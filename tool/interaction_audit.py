#!/usr/bin/env python3
"""Audit ActiRune production interaction ownership and screen reachability.

This is intentionally a source-level CI guard, not a Dart parser. It combines:
1. callback-contract checks for artwork screens owned by MainShell,
2. a complete inventory of every lib/features/**/*_screen.dart file,
3. production/onboarding/Battle reachability assertions,
4. test-reference evidence for every reachable or externally blocked screen,
5. fail-closed checks that prevent Battle from silently swallowing owner actions.

The machine-readable classification lives in
validation/interactions/screen_reachability.json. Adding or deleting a screen
without classifying it makes this audit fail.
"""

from __future__ import annotations

import json
import re
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAIN_SHELL = ROOT / "lib" / "app" / "main_shell.dart"
APP_ROOT = ROOT / "lib" / "app" / "actirune_app.dart"
ONBOARDING = ROOT / "lib" / "features" / "onboarding" / "onboarding_screen.dart"
BATTLE_FLOW_HOST = ROOT / "lib" / "features" / "battle" / "battle_flow_host.dart"
BATTLE_SCREEN = ROOT / "lib" / "features" / "battle" / "battle_screen.dart"
MATRIX = ROOT / "validation" / "interactions" / "screen_reachability.json"

SCREENS = {
    "HomeScreen": "lib/features/home/home_screen.dart",
    "AdventureScreen": "lib/features/adventure/adventure_screen.dart",
    "HeroScreen": "lib/features/hero/hero_screen.dart",
    "ProfileScreen": "lib/features/profile/profile_screen.dart",
    "DailySummaryPopup": "lib/features/home/daily_summary_popup.dart",
    "EventDetailPopup": "lib/features/home/event_detail_popup.dart",
    "DailyQuestsScreen": "lib/features/quests/daily_quests_screen.dart",
    "WeeklyQuestsScreen": "lib/features/quests/weekly_quests_screen.dart",
    "QuestChainScreen": "lib/features/quests/quest_chain_screen.dart",
    "EventsScreen": "lib/features/home/events_screen.dart",
    "WorldProgressionScreen": "lib/features/adventure/world_progression_screen.dart",
    "RuneShrineReadyScreen": "lib/features/home/rune_shrine_ready_screen.dart",
    "InventoryScreen": "lib/features/hero/inventory_screen.dart",
    "EquipmentScreen": "lib/features/hero/equipment_screen.dart",
    "LumiScreen": "lib/features/hero/lumi_screen.dart",
    "MovementMasteryScreen": "lib/features/hero/movement_mastery_screen.dart",
    "PlayerLevelScreen": "lib/features/profile/player_level_screen.dart",
    "AchievementsScreen": "lib/features/profile/achievements_screen.dart",
    "ProfileHistoryScreen": "lib/features/profile/profile_history_screen.dart",
    "SettingsAccountScreen": "lib/features/profile/settings_account_screen.dart",
    "SettingsNotificationsScreen": "lib/features/profile/settings_notifications_screen.dart",
    "SettingsPrivacyScreen": "lib/features/profile/settings_privacy_screen.dart",
    "SettingsPermissionsScreen": "lib/features/profile/settings_permissions_screen.dart",
    "SettingsAccessibilityScreen": "lib/features/profile/settings_accessibility_screen.dart",
    "SettingsHubScreen": "lib/features/profile/settings_hub_screen.dart",
    "ShopScreen": "lib/features/shop/shop_screen.dart",
    "ProPaywallScreen": "lib/features/shop/pro_paywall_screen.dart",
}

# These callbacks are optional observers; the screen has authoritative local
# behavior even when the owner does not subscribe.
ALLOW_MISSING = {
    ("AchievementsScreen", "onFilterChanged"),
}

ALLOWED_STATUSES = {
    "production_route",
    "onboarding_route",
    "external_blocker",
    "authority_blocked",
    "legacy_unrouted",
}

CALLBACK_DECL = re.compile(
    r"final\s+(?:VoidCallback|ValueChanged<[^>]+>)\?\s+(on[A-Za-z0-9_]+)\s*;"
)


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def class_token_present(source: str, class_name: str) -> bool:
    return re.search(rf"\b{re.escape(class_name)}\b", source) is not None


def class_constructed(source: str, class_name: str) -> bool:
    return re.search(rf"\b{re.escape(class_name)}\s*\(", source) is not None


def extract_call(source: str, class_name: str) -> str:
    needle = class_name + "("
    start = source.find(needle)
    if start < 0:
        raise ValueError(f"{class_name} production instantiation not found")
    pos = start + len(class_name)
    depth = 0
    in_string: str | None = None
    escaped = False
    for index in range(pos, len(source)):
        char = source[index]
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == in_string:
                in_string = None
            continue
        if char in ("'", '"'):
            in_string = char
            continue
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0:
                return source[start : index + 1]
    raise ValueError(f"{class_name} constructor call is not balanced")


def load_matrix(failures: list[str]) -> list[dict[str, str]]:
    try:
        payload = json.loads(read(MATRIX))
    except (OSError, json.JSONDecodeError) as error:
        failures.append(f"screen reachability matrix cannot be read: {error}")
        return []

    if payload.get("schema_version") != 1:
        failures.append("screen reachability matrix schema_version must be 1")

    rows = payload.get("screens")
    if not isinstance(rows, list):
        failures.append("screen reachability matrix screens must be a list")
        return []

    normalized: list[dict[str, str]] = []
    seen_paths: set[str] = set()
    seen_classes: set[str] = set()
    for index, row in enumerate(rows):
        if not isinstance(row, dict):
            failures.append(f"matrix row {index} is not an object")
            continue
        path = row.get("path")
        class_name = row.get("class")
        status = row.get("status")
        owner = row.get("owner")
        if not all(isinstance(value, str) and value for value in (path, class_name, status, owner)):
            failures.append(f"matrix row {index} is missing path/class/status/owner")
            continue
        if status not in ALLOWED_STATUSES:
            failures.append(f"{path} has unsupported status {status}")
        if path in seen_paths:
            failures.append(f"duplicate screen path in matrix: {path}")
        if class_name in seen_classes:
            failures.append(f"duplicate screen class in matrix: {class_name}")
        seen_paths.add(path)
        seen_classes.add(class_name)
        normalized.append(row)

    return normalized


def audit_screen_inventory(
    failures: list[str],
    rows: list[dict[str, str]],
    main_shell: str,
    app_root: str,
    onboarding: str,
    battle_flow_host: str,
    battle_screen: str,
) -> None:
    discovered = {
        path.relative_to(ROOT).as_posix()
        for path in ROOT.glob("lib/features/**/*_screen.dart")
    }
    classified = {row["path"] for row in rows}

    for path in sorted(discovered - classified):
        failures.append(f"unclassified screen file: {path}")
    for path in sorted(classified - discovered):
        failures.append(f"classified screen file does not exist: {path}")

    test_corpus = "\n".join(read(path) for path in ROOT.glob("test/**/*.dart"))
    production_sources = "\n".join((main_shell, app_root, onboarding))
    battle_sources = "\n".join((battle_flow_host, battle_screen))

    print("\nSCREEN_REACHABILITY")
    print("SCREEN|STATUS|OWNER|TEST_REFERENCE|QUALITY")
    for row in sorted(rows, key=lambda item: item["path"]):
        path = row["path"]
        class_name = row["class"]
        status = row["status"]
        owner = row["owner"]
        quality = row.get("quality", "canonical_or_structural")

        source_path = ROOT / path
        if source_path.exists():
            source = read(source_path)
            if re.search(rf"\bclass\s+{re.escape(class_name)}\b", source) is None:
                failures.append(f"{path} does not declare expected class {class_name}")

        tested = class_token_present(test_corpus, class_name)
        print(
            f"{class_name}|{status}|{owner}|"
            f"{'YES' if tested else 'NO'}|{quality}"
        )

        if status in {"production_route", "onboarding_route", "external_blocker"} and not tested:
            failures.append(f"{class_name} has no test reference")

        if status == "production_route":
            if owner != "main_shell":
                failures.append(f"{class_name} production_route owner must be main_shell")
            if not class_constructed(main_shell, class_name):
                failures.append(f"{class_name} is classified production_route but MainShell does not construct it")
        elif status == "onboarding_route":
            expected_owner_source = app_root if owner == "actirune_app" else onboarding
            if not class_constructed(expected_owner_source, class_name):
                failures.append(
                    f"{class_name} onboarding owner {owner} does not construct the screen"
                )
        elif status == "external_blocker":
            if class_name != "BattleScreen" and not class_constructed(battle_sources, class_name):
                failures.append(f"{class_name} is not owned by the Battle adapter/host")
            if class_constructed(production_sources, class_name):
                failures.append(f"{class_name} must stay out of production roots until encounter authority exists")
        elif status in {"authority_blocked", "legacy_unrouted"}:
            if class_constructed(production_sources, class_name):
                failures.append(f"{class_name} is {status} but is constructed by a production root")

    counts = Counter(row["status"] for row in rows)
    print("\nSCREEN_COUNTS")
    for status in sorted(counts):
        print(f"{status}={counts[status]}")
    print(f"total={len(rows)}")


def audit_battle_fail_closed(
    failures: list[str], app_root: str, main_shell: str, battle_screen: str
) -> None:
    if "const MainShell()" not in app_root:
        failures.append("production /app route is no longer the canonical MainShell")
    if "battleRootBuilder:" in app_root:
        failures.append("production app must not inject a Battle builder before encounter authority")
    if "bool get _battleAvailable => widget.battleRootBuilder != null;" not in main_shell:
        failures.append("MainShell Battle availability gate is missing")
    if "Gerçek karşılaşma içeriği" not in main_shell:
        failures.append("MainShell Battle fail-closed explanation is missing")
    if "FeatureUnavailableDialog.show" not in battle_screen:
        failures.append("BattleScreen must provide visible fail-closed feedback for unowned actions")

    silent_forwarding = (
        "onBattlePrepInfo",
        "onEquipment",
        "onRunes",
        "onCompanion",
        "onAbilities",
        "onBattleTips",
        "onCameraPrepInfo",
        "onCameraRecheck",
        "onVictoryReplay",
        "onVictoryViewRewards",
        "onDefeatViewTactics",
    )
    for callback in silent_forwarding:
        pattern = rf"\b{callback}\s*:\s*widget\.{callback}\s*,"
        if re.search(pattern, battle_screen):
            failures.append(f"BattleScreen silently forwards nullable {callback}")

    if "if (request == null)" not in battle_screen or "Son Bir Şans" not in battle_screen:
        failures.append("Battle rewarded retry must visibly fail closed when no owner exists")


def main() -> int:
    main_shell = read(MAIN_SHELL)
    app_root = read(APP_ROOT)
    onboarding = read(ONBOARDING)
    battle_flow_host = read(BATTLE_FLOW_HOST)
    battle_screen = read(BATTLE_SCREEN)
    failures: list[str] = []
    callback_rows: list[tuple[str, str, str]] = []

    for class_name, relative_path in SCREENS.items():
        screen_source = read(ROOT / relative_path)
        callbacks = sorted(set(CALLBACK_DECL.findall(screen_source)))
        try:
            call = extract_call(main_shell, class_name)
        except ValueError as error:
            failures.append(str(error))
            continue

        for callback in callbacks:
            if (class_name, callback) in ALLOW_MISSING:
                callback_rows.append((class_name, callback, "LOCAL_OWNER"))
                continue
            connected = re.search(rf"\b{re.escape(callback)}\s*:", call) is not None
            status = "CONNECTED" if connected else "MISSING"
            callback_rows.append((class_name, callback, status))
            if not connected:
                failures.append(f"{class_name}.{callback} is not wired in MainShell")

    forbidden = {
        "Hero character story must not route to QuestChain":
            r"onCharacterStory\s*:\s*\(\)\s*=>\s*_openQuestChain",
    }
    for label, pattern in forbidden.items():
        if re.search(pattern, main_shell):
            failures.append(label)

    matrix_rows = load_matrix(failures)
    audit_screen_inventory(
        failures,
        matrix_rows,
        main_shell,
        app_root,
        onboarding,
        battle_flow_host,
        battle_screen,
    )
    audit_battle_fail_closed(failures, app_root, main_shell, battle_screen)

    print("SCREEN_CALLBACKS")
    print("SCREEN|CALLBACK|STATUS")
    for row in callback_rows:
        print("|".join(row))

    if failures:
        print("\nINTERACTION AUDIT: FAIL", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print(
        f"\nINTERACTION AUDIT: PASS "
        f"({len(callback_rows)} callback contracts; {len(matrix_rows)} screens classified)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
