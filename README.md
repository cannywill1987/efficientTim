ios构建
 flutter build ios --no-tree-shake-icons
 
端口号被占用时删除指定端口号
1.lsof -i tcp:9999
2.kill -9 9999
指令
启动 app:flutter run
启动 flutter devtools: flutter pub global run devtools
使用方法 https://docs.flutter.dev/development/tools/devtools/cli

老孟文档
http://laomengit.com/flutter/widgets/showDialog.html#showgeneraldialog

model build的方法
flutter pub run build_runner build --delete-conflicting-outputs

flutter packages pub run build_runner watch
清空缓存
flutter packages pub run build_runner watch --delete-conflicting-outputs

谷歌字体 很好的选字体工具
https://fonts.google.com/?preview.text=24:40

google material icon tag
https://fonts.google.com/icons

处理翻译arb
pub global run intl_utils:generate
arb
 flutter pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart

font awsome的Ui
font_awesome_flutter
https://pub.dev/packages/font_awesome_flutter/install

flutter-img-sync图片生成
1、Android Studio 搜索插件 flutter-img-sync 并安装：

2、 在主目录下新建文件夹：./assets/images/ 用于存放图片资源。

3、在 pubspec.yaml文件中定义图片存放目录；

  assets:

  # assets-generator-begin
  # assets/images/*
    - assets/images/default_head_portrait.png
  # assets-generator-end
4、执行Android Studio插件命令 FlutterImgSync：

5、输入本地预览端口（任意端口）， 执行命令后会在 lib 目录下自动生成 r.dart 文件

6、在使用 图片的地方，引入 r.dart 文件，示例：

Image.asset(
            R.assetsImagesDefaultHeadPortrait,
            width: ScreenUtil().setWidth(12),
            height: ScreenUtil().setWidth(12),
          )

Connection refused (OS Error: Connection refused, errno = 61), address = storage.googleapis.com, port = 52088 解决方案
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn


打包
//发布华为build.gradle包名需要改成 com.timespeed.time_hello values文件夹名称改为 时间管理局-学霸爱的专注番茄钟 才能发布成功
applicationId "com.timespeed.time_hello"

参考:http://wjhsh.net/niceyoo-p-11046253.html
flutter build apk --release --no-tree-shake-icons
注意 加上后面是为了 This application cannot tree shake icons fonts. It has non-constant instances of IconData

flutter_bugly建议
64-bit
flutter build apk --release --target-platform android-arm64 --no-tree-shake-icons
32-bit（目前配合armeabi-v7a可以打出32位64位通用包）
flutter build apk --release --target-platform android-arm --no-tree-shake-icons

aab
flutter build appbundle --no-tree-shake-icons    --release

一个不错的lottie样式列表
https://xvrh.github.io/lottie-flutter-web/#/

ANDROID SDK 签名
通过app得到:https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419319167&token=&lang=zh_CN
b80291045378ed1b497f7dccdb0a4582
这个签名是正确的

key Hashes facebook用
ER8W7PkBh3KzYGW+mZA6WR7WOuE=
获取指令
keytool -list -v -keystore sign.jks -alias sign -storepass linzhibin2003 -keypass linzhibin2003
SHA1: 8F:B0:82:22:FF:52:BF:B1:16:95:00:54:31:CE:FF:6E:79:1F:C8:88
SHA256: 3D:FD:9A:7F:85:CF:E9:51:B0:4E:77:BD:3A:F0:3C:46:85:D5:B0:83:EE:AA:B8:CF:E3:CB:8A:76:D6:CF:74:AD

md5
b80291045378ed1b497f7dccdb0a4582


sharesdk
https://new.dashboard.mob.com/#/createApp

windows打包
https://www.youtube.com/watch?v=XvwX-hmYv0E


mac打包
fmdb Minimun target 13
nanopb 11.0
promiseobjc 11

Pods
  Target Support Files
    Pods-Runner
      Pods-Runner-frameworks


windows构建指令
flutter build windows --no-sound-null-safety 
reeadme inno教程
https://blog.csdn.net/ww897532167/article/details/127012631

如果出现 quadrant找不到的问题
需要再
xcode architecture exclude
把 arm64, x86_64加上去


提取页面的需要翻译的中文，转换成 key: value i18n,key是小写英文空格用下划线区分,每个item逗号分开
getI18NKey().key方式替换代码中文


Targets Support Files/Pods-Runner/Pods-Runner-frameworks
修改
source="$(readlink -f "${source}")"
加上-f

ios&mac如何创建下载锻炼和推广图片
https://tools.applemediaservices.com/app-store-promote/app/1663610373?country=us

体积分析和优化
https://docs.flutter.dev/perf/app-size#estimating-total-size

flutter build apk --release --no-tree-shake-icons  --analyze-size --target-platform android-arm64


阿里妈妈抠图工具
https://chuangyi.taobao.com/tools/santi?spm=a2esx.12365734.0.0.d7132593vS685L

flutter web构建
构建后的代码在  build/web文件夹里
用Http-server解压缩即可
//这个比canvaskit更快 更好支持service worker

flutter build web --profile --no-tree-shake-icons --web-renderer html

flutter build web --profile --source-maps  --no-tree-shake-icons --web-renderer html

压缩不管用 会出问题
flutter build web --profile --dart-define=Dart2jsOptimization=O0   --no-tree-shake-icons --web-renderer html

flutter build web --profile --dart-define=Dart2jsOptimization=O0   --no-tree-shake-icons --web-renderer canvaskit


flutter build web --web-renderer canvaskit  --no-tree-shake-icons


flutter build web --profile --source-maps  --no-tree-shake-icons --web-renderer html




参考
https://docs.flutter.dev/platform-integration/web/building

https://dart.dev/tools/webdev#serve

国外app store 刷分网站
https://apptimizer.net/?utm_source=google&utm_medium=cpc&utm_campaign=12875054352&utm_content=130689527009&utm_term=how%20to%20advertise%20your%20app&gad_source=1&gclid=Cj0KCQiAz8GuBhCxARIsAOpzk8x0Sn5vPB-KAIxTBdSjXhiEiHqgOowlST6NW5aOzbn_tkX0mK51Ps4aAhK4EALw_wcB

相关账号
firebase
timerbell2022@gmail.com
linzhibin2003
https://console.firebase.google.com/


节假日查询
https://www.idcd.com/docs/open-api/holiday
curl --location --request GET 'https://www.idcd.com/api/holiday?year=2024' \
--header 'ClientID: df77f2de-2924-4499-adda-1c4cc243625a' \
--header 'Nonce: v0j38hHHUEqFwoh0Gc8Rbfi737xtIpLL' \
--header 'Timestamp: 1716085926' \
--header 'Signature: 5b1230f42bad2ffd5ad09890a8ebb47c02d74668be0cf7bb54a0f6a14996117b' \
--header 'SignatureMethod: HmacSHA256'

