import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutterapps/model/Photo.dart';

class PhotosPreview extends StatefulWidget {
  List<Photo> photos = [];
  int startPage = 1;

  PhotosPreview({Key? key, required this.photos, required this.startPage}) : super(key: key);

  @override
  _PhotosPreviewState createState() => _PhotosPreviewState();
}

class _PhotosPreviewState extends State<PhotosPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      // add this body tag with container and photoview widget
      body: PhotoViewGallery.builder(
        itemCount: widget.photos.length,
        pageController: PageController(initialPage: widget.startPage),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(
                widget.photos[index].imageUrl!),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
      ),
    );
  }
}