import 'dart:async';

import 'package:day36/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home:
            //HomePage()
            MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/splash.png'), fit: BoxFit.cover)),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Stack(children: [
                // Image.asset(
                //   'assets/splash.png',
                //   fit: BoxFit.cover,
                // ),
                Positioned(
                  left: 30,
                  top: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black),
                      ),
                      Text(
                        'To the weather forecast',
                        style: TextStyle(
                            //fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black.withOpacity(.6)),
                      ),
                    ],
                  ),
                )
              ]),
            )
            // Image.asset(
            //   'assets/splash.png',
            //   fit: BoxFit.cover,
            // )
            ),
      ),
    );
  }
}
