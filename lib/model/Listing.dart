import 'package:flutterapps/model/UserModel.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Listing.g.dart';

@JsonSerializable()

class Listing {
  int? id;
  int? userId;
  int? type;
  String? userName;
  String? contactNumber;
  int? categoryId;
  String? categoryName;
  int? subCategoryId;
  String? subCategoryName;

  //var location: Location?

  String? detailedInformation;
  String? title;
  int? status;
  int? views;
  int? postedDate;
  String? currency;
  List? imagesPath;

  int? featuredOnDate;

  double? latitude;
  double? longitude;

  int? popularityfactor;

  String? reasonForDeletion;

  int? isFavorite;
  int? isReported;
  int? isFeatured;
  int? isBannerAd;
  int? isDealAd;

  double? dealPrice;
  int? dealEndDate;

  UserModel? user;

  Listing();

  factory Listing.fromJson(Map<String, dynamic> json) => _$ListingFromJson(json);
  Map<String, dynamic> toJson() => _$ListingToJson(this);
}

