import 'package:ff/screens/MPinScreen.dart';
import 'package:ff/screens/login.dart';
import 'package:ff/screens/signup.dart';
import 'package:ff/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child){
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_)=>AppProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // home: LoginPage(),
           home: SplashScreen(),
           //  home: OtpPage(),
            // home: MPinScreen(),
          ),
        );
      },
    );

  }
}




