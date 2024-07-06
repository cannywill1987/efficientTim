import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';

/**
 * https://firebase.google.com/docs/storage/flutter/create-reference?hl=zh-cn
 * 这里配置bucket
 * https://console.cloud.google.com/storage/browser?project=timerbell-todo-383409&prefix=&forceOnBucketsSortingFiltering=true
 */
class FirebaseStoreManager {
  static FirebaseStoreManager? mFirebaseManager;
//
  final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: 'gs://timerbell-todo-383409.appspot.com');

  // final databaseReference = FirebaseDatabase.instance.ref();
// // 创建引用
  final storageReference = FirebaseStorage.instanceFor(bucket: 'gs://timerbell-3a4af.appspot.com').ref();

  static FirebaseStoreManager getInstance()  {
    // FirebaseDatabase.instance.ref()
    if (mFirebaseManager == null) {
      mFirebaseManager = new FirebaseStoreManager();
      // mFirebaseManager?.init();
    }
    return mFirebaseManager!;
  }

  // 上传文件
  Future<TaskSnapshot> uploadFile({required String path, DocType docType = DocType.image, FileExtension fileExtensionEnum: FileExtension.jpg, String fileName = ""}) async {
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    File file = File(path);
    TaskSnapshot taskSnapshot = await storageReference.child("/${fileType}/${uid}/${fileName}.${fileExt}").putFile(file);
    return taskSnapshot;
  }

  Future<String> getDownloadUrl({DocType docType = DocType.image, FileExtension fileExtensionEnum: FileExtension.jpg, String fileName = ""}) async {
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
   String url = await storageReference.child("/${fileType}/${uid}/${fileName}.${fileExt}").getDownloadURL();
    return url;
  }

  Future<TaskSnapshot> setString({DocType docType = DocType.md, FileExtension fileExtensionEnum: FileExtension.md, String fileName = "", required String data}) async {
    // 编码为 UTF-8
    List<int> utf8Bytes = utf8.encode(data);

    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    TaskSnapshot snapshot = await storageReference.child("/${fileType}/${uid}/${fileName}.${fileExt}").putString(base64.encode(utf8Bytes), format: PutStringFormat.base64);
    return snapshot;
  }

  // 下载文件
  Future<String> getString({DocType docType = DocType.md, FileExtension fileExtensionEnum: FileExtension.md, String fileName = "", String? defaultVal}) async {
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
try {
  List<int>? list = await storageReference.child(
      "/${fileType}/${uid}/${fileName}.${fileExt}").getData();
   // Uint8List 转string
  // String data = String.fromCharCodes(list!);
  //
  // List<int> utf8Bytes = base64.decode(data);
    String utf8String = utf8.decode(list ?? []);
    return utf8String;
  // BaseBean data = await HttpManager.getInstance().doGetFileContentRequest(url);
  // return data.data;
  // return data;
} catch (e) {
  print(e);
  return defaultVal ?? "";
}
  }

  void deleteFile({DocType docType = DocType.document, FileExtension fileExtensionEnum: FileExtension.json, String fileName = ""}) {
    String fileExt = getFileExtensionByEnum(fileExtensionEnum);
    String fileType = getFileTypeByEnum(docType);
    String? uid = LoginManager.getInstance().getUserBean().uid ?? "otherUid";
    storageReference.child("/${fileType}/${uid}/${fileName}.${fileExt}").delete().then((_) {
      print('File deleted successfully');
    });
  }

  void init() {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
  }

  void saveDataToFirebase(String data) {
    try {
      saveData(data);
    } catch (e) {
      print("Error saving data: $e");
}
  }

  void saveData(String data) {
    print("Data saved to Firebase: $data");
  }

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