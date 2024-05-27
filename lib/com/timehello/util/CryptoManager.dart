import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/components/PasswordWidget.dart';
import 'package:time_hello/com/timehello/components/TwoPasswordWidget.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/models/MissionModel.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/OverlayManagement.dart';
import 'package:time_hello/com/timehello/util/SharePreferenceUtil.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../r.dart';
import '../config/Params.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/**
 * 用于设计样式管理
 */
class CryptoManager {
  static CryptoManager? mCryptoManager;

  // String password = "";
  Map folderPasswordMap = Map<String,
      String>(); // key folderId value 加密的Missionmodel Title 主要是因为mongoapismanager的title

  static CryptoManager getInstance({AdaptiveThemeMode? themeMode}) {
    if (mCryptoManager == null) {
      mCryptoManager = new CryptoManager();
      mCryptoManager?.init(themeMode);
    }
    return mCryptoManager!;
  }

  init([AdaptiveThemeMode? adaptiveTheme]) {
    try {
      String passwordEncrypt = SharePreferenceUtil.getSyncInstance().getString(
          key: ShareprefrenceKeys.defaultPasswordKey, defaultVal: "");
      // if (!TextUtil.isEmpty(passwordEncrypt)) {
      //   this.password = Utility.decryptCTRAES(
      //       passwordEncrypt, Params.AES_MY_MISSION_PASSWORD);
      // }
    } catch (e) {}
  }

  /**
   * 是否有密码
   */
  String hashPassword(String password) {
    // 使用SHA-256哈希函数将密码转换为256位密钥
    var bytes = utf8.encode(password); // 数据转换为utf8字节
    var digest = sha256.convert(bytes); // SHA-256哈希
    return digest.toString().substring(0, 32); // 返回十六进制字符串
  }

  /**
   * 插入任务时判断是否需要设置密码
   */
  Future<bool> checkFolderModelSecurityPasswordSetting({folderId = ""}) async {
    if (TextUtil.isEmpty(folderId) == true) {
      return Future.value(true);
    }
    //是否有密码
    bool res = this.shouldMissionModelEncrypt(folderId);
    // missionmodel是否需要加密
    if (res == true) {
      //是否设置了正确的密码 isCorrect 密码是否正确 0 密码错误 1 密码正确 2 没有任务
      int isCorrect = this.isPasswordCorrectForFolderModel(folderId: folderId);
      // 密码正确直接操作
      if (isCorrect == 1 || isCorrect == 2) {
        return Future.value(true);
      } else {
//密码不正确弹出密码框
        bool res = await this.showTwoPasswordDialog(folderId: folderId);
        // 密码设置成功返回true
        return res;
      }
    }
    //不需要设置密码返回true
    return Future.value(true);
  }

  /**
   * 插入任务时判断是否需要设置密码 需要显示红点
   */
  shouldShowRedDotForFolderModel({folderId = ""}) {
    if (TextUtil.isEmpty(folderPasswordMap[folderId])) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * 密码是否正确
   */
  bool isPasswordCorrectForPassword(
      {required String folderId, required String password}) {
    try {
      List<MissionModel>? listMissionModels = MongoApisManager.getInstance()
          .queryEncryptMissioinModelsByFolderId(folderId: folderId);
      if (listMissionModels == null || listMissionModels.length == 0) {
        return true;
      }
      if (listMissionModels != null) {
        String titleEncrypted = folderPasswordMap[folderId ?? ""];
        // MissionModel missionModel = listMissionModels[0];
        // String password = this.getDigitPassword(folderId: folderId);
        String res =
            Utility.decryptCTRAES(titleEncrypted ?? "", hashPassword(password));
        return true;
      }
      // }
      return false;
    } catch (e) {
      return false;
    }
    // }
  }

  /**
   * folderId 密码是否正确 0 密码错误 1 密码正确 2 没有任务
   */
  int isPasswordCorrectForFolderModel({required String folderId}) {
    try {
      List<MissionModel>? listMissionModels = MongoApisManager.getInstance()
          .queryEncryptMissioinModelsByFolderId(folderId: folderId);
      if (listMissionModels == null || listMissionModels.length == 0) {
        return 2;
      }
      if (listMissionModels != null) {
        String titleEncrypted = folderPasswordMap[folderId ?? ""];
        // MissionModel missionModel = listMissionModels[0];
        String password = this.getDigitPassword(folderId: folderId);
        if (TextUtil.isEmpty(password)) {
          return 0;
        }
        String res =
            Utility.decryptCTRAES(titleEncrypted ?? "", hashPassword(password));
        return 1;
      }
      // }
      return 0;
    } catch (e) {
      return 0;
    }
    // }
  }

  /**
   * 点击安全按钮弹出密码框
   */
  updateMissionModelList(
      {required List<MissionModel> listMissionModelsTmp}) async {
    MongoApisManager.getInstance().listMissionModels =
        await CryptoManager.getInstance().batchDecryptMissionModels(
            MongoApisManager.getInstance().listMissionModels);
    // List<MissionModel> missionModels = await CryptoManager.getInstance().batchDecryptMissionModels(listMissionModelsTmp);
    // MongoApisManager.getInstance().listMissionModels.forEach((element) {
    //   missionModels.forEach((element2) {
    //     if(element.objectId == element2.objectId) {
    //       element.title = element2.title;
    //     }
    //   });
    // });
    // MongoApisManager.getInstance().listMissionModels = missionModels;
    await Utility.initCalendarModel();
  }

  /**
   * true表示可以执行 false表示不可以执行
   */
  Future<bool> showTwoPasswordDialog({folderId = "", Function? okCallback}) async {
    GlobalKey<TwoPasswordWidgetState>? passwordWidgetStateGlobalKey = GlobalKey();
    if (TextUtil.isEmpty(folderId) == true) {
      return true;
    }
    FolderModel? folderModel =
        MongoApisManager.getInstance().queryfolderModelWithFolderId(folderId);
    Future.delayed(Duration(milliseconds: 500), () {
      if (folderModel == null) {
        return;
      }
      String password = this.getDigitPassword(folderId: folderId);
      if (TextUtil.isEmpty(password) == true) {
        password = "";
      }
      passwordWidgetStateGlobalKey?.currentState?.setPassword1(password);
      passwordWidgetStateGlobalKey?.currentState?.setPassword2(password);
    });
    // OverlayManagement.getInstance().show
    bool? result = await DialogManagement.getInstance().showAsyncCustomDialog(
        Utility.getGlobalContext(),
        cancelText: getI18NKey().cancel, okCallback: () {
      // if (okCallback != null) {
      //校验密码是否正确
      bool res =
          passwordWidgetStateGlobalKey?.currentState?.checkPassword() ?? false;
      //密码不正确 应该弹出toast checkPassword 已经弹出了 所以没必要在弹出一遍
      if (!res) {
        // DialogManagement.getInstance()
        //     .hideDialog(Utility.getGlobalContext(), false);
        return;
      }
      // 得到当前密码
      String password =
          passwordWidgetStateGlobalKey?.currentState?.getPassword1() ?? "";
      // this.setDigitPassword(folderId: folderId, password: password);
      setDigitPassword(folderId: folderId, password: password);
      okCallback?.call(password);
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), true);
      return;
      // }
    }, cancelCallback: () {
      DialogManagement.getInstance()
          .hideDialog(Utility.getGlobalContext(), false);
      return;
    },
        okText: getI18NKey().confirm,
        child: Container(
          width: 400,
          child: Column(
            children: [
              Utility.getSVGPicture(R.assetsImgIcSecure, size: 80),
              SizedBox(
                height: 20,
              ),
              Text(
                getI18NKey()
                    .please_input_folder_password(folderModel?.title ?? ""),
                style: TextStyle(
                    fontSize: 18,
                    color: ThemeManager.getInstance().getTextColor()),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                getI18NKey().local_password_desc,
                style: TextStyle(fontSize: 14, color: Color(0xff999999)),
              ),
              SizedBox(
                height: 20,
              ),
              TwoPasswordWidget(
                key: passwordWidgetStateGlobalKey,
              ),
            ],
          ),
        ));
    if (result == null) {
      return true;
    } else {
      return result;
    }
  }

  /**
   * FolderModel判断是不是需要给missionmodel加密
   */
  shouldMissionModelEncrypt(String folderId) {
    FolderModel? folderModel =
        MongoApisManager.getInstance().getFolderModelByFolderId(folderId);
    return (folderModel?.cryptoVersion ?? -1) >= 0 ? true : false;
  }

  clearDigitPassword({String? folderId}) {
    String password = this.getDigitPassword(folderId: folderId);
    SharePreferenceUtil.getSyncInstance().setString(
        key: ShareprefrenceKeys.defaultPasswordKey + (folderId ?? ""),
        content: password);
  }

  setDigitPassword({String password = "", required String folderId}) {
    try {
      if (TextUtil.isEmpty(password)) {
        return;
      }
      SharePreferenceUtil.getSyncInstance().setString(
          key: ShareprefrenceKeys.defaultPasswordKey + (folderId ?? ""),
          content:
              Utility.encryptCTRAES(password, Params.AES_MY_MISSION_PASSWORD));
    } catch (e) {}
  }

  String getDigitPassword({String? folderId}) {
    try {
      String contentEncrypt = SharePreferenceUtil.getSyncInstance().getString(
          key: ShareprefrenceKeys.defaultPasswordKey + (folderId ?? ""),
          defaultVal: "");
      if (TextUtil.isEmpty(contentEncrypt)) {
        return "";
      }
      String digitPassword =
          Utility.decryptCTRAES(contentEncrypt, Params.AES_MY_MISSION_PASSWORD);
      return digitPassword;
    } catch (e) {
      return "";
    }
  }

  /**
   * 判断是否设置了密码
   */
  static isMyDigitPasswordSet({String? folderId}) {
    return !TextUtil.isEmpty(SharePreferenceUtil.getSyncInstance().getString(
        key: ShareprefrenceKeys.defaultPasswordKey + (folderId ?? ''),
        defaultVal: ""));
  }

  Future<List<FolderModel>> batchEncryptFolderModels(
      List<FolderModel> listFolderModel, String key) async {
    List<Future<FolderModel>> listMissionModelToEncrypt = [];
    listFolderModel.forEach((FolderModel missionModel) {
      if (!TextUtil.isEmpty(missionModel.title) &&
          (missionModel.cryptoVersion ?? -1) >= 0) {
        listMissionModelToEncrypt
            .add(encryptFolderModelTitle(missionModel, key));
      }
    });
    List<FolderModel> list = await Future.wait(listMissionModelToEncrypt);
    return list;
  }

  Future<List<FolderModel>> batchDecryptFolderModels(
      List<FolderModel> listFolderModel) async {
    List<Future<FolderModel>> listFolderModelToDecrypt = [];
    List<FolderModel> listFolderModelRest = [];
    listFolderModel.forEach((FolderModel folderModel) {
      if (!TextUtil.isEmpty(folderModel.objectId) &&
          !TextUtil.isEmpty(folderModel.title) &&
          (folderModel.cryptoVersion ?? -1) >= 0) {
        try {
          String password = getDigitPassword(folderId: folderModel.objectId);
          listFolderModelToDecrypt
              .add(decryptFolderModelTitle(folderModel, password));
        } catch (e) {
          listFolderModelRest.add(folderModel);
        }
      } else {
        listFolderModelRest.add(folderModel);
      }
    });
    List<FolderModel> list = await Future.wait(listFolderModelToDecrypt);
    list.addAll(listFolderModelRest);
    return list;
  }


  List<MissionModel> batchEncryptMissionModels(
      List<MissionModel> listMissionModel) {
    for (int i = 0; i < listMissionModel.length; i++) {
      MissionModel missionModel = listMissionModel[i];
      if (!TextUtil.isEmpty(missionModel.title) &&
          (missionModel.cryptoVersion ?? -1) == -1 && (missionModel?.hasDecrypted ?? false == true )) {
        missionModel.cryptoVersion = 0;
        missionModel.hasDecrypted = false;
        encryptMissionModelTitle(missionModel);
      }
    }
    return listMissionModel;
  }

  Future<List<MissionModel>> batchEncryptMissionModelsForFolderId(
      {required String folderId, required String password}) async {
    List<MissionModel> listMissionModel = MongoApisManager.getInstance()
        .queryMissioinModelsByFolderId(folderId: folderId);
    for (int i = 0; i < listMissionModel.length; i++) {
      MissionModel missionModel = listMissionModel[i];
      if (!TextUtil.isEmpty(missionModel.title) &&
          (missionModel.cryptoVersion ?? -1) == -1) {
        missionModel.cryptoVersion = 0;
        listMissionModel[i] =
            await this.encryptMissionModelTitle(missionModel, password);
      }
    }
    await MongoApisManager.getInstance()
        .batchUpdate_MissionModelWithParams(listMissionModel: listMissionModel);

    List<Future<MissionModel>> listMissionModelToEncrypt = [];
    String? key;
    listMissionModel.forEach((MissionModel missionModel) {
      if (!TextUtil.isEmpty(missionModel.title) &&
          (missionModel.cryptoVersion ?? -1) >= 0) {
        if (key == null) {
          key = getDigitPassword(folderId: missionModel.folder_id ?? "");
        }
        listMissionModelToEncrypt
            .add(this.encryptMissionModelTitle(missionModel));
      }
    });
    List<MissionModel> list = await Future.wait(listMissionModelToEncrypt);
    return list;
  }

  // Future<List<MissionModel>> batchEncryptMissionModels(
  //     List<MissionModel> listMissionModel) async {
  //   List<Future<MissionModel>> listMissionModelToEncrypt = [];
  //   String? key;
  //   listMissionModel.forEach((MissionModel missionModel) {
  //     if (!TextUtil.isEmpty(missionModel.title) &&
  //         (missionModel.cryptoVersion ?? -1) >= 0) {
  //       if (key == null) {
  //         key = getDigitPassword(folderId: missionModel.folder_id ?? "");
  //       }
  //       listMissionModelToEncrypt
  //           .add(this.encryptMissionModelTitle(missionModel));
  //     }
  //   });
  //   List<MissionModel> list = await Future.wait(listMissionModelToEncrypt);
  //   return list;
  // }

  Future<List<MissionModel>> batchAndUpdateDecryptMissionModels(
      {required String folderId}) async {
    //从加密模式切换到不加密moshi
    List<MissionModel> listMissionModel = MongoApisManager.getInstance()
        .queryEncryptMissioinModelsByFolderId(folderId: folderId);
    listMissionModel.forEach((MissionModel missionModel) {
      missionModel.cryptoVersion = -1;
    });
    await MongoApisManager.getInstance()
        .batchUpdate_MissionModelWithParams(listMissionModel: listMissionModel);
    return listMissionModel;
    // CryptoManager.getInstance()
    //     .batchDecryptMissionModels(
    //     listMissionModel);
  }


  /**
   * 批量解密需要解密的 cryptoVersion=0的 -1不需要解密
   */
  Future<List<MissionModel>> batchDecryptMissionModels(
      List<MissionModel> listMissionModel) async {
    //需要重新初始化密码
    folderPasswordMap = {};
    List<MissionModel> listMissionModelToDecrypt = [];
    List<MissionModel> listMissionModelRest = [];
    String? key;
    Map folderIdPasswordMap = {}; // {folderId:password}
    listMissionModel.forEach((MissionModel missionModel) async {
      if (!TextUtil.isEmpty(missionModel.title) &&
          (missionModel.cryptoVersion ?? -1) >= 0) {
        // if (key == null) {
        //避免多次解密
        if (!folderIdPasswordMap.containsKey(missionModel.folder_id ?? "")) {
          key = getDigitPassword(folderId: missionModel.folder_id ?? "");
          folderIdPasswordMap[missionModel.folder_id ?? ""] = key;
        } else {
          key = folderIdPasswordMap[missionModel.folder_id ?? ""];
        }
        // }
        MissionModel? missionModelTmp =
            await this.decryptMissionModelTitle(missionModel, key ?? "");
        //解密成功证明有missionModelTmp
        if (missionModelTmp != null) {
          folderPasswordMap[missionModel.folder_id ?? ""] =
              missionModel.title ?? "";
          missionModel.hasDecrypted = true;
        }
        listMissionModelToDecrypt.add(missionModelTmp ?? missionModel);
      } else {
        listMissionModelRest.add(missionModel);
      }
    });
    List<MissionModel> list = listMissionModelToDecrypt;
    list.addAll(listMissionModelRest);
    return list;
  }

  Future<FolderModel> decryptFolderModelTitle(
      FolderModel folderModel, String key) async {
    if (!TextUtil.isEmpty(folderModel.title) &&
        (folderModel.cryptoVersion ?? -1) >= 0) {
      try {
        folderModel.title = await Utility.decryptCTRAES(
            folderModel.title!, this.hashPassword(key));
      } catch (e) {
        return folderModel;
      }
    }
    return folderModel;
  }

  Future<FolderModel> encryptFolderModelTitle(
      FolderModel folderModel, String key) async {
    if (!TextUtil.isEmpty(folderModel.title) &&
        (folderModel.cryptoVersion ?? -1) >= 0) {
      folderModel.title = await Utility.encryptCTRAES(
          folderModel.title!, this.hashPassword(key));
      String title = await Utility.decryptCTRAES(
          folderModel.title!, this.hashPassword(key));
      print("title: $title");
    }
    return folderModel;
  }

  Future<MissionModel?> decryptMissionModelTitle(
      MissionModel missionModel, String key) async {
    if (!TextUtil.isEmpty(missionModel.title) &&
        (missionModel.cryptoVersion ?? -1) >= 0) {
      try {
        missionModel.title = await Utility.decryptCTRAES(
            missionModel.title!, this.hashPassword(key));
      } catch (e) {
        return null;
      }
    }
    return missionModel;
  }

  Future<MissionModel> encryptMissionModelTitle(MissionModel missionModel,
      [String? key]) async {
    if (!TextUtil.isEmpty(missionModel.title) &&
        (missionModel.cryptoVersion ?? -1) >= 0) {
      //通过folderid的password加密
      String keyTmp =
          key ?? getDigitPassword(folderId: missionModel.folder_id ?? "");
      missionModel.title = await Utility.encryptCTRAES(
          missionModel.title!, this.hashPassword(keyTmp));
      String title = await Utility.decryptCTRAES(
          missionModel.title!, this.hashPassword(keyTmp));
      print("title: $title");
    }
    return missionModel;
  }

//
// static String decryptCTRAES(String encryptedText, String keyTmp) {
//   final key = encrypt.Key.fromUtf8(keyTmp);
//   final iv = encrypt.IV.fromUtf8(Params.AES_IV);
//   final encrypter = encrypt.Encrypter(encrypt.AES(key));
//   encrypt.Encrypted encrypted = encrypter.encrypt(encryptedText, iv: iv);
//   return encrypted.base64;
//
//   // final key = encrypt.Key.fromUtf8(keyTmp);
//   // final iv = encrypt.IV.fromUtf8(Params.AES_IV);
//   // final encrypter = encrypt.Encrypter(encrypt.AES(key));
//   // final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
//   // return decrypted;
// }
//
// /**
//  * CTR可以加密
//  */
// static String encryptCTRAES(String plainText, String keyTmp) {
//   final key = encrypt.Key.fromUtf8(keyTmp);
//   final iv = encrypt.IV.fromUtf8(Params.AES_IV);
//   final encrypter = encrypt.Encrypter(encrypt.AES(key));
//   encrypt.Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
//   return encrypted.base64;
//
//   // final key = encrypt.Key.fromUtf8(keyTmp);
//   // final iv = encrypt.IV.fromUtf8(Params.AES_IV);
//   // final encrypter = encrypt.Encrypter(encrypt.AES(key));
//   // encrypt.Encrypted encrypted = encrypter.encrypt(plainText, iv: iv);
//   // return encrypted.base64;
// }
}
