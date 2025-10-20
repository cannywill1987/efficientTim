# FastJSON ProGuard 规则 - 忽略Android上不存在的桌面Java类
# 这些规则告诉ProGuard忽略缺失的类，避免R8构建错误

# 忽略AWT相关类（桌面Java图形界面类，Android不支持）
-dontwarn java.awt.**
-dontwarn javax.swing.**

# 忽略JSR相关类（Java规范请求相关类）
-dontwarn javax.money.**
-dontwarn javax.ws.rs.**
-dontwarn javax.ws.rs.ext.**

# 忽略Jersey相关类
-dontwarn org.glassfish.jersey.**

# 忽略Joda Time相关类（如果使用了时间处理库）
-dontwarn org.joda.time.**

# 忽略Spring相关类
-dontwarn springfox.documentation.**

# 保持FastJSON的核心功能
-keep class com.alibaba.fastjson.** { *; }
-keep class com.alibaba.fastjson.serializer.** { *; }
-keep class com.alibaba.fastjson.parser.** { *; }

# 保持FastJSON的注解
-keep @interface com.alibaba.fastjson.annotation.*
-keep class * implements com.alibaba.fastjson.serializer.ObjectSerializer
-keep class * implements com.alibaba.fastjson.parser.deserializer.ObjectDeserializer

# 保持枚举类
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# 保持序列化相关的类
-keepclassmembers class * {
    @com.alibaba.fastjson.annotation.JSONField <fields>;
}

# 忽略所有缺失类的警告
-ignorewarnings
