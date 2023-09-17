// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
//
// class Game {
//   final String id; // Change int to String
//   final String gameName;
//   final String day;
//   final String openTime;
//   final String closeTime;
//
//   Game({
//     required this.id,
//     required this.gameName,
//     required this.day,
//     required this.openTime,
//     required this.closeTime,
//   });
//
//   factory Game.fromJson(Map<String, dynamic> json) {
//     return Game(
//       id: json['id'],
//       gameName: json['game_name'],
//       day: json['day'],
//       openTime: json['open_time'],
//       closeTime: json['close_time'],
//     );
//   }
// }
//
//
// class GameBajiListScreen extends StatefulWidget {
//   final String gameId;
//
//   GameBajiListScreen({required this.gameId});
//
//   @override
//   _GameBajiListScreenState createState() => _GameBajiListScreenState();
// }
//
// class _GameBajiListScreenState extends State<GameBajiListScreen> {
//   late Future<List<Game>> _gameList;
//
//   @override
//   void initState() {
//     super.initState();
//     _gameList = fetchGameList(widget.gameId);
//   }
//
//
//   Future<List<Game>> fetchGameList(String gameId) async {
//     print(gameId.toString());
//     final response = await http.post(
//       Uri.parse("https://bvaedu.com/matkaking/API/game_baji_list.php"),
//       body: {'id': gameId},
//     );
//     if (response.statusCode == 200) {
//       final jsonList = json.decode(response.body)['game_baji_list'];
//       print(jsonList.toString());
//       return jsonList.map<Game>((json) => Game.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load game list');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Game Baji List'),
//       ),
//       body: FutureBuilder<List<Game>>(
//         future: _gameList,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           } else {
//             final games = snapshot.data ?? [];
//             return ListView.builder(
//               itemCount: games.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(games[index].gameName),
//                   subtitle: Text('Day: ${games[index].day}'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
//
//

import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

import 'gamedetails.dart';

class Game {
  final String id;
  final String gameName;
  final String day;
  final String openTime;
  final String closeTime;

  Game({
    required this.id,
    required this.gameName,
    required this.day,
    required this.openTime,
    required this.closeTime,
  });
}

class GameBajiListScreen extends StatefulWidget {
  final String gameId;
  GameBajiListScreen({
    required this.gameId,
  });
  @override
  _GameBajiListScreenState createState() => _GameBajiListScreenState();
}

class _GameBajiListScreenState extends State<GameBajiListScreen> {
  final String apiUrl = "$baseUrl/game_baji_list.php";
  late String today;
  // final String gameId = "5"; // Replace with your user ID
  List<Game> games = [];// Add this line to declare the games list

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    today = DateFormat('EEEE').format(now); // Get the full day name
    fetchGameData();
  }

  Future<void> fetchGameData() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'id': widget.gameId},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Game> gameList = [];

        for (var item in data['game_baji_list']) {
          if (item['day'] == today) {
            gameList.add(Game(
              id: item['id'],
              gameName: item['game_name'],
              day: item['day'],
              openTime: item['open_time'],
              closeTime: item['close_time'],
            ));
          }
        }
        setState(() {
          games = gameList;
        });
      }
    } catch (error) {
      print("Error fetching game data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Baji List'),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          Game game = games[index];
          bool isOpen = isGameOpen(game.openTime, game.closeTime);
          // return ListTile(
          //   title: Text(game.gameName),
          //   subtitle: Text('Open: ${game.openTime} - ${game.closeTime}'),
          //   trailing: CircleAvatar(
          //     backgroundColor: isOpen ? Colors.green : Colors.red,
          //     child: Text(isOpen ? 'Open' : 'Closed'),
          //   ),
          // );
          return GameBajiTile(game: game,isOpen: isOpen,gameId: widget.gameId,);
        },
      ),
    );
  }

  bool isGameOpen(String openTime, String closeTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime open = DateTime.parse('${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} $openTime:00');
    DateTime close = DateTime.parse('${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} $closeTime:00');
    return now.isAfter(open) && now.isBefore(close);
  }

}



class GameBajiTile extends StatefulWidget {
  Game game;
  bool isOpen;
  final String gameId;
  GameBajiTile({
    required this.game,
    required this.isOpen,
    required this.gameId,
    Key? key}) : super(key: key);

  @override
  State<GameBajiTile> createState() => _GameBajiTileState();
}

class _GameBajiTileState extends State<GameBajiTile> {
  String _result = '';

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Market Closed"),
          content: Text("Can't bet when the market is closed"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchGameResults() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/game_baji_result.php"),
        body: {
          'game_id': widget.gameId,
          'game_baji_id': widget.game.id,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData.containsKey('game_baji_result_list')) {
          // Handle the game results here
          final gameResults = jsonData['game_baji_result_list'];
          print("Game Results:");
          for (var result in gameResults) {
            print("ID: ${result['id']}");
            print("Result: ${result['result']}");
            setState(() {
              _result = result['result'];
            });

          }
        } else if (jsonData.containsKey('message')) {
          // Handle the message here
          print("Message: ${jsonData['message']}");
          setState(() {
            _result = jsonData['message'];
          });

        }
      } else {
        // Handle error: Unable to fetch data
        print("Error: Unable to fetch data");
      }
    } catch (error) {
      // Handle error: $error
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchGameResults();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: GestureDetector(
        onTap: (){
          widget.isOpen ? Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GameDetails(game: widget.game,mainGameId: widget.gameId,)),
          ) : _showAlertDialog(context);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60.sp,
                      width: 60.sp,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isOpen ? Colors.green : Colors.red,
                      ),
                      child: Text(
                        widget.isOpen ? 'Market Open' : 'Market Closed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.game.gameName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1282),
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          'Open: ${widget.game.openTime} - ${widget.game.closeTime}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(_result.toString(),
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
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
                      radius: 27.r,
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 10.h,
                color: Colors.yellow.shade700,
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Icon(Icons.analytics_outlined, color: Colors.white),
                //     SizedBox(width: 15.w),
                //     Text(
                //       'click here to open chart',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
