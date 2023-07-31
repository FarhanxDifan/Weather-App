import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position position;
  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longatute = position.longitude;
    });
    fetchWeatherData();
  }

  var latitude;
  var longatute;

  fetchWeatherData() async {
    String forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2MIhWnKnisutHJ1y1dgxc-XbFFbVlG_T_f8F9_fhd6ZFC4PRI3oNAWgMc";

    String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longatute&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR2MIhWnKnisutHJ1y1dgxc-XbFFbVlG_T_f8F9_fhd6ZFC4PRI3oNAWgMc";

    var weatherResponce = await http.get(Uri.parse(weatherUrl));

    var forecastResponce = await http.get(Uri.parse(forecastUrl));
    weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecastResponce.body));
    setState(() {});
    print("eeeeeeeeeee${forecastMap!["cod"]}");
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: forecastMap != null
          ? Scaffold(
              backgroundColor: Color(0xff1C1A43),
              body: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.tune,
                              color: Colors.white,
                            ),
                            Text(
                              "Weather Forecast",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color:
                                Color.fromARGB(255, 50, 51, 83).withOpacity(.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Today",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "${Jiffy(DateTime.now()).format("h:mm a")}",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.7),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                                Text(
                                  "${Jiffy(DateTime.now()).format("MMM do yy")}",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            // SizedBox(height: 20,),
                            Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${weatherMap!["main"]["temp"]} ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "°C",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 35,
                                              color: Colors.yellow),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Feels Like",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color:
                                                  Colors.white.withOpacity(.6)),
                                        ),
                                        Text(
                                          " ${weatherMap!["main"]["feels_like"]} °",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${weatherMap!["weather"][0]["description"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                                Spacer(),
                                // Image.network(
                                //   "http://openweathermap.org/img/wn/01d@2x.png",
                                //   height: 130,
                                //   width: 130,
                                //   fit: BoxFit.cover,
                                // ),
                                Image.asset(
                                  "assets/jj.png",
                                  fit: BoxFit.cover,
                                  width: 100,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${weatherMap!["name"]}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        height: 90,
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 50, 51, 83).withOpacity(.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "💧  Humidity ${weatherMap!["main"]["humidity"]},",
                                  style: style(),
                                ),
                                // Text(
                                //     "🌅 Sunrise ${Jiffy("${DateTime.fromMicrosecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")}"),
                                Text(
                                  "☁️  Pressure ${weatherMap!["main"]["pressure"]}",
                                  style: style(),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Text(
                                //     "Pressure ${weatherMap!["main"]["pressure"]}"),
                                Text(
                                  "🌅  Sunrise: ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")}",
                                  style: style(),
                                ),
                                // Text("Sunrise ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(waether!["sys"]["sunrise"] * 1000)}").format('h:mm a')},)

                                Text(
                                  "🌄  Sunset: ${Jiffy("${DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("h:mm a")}",
                                  style: style(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //           "${Jiffy(DateTime.now()).format("MMM do yy")} , ${Jiffy(DateTime.now()).format("h:mm")}"),
                      //       Text("${weatherMap!["name"]}")
                      //     ],
                      //   ),
                      // ),
                      // Text(
                      //   "${weatherMap!["main"]["temp"]} °",
                      //   style: TextStyle(
                      //     fontSize: 25,
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Column(children: [
                      //     Text("Feels Like ${weatherMap!["main"]["feels_like"]}"),
                      //     Text("${weatherMap!["weather"][0]["description"]}")
                      //   ]),
                      // ),
                      // Text(
                      //     "Humidity ${weatherMap!["main"]["humidity"]}, Pressure ${weatherMap!["main"]["pressure"]}"),
                      // Text(
                      //     "Sunrise ${Jiffy("${DateTime.fromMicrosecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)}").format("h:mm a")} , Sunset ${Jiffy("${DateTime.fromMicrosecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)}").format("h:mm a")}"),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),

                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(15),
                        //   color: Color.fromARGB(255, 50, 51, 83).withOpacity(.4),
                        // ),
                        height: 193,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: forecastMap!.length,
                            separatorBuilder: (_, index) => SizedBox(
                                  width: 10,
                                ),
                            itemBuilder: (context, index) {
                              var time =
                                  Jiffy(forecastMap!["list"][index]["dt_txt"])
                                      .format("EEE h:mm");
                              var x = forecastMap!["list"][index]["weather"][0]
                                  ["icon"];
                              // var xx = forecastMap!["list"][index]["weather"][0]["icon"];
                              var z = forecastMap!["list"][index]["weather"][0]
                                  ["description"];
                              return Container(
                                // height: 15,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 50, 51, 83)
                                      .withOpacity(.4),
                                ),
                                //width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.network(
                                          "http://openweathermap.org/img/wn/$x@2x.png",
                                          fit: BoxFit.cover,
                                        ),
                                        // Image.asset(
                                        //   "assets/jj.png",
                                        //   fit: BoxFit.cover,
                                        //   width: 60,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("h a")}",
                                      style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(.6)),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${weatherMap!["main"]["temp"]} ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "°C",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.yellow),
                                        ),
                                      ],
                                    ),
                                    // Text(
                                    //     "${forecastMap!["list"][index]["main"]["temp_max"]} °  "),
                                    // Image.network(z == "clear sky"
                                    //     ? "http://openweathermap.org/img/wn/01d@2x.png"
                                    //     : z == "few clouds"
                                    //         ? "http://openweathermap.org/img/wn/02n@2x.png"
                                    //         : z == "scattered clouds"
                                    //             ? "http://openweathermap.org/img/wn/03n@2x.png"
                                    //             : z == "broken clouds"
                                    //                 ? "http://openweathermap.org/img/wn/04n@2x.png"
                                    //                 : z == "shower rain"
                                    //                     ? "http://openweathermap.org/img/wn/05n@2x.png"
                                    //                     : z == "rain"
                                    //                         ? "http://openweathermap.org/img/wn/06n@2x.png"
                                    //                         : z == "thunderstorm"
                                    //                             ? "http://openweathermap.org/img/wn/07n@2x.png"
                                    //                             : z == "snow"
                                    //                                 ? "http://openweathermap.org/img/wn/08n@2x.png"
                                    //                                 : "http://openweathermap.org/img/wn/09n@2x.png"),
                                    // Image.network(
                                    //     "http://openweathermap.org/img/wn/$x@2x.png"),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${forecastMap!["list"][index]["weather"][0]["description"]}",
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(.6)),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Chance of Rain",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/rain.png'),
                                  fit: BoxFit.fill),
                              color: Color.fromARGB(255, 50, 51, 83)
                                  .withOpacity(.4),
                              borderRadius: BorderRadius.circular(20)),
                          height: 200,
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 15),
                          margin: EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Text(
                                  "It's just an image",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            )
          : Center(child: SpinKitCubeGrid(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? Colors.blue : Colors.green,
                  ),
                );
              },
            )),
    );
  }
}

style() {
  return TextStyle(color: Colors.white.withOpacity(.6), fontSize: 14);
}
