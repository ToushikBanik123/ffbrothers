import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/Game.dart';
import '../utils/const.dart';

class GameResult {
  final String id;
  final String jodiDigit;
  final String singleDigit;
  final String registeredDate;

  GameResult({
    required this.id,
    required this.jodiDigit,
    required this.singleDigit,
    required this.registeredDate,
  });

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      id: json['id'],
      jodiDigit: json['jodi_digit'],
      singleDigit: json['single_digit'],
      registeredDate: json['registered_date'],
    );
  }
}

class GameResultList {
  final Map<String, List<GameResult>> gameResultList;

  GameResultList({
    required this.gameResultList,
  });

  // factory GameResultList.fromJson(Map<String, dynamic> json) {
  //   final Map<String, dynamic> gameResultListJson = json['game_result_list'];
  //   final Map<String, List<GameResult>> gameResultList = {};
  //
  //   gameResultListJson.forEach((date, resultsJson) {
  //     final List<GameResult> results = resultsJson
  //         .map((resultJson) => GameResult.fromJson(resultJson))
  //         .toList();
  //     gameResultList[date] = results;
  //   });
  //
  //   return GameResultList(gameResultList: gameResultList);
  // }
  factory GameResultList.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> gameResultListJson = json['game_result_list'];
    final Map<String, List<GameResult>> gameResultList = {};

    gameResultListJson.forEach((date, resultsJson) {
      final List<GameResult> results = (resultsJson as List<dynamic>)
          .map((resultJson) => GameResult.fromJson(resultJson))
          .toList();
      gameResultList[date] = results;
    });

    return GameResultList(gameResultList: gameResultList);
  }
}

class GameResultPage extends StatefulWidget {
  final GameList;
  GameResultPage({required this.GameList, Key? key}) : super(key: key);

  @override
  State<GameResultPage> createState() => _GameResultPageState();
}

class _GameResultPageState extends State<GameResultPage> {
  late Future<GameResultList> gameResultList;

  @override
  void initState() {
    super.initState();
    gameResultList = fetchGameResults();
  }

  Future<GameResultList> fetchGameResults() async {
    final response =
        await http.post(Uri.parse('$baseUrl/game_result_list.php'), body: {
      'game_id': widget.GameList.id.toString(),
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return GameResultList.fromJson(json);
    } else {
      throw Exception('Failed to load game results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.GameList.gameName), //gameName
      ),
      body: FutureBuilder<GameResultList>(
        future: gameResultList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final gameResultList = snapshot.data!.gameResultList;

            return ListView.builder(
              itemCount: gameResultList.length,
              itemBuilder: (context, index) {
                final date = gameResultList.keys.toList()[index];
                final results = gameResultList[date];

                return Container(
                  padding: EdgeInsets.all(15.sp),
                  child: Column(
                    children: [
                      Material(
                        elevation: 2.sp,
                        child: Container(
                          height: 130.sp,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(10.sp),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.GameList.gameName,
                                    style: TextStyle(
                                      color: Colors.purple,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.purple,
                                        size: 18.sp,
                                      ),
                                      SizedBox(
                                        width: 5.sp,
                                      ),
                                      Text(
                                        "$date",
                                        style: TextStyle(
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // SizedBox(height: 5.sp),
                              Container(
                                height: 1.sp,
                                width: double.infinity,
                                color: Colors.purple,
                              ),
                              SizedBox(height: 5.sp),
                              // ListView.builder(
                              //     shrinkWrap: true,
                              //     physics: NeverScrollableScrollPhysics(),
                              //     itemCount: results!.length,
                              //     itemBuilder: (context, index) {
                              //       final result = results[index];
                              //       return Column(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceAround,
                              //         children: [
                              //           Text("${result.jodiDigit}"),
                              //           Text("${result.singleDigit}"),
                              //         ],
                              //       );
                              //     })
                              Container(
                                height: 80.sp,
                                child: ListView.builder(
                                    itemCount: results!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context,index){
                                      final result = results[index];
                                      return Container(
                                        // height: 10,
                                        width: 45.sp,
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.purple,),
                                          borderRadius: BorderRadius.circular(16.sp),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(result.jodiDigit),
                                            Text(result.singleDigit),
                                          ],
                                        ),
                                      );

                                }),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
