// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../Provider/AppProvider.dart';
// import 'home.dart';
//
// class Withdrawl extends StatefulWidget {
//   const Withdrawl({Key? key}) : super(key: key);
//
//   @override
//   State<Withdrawl> createState() => _WithdrawlState();
// }
//
// class _WithdrawlState extends State<Withdrawl> {
//   TextEditingController _amountController = TextEditingController();
//   String balance = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBalance();
//   }
//
//   Future<void> fetchBalance() async {
//     final uri = Uri.parse('https://bvaedu.com/matkaking/API/wallet_balance.php');
//     String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     final response = await http.post(uri, body: {'uid': userId});
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['balance'] != null && data['balance'].isNotEmpty) {
//         setState(() {
//           balance = data['balance'][0]['balance'];
//         });
//       } else {
//         setState(() {
//           balance = 'No balance found';
//         });
//       }
//     } else {
//       throw Exception('Failed to load balance');
//     }
//   }
//
//   Future<void> _handleWithdrawalRequest() async {
//     final userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     final amount = _amountController.text;
//
//     if (userId == null) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text("User ID is not available."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     if (double.tryParse(amount) == null || double.parse(amount) < 300) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text("Withdrawal amount must be at least Rs. 300."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     // Ensure the withdrawal amount is less than or equal to the user's balance
//     if (double.parse(amount) > double.parse(balance)) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text("Withdrawal amount cannot exceed your account balance."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//       return;
//     }
//
//     final Uri uri = Uri.parse("https://bvaedu.com/matkaking/API/fund_withdraw_request.php");
//     final Map<String, String> body = {
//       "uid": userId,
//       "amount": amount,
//     };
//
//     final response = await http.post(uri, body: body);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final String message = data['message'];
//
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Withdrawal Request"),
//             content: Text(message),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   // Navigator.of(context).pop();
//                   Navigator.pushReplacement(
//                     // Use pushReplacement to prevent going back to the login screen
//                     context,
//                     MaterialPageRoute(builder: (context) => HomePage()),
//                   );
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       // Handle error
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text("An error occurred while processing your request."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   void _showErrorSnackBar(String errorMessage) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(errorMessage),
//         duration: Duration(seconds: 3),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.cyan,
//         title: Text('Withdraw Money'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           children: [
//             SizedBox(height: 10.h),
//             Center(
//               child: Text(
//                 'Current Points : $balance',
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), // Add ".sp" for font size scaling
//               ),
//             ),
//             SizedBox(height: 20.h),
//             Center(
//               child: Text(
//                 'You should withdraw at least Rs. 300',
//                 style: TextStyle(fontSize: 14.sp, color: Colors.grey),
//               ),
//             ),
//             SizedBox(height: 50.h),
//             TextFormField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(50.r),
//                 ),
//                 hintText: 'Enter Rs.',
//               ),
//             ),
//             SizedBox(height: 70.h),
//             GestureDetector(
//               onTap: () async {
//                 final withdrawalAmount = double.parse(_amountController.text);
//                 final availableBalance = double.parse(balance);
//
//                 if (withdrawalAmount < 300) {
//                   _showErrorSnackBar("Withdrawal amount must be at least Rs. 300.");
//                 } else if (withdrawalAmount > availableBalance) {
//                   _showErrorSnackBar("Withdrawal amount cannot exceed your account balance.");
//                 } else {
//                   await _handleWithdrawalRequest();
//                 }
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 47.h,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [Colors.cyan, Colors.blue],
//                   ),
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Withdraw',
//                     style: TextStyle(
//                       decoration: TextDecoration.none,
//                       fontSize: 18.sp,
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
import 'dart:convert';
import 'package:ff/utils/const.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../Provider/AppProvider.dart';
import 'home.dart';

class Withdrawl extends StatefulWidget {
  const Withdrawl({Key? key}) : super(key: key);

  @override
  State<Withdrawl> createState() => _WithdrawlState();
}

class _WithdrawlState extends State<Withdrawl> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _upiController = TextEditingController(); // Added UPI field
  String balance = '';

  @override
  void initState() {
    super.initState();
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    final uri = Uri.parse('$baseUrl/wallet_balance.php');
    String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    final response = await http.post(uri, body: {'uid': userId});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['balance'] != null && data['balance'].isNotEmpty) {
        setState(() {
          balance = data['balance'][0]['balance'];
        });
      } else {
        setState(() {
          balance = 'No balance found';
        });
      }
    } else {
      throw Exception('Failed to load balance');
    }
  }

  Future<void> _handleWithdrawalRequest() async {
    final userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    final amount = _amountController.text;
    final upi = _upiController.text;

    if (userId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("User ID is not available."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (double.tryParse(amount) == null || double.parse(amount) < 300) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Withdrawal amount must be at least Rs. 300."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Ensure the withdrawal amount is less than or equal to the user's balance
    if (double.parse(amount) > double.parse(balance)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Withdrawal amount cannot exceed your account balance."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    final Uri uri = Uri.parse("$baseUrl/fund_withdraw_request.php");
    final Map<String, String> body = {
      "uid": userId,
      "amount": amount,
      "upi": upi, // Add UPI parameter
    };

    final response = await http.post(uri, body: body);
    print(response.statusCode.toString());

    // if (response.statusCode == 500) {
      final data = json.decode(response.body);
      final String message = data['message'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Withdrawal Request Done"),
            // content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text("Error"),
    //         content: Text("An error occurred while processing your request."),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text("OK"),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Withdraw Money'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Center(
              child: Text(
                'Current Points : $balance',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Text(
                'You should withdraw at least Rs. 300',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                hintText: 'Enter Rs.',
              ),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              controller: _upiController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                hintText: 'Enter Payment Number',
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                final withdrawalAmount = double.parse(_amountController.text);
                final availableBalance = double.parse(balance);

                if (withdrawalAmount < 300) {
                  _showErrorSnackBar("Withdrawal amount must be at least Rs. 300.");
                } else if (withdrawalAmount > availableBalance) {
                  _showErrorSnackBar("Withdrawal amount cannot exceed your account balance.");
                } else {
                  await _handleWithdrawalRequest();
                }
              },
              child: Container(
                width: double.infinity,
                height: 47.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.cyan, Colors.blue],
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Text(
                    'Withdraw',
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
          ],
        ),
      ),
    );
  }
}
