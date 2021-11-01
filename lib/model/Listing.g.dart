// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) {
  return Listing()
    ..id = json['id'] as int?
    ..userId = json['userId'] as int?
    ..type = json['type'] as int?
    ..userName = json['userName'] as String?
    ..contactNumber = json['contactNumber'] as String?
    ..categoryId = json['categoryId'] as int?
    ..categoryName = json['categoryName'] as String?
    ..subCategoryId = json['subCategoryId'] as int?
    ..subCategoryName = json['subCategoryName'] as String?
    ..detailedInformation = json['detailedInformation'] as String?
    ..title = json['title'] as String?
    ..status = json['status'] as int?
    ..views = json['views'] as int?
    ..postedDate = json['postedDate'] as int?
    ..currency = json['currency'] as String?
    ..imagesPath = json['imagesPath'] as List<dynamic>?
    ..featuredOnDate = json['featuredOnDate'] as int?
    ..latitude = (json['latitude'] as num?)?.toDouble()
    ..longitude = (json['longitude'] as num?)?.toDouble()
    ..popularityfactor = json['popularityfactor'] as int?
    ..reasonForDeletion = json['reasonForDeletion'] as String?
    ..isFavorite = json['isFavorite'] as int?
    ..isReported = json['isReported'] as int?
    ..isFeatured = json['isFeatured'] as int?
    ..isBannerAd = json['isBannerAd'] as int?
    ..isDealAd = json['isDealAd'] as int?
    ..dealPrice = (json['dealPrice'] as num?)?.toDouble()
    ..dealEndDate = json['dealEndDate'] as int?
    ..user = json['user'] == null
        ? null
        : UserModel.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': instance.type,
      'userName': instance.userName,
      'contactNumber': instance.contactNumber,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'subCategoryId': instance.subCategoryId,
      'subCategoryName': instance.subCategoryName,
      'detailedInformation': instance.detailedInformation,
      'title': instance.title,
      'status': instance.status,
      'views': instance.views,
      'postedDate': instance.postedDate,
      'currency': instance.currency,
      'imagesPath': instance.imagesPath,
      'featuredOnDate': instance.featuredOnDate,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'popularityfactor': instance.popularityfactor,
      'reasonForDeletion': instance.reasonForDeletion,
      'isFavorite': instance.isFavorite,
      'isReported': instance.isReported,
      'isFeatured': instance.isFeatured,
      'isBannerAd': instance.isBannerAd,
      'isDealAd': instance.isDealAd,
      'dealPrice': instance.dealPrice,
      'dealEndDate': instance.dealEndDate,
      'user': instance.user,
    };
