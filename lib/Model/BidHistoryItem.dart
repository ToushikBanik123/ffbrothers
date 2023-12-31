import 'package:flutter/material.dart';

class BidHistoryItem {
  final String? id;
  final String? gameName;
  final String? gameCategory;
  final String? bajiName;
  final String? betOn;
  final String? betNumber;
  final String? betAmount;
  final String? betTime;
  final String? betDate;

  BidHistoryItem({
    required this.id,
    required this.gameName,
    required this.gameCategory,
    required this.bajiName,
    required this.betOn,

    required this.betNumber,
    required this.betAmount,
    required this.betTime,
    required this.betDate,
  });
}