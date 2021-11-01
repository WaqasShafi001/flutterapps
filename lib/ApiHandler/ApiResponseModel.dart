import 'package:flutterapps/Helper/userProfileManager.dart';
import 'package:flutterapps/model/settings.dart';

import '/model/UserModel.dart';
import 'package:flutterapps/model/Listing.dart';
import 'package:flutterapps/Helper/SharedPrefs.dart';
import 'package:flutterapps/model/VideoPost.dart';
import 'package:flutterapps/model/Photo.dart';
import 'package:flutterapps/Helper/ConstantUtil.dart';

class ApiResponseModel {
  bool? success;
  String? message;
  String? authKey;

  UserModel? user;
  SettingsModel? setting;

  List<UserModel> popularUser = [];
  List<VideoPost> videosPost = [];
  List<Photo> photos = [];

  ApiResponseModel();

  factory ApiResponseModel.fromJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = json['status'] == 200;
    dynamic data = json['data'];

    print(data);

    if (model.success!) {
      model.message = json['message'];
      if (data != null && data.length > 0) {

        if (data['user'] != null) {
          model.user = UserModel.fromJson(data['user']);
          UserProfileManager().user = model.user;
          model.authKey = data['user']['auth_key'];
          if (model.authKey != null){
            SharedPrefs().setAuthorizationKey(model.authKey!);
          }
        } else if (data['category'] != null) {
          dynamic categories = data['category'];
          if (categories != null) {
            model.videosPost = List<VideoPost>.from(
                categories.map((x) => VideoPost.fromJson(x)));
          }
        } else if (data['gallary'] != null) {
          dynamic gallary = data['gallary'];
          if (gallary != null) {
            model.photos =
                List<Photo>.from(gallary.map((x) => Photo.fromJson(x)));
          }
        }
        else if (data['setting'] != null) {
          model.setting = SettingsModel.fromJson(data['setting']);
        }
      }
    } else {
      if (data == null || data == []) {
        model.message = json['message'];
      } else {
        Map errors = data['errors'];
        var errorsArr = errors[errors.keys.first] ?? [];
        String error = errorsArr.first ?? "";
        model.message = error;
      }
    }
    return model; /**/
  }

  factory ApiResponseModel.fromUsersJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = json['status'] == 200;
    dynamic data = json['data'];

    if (model.success!) {
      model.message = json['message'];
      print(data);
      if (data != null && data.length > 0) {
        if (data['user'] != null && data['user'].length > 0) {
          model.popularUser = List<UserModel>.from(
              data['user'].map((x) => UserModel.fromJson(x)));
        }
      }
    } else {
      Map errors = data['errors'];
      var errorsArr = errors[errors.keys.first] ?? [];
      String error = errorsArr.first ?? "";
      // ApplicationLocalizations.of(
      //         Navigation/**/Service.instance.getCurrentStateContext())
      //     .translate('serverError_text');
      model.message = error;
    }
    return model;
  }

  factory ApiResponseModel.fromErrorJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = false;
    model.message = json['message'];
    return model;
  }
}
