import 'package:flutterapps/model/VideoModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'VideoPost.g.dart';

@JsonSerializable()
class VideoPost {
  int? id;
  String? name;
  String? imageUrl;
  List<VideoModel>? post = [];

  VideoPost();

  factory VideoPost.fromJson(Map<String, dynamic> json) =>
      _$VideoPostFromJson(json);
  Map<String, dynamic> toJson() => _$VideoPostToJson(this);
}
