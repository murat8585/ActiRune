#!/usr/bin/env python3
"""Fail when production artwork screens expose callbacks that MainShell leaves dead.

This is intentionally a small source-level guard, not a Dart parser. It checks
constructor callback contracts for the production screens MainShell owns and
makes missing wiring visible in CI before an APK is produced.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAIN_SHELL = ROOT / "lib" / "app" / "main_shell.dart"

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

CALLBACK_DECL = re.compile(
    r"final\s+(?:VoidCallback|ValueChanged<[^>]+>)\?\s+(on[A-Za-z0-9_]+)\s*;"
)


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


def main() -> int:
    main_shell = MAIN_SHELL.read_text(encoding="utf-8")
    failures: list[str] = []
    rows: list[tuple[str, str, str]] = []

    for class_name, relative_path in SCREENS.items():
        screen_source = (ROOT / relative_path).read_text(encoding="utf-8")
        callbacks = sorted(set(CALLBACK_DECL.findall(screen_source)))
        try:
            call = extract_call(main_shell, class_name)
        except ValueError as error:
            failures.append(str(error))
            continue

        for callback in callbacks:
            if (class_name, callback) in ALLOW_MISSING:
                rows.append((class_name, callback, "LOCAL_OWNER"))
                continue
            connected = re.search(rf"\b{re.escape(callback)}\s*:", call) is not None
            status = "CONNECTED" if connected else "MISSING"
            rows.append((class_name, callback, status))
            if not connected:
                failures.append(f"{class_name}.{callback} is not wired in MainShell")

    forbidden = {
        "Hero character story must not route to QuestChain":
            r"onCharacterStory\s*:\s*\(\)\s*=>\s*_openQuestChain",
    }
    for label, pattern in forbidden.items():
        if re.search(pattern, main_shell):
            failures.append(label)

    print("SCREEN|CALLBACK|STATUS")
    for row in rows:
        print("|".join(row))

    if failures:
        print("\nINTERACTION AUDIT: FAIL", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1

    print(f"\nINTERACTION AUDIT: PASS ({len(rows)} callback contracts checked)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
