import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Register.dart';
import 'login.dart';
import 'navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCGlpLeAeam9PdoUK8U0NpAAGTPahqva0A",
          authDomain: "powerlifting-application-11263.firebaseapp.com",
          projectId: "powerlifting-application-11263",
          storageBucket: "powerlifting-application-11263.appspot.com",
          messagingSenderId: "31142014468",
          appId: "1:31142014468:web:a3b9abc778bf36c47a8f51"));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Coaches Dashboard",
      theme: ThemeData(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
        scaffoldBackgroundColor: Color.fromARGB(255, 50, 50, 48),
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
        }),
        primaryColor: Colors.white,
      ),
      initialRoute: '/SignUp',
      routes: {
        '/login': (context) => const Login(),
        '/SignUp': (context) => const SignUp(),
        '/Navbar': (context) => Navbar(),
      },
    );
  }
}
