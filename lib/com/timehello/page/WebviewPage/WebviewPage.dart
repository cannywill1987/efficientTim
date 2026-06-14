import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    hide WebResourceError;
import 'package:time_hello/com/timehello/beans/WebViewBaseBean.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../components/BaseWidget.dart';

class WebviewPage extends BaseWidget {
  WebviewPage({
    Key? key,
    required this.url,
    required this.title,
    this.showAppBar = true,
  }) : super(key: key);

  final String url;
  final String title;
  final bool showAppBar;

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _WebviewPageState();
  }
}

class _WebviewPageState extends BaseWidgetState<WebviewPage> {
  final GlobalKey webViewKey = GlobalKey();
  WebViewController? controller;
  double curValue = 0;

  bool get _shouldUseInAppWebView =>
      defaultTargetPlatform == TargetPlatform.windows;

  bool get _shouldUseDesktopShareFallback =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //   crossPlatform: InAppWebViewOptions(
  //     useShouldOverrideUrlLoading: true,
  //     mediaPlaybackRequiresUserGesture: false,
  //   ),
  //   /// android 支持HybridComposition
  //   android: AndroidInAppWebViewOptions(
  //     useHybridComposition: true,
  //   ),
  //   ios: IOSInAppWebViewOptions(
  //     allowsInlineMediaPlayback: true,
  //   ),
  // );

  @override
  void initState() {
    super.initState();
    if (_shouldUseInAppWebView) {
      return;
    }
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "Flutter",
        onMessageReceived: (message) {
          _handleRawJavaScriptMessage(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (!mounted) {
              return;
            }
            setState(() {
              curValue = progress.toDouble() / 100;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (!mounted) {
              return;
            }
            setState(() {
              curValue = 1;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(this.widget.url));
    // macOS 的 webview_flutter 暂不支持 opaque/background 相关实现；
    // 透明背景只在移动端设置，避免桌面右侧面板直接红屏。
    if (defaultTargetPlatform != TargetPlatform.macOS) {
      controller?.setBackgroundColor(const Color(0x00000000));
    }
  }

  /// 复用 AppAIPlugin 的思路：WebView 只负责承载页面，业务动作通过 JS bridge
  /// 回到 Flutter 壳处理，避免网页侧直接关心桌面端分享能力。Windows 当前走
  /// flutter_inappwebview_windows，因此这里统一收敛为原始字符串消息。
  Future<void> _handleRawJavaScriptMessage(String rawMessage) async {
    try {
      WebViewBaseBean bean = WebViewBaseBean.fromJson(jsonDecode(rawMessage));
      switch (bean.api) {
        case 'shareToWechat':
          String title = bean.data?["title"] ?? "";
          String desc = bean.data?["desc"] ?? "";
          String link = bean.data?["link"] ?? "";
          String imgUrl = bean.data?["imgUrl"] ?? "";
          if (_shouldUseDesktopShareFallback) {
            await _shareByDesktopFallback(
              api: bean.api ?? "",
              link: link,
            );
            break;
          }
          await CounterMethodChannelManager.getInstance().shareToWeChat(
              title: title, subtitle: desc, iconUrl: imgUrl, url: link);
          break;
        case 'shareToQQ':
          String title = bean.data?["title"] ?? "";
          String desc = bean.data?["desc"] ?? "";
          String link = bean.data?["link"] ?? "";
          String imgUrl = bean.data?["imgUrl"] ?? "";
          if (_shouldUseDesktopShareFallback) {
            await _shareByDesktopFallback(
              api: bean.api ?? "",
              link: link,
            );
            break;
          }
          await CounterMethodChannelManager.getInstance().shareToQQ(
              title: title, subtitle: desc, iconUrl: imgUrl, url: link);
          break;
        case 'shareToFacebook':
        case 'shareToX':
          final String shareUrl = bean.data?["shareUrl"] ?? "";
          if (shareUrl.trim().isEmpty) {
            Utility.showToastMsg(
                context: context, msg: '分享链接为空，请稍后再试', type: 'error');
            break;
          }
          // 桌面端统一走系统浏览器，避免第三方分享页占用侧边 WebView。
          Utility.openExternalWebView(url: shareUrl);
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  /// 桌面端没有接入移动端微信/QQ SDK，这里先复制邀请链接并给出明确提示。
  ///
  /// 微信客户端支持 `weixin://` 唤起时再延迟打开；QQ 的 `mqq://` 在 macOS
  /// 未安装或未注册时会弹系统选择应用窗口，所以只复制链接，避免打扰用户。
  Future<void> _shareByDesktopFallback({
    required String api,
    required String link,
  }) async {
    final bool isQQ = api == 'shareToQQ';
    final String appName = isQQ ? 'QQ' : '微信';

    if (link.trim().isEmpty) {
      Utility.showToastMsg(
          context: context, msg: '分享链接为空，请稍后再试', type: 'error');
      return;
    }

    await FlutterClipboard.copy(link);
    Utility.showToastMsg(context: context, msg: '邀请链接已复制，请在$appName粘贴发送');

    if (api == 'shareToWechat') {
      await Future.delayed(const Duration(milliseconds: 600));
      try {
        await launchUrl(
          Uri.parse('weixin://'),
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {}
    }
  }

  Widget _buildWebViewBody() {
    final bool isLoading = curValue > 0 && curValue < 1;
    return Stack(
      children: [
        _shouldUseInAppWebView
            ? InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  transparentBackground: true,
                  useShouldOverrideUrlLoading: true,
                ),
                onWebViewCreated: (inAppController) {
                  inAppController.addJavaScriptHandler(
                    handlerName: 'Flutter',
                    callback: (args) {
                      final String rawMessage =
                          args.isEmpty ? '' : (args.first ?? '').toString();
                      _handleRawJavaScriptMessage(rawMessage);
                      return null;
                    },
                  );
                },
                onProgressChanged: (inAppController, progress) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    curValue = progress.toDouble() / 100;
                  });
                },
                onLoadStop: (inAppController, url) async {
                  await inAppController.evaluateJavascript(source: '''
                    if (!window.Flutter) {
                      window.Flutter = {
                        postMessage: function(message) {
                          window.flutter_inappwebview.callHandler('Flutter', message);
                        }
                      };
                    }
                  ''');
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    curValue = 1;
                  });
                },
                shouldOverrideUrlLoading:
                    (inAppController, navigationAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
              )
            : WebViewWidget(controller: controller!),
        if (isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              minHeight: 2,
              value: curValue,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                ThemeManager.getInstance().getDefautThemeColor(),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = _buildWebViewBody();
    if (!widget.showAppBar) {
      // 桌面右侧浮层已经有统一标题栏，这里只输出纯 WebView 内容。
      return ColoredBox(
        color: ThemeManager.getInstance().getThemeMode().isDark
            ? const Color(0xFF111111)
            : ColorsConfig.backgroundColor,
        child: body,
      );
    }

    return Scaffold(appBar: AppBar(title: Text(widget.title)), body: body);
  }
}
