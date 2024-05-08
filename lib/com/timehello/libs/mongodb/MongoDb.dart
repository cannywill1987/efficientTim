class MongoDb {
  //Bmob REST API 地址
  static String mongoHost = "https://api2.bmob.cn";

  //Bmob 应用ID，不可泄漏
  static String mongoAppId = "";

  //Bmob REST API 密钥，不可泄漏
  static String mongoRestApiKey = "";

  //Bmob REST API 管理密钥 超级权限Key，不可泄漏
  static String mongoMasterKey = "";

  //SDK安全密钥，不可泄漏
  static String mongoSecretKey = "";

  //SDK安全码，不可泄漏
  static String mongoApiSafe = "";

  //固定
  static final String mongoSDKType = "Flutter";

  //固定
  static final String mongoSDKVersion = "10";

  static const String MONGODB_PROPERTY_OBJECT_ID = "_id";
  static const String MONGODB_PROPERTY_CREATED_AT = "createdAt";
  static const String MONGODB_PROPERTY_UPDATED_AT = "updatedAt";
  static const String MONGODB_PROPERTY_SESSION_TOKEN = "sessionToken";

  static const String MONGODB_KEY_TYPE = "__type";
  static const String MONGODB_KEY_CLASS_NAME = "className";
  static const String MONGODB_KEY_RESULTS = "results";

  static const String MONGODB_API_VERSION = "/1";
  static const String MONGODB_API_FILE_VERSION = "/2";
  static const String MONGODB_API_CLASSES = MONGODB_API_VERSION + "/classes/";
  static const String MONGODB_API_USERS = MONGODB_API_VERSION + "/users";

  static const String MONGODB_API_REQUEST_PASSWORD_RESET =
      MONGODB_API_VERSION + "/requestPasswordReset";

  static const String MONGODB_API_REQUEST_PASSWORD_BY_SMS_CODE =
      MONGODB_API_VERSION + "/resetPasswordBySmsCode";

  static const String MONGODB_API_REQUEST_UPDATE_USER_PASSWORD =
      MONGODB_API_VERSION + "/updateUserPassword";

  static const String MONGODB_API_BATCH = MONGODB_API_VERSION + "/batch";

  static const String MONGODB_API_REQUEST_REQUEST_EMAIL_VERIFY =
      MONGODB_API_VERSION + "/requestEmailVerify";

  static const String MONGODB_API_LOGIN = MONGODB_API_VERSION + "/login";
  static const String MONGODB_API_SLASH = "/";
  static const String MONGODB_API_SEND_SMS_CODE =
      MONGODB_API_VERSION + "/requestSmsCode";
  static const String BMOB_API_VERIFY_SMS_CODE =
      MONGODB_API_VERSION + "/verifySmsCode/";
  static const String MONGODB_API_TIMESTAMP = "/timestamp";
  static const String MONGODB_API_FILE = "/files";

  static const String MONGODB_TYPE_POINTER = "Pointer";

  static const String MONGODB_CLASS_BMOB_USER = "BmobUser";

  static const String MONGODB_CLASS_BMOB_INSTALLATION = "BmobInstallation";

  static const String MONGODB_TABLE_USER = "_User";

  static const String MONGODB_TABLE_INSTALLATION = "_Installation";

  static const String MONGODB_ERROR_OBJECT_ID = "ObjectId is null or empty.";

  static const int MONGODB_ERROR_CODE_LOCAL = 1001;

  static const String MONGODB_TABLE_TOLE = "_Role";

  //SDK初始化
  static void init(appHost, appId, apiKey) {
    mongoHost = appHost;
    mongoAppId = appId;
    mongoRestApiKey = apiKey;
  }

  //SDK初始化，包含master key，允许操作其他用户
  static void initMasterKey(appHost, appId, apiKey, masterKey) {
    init(appHost, appId, apiKey);
    mongoMasterKey = masterKey;
  }

  //SDK初始化，加密请求格式
  static void initEncryption(appHost, secretKey, apiSafe) {
    mongoHost = appHost;
    mongoSecretKey = secretKey;
    mongoApiSafe = apiSafe;
  }

  //SDK初始化，加密请求格式，包含master key，允许操作其他用户
  static void initEncryptionMasterKey(appHost, secretKey, apiSafe, masterKey) {
    initEncryption(appHost, secretKey, apiSafe);
    mongoMasterKey = masterKey;
  }
}
