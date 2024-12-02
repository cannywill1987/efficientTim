import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:time_hello/com/timehello/beans/BaseBean.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:auto_orientation/auto_orientation.dart';
import 'package:video_player/video_player.dart';

import '../beans/IPApiLocationBean.dart';
import '../config/ENUMS.dart';
import '../config/Params.dart';

class DeviceInfoManagement {
  static DeviceInfoManagement? mDeviceInfoManagement;

  DeviceInfoPlugin? deviceInfoPlugin;
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  AndroidDeviceInfo? androidDeviceInfo;
  IosDeviceInfo? iosDeviceInfo;
  WebBrowserInfo? webBrowserInfo;
  MacOsDeviceInfo? macOsDeviceInfo;
  WindowsDeviceInfo? windowsDeviceInfo;
  DeviceTypeEnum? deviceTypeEnum;
  IPApiLocationBean? ipApiLocationBean;

  DeviceInfoManagement();

  String timezone = '';

  static DeviceInfoManagement? getInstance() {
    if (mDeviceInfoManagement == null) {
      mDeviceInfoManagement = new DeviceInfoManagement();
      mDeviceInfoManagement?.init();
    }
    return mDeviceInfoManagement;
  }

  init() async {
    this.deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (isIOS() == true) {
        this.iosDeviceInfo = await deviceInfoPlugin?.iosInfo;
        this.deviceTypeEnum = DeviceTypeEnum.IOS;
      }
    } catch (e) {}
    try {
      if (isMacOs() == true) {
        this.macOsDeviceInfo = await deviceInfoPlugin?.macOsInfo;
        this.deviceTypeEnum = DeviceTypeEnum.MACOS;
      }
    } catch (e) {}
    try {
      if (isAndroid() == true) {
        this.androidDeviceInfo = await deviceInfoPlugin?.androidInfo;
        this.deviceTypeEnum = DeviceTypeEnum.ANDROID;
      }
    } catch (e) {}
    try {
      this.webBrowserInfo = await deviceInfoPlugin?.webBrowserInfo;
      this.deviceTypeEnum = DeviceTypeEnum.WEB;
    } catch (e) {}

    try {
      if (isWindows() == true) {
        this.windowsDeviceInfo = await deviceInfoPlugin?.windowsInfo;
        this.deviceTypeEnum = DeviceTypeEnum.WEB;
      }
    } catch (e) {}
    try {
      if (Platform.isAndroid) {
        _deviceData = readAndroidBuildData(androidDeviceInfo!);
      } else if (Platform.isIOS) {
        _deviceData = readIosDeviceInfo(iosDeviceInfo!);
      } else if (Platform.isMacOS) {
        _deviceData = readMacOsDeviceInfo(macOsDeviceInfo!);
      } else if (Platform.isWindows) {
        _deviceData = readWindowsDeviceInfo(windowsDeviceInfo!);
      }
    } catch (e) {}

    mDeviceInfoManagement?.timezone =
        await FlutterNativeTimezone.getLocalTimezone();
    // getIPApiLocationBean();
    return mDeviceInfoManagement;
  }

  static bool isMacOs() {
    return !kIsWeb && Platform.isMacOS;
  }

  static bool isAndroid() {
    return !kIsWeb && Platform.isAndroid;
  }

  static bool isWindows() {
    return !kIsWeb && Platform.isWindows;
  }

  static bool isIOS() {
    return !kIsWeb && Platform.isIOS;
  }

  static isMobileWeb() {
    return isWEB() && (isAndroid() || isIOS());
  }

  static bool isWEB() {
    return kIsWeb;
  }

  static bool isMoible() {
    return isAndroid() || isIOS();
  }

  static String getLanguage() {
    // final List<Locale> systemLocales = WidgetsBinding.instance.window.locales; // Returns the list of locales that user defined in the system settings.
    // return Platform.localeName; //这个返回 en_US
    try {
      Locale c = Localizations.localeOf(Utility.getGlobalContext());
      return c.languageCode; //返回en
    } catch (e) {
      return "en";
    }
  }

  static String getLanguageCountryCode() {
    // final List<Locale> systemLocales = WidgetsBinding.instance.window.locales; // Returns the list of locales that user defined in the system settings.
    // return Platform.localeName; //这个返回 en_US
    try {
      Locale c = Localizations.localeOf(Utility.getGlobalContext());
      return c.languageCode + (c.countryCode ?? ""); //返回en
    } catch (e) {
      return "en";
    }
  }

  static vibrate({stopAfter: 3000}) async {
    // Check if the device can vibrate
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate == true) {
// Vibrate
// Vibration duration is a constant 500ms because
// it cannot be set to a specific duration on iOS.
      Vibrate.vibrate();

// Vibrate with pauses between each vibration
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
      ];
      Vibrate.vibrateWithPauses(pauses);
    }
// vibrate - sleep 0.5s - vibrate - sleep 1s - vibrate - sleep 0.5s - vibrate
  }

  String getModel() {
    return _deviceData['model'] ?? '';
  }

  static Locale? getMachaneLocal() {
    return Params.local;
  }

  static String getCountryCode() {
    Locale myLocale = Localizations.localeOf(Utility.getGlobalContext());
    String? countryCode = WidgetsBinding.instance.window.locale.countryCode;
    return myLocale.countryCode?.toString() ?? countryCode ?? "";
  }

  String getTimeZoneName() {
    return mDeviceInfoManagement?.timezone ?? '';
  }

  static isWebMobileBySize() {
    return isWEB() && Utility.isHandsetBySize();
  }

  static isWebPCBySize() {
    return isWEB() && !Utility.isHandsetBySize();
  }

  String getBrand() {
    return _deviceData['brand'] ?? '';
  }

  Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.id,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
      'brand': 'IOS',
      'manufacturer': 'IOS',
    };
  }

  isLandScape() async {
    final orientation = await NativeDeviceOrientationCommunicator()
        .orientation(useSensor: true);
    return orientation == NativeDeviceOrientation.landscapeLeft ||
        orientation == NativeDeviceOrientation.landscapeRight;
  }

  setLandScape(bool isLandScape) {
    if (isLandScape == true) {
      AutoOrientation.landscapeAutoMode(forceSensor: true);
    } else {
      AutoOrientation.portraitUpMode();
    }
    // mDeviceInfoManagement?.isLandScape = isLandScape;
  }

  Future<Map> getImageDimensions(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = await decodeImageFromList(bytes);
    image.dispose();

    return {"width": image.width.toDouble(), "height": image.height.toDouble()};
  }

  Future<Map> getVideoDimensions(File videoFile) async {
    final videoController = VideoPlayerController.file(videoFile);
    await videoController.initialize();

    final videoSize = videoController.value.size;
    videoController.dispose();
    return {
      "width": videoSize.width.toDouble(),
      "height": videoSize.height.toDouble()
    };
  }

  Map<String, dynamic> readLinuxDeviceInfo(LinuxDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'version': data.version,
      'id': data.id,
      'idLike': data.idLike,
      'versionCodename': data.versionCodename,
      'versionId': data.versionId,
      'prettyName': data.prettyName,
      'buildId': data.buildId,
      'variant': data.variant,
      'variantId': data.variantId,
      'machineId': data.machineId,
      'brand': 'LINUX',
      'manufacturer': 'LINUX',
    };
  }

  Map<String, dynamic> readWebBrowserInfo(WebBrowserInfo data) {
    return <String, dynamic>{
      'browserName': data.browserName,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
      'brand': 'WEB',
      'manufacturer': 'WEB',
    };
  }

  Map<String, dynamic> readMacOsDeviceInfo(MacOsDeviceInfo data) {
    return <String, dynamic>{
      'computerName': data.computerName,
      'hostName': data.hostName,
      'arch': data.arch,
      'model': data.model,
      'kernelVersion': data.kernelVersion,
      'osRelease': data.osRelease,
      'activeCPUs': data.activeCPUs,
      'memorySize': data.memorySize,
      'cpuFrequency': data.cpuFrequency,
      'systemGUID': data.systemGUID,
      'brand': 'MAC',
      'manufacturer': 'MAC',
    };
  }

  Map<String, dynamic> readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'model': 'WINDOWS',
      'brand': 'WINDOWS',
      'manufacturer': 'WINDOWS',
    };
  }
}
