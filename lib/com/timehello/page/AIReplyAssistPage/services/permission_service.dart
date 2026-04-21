import 'native_assist_bridge.dart';

/// 权限服务：
/// - 屏幕录制权限（截图）
/// - 辅助功能权限（点击/粘贴）
class PermissionService {
  final NativeAssistBridge _bridge;

  PermissionService({NativeAssistBridge? bridge})
      : _bridge = bridge ?? NativeAssistBridge();

  /// 返回统一的权限状态字符串。
  Future<Map<String, String>> checkPermissions() async {
    final Map<String, dynamic> res = await _bridge.checkPermissions();
    return <String, String>{
      'screenRecording': res['screenRecording']?.toString() ?? 'unknown',
      'accessibility': res['accessibility']?.toString() ?? 'unknown',
    };
  }

  /// 跳转到系统设置对应权限页。
  Future<void> openSystemSettings(String page) async {
    await _bridge.openSystemSettings(page: page);
  }
}
