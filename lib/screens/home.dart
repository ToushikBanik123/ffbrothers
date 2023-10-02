// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../Model/Game.dart';
// import '../Provider/AppProvider.dart';
// import 'addpoint.dart';
// import 'drawer.dart';
// import 'gameListUi.dart';
// import 'walletpage.dart';
// import 'withdrawl.dart';
// import 'package:url_launcher/url_launcher.dart';
//
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final PageController _controller = PageController(
//     initialPage: 0,
//     viewportFraction: 1.0, // Ensures each page occupies the full width
//   );
//   late Timer _timer;
//   int _currentPage = 0;
//   bool isLastPage = false;
//   String balance = '';
//   List<GameList> gameList = [];
//   List<GameList> highlightGameList = [];
//   List<dynamic> banners = [];
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
//       if (_currentPage < banners.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }
//       _controller.animateToPage(
//         _currentPage,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeIn,
//       );
//     });
//     fetchGameList();
//     highlight_game();
//     fetchBalance();
//     fetchBanners();
//   }
//
//   Future<void> fetchBalance() async {
//     final uri = Uri.parse('https://bvaedu.com/matkaking/API/wallet_balance.php');
//     String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
//     final response = await http.post(uri, body: {'uid': userId});
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['balance'] != null && data['balance'].isNotEmpty) {
//         setState(() {
//           balance = data['balance'][0]['balance'];
//         });
//       } else {
//         setState(() {
//           balance = 'No balance found';
//         });
//       }
//     } else {
//       throw Exception('Failed to load balance');
//     }
//   }
//
//   Future<List<GameList>> highlight_game() async {
//     final response = await http.get(Uri.parse('https://bvaedu.com/matkaking/API/highlight_game.php'));
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//
//       if (data.containsKey('gamelist')) {
//         List<GameList> gameList = (data['gamelist'] as List)
//             .map((gameJson) => GameList.fromJson(gameJson))
//             .toList();
//         highlightGameList = gameList;
//         return gameList;
//       }
//     }
//
//     throw Exception('Failed to load game list');
//   }
//
//
//
//   Future<void> fetchGameList() async {
//     final apiUrl = "https://bvaedu.com/matkaking/API/game_list.php";
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//
//         if (jsonData.containsKey("gamelist")) {
//           final gamelist = jsonData["gamelist"];
//           List<GameList> tempList = [];
//
//           for (var item in gamelist) {
//             tempList.add(GameList(
//               id: item["id"],
//               gameName: item["game_name"],
//               category: item["category"],
//             ));
//           }
//
//           setState(() {
//             gameList = tempList;
//           });
//         } else {
//           // Handle the case where "gamelist" key is not present in the response
//         }
//       } else {
//         // Handle HTTP error
//       }
//     } catch (e) {
//       // Handle network and JSON parsing errors
//       print(e);
//     }
//   }
//
//   Future<void> fetchBanners() async {
//     final response = await http.get(Uri.parse("https://bvaedu.com/matkaking/API/banner.php"));
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       setState(() {
//         banners = responseData['banner'];
//       });
//     } else {
//       throw Exception('Failed to load banners');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(color: Color(0xFF00ff01)),
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'FF King',
//               style: GoogleFonts.dancingScript(
//                 fontSize: 25.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             Consumer<AppProvider>(builder: (context, provider, child) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => WalletPage()),
//                   );
//                 },
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.wallet,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => WalletPage()),
//                         );
//                       },
//                     ),
//                     Text(
//                       balance,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//       drawer: NavDrawer(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 200, // Adjust the height as needed
//               child: PageView.builder(
//                 controller: _controller,
//                 itemCount: banners.length,
//                 itemBuilder: (context, index) {
//                   final banner = banners[index];
//                   final imageUrl =
//                       "https://bvaedu.com/matkaking/admin/banner_image/${banner['image']}";
//
//                   return Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover,
//                   );
//                 },
//                 onPageChanged: (int page) {
//                   setState(() {
//                     _currentPage = page;
//                     isLastPage = page == banners.length - 1;
//                   });
//                 },
//               ),
//             ),
//             Row(
//               children: [
//                 SizedBox(width: 5.w),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => AddPoint()),
//                       );
//                     },
//                     child: Container(
//                       height: 50.sp,
//                       margin: EdgeInsets.symmetric(vertical: 10.sp),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20.r),
//                         color: Colors.blue.shade300,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Add Money',
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(width: 5.w),
//                           CircleAvatar(
//                             child: Icon(
//                               Icons.add_circle_outline_outlined,
//                               color: Colors.blue.shade300,
//                             ),
//                             radius: 10.r,
//                             backgroundColor: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 5.w),
//                 // Expanded(
//                 //   child: Container(
//                 //     height: 50.sp,
//                 //     decoration: BoxDecoration(
//                 //       borderRadius: BorderRadius.circular(20.r),
//                 //       color: Colors.green.shade500,
//                 //     ),
//                 //     margin: EdgeInsets.symmetric(vertical: 10.sp),
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.center,
//                 //       children: [
//                 //         Text(
//                 //           'WhatsApp',
//                 //           overflow: TextOverflow.ellipsis,
//                 //           style: TextStyle(
//                 //             fontSize: 14.sp,
//                 //             color: Colors.white,
//                 //             fontWeight: FontWeight.bold,
//                 //           ),
//                 //         ),
//                 //         SizedBox(width: 5.w),
//                 //         CircleAvatar(
//                 //           backgroundImage: AssetImage('assets/images/wp.png'),
//                 //           radius: 15.r,
//                 //           backgroundColor: Colors.white,
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // ),
//                 GestureDetector(
//                   onTap: () async {
//                     final phoneNumber = '9330441646'; // Replace with the desired WhatsApp number
//                     final url = 'https://wa.me/$phoneNumber';
//                     if (await canLaunch(url)) {
//                       await launch(url);
//                     } else {
//                       throw 'Could not launch $url';
//                     }
//                   },
//                   child: Expanded(
//                     child: Container(
//                       height: 50.sp,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20.r),
//                         color: Colors.green.shade500,
//                       ),
//                       margin: EdgeInsets.symmetric(vertical: 10.sp),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'WhatsApp',
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(width: 5.w),
//                           CircleAvatar(
//                             backgroundImage: AssetImage('assets/images/wp.png'),
//                             radius: 15.r,
//                             backgroundColor: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 5.w),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Withdrawl()),
//                       );
//                     },
//                     child: Container(
//                       height: 50.sp,
//                       margin: EdgeInsets.symmetric(vertical: 10.sp),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20.r),
//                         color: Colors.blue,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Withdrawl',
//                             style: TextStyle(
//                               fontSize: 14.sp,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(width: 5.w),
//                           CircleAvatar(
//                             child: Icon(
//                               Icons.login,
//                               color: Colors.blue,
//                               size: 20.sp,
//                             ),
//                             radius: 13.r,
//                             backgroundColor: Colors.white,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 5.w),
//               ],
//             ),
//             SizedBox(height: 3.h),
//             Divider(
//               height: 2.0,
//               color: Colors.grey,
//             ),
//             SizedBox(height: 3.h),
//
//
//
//             // FutureBuilder<List<GameList>>(
//             //   future: highlight_game(),
//             //   builder: (context, snapshot) {
//             //     if (snapshot.connectionState == ConnectionState.waiting) {
//             //       return CircularProgressIndicator();
//             //     } else if (snapshot.hasError) {
//             //       return Text('Error: ${snapshot.error}');
//             //     } else if (snapshot.hasData) {
//             //       final games = snapshot.data!;
//             //       final itemCount = 4;
//             //       return ;
//             //     } else {
//             //       return Text('No data available.');
//             //     }
//             //   },
//             // )
//
//             GridView.builder(
//               shrinkWrap: true,
//               padding: EdgeInsets.all(10.sp),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // 2 items per row
//                   crossAxisSpacing: 10.0,
//                   mainAxisSpacing: 10.0,
//                   childAspectRatio: 3/1
//               ),
//               itemCount: 4,
//               itemBuilder: (context, index) {
//                 if (index < highlightGameList.length) {
//                   // Display available game
//                   return Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.sp),
//                       color: Colors.yellow.shade800,
//                     ),
//                     padding: EdgeInsets.all(10.sp),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(
//                           Icons.star,
//                           color: Colors.white,
//                         ),
//                         Text(
//                           highlightGameList[index].gameName ?? 'Coming Soon',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14.0,
//                           ),
//                         ),
//                         Icon(
//                           Icons.star,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   // Display "Coming Soon" for empty slots
//                   return Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.sp),
//                       color: Colors.yellow.shade800, // You can use any color you prefer
//                     ),
//                     padding: EdgeInsets.all(10.sp),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Icon(
//                           Icons.star,
//                           color: Colors.white,
//                         ),
//                         Text(
//                           'Coming Soon',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14.0,
//                           ),
//                         ),
//                         Icon(
//                           Icons.star,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             )
//
//
//
//             ,SizedBox(height: 3.h),
//             Divider(
//               height: 2.0,
//               color: Colors.grey,
//             ),
//             SizedBox(height: 3.h),
//             ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: gameList.length,
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 final game = gameList[index];
//                 return gameListUi(GameList: game);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//

import 'dart:async';
import 'dart:convert';
import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Model/Game.dart';
import '../Provider/AppProvider.dart';
import 'UPIAddMoney.dart';
import 'addpoint.dart';
import 'drawer.dart';
import 'gameBajiList.dart';
import 'gameListUi.dart';
import 'walletpage.dart';
import 'withdrawl.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController(
    initialPage: 0,
    viewportFraction: 1.0, // Ensures each page occupies the full width
  );
  late Timer _timer;
  int _currentPage = 0;
  bool isLastPage = false;
  String balance = '';
  List<GameList> gameList = [];
  List<GameList> highlightGameList = [];
  List<dynamic> banners = [];

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
  //     if (_currentPage < banners.length - 1) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }
  //     _controller.animateToPage(
  //       _currentPage,
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeIn,
  //     );
  //   });
  //   fetchGameList();
  //   highlight_game();
  //   fetchBalance();
  //   fetchBanners();
  // }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_currentPage < banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });

    // Schedule the fetchBalance function to be called every second
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      fetchBalance();
    });

    fetchGameList();
    highlight_game();
    fetchBalance(); // Call fetchBalance initially
    fetchBanners();
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

  Future<List<GameList>> highlight_game() async {
    final response = await http.get(Uri.parse('$baseUrl/highlight_game.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('gamelist')) {
        List<GameList> gameList = (data['gamelist'] as List)
            .map((gameJson) => GameList.fromJson(gameJson))
            .toList();
        highlightGameList = gameList;
        return gameList;
      }
    }

    throw Exception('Failed to load game list');
  }

  Future<void> fetchGameList() async {
    final apiUrl = "$baseUrl/game_list.php";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData.containsKey("gamelist")) {
          final gamelist = jsonData["gamelist"];
          List<GameList> tempList = [];

          for (var item in gamelist) {
            tempList.add(GameList(
              id: item["id"],
              gameName: item["game_name"],
              category: item["category"],
            ));
          }

          setState(() {
            gameList = tempList;
          });
        } else {
          // Handle the case where "gamelist" key is not present in the response
        }
      } else {
        // Handle HTTP error
      }
    } catch (e) {
      // Handle network and JSON parsing errors
      print(e);
    }
  }

  Future<void> fetchBanners() async {
    // final response = await http.get(Uri.parse("$baseUrl/banner.php"));
    final response = await http.get(Uri.parse("$baseUrl/banner.php"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        banners = responseData['banner'];
      });
    } else {
      throw Exception('Failed to load banners');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Color(0xFF00ff01)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FF Brothers',
              style: GoogleFonts.dancingScript(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Consumer<AppProvider>(builder: (context, provider, child) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WalletPage()),
                  );
                },
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.wallet,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WalletPage()),
                        );
                      },
                    ),
                    Text(
                      balance,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 20.sp,),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200, // Adjust the height as needed
              child: PageView.builder(
                controller: _controller,
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  final imageUrl =
                      "https://bvaedu.com/matkaking/admin/banner_image/${banner['image']}";

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                },
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                    isLastPage = page == banners.length - 1;
                  });
                },
              ),
            ),
            Row(
              children: [
                SizedBox(width: 5.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPoint()),
                        // MaterialPageRoute(builder: (context) => ChosePayment()),

                        // MaterialPageRoute(builder: (context) => AddPoint()),
                        // MaterialPageRoute(builder: (context) => UPIAddMoney(amount: 200,)),
                        // MaterialPageRoute(builder: (context) => UPIpage()),
                      );
                    },
                    child: Container(
                      height: 50.sp,
                      margin: EdgeInsets.symmetric(vertical: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.blue.shade300,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add Money',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          CircleAvatar(
                            child: Icon(
                              Icons.add_circle_outline_outlined,
                              color: Colors.blue.shade300,
                            ),
                            radius: 10.r,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: GestureDetector(
                    // onTap: () async {
                    //   // final phoneNumber = '9330441646'; // Replace with the desired WhatsApp number
                    //   final url = 'https://wa.me/9330441646';
                    //   if (await canLaunch(url)) {
                    //     await launch(url);
                    //   } else {
                    //     throw 'Could not launch $url';
                    //   }
                    // },
                    onTap: () async {
                      final phoneNumber = '9330441646';
                      final url = 'https://api.whatsapp.com/send?phone=${Uri.encodeFull(phoneNumber)}';

                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // Handle the case where WhatsApp could not be launched.
                        // You can display a message or perform some other action here.
                        print('Could not launch WhatsApp');
                      }
                    },

                    child: Container(
                      height: 50.sp,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.green.shade500,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'WhatsApp',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/wp.png'),
                            radius: 15.r,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Withdrawl()),
                      );
                    },
                    child: Container(
                      height: 50.sp,
                      margin: EdgeInsets.symmetric(vertical: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.blue,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Withdrawl',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          CircleAvatar(
                            child: Icon(
                              Icons.login,
                              color: Colors.blue,
                              size: 20.sp,
                            ),
                            radius: 13.r,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
              ],
            ),
            SizedBox(height: 3.h),
            Divider(
              height: 2.0,
              color: Colors.grey,
            ),
            SizedBox(height: 3.h),

            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(10.sp),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 3/1
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                if (index < highlightGameList.length) {
                  // Display available game
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameBajiListScreen(gameId: highlightGameList[index].id.toString(),
                        )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.sp),
                        // color: Colors.yellow.shade800,
                        color: Color(0xFFFF0000),
                      ),
                      padding: EdgeInsets.all(10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          Text(
                            highlightGameList[index].gameName ?? 'Coming Soon',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Display "Coming Soon" for empty slots
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.sp),
                      // color: Colors.yellow.shade800, // You can use any color you prefer
                      color: Color(0xFFFF0000), // You can use any color you prefer
                    ),
                    padding: EdgeInsets.all(10.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        Text(
                          'Coming Soon',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            SizedBox(height: 3.h),
            Divider(
              height: 2.0,
              color: Colors.grey,
            ),
            SizedBox(height: 3.h),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: gameList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final game = gameList[index];
                return gameListUi(GameList: game);
              },
            ),
          ],
        ),
      ),
    );
  }
}
