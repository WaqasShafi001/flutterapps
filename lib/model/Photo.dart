import 'package:json_annotation/json_annotation.dart';
part 'Photo.g.dart';

@JsonSerializable()
class Photo {
  int? id;
  String? imageUrl;
  int? status;
  int? created_at;

  Photo();

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
