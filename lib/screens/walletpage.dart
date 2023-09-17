import 'dart:convert';
import 'package:ff/screens/withdrawl.dart';
import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Model/FundRequest.dart';
import '../Provider/AppProvider.dart';
import 'UPIAddMoney.dart';
import 'addpoint.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}


class _WalletPageState extends State<WalletPage> {
  int selectedImageIndex = 0;
  String balance = '';
  bool _toggleValue = false;
  List<dynamic> _addFundList = [];
  List<dynamic> _withdrawFundList = [];

  @override
  void initState() {
    super.initState();
    fetchBalance();
    _fetchData();
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

  // Future<void> _fetchData() async {
  //   // Fetch data from API 1
  //   String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
  //   final addFundUri = Uri.parse('https://bvaedu.com/matkaking/API/fund_add_request_list.php');
  //   final addFundResponse = await http.post(
  //     addFundUri,
  //     body: {'uid': userId},
  //   );
  //
  //   if (addFundResponse.statusCode == 200) {
  //     final addFundData = json.decode(addFundResponse.body);
  //     setState(() {
  //       _addFundList = addFundData['addfundlist'];
  //     });
  //   }
  //
  //   // Fetch data from API 2
  //   final withdrawFundUri = Uri.parse('https://bvaedu.com/matkaking/API/fund_withdraw_request_list.php');
  //   final withdrawFundResponse = await http.post(
  //     withdrawFundUri,
  //     body: {'uid': userId},
  //   );
  //
  //   if (withdrawFundResponse.statusCode == 200) {
  //     final withdrawFundData = json.decode(withdrawFundResponse.body);
  //     setState(() {
  //       _withdrawFundList = withdrawFundData['withdrawfundlist'];
  //     });
  //   }
  // }
  Future<void> _fetchData() async {
    String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    final addFundUri = Uri.parse('$baseUrl/fund_add_request_list.php');
    final addFundResponse = await http.post(
      addFundUri,
      body: {'uid': userId},
    );

    if (addFundResponse.statusCode == 200) {
      final addFundData = json.decode(addFundResponse.body);
      List<FundRequest> addFundList = [];
      for (var item in addFundData['addfundlist']) {
        addFundList.add(FundRequest.fromJson(item));
      }
      setState(() {
        _addFundList = addFundList;
      });
    }

    // Fetch data from API 2
    final withdrawFundUri = Uri.parse('$baseUrl/fund_withdraw_request_list.php');
    final withdrawFundResponse = await http.post(
      withdrawFundUri,
      body: {'uid': userId},
    );

    if (withdrawFundResponse.statusCode == 200) {
      final withdrawFundData = json.decode(withdrawFundResponse.body);
      List<FundRequest> withdrawFundList = [];
      for (var item in withdrawFundData['withdrawfundlist']) {
        withdrawFundList.add(FundRequest.fromJson(item));
      }
      setState(() {
        _withdrawFundList = withdrawFundList;
      });
    }
  }



  List<dynamic> getDisplayedFundList() {
    return _toggleValue ? _withdrawFundList : _addFundList;
  }

  Widget _buildPiledToggle(String label, bool value, Function(bool) onChanged) {
    return InkWell(
      onTap: () {
        setState(() {
          _toggleValue = !_toggleValue;
        });
        if (onChanged != null) {
          onChanged(_toggleValue);
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: value ? Colors.white : Colors.black,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: value ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('My Wallet'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w), // Add ".w" for width scaling
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10.h), // Add ".h" for height scaling
            Center(
              child: Text(
                'Current Points : $balance',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), // Add ".sp" for font size scaling
              ),
            ),
            SizedBox(height: 10.h), // Add ".h" for height scaling
            const Divider(
              height: 2.0,
              color: Colors.black,
            ),
            SizedBox(height: 20.h), // Add ".h" for height scaling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => TransferMoney()),
                    // );
                    Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => AddPoint()),s
                      MaterialPageRoute(builder: (context) => UPIpage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h), // Add ".w" and ".h" for width and height scaling
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Add Fund',
                    style: TextStyle(fontSize: 16.sp), // Add ".sp" for font size scaling
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    //Withdrawl
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Withdrawl()),
                      );

                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h), // Add ".w" and ".h" for width and height scaling
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Withdraw',
                    style: TextStyle(fontSize: 16.sp), // Add ".sp" for font size scaling
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h), // Add ".h" for height scaling
            const Divider(
              height: 2.0,
              color: Colors.black,
            ),
            SizedBox(height: 20.h),

            Text(
              'My Transactions :-',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), // Add ".sp" for font size scaling
            ),
            SizedBox(height: 20.0),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPiledToggle('Show Add Funds', _toggleValue, (value) {
                  // Handle the toggle value change
                }),
                SizedBox(width: 10),
                _buildPiledToggle('Show Withdraw Funds', !_toggleValue, (value) {
                  // Handle the toggle value change
                }),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: getDisplayedFundList().length,
              itemBuilder: (context, index) {
                final FundRequest fundRequest = getDisplayedFundList()[index];
                // Build UI elements using fundRequest data
                return _toggleValue ? Container(
                  margin: EdgeInsets.symmetric(vertical: 15.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r), // Add ".r" for radius scaling
                    gradient: LinearGradient(
                      colors: [Color(0xFFD09192), Color(0xFFC82471)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${fundRequest.transactionDate}',
                              style: TextStyle(
                                fontSize: 16.sp, // Add ".sp" for font size scaling
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h), // Add ".h" for height scaling
                            Text(
                              '${fundRequest.status}',
                              style: TextStyle(
                                fontSize: 13.sp, // Add ".sp" for font size scaling
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '₹ ${fundRequest.amount} ',
                              style: TextStyle(
                                fontSize: 16.sp, // Add ".sp" for font size scaling
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(height: 10.h), // Add ".h" for height scaling
                            // Text(
                            //   '${fundRequest.transactionId}',
                            //   style: TextStyle(
                            //     fontSize: 13.sp, // Add ".sp" for font size scaling
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ) : Container(
                  margin: EdgeInsets.symmetric(vertical: 15.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r), // Add ".r" for radius scaling
                    gradient: LinearGradient(
                      colors: [Colors.cyan, Colors.green],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${fundRequest.paymentMode}',
                              style: TextStyle(
                                fontSize: 16.sp, // Add ".sp" for font size scaling
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h), // Add ".h" for height scaling
                            Text(
                              '${fundRequest.transactionDate}  ${fundRequest.status}',
                              style: TextStyle(
                                fontSize: 13.sp, // Add ".sp" for font size scaling
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '₹ ${fundRequest.amount} ',
                              style: TextStyle(
                                fontSize: 16.sp, // Add ".sp" for font size scaling
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.h), // Add ".h" for height scaling
                            Text(
                              '${fundRequest.transactionId}',
                              style: TextStyle(
                                fontSize: 13.sp, // Add ".sp" for font size scaling
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


