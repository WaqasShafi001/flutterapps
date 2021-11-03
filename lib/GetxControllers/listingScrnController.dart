// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterapps/GetxControllers/CategoryGetModel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ListingScreenController extends GetxController {
  var videoCategoryPosts = [].obs;
  var categoryIdList = <String?>[].obs;
  var categoryNameList = [].obs;
  var idOfCategory = 0.obs;
  var listOfCategoryIDfromAPI = <int?>[].obs;
  var categoryAllList = [].obs;

  var videoIDForUpdateApi = 0.obs;

  @override
  void onInit() {
    getCategoryMethod();

    super.onInit();
  }

  // TextEditingController categoryTextController = TextEditingController();

  TextEditingController titleTextController = TextEditingController();

  TextEditingController descriptionTextController = TextEditingController();

  var image = File('').obs;
  var video = File('path').obs;

  var isImagePicked = false.obs;
  var isVideoPicked = false.obs;

  final ImagePicker _picker = ImagePicker();

  chooseImage() async {
    try {
      final pickedFile = await _picker.getImage(
        source: ImageSource.gallery,
      );
      isImagePicked.value = true;
      compressImage(pickedFile);
      // image.value = pickedFile!;
      // print(
      //     'imageeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ${image.value.path}');

    } catch (e) {}
  }

  compressImage(PickedFile? f) async {
    final filePath = f!.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
        filePath, outPath,
        minWidth: 800, minHeight: 1500, quality: 60);
    image.value = compressedImage!;
    print('this is compressed image ========= ${image.value.path}');
  }

  File videoFile = File('');
  chooseVideo() async {
    try {
      final pickedFile = await _picker.getVideo(
        source: ImageSource.gallery,
      );
      isVideoPicked.value = true;
      videoFile = File('${pickedFile!.path}');
      print('path is=${videoFile.path}');
      // compressVideo(pickedFile);

      // video.value = pickedFile!;

      // print(
      //     'videooooooooooooooooooooooooooooooooooooooooooooooooo  ${video.value.path}');

    } catch (e) {}
  }

  // compressVideo(PickedFile? f) async {
  //   final filePath = f!.path;
  //   final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
  //     filePath,
  //     quality: VideoQuality.DefaultQuality,
  //     deleteOrigin: false,
  //     includeAudio: true,
  //   );
  //   video.value = mediaInfo!.file!;

  //   print(
  //       'this is coompressed video ========= ${video.value.path} and its size is ${mediaInfo.filesize}');
  // }

  Future uploadVideoToNetwork() async {
    dio.FormData formData = dio.FormData.fromMap({
      'image': await dio.MultipartFile.fromFile(
        image.value.path,
        filename: basename(image.value.path),
      ),
      'video': await dio.MultipartFile.fromFile(videoFile.path,
          filename: basename(videoFile.path))
    });

    final response = await dio.Dio().post(
      'https://starwebapk.com/mobile_api/public/api/createpost?category_id=${idOfCategory.value}&title=${titleTextController.text}&description=${descriptionTextController.text}&is_premium=1',
      data: formData,
      options: dio.Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    if (response.data['status'] == true) {
      // isLoading.value = true;
      EasyLoading.dismiss();
      Get.snackbar(
        'congrats!',
        '${response.data['post']}',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      dismissDialog();
    } else {
      Get.snackbar(
        'error!',
        '${response.data['post']}',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );

      dismissDialog();
    }
    print('response data is = ${response.data}');
  }

  Future updateVideoToNetwork() async {
    dio.FormData formData = dio.FormData.fromMap({
      'image': await dio.MultipartFile.fromFile(
        image.value.path,
        filename: basename(image.value.path),
      ),
      'video': await dio.MultipartFile.fromFile(videoFile.path,
          filename: basename(videoFile.path))
    });

    final response = await dio.Dio().post(
      'https://starwebapk.com/mobile_api/public/api/updatepost/${videoIDForUpdateApi.value}?category_id=${idOfCategory.value}&title=${titleTextController.text}&description=${descriptionTextController.text}&is_premium=1',
      data: formData,
      options: dio.Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    if (response.data['status'] == true) {
      // isLoading.value = true;
      print(
          'this is the id of this current video ${videoIDForUpdateApi.value}');
      EasyLoading.dismiss();
      Get.snackbar(
        'congrats!',
        '${response.data['post']}',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      dismissDialog();
    } else {
      Get.snackbar(
        'error!',
        '${response.data['post']}',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );

      dismissDialog();
    }
    print('response data is = ${response.data}');
  }

  // api category get method
  // 1st thing first

  Future getCategoryMethod() async {
    Dio dio = Dio();

    try {
      var url = 'https://starwebapk.com/mobile_api/public/api/get/categorydata';
      var response = await dio.get(url);
      print('response is ......== $response');
      var getResponse = response.data;
      CategoryGetModel getModel = CategoryGetModel.fromJson(getResponse);
      log('Status = ${getResponse['status']}');
      log('this is data  ${getResponse['data']}');

      (getResponse['data'] as List)
          .forEach((e) => categoryIdList.add(e['name']));
      log('thisis new list $categoryIdList');

      if (getModel.status == true) {
        print(
            'this is the actual datafor the api =p===-==-=-=-==- ${getModel.data}');
        categoryAllList.value = getModel.data!.map((e) => e).toList();
        categoryIdList.value = getModel.data!.map((v) => v.name).toList();
        listOfCategoryIDfromAPI.value =
            getModel.data!.map((i) => i.id).toList();

        log('My Category List is .................,><>< ${categoryIdList}');
      }
    } catch (e) {}
  }

  dismissDialog() {
    // categoryTextController.text = '';
    descriptionTextController.text = '';
    titleTextController.text = '';
    image.value = File('');
    videoFile = File('');
  }

  // copyMyList(){
  //   categoryNameList.value = categoryIdList.map((element) => element!.image).toList();
  //   print("ooooooooooooooooooooooooooooooooooooppppppppppppppppppppppppppppppppppppp$categoryNameList");
  // }
}
