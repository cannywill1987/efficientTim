import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/AppPromotionPage/components/AppPromotionDetailSheet.dart';
import 'package:time_hello/com/timehello/util/AppPromotionManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class AppPromotionPage extends StatefulWidget {
  const AppPromotionPage({Key? key}) : super(key: key);

  @override
  State<AppPromotionPage> createState() => _AppPromotionPageState();
}

class _AppPromotionPageState extends State<AppPromotionPage> {
  late List<AppPromotionModel> _apps;

  @override
  void initState() {
    super.initState();
    _apps = AppPromotionManager.getInstance().getApps();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppPromotionStrings.of(context);
    return Scaffold(
      backgroundColor: const Color(0xfff7f8fb),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                _Header(strings: strings),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    itemCount: _apps.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final app = _apps[index];
                      return _AppPromotionCard(
                        app: app,
                        strings: strings,
                        onTap: () {
                          AppPromotionDetailSheet.show(context, app: app);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user_outlined,
                          size: 16, color: Color(0xff667085)),
                      const SizedBox(width: 6),
                      Text(
                        strings.safeNotice,
                        style: const TextStyle(
                          color: Color(0xff667085),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AppPromotionStrings strings;

  const _Header({required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: strings.back,
              icon: const Icon(Icons.arrow_back_ios_new, size: 22),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Utility.popupDesktopNavigator(context);
                }
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                strings.title,
                style: const TextStyle(
                  color: Color(0xff111827),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                strings.subtitle,
                style: const TextStyle(
                  color: Color(0xff667085),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: strings.close,
              icon: const Icon(Icons.close, size: 24),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Utility.popupDesktopNavigator(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppPromotionCard extends StatelessWidget {
  final AppPromotionModel app;
  final AppPromotionStrings strings;
  final VoidCallback onTap;

  const _AppPromotionCard({
    required this.app,
    required this.strings,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 110),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xffeef0f5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              AppPromotionIcon(app: app, size: 64),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            app.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xff111827),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (app.category.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _CategoryPill(text: app.category),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      app.subtitle.isNotEmpty ? app.subtitle : app.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff475467),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      children: app.platforms
                          .take(4)
                          .map((item) => _PlatformMiniIcon(code: item.code))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Color(0xff667085)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String text;

  const _CategoryPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xffefeaff),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xff6252f4),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PlatformMiniIcon extends StatelessWidget {
  final String code;

  const _PlatformMiniIcon({required this.code});

  @override
  Widget build(BuildContext context) {
    final color = code == 'android'
        ? const Color(0xff39b54a)
        : code == 'ios'
            ? Colors.black
            : code == 'macos'
                ? const Color(0xff007aff)
                : const Color(0xff1677ff);
    return Icon(AppPromotionPlatformIcon.iconFor(code), size: 18, color: color);
  }
}

class AppPromotionStrings {
  final String title;
  final String subtitle;
  final String safeNotice;
  final String appIntro;
  final String mainFeatures;
  final String supportedPlatforms;
  final String downloadNow;
  final String close;
  final String back;
  final String securityPassed;
  final String privacyProtected;

  const AppPromotionStrings({
    required this.title,
    required this.subtitle,
    required this.safeNotice,
    required this.appIntro,
    required this.mainFeatures,
    required this.supportedPlatforms,
    required this.downloadNow,
    required this.close,
    required this.back,
    required this.securityPassed,
    required this.privacyProtected,
  });

  static AppPromotionStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode.toLowerCase();
    return _values[locale] ?? _values['en']!;
  }

  static const Map<String, AppPromotionStrings> _values = {
    'zh': AppPromotionStrings(
      title: '发现更多应用',
      subtitle: '探索我们更多优质应用，让生活更高效',
      safeNotice: '所有应用均经过安全检测，请放心使用',
      appIntro: '应用介绍',
      mainFeatures: '主要功能',
      supportedPlatforms: '支持平台',
      downloadNow: '立即下载',
      close: '关闭',
      back: '返回',
      securityPassed: '安全检测通过',
      privacyProtected: '隐私保护',
    ),
    'en': AppPromotionStrings(
      title: 'Discover More Apps',
      subtitle: 'Explore more useful apps for a more efficient day',
      safeNotice: 'All apps are security checked',
      appIntro: 'About',
      mainFeatures: 'Features',
      supportedPlatforms: 'Platforms',
      downloadNow: 'Download',
      close: 'Close',
      back: 'Back',
      securityPassed: 'Security checked',
      privacyProtected: 'Privacy protected',
    ),
    'fr': AppPromotionStrings(
      title: 'Découvrir plus d’apps',
      subtitle: 'Explorez nos apps pour une journée plus efficace',
      safeNotice: 'Toutes les apps sont vérifiées',
      appIntro: 'Présentation',
      mainFeatures: 'Fonctions',
      supportedPlatforms: 'Plateformes',
      downloadNow: 'Télécharger',
      close: 'Fermer',
      back: 'Retour',
      securityPassed: 'Sécurité vérifiée',
      privacyProtected: 'Confidentialité protégée',
    ),
    'ja': AppPromotionStrings(
      title: 'もっとアプリを探す',
      subtitle: '毎日をより効率的にするアプリを見つけましょう',
      safeNotice: 'すべてのアプリは安全確認済みです',
      appIntro: 'アプリ紹介',
      mainFeatures: '主な機能',
      supportedPlatforms: '対応平台',
      downloadNow: 'ダウンロード',
      close: '閉じる',
      back: '戻る',
      securityPassed: '安全確認済み',
      privacyProtected: 'プライバシー保護',
    ),
    'es': AppPromotionStrings(
      title: 'Descubrir más apps',
      subtitle: 'Explora más apps útiles para un día más eficiente',
      safeNotice: 'Todas las apps han sido verificadas',
      appIntro: 'Introducción',
      mainFeatures: 'Funciones',
      supportedPlatforms: 'Plataformas',
      downloadNow: 'Descargar',
      close: 'Cerrar',
      back: 'Volver',
      securityPassed: 'Seguridad verificada',
      privacyProtected: 'Privacidad protegida',
    ),
    'it': AppPromotionStrings(
      title: 'Scopri altre app',
      subtitle: 'Esplora app utili per rendere la giornata più efficiente',
      safeNotice: 'Tutte le app sono controllate',
      appIntro: 'Introduzione',
      mainFeatures: 'Funzioni',
      supportedPlatforms: 'Piattaforme',
      downloadNow: 'Scarica',
      close: 'Chiudi',
      back: 'Indietro',
      securityPassed: 'Sicurezza verificata',
      privacyProtected: 'Privacy protetta',
    ),
  };
}

class AppPromotionIcon extends StatelessWidget {
  final AppPromotionModel app;
  final double size;

  const AppPromotionIcon({Key? key, required this.app, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    if (app.iconUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: Image.network(
          app.iconUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _assetIcon(radius),
        ),
      );
    }
    return _assetIcon(radius);
  }

  Widget _assetIcon(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: Image.asset(
        app.localIconAsset,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class AppPromotionPlatformIcon {
  static IconData iconFor(String code) {
    switch (code) {
      case 'android':
        return Icons.android;
      case 'ios':
        return Icons.phone_iphone;
      case 'macos':
        return Icons.desktop_mac;
      case 'windows':
        return Icons.window;
      default:
        return Icons.public;
    }
  }
}
