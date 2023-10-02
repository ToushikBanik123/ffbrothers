import 'package:ff/Provider/AppProvider.dart';
import 'package:ff/screens/login.dart';
import 'package:ff/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../utils/Widgits/custom_button.dart';
import '../utils/utils.dart';

class OtpScreen extends StatefulWidget {
  final String otp;
  final String phone;
  OtpScreen({super.key, required this.otp, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child:  Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Container(
                          width: 200.sp,
                          height: 200.sp,
                          padding: EdgeInsets.all(20.sp),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple.shade50,
                          ),
                          child: Image.asset(
                            "assets/images/image2.png",
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        Text(
                          "Verification",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        Text(
                          "Enter the OTP send to your phone number",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.sp),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 60.sp,
                            height: 60.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.purple.shade200,
                              ),
                            ),
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                        ),
                        SizedBox(height: 25.sp),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: CustomButton(
                            text: "Verify",
                            onPressed: () {
                              if (otpCode != null) {
                                verifyOtp(context, otpCode!);
                              } else {
                                showSnackBar(context, "Enter 6-Digit code");
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        Text(
                          "Didn't receive any code?",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                        SizedBox(height: 15.sp),
                        Text(
                          "Resend New Code",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // verify otp
  void verifyOtp(BuildContext context, String userOtp) {
    if(userOtp == widget.otp){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignUp(phoneNumber: widget.phone)));
    }else{
      showSnackBar(context, "Enter Correct OTP");
    }
  }
}
