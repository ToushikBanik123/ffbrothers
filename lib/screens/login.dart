import 'dart:convert';
import 'package:ff/screens/signup.dart';
import 'package:ff/screens/welcome_aboard_screen.dart';
import 'package:ff/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import '../Model/UserModel.dart';
import '../Provider/AppProvider.dart';
import '../utils/Widgits/WithIconTextField.dart';
import 'MPinScreen.dart';
import 'forgotpassword.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> loginUser(String phone, String password) async {
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
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.red],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Container(
                height: 450.h, // Add ".h" for height scaling
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        16.r), // Add ".r" for radius scaling
                    color: Colors.white.withOpacity(0.4)),
                child: Padding(
                  padding: EdgeInsets.all(18.w), // Add ".w" for width scaling
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IconTextField(
                        text: "Phone Number",
                        icon: Icons.phone,
                        isPasswordType: false,
                        controller: _phonenumberController,
                        keyboardType: TextInputType.phone,
                        enabled: true,
                      ),
                      SizedBox(height: 16.h),
                      IconTextField(
                        text: "Password",
                        icon: Icons.password,
                        isPasswordType: true,
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        enabled: true,
                      ),
                      SizedBox(height: 16.h), // Add ".h" for height scaling
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    // builder: (context) => SignUp(phoneNumber: "9800515347",)),
                                    builder: (context) => WelcomeAboardScreen()),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()),
                              );
                            },
                            child: const Text(
                              'Forgot ?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 70.h), // Add ".h" for height scaling
                      GestureDetector(
                        onTap: () {
                          final phoneNumber = _phonenumberController.text;
                          final password = _passwordController.text;
                          //
                          // if (phoneNumber.isNotEmpty && password.isNotEmpty) {
                          //   loginUser(phoneNumber, password);
                          // } else {
                          //   // Handle empty fields
                          // }
                          // loginUser(phoneNumber, password);
                          loginUser(phoneNumber, password);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 47.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Center(
                            child: Text(
                              'Login',
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 18.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
