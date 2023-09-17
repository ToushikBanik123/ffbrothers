import 'package:ff/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

import '../Model/BidHistoryItem.dart';
import '../Provider/AppProvider.dart';

class bidHistoryDrawer extends StatefulWidget {
  const bidHistoryDrawer({Key? key}) : super(key: key);

  @override
  State<bidHistoryDrawer> createState() => _bidHistoryDrawerState();
}

class _bidHistoryDrawerState extends State<bidHistoryDrawer> {
  late List<BidHistoryItem> bidHistory = [];

  Future<void> fetchBidHistory(String uid) async {
    final response = await http.post(
      Uri.parse("$baseUrl/bid_history.php"),
      body: {'uid': uid},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final gamelist = data['gamelist'];
      bidHistory =
          List<BidHistoryItem>.from(gamelist.map((item) => BidHistoryItem(
                id: item['id'],
                gameName: item['game_name'],
                betOn: item['bet_on'],
                betNumber: item['bet_number'],
                betAmount: item['bet_amount'],
                betTime: item['bet_time'],
                betDate: item['bet_date'],
              )));
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    String? userId = Provider.of<AppProvider>(context, listen: false).user?.id;
    fetchBidHistory(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bid History'),
      ),
      body: bidHistory == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
        itemCount: bidHistory.length,
        itemBuilder: (context, index) {
          final item = bidHistory[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTileTheme(
              dense: true,
              contentPadding: EdgeInsets.all(16),
              child: ListTile(
                title: Text(item.gameName.toString() + " " + item.betTime.toString()),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bet on: ${item.betOn}, Bet Number: ${item.betNumber}'),
                    // Text('Time: ${item.betTime ?? 'Not available'}'),
                    Text('Date: ${item.betDate ?? 'Not available'}'),
                  ],
                ),
                trailing: Text('Amount: ${item.betAmount}'),
              ),
            ),
          );
        },
      )
    );
  }
}
