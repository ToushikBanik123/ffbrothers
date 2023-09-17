import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}