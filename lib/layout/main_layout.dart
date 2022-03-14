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
import 'page/music_playing_layout.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> with TickerProviderStateMixin {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  AudioPlayer _audioPlayer = AudioPlayer();
  AudioCache _audioCache = AudioCache();
  late AnimationController transitionAnimationController;
  PlayerState? _playerState;
  int _currentTabIndex = 1;
  List<PlaylistCurrentlyListening> _listDefaultMusic = [];
  bool loadDone = false;
  int indexMusic = 0;

  final PlayListApi _listApi = PlayListApi();
  Future _loadPlayList() async {
    return _memoizer.runOnce(() {
      _listApi.getPlaylistFromLocal().then((value) {
        setState(() {
          _listDefaultMusic = value;
          loadDone = true;
        });
      });
      return _listDefaultMusic;
    });
  }

  Future _playLocalFile(String path, PlayerState? state) async {
    _audioPlayer.stop();
    String url = "music/" + path;
    await _audioCache.play(url);

    setState(() {
      _playerState = PlayerState.PLAYING;
    });
  }

// Hàm dừng nhạc
  Future _pauseMusic() async {
    _audioPlayer.stop();
    await _audioPlayer.pause();
    setState(() => _playerState = PlayerState.PAUSED);
  }

// Hàm hiện trang nghe nhạc
  Future _showSheetMusicPlayingLayout(AudioCache audioCache,
          AudioPlayer audioPlayer, PlayerState? playerState) =>
      showModalBottomSheet(
          transitionAnimationController: transitionAnimationController,
          isScrollControlled: true,
          // enableDrag: false, // thuột tính cho phép đóng sheet bằng cách kéo trược
          // isDismissible: false, // Thuột tính cho phép click ra ngoài sheet đê đóng
          context: context,
          builder: (context) => MusicPlayingLayout(
                listDefaultMusic: _listDefaultMusic,
                indexMusic: indexMusic,
                audioCache: audioCache,
                audioPlayer: audioPlayer,
                playerState: playerState,
              ));

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    if (Platform.isIOS) {
      _audioCache.fixedPlayer?.notificationService.startHeadlessService();
    }
    transitionAnimationController = BottomSheet.createAnimationController(this);
    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    transitionAnimationController.dispose();
    _audioPlayer.dispose();
    _audioCache.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueriHeight = MediaQuery.of(context).size.height;

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
          Icons.music_note,
        ),
        label: 'Cá nhân',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.radio_button_checked_outlined,
        ),
        label: 'Khám phá',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.stacked_line_chart_outlined),
        label: '#Zingchart',
      ),
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.radar_outlined,
        ),
        label: 'Radio',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.backup_table),
        label: 'Theo dỏi',
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

    _loadPlayList();
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
          Container(
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
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        _showSheetMusicPlayingLayout(
                            _audioCache, _audioPlayer, _playerState);
                      },
                      child: Container(
                        color: Colors.white.withOpacity(0),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: colors.AppColors.appColor,
                                  borderRadius: BorderRadius.circular(45)),
                              child: loadDone == true
                                  ? CircleAvatar(
                                      backgroundImage: AssetImage(
                                        "assets/images/thumbnails/" +
                                            _listDefaultMusic[indexMusic]
                                                .thumbnails
                                                .toString(),
                                      ),
                                    )
                                  : Container(),
                            ),
                            Row(
                              children: [
                                loadDone == true
                                    ? Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(_listDefaultMusic[indexMusic]
                                                .title
                                                .toString()),
                                            Text(_listDefaultMusic[indexMusic]
                                                .author
                                                .toString())
                                          ],
                                        ))
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    const Icon(Icons.favorite_border),
                    IconButton(
                      icon: Icon(
                        _playerState == PlayerState.PLAYING
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        _playerState == PlayerState.PLAYING
                            ? _pauseMusic()
                            : _playLocalFile(
                                _listDefaultMusic[indexMusic].url.toString(),
                                _playerState);
                      },
                    ),
                    const Icon(
                      Icons.skip_next_rounded,
                      size: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),

      // Phần bottomNavigationBar
      bottomNavigationBar: _bottomNavBar,
    );
  }
}

class SizeTransition1 extends PageRouteBuilder {
  final Widget page;
  SizeTransition1(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
                reverseCurve: Curves.fastOutSlowIn);
            return Align(
                alignment: Alignment.bottomCenter,
                child: SizeTransition(
                    sizeFactor: animation, child: page, axisAlignment: 0));
          },
        );
}
