import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController{
  RxBool isDarkMode = true.obs;
  RxBool isLoading = false.obs;
    var currentWeather = {}.obs;
  var weather = [].obs;

  RxString city = "Kanpur".obs;
  Position? position;

  void changeTheme(){
    isDarkMode.value = !isDarkMode.value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkMode', isDarkMode.value);
    });

  }
  @override
  void onInit() {
    isLoading.value = true;

    super.onInit();
  }

  @override
  void onReady() async{
     await getCurrentLocation();
   await  getCityName();
    // TODO: implement onInit
     getCurrentWeather();
     super.onReady();
  }

  Future<void> getCurrentLocation() async {

    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    isLoading.value = true;

    update();

    await getCityName();
    String apikey = 'd706b782deca87be0f3ec31e935a21d6';

    final res = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=${city.value}&appid=$apikey'),
    );
    // print(res.body);
    final data = jsonDecode(res.body);
    // print(data);
    if (data['cod'] != '200') {
      print(data);
      throw 'Response Failed with status Code ${data['cod']}';
    }
    currentWeather.value = data['list'][0];
    weather.value = data['list'];
    // final data = snapshot.data!;
    final double currentTemp = ((data['list'][0]['main']['temp']) - (273.15));
    final humidity = data['list'][0]['main']['humidity'];
    final pressure = data['list'][0]['main']['pressure'];
    final currentSky = data['list'][0]['weather'][0]['main'];
    final windAir = data['list'][0]['wind']['speed'];
    isLoading.value = false;
    return data;

  }

  Future<void> getCityName() async {
    try {
      var position1 = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      position = position1;
      double lat = position1!.latitude;
      double long = position1!.longitude;
      GeoCode geoCode = GeoCode();
      Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: long);
      city.value = address.city!;
    } catch (e) {
      print('Error: $e');
    }
  }

}