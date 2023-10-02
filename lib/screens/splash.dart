import 'dart:async';
import 'package:ff/Provider/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/const.dart';
import 'login.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Model/UserModel.dart';
import '../Provider/AppProvider.dart';
import 'MPinScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late int status;


  //LoginPage()

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();

    // notificationServices.requestNotificationPermission();
    // notificationServices.firebaseInit();
    // // notificationServices.isTokenRefresh();
    // notificationServices.getDeviceToken().then((value){
    //   print("Device Token");
    //   print(value.toString());
    // });

    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value) {
      print("Device Token");
      print(value.toString());
    });

    Timer(Duration(seconds: 2), () {
      _checkAutoLogin();
    });
  }

  Future<void> loginUser(String phone, String password) async {
    // const String apiUrl = "https://bvaedu.com/matkaking/API/user_login.php";
    String apiUrl = "$baseUrl/user_login.php";

    try {
      final response = await http.post(Uri.parse(apiUrl), body: {
        'phone': phone,
        'password': password,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData['message']);
        if (responseData['message'] == "Login successful") {
          final userJson = responseData['user'][0];
          UserModel user = UserModel.fromJson(userJson);

          // Save the user information locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('savedUser', jsonEncode(userJson));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Login successful!'),
            ),
          );

          Provider.of<AppProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacement( // Use pushReplacement to prevent going back to the login screen
            context,
            MaterialPageRoute(builder: (context) => MPinScreen()),
          );
        } else if (responseData['message'] == "Account has been Deactivated") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid username and password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Login')),
        );
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      print('Error: $error');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while logging in')),
      );
    }
  }

  Future<void> _checkAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUserJson = prefs.getString('savedUser');
    if (savedUserJson != null) {
      UserModel user = UserModel.fromJson(jsonDecode(savedUserJson));
      // You may want to handle the case where the saved user info is invalid or outdated
      // For now, let's assume that the user info is always valid
      loginUser(user.phone, user.password);
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  Future<Map<String, dynamic>> fetchDataFromApi() async {
    final apiUrl = '$baseUrl/playstore.php'; // Replace with your API URL

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // You can now access the data from the API like this:
      final List<dynamic> values = data['value'];
      final int id = values[0]['id'];
      setState(() {
        status = id;
      });

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception or handle the error accordingly.
      throw Exception('Failed to load data from the API');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09012E), // Set your desired background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Replace 'logo.png' with your actual logo image asset
            Image.asset('assets/images/logo.png', width: 400.w, height: 400.sp), // You can use a loading indicator here
          ],
        ),
      ),
    );
  }
}

// Create a HomeScreen widget for the next screen after splash
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Welcome to the App!')),
    );
  }
}



