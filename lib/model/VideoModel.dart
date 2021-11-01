
import 'package:json_annotation/json_annotation.dart';
part 'VideoModel.g.dart';

@JsonSerializable()
class VideoModel {
  int? category_id;
  String? cateogry_name;
  int? created_at;
  String? description;
  int? id;
  String? imageUrl;
  int? is_premium;
  String? title;
  String? videoUrl;

  VideoModel();

  factory VideoModel.fromJson(Map<String, dynamic> json) => _$VideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}
