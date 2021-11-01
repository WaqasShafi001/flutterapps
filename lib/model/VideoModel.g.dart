// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VideoModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) {
  return VideoModel()
    ..category_id = json['category_id'] as int?
    ..cateogry_name = json['cateogry_name'] as String?
    ..created_at = json['created_at'] as int?
    ..description = json['description'] as String?
    ..id = json['id'] as int?
    ..imageUrl = json['imageUrl'] as String?
    ..is_premium = json['is_premium'] as int?
    ..title = json['title'] as String?
    ..videoUrl = json['videoUrl'] as String?;
}

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'category_id': instance.category_id,
      'cateogry_name': instance.cateogry_name,
      'created_at': instance.created_at,
      'description': instance.description,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'is_premium': instance.is_premium,
      'title': instance.title,
      'videoUrl': instance.videoUrl,
    };
