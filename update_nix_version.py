#!/usr/bin/env python3
"""Update version + sha256 in assets/glf/pkgs/default.nix from src/version.py.

Usage:
    python update_nix_version.py
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent
VERSION_FILE = ROOT_DIR / "src" / "version.py"
GET_SHA256_SCRIPT = ROOT_DIR / "getGlfSha256.sh"
NIX_FILE = ROOT_DIR / "assets" / "glf" / "pkgs" / "default.nix"


def get_version() -> str:
    content = VERSION_FILE.read_text(encoding="utf-8")
    match = re.search(r'VERSION\s*=\s*"([^"]+)"', content)
    if not match:
        sys.exit(f"Could not find VERSION in {VERSION_FILE}")
    return match.group(1)


def getGlfSha256(version: str) -> str:
    result = subprocess.run(
        ["bash", str(GET_SHA256_SCRIPT), version],
        cwd=ROOT_DIR,
        capture_output=True,
        text=True,
    )
    output = result.stdout + result.stderr
    if result.returncode != 0:
        sys.exit(f"getGlfSha256.sh failed for version {version}:\n{output}")

    match = re.search(r"hash '(sha256-[^']+)'", output)
    if not match:
        sys.exit(f"Could not find sha256 hash in output:\n{output}")
    return match.group(1)


def update_nix_file(version: str, sha256: str) -> None:
    content = NIX_FILE.read_text(encoding="utf-8")

    new_content, version_count = re.subn(
        r'(version\s*=\s*")[^"]+(")', rf"\g<1>{version}\g<2>", content, count=1
    )
    if version_count == 0:
        sys.exit(f"Could not find version field in {NIX_FILE}")

    new_content, sha256_count = re.subn(
        r'(sha256\s*=\s*")[^"]+(")', rf"\g<1>{sha256}\g<2>", new_content, count=1
    )
    if sha256_count == 0:
        sys.exit(f"Could not find sha256 field in {NIX_FILE}")

    NIX_FILE.write_text(new_content, encoding="utf-8")


def main() -> None:
    version = get_version()
    print(f"Version: {version}")

    sha256 = getGlfSha256(version)
    print(f"sha256: {sha256}")

    update_nix_file(version, sha256)
    print(f"Updated {NIX_FILE}")


if __name__ == "__main__":
    main()
