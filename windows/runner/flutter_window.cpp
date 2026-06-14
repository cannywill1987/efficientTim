#include "flutter_window.h"

#include <flutter/standard_method_codec.h>

#include <iostream>
#include <optional>
#include <variant>

#include "flutter/generated_plugin_registrant.h"

namespace {
constexpr char kCounterMethodChannelName[] = "com.efficienttime.counter";

// 功能：兼容 Flutter 侧常用的 List<Map> 入参，也允许未来直接传 Map。
flutter::EncodableMap GetFirstMapArgument(
    const flutter::EncodableValue* arguments) {
  if (arguments == nullptr) {
    return flutter::EncodableMap();
  }

  if (const auto* list = std::get_if<flutter::EncodableList>(arguments)) {
    if (!list->empty()) {
      if (const auto* first_map =
              std::get_if<flutter::EncodableMap>(&list->front())) {
        return *first_map;
      }
    }
  }

  if (const auto* map = std::get_if<flutter::EncodableMap>(arguments)) {
    return *map;
  }

  return flutter::EncodableMap();
}

// 功能：构造公共桥接器统一返回结构，后续新增 action 时优先在这里分发。
flutter::EncodableValue BuildCommonBridgeResult(
    const flutter::MethodCall<flutter::EncodableValue>& call) {
  const auto args = GetFirstMapArgument(call.arguments());
  std::string action;
  flutter::EncodableValue data{flutter::EncodableMap()};

  const auto action_it = args.find(flutter::EncodableValue("action"));
  if (action_it != args.end()) {
    if (const auto* action_value =
            std::get_if<std::string>(&action_it->second)) {
      action = *action_value;
    }
  }

  const auto params_it = args.find(flutter::EncodableValue("params"));
  if (params_it != args.end()) {
    data = params_it->second;
  }

  flutter::EncodableMap response;
  response[flutter::EncodableValue("success")] = flutter::EncodableValue(true);
  response[flutter::EncodableValue("platform")] =
      flutter::EncodableValue("windows");
  response[flutter::EncodableValue("action")] = flutter::EncodableValue(action);
  response[flutter::EncodableValue("data")] = data;
  return flutter::EncodableValue(response);
}
}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  method_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), kCounterMethodChannelName,
          &flutter::StandardMethodCodec::GetInstance());
  method_channel_->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
             result) {
        if (call.method_name() == "commonBridge") {
          result->Success(BuildCommonBridgeResult(call));
          return;
        }
        if (call.method_name() == "getBrand") {
          result->Success(flutter::EncodableValue("windows"));
          return;
        }
        if (call.method_name() == "init") {
          result->Success(flutter::EncodableValue(true));
          return;
        }
        if (call.method_name() == "Logs") {
          const auto args = GetFirstMapArgument(call.arguments());
          const auto tag_it = args.find(flutter::EncodableValue("TAG"));
          const auto msg_it = args.find(flutter::EncodableValue("msg"));
          const auto* tag =
              tag_it == args.end()
                  ? nullptr
                  : std::get_if<std::string>(&tag_it->second);
          const auto* msg =
              msg_it == args.end()
                  ? nullptr
                  : std::get_if<std::string>(&msg_it->second);
          std::cout << "[" << (tag == nullptr ? "Flutter" : *tag) << "] "
                    << (msg == nullptr ? "" : *msg) << std::endl;
          result->Success(flutter::EncodableValue(true));
          return;
        }
        result->NotImplemented();
      });
  SetChildContent(flutter_controller_->view()->GetNativeWindow());
  return true;
}

void FlutterWindow::OnDestroy() {
  method_channel_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
