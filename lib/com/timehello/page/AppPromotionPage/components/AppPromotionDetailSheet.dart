import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/page/AppPromotionPage/AppPromotionPage.dart';
import 'package:time_hello/com/timehello/util/AppPromotionManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

class AppPromotionDetailSheet extends StatelessWidget {
  final AppPromotionModel app;

  const AppPromotionDetailSheet({Key? key, required this.app})
      : super(key: key);

  static Future<void> show(BuildContext context,
      {required AppPromotionModel app}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppPromotionDetailSheet(app: app),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppPromotionStrings.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.86,
      minChildSize: 0.62,
      maxChildSize: 0.96,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
            children: [
              Row(
                children: [
                  AppPromotionIcon(app: app, size: 58),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (app.category.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            app.category,
                            style: const TextStyle(
                              color: Color(0xff6252f4),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: strings.close,
                    icon: const Icon(Icons.close, color: Color(0xff667085)),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const SizedBox(height: 18),
              _Banner(app: app),
              const SizedBox(height: 20),
              _SectionTitle(title: strings.appIntro),
              const SizedBox(height: 8),
              Text(
                app.description.isNotEmpty ? app.description : app.subtitle,
                style: const TextStyle(
                  color: Color(0xff344054),
                  fontSize: 15,
                  height: 1.55,
                ),
              ),
              if (app.features.isNotEmpty) ...[
                const SizedBox(height: 20),
                _SectionTitle(title: strings.mainFeatures),
                const SizedBox(height: 12),
                _Features(features: app.features),
              ],
              const SizedBox(height: 20),
              _SectionTitle(title: strings.supportedPlatforms),
              const SizedBox(height: 12),
              _PlatformGrid(app: app),
              const SizedBox(height: 18),
              _DownloadButton(app: app, label: strings.downloadNow),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline,
                      size: 15, color: Color(0xff667085)),
                  const SizedBox(width: 6),
                  Text(
                    '${strings.securityPassed}  |  ${strings.privacyProtected}',
                    style: const TextStyle(
                      color: Color(0xff667085),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Banner extends StatelessWidget {
  final AppPromotionModel app;

  const _Banner({required this.app});

  @override
  Widget build(BuildContext context) {
    if (app.bannerUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          app.bannerUrl,
          height: 186,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _FallbackBanner(app: app),
        ),
      );
    }
    return _FallbackBanner(app: app);
  }
}

class _FallbackBanner extends StatelessWidget {
  final AppPromotionModel app;

  const _FallbackBanner({required this.app});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 186,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xff5b4df7), Color(0xff7e8bff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  app.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  app.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xeeffffff),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          AppPromotionIcon(app: app, size: 92),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xff111827),
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _Features extends StatelessWidget {
  final List<String> features;

  const _Features({required this.features});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: features.take(4).map((feature) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xfff0efff),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle_outline,
                    color: Color(0xff6252f4)),
              ),
              const SizedBox(height: 8),
              Text(
                feature,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xff475467), fontSize: 12),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PlatformGrid extends StatelessWidget {
  final AppPromotionModel app;

  const _PlatformGrid({required this.app});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: app.platforms.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.9,
      ),
      itemBuilder: (context, index) {
        final platform = app.platforms[index];
        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _open(platform.url),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xffd8dce6)),
            ),
            child: Row(
              children: [
                Icon(
                  AppPromotionPlatformIcon.iconFor(platform.code),
                  color: const Color(0xff6252f4),
                  size: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        platform.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (platform.subtitle.isNotEmpty)
                        Text(
                          platform.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xff475467),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final AppPromotionModel app;
  final String label;

  const _DownloadButton({required this.app, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff6252f4),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          final platform = app.getPreferredPlatform();
          if (platform != null) _open(platform.url);
        },
        icon: const Icon(Icons.file_download_outlined),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

void _open(String url) {
  if (url.isNotEmpty) {
    Utility.openExternalWebView(url: url);
  }
}
