// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';
//
// import '../Provider/AppProvider.dart';
// import 'home.dart';
//
// class MPinScreen extends StatefulWidget {
//   @override
//   _MPinScreenState createState() => _MPinScreenState();
// }
//
// class _MPinScreenState extends State<MPinScreen> {
//   TextEditingController uidController = TextEditingController();
//   TextEditingController mpinController = TextEditingController();
//   String message = '';
//
//   Future<void> validateMPin() async {
//     String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     const String apiUrl = "https://bvaedu.com/matkaking/API/mpin_login.php";
//     final Map<String, String?> requestData = {
//       'uid': userId,
//       'mpin': mpinController.text,
//     };
//
//     final response = await http.post(Uri.parse(apiUrl), body: requestData);
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         message = data['message'];
//         if (message == "M-PIN Matched") {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => HomePage()),
//           );
//         }
//       });
//     } else {
//       setState(() {
//         message = 'Error occurred while connecting to the server';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.black,
//       //   elevation: 0,
//       //   title: Text(
//       //     'M-PIN Validation',
//       //     style: TextStyle(color: Colors.white),
//       //   ),
//       // ),
//       body: Stack(
//         children: [
//           Positioned(
//             right: -50,
//             top: -160,
//             child: Container(
//               height: 400.sp,
//               width: 400.sp,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 // borderRadius: BorderRadius.circular(700.r),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.all(16.sp),
//             decoration: BoxDecoration(
//               // gradient: LinearGradient(
//               //   begin: Alignment.topCenter,
//               //   end: Alignment.bottomCenter,
//               //   colors: [Colors.black, Colors.red],
//               // ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Text("Hello User",
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Text("Good to see you again.",
//                       style: TextStyle(
//                         //fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 50.sp),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 30,
//                       width: 30,
//                       margin: EdgeInsets.symmetric(horizontal: 10.sp),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.red),
//                       ),
//                       child: TextFormField(
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         onChanged: (Value){
//                           if(Value.length ==  1){
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         onSaved: (pin1){
//
//                         },
//                         inputFormatters: [LengthLimitingTextInputFormatter(1)],
//                         decoration: InputDecoration(
//                           border: InputBorder.none, // Remove the underline
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 30,
//                       width: 30,
//                       margin: EdgeInsets.symmetric(horizontal: 10.sp),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.red),
//                       ),
//                       child: TextFormField(
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         onChanged: (Value){
//                           if(Value.length ==  1){
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         onSaved: (pin2){
//
//                         },
//                         inputFormatters: [LengthLimitingTextInputFormatter(1)],
//                         decoration: InputDecoration(
//                           border: InputBorder.none, // Remove the underline
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 30,
//                       width: 30,
//                       margin: EdgeInsets.symmetric(horizontal: 10.sp),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.red),
//                       ),
//                       child: TextFormField(
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         onChanged: (Value){
//                           if(Value.length ==  1){
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         onSaved: (pin3){
//
//                         },
//                         inputFormatters: [LengthLimitingTextInputFormatter(1)],
//                         decoration: InputDecoration(
//                           border: InputBorder.none, // Remove the underline
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 30,
//                       width: 30,
//                       margin: EdgeInsets.symmetric(horizontal: 10.sp),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.red),
//                       ),
//                       child: TextFormField(
//                         keyboardType: TextInputType.number,
//                         textAlign: TextAlign.center,
//                         onSaved: (pin4){
//
//                         },
//                         onChanged: (Value){
//                           if(Value.length ==  1){
//                             FocusScope.of(context).nextFocus();
//                           }
//                         },
//                         inputFormatters: [LengthLimitingTextInputFormatter(1)],
//                         decoration: InputDecoration(
//                           border: InputBorder.none, // Remove the underline
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 50.sp),
//
//                 // TextField(
//                 //   controller: mpinController,
//                 //   cursorColor: Colors.white,
//                 //   style: TextStyle(color: Colors.white),
//                 //   maxLength: 4,
//                 //   decoration: InputDecoration(
//                 //     prefixIcon: const Icon(
//                 //       Icons.lock_clock_outlined,
//                 //       color: Colors.white70,
//                 //     ),
//                 //     labelText: "mPin",
//                 //     labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
//                 //     filled: true,
//                 //     floatingLabelBehavior: FloatingLabelBehavior.never,
//                 //     fillColor: Colors.white.withOpacity(0.3),
//                 //     border: OutlineInputBorder(
//                 //       borderRadius: BorderRadius.circular(30.0),
//                 //       borderSide: BorderSide(width: 0, style: BorderStyle.none),
//                 //     ),
//                 //   ),
//                 //   keyboardType: TextInputType.number,
//                 // ),
//                 // SizedBox(height: 20.sp),
//                 ElevatedButton(
//                   onPressed: validateMPin,
//                   child: Container(
//                     width: double.infinity,
//                     height: 47.h, // Add ".h" for height scaling
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(
//                           30.r), // Add ".r" for radius scaling
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 20.w),
//                     child: Center(
//                       child: Text(
//                         'Validate M-PIN',
//                         style: TextStyle(
//                           decoration: TextDecoration.none,
//                           fontSize: 18.sp,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.sp),
//                 Text(message, style: TextStyle(fontSize: 16,color: Colors.white)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//
//
//   }
// }
//

import 'package:ff/screens/signup.dart';
import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../Provider/AppProvider.dart';
import 'home.dart';

class MPinScreen extends StatefulWidget {
  @override
  _MPinScreenState createState() => _MPinScreenState();
}

class _MPinScreenState extends State<MPinScreen> {
  List<FocusNode> pinFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<TextEditingController> pinControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  String message = '';

  Future<void> validateMPin() async {
    String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    String apiUrl = "$baseUrl/mpin_login.php";
    final Map<String, String?> requestData = {
      'uid': userId,
      'mpin': pinControllers.map((controller) => controller.text).join(),
    };

    final response = await http.post(Uri.parse(apiUrl), body: requestData);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        message = data['message'];
        if (message == "M-PIN Matched") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    } else {
      setState(() {
        message = 'Error occurred while connecting to the server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: -50,
            top: -160,
            child: Container(
              height: 400.sp,
              width: 400.sp,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                 Positioned(
                     right: 100.sp,
                     bottom: 100.sp,
                     child:  Text("FF   Brothers",
                    style: GoogleFonts.almendraSc(
                     color: Colors.white,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                   ),
                 ))
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Hello User",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Good to see you again.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.symmetric(horizontal: 10.sp),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red),
                        ),
                        child: TextFormField(
                          controller: pinControllers[i],
                          focusNode: pinFocusNodes[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.transparent,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1)
                          ],
                          onChanged: (Value) {
                            if (Value.length == 1) {
                              int currentIndex = i;
                              if (currentIndex < 3) {
                                FocusScope.of(context).requestFocus(
                                  pinFocusNodes[currentIndex + 1],
                                );
                              } else {
                                validateMPin();
                              }
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 60.sp,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Container(
                      height: 1.sp,
                      width: 60.sp,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(message,
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: validateMPin,
        child: Container(
          width: double.infinity,
          height: 47.h,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          child: Center(
            child: Text(
              'Validate M-PIN',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 18.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
