import 'package:ff/screens/gameBajiList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'GameResultPage.dart';


class gameListUi extends StatelessWidget {
  final GameList;
  gameListUi({required this.GameList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameBajiListScreen(gameId: GameList.id,
                  )),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 27.r,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.transparent,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              GameList.category,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // color: Color(0xFF0D1282),
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              GameList.gameName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.red),
                                Icon(Icons.star, color: Colors.red),
                                Icon(Icons.star, color: Colors.red),
                              ],
                            )
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.red.shade200,
                          radius: 20.r,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameResultPage(GameList: GameList,)),
                );
              },
              child: Container(
                height: 40.h,
                // color: Colors.yellow.shade700,
                color: Color(0xFFFFFF3B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.analytics_outlined, color: Colors.red),
                    SizedBox(width: 15.w),
                    Text(
                      'click here to open chart',
                      style: TextStyle(
                        color: Color(0xFF0000FA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
