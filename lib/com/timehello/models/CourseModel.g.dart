// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CourseModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      tagName: json['tagName'] as String?,
      folderTitle: json['folderTitle'] as String?,
      authorIntro: json['authorIntro'] as String?,
      courseIntro: json['courseIntro'] as String?,
      languageCode: json['languageCode'] as String?,
      courseDetailPlan: json['courseDetailPlan'] as String?,
      imageSmallUrls: (json['imageSmallUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageBigUrls: (json['imageBigUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageOriginUrls: (json['imageOriginUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      type: json['type'] as int?,
      password: json['password'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      courseFid: json['courseFid'] as String?,
      uid: json['uid'] as String?,
      authorAvatar: json['authorAvatar'] as String?,
      authorName: json['authorName'] as String?,
      created_at: json['created_at'] as int?,
      updated_at: json['updated_at'] as int?,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..objectId = json['_id'] as String?
      ..code = json['code'] as String?
      ..backgroundUrl = json['backgroundUrl'] as String?
      ..countryCode = json['countryCode'] as String?
      ..isEditable = json['isEditable'] as bool?
      ..verifiedtatus = json['verifiedtatus'] as int?
      ..otherUids = json['otherUids'] as List<dynamic>?
      ..otherUserInfo = json['otherUserInfo'] as List<dynamic>?;

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': instance.objectId,
      'id': instance.id,
      'title': instance.title,
      'tagName': instance.tagName,
      'code': instance.code,
      'folderTitle': instance.folderTitle,
      'authorIntro': instance.authorIntro,
      'courseIntro': instance.courseIntro,
      'courseDetailPlan': instance.courseDetailPlan,
      'backgroundUrl': instance.backgroundUrl,
      'imageSmallUrls': instance.imageSmallUrls,
      'imageBigUrls': instance.imageBigUrls,
      'imageOriginUrls': instance.imageOriginUrls,
      'countryCode': instance.countryCode,
      'languageCode': instance.languageCode,
      'type': instance.type,
      'isEditable': instance.isEditable,
      'password': instance.password,
      'price': instance.price,
      'courseFid': instance.courseFid,
      'uid': instance.uid,
      'authorAvatar': instance.authorAvatar,
      'authorName': instance.authorName,
      'verifiedtatus': instance.verifiedtatus,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'otherUids': instance.otherUids,
      'otherUserInfo': instance.otherUserInfo,
    };
