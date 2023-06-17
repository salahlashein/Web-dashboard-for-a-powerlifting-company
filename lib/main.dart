import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/details_screen/details_screen.dart';
import 'package:web_dashboard/forget_password.dart';
import 'package:web_dashboard/services/auth.dart';
import 'package:web_dashboard/setting_screen/setting.dart';
import 'package:web_dashboard/test.dart';

import 'Register.dart';
import 'athleatesList.dart';
import 'login.dart';
import 'navbar.dart';
import 'package:firebase_core/firebase_core.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AthleteHoverNotifier()),
      ],
      child: MaterialApp(
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
        initialRoute: '/login',
        routes: {
          '/login': (context) => Login(),
          '/SignUp': (context) => const SignUp(),
          '/Navbar': (context) => Navbar(),
          '/details': (context) => const DetailsScreen(),
          '/settings': (context) => const SettingScreen(),
          '/forgetpass': (context) => const ForgetPassword(),
          '/AthletesGrid': (context) => AthletesGrid(),
        },
      ),
    );
  }
}
