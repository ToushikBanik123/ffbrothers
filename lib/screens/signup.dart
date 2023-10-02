import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the toast package
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/const.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  final String phoneNumber;
  SignUp({required this.phoneNumber, Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  TextEditingController _mpinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.phoneNumber);
  }

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


  // bool validateFields() {
  //   final name = _usernameController.text;
  //   final phone = _phoneController.text;
  //   final password = _passwordTextController.text;
  //   final confirmPassword = _confirmController.text;
  //   final mpin = _mpinController.text;
  //
  //   if (name.isEmpty && phone.isEmpty && password.isEmpty && confirmPassword.isEmpty && mpin.isEmpty) {
  //     Fluttertoast.showToast(
  //       msg: "Please fill in all fields.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return false;
  //   }
  //
  //   if (password != confirmPassword) {
  //     Fluttertoast.showToast(
  //       msg: "Password and Confirm Password do not match.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //     return false;
  //   }
  //
  //   return true;
  // }
  bool validateFields() {
    final name = _usernameController.text;
    final phone = _phoneController.text;
    final password = _passwordTextController.text;
    final confirmPassword = _confirmController.text;
    final mpin = _mpinController.text;

    if (name.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty || mpin.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in all fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(
        msg: "Password and Confirm Password do not match.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF335BCE),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Register your account',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp,),
                  child: Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                buildTextField(
                  hintText: 'Enter name',
                  controller: _usernameController,
                  isPassword: false,
                  keyboardType: TextInputType.name,
                  enabled: true,
                ),
                SizedBox(height: 0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp,),
                  child: Text(
                    'Phone No',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                buildTextField(
                  hintText: "Phone Number",
                  isPassword: false,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: false,
                ),
                SizedBox(height: 0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp,),
                  child: Text(
                    'Enter Password',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                buildTextField(
                  hintText: "Enter Password",
                  isPassword: true,
                  controller: _passwordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  enabled: true,
                ),
                SizedBox(height: 0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp,),
                  child: Text(
                    'Confirm Password',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                buildTextField(
                  hintText: "Confirm Password",
                  isPassword: true,
                  controller: _confirmController,
                  keyboardType: TextInputType.visiblePassword,
                  enabled: true,
                ),
                SizedBox(height: 0.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp,),
                  child: Text(
                    'M-Pin',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
                  color: Color(0xFFE8E8E8),
                  child: TextField(
                    controller: _mpinController,
                    style: TextStyle(color: Colors.black),
                    maxLength: 4,
                    decoration: InputDecoration(
                      hintText: "mPin",
                      border: OutlineInputBorder(),
                      counterText: "", // Remove the counter text
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          if (validateFields()) {
            registerUser(
              name: _usernameController.text,
              phone: _phoneController.text,
              password: _passwordTextController.text,
              mpin: _mpinController.text,
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: Color(0xFF335BCE),
            borderRadius: BorderRadius.circular(12.r),
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

  Widget buildTextField({
    required String hintText,
    required bool isPassword,
    required bool enabled,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 10.sp),
      color: Color(0xFFE8E8E8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }


}


