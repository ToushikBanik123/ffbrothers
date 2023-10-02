// import 'package:country_picker/country_picker.dart';
// import 'package:ff/Provider/AppProvider.dart';
// import 'package:flutter/material.dart';
// // import 'package:phoneauth_firebase/provider/auth_provider.dart';
// // import 'package:phoneauth_firebase/widgets/custom_button.dart';
// import 'package:provider/provider.dart';
//
// import '../utils/Widgits/custom_button.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final TextEditingController phoneController = TextEditingController();
//
//   Country selectedCountry = Country(
//     phoneCode: "91",
//     countryCode: "IN",
//     e164Sc: 0,
//     geographic: true,
//     level: 1,
//     name: "India",
//     example: "India",
//     displayName: "India",
//     displayNameNoCountryCode: "IN",
//     e164Key: "",
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     phoneController.selection = TextSelection.fromPosition(
//       TextPosition(
//         offset: phoneController.text.length,
//       ),
//     );
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 200,
//                     height: 200,
//                     padding: const EdgeInsets.all(20.0),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.purple.shade50,
//                     ),
//                     child: Image.asset(
//                       "assets/images/image1.png",
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Register",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Add your phone number. We'll send you a verification code",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.black38,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     cursorColor: Colors.purple,
//                     controller: phoneController,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         phoneController.text = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: "Enter phone number",
//                       hintStyle: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15,
//                         color: Colors.grey.shade600,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.black12),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: const BorderSide(color: Colors.black12),
//                       ),
//                       prefixIcon: Container(
//                         padding: const EdgeInsets.all(8.0),
//                         child: InkWell(
//                           onTap: () {
//                             showCountryPicker(
//                                 context: context,
//                                 countryListTheme: const CountryListThemeData(
//                                   bottomSheetHeight: 550,
//                                 ),
//                                 onSelect: (value) {
//                                   setState(() {
//                                     selectedCountry = value;
//                                   });
//                                 });
//                           },
//                           child: Text(
//                             "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       suffixIcon: phoneController.text.length > 9
//                           ? Container(
//                               height: 30,
//                               width: 30,
//                               margin: const EdgeInsets.all(10.0),
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.green,
//                               ),
//                               child: const Icon(
//                                 Icons.done,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: CustomButton(
//                         text: "Sign Up", onPressed: () => sendPhoneNumber()),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void sendPhoneNumber() {
//     final ap = Provider.of<AppProvider>(context, listen: false);
//     String phoneNumber = phoneController.text.trim();
//     ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import '../utils/const.dart';
import 'otp_screen.dart';

class ApiResponse {
  final String message;
  final bool shouldNavigate;

  ApiResponse({required this.message, required this.shouldNavigate});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'] ?? '',
      shouldNavigate: json['return'] == "true",
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool showError = false;

  // Future<void> sendOtpAndNavigate() async {
  //   final apiUrl = "$baseUrl/otp.php";
  //   final phone = phoneController.text; // Get the phone number from the input field
  //   final otp = generateOTP(); // Generate a random 4-digit OTP
  //
  //   final response = await http.post(
  //     Uri.parse(apiUrl),
  //     body: {
  //       "phone": phone,
  //       "otp": otp,
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //
  //     final message = responseData['message'];
  //     String? shouldNavigate = responseData['return'];
  //
  //     print(message);
  //     showSnackBar(context, responseData['message']);
  //
  //     if (responseData['return'] == "true") {
  //       // Navigate to another page here
  //       Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(verificationId: otp,)));
  //     } else {
  //       // Handle the case where 'return' is false if needed
  //     }
  //   } else {
  //     // Handle API request error
  //     print("API request failed with status code ${response.statusCode}");
  //   }
  // }


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
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpScreen(otp: otp,phone: phone,)));
      return ApiResponse.fromJson(responseData);
    } else {
      throw Exception("API request failed with status code ${response.statusCode}");
    }
  }


  // Future<void> sendOtpAndNavigate() async {
  //   final phone = phoneController.text;
  //   final otp = generateOTP();
  //
  //   try {
  //     final apiResponse = await sendOtpRequest(phone, otp);
  //
  //     String message = apiResponse.message;
  //     bool shouldNavigate = apiResponse.shouldNavigate;
  //
  //     print(message);
  //
  //
  //   } catch (e) {
  //     // Handle API request error
  //     print("API request failed with error: $e");
  //   }
  // }




  String generateOTP() {
    final random = Random();
    final otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                    ),
                    child: Image.asset(
                      "assets/images/image1.png",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Add your phone number. We'll send you a verification code",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    cursorColor: Colors.purple,
                    controller: phoneController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      setState(() {
                        phoneController.text = value;
                        showError = false; // Reset the error state
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      errorText: showError
                          ? "Phone number must be 10 characters"
                          : null,
                    ),
                    maxLength: 10, // Set max length to 10 characters
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (phoneController.text.length != 10) {
                          setState(() {
                            showError = true;
                          });
                        } else {
                          // sendOtpAndNavigate();
                          sendOtpRequest();
                        }
                      },
                      child: Text("Sign Up"),
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

}



