import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String policyText = "Loading...";

  Future<void> fetchPolicy() async {
    final response = await http.get(Uri.parse("$baseUrl/privacy_policy.php"));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final policyData = jsonData['policy'][0]['policy'];
      setState(() {
        policyText = policyData;
      });
    } else {
      setState(() {
        policyText = "Error fetching policy.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Text(policyText),
        ),
      ),
    );
  }
}

