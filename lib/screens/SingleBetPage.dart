import 'dart:convert';

import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Model/Game.dart';
import '../Provider/AppProvider.dart';
import '../utils/Widgits/SeparateTabBar.dart';
import 'gameBajiList.dart';

class SingleBetPage extends StatefulWidget {
  final Game game;
  final String mainGameId;
  SingleBetPage({required this.game, required this.mainGameId, Key? key})
      : super(key: key);

  @override
  State<SingleBetPage> createState() => _SingleBetPageState();
}

class _SingleBetPageState extends State<SingleBetPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _betController = TextEditingController();
  TextEditingController _rsController = TextEditingController();
  String balance = 'Loading...';
  List<Map<String, dynamic>> betHistory = [];
  String? userId;

  // Variables to store the edited bet values
  String? editedBetNumber;
  String? editedBetAmount;
  int? editedBetIndex;
  double? totalBetAmount = 0.0;
  bool isLoading = false;

  Future<void> _fetchBalance() async {
    final uri =
        Uri.parse('$baseUrl/wallet_balance.php');
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
  bool isDuplicateBet(String betNumber) {
    return betHistory.any((bet) => bet['bet_number'] == betNumber);
  }

  @override
  void initState() {
    super.initState();

    userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    _fetchBalance();
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
              SizedBox(width: 30.sp,),
            ],
          ),
        ],
      ),
      body:   isLoading ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          Expanded(
            child: Container(
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
                          // child: TextFormField(
                          //   controller: _betController,
                          //   keyboardType: TextInputType.number,
                          //   maxLength: 3,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10.r),
                          //     ),
                          //     hintText: 'Enter Bet Number',
                          //   ),
                          // ),
                          child: TextFormField(
                            controller: _betController,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            onChanged: (Value) {
                              if (Value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              hintText: 'Enter Bet Number',
                              counterText:
                                  '', // This line hides the character count
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
                    // onTap: () {
                    //   double currentBalance = double.tryParse(balance) ?? 0.0;
                    //   double betAmount = double.tryParse(_rsController.text) ?? 0.0;
                    //
                    //   // Check if both fields are not empty
                    //   if (_rsController.text.isNotEmpty && _betController.text.isNotEmpty) {
                    //     // Check if the bet amount is greater than or equal to 10
                    //     if (betAmount >= 10) {
                    //       // Calculate the total bet amount by summing up existing bets
                    //       double totalBetAmount = betHistory
                    //           .map((bet) => double.tryParse(bet['bet_amount']) ?? 0.0)
                    //           .fold(0, (prev, current) => prev + current);
                    //
                    //       // Check if the total bet amount plus the new bet is within the balance
                    //       if (totalBetAmount + betAmount <= currentBalance) {
                    //         // Add the bet locally to the betHistory list
                    //         setState(() {
                    //           betHistory.add({
                    //             'bet_number': _betController.text,
                    //             'bet_amount': _rsController.text,
                    //             'isPlaced': false, // Initialize isPlaced
                    //           });
                    //         });
                    //         // Clear the input fields
                    //         _betController.clear();
                    //         _rsController.clear();
                    //       } else {
                    //         _showSnackBar('Total bet amount exceeds available balance.');
                    //       }
                    //     } else {
                    //       _showSnackBar('Minimum bet amount is 10.');
                    //     }
                    //   } else {
                    //     _showSnackBar('Please enter values for both fields.');
                    //   }
                    // },
                    onTap: () {
                      double currentBalance = double.tryParse(balance) ?? 0.0;
                      double betAmount = double.tryParse(_rsController.text) ?? 0.0;
                      String betNumber = _betController.text;

                      // Check if both fields are not empty
                      if (betNumber.isNotEmpty && _rsController.text.isNotEmpty) {
                        // Check if the bet amount is greater than or equal to 10
                        if (betAmount >= 10) {
                          // Check for duplicate bet number
                          if (isDuplicateBet(betNumber)) {
                            _showSnackBar('Duplicate bet number: $betNumber');
                          } else {
                            // Calculate the total bet amount by summing up existing bets
                            double totalBetAmount = betHistory
                                .map((bet) => double.tryParse(bet['bet_amount']) ?? 0.0)
                                .fold(0, (prev, current) => prev + current);

                            // Check if the total bet amount plus the new bet is within the balance
                            if (totalBetAmount + betAmount <= currentBalance) {
                              // Add the bet locally to the betHistory list
                              setState(() {
                                betHistory.add({
                                  'bet_number': betNumber,
                                  'bet_amount': _rsController.text,
                                  'isPlaced': false, // Initialize isPlaced
                                });
                              });
                              // Clear the input fields
                              _betController.clear();
                              _rsController.clear();
                            } else {
                              _showSnackBar('Total bet amount exceeds available balance.');
                            }
                          }
                        } else {
                          _showSnackBar('Minimum bet amount is 10.');
                        }
                      } else {
                        _showSnackBar('Please enter values for both fields.');
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 100.sp,
                                      alignment: Alignment.center,
                                      child: Text('Bet Number',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                  Container(
                                      width: 100.sp,
                                      alignment: Alignment.center,
                                      child: Text('Bet Amount',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                  Container(
                                      width: 100.sp,
                                      alignment: Alignment.center,
                                      child: Text('Action',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                          );
                        } else {
                          final item = betHistory[index - 1];
                          final bool isPlaced = item['isPlaced'] ?? false;
                          return Container(
                            decoration: BoxDecoration(
                              color: index % 2 == 0
                                  ? Colors.grey[200]
                                  : Colors.white,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 100.sp,
                                      alignment: Alignment.center,
                                      child: Text('${item['bet_number']}')),
                                  Container(
                                      width: 100.sp,
                                      alignment: Alignment.center,
                                      child: Text('${item['bet_amount']}')),
                                  Container(
                                    width: 100.sp,
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
                                      width: 50.sp,
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
          child: Text(
            "Submit",
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
    // setState(() {
    //   isLoading = true;
    // });
    for (var bet in betHistory) {
      double currentBalance = double.tryParse(balance) ?? 0.0;
      double betAmount = double.tryParse(bet['bet_amount']) ?? 0.0;
      if (betAmount <= currentBalance) {
        // Send each bet to the API one by one
        setState(() {
          isLoading = true;
        });
        await _sendBetRequest(
          uid: userId!,
          game_id: widget.mainGameId,
          game_baji_id: widget.game.id,
          bet_on: 'Single',
          bet_number: bet['bet_number'],
          bet_amount: bet['bet_amount'],
        );
        // Update the isPlaced field for the placed bet
        setState(() {
          bet['isPlaced'] = true;
          isLoading = false;
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
      Color alertColor = Colors.red;

      if (parsedResponse.containsKey('message')) {
        final message = parsedResponse['message'];
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(message)),
        // );
        if (message == "User Bet Successful") {
          _fetchBalance();
          alertColor = Colors.green;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alert"),
              content: Text(message),
              backgroundColor: alertColor, // Set the background color
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('API Response: Unknown');
      }
    } else {
      print('API Error: ${response.statusCode}');
    }
  }
}
