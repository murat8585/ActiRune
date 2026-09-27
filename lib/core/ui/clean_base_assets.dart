/// Canonical clean-base asset selections for the first playable ActiRune flow.
///
/// These constants intentionally isolate routing/UI code from the current asset
/// filenames. When the visual authority package is normalized later, only this
/// mapping needs to change.
abstract final class CleanBaseAssets {
  static const root = 'assets/ui/clean_base_final_60';

  static const home = '$root/32__EARLY_QA_POS_25__PASS.png';
  static const questCenter = '$root/25__EARLY_QA_POS_13__PASS.png';
  static const dailyQuests = '$root/44__LATE_QA_POS_13__PASS.png';
  static const weeklyQuests = '$root/45__LATE_QA_POS_14__PASS.png';
  static const adventure = '$root/28__EARLY_QA_POS_21__PASS.png';
  static const battlePrep = '$root/46__LATE_QA_POS_15__PASS.png';
  static const cameraPrep = '$root/47__LATE_QA_POS_16__PASS.png';
  static const liveBattle = '$root/56__FINAL_FIX__LIVE_BATTLE__PASS.png';
  static const victory = '$root/48__LATE_QA_POS_18__PASS.png';
  static const defeat = '$root/49__LATE_QA_POS_19__PASS.png';
}
