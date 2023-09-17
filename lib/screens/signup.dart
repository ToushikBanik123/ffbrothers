import 'dart:convert';
import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../utils/Widgits/WithIconTextField.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  TextEditingController _mpinController = TextEditingController();

  Future<void> registerUser(
      {required String name,
      required String phone,
      required String password,
      required String mpin}) async {
    final apiUrl = "$baseUrl/user_register.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "name": name,
        "phone": phone,
        "password": password,
        "mpin": mpin,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      // Handle the response message here (e.g., show a dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      print(message);
    } else {
      // Handle error response (e.g., show an error dialog)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notable to Register")),
      );
      print("Notable to Register");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.red],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(18.w), // Add ".w" for width scaling
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconTextField(
                      text: "Enter Your Name",
                      icon: Icons.person,
                      isPasswordType: false,
                      controller: _usernameController,
                      keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 27.h), // Add ".h" for height scaling
                  IconTextField(
                    text: "Phone Number",
                    icon: Icons.phone,
                    isPasswordType:  false,
                    controller:  _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 27.h), // Add ".h" for height scaling
                  IconTextField(
                      text: "Enter Password",
                      icon: Icons.lock_outline,
                      isPasswordType: true,
                      controller: _passwordTextController,
                     keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 27.h), // Add ".h" for height scaling
                  IconTextField(
                      text: "Confirm Password",
                      icon: Icons.password,
                      isPasswordType: true,
                      controller: _confirmController,
                      keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 27.h), // Add ".h" for height scaling
                  TextField(
                    controller: _mpinController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    maxLength: 4,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_clock_outlined,
                        color: Colors.white70,
                      ),
                      labelText: "mPin",
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 100.h), // Add ".h" for height scaling
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          // final phone = _phoneController.text;
          // final password = _passwordTextController.text;
          // final name = _usernameController.text;
          // final mpin = _mpinController.text;

          registerUser(
              name: _usernameController.text,
              phone: _phoneController.text,
              password: _passwordTextController.text,
              mpin: _mpinController.text);
        },
        child: Container(
          width: double.infinity,
          height: 47.h, // Add ".h" for height scaling
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                30.r), // Add ".r" for radius scaling
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: Text(
              'Sign Up',
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
