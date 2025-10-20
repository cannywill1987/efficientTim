plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    useLibrary("org.apache.http.legacy")
    namespace = "com.timespeed.time_hello"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion


    lint {
//        disable("InvalidPackage")
        checkReleaseBuilds = false
    }

    // 配置 sourceSets，指定 jniLibs 的目录为 'src/main/libs'
    sourceSets {
        getByName("main") {
            jniLibs.srcDirs("src/main/libs")
        }
    }
    // 配置签名信息，包含 debug 和 release 两种构建类型
    signingConfigs {
        // debug 签名配置
        getByName("debug") {
            // 设置 key 的别名
            keyAlias = "sign"
            // 设置 key 的密码
            keyPassword = "linzhibin2003"
            // 设置 keystore 文件路径
            storeFile = file("sign.jks")
            // 设置 keystore 的密码
            storePassword = "linzhibin2003"
        }
        // release 签名配置
        create("release") {
            // 设置 key 的别名
            keyAlias = "sign"
            // 设置 key 的密码
            keyPassword = "linzhibin2003"
            // 设置 keystore 文件路径
            storeFile = file("sign.jks")
            // 设置 keystore 的密码
            storePassword = "linzhibin2003"
        }
    }


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // 添加本地库依赖仓库，指定 'src/main/libs' 目录
    repositories {
        flatDir {
            dirs("src/main/libs") // 指定本地库目录
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.timespeed.time_hello.efficienttime"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        multiDexEnabled = true
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            // 配置ProGuard规则文件，解决FastJSON的R8构建错误
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            // 启用代码压缩和混淆
            isMinifyEnabled = true
            isShrinkResources = true
        }
        debug {
            // Debug构建也使用ProGuard规则，确保一致性
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
    // 启用 viewBinding 功能
    buildFeatures {
        viewBinding = true // 开启视图绑定
    }
//    lint {
//        // Turns off checks for the issue IDs you specify.
//        disable += "TypographyFractions" + "TypographyQuotes"
//        // Turns on checks for the issue IDs you specify. These checks are in
//        // addition to the default lint checks.
//        enable += "RtlHardcoded" + "RtlCompat" + "RtlEnabled"
//        // To enable checks for only a subset of issue IDs and ignore all others,
//        // list the issue IDs with the 'check' property instead. This property overrides
//        // any issue IDs you enable or disable using the properties above.
//        checkOnly += "NewApi" + "InlinedApi"
//        // If set to true, turns off analysis progress reporting by lint.
//        quiet = true
//        // If set to true (default), stops the build if errors are found.
//        abortOnError = false
//        // If set to true, lint only reports errors.
//        ignoreWarnings = true
//        // If set to true, lint also checks all dependencies as part of its analysis.
//        // Recommended for projects consisting of an app with library dependencies.
//        checkDependencies = true
//    }
}

dependencies {
    //  so文件造成的崩溃问题的解决办法 需要从jni lib捞出来  https://help.aliyun.com/document_detail/40004.html
    //  https://help.aliyun.com/document_detail/190009.html
    // 引入本地AAR库，Kotlin DSL语法需要使用 mapOf 传递参数
    implementation(fileTree(mapOf("dir" to "src/main/libs", "include" to listOf("*.aar"))))
    implementation("com.android.support:appcompat-v7:28.0.0") // 推送用得上
    // implementation("com.android.support:support-v13:28.0.0")
    implementation("com.android.support:support-annotations:28.0.0") // 支持注解库
    // 引入support支持库的multidex库
    // implementation("com.android.support:multidex:1.0.3")
    // 或androidx支持库的multidex库
    implementation("androidx.multidex:multidex:2.0.1") // 支持多dex
    // todo 下面两个应该没啥用 可以考虑删除掉
    // implementation("androidx.core:core-ktx:1.5.0")
    // implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.4.3")
    implementation("com.google.android.play:integrity:1.1.0") // Google Play完整性库

    implementation("androidx.appcompat:appcompat:1.2.0") // AndroidX兼容库
    implementation("com.google.android.material:material:1.3.0") // Material组件库
    implementation("com.google.android.material:material:1.3.0") // Material组件库（重复可考虑去掉）
    // implementation("com.alibaba:fastjson:1.2.76")
    // implementation("com.mob.sdk:MobSDK2:2022.0714.1020")
//    implementation("com.huawei.agconnect:agconnect-core:1.5.2.300") // 华为AG连接核心库
    // implementation("com.facebook.android:facebook-login:latest.release")

    implementation("androidx.constraintlayout:constraintlayout:2.0.4") // 约束布局
    implementation("androidx.navigation:navigation-fragment:2.3.5") // Navigation导航组件
    implementation("androidx.navigation:navigation-ui:2.3.5") // Navigation导航UI
    implementation("androidx.work:work-runtime:2.7.1") // WorkManager任务调度
    // implementation(files("src/main/libs/alicloud-android-beacon-1.0.7.jar"))
    // implementation(files("src/main/libs/alicloud-android-crashdefend-0.0.6.jar"))
    // implementation(files("src/main/libs/alicloud-android-tool-1.0.0.jar"))
    // implementation(files("src/main/libs/alicloud-android-utdid-2.6.0.jar"))
    // implementation(files("src/main/libs/mipush-4.9.1.jar"))
    implementation(files("src/main/libs/networksdk-3.5.8.6-open.jar")) // 网络SDK
    implementation("com.alibaba:fastjson:1.2.76") // fastjson库

    implementation("com.google.firebase:firebase-auth:19.2.0") // Firebase认证
    implementation(files("src/main/libs/libammsdk.jar")) // 微信SDK
    implementation(files("src/main/libs/open_sdk_3.5.14.3_rc26220c_lite.jar")) // QQ SDK
    // implementation(files("libs/alicloud-android-beacon-1.0.7.jar"))
    // implementation(files("libs/alicloud-android-crashdefend-0.0.6.jar"))
    // implementation(files("libs/alicloud-android-tool-1.0.0.jar"))
    // implementation(files("libs/alicloud-android-utdid-2.6.0.jar"))
    // implementation(files("libs/mipush-4.9.1.jar"))
    // implementation(files("libs/networksdk-3.5.8.6-open.jar"))

    // compile("com.aliyun.ams:alicloud-android-ha-adapter:1.1.5.2-open@aar") {
    //     transitive = true
    // }
    //
    // compile("com.aliyun.ams:alicloud-android-tlog:1.1.4.4-open@aar") {
    //     transitive = true
    // }
    // implementation(files("src/main/libs/alicloud-android-tool-1.0.0.jar"))
    // implementation(files("src/main/libs/alicloud-android-ut-5.4.4.jar"))
    // implementation(files("src/main/libs/alicloud-android-utdid-2.6.0.jar"))
    // implementation(files("src/main/libs/alicloud-android-utils-2.0.0.jar"))
    // implementation(files("src/main/libs/mipush-4.9.1.jar"))
    // implementation(files("src/main/libs/networksdk-3.5.8.6-open.jar"))
    // implementation(files("src/main/libs/alicloud-android-utdid-2.5.1-proguard.jar"))
    // implementation(files("src/main/libs/alicloud-android-beacon-1.0.7.jar"))
    // implementation(files("src/main/libs/jcore-android-3.1.2.jar"))
    // implementation(files("src/main/libs/jpush-android-4.5.0.jar"))
    // implementation(files("src/main/libs/jcore-android-3.1.2.jar"))
    // implementation(files("src/main/libs/jpush-android-4.5.0.jar"))
    // testImplementation("junit:junit:4.+")
    // androidTestImplementation("androidx.test.ext:junit:1.1.2")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.3.0") // UI测试
    implementation("com.google.firebase:firebase-analytics:17.4.1") // Firebase分析
    implementation(platform("com.google.firebase:firebase-bom:31.2.3")) // Firebase BoM

    // classpath "com.tencent.android.tpns:tpnsplugin:1.8.0"
    // classpath "com.aliyun.ams:emas-services:1.0.1"

    // implementation("cn.jiguang.sdk:jpush-google:4.5.0")  // 此处以JPush 4.5.0 Google Play版本为例
    // implementation("cn.jiguang.sdk:jcore-google:3.1.2")  // 此处以JCore 3.1.2 Google Play 版本为例。
    // 阿里推送库

    // 辅助通道基础依赖

    // 华为依赖

    // 小米依赖

    // OPPO依赖

    // vivo依赖

    // 魅族依赖

    // 谷歌依赖

    // 阿里推送库
    // compile("com.aliyun.ams:alicloud-android-ha-adapter:1.1.5.2-open@aar")

    // 华为依赖
    // compile("com.aliyun.ams:alicloud-android-tlog:1.1.4.4-open@aar")
    // 辅助通道基础依赖
    // implementation("com.aliyun.ams:alicloud-android-third-push:3.7.0")
    // 小米依赖
    // compile("com.aliyun.ams:alicloud-android-third-push-xiaomi:3.7.0")
    // OPPO依赖
    // compile("com.aliyun.ams:alicloud-android-third-push-oppo:3.7.0")
    // vivo依赖
    // compile("com.aliyun.ams:alicloud-android-third-push-vivo:3.7.0")
    // 魅族依赖
    // compile("com.aliyun.ams:alicloud-android-third-push-meizu:3.7.0")
    // 谷歌依赖
    // compile("com.aliyun.ams:alicloud-android-third-push-fcm:3.7.0")
}


flutter {
    source = "../.."
}
