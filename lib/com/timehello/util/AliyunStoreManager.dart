import 'dart:convert';
import 'dart:io';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:time_hello/com/timehello/common/httpclient/HttpManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/config/Params.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../beans/BaseBean.dart';

/**
 * https://help.aliyun.com/zh/oss/developer-reference/use-temporary-access-credentials-provided-by-sts-to-access-oss
 * https://ram.console.aliyun.com/permissions
 * https://help.aliyun.com/zh/ram/developer-reference/sts-sdk-overview?spm=a2c4g.11186623.0.i9#reference-w5t-25v-xdb
 * 这里配置bucket
 * https://help.aliyun.com/zh/oss/developer-reference/use-temporary-access-credentials-provided-by-sts-to-access-oss#p-osc-r0m-u63
 * https://www.npmjs.com/package/@alicloud/sts20150401?activeTab=code
 * 处理完还需呀设置上传服务器oss回到告诉服务器做记录
 * https://help.aliyun.com/zh/oss/user-guide/upload-callbacks-12?spm=api-workbench.Troubleshoot.0.0.13c47185fL7mxk
 */
class AliyunStoreManager {
  static AliyunStoreManager? mAliyunStoreManagerr;
  String accessKey = "";
  String accessSecret = "";
  String expire = "";
  String secureToken = "";
  Client? client;
  Auth? auth;
//
//   final AliyunStoreManager storage = AliyunStoreManager.instanceFor(bucket: 'gs://timerbell-todo-383409.appspot.com');

  // final databaseReference = FirebaseDatabase.instance.ref();
// // 创建引用
//   final storageReference = AliyunStoreManager.instanceFor(bucket: 'gs://timerbell-3a4af.appspot.com').ref();

  static AliyunStoreManager getInstance() {
    // FirebaseDatabase.instance.ref()
    if (mAliyunStoreManagerr == null) {
      mAliyunStoreManagerr = new AliyunStoreManager();
      mAliyunStoreManagerr?.init();
    }
    return mAliyunStoreManagerr!;
  }

  Auth _authGetter({config}) {
    return auth = Auth(
      accessKey: accessKey,
      accessSecret: accessSecret,
      expire: expire,
      secureToken: secureToken,
    );
  }

  Future<void> init() async {
    bool isExpire = auth != null && auth!.isExpired == true;
    if (client == null || isExpire) {
      auth = null;
      client = null;
    }
    if (client == null) {
      BaseBean baseBean =
          await HttpManager.getInstance().doGetRequest(Apis.getOssToken);
      this.accessKey = baseBean.data["accessKeyId"];
      this.accessSecret = baseBean.data["accessKeySecret"];
      this.expire = baseBean.data['expiration'];
      this.secureToken = baseBean.data['securityToken'];
      client = Client.init(
          stsUrl: "sts.cn-hongkong.aliyuncs.com",
          ossEndpoint: "oss-cn-hongkong.aliyuncs.com",
          bucketName: "timehello",
          authGetter: _authGetter);
    }
    return;
  }

  Future uploadFile(
      {required File file,
        Function? downloadCallback
        // DocType docType = DocType.image,
        // FileExtension fileExtensionEnum: FileExtension.jpg,
        }) async {
    await this.init();
    String fileName = file.path.split('/').last;
    // String fileExt = getFileTypeByString(file.path);
    String fileType = getFileTypeByString(file.path);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    // File file = File(file.path);
    int random = Utility.getRandom(from: 1000000, max: 9999999);
    String filePath = "timehello/${fileType}/${uid}/${random}-${fileName}";
    String ossFilePathUrl =
        "${Params.mOssUrl}/timehello/${fileType}/${uid}/${random}-${fileName}";
    Response<dynamic> res = await client!.putObject(
      file.readAsBytesSync(),
      filePath,
      option: PutRequestOption(
        bucketName: "timehello",

        onSendProgress: (count, total) {
          // if (kDebugMode) {
          print("send: count = $count, and total = $total");
          downloadCallback?.call(count, total);
          // }
        },
        onReceiveProgress: (count, total) {
          // if (kDebugMode) {
          print("receive: count = $count, and total = $total");
          // }
        },
        override: true,
        aclModel: AclMode.publicWrite,
        storageType: StorageType.standard,
      ),
    );
    if (res.statusCode == 200) {
      // print("success");
      return ossFilePathUrl;
    }

    print(res);
    return "";
  }

//
//   // 上传文件
  Future uploadFileByFilePath(
      {required String path,
      DocType docType = DocType.image,
        Function? downloadCallback,
        FileExtension fileExtensionEnum: FileExtension.jpg,
      String fileName = ""}) async {
    await this.init();
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    File file = File(path);
    int random = Utility.getRandom(from: 1000000, max: 9999999);
    String filePath = "timehello/${fileType}/${uid}/${fileName}${random}.${fileExt}";
    String ossFilePathUrl =
        "${Params.mOssUrl}/timehello/${fileType}/${uid}/${fileName}${random}.${fileExt}";
    Response<dynamic> res = await client!.putObject(
      file.readAsBytesSync(),
      filePath,
      option: PutRequestOption(
        bucketName: "timehello",

        onSendProgress: (count, total) {
          // if (kDebugMode) {
          print("send: count = $count, and total = $total");
          downloadCallback?.call(count, total);
          // }
        },
        onReceiveProgress: (count, total) {
          // if (kDebugMode) {
          print("receive: count = $count, and total = $total");
          // }
        },
        override: true,
        aclModel: AclMode.publicWrite,
        storageType: StorageType.standard,
        // callback:  Callback(
        //   callbackUrl: "${Params.mUrl}/api/common/ossCallback",
        //   callbackBody:
        //   "{\"mimeType\":\${mimeType}, \"filepath\":\${object},\"size\":\${size},\"bucket\":\${bucket},\"phone\":\${x:phone}}",
        //   callbackVar: {"x:phone": "android"},
        //   calbackBodyType: CalbackBodyType.json,
        // ),
      ),
    );
    if (res.statusCode == 200) {
      // print("success");
      return ossFilePathUrl;
    }

    print(res);
    return "";
    // await Client().putObjects(
    //     [
    //       AssetEntity(
    //         filename: "/${fileType}/${uid}/${fileName}.${fileExt}",
    //         bytes: file.readAsBytesSync(),
    //         option: PutRequestOption(
    //           onSendProgress: (count, total) {
    //               print("send: count = $count, and total = $total");
    //           },
    //           onReceiveProgress: (count, total) {
    //               print(
    //                   "receive: count = $count, and total = $total");
    //           },
    //           override: true,
    //           aclModel: AclMode.inherited,
    //         ),
    //       ),
    //       AssetEntity(
    //           filename: "filename2.txt", bytes: "files2".codeUnits),
    //     ],
    // );
  }

//
  getDownloadUrl(
      {DocType docType = DocType.image,
      FileExtension fileExtensionEnum: FileExtension.jpg,
      String fileName = ""}) async {
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    Response<dynamic> s = await client!.getObject(
      "/${fileType}/${uid}/${fileName}.${fileExt}",
      onReceiveProgress: (count, total) {
        print("received = $count, total = $total");
      },
    );

    // String url = await storageReference.child("/${fileType}/${uid}/${fileName}.${fileExt}").getDownloadURL();
    //  return url;
  }


  Future<String> setString({DocType docType = DocType.md, FileExtension fileExtensionEnum: FileExtension.md, String fileName = "", required String data}) async {
    // 编码为 UTF-8
    List<int> utf8Bytes = utf8.encode(data);

    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    // TaskSnapshot snapshot = await storageReference.child("/${fileType}/${uid}/${fileName}.${fileExt}").putString(base64.encode(utf8Bytes), format: PutStringFormat.base64);
    // return snapshot;


    await this.init();
    // String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    // String fileType = getFileTypeByEnum(docType);
    // String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    // File file = File(path);
    String filePath = "timehello/${fileType}/${uid}/${fileName}.${fileExt}";
    String ossFilePathUrl =
        "${Params.mOssUrl}/timehello/${fileType}/${uid}/${fileName}.${fileExt}";
    Response<dynamic> res = await client!.putObject(
      utf8Bytes,
      filePath,
      option: PutRequestOption(
        bucketName: "timehello",

        onSendProgress: (count, total) {
          // if (kDebugMode) {
          print("send: count = $count, and total = $total");
          // }
        },
        onReceiveProgress: (count, total) {
          // if (kDebugMode) {
          print("receive: count = $count, and total = $total");
          // }
        },
        override: true,
        aclModel: AclMode.publicWrite,
        storageType: StorageType.standard,
        // callback:  Callback(
        //   callbackUrl: "${Params.mUrl}/api/common/ossCallback",
        //   callbackBody:
        //   "{\"mimeType\":\${mimeType}, \"filepath\":\${object},\"size\":\${size},\"bucket\":\${bucket},\"phone\":\${x:phone}}",
        //   callbackVar: {"x:phone": "android"},
        //   calbackBodyType: CalbackBodyType.json,
        // ),
      ),
    );
    if (res.statusCode == 200) {
      // print("success");
      return ossFilePathUrl;
    } else {
      throw Exception("Failed to setString");
    }

    print(res);
    return "";
  }

  Future<Map> getJSON({DocType docType = DocType.md, FileExtension fileExtensionEnum: FileExtension.md, String fileName = "", String? defaultVal}) async {
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager
        .getInstance()
        .getUserBean()
        .uid ?? "otherUid";
    try {
      // List<int>? list = await storageReference.child(
      //     "/${fileType}/${uid}/${fileName}.${fileExt}").getData();

      String ossFilePathUrl =
          "${Params
          .mOssUrl}/timehello/${fileType}/${uid}/${fileName}.${fileExt}";
      print("ossUrl: $ossFilePathUrl");
      BaseBean data = await HttpManager.getInstance().doGetFileContentRequest(
          ossFilePathUrl);
      return data.data;
    } catch (e) {
      print(e);
      throw Exception("Failed to getString");
      // return defaultVal ?? "";
    }
  }

  // 下载文件
  Future<String> getString({DocType docType = DocType.md, FileExtension fileExtensionEnum: FileExtension.md, String fileName = "", String? defaultVal}) async {
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
try {
  // List<int>? list = await storageReference.child(
  //     "/${fileType}/${uid}/${fileName}.${fileExt}").getData();

  String ossFilePathUrl =
      "${Params.mOssUrl}/timehello/${fileType}/${uid}/${fileName}.${fileExt}";
  BaseBean data = await HttpManager.getInstance().doGetFileContentRequest(ossFilePathUrl);
  return data.data;
} catch (e) {
  print(e);
  throw Exception("Failed to getString");
  // return defaultVal ?? "";
}
  }
//
//   void deleteFile({DocType docType = DocType.document, FileExtension fileExtensionEnum: FileExtension.json, String fileName = ""}) {
//     String fileExt = getFileExtensionByEnum(fileExtensionEnum);
//     String fileType = getFileTypeByEnum(docType);
//     String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
//     storageReference.child("/${fileType}/${uid}/${fileName}.${fileExt}").delete().then((_) {
//       print('File deleted successfully');
//     });
//   }

  // void init() {
  //   // FirebaseDatabase.instance.setPersistenceEnabled(true);
  //   // FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
  // }

//   void saveDataToFirebase(String data) {
//     try {
//       saveData(data);
//     } catch (e) {
//       print("Error saving data: $e");
// }
//   }
//
//   void saveData(String data) {
//     print("Data saved to Firebase: $data");
//   }

  String getFileTypeByEnum(DocType docType) {
    switch (docType) {
      case DocType.document:
        return "document";
      case DocType.image:
        return "image";
      case DocType.audio:
        return "audio";
      case DocType.video:
        return "video";
      case DocType.attachment:
        return "attachment";
      case DocType.md:
        return "md";
      default:
        return "others";
    }
  }
  // 返回 document image audio video attachment md others
  String getFileTypeByString(String path) {
    String extension = path.split('.').last;
    switch (extension) {
      case "md":
        return "md";
      case "json":
        return "document";
      case "txt":
        return "document";
      case "pdf":
        return "document";
      case "doc":
        return "document";
      case "docx":
        return "document";
      case "xls":
        return "document";
      case "xlsx":
        return "document";
      case "ppt":
        return "document";
      case "pptx":
        return "document";
      case "jpg":
        return "image";
      case "jpeg":
        return "image";
      case "png":
        return "image";
      case "gif":
        return "image";
      case "mp3":
        return "audio";
      case "mp4":
        return "video";
      case "avi":
        return "video";
      case "flv":
        return "video";
      case "wmv":
        return "video";
      case "mov":
        return "video";
      case "m4a":
        return "audio";
      case "m4v":
        return "video";
      case "mkv":
        return "video";
      case "rmvb":
        return "video";
      case "rm":
        return "video";
      case "wma":
        return "audio";
      case "wav":
        return "audio";
      case "aac":
        return "audio";
      case "amr":
        return "audio";
      case "zip":
        return "attachment";
      case "rar":
        return "attachment";
      case "sevenz":
        return "attachment";
      case "tar":
        return "attachment";
      case "gz":
        return "attachment";
      case "bz2":
        return "attachment";
      case "apk":
        return "attachment";
      case "exe":
        return "attachment";
      case "dmg":
        return "attachment";
      case "iso":
        return "attachment";
      case "deb":
        return "attachment";
      case "rpm":
        return "attachment";
      case "ipa":
        return "attachment";
      case "app":
        return "attachment";
      default:
        return "others";

    }
  }

  String getFileExtensionByEnum(FileExtension ext) {
    switch (ext) {
      case FileExtension.md:
        return "md";
      case FileExtension.json:
        return "json";
      case FileExtension.txt:
        return "txt";
      case FileExtension.pdf:
        return "pdf";
      case FileExtension.doc:
        return "doc";
      case FileExtension.docx:
        return "docx";
      case FileExtension.xls:
        return "xls";
      case FileExtension.xlsx:
        return "xlsx";
      case FileExtension.ppt:
        return "ppt";
      case FileExtension.pptx:
        return "pptx";
      case FileExtension.jpg:
        return "jpg";
      case FileExtension.jpeg:
        return "jpeg";
      case FileExtension.png:
        return "png";
      case FileExtension.gif:
        return "gif";
      case FileExtension.mp3:
        return "mp3";
      case FileExtension.mp4:
        return "mp4";
      case FileExtension.avi:
        return "avi";
      case FileExtension.flv:
        return "flv";
      case FileExtension.wmv:
        return "wmv";
      case FileExtension.mov:
        return "mov";
      case FileExtension.m4a:
        return "m4a";
      case FileExtension.m4v:
        return "m4v";
      case FileExtension.mkv:
        return "mkv";
      case FileExtension.rmvb:
        return "rmvb";
      case FileExtension.rm:
        return "rm";
      case FileExtension.wma:
        return "wma";
      case FileExtension.wav:
        return "wav";
      case FileExtension.aac:
        return "aac";
      case FileExtension.amr:
        return "amr";
      case FileExtension.zip:
        return "zip";
      case FileExtension.rar:
        return "rar";
      case FileExtension.sevenz:
        return "sevenz";
      case FileExtension.tar:
        return "tar";
      case FileExtension.gz:
        return "gz";
      case FileExtension.bz2:
        return "bz2";
      case FileExtension.apk:
        return "apk";
      case FileExtension.exe:
        return "exe";
      case FileExtension.dmg:
        return "dmg";
      case FileExtension.iso:
        return "iso";
      case FileExtension.deb:
        return "deb";
      case FileExtension.rpm:
        return "rpm";
      case FileExtension.ipa:
        return "ipa";
      case FileExtension.app:
        return "app";
      default:
        return "others";
    }
  }
}
