import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maa/firebase_options.dart';
import 'views/screens/splash/scr.dummy_splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    print("\x1B[36mThis is called from : main()\x1B[0m");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maa',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),

      // home: const LauncherSlidesScreen(),
      home: const DummySplashScreen(),
      // home: BaseScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
