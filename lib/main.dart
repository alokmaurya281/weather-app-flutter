import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/home/controllers/home_controller.dart';
final homeController = Get.put(HomeController());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  homeController.isDarkMode.value = isDarkMode;
  runApp(const MyApp());
}
//

class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return Obx(
      ()=> MaterialApp(
        themeMode: homeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),

        home: const Home(),
      ),
    );
  }
}
