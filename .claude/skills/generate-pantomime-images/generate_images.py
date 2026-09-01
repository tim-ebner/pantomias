#!/usr/bin/env python3
"""Generate pantomime prompt images via the OpenAI Images API.

Not part of the Flutter app itself — a helper invoked by the
`generate-pantomime-images` skill from a scratch directory. Produces one
ready-to-use .webp per word, matching the existing asset style: tight crop
around the subject, transparent background, small file size.

Usage:
    python3 generate_images.py octopus="a cute octopus" kangaroo="a cute kangaroo" ...

Each positional arg is "<snake_case_name>=<short subject description>".
The subject description gets the shared style suffix appended automatically
— do not repeat style words (cartoon, outline, colors, ...) in it.

Env:
    OPENAI_API_KEY must be set (see the skill's step about sourcing the
    user's shell profile — a fresh Bash tool invocation does not inherit it
    automatically).
"""
import argparse
import base64
import os
import sys
from pathlib import Path

import requests
from PIL import Image

STYLE_SUFFIX = (
    ", cute cartoon sticker illustration, thick bold black outline, "
    "flat cel-shaded colors, simple friendly kawaii children's-book style, "
    "single centered subject, transparent background, no text, no shadow, "
    "no gradient background, inanimate objects and items are drawn plainly "
    "with no face and no eyes — only living subjects (people, animals, "
    "fantasy/humanoid characters) get a cute face; when depicting a human "
    "character whose gender isn't specified in the subject description, "
    "use a gender-neutral/ambiguous design rather than defaulting to male"
)

TARGET_MAX_PX = 350  # matches the typical longer-side size of existing assets
WEBP_QUALITY = 90


def parse_words(args: list[str]) -> dict[str, str]:
    words = {}
    for arg in args:
        if "=" not in arg:
            sys.exit(f"bad argument (expected name=\"subject\"): {arg}")
        name, subject = arg.split("=", 1)
        words[name] = subject
    return words


def generate_raw(name: str, subject: str, api_key: str, out_dir: Path, model: str, quality: str) -> Path:
    out_path = out_dir / f"{name}.png"
    if out_path.exists():
        print(f"skip (already generated): {name}")
        return out_path
    prompt = subject + STYLE_SUFFIX
    resp = requests.post(
        "https://api.openai.com/v1/images/generations",
        headers={"Authorization": f"Bearer {api_key}"},
        json={
            "model": model,
            "prompt": prompt,
            "size": "1024x1024",
            "quality": quality,
            "background": "transparent",
            "n": 1,
        },
        timeout=180,
    )
    resp.raise_for_status()
    data = resp.json()["data"][0]
    out_path.write_bytes(base64.b64decode(data["b64_json"]))
    print(f"generated: {name} -> {out_path}")
    return out_path


def crop_resize_export(name: str, raw_path: Path, webp_dir: Path) -> Path:
    img = Image.open(raw_path).convert("RGBA")
    bbox = img.getbbox()
    if bbox is not None:
        pad = 8
        left, top, right, bottom = bbox
        left = max(0, left - pad)
        top = max(0, top - pad)
        right = min(img.width, right + pad)
        bottom = min(img.height, bottom + pad)
        img = img.crop((left, top, right, bottom))

    w, h = img.size
    scale = TARGET_MAX_PX / max(w, h)
    new_size = (max(1, round(w * scale)), max(1, round(h * scale)))
    img = img.resize(new_size, Image.LANCZOS)

    out_path = webp_dir / f"{name}.webp"
    img.save(out_path, "WEBP", quality=WEBP_QUALITY, method=6)
    kb = out_path.stat().st_size / 1024
    print(f"exported: {name} -> {new_size[0]}x{new_size[1]}, {kb:.0f} KB")
    return out_path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("words", nargs="+", help='name="subject description" pairs')
    parser.add_argument("--out-dir", default=".", help="scratch directory to write raw/ and webp/ into")
    parser.add_argument(
        "--model",
        default="gpt-image-1-mini",
        help="OpenAI image model. Default gpt-image-1-mini — much cheaper than gpt-image-1 "
        "for this cute-sticker style, which does not need the flagship model's fidelity.",
    )
    parser.add_argument(
        "--quality",
        default="medium",
        choices=["low", "medium", "high", "auto"],
        help="Default medium — good balance of cost and legibility for this art style.",
    )
    args = parser.parse_args()

    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        sys.exit("OPENAI_API_KEY not set in environment")

    out_dir = Path(args.out_dir)
    raw_dir = out_dir / "raw"
    webp_dir = out_dir / "webp"
    raw_dir.mkdir(parents=True, exist_ok=True)
    webp_dir.mkdir(parents=True, exist_ok=True)

    for name, subject in parse_words(args.words).items():
        raw_path = generate_raw(name, subject, api_key, raw_dir, args.model, args.quality)
        crop_resize_export(name, raw_path, webp_dir)


if __name__ == "__main__":
    main()
