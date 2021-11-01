// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo()
    ..id = json['id'] as int?
    ..imageUrl = json['imageUrl'] as String?
    ..status = json['status'] as int?
    ..created_at = json['created_at'] as int?;
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'status': instance.status,
      'created_at': instance.created_at,
    };
