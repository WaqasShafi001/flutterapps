// ignore_for_file: unnecessary_question_mark

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutterapps/ApiHandler/ApiController.dart';
import 'package:flutterapps/GetxControllers/CategoryGetModel.dart';
import 'package:flutterapps/GetxControllers/listingScrnController.dart';
import 'package:flutterapps/model/VideoPost.dart';
import 'package:flutterapps/model/VideoModel.dart';
import 'package:flutterapps/Screens/VideoListingDetail.dart';
import 'package:flutterapps/Helper/FadeAnimation.dart';
import 'package:flutterapps/Helper/AdHelper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

class ListingsScreen extends StatefulWidget {
  @override
  _ListingsState createState() => _ListingsState();
}

class _ListingsState extends State<ListingsScreen> {
  var listingController = Get.put(ListingScreenController());
  List<String> locations = ['A', 'B', 'C', 'D'];
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    loadProfile();

    getListing();
  }

  void showInterstitial() {
    InterstitialAds(
      onCompletion: () {},
    ).loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    log('this isssssssssssssssssssssssssssssssssss----------------------=======================${listingController.categoryIdList}');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Videos",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.defaultDialog(
              title: 'Upload Video',
              content: Column(
                children: [
                  //dropdown ///////////
                  DropDown<String?>(
                    items: listingController.categoryIdList,
                    hint: Text('choose category'),
                    showUnderline: false,
                    onChanged: (val) {
                      listingController.idOfCategory.value =
                          listingController.categoryIdList.indexOf(val) + 1;

                      // // listingController.ListOfCategoryIDfromAPI
                      // List res = listingController.categoryAllList
                      //     .where((item) => listingController
                      //         .listOfCategoryIDfromAPI
                      //         .contains(item.id))
                      //     .toList();
                      // log('res is {$res}');

                      log('id index val is =${listingController.idOfCategory.value}');
                      log('val is $val');
                    },
                  ),

                  TextFormField(
                    controller: listingController.titleTextController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  TextFormField(
                    controller: listingController.descriptionTextController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Description',
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: listingController.isImagePicked.value ? 50 : 0,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              listingController.chooseImage();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                            child: Text('choose image'),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              listingController.chooseVideo();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                            child: Text('choose video'),
                          ),
                        ],
                      ),
                      Obx(
                        () => Text(listingController.isImagePicked.value
                            ? listingController.image.value.path
                            : ''),
                      ),
                      Obx(
                        () => Text(listingController.isVideoPicked.value
                            ? listingController.videoFile.path
                            : ''),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (listingController.idOfCategory.value == 0 &&
                          listingController.titleTextController.text.isEmpty &&
                          listingController
                              .descriptionTextController.text.isEmpty) {
                        Get.snackbar(
                          'empty',
                          'any of the field should not be empty',
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        );
                      } else {
                        if (listingController.image.value.path.isNotEmpty &&
                            listingController.videoFile.path.isNotEmpty) {
                          EasyLoading.show(status: 'loading...');
                          Navigator.pop(context);
                          listingController
                              .uploadVideoToNetwork()
                              .then((value) {
                            setState(() {
                              widget.createState().initState();
                            });
                          });
                          // listingController.isLoading.value
                          //     ? CircularProgressIndicator()
                          //     : SizedBox();
                          // listingController.isDismissDialog.value
                          //     ? Navigator.pop(context)
                          //     : SizedBox();
                        } else {
                          // Navigator.pop(context);
                          Get.snackbar(
                            'error',
                            'please choose media files',
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    child: Text('upload')),
              ],
            );
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: getCategoriesBody(context)));
  }

  getCategoriesBody(BuildContext context) {
    print('-=-=-=-=-=-=-=-=-${listingController.videoCategoryPosts.length}');
    return ListView.builder(
      itemCount: listingController.videoCategoryPosts.length,
      itemBuilder: _getListItemUI,
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getListItemUI(BuildContext context, int index,
      {double imgwidth: 200.0}) {
    VideoPost currentPost = listingController.videoCategoryPosts[index];

    print(
        'wwwwwwwwwwwwwwwwwwwww${currentPost.name} wwwwwwwwww ${currentPost.post!.length}');

    print('wwwwwwwwwwwwwwwwwwwwwwwwwwwwwww ${currentPost.post!.toList()}');

    return FadeAnimation(
        0.3,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Text(
                      currentPost.name!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 20),
                    ),
                    Image.network(
                      currentPost.imageUrl!,
                      height: 24,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 170,
                //color: Colors.red,
                child: getVideosBody(context, currentPost.post!),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  getVideosBody(BuildContext contex, List<VideoModel> videos) {
    print(
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx${videos.length}');
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: videos.length,
      itemBuilder: (BuildContext context, int index) {
        // VideoModel video = videos[index];
        return _getVideoItemUI(videos[index]);
      },
      padding: EdgeInsets.all(0.0),
    );
  }

  Widget _getVideoItemUI(VideoModel video) {
    listingController.videoIDForUpdateApi.value = video.id as int;
    log('this is the video id = = = = = =  = ${listingController.videoIDForUpdateApi.value} . . . .  ${video.id}');
    return AspectRatio(
      aspectRatio: 1.8 / 1,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  VideoListingDetailScreen(videoObject: video)));
          print('tapped');
        },
        child: Container(
          margin: EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.green.withOpacity(0.5),
            // image: DecorationImage(
            //     image: NetworkImage(video.imageUrl!), fit: BoxFit.cover),
            image: DecorationImage(
                image: AssetImage(
                  'assets/logo.png',
                ),
                fit: BoxFit.cover),
          ),
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.2),
                  ])),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: myPopMenu(),
                  ),
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Icon(
                  //     Icons.more_vert,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      video.title!,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void getListing() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage("No Internet connection");
      return;
    }

    EasyLoading.show(status: 'loading...');
    ApiController().getVideos().then((response) async {
      log(' ----------------------------------------i am here--------------${response.success}-${response.message}-----------------${response.videosPost.toList()}--------------');
      listingController.videoCategoryPosts.value =
          response.success == true ? response.videosPost.toList() : [];
      setState(() {});
      EasyLoading.dismiss();
    });
  }

  loadProfile() {
    ApiController().getUserProfile().then((response) async {
      EasyLoading.dismiss();
      showInterstitial();
    });
  }

  void showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget myPopMenu() {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert, color: Colors.white),
        onSelected: (value) {
          print('this is clicked');
          Get.defaultDialog(
            title: 'Update Video',
            content: Column(
              children: [
                //drop down
                DropDown<String?>(
                  items: listingController.categoryIdList,
                  hint: Text('choose category'),
                  showUnderline: false,
                  onChanged: (val) {
                    listingController.idOfCategory.value =
                        listingController.categoryIdList.indexOf(val) + 1;

                    // // listingController.ListOfCategoryIDfromAPI
                    // List res = listingController.categoryAllList
                    //     .where((item) => listingController
                    //         .listOfCategoryIDfromAPI
                    //         .contains(item.id))
                    //     .toList();
                    // log('res is {$res}');

                    log('id index val is =${listingController.idOfCategory.value}');
                    log('val is $val');
                  },
                ),
                TextFormField(
                  controller: listingController.titleTextController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                TextFormField(
                  controller: listingController.descriptionTextController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: listingController.isImagePicked.value ? 50 : 0,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            listingController.chooseImage();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          child: Text('choose image'),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            listingController.chooseVideo();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black)),
                          child: Text('choose video'),
                        ),
                      ],
                    ),
                    Obx(
                      () => Text(listingController.isImagePicked.value
                          ? listingController.image.value.path
                          : ''),
                    ),
                    Obx(
                      () => Text(listingController.isVideoPicked.value
                          ? listingController.videoFile.path
                          : ''),
                    ),
                  ],
                )
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (listingController.idOfCategory.value == 0 &&
                        listingController.titleTextController.text.isEmpty &&
                        listingController
                            .descriptionTextController.text.isEmpty) {
                      Get.snackbar(
                        'empty',
                        'any of the field should not be empty',
                        backgroundColor: Colors.white,
                        colorText: Colors.black,
                      );
                    } else {
                      if (listingController.image.value.path.isNotEmpty &&
                          listingController.videoFile.path.isNotEmpty) {
                        EasyLoading.show(status: 'loading...');
                        Navigator.pop(context);
                        listingController.updateVideoToNetwork().then((value) {
                          setState(() {
                            widget.createState().initState();
                          });
                        });
                        // listingController.isLoading.value
                        //     ? CircularProgressIndicator()
                        //     : SizedBox();
                        // listingController.isDismissDialog.value
                        //     ? Navigator.pop(context)
                        //     : SizedBox();
                      } else {
                        // Navigator.pop(context);
                        Get.snackbar(
                          'error',
                          'please choose media files',
                          backgroundColor: Colors.white,
                          colorText: Colors.black,
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  child: Text('update')),
            ],
          );
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  height: MediaQuery.of(context).size.height * 0.01,
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(Icons.update),
                      ),
                      Text('update')
                    ],
                  )),
              // PopupMenuItem(
              //     value: 2,
              //     child: Row(
              //       children: <Widget>[
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
              //           child: Icon(Icons.delete),
              //         ),
              //         Text('delete')
              //       ],
              //     )),
              // PopupMenuItem(
              //     value: 3,
              //     child: Row(
              //       children: <Widget>[
              //         Padding(
              //           padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
              //           child: Icon(Icons.dismiss),
              //         ),
              //         Text('dismiss')
              //       ],
              //     )),
            ]);
  }
}
