import 'dart:convert';
import 'dart:io';
import 'package:clone_zingmp3/API/playlistapi.dart';
import 'package:clone_zingmp3/layout/chart_layout.dart';
import 'package:clone_zingmp3/layout/discover_layout.dart';
import 'package:clone_zingmp3/layout/individual_layout.dart';
import 'package:clone_zingmp3/layout/radio_layout.dart';
import 'package:clone_zingmp3/layout/tracking_layout.dart';
import 'package:clone_zingmp3/model/playlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;
import 'package:audioplayers/audioplayers.dart';
import 'package:async/async.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  AsyncMemoizer _memoizer = AsyncMemoizer();
  int _currentTabIndex = 1;
  List<PlaylistCurrentlyListening> _listDefaultMusic = [];
  PlayerState? playerState;

  final PlayListApi _listApi = PlayListApi();
  Future _loadPlayList() async {
    return _memoizer.runOnce(() {
      _listApi.getPlaylistFromLocal().then((value) {
        _listDefaultMusic = value;
      });
      return _listDefaultMusic;
    });
  }

  Future _playLocalFile(String path, PlayerState? state) async {
    final result = await audioCache.play(path);

    setState(() {
      playerState = PlayerState.PLAYING;

      print(playerState);
    });
  }

  Future _pauseMusic() async {
    int result = await audioPlayer.pause();
    setState(() => playerState = PlayerState.PAUSED);
    print(playerState);
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    if (Platform.isIOS) {
      audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }

    setState(() {
      audioPlayer = AudioPlayer();
      audioCache = AudioCache(fixedPlayer: audioPlayer);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    // Các layout trong tương ứng với các item bottombar
    final _kTabScreens = <Widget>[
      const IndividualLayout(),
      const DiscoverLayout(),
      const ChartLayout(),
      const RadioLayout(),
      const TrackingLayout()
    ];

    //  Các item có trong BottomNavigationbar
    final _kBottomNaviGationBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.ac_unit,
        ),
        title: Text(
          'Cá nhân',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.ac_unit,
        ),
        title: Text(
          'Khám phá',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.ac_unit,
        ),
        title: Text(
          '#Zingchart',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.ac_unit,
        ),
        title: Text(
          'Radio',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.ac_unit,
        ),
        title: Text(
          'Theo dỏi',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    ];

    //  Widget build bottombar
    final Widget _bottomNavBar = Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 0.5, color: Colors.grey))),
        child: BottomNavigationBar(
          items: _kBottomNaviGationBarItems,
          backgroundColor: colors.AppColors.searchBackground,
          currentIndex: _currentTabIndex,
          elevation: 1,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: colors.AppColors.appColor,
          unselectedItemColor: colors.AppColors.appUnSelectColor,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Phần Body Tabbar
          Expanded(
            child: _kTabScreens[_currentTabIndex],
          ),

          // Phần hiển thị nhạc đang nghe
          FutureBuilder(
            future: _loadPlayList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  height: 58,
                  color: colors.AppColors.searchBackground,
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        color: colors.AppColors.appColor,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                              child: Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: colors.AppColors.appColor,
                                borderRadius: BorderRadius.circular(45)),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                "assets/images/thumbnails/" +
                                    _listDefaultMusic[1].thumbnails.toString(),
                              ),
                            ),
                          )),
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(_listDefaultMusic[1]
                                          .title
                                          .toString()),
                                      Text(_listDefaultMusic[1]
                                          .author
                                          .toString())
                                    ],
                                  ))),
                          const Icon(Icons.favorite_border),
                          IconButton(
                            icon: Icon(playerState == PlayerState.PLAYING
                                ? Icons.pause
                                : Icons.play_arrow),
                            onPressed: () {
                              playerState == PlayerState.PLAYING
                                  ? _pauseMusic()
                                  : _playLocalFile(
                                      "music/" +
                                          _listDefaultMusic[1].url.toString(),
                                      playerState);
                            },
                          ),
                          const Icon(
                            Icons.skip_next_rounded,
                            size: 26,
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      )
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 58,
                  color: colors.AppColors.searchBackground,
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        color: colors.AppColors.appColor,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                              child: Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: colors.AppColors.appColor,
                                borderRadius: BorderRadius.circular(45)),
                            child: const CircularProgressIndicator.adaptive(),
                          )),
                          Expanded(
                              child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text("Loading..."),
                                      Text("Loading..."),
                                    ],
                                  ))),
                          const Icon(Icons.favorite_border),
                          IconButton(
                            icon: Icon(playerState == PlayerState.PLAYING
                                ? Icons.pause
                                : Icons.play_arrow),
                            onPressed: () {},
                          ),
                          const Icon(
                            Icons.skip_next_rounded,
                            size: 26,
                          ),
                          const SizedBox(
                            width: 5,
                          )
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),

      // Phần bottomNavigationBar
      bottomNavigationBar: _bottomNavBar,
    );
  }
}
