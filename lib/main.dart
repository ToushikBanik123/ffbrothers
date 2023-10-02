
import 'package:ff/screens/MPinScreen.dart';
import 'package:ff/screens/login.dart';
import 'package:ff/screens/signup.dart';
import 'package:ff/screens/splash.dart';
import 'package:ff/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Provider/AppProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Provider/notification_services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMassagingBackgroundHandler);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMassagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print(message.notification!.title.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // Uncomment and replace with your desired initial screen
            home: SplashScreen(),
            // home: MPinScreen(),
            // home: TestPage(),
            // home: LoginPage(),
            // home: OtpPage(),
            // home: MPinScreen(),
          ),
        );
      },
    );
  }
}
