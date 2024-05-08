import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:time_hello/com/timehello/beans/WebViewBaseBean.dart';
import 'package:time_hello/com/timehello/libs/methodChannel/CounterMethodChannelManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../components/BaseWidget.dart';

class WebviewPage extends BaseWidget {
  WebviewPage({required this.url, required this.title});

  final String url;
  final String title;

  @override
  BaseWidgetState<BaseWidget<ChangeNotifier>> getState() {
    // TODO: implement getState
    return _WebviewPageState();
  }
}

class _WebviewPageState extends BaseWidgetState<WebviewPage> {
  final GlobalKey webViewKey = GlobalKey();
  late WebViewController controller;
  double curValue = 0;

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

  void initState() {
    controller = WebViewController()
      ..addJavaScriptChannel("Flutter", onMessageReceived: (message) {
        // height = double.parse(message.message);
        // print("111111111");
        // Utility.showToast(msg: "share");
        try {
          WebViewBaseBean bean =
              WebViewBaseBean.fromJson(jsonDecode(message.message));
          switch (bean.api) {
            case 'shareToWechat':
              String title = bean.data?["title"] ?? "";
              String desc = bean.data?["desc"] ?? "";
              String link = bean.data?["link"] ?? "";
              String imgUrl = bean.data?["imgUrl"] ?? "";
              CounterMethodChannelManager.getInstance().shareToWeChat(
                  title: title, subtitle: desc, iconUrl: imgUrl, url: link);
              break;
            case 'shareToQQ':
              String title = bean.data?["title"] ?? "";
              String desc = bean.data?["desc"] ?? "";
              String link = bean.data?["link"] ?? "";
              String imgUrl = bean.data?["imgUrl"] ?? "";
              CounterMethodChannelManager.getInstance().shareToQQ(
                  title: title, subtitle: desc, iconUrl: imgUrl, url: link);
              break;
          }
        } catch (e) {
          print(e);
        }
      })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            curValue = progress.toDouble() / 100;
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            // 注入 js
            //         controller.runJavaScript(
            //             '''const resizeObserver = new ResizeObserver(entries =>
            //       Report.postMessage(document.scrollingElement.scrollHeight))
            // resizeObserver.observe(document.body)''');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          //进度条
          LinearProgressIndicator(
            value: curValue,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          WebViewWidget(controller: this.controller),
        ],
      ),
      // body: InAppWebView(
      //   key: webViewKey,
      //   initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
      //   initialOptions: options,
      // ),
    );
  }
}
