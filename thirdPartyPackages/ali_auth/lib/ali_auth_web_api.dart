/// 文件作用：为 Web 构建提供阿里云一键登录插件的兼容实现。
///
/// 当前业务的一键登录能力只在移动端使用；原插件的 Web JS interop
/// 在 Dart 3.9 下无法编译。这里保留 Web 插件注册入口，但避免引用旧版
/// JS 注解，确保 Flutter Web 包可以正常构建。
class AliAuthPluginWebApi {
  /// Web 端不加载阿里云号码认证 SDK，返回空值避免首屏构建失败。
  Future<String?> getConnection() async => null;

  /// Web 端暂无 SDK 日志开关，保留方法用于兼容平台接口。
  Future<void> setLoggerEnable(bool isEnable) async {}

  /// Web 端暂无 SDK 版本信息，返回空值即可。
  Future<String?> getVersion() async => null;

  /// Web 端不支持本机号码鉴权，显式走失败回调，避免调用方误判成功。
  Future<void> checkAuthAvailable(
    String accessToken,
    String jwtToken,
    Function(dynamic status) success,
    Function(dynamic status) error,
  ) async {
    error({
      'code': 'unsupported_web',
      'message': 'AliAuth web authentication is not available.',
    });
  }

  /// Web 端不支持获取本机号码校验 Token，显式走失败回调。
  Future<void> getVerifyToken(
    Function(dynamic status) success,
    Function(dynamic status) error,
  ) async {
    error({
      'code': 'unsupported_web',
      'message': 'AliAuth web verify token is not available.',
    });
  }
}
