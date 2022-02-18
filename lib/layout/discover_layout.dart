import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;
import 'package:flutter/services.dart';

class DiscoverLayout extends StatefulWidget {
  const DiscoverLayout({Key? key}) : super(key: key);

  @override
  _DiscoverLayoutState createState() => _DiscoverLayoutState();
}

class _DiscoverLayoutState extends State<DiscoverLayout> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List _carousel = [];
  List _listTop100 = [];
  bool _loadingCaroulsel = true;
  bool _loadingList = true;

  _loadingJson() async {
    DefaultAssetBundle.of(context)
        .loadString("json/dc_caroulsel.json")
        .then((value) {
      setState(() {
        _carousel = json.decode(value);
        _carousel.isNotEmpty
            ? _loadingCaroulsel = false
            : _loadingCaroulsel = true;
      });
    });

    DefaultAssetBundle.of(context)
        .loadString("json/dc_listtop100.json")
        .then((value) {
      setState(() {
        _listTop100 = json.decode(value);
        _listTop100.isNotEmpty ? _loadingList = false : _loadingList = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _loadingJson();
    });

    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
        if (_pageController.hasClients) {
          _pageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 50), curve: Curves.easeIn);
        }
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Phần Search
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            elevation: 0,
            leadingWidth: 60,
            leading: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: colors.AppColors.appColor,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage("assets/images/avt.jpg"),
                          fit: BoxFit.cover)),
                )
              ],
            ),
            actions: [
              const SizedBox(
                width: 65,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: colors.AppColors.boxBackgroundColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(Icons.search,
                            color: colors.AppColors.appUnSelectColor),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Bài hát, playlist, nghệ sĩ...",
                          style: TextStyle(
                              fontSize: 16,
                              color: colors.AppColors.appUnSelectColor),
                        )),
                        Icon(Icons.mic_none,
                            color: colors.AppColors.appUnSelectColor),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Icon(Icons.settings, color: colors.AppColors.appUnSelectColor),
              const SizedBox(
                width: 10,
              ),
            ],
          ),

          // Phần card carousel (thẻ băng chuyền)  giới thiệu nhạc
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                height: 220,
                width: MediaQuery.of(context).size.width,
                child: Stack(children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Đến link nào đó
                        },
                        child: _loadingCaroulsel == false
                            ? Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/carousel/" +
                                                _carousel[index]["img"]),
                                        fit: BoxFit.cover),
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      );
                    },
                    itemCount: _carousel.length,
                  ),

                  // Dấu trấm trên thẻ băng chuyền
                  Positioned(
                    left: MediaQuery.of(context).size.width - 165.0,
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                        for (var i = 0; i < _carousel.length; i++)
                          if (_currentPage == i)
                            Container(
                              margin: const EdgeInsets.all(3),
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                            )
                          else
                            Container(
                              margin: const EdgeInsets.all(3),
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8)),
                            )
                      ],
                    ),
                  )
                ])),
          )),

          // ## // Phần body
          // List
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              height: 65,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    height: 75,
                    width: 75,
                    child: Column(
                      children: [
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.only(bottom: 5),
                            child: Icon(Icons.music_note_outlined)),
                        Text("data")
                      ],
                    ),
                  );
                },
                itemCount: 7,
              ),
            ),
          ),

          // Phần "Gần Đây"
          SliverToBoxAdapter(
            child: Container(
                height: 180,
                child: Column(
                  children: [
                    Row(children: const [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Gần Đây",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              if (index % 2 != 0 && index < 6)
                                GestureDetector(
                                  onTap: () {
                                    // print("object" + index.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 95,
                                          width: 95,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text("data")
                                      ],
                                    ),
                                  ),
                                ),
                              if (index % 2 == 0 && index < 6)
                                GestureDetector(
                                  onTap: () {
                                    // print("object" + index.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 95,
                                          width: 95,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(85)),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text("data")
                                      ],
                                    ),
                                  ),
                                ),
                              if (index == 6)
                                GestureDetector(
                                  onTap: () {
                                    // print("object" + index.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20),
                                    width: 95,
                                    height: 95,
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 45,
                                            width: 45,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      offset:
                                                          const Offset(1, 1),
                                                      blurRadius: 4,
                                                      spreadRadius: 1)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                            child: const Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.grey,
                                              size: 30,
                                            )),
                                        const Text("Xem tất cả",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        itemCount: 7,
                      ),
                    )
                  ],
                )),
          ),

          //  Phần QC
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 20, right: 10, bottom: 20, left: 10),
              height: 120,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.purple, borderRadius: BorderRadius.circular(5)),
            ),
          ),

          // Phần có thể muốn nghe
          SliverToBoxAdapter(
            child: Container(
                height: 250,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Có thể bạn muốn nghe",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                        height: 225,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, true, 5))
                  ],
                )),
          ),

          // Phần Nghe là thấy Tết
          SliverToBoxAdapter(
            child: Container(
                height: 240,
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Nghe là thấy Tết",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                        height: 210,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, false, 5))
                  ],
                )),
          ),

          // Phần XONE's CORNER
          SliverToBoxAdapter(
            child: Container(
                height: 240,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "XONE's CORNER",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                        height: 215,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, false, 5))
                  ],
                )),
          ),

          // Phần Radio nổi bật
          SliverToBoxAdapter(
            child: Container(
                height: 240,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Radio nổi bật",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                      height: 215,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              if (index < 6)
                                GestureDetector(
                                  onTap: () {
                                    // print("object" + index.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 140,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          140)),
                                            ),
                                            Positioned(
                                                left: 100,
                                                top: 100,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              35),
                                                      color: Colors.yellow
                                                          .withOpacity(0.8)),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text("data"),
                                        Text("data")
                                      ],
                                    ),
                                  ),
                                )
                              else
                                GestureDetector(
                                  onTap: () {
                                    // print("object" + index.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 20),
                                    width: 95,
                                    height: 95,
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 45,
                                            width: 45,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      offset:
                                                          const Offset(1, 1),
                                                      blurRadius: 4,
                                                      spreadRadius: 1)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                            child: const Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.grey,
                                              size: 30,
                                            )),
                                        const Text("Xem tất cả",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        itemCount: 7,
                      ),
                    )
                  ],
                )),
          ),

          // Phần mix riêng
          SliverToBoxAdapter(
            child: Container(
                height: 240,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Mix riêng cho bạn",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                        height: 215,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, false, 4))
                  ],
                )),
          ),

          // Phần nhạc mới mỗi ngày
          SliverToBoxAdapter(
            child: Container(
                height: 240,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Nhạc mới mỗi ngày",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                        height: 215,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, false, 5))
                  ],
                )),
          ),

          // Phần Zing Chart
          SliverToBoxAdapter(
            child: Container(
              height: 550,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  color: colors.AppColors.appColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Column(),
            ),
          ),

          // Phần Top 100
          SliverToBoxAdapter(
            child: Container(
                height: 250,
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Top 100",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                        height: 225,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, true, 5))
                  ],
                )),
          ),

          // Phần Sự kiện
          SliverToBoxAdapter(
            child: Container(
                height: 250,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Sự kiện",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                      height: 225,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              if (index < 6)
                                GestureDetector(
                                  onTap: () {
                                    // print("object" + index.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 140,
                                          width: 260,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.red.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 45,
                                          width: 260,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(children: const [
                                                Text("data"),
                                                Text("data"),
                                              ]),
                                              Container(
                                                child: const Text("Quan tâm"),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (index == 6)
                                GestureDetector(
                                  onTap: () {
                                    // print("object" + index.toString());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 20),
                                    width: 110,
                                    height: 110,
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 45,
                                            width: 45,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      offset:
                                                          const Offset(1, 1),
                                                      blurRadius: 4,
                                                      spreadRadius: 1)
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(45)),
                                            child: const Icon(
                                              Icons.arrow_right_alt,
                                              color: Colors.grey,
                                              size: 30,
                                            )),
                                        const Text("Xem tất cả",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey))
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                        itemCount: 7,
                      ),
                    )
                  ],
                )),
          ),

          // Phần EDM
          SliverToBoxAdapter(
            child: Container(
                height: 275,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.withOpacity(0.2))),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Vì bạn quan tâm",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text("EDM",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                        ],
                      )
                    ]),
                    Container(
                        height: 235,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, true, 5))
                  ],
                )),
          ),

          // Phần R&B
          SliverToBoxAdapter(
            child: Container(
                height: 275,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.withOpacity(0.2))),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Vì bạn quan tâm",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text("R&B",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                        ],
                      )
                    ]),
                    Container(
                        height: 225,
                        width: MediaQuery.of(context).size.width,
                        child: _buildListCard(_listTop100, true, 5))
                  ],
                )),
          ),

          // Phần Mới phát hành
          SliverToBoxAdapter(
            child: Container(
                height: 250,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Mới phát hành",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    _buildListCard(_listTop100, true, 6, subtext: true)
                  ],
                )),
          ),

          // Phần nghệ sĩ yêu thích
          SliverToBoxAdapter(
            child: Container(
                height: 240,
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        "Nghệ sĩ yêu thích",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ]),
                    Container(
                      height: 215,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // print("object" + index.toString());
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            );
                          },
                          itemCount: 7),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(List json, bool seeAll, int count,
      {bool subtext = false}) {
    return Container(
      height: 225,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            children: [
              if (index < count)
                GestureDetector(
                  onTap: () {
                    // print("object" + index.toString());
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 140,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: _loadingList == false
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    json[index]["img"],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(_loadingList == false
                            ? json[index]["title"]
                            : "data"),
                        Text(_loadingList == false
                            ? json[index]["subtitle"]
                            : "data"),
                        subtext == true
                            ? const Text("data") //Text(json[index]["subtext"])
                            : Container()
                      ],
                    ),
                  ),
                ),
              if (seeAll == true && index == count)
                GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    width: 110,
                    height: 110,
                    child: Column(
                      children: [
                        Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: const Offset(1, 1),
                                      blurRadius: 4,
                                      spreadRadius: 1)
                                ],
                                borderRadius: BorderRadius.circular(45)),
                            child: const Icon(
                              Icons.arrow_right_alt,
                              color: Colors.grey,
                              size: 30,
                            )),
                        const Text("Xem tất cả",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey))
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
        itemCount: count + 1,
      ),
    );
    ;
  }
}
