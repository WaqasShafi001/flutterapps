import 'package:flutterapps/model/UserModel.dart';

class UserProfileManager{
  static final UserProfileManager _singleton = UserProfileManager._internal();

  UserModel? user;

  factory UserProfileManager() {
    return _singleton;
  }

  UserProfileManager._internal();

  refreshProfile(){}
}
