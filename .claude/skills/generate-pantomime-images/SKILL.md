---
name: generate-pantomime-images
description: Batch-generate new pantomime prompt images via the OpenAI Images API in the app's existing cute-sticker art style, then wire each approved one into the app end-to-end. Use when the user wants several new pantomime images added at once, not just one.
---

# Generate and add pantomime images (batch)

This is the batch/AI-generation counterpart to the `add-pantomime-image`
skill: it produces the image files themselves via the OpenAI Images API,
then applies the same per-image app-integration steps to each approved
result. Use `add-pantomime-image` instead when the user already has a
specific image file to add one at a time.

Cost note: an earlier run using `gpt-image-1` at default quality was
noticeably expensive for 20 images. **Default to `gpt-image-1-mini` with
`quality=medium`** (already the script's defaults) — it's cheap and the
cute-sticker style doesn't need flagship fidelity. Only step up to
`gpt-image-1` / `high` quality if the user asks for it or medium quality
results look visibly worse.

## 1. Pick the words

- If the user gave a list, use it. Otherwise propose ~15-20 new words that
  extend the existing categories (animals, professions/fantasy characters,
  objects, gerund-form activities like `climbing`/`dancing`/`skiing`).
- Check against existing prompt IDs to avoid duplicates:
  `ls assets/images/pants/ | sed 's/\.webp$//' | sort`
- Each word becomes a `snake_case` `promptId`; write a short English
  subject description for the generation prompt (e.g. `octopus="a cute
  octopus"`, `firefighter="a cute firefighter character with a helmet"`).
  Keep the description to the subject only — the script appends the shared
  style suffix (outline, flat colors, transparent background, etc.)
  automatically, so don't repeat style words here.
- Inanimate objects (backpack, kettle, hammer, ...) should read as plain
  objects, not characters — the shared style suffix already tells the model
  not to give them a face/eyes, so just describe the object itself (e.g.
  `hammer="a cute hammer"`), don't add "character" or personify it.
- For human/professional/fantasy characters, don't let the batch default to
  all-male: vary gender explicitly across the words you pick, e.g.
  `doctor="a cute female doctor character with a stethoscope"`,
  `pilot="a cute male pilot character with an aviator cap"`, or omit gender
  entirely for a gender-neutral design. Look at the genders already implied
  by existing prompt strings in `app_de.arb`/`app_en.arb` before deciding
  which way to lean for a new word.

## 2. Make sure `OPENAI_API_KEY` is reachable

Each Bash tool call starts a fresh shell that does **not** automatically
source the user's `~/.zshrc` in this environment. If the key was set in the
user's interactive shell, prefix the check (and every later invocation of
the script) with `source ~/.zshrc 2>/dev/null;`:

```
source ~/.zshrc 2>/dev/null; env | grep -c OPENAI_API_KEY
```

Never print the key's value. If it's not set anywhere, ask the user to add
`export OPENAI_API_KEY="sk-..."` to their shell profile (they can run that
via a `!`-prefixed command so the value never enters the chat transcript).

## 3. Set up a throwaway Python environment in the scratch directory

The script needs `pillow` and `requests`; Homebrew's system Python is
externally managed, so use an isolated venv in the scratchpad instead of
touching the system install:

```
python3 -m venv "$SCRATCH/venv"
"$SCRATCH/venv/bin/pip" install --quiet pillow requests
```

## 4. Generate

Copy `generate_images.py` from this skill's directory into the scratch
directory (or run it in place with `--out-dir "$SCRATCH"`). Test with one
word first to confirm the API key and params work before spending on the
full batch:

```
"$SCRATCH/venv/bin/python" generate_images.py --out-dir "$SCRATCH" \
  octopus="a cute octopus"
```

Then run the rest (all words can go in one call; the script skips any
`raw/<name>.png` that already exists, so a partial re-run is cheap):

```
"$SCRATCH/venv/bin/python" generate_images.py --out-dir "$SCRATCH" \
  kangaroo="a cute kangaroo" koala="a cute koala" ...
```

This writes final, ready-to-use `.webp` files to `$SCRATCH/webp/<name>.webp`
— already cropped to content, resized to match the existing assets' scale
(~350px on the longer side), and compressed to a comparable file size
(typically well under 50 KB).

## 5. Show the results for approval before touching the repo

Build a labeled contact sheet (grid of thumbnails with filenames) from
`$SCRATCH/webp/*.webp` and send it with `SendUserFile`. AI-generated images
are not deterministic — expect the user to reject or want to re-roll a few.
Do not add anything to the app until the user confirms which ones to keep.
Drop rejected words from the batch; re-run step 4 for any the user wants
regenerated (same word, will produce a different result since nothing is
cached beyond the raw PNG already on disk — delete that PNG first to force
a fresh generation).

## 6. Integrate each approved image

For every approved `<name>.webp`, copy it to `assets/images/pants/<name>.webp`,
then apply the same four edits the `add-pantomime-image` skill documents,
once per image:

1. Add `- assets/images/pants/<name>.webp` to `pubspec.yaml`'s `assets:` list.
2. Add `_imageMetaInfo('assets/images/pants/<name>.webp'),` to
   `getAllImageMetaInfo()` in `lib/core/data/image_meta_info_repository.dart`.
3. Add a `prompt<PascalCaseName>` key (German text) to `lib/l10n/app_de.arb`
   and the same key (English text) to `lib/l10n/app_en.arb`.
4. Add `'<name>' => prompt<PascalCaseName>,` to the switch in
   `AppLocalizationsX.pantomimePrompt()` in `lib/l10n/l10n.dart`, before the
   `_ => promptId` fallback.

Batching these edits (one pass through each file covering every new word,
rather than repeating the whole file edit per word) is fine and faster.

## 7. Verify

```
flutter gen-l10n
flutter analyze
flutter test
```

All three must be clean before reporting success. Report the exact list of
words actually added (vs. proposed/rejected) and the files touched. Do not
commit unless explicitly asked to.
