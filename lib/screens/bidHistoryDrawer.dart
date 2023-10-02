// import 'package:ff/utils/const.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:provider/provider.dart';
//
// import '../Model/BidHistoryItem.dart';
// import '../Provider/AppProvider.dart';
// import 'package:intl/intl.dart';
//
// class bidHistoryDrawer extends StatefulWidget {
//   const bidHistoryDrawer({Key? key}) : super(key: key);
//
//   @override
//   State<bidHistoryDrawer> createState() => _bidHistoryDrawerState();
// }
//
// class _bidHistoryDrawerState extends State<bidHistoryDrawer> {
//   late List<BidHistoryItem> bidHistory = [];
//   DateTime? selectedStartDate;
//   DateTime? selectedEndDate;
//
//   Future<void> fetchBidHistory(
//       {required String uid,
//       required String startDateFormatted,
//       required String endDateFormatted}) async {
//     print("startDateFormatted " +
//         startDateFormatted.toString() +
//         "endDateFormatted " +
//         endDateFormatted);
//
//     final response = await http.post(
//       Uri.parse("$baseUrl/bid_history.php"),
//       body: {
//         'uid': uid,
//         'start_date': startDateFormatted,
//         'end_date': endDateFormatted,
//       },
//     );
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final gamelist = data['gamelist'];
//       bidHistory =
//           List<BidHistoryItem>.from(gamelist.map((item) => BidHistoryItem(
//                 id: item['id'],
//                 gameName: item['game_name'],
//                 betOn: item['bet_on'],
//                 betNumber: item['bet_number'],
//                 betAmount: item['bet_amount'],
//                 betTime: item['bet_time'],
//                 betDate: item['bet_date'],
//               )));
//       setState(() {});
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? pickedStartDate = await showDatePicker(
//       context: context,
//       initialDate: selectedStartDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedStartDate != null) {
//       setState(() {
//         selectedStartDate = pickedStartDate;
//         // fetchBidHistory();
//       });
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context) async {
//     final DateTime? pickedEndDate = await showDatePicker(
//       context: context,
//       initialDate:
//           selectedEndDate ?? DateTime.now().subtract(Duration(days: 30)),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (pickedEndDate != null) {
//       setState(() {
//         selectedEndDate = pickedEndDate;
//         // fetchBidHistory();
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     DateTime now = DateTime.now();
//     DateTime oneMonthAgo = now.subtract(Duration(days: 30)); // 30 days ago
//     String startDateFormatted = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
//     String endDateFormatted = DateFormat('yyyy-MM-dd').format(now);
//     // selectedStartDate = startDateFormatted;
//     selectedStartDate = DateTime.parse(startDateFormatted);
//     selectedEndDate = DateTime.parse(endDateFormatted);
//     print(selectedStartDate.toString());
//     fetchBidHistory(
//         uid: userId!,
//         startDateFormatted: startDateFormatted,
//         endDateFormatted: endDateFormatted);
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//   //   String startDate = "2023-01-01"; // Replace with your start date
//   //   String endDate = "2023-12-31";   // Replace with your end date
//   //   fetchBidHistory(userId!, startDate, endDate);
//   //   // fetchBidHistory(userId!);
//   // }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//   //
//   //   // Calculate startDate and endDate
//   //   DateTime now = DateTime.now();
//   //   DateTime oneMonthAgo = now.subtract(Duration(days: 30)); // 30 days ago
//   //   String startDateFormatted = DateFormat('yyyy-MM-dd').format(now);
//   //   String endDateFormatted = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
//   //   print("Test");
//   //   print("startDateFormatted " + startDateFormatted.toString() + "endDateFormatted " + endDateFormatted);
//   //
//   //   fetchBidHistory(userId!, startDateFormatted, endDateFormatted);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: Text('Bid History'),
//         ),
//         body: bidHistory == null
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Column(
//                 children: [
//                   Consumer<AppProvider>(builder: (context, provider, child) {
//                     return Container(
//                       height: 250.sp,
//                       width: double.infinity,
//                       margin: EdgeInsets.all(20.sp),
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade100,
//                         borderRadius: BorderRadius.circular(10.sp),
//                       ),
//                       padding: EdgeInsets.all(20.sp),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "From Date: ",
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => _selectStartDate(context),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10.sp),
//                               ),
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.calendar_today),
//                                     onPressed: () => _selectStartDate(context),
//                                   ),
//                                   Text(DateFormat('yyyy-MM-dd')
//                                       .format(selectedStartDate!)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "To Date: ",
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => _selectEndDate(context),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(10.sp),
//                               ),
//                               child: Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.calendar_today),
//                                     onPressed: () => _selectEndDate(context),
//                                   ),
//                                   Text(DateFormat('yyyy-MM-dd')
//                                       .format(selectedEndDate!)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 10.sp,
//                           ),
//                           GestureDetector(
//                               onTap: () {
//                                 fetchBidHistory(
//                                     uid: provider.user!.id,
//                                     startDateFormatted: DateFormat('yyyy-MM-dd')
//                                         .format(selectedStartDate!),
//                                     endDateFormatted: DateFormat('yyyy-MM-dd')
//                                         .format(selectedEndDate!));
//                               },
//                               child: Container(
//                                 height: 50.sp,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: Colors.black,
//                                   borderRadius: BorderRadius.circular(10.sp),
//                                 ),
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   "SEARCH",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ))
//                         ],
//                       ),
//                     );
//                   }),
//                   ListView.builder(
//                     itemCount: bidHistory.length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       final item = bidHistory[index];
//                       return Card(
//                         elevation: 3,
//                         margin:
//                             EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         child: ListTileTheme(
//                           dense: true,
//                           contentPadding: EdgeInsets.all(16),
//                           child: ListTile(
//                             title: Text(item.gameName.toString() +
//                                 " " +
//                                 item.betTime.toString()),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                     'Bet on: ${item.betOn}, Bet Number: ${item.betNumber}'),
//                                 // Text('Time: ${item.betTime ?? 'Not available'}'),
//                                 Text(
//                                     'Date: ${item.betDate ?? 'Not available'}'),
//                               ],
//                             ),
//                             trailing: Text('Amount: ${item.betAmount}'),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ));
//   }
// }

import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../Model/BidHistoryItem.dart';
import '../Provider/AppProvider.dart';
import 'package:intl/intl.dart';

class bidHistoryDrawer extends StatefulWidget {
  const bidHistoryDrawer({Key? key}) : super(key: key);

  @override
  State<bidHistoryDrawer> createState() => _bidHistoryDrawerState();
}

class _bidHistoryDrawerState extends State<bidHistoryDrawer> {
  late List<BidHistoryItem> bidHistory = [];
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Future<void> fetchBidHistory(
      {required String uid,
      required String startDateFormatted,
      required String endDateFormatted}) async {
    print("startDateFormatted " +
        startDateFormatted.toString() +
        "endDateFormatted " +
        endDateFormatted);

    final response = await http.post(
      Uri.parse("$baseUrl/bid_history.php"),
      body: {
        'uid': uid,
        'start_date': startDateFormatted,
        'end_date': endDateFormatted,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final gamelist = data['gamelist'];
      setState(() {
        bidHistory =
            List<BidHistoryItem>.from(gamelist.map((item) => BidHistoryItem(
                  id: item['id'],
                  gameName: item['game_name'],
                  gameCategory: item['game_category'],
                  bajiName: item['baji_name'],
                  betOn: item['bet_on'],
                  betNumber: item['bet_number'],
                  betAmount: item['bet_amount'],
                  betTime: item['bet_time'],
                  betDate: item['bet_date'],
                )));
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedStartDate != null) {
      setState(() {
        selectedStartDate = pickedStartDate;
      });

      String? userId =
          Provider.of<AppProvider>(context, listen: false).user?.id;
      String startDateFormatted =
          DateFormat('yyyy-MM-dd').format(pickedStartDate);
      String endDateFormatted =
          DateFormat('yyyy-MM-dd').format(selectedEndDate!);
      fetchBidHistory(
        uid: userId!,
        startDateFormatted: startDateFormatted,
        endDateFormatted: endDateFormatted,
      );
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate:
          selectedEndDate ?? DateTime.now().subtract(Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedEndDate != null) {
      setState(() {
        selectedEndDate = pickedEndDate;
      });

      String? userId =
          Provider.of<AppProvider>(context, listen: false).user?.id;
      String startDateFormatted =
          DateFormat('yyyy-MM-dd').format(selectedStartDate!);
      String endDateFormatted = DateFormat('yyyy-MM-dd').format(pickedEndDate);
      fetchBidHistory(
        uid: userId!,
        startDateFormatted: startDateFormatted,
        endDateFormatted: endDateFormatted,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    DateTime now = DateTime.now();
    DateTime oneMonthAgo = now.subtract(Duration(days: 30)); // 30 days ago
    String startDateFormatted = DateFormat('yyyy-MM-dd').format(oneMonthAgo);
    String endDateFormatted = DateFormat('yyyy-MM-dd').format(now);
    selectedStartDate = DateTime.parse(startDateFormatted);
    selectedEndDate = DateTime.parse(endDateFormatted);
    fetchBidHistory(
        uid: userId!,
        startDateFormatted: startDateFormatted,
        endDateFormatted: endDateFormatted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Bid History'),
      ),
      body: bidHistory.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Consumer<AppProvider>(builder: (context, provider, child) {
                  return Container(
                    height: 250.sp,
                    width: double.infinity,
                    margin: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      // color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10.sp),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF79D4DB), Color(0xFF7DDC81)],
                      ),
                    ),
                    padding: EdgeInsets.all(20.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From Date: ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectStartDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.calendar_month,),
                                  onPressed: () => _selectStartDate(context),
                                ),
                                Text(DateFormat('yyyy-MM-dd')
                                    .format(selectedStartDate!)),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          "To Date: ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectEndDate(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.calendar_month),
                                  onPressed: () => _selectEndDate(context),
                                ),
                                Text(DateFormat('yyyy-MM-dd')
                                    .format(selectedEndDate!)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            String startDateFormatted = DateFormat('yyyy-MM-dd')
                                .format(selectedStartDate!);
                            String endDateFormatted = DateFormat('yyyy-MM-dd')
                                .format(selectedEndDate!);
                            fetchBidHistory(
                                uid: provider.user!.id,
                                startDateFormatted: startDateFormatted,
                                endDateFormatted: endDateFormatted);
                          },
                          child: Container(
                            height: 50.sp,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "SEARCH",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
                Expanded(
                  child: ListView.builder(
                    itemCount: bidHistory.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = bidHistory[index];
                      return Container(
                        width: double.infinity,
                        height: 250.sp,
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF77C4D2)),
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month,
                                  color: Color(0xFF7DDC81),
                                ),
                                SizedBox(width: 10.sp,),
                                Text(item.betDate.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1.sp,
                              width: double.infinity,
                              color: Color(0xFF77C4D2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100.sp,
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Game Name",
                                        style: TextStyle(
                                          color: Color(0xFF7DDC81),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      Text(item.gameName.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100.sp,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text("Category",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF7DDC81),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      Text(item.gameCategory.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100.sp,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text("Baji Name",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF7DDC81),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      Text(item.bajiName.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            Container(
                              height: 1.sp,
                              width: double.infinity,
                              color: Color(0xFF77C4D2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 100.sp,
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("Bet On",
                                        style: TextStyle(
                                          color: Color(0xFF7DDC81),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      Text(item.betOn.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100.sp,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text("Bet Number",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF7DDC81),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      Text(item.betNumber.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100.sp,
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Text("Bet Amount",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF7DDC81),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.sp,
                                      ),
                                      Text(item.betAmount.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      );
                      // return Card(
                      //   elevation: 3,
                      //   margin:
                      //       EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //   child: ListTileTheme(
                      //     dense: true,
                      //     contentPadding: EdgeInsets.all(16),
                      //     child: ListTile(
                      //       title: Text(item.gameName.toString() +
                      //           " " +
                      //           item.betTime.toString()),
                      //       subtitle: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //               'Bet on: ${item.betOn}, Bet Number: ${item.betNumber}'),
                      //           Text(
                      //               'Date: ${item.betDate ?? 'Not available'}'),
                      //         ],
                      //       ),
                      //       trailing: Text('Amount: ${item.betAmount}'),
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
