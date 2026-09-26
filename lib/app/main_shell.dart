import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/platform/app_settings_launcher.dart';
import '../core/widgets/feature_unavailable_dialog.dart';
import '../features/adventure/adventure_screen.dart';
import '../features/adventure/world_progression_screen.dart';
import '../features/battle/battle_prep_screen.dart';
import '../features/hero/equipment_screen.dart';
import '../features/hero/crafting_screen.dart';
import '../features/hero/hero_item_state.dart';
import '../features/hero/hero_screen.dart';
import '../features/hero/inventory_screen.dart';
import '../features/hero/lumi_screen.dart';
import '../features/hero/movement_mastery_screen.dart';
import '../features/home/daily_streak_preview_screen.dart';
import '../features/home/daily_summary_popup.dart';
import '../features/home/event_detail_popup.dart';
import '../features/home/events_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/local_event_state.dart';
import '../features/home/home_preview_dialog.dart';
import '../features/home/quest_center_screen.dart';
import '../features/home/rune_inbox_screen.dart';
import '../features/home/rune_shrine_ready_screen.dart';
import '../features/profile/achievements_screen.dart';
import '../features/profile/player_level_screen.dart';
import '../features/profile/profile_history_screen.dart';
import '../features/profile/profile_history_state.dart';
import '../features/profile/local_settings_state.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_accessibility_screen.dart';
import '../features/profile/settings_account_screen.dart';
import '../features/profile/settings_hub_screen.dart';
import '../features/profile/settings_notifications_screen.dart';
import '../features/profile/settings_permissions_screen.dart';
import '../features/profile/settings_privacy_screen.dart';
import '../features/quests/daily_quests_screen.dart';
import '../features/quests/local_quest_state.dart';
import '../features/quests/quest_chain_screen.dart';
import '../features/quests/weekly_quests_screen.dart';
import '../features/shop/pro_paywall_screen.dart';
import '../features/shop/shop_screen.dart';
import '../features/social/social_screen.dart';

enum _ShellDestination { home, adventure, battle, hero, profile }

typedef BattleRootBuilder =
    Widget Function(
      BuildContext context,
      ValueChanged<BattlePrepRootDestination> onRootNavigate,
    );

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.battleRootBuilder,
    this.onDailySummaryDetails,
    this.onWeeklyQuestChainReward,
    this.onQuestChainStreakDetails,
    this.onQuestChainCompletionRewards,
    this.preferences,
  });

  final BattleRootBuilder? battleRootBuilder;
  final VoidCallback? onDailySummaryDetails;
  final VoidCallback? onWeeklyQuestChainReward;
  final VoidCallback? onQuestChainStreakDetails;
  final VoidCallback? onQuestChainCompletionRewards;
  final SharedPreferences? preferences;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  _ShellDestination destination = _ShellDestination.home;
  final LocalQuestOwner _questOwner = LocalQuestOwner();
  final HeroItemOwner _itemOwner = HeroItemOwner();
  final ProfileHistoryOwner _historyOwner = ProfileHistoryOwner();
  late final LocalSettingsOwner _localSettingsOwner = LocalSettingsOwner(
    widget.preferences,
  );

  @override
  void dispose() {
    _questOwner.dispose();
    _itemOwner.dispose();
    _historyOwner.dispose();
    _localSettingsOwner.dispose();
    super.dispose();
  }

  bool get _battleAvailable => widget.battleRootBuilder != null;

  void _showUnavailable(
    BuildContext context,
    String feature, {
    String? message,
  }) {
    unawaited(
      FeatureUnavailableDialog.show(
        context,
        feature: feature,
        message: message,
      ),
    );
  }

  void _showHomePreview(BuildContext context, String title, [String? message]) {
    unawaited(
      HomePreviewDialog.show(
        context,
        title: title,
        message:
            message ??
            'Bu alan test önizlemesinde açıldı. Canlı tercih sahibi bağlı olmadığı için kalıcı hesap veya ayar verisi değiştirilmez.',
      ),
    );
  }

  void _select(_ShellDestination next) {
    if (destination == next) return;
    setState(() => destination = next);
  }

  _ShellDestination _rootByName(String name) {
    return switch (name) {
      'home' => _ShellDestination.home,
      'adventure' => _ShellDestination.adventure,
      'battle' => _ShellDestination.battle,
      'hero' => _ShellDestination.hero,
      'profile' => _ShellDestination.profile,
      _ => throw ArgumentError.value(name, 'name', 'Unknown root destination'),
    };
  }

  void _selectRoot(BuildContext context, String rootName) {
    final next = _rootByName(rootName);
    if (next == _ShellDestination.battle && !_battleAvailable) {
      _showUnavailable(
        context,
        'Savaş',
        message:
            'Gerçek karşılaşma içeriği henüz bağlı olmadığı için Savaş şu anda kilitli.',
      );
      return;
    }
    _select(next);
  }

  void _closeChildStackAndSelect(BuildContext routeContext, String rootName) {
    final next = _rootByName(rootName);
    if (next == _ShellDestination.battle && !_battleAvailable) {
      _showUnavailable(
        routeContext,
        'Savaş',
        message:
            'Gerçek karşılaşma içeriği henüz bağlı olmadığı için Savaş şu anda kilitli.',
      );
      return;
    }
    Navigator.of(routeContext).popUntil((route) => route.isFirst);
    _select(next);
  }

  Future<void> _openDailyStreakPreview(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => DailyStreakPreviewScreen(
          onBack: () => Navigator.of(routeContext).pop(),
        ),
      ),
    );
  }

  Future<void> _openRuneInbox(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) =>
            RuneInboxScreen(onBack: () => Navigator.of(routeContext).pop()),
      ),
    );
  }

  Future<void> _openQuestCenter(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => QuestCenterScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onDaily: () => _openDailyQuests(routeContext),
          onWeekly: () => _openWeeklyQuests(routeContext),
          questOwner: _questOwner,
        ),
      ),
    );
  }

  Future<void> _openDailySummary(BuildContext context) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Dünün Özeti',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, _) => DailySummaryPopup(
        onClose: () => Navigator.of(dialogContext).pop(),
        onContinueToday: () => Navigator.of(dialogContext).pop(),
        onAdventureProgress: () {
          Navigator.of(dialogContext).pop();
          _select(_ShellDestination.adventure);
        },
        onViewDetails: () {
          Navigator.of(dialogContext).pop();
          final callback = widget.onDailySummaryDetails;
          if (callback != null) {
            callback();
          } else {
            _showHomePreview(
              context,
              'Günlük Özet Detayları',
              'Canlı ayrıntılı istatistik sahibi henüz bağlı değil. Bu önizleme Dünün Özeti akışını kapatmadan ayrıntı alanını test etmek içindir.',
            );
          }
        },
      ),
    );
  }

  Future<void> _openEventDetail(BuildContext context, String eventId) async {
    final event = const LocalEventOwner().byId(eventId);
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Etkinlik Detayı',
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, _) => EventDetailPopup(
        event: event,
        onClose: () => Navigator.of(dialogContext).pop(),
        onJoin: () => _showUnavailable(
          dialogContext,
          'Etkinliğe Katıl',
          message:
              'Canlı katılım sahibi bağlı değil; ${event.title} için katılım kaydedilmedi.',
        ),
        onViewTasks: () => _showUnavailable(
          dialogContext,
          'Etkinlik Görevleri',
          message: '${event.title} için doğrulanmış görev kaydı bağlı değil.',
        ),
        onTask: (_) => _showUnavailable(
          dialogContext,
          'Etkinlik Görevi',
          message: '${event.title} için doğrulanmış görev kaydı bağlı değil.',
        ),
      ),
    );
  }

  Future<void> _openDailyQuests(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => DailyQuestsScreen(
          questOwner: _questOwner,
          onProgressReward: () => _showUnavailable(
            routeContext,
            'Günlük Rün Sandığı',
            message:
                'Gerçek görev ilerlemesi, ödül içeriği ve ödül kayıt sistemi bağlı değil. Herhangi bir ödül verilmedi.',
          ),
          onClaimExploreReward: () => _showUnavailable(
            routeContext,
            'Keşif Ödülü',
            message:
                'Gerçek görev ilerlemesi, ödül içeriği ve ödül kayıt sistemi bağlı değil. Herhangi bir ödül verilmedi.',
          ),
          onClaimBattleReward: () => _showUnavailable(
            routeContext,
            'Savaş Ödülü',
            message:
                'Gerçek görev ilerlemesi, ödül içeriği ve ödül kayıt sistemi bağlı değil. Herhangi bir ödül verilmedi.',
          ),
          onFreeTaskChange: () =>
              _showUnavailable(routeContext, 'Görev Değiştirme'),
          onTaskChangeHelp: () =>
              _showUnavailable(routeContext, 'Görev Değiştirme Yardımı'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openWeeklyQuests(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => WeeklyQuestsScreen(
          questOwner: _questOwner,
          onDailyStreak: () => _openDailyStreakPreview(routeContext),
          onClaimQuestChainReward: () => _showUnavailable(
            routeContext,
            'Haftalık Görev Ödülü',
            message:
                'Gerçek görev ilerlemesi, ödül içeriği ve ödül kayıt sistemi bağlı değil. Herhangi bir ödül verilmedi.',
          ),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openQuestChain(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => QuestChainScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onDailyStreak: () {
            final callback = widget.onQuestChainStreakDetails;
            if (callback != null) {
              callback();
            } else {
              _openDailyQuests(routeContext);
            }
          },
          onActiveQuest: _battleAvailable
              ? () => _closeChildStackAndSelect(routeContext, 'battle')
              : () => _showUnavailable(
                  routeContext,
                  'Aktif Görev',
                  message:
                      'Gerçek karşılaşma içeriği bağlanmadan aktif görev Savaş akışını başlatamaz.',
                ),
          onCompletionRewards: () {
            final callback = widget.onQuestChainCompletionRewards;
            if (callback != null) {
              callback();
            } else {
              _showUnavailable(
                routeContext,
                'Bölüm Tamamlama Ödülü',
                message:
                    'Gerçek görev zinciri ilerlemesi, ödül içeriği ve ödül kayıt sistemi bağlı değil. Herhangi bir ödül verilmedi.',
              );
            }
          },
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openEvents(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => EventsScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onFeaturedEvent: () =>
              _openEventDetail(routeContext, LocalEventOwner.runeStorm.id),
          onEvent: (eventId) => _openEventDetail(routeContext, eventId),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openWorldProgression(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => WorldProgressionScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onHeroProfile: () => _closeChildStackAndSelect(routeContext, 'hero'),
          onNotifications: () => _openNotifications(routeContext),
          onSettings: () => _openSettingsHub(routeContext),
          onRegionSelect: () => _showHomePreview(
            routeContext,
            'Bölge Seçimi',
            'Bölge seçimi önizlemesi açık. Canlı bölge sahipliği bağlanmadığı için bu test sürümünde harita kalıcı olarak değiştirilmiyor.',
          ),
          onAncientTree: () => _showHomePreview(
            routeContext,
            'Kadim Ağaç',
            'Kadim Ağaç keşif noktası önizlemesi. Canlı ilerleme bağlandığında görev ve karşılaşma ayrıntıları burada açılacak.',
          ),
          onLostRuneCave: () => _showHomePreview(
            routeContext,
            'Kayıp Rün Mağarası',
            'Kayıp Rün Mağarası keşif noktası önizlemesi. Canlı ilerleme ve ödül sahipliği bu önizlemede değiştirilmez.',
          ),
          onWaterfallTemple: () => _showHomePreview(
            routeContext,
            'Şelale Tapınağı',
            'Şelale Tapınağı keşif noktası önizlemesi. Bu ekran salt okunurdur; görev veya ödül durumu değiştirilmez.',
          ),
          onWindCliffs: () => _showHomePreview(
            routeContext,
            'Rüzgar Kayalıkları',
            'Rüzgar Kayalıkları keşif noktası önizlemesi. Canlı progression owner bağlanana kadar yalnız bilgi gösterilir.',
          ),
          onShowNextTarget: () => _showHomePreview(
            routeContext,
            'Sonraki Hedef',
            'Sonraki hedef önizlemesi. Canlı progression owner bağlanmadığından haritada kalıcı seçim yapılmıyor.',
          ),
          onBossPreview: () => _showHomePreview(
            routeContext,
            'Boss Ön İzleme',
            'Boss şu anda kilitli. Bu önizleme yalnız kilit durumunu gösterir; savaş başlatılmaz ve boss açılmaz.',
          ),
          onRewardPreview: () => _showHomePreview(
            routeContext,
            'Ödül Ön İzleme',
            'Bölge ödülü önizlemesi. Gerçek ödül sahibi bağlanmadan hiçbir ödül verilmez veya envanter değiştirilmez.',
          ),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          bossUnlocked: false,
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openRuneShrine(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => RuneShrineReadyScreen(
          onClose: () => Navigator.of(routeContext).pop(),
          onOpenGift: () => _showHomePreview(
            routeContext,
            'Rün Hediyesi',
            'Rün hediyesi önizlemesi açık. Ödüllü reklam ve gerçek ödül sahibi bağlanmadığı için bu test sürümünde rune, envanter veya para birimi değiştirilmez.',
          ),
          onNotNow: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openInventory(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => InventoryScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onInfo: () => _showUnavailable(routeContext, 'Envanter Bilgisi'),
          onBulkActions: () =>
              _showUnavailable(routeContext, 'Toplu Envanter İşlemleri'),
          onCrafting: () => _openCrafting(routeContext),
          itemOwner: _itemOwner,
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openEquipment(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => EquipmentScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onInfo: () => _showUnavailable(routeContext, 'Ekipman Bilgisi'),
          onInventory: () => _openInventory(routeContext),
          onPresets: () =>
              _showUnavailable(routeContext, 'Ekipman Ön Ayarları'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          itemOwner: _itemOwner,
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openCrafting(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => CraftingScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onInfo: () => _showUnavailable(routeContext, 'Üretim Bilgisi'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          itemOwner: _itemOwner,
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openLumi(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => LumiScreen(
          onDailyStreak: () => _openDailyQuests(routeContext),
          onBondInfo: () => _showUnavailable(routeContext, 'Lumi Bağı'),
          onLevelRewards: () =>
              _showUnavailable(routeContext, 'Lumi Seviye Ödülleri'),
          onAbilitySelected: (_) =>
              _showUnavailable(routeContext, 'Lumi Yeteneği'),
          onAppearanceSelected: (_) =>
              _showUnavailable(routeContext, 'Lumi Görünümü'),
          onAppearanceNext: () =>
              _showUnavailable(routeContext, 'Lumi Görünümleri'),
          onCustomize: () =>
              _showUnavailable(routeContext, 'Lumi Özelleştirme'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openMovementMastery(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => MovementMasteryScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onHelp: () =>
              _showUnavailable(routeContext, 'Hareket Ustalığı Yardımı'),
          onMasteryInfo: () =>
              _showUnavailable(routeContext, 'Hareket Ustalığı Bilgisi'),
          onMovement: (_) =>
              _showUnavailable(routeContext, 'Hareket Ustalığı Detayı'),
          onMovementGuide: () =>
              _showUnavailable(routeContext, 'Hareket Rehberi'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openPlayerLevel(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => PlayerLevelScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onHelp: () =>
              _showUnavailable(routeContext, 'Oyuncu Seviyesi Yardımı'),
          onClaimMilestone: () =>
              _showUnavailable(routeContext, 'Seviye Ödülü'),
          onAbout: () =>
              _showUnavailable(routeContext, 'Oyuncu Seviyesi Hakkında'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openAchievements(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => AchievementsScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onCrystalStore: () => _openShop(routeContext),
          onGoldStore: () => _openShop(routeContext),
          onNotifications: () => _openNotifications(routeContext),
          onShowInProfile: () => Navigator.of(routeContext).pop(),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openProfileHistory(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => ProfileHistoryScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          historyOwner: _historyOwner,
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openAccount(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsAccountScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onEditProfile: () =>
              _showHomePreview(routeContext, 'Profili Düzenle'),
          onCopyRuneId: () => _showHomePreview(routeContext, 'Rune ID'),
          onLinkedAccount: (_) =>
              _showHomePreview(routeContext, 'Bağlı Hesaplar'),
          onViewData: () => _showHomePreview(routeContext, 'Verilerimi Gör'),
          onSignOut: () => _showHomePreview(routeContext, 'Çıkış Yap'),
          onDeleteAccount: () => _showHomePreview(routeContext, 'Hesabı Sil'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openNotifications(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsNotificationsScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          settingsOwner: _localSettingsOwner,
          onReminderHours: () =>
              _showHomePreview(routeContext, 'Hatırlatma Saatleri'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openPrivacy(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsPrivacyScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onProfileVisibility: () =>
              _showHomePreview(routeContext, 'Profil Görünürlüğü'),
          onToggle: (_) => _showHomePreview(routeContext, 'Gizlilik Tercihi'),
          onBlockedPlayers: () =>
              _showHomePreview(routeContext, 'Engellenen Oyuncular'),
          onDataPrivacy: () =>
              _showHomePreview(routeContext, 'Veri ve Gizlilik'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _managePermission(
    BuildContext context,
    PermissionTarget target,
  ) async {
    final opened = await const AppSettingsLauncher().openAppSettings();
    if (!opened && context.mounted) {
      _showUnavailable(context, '${target.name} İzni');
    }
  }

  Future<void> _openPermissions(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsPermissionsScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onManage: (target) =>
              unawaited(_managePermission(routeContext, target)),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openAccessibility(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsAccessibilityScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onTextSize: () => _showHomePreview(routeContext, 'Metin Boyutu'),
          settingsOwner: _localSettingsOwner,
          onColorSupport: () =>
              _showHomePreview(routeContext, 'Renk Ayrımı Desteği'),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openSettingsHub(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => SettingsHubScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onSection: (section) {
            switch (section) {
              case SettingsSection.account:
                _openAccount(routeContext);
              case SettingsSection.notifications:
                _openNotifications(routeContext);
              case SettingsSection.privacy:
                _openPrivacy(routeContext);
              case SettingsSection.permissions:
                _openPermissions(routeContext);
              case SettingsSection.accessibility:
                _openAccessibility(routeContext);
            }
          },
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  Future<void> _openSocial(BuildContext context) async {
    await Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => const SocialScreen()));
  }

  Future<void> _openProPaywall(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => ProPaywallScreen(
          onBack: () => Navigator.of(routeContext).pop(),
          onClose: () => Navigator.of(routeContext).pop(),
          onPlanSelected: (_) =>
              _showUnavailable(routeContext, 'Pro Plan Seçimi'),
          onUpgradeRequested: () =>
              _showUnavailable(routeContext, 'ActiRune Pro Satın Alma'),
          onContinueFree: () => Navigator.of(routeContext).pop(),
        ),
      ),
    );
  }

  Future<void> _openShop(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (routeContext) => ShopScreen(
          onNotifications: () => _openNotifications(routeContext),
          onSettings: () => _openSettingsHub(routeContext),
          onCategorySelected: (category) {
            if (category == ShopCategory.pro) {
              _openProPaywall(routeContext);
            } else {
              _showUnavailable(routeContext, 'Mağaza Kategorisi');
            }
          },
          onWeeklyCollection: () =>
              _showUnavailable(routeContext, 'Haftalık Koleksiyon'),
          onSeeAllFeatured: () =>
              _showUnavailable(routeContext, 'Öne Çıkan Ürünler'),
          onProductSelected: (_) =>
              _showUnavailable(routeContext, 'Mağaza Ürünü'),
          onRuneThemes: () => _showUnavailable(routeContext, 'Rün Temaları'),
          onCrystalPacks: () =>
              _showUnavailable(routeContext, 'Kristal Paketleri'),
          onPro: () => _openProPaywall(routeContext),
          onRootNavigate: (next) =>
              _closeChildStackAndSelect(routeContext, next.name),
          battleRootEnabled: true,
        ),
      ),
    );
  }

  List<Widget> _screens(BuildContext context) {
    return [
      HomeScreen(
        onDailyStreak: () => _openDailyStreakPreview(context),
        onMessages: () => _openRuneInbox(context),
        onQuests: () => _openQuestCenter(context),
        onEvents: () => _openEvents(context),
        onSettings: () => _openSettingsHub(context),
        onWorldMap: () => _openWorldProgression(context),
        onYesterdaySummary: () => _openDailySummary(context),
        onRewards: () => _openRuneShrine(context),
        onRootNavigate: (next) => _selectRoot(context, next.name),
        battleRootEnabled: true,
      ),
      AdventureScreen(
        onDailyStreak: () => _openDailyQuests(context),
        onMessages: () => _showUnavailable(context, 'Rune Gelen Kutusu'),
        onQuests: () => _openQuestChain(context),
        onEvents: () => _openEvents(context),
        onSettings: () => _openSettingsHub(context),
        onWorldMap: () => _openWorldProgression(context),
        onEncounterPreview: () => _showUnavailable(
          context,
          'Hazır Ol',
          message:
              'Bu karşılaşma henüz açılmadı. Gerçek encounter durumu açıldığında Savaş hazırlığına geçecek.',
        ),
        onStory: () => _showUnavailable(context, 'Bölüm Hikayesi'),
        onAdventureLog: () => _showUnavailable(context, 'Macera Günlüğü'),
        onRootNavigate: (next) => _selectRoot(context, next.name),
        battleRootEnabled: true,
      ),
      widget.battleRootBuilder?.call(
            context,
            (next) => _selectRoot(context, next.name),
          ) ??
          const SizedBox.shrink(),
      HeroScreen(
        onEquipment: () => _openEquipment(context),
        onRunes: () => _showUnavailable(context, 'Runeler'),
        onAbilities: () => _showUnavailable(context, 'Yetenekler'),
        onCompanion: () => _openLumi(context),
        onCharacterStory: () => _showUnavailable(context, 'Karakter Hikayesi'),
        onCompanionDetails: () => _openLumi(context),
        onRuneDetails: () => _showUnavailable(context, 'Rune Detayları'),
        onDetailedStats: () =>
            _showUnavailable(context, 'Detaylı İstatistikler'),
        onMovementMastery: () => _openMovementMastery(context),
        onRootNavigate: (next) => _selectRoot(context, next.name),
        battleRootEnabled: true,
      ),
      ProfileScreen(
        onBack: () => _selectRoot(context, 'home'),
        onProfileDetails: () => _openPlayerLevel(context),
        onEditProfile: () => _showUnavailable(context, 'Profili Düzenle'),
        onAvatar: () => _showUnavailable(context, 'Profil Fotoğrafı'),
        onBadges: () => _openAchievements(context),
        onMovementMastery: () => _openMovementMastery(context),
        onWorldProgress: () => _openWorldProgression(context),
        onFriends: () => _openSocial(context),
        onHistory: () => _openProfileHistory(context),
        onAccountInfo: () => _openAccount(context),
        onNotifications: () => _openNotifications(context),
        onPrivacy: () => _openPrivacy(context),
        onSettings: () => _openSettingsHub(context),
        onRootNavigate: (next) => _selectRoot(context, next.name),
        battleRootEnabled: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: destination.index, children: _screens(context)),
    );
  }
}
