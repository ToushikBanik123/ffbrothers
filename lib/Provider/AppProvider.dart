import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/UserModel.dart';
import 'package:http/http.dart' as http;

import '../screens/otp_screen.dart';
import '../screens/signup.dart';
import '../utils/utils.dart';

class AppProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  UserModel? get user => _user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void setUser(UserModel? value) {
    _user = value;
    notifyListeners();
  }

  // // signin
  // void signInWithPhone(BuildContext context, String phoneNumber) async {
  //   try {
  //     await _firebaseAuth.verifyPhoneNumber(
  //         phoneNumber: phoneNumber,
  //         verificationCompleted:
  //             (PhoneAuthCredential phoneAuthCredential) async {
  //           // await _firebaseAuth.signInWithCredential(phoneAuthCredential);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //               builder: (context) => SignUp(phoneNumber: phoneNumber),
  //               ),
  //           );
  //           showSnackBar(context,"Calling _firebaseAuth.verifyPhoneNumber");
  //         },
  //         verificationFailed: (error) {
  //           // showSnackBar(context,"Calling verificationFailed");
  //           showSnackBar(context,error.message.toString());
  //           throw Exception(error.message);
  //         },
  //         codeSent: (verificationId, forceResendingToken) {
  //           print("codeSent");
  //           showSnackBar(context,"Calling codeSent");
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => OtpScreen(verificationId: verificationId),
  //             ),
  //           );
  //         },
  //         codeAutoRetrievalTimeout: (verificationId) {});
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //   }
  // }


  // verify otp
  // void verifyOtp({
  //   required BuildContext context,
  //   required String verificationId,
  //   required String userOtp,
  //   required Function onSuccess,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     PhoneAuthCredential creds = PhoneAuthProvider.credential(
  //         verificationId: verificationId, smsCode: userOtp);
  //     onSuccess();
  //     _isLoading = false;
  //     notifyListeners();
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message.toString());
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      // Attempt to sign in with the provided credentials
      UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(creds);

      // If signInWithCredential succeeds, it means the OTP was correct
      if (userCredential.user != null) {
        // The OTP was verified correctly
        onSuccess(userCredential.user!.phoneNumber.toString());
      } else {
        // The OTP verification failed
        showSnackBar(context, "OTP verification failed.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication exceptions here
      showSnackBar(context, e.message.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}