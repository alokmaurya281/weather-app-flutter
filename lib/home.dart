import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/houry_forecast_items.dart';
import 'package:weather_app/main.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              homeController.getCurrentWeather();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          Obx(
                () =>
                IconButton(
                  onPressed: () {
                    homeController.changeTheme();
                  },
                  icon: homeController.isDarkMode.value == false ? const Icon(
                      Icons.light_mode_outlined) : const Icon(
                      Icons.dark_mode_outlined),
                ),
          ),
        ],
      ),
      body: Obx(
            () =>
        homeController.isLoading.value ? const Center(
          child: CircularProgressIndicator(),)


            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // borderRadius: BorderRadius.circular(16),
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'City: ${homeController.city}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${(homeController.currentWeather['main']['temp'] - 273.15).toStringAsPrecision(4)} °C',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Icon(
                              homeController
                                  .currentWeather['weather'][0]['main'] ==
                                  'Clouds' || homeController
                                  .currentWeather['weather'][0]['main'] ==
                                  'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              homeController
                                  .currentWeather['weather'][0]['main'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final hourlyForecast = homeController.weather[index + 1];
                    final hourlyTemp = hourlyForecast['main']['temp'];
                    final hourlySky = homeController.weather[index + 1]['weather'][0]['main'];
                    final time = DateTime.parse(hourlyForecast['dt_txt']);
                    return HourlyForecastItems(
                      time: DateFormat.jm().format(time),
                      icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                          ? Icons.cloud
                          : Icons.sunny,
                      temperature:
                          (hourlyTemp - 273.15).toString().substring(0, 5),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Additional Information',
                  style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInformation(
                    icon: Icons.water_drop,
                    label: "Humidity",
                    value: homeController.currentWeather['main']['humidity'].toString(),
                  ),
                  AdditionalInformation(
                    icon: Icons.air,
                    label: 'Wind Air',
                    value: homeController.currentWeather['wind']['speed'].toString(),
                  ),
                  AdditionalInformation(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    value: homeController.currentWeather['main']['pressure'].toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
