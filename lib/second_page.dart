import 'dart:ui';

import 'package:day36/third_page.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'home_page.dart';
import 'model.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key? key, this.exercise}) : super(key: key);

  final Exercise? exercise;
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int second = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(.5),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //     image: NetworkImage(
              //       "${widget.exercise!.thumbnail}",
              //     ),
              //     fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(color: Colors.black, width: 3)
            ),
            padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        "${widget.exercise!.thumbnail}",
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 3)),
              // child: Image.network(
              //   "${widget.exercise!.thumbnail}",
              //   height: double.infinity,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SleekCircularSlider(
                  min: 3,
                  max: 10,
                  initialValue: second.toDouble(),
                  onChange: (double value) {
                    setState(() {
                      second = value.toInt();
                      print("second issss$second");
                    });
                    // callback providing a value while its being changed (with a pan gesture)
                  },
                  innerWidget: (double value) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${second.toStringAsFixed(0)}",
                              style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print("sssssssssssssss$second");
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ThirdPage(
                                        exercise: widget.exercise,
                                        second: second,
                                      )));
                            },
                            child: Text("Next"),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 207, 99, 226)),
                          )
                        ],
                      ),
                    );
                    // use your custom widget inside the slider (gets a slider value from the callback)
                  },
                ),
              ],
            ),
          ),
          Positioned(
              left: 30,
              top: 30,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  height: 30,
                  padding: EdgeInsets.all(5),
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
