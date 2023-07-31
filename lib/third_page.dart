import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:day36/widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model.dart';

class ThirdPage extends StatefulWidget {
  ThirdPage({Key? key, this.exercise, this.second}) : super(key: key);

  final Exercise? exercise;
  int? second;

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  bool isPlaying = false;
  bool isComplete = false;
  int startSound = 0;
  late Timer timer;
  String musicPath = "assets/music.mp3";

  playAudio() async {
    // await audioCache.load(musicPath);
    // await audioPlayer.play(AssetSource(musicPath));
  }

  @override
  void initState() {
    // TODO: implement initState
    // playAudio();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var x = widget.second! - 1;

      print("${x}");

      if (timer.tick == widget.second) {
        timer.cancel();
        setState(() {
          //isPlaying = true;
          playAudio();
          Fluttertoast.showToast(msg: "Time Out");
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        });
      }
      setState(() {
        startSound = timer.tick;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //border: Border.all(color: Colors.black, width: 3)
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  width: double.infinity,
                  imageUrl: "${widget.exercise!.gif}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => spinkit,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ],
            ),
          ),
          Positioned(
              top: 100,
              //left: 20,
              right: 100,
              child: Center(
                  child: Text(
                "Count Down(out of_${widget.second}): $startSound",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              )))
        ],
      ),
    );
  }
}
