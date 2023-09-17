import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../Provider/AppProvider.dart';
import 'home.dart';

class AddPoint extends StatefulWidget {
  const AddPoint({Key? key}) : super(key: key);

  @override
  State<AddPoint> createState() => _AddPointState();
}

class _AddPointState extends State<AddPoint> {
  List<Map<String, dynamic>> upiIds = [];
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  bool _isValidAmount = false;
  int _selectedUpiIndex = -1; // Initialize with -1 to indicate no selection
  String? paymentGateway;
  // String? userId; // Initialize userId from the provider

  Future<void> fetchUpiIds() async {
    final response = await http.get(Uri.parse("$baseUrl/upi_id.php"));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("upiid")) {
        setState(() {
          upiIds = List<Map<String, dynamic>>.from(jsonResponse["upiid"]);
        });
      } else {
        // Handle the case when "upiid" key is not present in the response
        print("No UPI IDs found.");
      }
    } else {
      // Handle the case when the API call fails
      print("Failed to fetch UPI IDs.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUpiIds();
  }

  void _validateAmount(String value) {
    final amount = int.tryParse(value);
    setState(() {
      _isValidAmount = amount != null && amount >= 500;
    });
  }

  Future<void> _submitFundRequest() async {
    final amount = _amountController.text;
    final transactionId = _transactionIdController.text;
    String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;

    if (amount.isEmpty || transactionId.isEmpty || int.tryParse(amount) == null || int.parse(amount) < 500) {
      // Check if amount and transactionId are not empty, and amount is greater than or equal to 100
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid amount or transaction ID")),
      );
      return;
    }

    final url = Uri.parse("$baseUrl/fund_add_request.php");
    final response = await http.post(
      url,
      body: {
        "uid": userId!,
        "amount": amount,
        "payment_gateway": paymentGateway!,
        "transaction_id": transactionId,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey("message")) {
        final message = jsonResponse["message"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown response from server")),
        );
      }
    } else {
      // Handle the case when the API call fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit fund request.")),
      );
    }
    Navigator.pop(context);
  }


  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Add Points'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Minimum Deposit Amount \₹ 500',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add Money : 9330441646',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: upiIds.length,
                  itemBuilder: (context, index) {
                    final upiId = upiIds[index]['upi_id'];
                    return ListTile(
                      title: Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: _selectedUpiIndex,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedUpiIndex = value!;
                                paymentGateway = upiId;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedUpiIndex = index;
                                paymentGateway = upiId;
                              });
                            },
                            child: Text(upiId),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: upiId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('UPI ID copied to clipboard: $upiId')),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Text(
                  'Now you can add points to your wallet',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30.h),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onChanged: _validateAmount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  hintText: 'Enter Amount',
                  errorText: !_isValidAmount ? 'Amount must be at least ₹ 500' : null,
                ),
              ),
              SizedBox(height: 30.h),
              TextFormField(
                controller: _transactionIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  hintText: 'Payment Number',
                ),
              ),
              SizedBox(height: 70.h),
              GestureDetector(
                onTap: _isValidAmount && paymentGateway != null
                    ? () async {
                  await _submitFundRequest();
                }
                    : null,
                child: Container(
                  width: double.infinity,
                  height: 47.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.cyan, Colors.blue],
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      'Proceed',
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
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
    );
  }
}
