import 'package:flutter/material.dart';
import 'package:flutterapps/ApiHandler/ApiController.dart';
import 'package:flutterapps/model/Photo.dart';
import 'package:flutterapps/Screens/PhotosPreview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:connectivity/connectivity.dart';

class PhotoGallery extends StatefulWidget {
  PhotoGallery({Key? key}) : super(key: key);

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<Photo> photos = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhotos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Photo Gallery"),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: GridView.builder(
              itemCount: photos.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.all(1),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotosPreview(photos:photos, startPage: index)));
                        print('tapped');
                      },
                        child: Container(
                            decoration: new BoxDecoration(
                                image: new DecorationImage(
                                    image: new NetworkImage(
                                        photos[index].imageUrl!),
                                    fit: BoxFit.cover)))
                    )
                    );
              }),
        ));
  }

  void getPhotos() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage("No Internet connection");
      return;
    }

    EasyLoading.show(status: 'loading...');
    ApiController().getPhotos().then((response) async {
      photos = response.success == true ? response.photos : [];
      setState(() {});
      EasyLoading.dismiss();
    });
  }

  void showMessage(String message){
    final snackBar = SnackBar(
      content: Text(message),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


