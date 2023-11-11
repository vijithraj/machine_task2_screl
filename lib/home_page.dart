import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'constraints.dart'as k;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoaded = false;
  num? temp;
  num? pressure;
  num? humidity;
  num? cover;
  String cityname = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }


  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Weather App",style: TextStyle(fontSize:
        20,color: Colors.white),),backgroundColor: Colors.black87,),
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/image1.jpg"),
                ),
              ),
              child: Visibility(
                  visible: isLoaded,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                        SizedBox(
                          height: 80,
                        ),
                            Row(
                              children: [
                                Icon(Icons.location_city_outlined,size: 60,color: Colors.white,),
                                Text(
                                  cityname,
                                  style: const TextStyle(
                                    fontSize: 45,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Saturday,nov,2023",
                              style: TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 130,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.cloud_outlined,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Cloud',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Pressure:${pressure?.toInt()}hpa',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Humidity:${humidity?.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(
                                '${temp?.toInt()}',
                                style: const TextStyle(
                                    fontSize: 90,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )),
                  )))),
    );


  }
  getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if (position != null) {
      print('lat:${position.latitude},long:${position.longitude}');
      getCurrentCityWeather(position);
    } else {
      print('Data Unavailable');
    }
  }

  getCurrentCityWeather(Position pos) async {
    var url =
        '${k.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${k.apiKey}';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = jsonDecode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
    } else {
      print(response.statusCode);
    }
  }
  updateUI(var decodeData) {
    setState(() {
      if (decodeData == null) {
        temp = 0;
        pressure = 0;
        humidity = 0;
        cover = 0;
        cityname = "Not available";
      } else {
        temp = decodeData['main']['temp'] - 273;
        pressure = decodeData['main']['pressure'];
        humidity = decodeData['clouds']['all'];
        cityname = decodeData['name'];
      }
    });
  }
}
