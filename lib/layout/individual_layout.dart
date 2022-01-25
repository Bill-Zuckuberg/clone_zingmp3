import 'package:clone_zingmp3/layout/page/individual_tab_close.dart';
import 'package:clone_zingmp3/layout/page/individual_tab_mixmusic.dart';
import 'package:clone_zingmp3/layout/page/individual_tab_playlist.dart';
import 'package:clone_zingmp3/layout/page/loanding_page.dart';
import 'package:flutter/material.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;

class IndividualLayout extends StatefulWidget {
  const IndividualLayout({Key? key}) : super(key: key);

  @override
  _IndividualLayoutState createState() => _IndividualLayoutState();
}

class _IndividualLayoutState extends State<IndividualLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double heightApp = 0;
  final _kTabSreens = <Widget>[
    const TabPlayList(),
    const TabMixMusic(),
    const TabClose(),
  ];
  final _kTabs = [
    const Tab(
      child: Text(
        'Playlist',
      ),
    ),
    const Tab(
      child: Text('Mix nhạc'),
    ),
    const Tab(
      child: Text('Gần đây'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _kTabSreens.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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

        SliverToBoxAdapter(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Thư Viện",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //     // Phần GridView
                  Container(
                    height: 200,
                    child: _buildGridList(),
                  ),

                  SizedBox(
                    height: 1200,
                    width: MediaQuery.of(context).size.width,
                    child: NestedScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      headerSliverBuilder:
                          (BuildContext context, bool isScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            backgroundColor: Colors.white,
                            pinned: true,
                            floating: false,
                            snap: false,
                            actions: [
                              Expanded(
                                  child: Row(
                                children: [
                                  TabBar(
                                      controller: _tabController,
                                      isScrollable: true,
                                      labelStyle: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      labelColor: Colors.black,
                                      unselectedLabelColor:
                                          colors.AppColors.unSelectedTitle,
                                      tabs: _kTabs),
                                  Expanded(child: Container()),
                                  Icon(
                                    Icons.adaptive.more,
                                    color: Colors.black,
                                  )
                                ],
                              ))
                            ],
                          )
                        ];
                      },
                      body: Builder(builder: (context) {
                        return
                            // ListView.builder(
                            //     itemCount: 20,
                            //     itemBuilder: (context, index) {
                            //       return Container(
                            //         height: 50,
                            //         width: 50,
                            //         margin: const EdgeInsets.all(8),
                            //         color: Colors.green,
                            //       );
                            //     })

                            TabBarView(
                          // physics: const NeverScrollableScrollPhysics(),
                          children: _kTabSreens,
                          controller: _tabController,
                        );
                      }),
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }

// GridView List
  Widget _buildGridList() {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      padding: const EdgeInsets.all(2),
      childAspectRatio: 0.51,
      children: List.generate(7, (index) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 1,
                    offset: const Offset(-2, -1)),
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 1,
                    offset: const Offset(2, 2)),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/music.png"),
                      fit: BoxFit.cover),
                ),
                child: Container(),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: Row(
                  children: [
                    const Text(
                      'Bài hát',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('12',
                        style: TextStyle(
                            color: colors.AppColors.unSelectedTitle,
                            fontSize: 14,
                            fontWeight: FontWeight.w600))
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
