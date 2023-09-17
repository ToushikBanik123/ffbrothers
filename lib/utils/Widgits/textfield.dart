import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50.h, // Add ".h" for height scaling
    margin:  EdgeInsets.fromLTRB(0, 10.h, 0, 20.h), // Add ".h" for height scaling
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90.r)), // Add ".r" for radius scaling
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16.sp), // Add ".sp" for font size scaling
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r))), // Add ".r" for radius scaling
      ),
    ),
  );
}
