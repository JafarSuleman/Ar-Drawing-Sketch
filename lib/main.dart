import 'package:doodle_fun_play/screens/ads_screen.dart';
import 'package:doodle_fun_play/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  MobileAds.instance.initialize();
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xffA0DEF9),
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue,
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
                fixedSize: const Size(55, 45),
                backgroundColor: Colors.pink.withOpacity(0.5),
                shape: const CircleBorder()),
          ),
          sliderTheme: SliderThemeData(
              activeTrackColor: const Color(0xff189EE9),
              inactiveTrackColor: Colors.black12,
              thumbColor: const Color(0xff189EE9),
              overlappingShapeStrokeColor: Colors.cyan,
              overlayColor: const Color(0xff189EE9).withOpacity(0.5))),
      home:  const HomeScreen(),
    );
  }
}
