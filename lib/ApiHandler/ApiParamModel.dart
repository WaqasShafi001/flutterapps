import 'dart:io';

class ApiParamModel {
  dynamic getLoginParam(String email, String password) {
    return {
      "email": email,
      "password": password,
      "device_type": Platform.isAndroid ? '1' : '2',
      "device_token": "sfjf34872sdlkfjsu834dskfjisdaaaa"
    };
  }

  dynamic getSocialLoginParam(
      String name, String socialType, String socialId, String email) {
    return {
      "name": name,
      "social_type": socialType,
      "social_id": socialId,
      "email": email,
      "device_type": Platform.isAndroid ? '1' : '2',
      "device_token": "sfjf34872sdlkfjsu834dskfjisdaaaa"
    };
  }

  dynamic getSignUpParam(String name, String email, String password) {
    return {
      "name": name,
      "username": email,
      "email": email,
      "password": password,
      "device_type": Platform.isAndroid ? '1' : '2',
      "device_token": "sfjf34872sdlkfjsu834dskfjisdaaaa",
      "country_id": "101"
    };
  }

  dynamic getSearchListinhParam(String title, String categoryId, String subCategoryId, String minPrice,
      String maxPrice, String countryId, String cityId, String userId, String packageBannerId, String isFeatured) {
    return {
      "title": title,
      "category_id": categoryId,
      "sub_category_id": subCategoryId,
      "min_price": minPrice,
      "max_price": maxPrice,
      "country_id": countryId,
      "city_id": cityId,
      "user_id": userId,
      "package_banner_id": packageBannerId,
      "featured": isFeatured
    };
  }
}
