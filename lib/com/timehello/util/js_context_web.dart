import 'dart:js' as js;

import 'js_context.dart';

class JsContextWeb implements JsContext {
  @override
  callMethod(String name) {
    js.context.callMethod(name);
  }
}

