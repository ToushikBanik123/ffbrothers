
// class GameList {
//   final String id;
//   final String gameName;
//   final String category;
//
//   GameList({
//     required this.id,
//     required this.gameName,
//     required this.category,
//   });
// }

class GameList {
  final String? id;
  final String? gameName;
  final String? category;

  GameList({this.id, this.gameName, this.category});

  factory GameList.fromJson(Map<String, dynamic> json) {
    return GameList(
      id: json['id'] as String?,
      gameName: json['game_name'] as String?,
      category: json['category'] as String?,
    );
  }
}
