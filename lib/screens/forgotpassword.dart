import 'dart:convert';
import 'dart:ffi';

import 'package:ff/screens/login.dart';
import 'package:ff/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'dart:math';
import '../utils/Widgits/WithIconTextField.dart';
import '../utils/const.dart';
import 'package:http/http.dart' as http;

import '../utils/utils.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool _isOtpSend = false;
  bool _isOtpVerified = true;
  bool _isPhoneNumberEditable = true;
  String? otpCode;
  String? SendOtp;
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  Future<void> updatePassword(BuildContext context, String phone, String password) async {
    final String apiUrl = '$baseUrl/update_password.php';

    // Create a map containing the data to be sent in the POST request
    final Map<String, String> data = {
      'phone': phone,
      'password': password,
    };

    // Encode the data as JSON
    final jsonData = jsonEncode(data);

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonData,
      );

      if (response.statusCode == 200) {
        // Successful response, parse the JSON data
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'];
        print("final message = jsonResponse['message'] $message for ${phone} and password $password");
        showSnackBar(context, "$message for ${phone} and password $password");
        if (message == "Password Update Successful") {
          // If password update is successful, navigate to the LoginPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Handle other cases if needed
          // You can display an error message here or take other actions
        }
      } else {
        // Handle errors here (e.g., network issues, server errors)
        throw Exception('Failed to update password');
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      throw Exception('Failed to update password');
    }
  }



  String generateOTP() {
    final random = Random();
    final otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }


  Future<ApiResponse> sendOtpRequest() async {

    final phone = phoneController.text;
    final otp = generateOTP();

    final apiUrl = "$baseUrl/otp.php";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        "phone": phone,
        "otp": otp,
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(otp: otp,phone: phone,)));
      setState(() {
        _isOtpSend = true;
        SendOtp = otp;
      });
      return ApiResponse.fromJson(responseData);
    } else {
      throw Exception("API request failed with status code ${response.statusCode}");
    }
  }

  void verifyOtp(BuildContext context, String userOtp) {
    if(userOtp == SendOtp){
      setState(() {
        _isOtpVerified = false;
        _isPhoneNumberEditable = false;
      });
    }else{
      showSnackBar(context, "Enter Correct OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red ,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
        title: Text('Forgot Password',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.black],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconTextField(
                    text: "Phone Number",
                    icon: Icons.phone,
                    isPasswordType: false,
                    controller: phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: _isPhoneNumberEditable,
                ),

                SizedBox(height: 20.sp),

                _isOtpSend? Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60.sp,
                    height: 60.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    textStyle: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      otpCode = value;
                    });
                  },
                ) : Container(),

                SizedBox(height: 27.h),
                _isOtpVerified ? Container() : _isOtpSend? IconTextField(
                    text: "Enter Password",
                    icon: Icons.lock_outline,
                    isPasswordType: true,
                    controller: passwordTextController,
                    keyboardType: TextInputType.visiblePassword,
                    enabled: true,
                ) :Container(),
                 Spacer(),
                _isOtpVerified ? _isOtpSend? GestureDetector(
                  onTap: (){
                    if (otpCode != null) {
                      verifyOtp(context, otpCode!);
                    } else {
                      showSnackBar(context, "Enter 6-Digit code");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 47.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r)),
                    child: Center(
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ) : GestureDetector(
                  onTap: (){
                    sendOtpRequest();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MyHomePage()),
                    // );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 47.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r)),
                    child: Center(
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ) : GestureDetector(
                  onTap: (){
                    // sendOtpRequest();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MyHomePage()),
                    // );
                    updatePassword(context, phoneController.text, passwordTextController.text);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 47.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r)),
                    child: Center(
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
