import 'dart:convert';

import 'package:clone_zingmp3/model/playlist.dart';
import 'package:flutter/services.dart';

class PlayListApi {
  PlayListApi();

  Future<List<PlaylistCurrentlyListening>> getPlaylistFromLocal() async {
    final data = await rootBundle.loadString("json/list_default_music.json");

    try {
      List<PlaylistCurrentlyListening> list =
          playlistCurrentlyListeningFromJson(data);
      return list;
    } catch (e) {
      return <PlaylistCurrentlyListening>[];
    }
  }
}
