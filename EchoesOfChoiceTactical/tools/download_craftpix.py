#!/usr/bin/env python3
"""
Download CraftPix asset packs using browser cookies.

Usage (pick one):

  A) Cookie name=value pairs (simplest):
     python download_craftpix.py --cookie "wordpress_logged_in_abc=VALUE"
     python download_craftpix.py --cookie "name1=val1" --cookie "name2=val2"

  B) Netscape cookies.txt file:
     python download_craftpix.py --cookies-file craftpix_cookies.txt

  C) Auto-detect file at tools/craftpix_cookies.txt:
     python download_craftpix.py

The script downloads all packs from the PACKS list below,
saving and extracting them into assets/art/{category}/.
"""

import argparse
import http.cookiejar
import os
import re
import sys
import time
import zipfile
from pathlib import Path

import requests
from bs4 import BeautifulSoup

# Force UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_DIR = SCRIPT_DIR.parent
ASSETS_DIR = PROJECT_DIR / "assets" / "art"
COOKIES_FILE = SCRIPT_DIR / "craftpix_cookies.txt"

BASE_URL = "https://craftpix.net"
HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/120.0.0.0 Safari/537.36"
    ),
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Referer": "https://craftpix.net/",
}

# Each pack: (category_folder, subfolder, product_url)
# category_folder maps to assets/art/{category_folder}/{subfolder}/
PACKS = [
    # --- Characters: Player Archetypes ---
    ("sprites/characters", "swordsman_1_3",
     "/freebies/free-swordsman-1-3-level-pixel-top-down-sprite-character-pack/"),
    ("sprites/characters", "swordsman_4_6",
     "/product/swordsman-level-4-6-pixel-character-top-down-sprite-pack/"),
    ("sprites/characters", "swordsman_7_9",
     "/product/swordsman-7-9-level-pixel-top-down-sprite-character-pack/"),
    ("sprites/characters", "base_male",
     "/freebies/free-base-4-direction-male-character-pixel-art/"),
    ("sprites/characters", "base_female",
     "/freebies/free-base-4-direction-female-character-pixel-art/"),
    ("sprites/characters", "bandit",
     "/freebies/free-medieval-bandit-4-direction-character-pack/"),
    ("sprites/characters", "vampire",
     "/freebies/free-vampire-4-direction-pixel-character-sprite-pack/"),
    ("sprites/characters", "roguelike_kit",
     "/freebies/free-top-down-roguelike-game-kit-pixel-art/"),
    ("sprites/characters", "wizard_male",
     "/product/wizard-4-direction-characters/"),
    ("sprites/characters", "wizard_female",
     "/product/wizard-4-direction-woman-character-sprites/"),
    ("sprites/characters", "archer",
     "/product/archer-4-direction-character-sprites/"),
    ("sprites/characters", "warrior_pack",
     "/product/warrior-4-direction-character-sprites/"),
    ("sprites/characters", "warrior_free",
     "/freebies/free-warrior-4-direction-character-sprites/"),

    # --- Characters: NPCs ---
    ("sprites/npcs", "citizen_artist_astrologer",
     "/freebies/free-citizen-artist-astrologer-4-direction-npc-character-pack/"),

    # --- Characters: Enemies ---
    ("sprites/enemies", "slime_mobs",
     "/freebies/free-slime-mobs-pixel-art-top-down-sprite-pack/"),
    ("sprites/enemies", "slime_enemies",
     "/product/pixel-art-slime-enemies-top-down-sprite-pack/"),
    ("sprites/enemies", "slime_boss",
     "/product/slime-boss-pixel-art-2d-sprite-for-roguelike-games/"),
    ("sprites/enemies", "skeleton",
     "/product/top-down-pixel-skeletons-character-sprite-pack/"),
    ("sprites/enemies", "goblin",
     "/product/goblin-pixel-art-character-sprite-pack/"),
    ("sprites/enemies", "zombie",
     "/product/zombie-4-direction-pixel-character-sprite-pack/"),
    ("sprites/enemies", "golem",
     "/product/golem-pixel-art-top-down-sprite-pack/"),
    ("sprites/enemies", "lich",
     "/product/top-down-pixel-lich-character-sprites/"),
    ("sprites/enemies", "gnolls",
     "/product/top-down-pixel-gnolls-character-pack/"),
    ("sprites/enemies", "lizardmen",
     "/product/lizardmen-pixel-art-character-sprite-pack/"),
    ("sprites/enemies", "demons",
     "/product/demons-4-direction-pixel-character-sprite-pack/"),
    ("sprites/enemies", "ghost",
     "/product/top-down-pixel-ghost-character-sprite-pack/"),
    ("sprites/enemies", "imp",
     "/product/imp-mobs-pixel-art-character-sprite-pack/"),
    ("sprites/enemies", "beholder",
     "/product/beholder-monsters-top-down-pixel-art-sprites/"),
    ("sprites/enemies", "giant_rat",
     "/product/giant-rat-4-direction-pixel-character-sprite-pack/"),
    ("sprites/enemies", "ent",
     "/product/top-down-pixel-ent-character-sprites/"),
    ("sprites/enemies", "mushroom",
     "/product/top-down-pixel-mushroom-sprite-pack/"),
    ("sprites/enemies", "orc",
     "/freebies/free-top-down-orc-game-character-pixel-art/"),
    ("sprites/enemies", "predator_plant",
     "/freebies/free-predator-plant-mobs-pixel-art-pack/"),
    ("sprites/enemies", "boss_characters",
     "/freebies/free-top-down-boss-character-4-direction-pack/"),

    # --- Tilesets: Battle Environments ---
    ("tilesets/battle", "grassland",
     "/product/grassland-top-down-tileset-pixel-art/"),
    ("tilesets/battle", "forest",
     "/product/forest-top-down-tileset-pixel-art/"),
    ("tilesets/battle", "cave",
     "/product/cave-tileset-top-down-pixel-art/"),
    ("tilesets/battle", "rocky",
     "/product/rocky-top-down-tileset-pixel-art-for-rpg/"),
    ("tilesets/battle", "dungeon_free",
     "/freebies/free-2d-top-down-pixel-dungeon-asset-pack/"),
    ("tilesets/battle", "dungeon_premium",
     "/product/dungeon-tileset-pixel-top-down-for-indie-game/"),
    ("tilesets/battle", "undead",
     "/freebies/free-undead-tileset-top-down-pixel-art/"),
    ("tilesets/battle", "cursed_land",
     "/freebies/free-cursed-land-top-down-pixel-art-tileset/"),
    ("tilesets/battle", "tavern",
     "/product/tavern-top-down-pixel-rpg-asset-pack/"),
    ("tilesets/battle", "swamp",
     "/product/swamp-top-down-tileset-pixel-art/"),
    ("tilesets/battle", "desert",
     "/product/desert-tileset-top-down-pixel-art/"),
    ("tilesets/battle", "mage_tower",
     "/product/mage-tower-top-down-pixel-art-asset-pack/"),
    ("tilesets/battle", "glowing_cave",
     "/product/glowing-cave-top-down-tileset-2d-pixel-art/"),
    ("tilesets/battle", "winter",
     "/product/winter-top-down-pixel-art-tileset-for-rpg/"),
    ("tilesets/battle", "guild_hall",
     "/freebies/free-top-down-pixel-art-guild-hall-asset-pack/"),

    # --- Tilesets: Overworld & Objects ---
    ("tilesets/overworld", "path_road",
     "/product/path-and-road-top-down-tileset-pixel-art/"),
    ("objects", "trees",
     "/freebies/free-top-down-trees-pixel-art/"),
    ("objects", "bushes",
     "/freebies/free-top-down-bushes-pixel-art/"),
    ("objects", "rocks_stones",
     "/freebies/free-rocks-and-stones-top-down-pixel-art/"),
    ("objects", "ruins",
     "/freebies/free-top-down-ruins-pixel-art/"),
    ("objects", "crystals",
     "/freebies/top-down-crystals-pixel-art/"),
    ("objects", "forest_objects",
     "/freebies/free-forest-objects-top-down-pixel-art/"),
    ("objects", "rocky_objects",
     "/freebies/free-rocky-area-objects-pixel-art/"),
    ("objects", "cave_objects",
     "/freebies/free-top-down-pixel-art-cave-objects/"),
    ("objects", "dungeon_props",
     "/freebies/free-pixel-dungeon-props-and-objects-asset-pack/"),
    ("objects", "bridges",
     "/freebies/free-bridges-top-down-pixel-art-asset-pack/"),

    # --- GUI & Icons ---
    ("gui", "rpg_ui",
     "/freebies/free-basic-pixel-art-ui-for-rpg/"),
    ("icons", "armor_weapons",
     "/product/armor-and-weapons-pixel-rpg-icons/"),
    ("icons", "magic_objects",
     "/product/magic-objects-and-icons-pixel-art-pack/"),
    ("icons", "treasure",
     "/product/treasure-32x32-objects-and-icons-pixel-pack/"),
    ("sprites/npcs", "market_square",
     "/product/pixel-art-market-square-rpg-shop-and-npc-assets-pack/"),
]


def create_session(cookie_pairs: list[str] | None = None,
                    cookies_file: Path | None = None) -> requests.Session:
    """Create an authenticated requests Session."""
    session = requests.Session()
    session.headers.update(HEADERS)

    if cookie_pairs:
        for pair in cookie_pairs:
            if "=" not in pair:
                print(f"WARNING: Skipping malformed cookie (no '='): {pair}")
                continue
            name, value = pair.split("=", 1)
            session.cookies.set(name.strip(), value.strip(), domain=".craftpix.net")
    elif cookies_file and cookies_file.exists():
        cj = http.cookiejar.MozillaCookieJar()
        cj.load(str(cookies_file), ignore_discard=True, ignore_expires=True)
        session.cookies = cj
    else:
        return None  # type: ignore[return-value]

    return session


def get_product_id(session: requests.Session, product_url: str) -> str | None:
    """Fetch a product page and extract the product ID.

    Looks for:
    1. data-product-id attribute
    2. /download/{id}/ links
    3. Product ID in page source
    """
    url = BASE_URL + product_url
    resp = session.get(url, timeout=30)
    resp.raise_for_status()

    soup = BeautifulSoup(resp.text, "html.parser")

    # Method 1: Look for /download/{id}/ links (works for freebies)
    for a_tag in soup.find_all("a", href=True):
        href = a_tag["href"]
        m = re.search(r"/download/(\d+)/?", href)
        if m:
            return m.group(1)

    # Method 2: Look for data-product-id attribute
    for elem in soup.find_all(attrs={"data-product-id": True}):
        return elem["data-product-id"]

    # Method 3: Search the raw HTML for product ID patterns
    # CraftPix embeds product_id in various places
    m = re.search(r'"product_id"\s*:\s*"?(\d+)"?', resp.text)
    if m:
        return m.group(1)

    m = re.search(r'data-product-id="(\d+)"', resp.text)
    if m:
        return m.group(1)

    # Method 4: Look in WooCommerce add-to-cart forms
    for form_input in soup.find_all("input", attrs={"name": "add-to-cart"}):
        val = form_input.get("value", "")
        if val.isdigit():
            return val

    return None


def resolve_zip_url(session: requests.Session, product_id: str) -> str | None:
    """Visit the /download/{id}/ page and extract the files.craftpix.net ZIP URL."""
    download_page_url = f"{BASE_URL}/download/{product_id}/"
    resp = session.get(download_page_url, timeout=30)
    resp.raise_for_status()

    soup = BeautifulSoup(resp.text, "html.parser")

    # Look for files.craftpix.net links (the actual ZIP)
    for a_tag in soup.find_all("a", href=True):
        href = a_tag["href"]
        if "files.craftpix.net" in href and ".zip" in href.lower():
            return href

    # Fallback: search raw HTML for files.craftpix.net URLs
    m = re.search(r'https?://files\.craftpix\.net/[^\s"\'<>]+\.zip', resp.text)
    if m:
        return m.group(0)

    return None


def download_file(session: requests.Session, url: str, dest_path: Path) -> bool:
    """Download a file from URL. Returns True on success."""
    try:
        resp = session.get(url, stream=True, timeout=120, allow_redirects=True)
        resp.raise_for_status()

        content_type = resp.headers.get("Content-Type", "")
        if "text/html" in content_type:
            print("  WARNING: Got HTML instead of a file")
            return False

        dest_path.parent.mkdir(parents=True, exist_ok=True)
        with open(dest_path, "wb") as f:
            for chunk in resp.iter_content(chunk_size=8192):
                f.write(chunk)
        return True
    except requests.RequestException as e:
        print(f"  ERROR downloading: {e}")
        return False


def extract_zip(zip_path: Path, extract_to: Path) -> bool:
    """Extract a ZIP file and return True on success."""
    try:
        with zipfile.ZipFile(zip_path, "r") as zf:
            zf.extractall(extract_to)
        return True
    except (zipfile.BadZipFile, Exception) as e:
        print(f"  ERROR extracting: {e}")
        return False


def main() -> None:
    parser = argparse.ArgumentParser(description="Download CraftPix asset packs.")
    parser.add_argument(
        "--cookie", action="append", metavar="NAME=VALUE",
        help="Cookie as name=value (repeat for multiple cookies)")
    parser.add_argument(
        "--cookies-file", type=Path, default=None,
        help="Path to Netscape-format cookies.txt file")
    parser.add_argument(
        "--only", type=str, default=None,
        help="Only download packs matching this subfolder name")
    parser.add_argument(
        "--start", type=int, default=1,
        help="Start from pack number N (1-indexed)")
    args = parser.parse_args()

    # Resolve cookie source
    session = None
    if args.cookie:
        print(f"Using {len(args.cookie)} cookie(s) from --cookie flags...")
        session = create_session(cookie_pairs=args.cookie)
    elif args.cookies_file:
        print(f"Loading cookies from {args.cookies_file}...")
        session = create_session(cookies_file=args.cookies_file)
    elif COOKIES_FILE.exists():
        print(f"Loading cookies from {COOKIES_FILE}...")
        session = create_session(cookies_file=COOKIES_FILE)

    if session is None:
        print("ERROR: No cookies provided.")
        print()
        print("Usage (pick one):")
        print()
        print('  A) --cookie flag (simplest):')
        print('     python download_craftpix.py --cookie "wordpress_logged_in_abc=VALUE"')
        print()
        print("  B) --cookies-file (Netscape format):")
        print("     python download_craftpix.py --cookies-file craftpix_cookies.txt")
        print()
        print(f"  C) Auto-detect file at: {COOKIES_FILE}")
        sys.exit(1)

    # Verify auth
    print("Verifying authentication...")
    test_resp = session.get(BASE_URL + "/my-account/", timeout=30)
    page_text = test_resp.text.lower()
    if "sign in" in page_text and "my-account" not in page_text:
        print("WARNING: May not be fully authenticated.")
        print("  Premium downloads may fail. Freebies should still work.")
    else:
        print("Authentication OK!")
    print()

    success_count = 0
    skip_count = 0
    fail_count = 0

    for i, (category, subfolder, product_url) in enumerate(PACKS, 1):
        if i < args.start:
            continue
        if args.only and args.only != subfolder:
            continue

        dest_dir = ASSETS_DIR / category / subfolder
        zip_path = dest_dir.with_suffix(".zip")

        # Skip if already downloaded and extracted
        if dest_dir.exists() and any(dest_dir.iterdir()):
            print(f"[{i}/{len(PACKS)}] SKIP (exists): {category}/{subfolder}")
            skip_count += 1
            continue

        print(f"[{i}/{len(PACKS)}] {category}/{subfolder}")
        print(f"  Page: {product_url}")

        # Step 1: Get the product ID from the product page
        product_id = get_product_id(session, product_url)
        if not product_id:
            print("  FAIL: Could not find product ID on page")
            fail_count += 1
            continue

        print(f"  Product ID: {product_id}")

        # Step 2: Visit the download page and get the real ZIP URL
        zip_url = resolve_zip_url(session, product_id)
        if not zip_url:
            print("  FAIL: Could not find ZIP URL on download page")
            print("  (This pack may require premium membership)")
            fail_count += 1
            continue

        print(f"  ZIP URL: {zip_url}")

        # Step 3: Download the actual ZIP file
        if not download_file(session, zip_url, zip_path):
            print("  FAIL: Download failed")
            fail_count += 1
            continue

        file_size = zip_path.stat().st_size
        print(f"  Downloaded: {file_size / 1024:.0f} KB")

        # Check if it's actually a ZIP
        if file_size < 100:
            print("  FAIL: File too small, likely not a real download")
            zip_path.unlink(missing_ok=True)
            fail_count += 1
            continue

        # Step 4: Extract
        dest_dir.mkdir(parents=True, exist_ok=True)
        if extract_zip(zip_path, dest_dir):
            print(f"  OK -> {dest_dir}")
            zip_path.unlink(missing_ok=True)
            success_count += 1
        else:
            print("  FAIL: Extraction failed")
            fail_count += 1

        # Small delay to be polite to the server
        time.sleep(1)

    print()
    print("=" * 50)
    print(f"Done! Success: {success_count}, Skipped: {skip_count}, Failed: {fail_count}")
    print(f"Assets saved to: {ASSETS_DIR}")

    if fail_count > 0:
        print()
        print("Some downloads failed. This may be due to:")
        print("  - Expired cookies (re-export and try again)")
        print("  - Premium pack without membership access")
        print("  - Pack URL changed (check craftpix.net manually)")
        print("  - Network issues (try again)")


if __name__ == "__main__":
    main()
