// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VideoPost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPost _$VideoPostFromJson(Map<String, dynamic> json) {
  return VideoPost()
    ..id = json['id'] as int?
    ..name = json['name'] as String?
    ..imageUrl = json['imageUrl'] as String?
    ..post = (json['post'] as List<dynamic>?)
        ?.map((e) => VideoModel.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$VideoPostToJson(VideoPost instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'post': instance.post,
    };
