import 'package:flutter/material.dart';
import 'package:flutterapps/Helper/userProfileManager.dart';
import 'package:flutterapps/Screens/VideoPlayerScreen.dart';
import 'package:flutterapps/model/VideoModel.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:flutterapps/Screens/InAppPurchaseScreen.dart';

class VideoListingDetailScreen extends StatefulWidget {
  VideoModel? videoObject;

  VideoListingDetailScreen({Key? key, required this.videoObject})
      : super(key: key);

  @override
  _VideoListingDetailState createState() => _VideoListingDetailState();
}

class _VideoListingDetailState extends State<VideoListingDetailScreen> {
  VideoModel? videoObject;

  @override
  void initState() {
    // TODO: implement initState
    videoObject = widget.videoObject;
    super.initState();
  }

  String videoPostedDate() {
    DateTime postedDate =
        DateTime.fromMicrosecondsSinceEpoch(videoObject!.created_at!);
    String formattedDate = DateFormat('dd-MMM-yyyy').format(postedDate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 350,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: makeVideo(),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          videoObject!.title!,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Detail",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          videoObject!.description!,
                          style: TextStyle(color: Colors.grey, height: 1.4),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Category",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          videoObject!.cateogry_name!,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Posted On",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          // videoPostedDate(),
                          '${DateTime.now()}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
          videoObject!.is_premium != 0 &&
                  UserProfileManager().user?.is_premium_user != 1
              ? Positioned.fill(
                  bottom: 50,
                  child: Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.yellow[700]),
                            child: Align(
                                child: Text(
                              "Unlock",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<Null>(
                                  builder: (context) => InAppPurchaseScreen(),
                                  fullscreenDialog: true))),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget makeVideo() {
    return new GestureDetector(
      onTap: () {
        print('videoObject!.is_premium');
        print(videoObject!.is_premium);
        print('UserProfileManager().user?.is_premium_user');
        print(UserProfileManager().user?.is_premium_user);

        if (videoObject!.is_premium == 0 ||
            UserProfileManager().user?.is_premium_user == 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SamplePlayer(videoObject: videoObject!)));
        } else {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => InAppPurchaseScreen()));
        }
      },
      child: AspectRatio(
        aspectRatio: 1.5 / 1,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(videoObject!.imageUrl!),
                  fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.9),
              Colors.black.withOpacity(.3)
            ])),
            child: Align(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
