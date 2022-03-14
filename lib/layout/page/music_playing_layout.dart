import 'package:clone_zingmp3/layout/page/loanding_page.dart';
import 'package:clone_zingmp3/layout/widget/indicato_widget.dart';
import 'package:clone_zingmp3/model/playlist.dart';
import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;
import 'dart:math' as math;

class MusicPlayingLayout extends StatefulWidget {
  AudioPlayer audioPlayer;
  AudioCache audioCache;
  PlayerState? playerState;
  int indexMusic;
  List<PlaylistCurrentlyListening> listDefaultMusic;
  MusicPlayingLayout(
      {Key? key,
      required this.audioCache,
      required this.audioPlayer,
      required this.indexMusic,
      required this.listDefaultMusic,
      required this.playerState})
      : super(key: key);

  @override
  _MusicPlayingLayoutState createState() => _MusicPlayingLayoutState();
}

class _MusicPlayingLayoutState extends State<MusicPlayingLayout>
    with TickerProviderStateMixin {
  int pageChanged = 0;
  int _indexMusic = 0;
  bool isPlaying = true;
  bool _isDisposed = false;
  Duration totalDuratio = const Duration();
  Duration position = const Duration();
  List<PlaylistCurrentlyListening>? _listDefaultMusic;
  late final AnimationController _animationController;

  Future _playLocalFile(String path) async {
    String url = "music/" + path;
    widget.audioPlayer.stop();
    _animationController.repeat();
    await widget.audioCache.play(url);
    setState(() {
      widget.playerState = PlayerState.PLAYING;
    });
  }

// Hàm dừng nhạc
  Future _pauseMusic() async {
    await widget.audioPlayer.pause();
    _animationController.stop();
    setState(() {
      widget.playerState = PlayerState.PAUSED;
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat().orCancel;

    _listDefaultMusic = widget.listDefaultMusic;
    _indexMusic = widget.indexMusic;

    // if (_isDisposed == true) {
    // widget.audioPlayer.onDurationChanged.listen((updateTotaDuration) {
    //   setState(() {
    //     totalDuratio = updateTotaDuration;
    //   });
    // });
    // widget.audioPlayer.onAudioPositionChanged.listen((updatePosition) {
    //   setState(() {
    //     position = updatePosition;
    //   });
    // });
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();

    widget.audioPlayer.dispose();
    widget.audioCache.clearAll();
  }

  @override
  Widget build(BuildContext context) {
    double meriQueriWidth = MediaQuery.of(context).size.width;
    double meriQueriHeight = MediaQuery.of(context).size.height;

    final List<Widget> _musicPlayingScreen = [
      Container(
        height: meriQueriHeight - 200,
        color: Colors.red[100],
        child: const Center(
          child: LoadingPage(),
        ),
      ),
      SizedBox(
        height: meriQueriHeight - 280,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                height: 320,
                width: 320,
                decoration: BoxDecoration(
                    color: Colors.red[300],
                    image: DecorationImage(
                        image: AssetImage("assets/images/thumbnails/" +
                            _listDefaultMusic![_indexMusic]
                                .thumbnails
                                .toString()),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(320)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 44,
              child: Center(
                child: Text("Lời nhạc"),
              ),
            )
          ],
        ),
      ),
      Container(
        height: meriQueriHeight - 200,
        color: Colors.blue[100],
        child: const Center(
          child: LoadingPage(),
        ),
      )
    ];

    return Scaffold(
      body: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1,
          maxChildSize: 1,
          minChildSize: 0.2,
          builder: (context, controller) {
            return Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(10),
              color: Colors.grey[300],
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  height: meriQueriHeight + 100,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 55,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => setState(() {
                                      // _animationController.stop();
                                      Navigator.pop(context);
                                    }),
                                icon:
                                    const Icon(Icons.arrow_back_ios_outlined)),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [Text("data"), Text("data")],
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.queue_music)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_vert_rounded))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                              3,
                              (index) => Indicato(
                                    isActive:
                                        pageChanged == index ? true : false,
                                  ))
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ExpandablePageView(
                        onPageChanged: (valueIndex) {
                          setState(() {
                            pageChanged = valueIndex;
                          });
                        },
                        children: _musicPlayingScreen,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          SizedBox(
                            height: 18,
                            child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                Container(
                                  height: 4,
                                  color: Colors.white,
                                ),
                                Container(
                                  height: 18,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: colors.AppColors.appColor,
                                  ),
                                  child: Center(
                                      child: Text(
                                          _printDuration(position) +
                                              "/" +
                                              _printDuration(totalDuratio),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white))),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            verticalDirection: VerticalDirection.up,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.autorenew_outlined,
                                    size: 30,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    if (_indexMusic > 0) {
                                      setState(() {
                                        --_indexMusic;
                                        _playLocalFile(
                                            _listDefaultMusic![_indexMusic]
                                                .url
                                                .toString());
                                      });
                                    } else {
                                      setState(() {
                                        _indexMusic =
                                            _listDefaultMusic!.length - 1;
                                        _playLocalFile(
                                            _listDefaultMusic![_indexMusic]
                                                .url
                                                .toString());
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.skip_previous_rounded,
                                    size: 35,
                                  )),
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    widget.playerState == PlayerState.PAUSED
                                        ? _playLocalFile(
                                            _listDefaultMusic![_indexMusic]
                                                .url
                                                .toString())
                                        : _pauseMusic();
                                  },
                                  icon: Icon(
                                    widget.playerState == PlayerState.PAUSED
                                        ? Icons.play_circle_outline_outlined
                                        : Icons.pause_circle_outlined,
                                    size: 55,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    if (_indexMusic <
                                        _listDefaultMusic!.length - 1) {
                                      setState(() {
                                        _indexMusic++;
                                        _playLocalFile(
                                            _listDefaultMusic![_indexMusic]
                                                .url
                                                .toString());
                                      });
                                    } else {
                                      setState(() {
                                        _indexMusic = 0;
                                        _playLocalFile(
                                            _listDefaultMusic![_indexMusic]
                                                .url
                                                .toString());
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.skip_next_rounded,
                                    size: 35,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.autorenew_outlined,
                                    size: 30,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite_outline)),
                              Expanded(child: Container()),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    const Text(
                                      "DANH SÁCH PHÁT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            Icons.queue_music_rounded))
                                  ],
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(
                              width: meriQueriWidth,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              child: const Text("Bình luận"),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
