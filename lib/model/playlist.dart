// To parse this JSON data, do
//
//     final playlistCurrentlyListening = playlistCurrentlyListeningFromJson(jsonString);

import 'dart:convert';

List<PlaylistCurrentlyListening> playlistCurrentlyListeningFromJson(
        String str) =>
    List<PlaylistCurrentlyListening>.from(
        json.decode(str).map((x) => PlaylistCurrentlyListening.fromJson(x)));

String playlistCurrentlyListeningToJson(
        List<PlaylistCurrentlyListening> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaylistCurrentlyListening {
  PlaylistCurrentlyListening({
    this.id,
    this.title,
    this.url,
    this.thumbnails,
    this.author,
    this.description,
  });

  String? id;
  String? title;
  String? url;
  String? thumbnails;
  String? author;
  String? description;

  factory PlaylistCurrentlyListening.fromJson(Map<String, dynamic> json) =>
      PlaylistCurrentlyListening(
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnails: json["thumbnails"],
        author: json["author"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "thumbnails": thumbnails,
        "author": author,
        "description": description,
      };
}
