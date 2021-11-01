import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ListingScreenController extends GetxController {
  var videoCategoryPosts = [].obs;

  TextEditingController categoryTextController = TextEditingController();
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

  compressVideo(PickedFile? f) async {
    final filePath = f!.path;
    final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.DefaultQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    video.value = mediaInfo!.file!;

    print(
        'this is coompressed video ========= ${video.value.path} and its size is ${mediaInfo.filesize}');
  }

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
      'https://starwebapk.com/mobile_api/public/api/createpost?category_id=${categoryTextController.text}&title=${titleTextController.text}&description=${descriptionTextController.text}&is_premium=1',
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
      'https://starwebapk.com/mobile_api/public/api/updatepost/4?category_id=${categoryTextController.text}&title=${titleTextController.text}&description=${descriptionTextController.text}&is_premium=1',
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

  dismissDialog() {
    categoryTextController.text = '';
    descriptionTextController.text = '';
    titleTextController.text = '';
    image.value = File('');
    videoFile = File('');
  }
}
