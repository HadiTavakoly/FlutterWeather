import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../api/current_weather_api.dart';
import '../models/current_weather_model.dart';
import 'package:intl/intl.dart';
import './search_page.dart';
import '../constans.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<CurrentWeather>? currentWeatherData;
  late String q;
  late String result;
  bool isLoading = false;

  final box = Hive.box('location');
  saveCity() {
    box.put('cityName', q);
  }

  loadCity() {
    q = box.get('cityName') ?? 'Tehran';
    result = q;
  }

  Future refresh() async {
    setState(() => isLoading = true);
    currentWeatherData = getCurrentWeather(q);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    loadCity();
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.refresh_outlined,
                  color: textColor,
                  size: 30,
                ),
                onPressed: () {
                  refresh();
                },
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: textColor,
                    size: 30,
                  ),
                  Text(
                    result,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ],
              ),
              GestureDetector(
                child: Icon(
                  Icons.search_outlined,
                  color: textColor,
                  size: 30,
                ),
                onTap: () async {
                  result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      ) ??
                      q;
                  setState(() {
                    q = result;
                  });
                  saveCity();
                  refresh();
                },
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: const Color(0xff602a93),
        ),
        body: Center(
          child: FutureBuilder(
            future: currentWeatherData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return isLoading
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                2 /
                                                5,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/final icon/${returnImage(snapshot.data!.current!.condition!.code!)}(${snapshot.data!.current!.isDay!}).png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${DateFormat.E().addPattern(',').add_M().add_LLL().format(
                                              DateTime.now(),
                                            )} ',
                                        style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${snapshot.data!.current!.tempC!}°',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 60,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 10),
                                        child: Text(
                                          '${snapshot.data!.forecast!.forecastday![0].day!.mintempC}° | ${snapshot.data!.forecast!.forecastday![0].day!.maxtempC}°',
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.current!.condition!.text
                                            .toString(),
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 50),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    forecastInfo(context, snapshot, 1),
                                    forecastInfo(context, snapshot, 4),
                                    forecastInfo(context, snapshot, 7),
                                  ],
                                ),
                              ),
                              Text(
                                'More information',
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  moreInfo(
                                    'assets/images/moreInfo/icons8-wind-96 (1).png',
                                    'Wind',
                                    '${snapshot.data!.current!.windKph} Km/h',
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  moreInfo(
                                    'assets/images/final icon/35(1).png',
                                    'Cloud',
                                    '${snapshot.data!.current!.cloud} %',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  moreInfo(
                                    'assets/images/final icon/7(1).png',
                                    'Precipitation',
                                    '${snapshot.data!.current!.precipMm} mm',
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  moreInfo(
                                    'assets/images/moreInfo/icons8-wet-96.png',
                                    'Humidity',
                                    '${snapshot.data!.current!.humidity} %',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  moreInfo(
                                    'assets/images/moreInfo/33.png',
                                    'Visibility',
                                    '${snapshot.data!.current!.visKm} Km',
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  moreInfo(
                                    'assets/images/moreInfo/icons8-temperature-96.png',
                                    'Pressure',
                                    '${snapshot.data!.current!.pressureMb} Hg',
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    astronomy(
                                      context,
                                      'assets/images/moreInfo/icons8-sunrise-96.png',
                                      'Sunrise',
                                      snapshot.data!.forecast!.forecastday![0]
                                          .astro!.sunrise
                                          .toString(),
                                    ),
                                    astronomy(
                                      context,
                                      'assets/images/moreInfo/full-moon.png',
                                      'Moon\nillumination',
                                      '${snapshot.data!.forecast!.forecastday![0].astro!.moonIllumination} %',
                                    ),
                                    astronomy(
                                      context,
                                      'assets/images/moreInfo/icons8-sunset-96.png',
                                      'Sunset',
                                      snapshot.data!.forecast!.forecastday![0]
                                          .astro!.sunset
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Column forecastInfo(
      BuildContext context, AsyncSnapshot<CurrentWeather> snapshot, int index) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: infoBoxColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Image(
                  image: AssetImage(
                    'assets/images/final icon/${returnImage(
                      snapshot
                          .data!
                          .forecast!
                          .forecastday![0]
                          .hour![DateTime.now()
                              .add(
                                Duration(hours: index),
                              )
                              .hour]
                          .condition!
                          .code!,
                    )}(${snapshot.data!.current!.isDay!}).png',
                  ),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${snapshot.data!.forecast!.forecastday![0].hour![DateTime.now().add(
                      Duration(hours: index),
                    ).hour].tempC}°',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          DateFormat.j().format(
            DateTime.now().add(
              Duration(
                hours: index,
              ),
            ),
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Expanded moreInfo(String image, String title, String description) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: infoBoxColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: Image(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column astronomy(
      BuildContext context, String image, String time, String temp) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: infoBoxColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                temp,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          time,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        )
      ],
    );
  }
}
