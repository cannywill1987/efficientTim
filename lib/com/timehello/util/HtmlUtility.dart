import 'package:universal_html/html.dart' as html;
// import 'dart:js' as js;



import 'package:time_hello/com/timehello/util/DeviceInfoManagement.dart';

class HtmlUtility {
  // 获取完整的 URL
  static getLocationUrl() {
    if (!DeviceInfoManagement.isWEB()) {
      return "";
    }
    return html.window.location.href;
  }

  static getHostName() {
    if (!DeviceInfoManagement.isWEB()) {
      return "";
    }
    return html.window.location.hostname;
  }

  static getQuery() {
    if (!DeviceInfoManagement.isWEB()) {
      return "";
    }
    return html.window.location.search;
  }

  static getQueryMap() {
    if (!DeviceInfoManagement.isWEB()) {
      return {};
    }
    String query = html.window.location.search ?? "";
    Map<String, String> queryParams = Uri.splitQueryString(
        query.startsWith('?') ? query.substring(1) : query);
    return queryParams;
  }

  static dismissLoading() {
    // if (!DeviceInfoManagement.isWEB()) {
    //   return;
    // }
    // js.context.callMethod('dismiss');
  }
  // static dimissLoading2() {
  //   JavascriptRuntime flutterJs;
  //   flutterJs = getJavascriptRuntime();
  //   JsEvalResult jsResult = flutterJs.evaluate(
  //       "dismiss()");
  // }
}
