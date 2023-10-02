// import 'dart:convert';
//
// import 'package:ff/screens/walletpage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../Model/Game.dart';
// import '../Provider/AppProvider.dart';
// import '../utils/Widgits/SeparateTabBar.dart';
// import 'gameBajiList.dart';
//
// class AddBet extends StatefulWidget {
//   final Game game;
//   final String mainGameId;
//   final int tabIndex;
//   AddBet({
//     required this.game,
//     required this.mainGameId,
//     required this.tabIndex
//   });
//
//   @override
//   _AddBetState createState() => _AddBetState();
// }
//
// class _AddBetState extends State<AddBet> with SingleTickerProviderStateMixin {
//   final PageController _controller = PageController(initialPage: 0);
//   late TabController _tabController;
//   TextEditingController _betController = TextEditingController();
//   TextEditingController _rsController = TextEditingController();
//   String balance = 'Loading...';
//   List<dynamic> betHistory = [];
//   String? userId;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _tabController = TabController(initialIndex: widget.tabIndex, length: 6, vsync: this);
//   //   userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//   //   _fetchBalance();
//   //   _fetchBetHistory(tabs[widget.tabIndex]);
//   // }
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(initialIndex: widget.tabIndex, length: 6, vsync: this);
//     _tabController.addListener(_handleTabChange); // Add this line
//     userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     _fetchBalance();
//     // _fetchBetHistory(tabs[widget.tabIndex]);
//   }
//
//
//   void _handleTabChange() {
//     int selectedIndex = _tabController.index;
//     String selectedTab = tabs[selectedIndex];
//     print('Tab changed to: $selectedTab');
//     // Perform any actions you want when the tab changes
//     // _fetchBetHistory(selectedTab); // For example, fetching new data based on the selected tab
//   }
//
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _betController.dispose();
//     _rsController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchBalance() async {
//     final uri = Uri.parse('https://bvaedu.com/matkaking/API/wallet_balance.php');
//     String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     try {
//       final response = await http.post(uri, body: {'uid': userId});
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           balance = data['balance']?.isNotEmpty ?? false ? data['balance'][0]['balance'] : 'No balance found';
//         });
//       } else {
//         throw Exception('Failed to load balance');
//       }
//     } catch (e) {
//       setState(() {
//         balance = 'Error: $e';
//       });
//     }
//   }
//
//
//   // Future<void> _fetchBetHistory(String betOn) async {
//   //   final uri = Uri.parse("https://bvaedu.com/matkaking/API/game_wise_bet_history.php");
//   //   try {
//   //     final response = await http.post(uri, body: {
//   //       'uid': userId,
//   //       'bet_on': betOn,
//   //       'game_id': widget.game.id, // Convert the gameId to a string
//   //     });
//   //     if (response.statusCode == 200) {
//   //       final Map<String, dynamic> data = json.decode(response.body);
//   //       setState(() {
//   //         betHistory = data['gamelist'] ?? [];
//   //       });
//   //     } else {
//   //       throw Exception('Failed to fetch bet history');
//   //     }
//   //   } catch (e) {
//   //     showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return AlertDialog(
//   //           title: Text('Error'),
//   //           content: Text('Failed to fetch bet history. Please try again.'),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () {
//   //                 Navigator.of(context).pop();
//   //               },
//   //               child: Text('OK'),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //   }
//   // }
//
//
//   // Future<void> _sendBetRequest({
//   //   required String uid,
//   //   required String game_id,
//   //   required String bet_on,
//   //   required String bet_number,
//   //   required String bet_amount,
//   //   required String market_time,
//   // }) async {
//   //   final uri = Uri.parse("https://bvaedu.com/matkaking/API/user_bet.php");
//   //   final response = await http.post(
//   //     uri,
//   //     body: {
//   //       'uid': uid,
//   //       'game_id': game_id,
//   //       'bet_on': bet_on,
//   //       'bet_number': bet_number,
//   //       'bet_amount': bet_amount,
//   //       'market_time': market_time,
//   //     },
//   //   );
//   //
//   //   if (response.statusCode == 200) {
//   //     final jsonResponse = response.body;
//   //     final parsedResponse = json.decode(jsonResponse);
//   //     if (parsedResponse.containsKey('message')) {
//   //       final message = parsedResponse['message'];
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text(message)),
//   //       );
//   //       if (message == "User Bet Successful") {
//   //         _fetchBalance();
//   //         // _fetchBetHistory(tabs[_tabController.index]);
//   //       }
//   //     } else {
//   //       print('API Response: Unknown');
//   //     }
//   //   } else {
//   //     print('API Error: ${response.statusCode}');
//   //   }
//   // }
//
//   Future<void> _sendBetRequest({
//     required String uid,
//     required String game_id,
//     required String game_baji_id,
//     required String bet_on,
//     required String bet_number,
//     required String bet_amount,
//   }) async {
//     final uri = Uri.parse("https://bvaedu.com/matkaking/API/user_bet.php");
//     final response = await http.post(
//       uri,
//       body: {
//         'uid': uid,
//         'game_id': game_id,
//         'game_baji_id': game_baji_id, // Add game_baji_id to the request
//         'bet_on': bet_on,
//         'bet_number': bet_number,
//         'bet_amount': bet_amount,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = response.body;
//       final parsedResponse = json.decode(jsonResponse);
//       if (parsedResponse.containsKey('message')) {
//         final message = parsedResponse['message'];
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//         if (message == "User Bet Successful") {
//           _fetchBalance();
//           // _fetchBetHistory(tabs[_tabController.index]);
//         }
//       } else {
//         print('API Response: Unknown');
//       }
//     } else {
//       print('API Error: ${response.statusCode}');
//     }
//   }
//
//
//   List<String> tabs = [
//     'Single',
//     'Patti',
//     // 'CP Patti',
//     // 'Jori',
//     // 'Jor',
//     // 'Bijor',
//   ];
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text(
//           'FF Brothers',
//           style: GoogleFonts.dancingScript(
//             fontSize: 25.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.wallet,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => WalletPage()),
//                   );
//                 },
//               ),
//               Text(
//                 '$balance',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // SeparateTabBar(tabController: _tabController, tabs: tabs),
//           // SeparateTabBar(tabController: _tabController, tabs: tabs),
//           TabBar(
//             controller: _tabController,
//             isScrollable: true,
//             tabs: tabs.map((String tab) {
//               return Tab(text: tab);
//             }).toList(),
//             onTap: (index) {
//               _tabController.animateTo(index); // Add this line
//             },
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 for (String tab in tabs)
//                   Container(
//                     height: screenHeight.h,
//                     width: screenWidth.w,
//                     child: Column(
//                       children: [
//                         SizedBox(height: 30.h),
//                         SizedBox(height: 5.h),
//                         Padding(
//                           padding: EdgeInsets.all(16.r),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _betController,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.r),
//                                     ),
//                                     hintText: 'Enter Bet Number',
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 16.w),
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _rsController,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.r),
//                                     ),
//                                     hintText: 'Enter Rs.',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30.h),
//                         GestureDetector(
//                           onTap: () {
//                             // Get the current balance as a numeric value
//                             double currentBalance = double.tryParse(balance) ?? 0.0;
//
//                             // Get the entered bet amount as a numeric value
//                             double betAmount = double.tryParse(_rsController.text) ?? 0.0;
//
//                             if (_rsController.text.isNotEmpty && _betController.text.isNotEmpty) {
//                               if (betAmount <= currentBalance) {
//                                 // TODO Fix the Ui
//                                 _sendBetRequest(
//                                   uid: Provider.of<AppProvider>(context, listen: false).user!.id,
//                                   bet_amount: betAmount.toString(),
//                                   bet_number: _betController.text.toString(),
//                                   bet_on: tab,
//                                   game_id: widget.mainGameId,
//                                   game_baji_id: widget.game.id,
//                                   // market_time: widget.game.isGameOpen() ? 'Market Running' : 'Market Closed',
//                                 );
//                               } else {
//                                 _showSnackBar('Bet amount exceeds available balance.');
//                               }
//                             } else {
//                               _showSnackBar('Please enter values for both fields.');
//                             }
//                           },
//                           child: Container(
//                             width: 300.w,
//                             height: 47.h,
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Add Bet',
//                                 style: TextStyle(
//                                   decoration: TextDecoration.none,
//                                   fontSize: 18.sp,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 30.h),
//                         Expanded(
//                           child: ListView.builder(
//                             // shrinkWrap: true,
//                             itemCount: betHistory.length + 1, // +1 for the header
//                             itemBuilder: (context, index) {
//                               if (index == 0) {
//                                 return Container(
//                                   decoration: const BoxDecoration(
//                                     color: Colors.red,
//                                   ),
//                                   child: const Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text('Bet Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                                         Text('Bet Amount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                                         Text('Edit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 final item = betHistory[index - 1]; // Subtract 1 to adjust for the header
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                     color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text('${item['bet_number']}'),
//                                         Text('${item['bet_amount']}'),
//                                         Text('${item['bet_time']}'),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//

//TODO

import 'dart:convert';

import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Model/Game.dart';
import '../Provider/AppProvider.dart';
import '../utils/Widgits/SeparateTabBar.dart';
import 'gameBajiList.dart';

// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
//
// import '../Model/Game.dart';
// import '../Provider/AppProvider.dart';
// import '../utils/Widgits/SeparateTabBar.dart';
// import 'gameBajiList.dart';
//
// class AddBet extends StatefulWidget {
//   final Game game;
//   final String mainGameId;
//   final int tabIndex;
//   AddBet({
//     required this.game,
//     required this.mainGameId,
//     required this.tabIndex,
//   });
//
//   @override
//   _AddBetState createState() => _AddBetState();
// }
//
// class _AddBetState extends State<AddBet> with SingleTickerProviderStateMixin {
//   final PageController _controller = PageController(initialPage: 0);
//   late TabController _tabController;
//   TextEditingController _betController = TextEditingController();
//   TextEditingController _rsController = TextEditingController();
//   String balance = 'Loading...';
//   List<Map<String, dynamic>> betHistory = []; // Changed to a list of maps
//   String? userId;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController =
//         TabController(initialIndex: widget.tabIndex, length: 6, vsync: this);
//     _tabController.addListener(_handleTabChange);
//     userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     _fetchBalance();
//   }
//
//   void _handleTabChange() {
//     int selectedIndex = _tabController.index;
//     String selectedTab = tabs[selectedIndex];
//     print('Tab changed to: $selectedTab');
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _betController.dispose();
//     _rsController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchBalance() async {
//     final uri = Uri.parse('https://bvaedu.com/matkaking/API/wallet_balance.php');
//     String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     try {
//       final response = await http.post(uri, body: {'uid': userId});
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           balance = data['balance']?.isNotEmpty ?? false
//               ? data['balance'][0]['balance']
//               : 'No balance found';
//         });
//       } else {
//         throw Exception('Failed to load balance');
//       }
//     } catch (e) {
//       setState(() {
//         balance = 'Error: $e';
//       });
//     }
//   }
//
//   List<String> tabs = [
//     'Single',
//     'Patti',
//     // 'CP Patti',
//     // 'Jori',
//     // 'Jor',
//     // 'Bijor',
//   ];
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text(
//           'FF Brothers',
//           style: GoogleFonts.dancingScript(
//             fontSize: 25.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.wallet,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   // Navigate to WalletPage
//                 },
//               ),
//               Text(
//                 '$balance',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           TabBar(
//             controller: _tabController,
//             isScrollable: true,
//             tabs: tabs.map((String tab) {
//               return Tab(text: tab);
//             }).toList(),
//             onTap: (index) {
//               _tabController.animateTo(index);
//             },
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 for (String tab in tabs)
//                   Container(
//                     height: screenHeight.h,
//                     width: screenWidth.w,
//                     child: Column(
//                       children: [
//                         SizedBox(height: 30.h),
//                         SizedBox(height: 5.h),
//                         Padding(
//                           padding: EdgeInsets.all(16.r),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _betController,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.r),
//                                     ),
//                                     hintText: 'Enter Bet Number',
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 16.w),
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: _rsController,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10.r),
//                                     ),
//                                     hintText: 'Enter Rs.',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30.h),
//                         GestureDetector(
//                           onTap: () {
//                             double currentBalance =
//                                 double.tryParse(balance) ?? 0.0;
//                             double betAmount =
//                                 double.tryParse(_rsController.text) ?? 0.0;
//                             if (_rsController.text.isNotEmpty &&
//                                 _betController.text.isNotEmpty) {
//                               if (betAmount <= currentBalance) {
//                                 // Add the bet locally to the betHistory list
//                                 setState(() {
//                                   betHistory.add({
//                                     'bet_number': _betController.text,
//                                     'bet_amount': _rsController.text,
//                                   });
//                                 });
//                                 // Clear the input fields
//                                 _betController.clear();
//                                 _rsController.clear();
//                               } else {
//                                 _showSnackBar(
//                                     'Bet amount exceeds available balance.');
//                               }
//                             } else {
//                               _showSnackBar(
//                                   'Please enter values for both fields.');
//                             }
//                           },
//                           child: Container(
//                             width: 300.w,
//                             height: 47.h,
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Add Bet',
//                                 style: TextStyle(
//                                   decoration: TextDecoration.none,
//                                   fontSize: 18.sp,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 30.h),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: betHistory.length,
//                             itemBuilder: (context, index) {
//                               final item = betHistory[index];
//                               return Container(
//                                 decoration: BoxDecoration(
//                                   color: index % 2 == 0
//                                       ? Colors.grey[200]
//                                       : Colors.white,
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 12),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text('${item['bet_number']}'),
//                                       Text('${item['bet_amount']}'),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Confirm Bet button is pressed
//           _confirmBets();
//         },
//         child: Icon(Icons.check),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   void _confirmBets() async {
//     for (var bet in betHistory) {
//       double currentBalance = double.tryParse(balance) ?? 0.0;
//       double betAmount = double.tryParse(bet['bet_amount']) ?? 0.0;
//       if (betAmount <= currentBalance) {
//         // Send each bet to the API one by one
//         await _sendBetRequest(
//           uid: userId!,
//           game_id: widget.mainGameId,
//           game_baji_id: widget.game.id,
//           bet_on: tabs[_tabController.index],
//           bet_number: bet['bet_number'],
//           bet_amount: bet['bet_amount'],
//         );
//       } else {
//         _showSnackBar('Bet amount exceeds available balance.');
//         break; // Stop sending bets if one bet exceeds the balance
//       }
//     }
//   }
//
//   Future<void> _sendBetRequest({
//     required String uid,
//     required String game_id,
//     required String game_baji_id,
//     required String bet_on,
//     required String bet_number,
//     required String bet_amount,
//   }) async {
//     final uri = Uri.parse("https://bvaedu.com/matkaking/API/user_bet.php");
//     final response = await http.post(
//       uri,
//       body: {
//         'uid': uid,
//         'game_id': game_id,
//         'game_baji_id': game_baji_id,
//         'bet_on': bet_on,
//         'bet_number': bet_number,
//         'bet_amount': bet_amount,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonResponse = response.body;
//       final parsedResponse = json.decode(jsonResponse);
//       if (parsedResponse.containsKey('message')) {
//         final message = parsedResponse['message'];
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//         if (message == "User Bet Successful") {
//           _fetchBalance();
//         }
//       } else {
//         print('API Response: Unknown');
//       }
//     } else {
//       print('API Error: ${response.statusCode}');
//     }
//   }
// }


class AddBet extends StatefulWidget {
  final Game game;
  final String mainGameId;
  final int tabIndex;
  AddBet({
    required this.game,
    required this.mainGameId,
    required this.tabIndex,
  });

  @override
  _AddBetState createState() => _AddBetState();
}

class _AddBetState extends State<AddBet>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController(initialPage: 0);
  late TabController _tabController;
  TextEditingController _betController = TextEditingController();
  TextEditingController _rsController = TextEditingController();
  String balance = 'Loading...';
  List<Map<String, dynamic>> betHistory = [];
  String? userId;

  // Variables to store the edited bet values
  String? editedBetNumber;
  String? editedBetAmount;
  int? editedBetIndex;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: widget.tabIndex, length: 6, vsync: this);
    _tabController.addListener(_handleTabChange);
    userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    _fetchBalance();
  }

  void _handleTabChange() {
    int selectedIndex = _tabController.index;
    String selectedTab = tabs[selectedIndex];
    print('Tab changed to: $selectedTab');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _betController.dispose();
    _rsController.dispose();
    super.dispose();
  }

  Future<void> _fetchBalance() async {
    final uri = Uri.parse('$baseUrl/wallet_balance.php');
    String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    try {
      final response = await http.post(uri, body: {'uid': userId});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          balance = data['balance']?.isNotEmpty ?? false
              ? data['balance'][0]['balance']
              : 'No balance found';
        });
      } else {
        throw Exception('Failed to load balance');
      }
    } catch (e) {
      setState(() {
        balance = 'Error: $e';
      });
    }
  }

  List<String> tabs = [
    'Single',
    'Patti',
    // 'CP Patti',
    // 'Jori',
    // 'Jor',
    // 'Bijor',
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showEditDialog(int index) {
    // Get the bet to be edited
    final betToEdit = betHistory[index];
    editedBetIndex = index;

    // Set the initial values in the edit dialog
    editedBetNumber = betToEdit['bet_number'];
    editedBetAmount = betToEdit['bet_amount'];

    // Show the edit dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Bet'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: TextEditingController(text: editedBetNumber),
                onChanged: (value) {
                  editedBetNumber = value;
                },
                decoration: InputDecoration(
                  labelText: 'Bet Number',
                ),
              ),
              TextFormField(
                controller: TextEditingController(text: editedBetAmount),
                onChanged: (value) {
                  editedBetAmount = value;
                },
                decoration: InputDecoration(
                  labelText: 'Bet Amount',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Apply the edited values
                if (editedBetIndex != null) {
                  setState(() {
                    betHistory[editedBetIndex!] = {
                      'bet_number': editedBetNumber,
                      'bet_amount': editedBetAmount,
                      'isPlaced': false, // Reset isPlaced when edited
                    };
                  });
                  editedBetIndex = null;
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'FF Brothers',
          style: GoogleFonts.dancingScript(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.wallet,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navigate to WalletPage
                },
              ),
              Text(
                '$balance',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: tabs.map((String tab) {
              return Tab(text: tab);
            }).toList(),
            onTap: (index) {
              _tabController.animateTo(index);
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (String tab in tabs)
                  Container(
                  height: screenHeight.h,
                  width: screenWidth.w,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _betController,
                                keyboardType: TextInputType.number,
                                // maxLength: 1,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  hintText: 'Enter Bet Number',
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: TextFormField(
                                controller: _rsController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  hintText: 'Enter Rs.',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.h),
                      GestureDetector(
                        onTap: () {
                          double currentBalance =
                              double.tryParse(balance) ?? 0.0;
                          double betAmount =
                              double.tryParse(_rsController.text) ?? 0.0;
                          if (_rsController.text.isNotEmpty &&
                              _betController.text.isNotEmpty) {
                            if (betAmount <= currentBalance) {
                              // Add the bet locally to the betHistory list
                              setState(() {
                                betHistory.add({
                                  'bet_number': _betController.text,
                                  'bet_amount': _rsController.text,
                                  'isPlaced': false, // Initialize isPlaced
                                });
                              });
                              // Clear the input fields
                              _betController.clear();
                              _rsController.clear();
                            } else {
                              _showSnackBar(
                                  'Bet amount exceeds available balance.');
                            }
                          } else {
                            _showSnackBar(
                                'Please enter values for both fields.');
                          }
                        },
                        child: Container(
                          width: 300.w,
                          height: 47.h,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Text(
                              'Add Bet',
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
                      SizedBox(height: 30.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: betHistory.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width : 100.sp,
                                          alignment: Alignment.center,
                                          child: Text('Bet Number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                      Container(
                                          width : 100.sp,
                                          alignment: Alignment.center,
                                          child: Text('Bet Amount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                      Container(
                                          width : 100.sp,
                                          alignment: Alignment.center,
                                          child: Text('Action', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                ),
                              );
                            }else{
                              final item = betHistory[index - 1 ];
                              final bool isPlaced = item['isPlaced'] ?? false;
                              return Container(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? Colors.grey[200]
                                      : Colors.white,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width : 100.sp,
                                          alignment: Alignment.center,
                                          child: Text('${item['bet_number']}')),
                                      Container(
                                          width : 100.sp,
                                          alignment: Alignment.center,
                                          child: Text('${item['bet_amount']}')),
                                      Container(
                                        width : 100.sp,
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            if (!isPlaced) // Only show edit and delete buttons if the bet is not placed
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  _showEditDialog(index - 1);
                                                },
                                              ),
                                            if (!isPlaced)
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  _deleteBet(index - 1);
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (isPlaced)
                                        Container(
                                          width : 50.sp,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Placed',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              decoration:
                                              TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          // Confirm Bet button is pressed
          _confirmBets();
        },
        child: Container(
          width: 100.sp,
          height: 40.sp,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10.sp),
          ),
          alignment: Alignment.center,
          child: Text("Submit",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _deleteBet(int index) {
    setState(() {
      betHistory.removeAt(index);
    });
  }

  void _confirmBets() async {
    for (var bet in betHistory) {
      double currentBalance = double.tryParse(balance) ?? 0.0;
      double betAmount = double.tryParse(bet['bet_amount']) ?? 0.0;
      if (betAmount <= currentBalance) {
        // Send each bet to the API one by one
        await _sendBetRequest(
          uid: userId!,
          game_id: widget.mainGameId,
          game_baji_id: widget.game.id,
          bet_on: tabs[_tabController.index],
          bet_number: bet['bet_number'],
          bet_amount: bet['bet_amount'],
        );
        // Update the isPlaced field for the placed bet
        setState(() {
          bet['isPlaced'] = true;
        });
      } else {
        _showSnackBar('Bet amount exceeds available balance.');
        break; // Stop sending bets if one bet exceeds the balance
      }
    }
    betHistory = [];
  }

  Future<void> _sendBetRequest({
    required String uid,
    required String game_id,
    required String game_baji_id,
    required String bet_on,
    required String bet_number,
    required String bet_amount,
  }) async {
    final uri = Uri.parse("$baseUrl/user_bet.php");
    final response = await http.post(
      uri,
      body: {
        'uid': uid,
        'game_id': game_id,
        'game_baji_id': game_baji_id,
        'bet_on': bet_on,
        'bet_number': bet_number,
        'bet_amount': bet_amount,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = response.body;
      final parsedResponse = json.decode(jsonResponse);
      if (parsedResponse.containsKey('message')) {
        final message = parsedResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        if (message == "User Bet Successful") {
          _fetchBalance();
        }else{
          _showSnackBar(message.toString());
        }
      } else {
        print('API Response: Unknown');
      }
    } else {
      print('API Error: ${response.statusCode}');
    }
  }
}



