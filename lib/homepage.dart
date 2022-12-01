import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weatherapptwo/getlocation.dart';
import 'package:weatherapptwo/rowbulider.dart';
import 'package:weatherapptwo/weahermodel.dart';
import 'package:weatherapptwo/weatherapiclass.dart';

import 'todayforcast.dart';
import 'weathercast.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var exactpostion = '';
  double? temp = 0;
  String? wind;
  String? humidity;
  String? rain;
  double? Morntemp;
  double? daytemp;
  double? evetemp;
  double? nighttemp;
  String location = '';
  String? disc;

  WeatherApi weatherApi = WeatherApi();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpostion();

    // getWeatgerdata(exactpostion);
  }

  void getWeatgerdata(String p) async {
    print('is ${p}');
    final url =
        'https://api.openweathermap.org/data/2.5/forecast/daily?q=${p}&units=metric&cnt=7&appid=d94bcd435b62a031771c35633f9f310a';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      // print(body);
      setState(() {
        location = body['city']['name'];
        temp = body['list'][0]['temp']['day'];
        humidity = body["list"][0]['humidity'].toString();
        wind = body['list'][0]['speed'].toString();
        rain = body["list"][0]['rain'].toString();
        Morntemp = body['list'][0]['temp']['day'];
        daytemp = body['list'][0]['temp']['max'];
        evetemp = body['list'][0]['temp']['eve'];
        nighttemp = body['list'][0]['temp']['night'];
        disc = body["list"][0]['weather'][0]['description'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getpostion();

                getWeatgerdata(exactpostion);
                getpostion();
              });
            },
            icon: Icon(Icons.location_on),
            color: Colors.black,
          ),
        ],
        leading: Icon(Icons.apps_rounded),
        backgroundColor: Color(0xff00a1ff),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(50),
                      bottomStart: Radius.circular(50)),
                  color: Color(0xff00a1ff),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff00a1ff),
                        spreadRadius: 4,
                        blurRadius: 13)
                  ]),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    // color: Colors.black,
                    child: temp! < 0
                        ? Image(image: AssetImage('images/snowflake.png'))
                        : (temp! <= 0 && temp! >= 10)
                            ? Image(image: AssetImage('images/rainy.png'))
                            : (temp! > 10)
                                ? Image(image: AssetImage('images/sun.png'))
                                : Image(image: AssetImage('images/rainy.png')),
                  ),
                  Text(
                    '${(temp)}°C',
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    location,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Text(
                    '${disc}',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Divider(
                      thickness: 2,
                      color: Colors.white30,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Weather(
                            image: 'images/wind.png',
                            climate: 'wind',
                            km: '${wind}'),
                        Weather(
                            image: 'images/hot.png',
                            climate: 'Humidity',
                            km: '${humidity}'),
                        Weather(
                            image: 'images/rainy.png',
                            climate: 'rain',
                            km: '${rain}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '1 days',
                        style: TextStyle(
                            color: Color(0xff606170),
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Today(
                        todayimage: 'images/morn.png',
                        time: '6:00',
                        todaytemp: '${Morntemp}',
                      ),
                      Today(
                        todayimage: 'images/sun.png',
                        time: '12:00',
                        todaytemp: '${daytemp}',
                      ),
                      Today(
                        todayimage: 'images/clouds.png',
                        time: '5:00',
                        todaytemp: '${evetemp}',
                      ),
                      Today(
                        todayimage: 'images/moon.png',
                        time: '9:00',
                        todaytemp: '${nighttemp}',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: weatherApi.getday(exactpostion),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: RowBulider(
                              verticalDirection: VerticalDirection.down,
                              itemBuilder: (context, index) {
                                var days = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: [
                                        Text(
                                          'day${index + 1} ',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          '${days.temp!.min}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          '${days.temp!.eve}',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          days.weather!.main.toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }

  Future<void> getpostion() async {
    Position position = await takeposition();
    List positiondata =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      print('pickup');
      print(positiondata[0].locality);
      exactpostion = positiondata[0].locality.toString();
    });
  }

  Future<Position> takeposition() async {
    print('on location');
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

    return await Geolocator.getCurrentPosition();
  }
}
