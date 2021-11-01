import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ApiParamModel.dart';
import 'package:flutterapps/ApiHandler/ApiResponseModel.dart';
import 'NetworkConstant.dart';
import 'package:flutterapps/Helper/SharedPrefs.dart';

class ApiController {
  final JsonDecoder _decoder = new JsonDecoder();

  Future<ApiResponseModel> loginApi(String email, String password) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.login;
    dynamic param = ApiParamModel().getLoginParam(email, password);
    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> socialLoginApi(
      String name, String socialType, String socialId, String email) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.socialLogin;
    dynamic param =
        ApiParamModel().getSocialLoginParam(name, socialType, socialId, email);
    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> registerUserApi(
      String name, String email, String password) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.register;
    dynamic param = ApiParamModel().getSignUpParam(name, email, password);
    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> forgotPasswordApi(String email) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.forgotPassword;
    return http.post(Uri.parse(url), body: {'email': email}).then(
        (http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getVideos() async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getVideos;
    String authKey = await SharedPrefs().getAuthorizationKey();
    return http.get(Uri.parse(url), headers: {"Authorization": authKey}).then(
        (http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      log('-=-=-=-=-=-=-=-=-=-=-=-${response.body}');
      print('-=-=-=-=-=-=-=-Parsed Responce=-=-=-=-${parsedResponse.message}');

      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPhotos() async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getPhotos;
    String authKey = await SharedPrefs().getAuthorizationKey();
    return http.get(Uri.parse(url), headers: {"Authorization": authKey}).then(
        (http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getUserProfile() async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getProfile;
    String authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": 'Bearer ${authKey}'
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      print(parsedResponse);

      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getSettings() async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getSettings;
    String authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": 'Bearer ${authKey}'
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      print(parsedResponse);

      return parsedResponse;
    });
  }

  Future<ApiResponseModel> setAsProUser(
      String transactionId, String amount) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.forgotPassword;
    return http.post(Uri.parse(url), body: {
      'transaction_id': transactionId,
      'amount': amount
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(response.body);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getResponse(String res) async {
    try {
      dynamic data = _decoder.convert(res);
      if (data['status'] == 401) {
        return ApiResponseModel.fromJson(
            {"message": data['message'], "isInvalidLogin": true});
      } else {
        return ApiResponseModel.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
      return ApiResponseModel.fromJson({"message": e.toString()});
    }
  }
}
