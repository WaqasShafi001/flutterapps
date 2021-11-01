import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutterapps/model/VideoModel.dart';

class SamplePlayer extends StatefulWidget {
  SamplePlayer({Key? key, required this.videoObject}) : super(key: key);
  VideoModel? videoObject;
  @override
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  FlickManager? flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(widget.videoObject!.videoUrl!),
    );
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         title: Text(widget.videoObject!.title!,style: TextStyle(color: Colors.white),
         ),
           backgroundColor: Colors.black,
        ),
        body:Container(
          child: FlickVideoPlayer(
            flickManager: flickManager!,
            flickVideoWithControls: FlickVideoWithControls(
              controls: FlickPortraitControls(
                iconSize: 30,
                fontSize: 20,
                progressBarSettings: FlickProgressBarSettings(
                  handleRadius: 10,
                  handleColor: Theme.of(context).accentColor,
                  height: 5,
                ),
              ),
              videoFit: BoxFit.contain,
            ),
        ),
        )
    );
  }
}