import 'package:ff/screens/SingleBetPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Model/Game.dart';
import 'PattiBetPage.dart';
import 'addbet.dart';
import 'gameBajiList.dart';

class GameDetails extends StatefulWidget {

  // GameDetails({Key? key}) : super(key: key);
  final Game game;
  final String mainGameId;

  GameDetails({required this.game, required this.mainGameId});

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> images = [
    'assets/images/jodiidigit.png',
    'assets/images/singledigit.png',
    'assets/images/gm.jpg',
    'assets/images/gm.jpg',
    'assets/images/gm.jpg',
    'assets/images/gm.jpg',
    'assets/images/gm.jpg',
    'assets/images/gm.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Game Topic',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    _buildContainer(
                      'Single',
                          () {
                        Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => AddBet(
                          //     game: widget.game,
                          //     mainGameId: widget.mainGameId,
                          //     tabIndex: 0,
                          // )),
                          MaterialPageRoute(builder: (context) => SingleBetPage(
                            game: widget.game,
                            mainGameId: widget.mainGameId,
                          )),
                        );
                      },
                    ),
                    _buildContainer(
                      'Patti',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PattiBetPage(
                            game: widget.game,
                            mainGameId: widget.mainGameId,
                          )),
                        );
                      },
                    ),
                  ],
                ),
                //TODO: Dont remove it maybe requared in future
                // Row(
                //   children: [
                //     _buildContainer(
                //       'CP Patti',
                //           () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => AddBet(
                //             game: widget.game,
                //             tabIndex: 2,
                //           )),
                //         );
                //       },
                //     ),
                //     _buildContainer(
                //       'Jori',
                //           () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => AddBet(
                //             game: widget.game,
                //             tabIndex: 3,
                //           )),
                //         );
                //       },
                //     ),
                //   ],
                // ),
                // Row(
                //   children: [
                //     _buildContainer(
                //       'Jor',
                //       () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => AddBet(
                //             game: widget.game,
                //             tabIndex: 4,
                //           )),
                //         );
                //       },
                //     ),
                //     _buildContainer(
                //       'Bijor',
                //       () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => AddBet(
                //             game: widget.game,
                //             tabIndex: 5,
                //           )),
                //         );
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildContainer(String text, VoidCallback onTap) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        margin: EdgeInsets.all(17.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.black],
          ),
          // border: Border.all(
          //   color: Colors.deepPurple.shade300,
          //   width: 2.0,
          // ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.dancingScript(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
