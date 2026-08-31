---
name: add-pantomime-image
description: Add a new pantomime prompt image end-to-end (asset registration, repository entry, localized prompt strings). Use when adding a new image/word to the pantomime deck.
---

# Add a new pantomime image

Adding one new image/word to the deck currently requires four
coordinated edits. This skill exists so none of them get missed.

## 1. Get the inputs

- The image file, already saved at
  `assets/images/pants/<name>.webp` (ask the user to provide it if it
  doesn't exist yet — this skill does not generate images).
- The German prompt text (the source/template locale).
- The English prompt text.

`<name>` must be `snake_case` and match the asset filename without
the extension — this becomes the `promptId`.

## 2. Register the asset

Add `- assets/images/pants/<name>.webp` to the `assets:` list in
`pubspec.yaml`, keeping the existing alphabetical-ish placement
consistent with neighboring entries (see
`tools/printFiles.sh` if you need to regenerate the whole list).

## 3. Add the repository entry

In `lib/core/data/image_meta_info_repository.dart`, add
`_imageMetaInfo('assets/images/pants/<name>.webp'),` to the list
returned by `getAllImageMetaInfo()`. The `promptId` is derived
automatically from the filename — no extra argument needed.

## 4. Add the localized strings

Add a `prompt<PascalCaseName>` key with its German text to
`lib/l10n/app_de.arb` and the same key with English text to
`lib/l10n/app_en.arb`, alongside the existing `prompt*` entries.

## 5. Wire the prompt lookup

In `lib/l10n/l10n.dart`, inside `AppLocalizationsX.pantomimePrompt()`,
add `'<name>' => prompt<PascalCaseName>,` as a new case, before the
`_ => promptId` fallback.

## 6. Regenerate and verify

Run `flutter gen-l10n` to refresh `lib/l10n/generated/`, then
`flutter analyze` to confirm nothing is broken. Report the exact four
files touched (`pubspec.yaml`, `image_meta_info_repository.dart`,
both `.arb` files, `l10n.dart`) plus the regenerated files. Do not
commit unless explicitly asked to.
