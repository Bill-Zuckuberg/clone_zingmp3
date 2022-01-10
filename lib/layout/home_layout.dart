import 'package:clone_zingmp3/layout/chart_layout.dart';
import 'package:clone_zingmp3/layout/discover_layout.dart';
import 'package:clone_zingmp3/layout/individual_layout.dart';
import 'package:clone_zingmp3/layout/radio_layout.dart';
import 'package:clone_zingmp3/layout/tracking_layout.dart';
import 'package:flutter/material.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabcontroller;
  static final _kTabs = <Tab>[
    Tab(
      icon: Icon(
        Icons.ac_unit,
        color: colors.AppColors.AppColor,
      ),
      child: Text(
        'Cá nhân',
        style: TextStyle(color: colors.AppColors.AppColor, fontSize: 10),
      ),
    ),
    Tab(
      icon: Icon(
        Icons.ac_unit,
        color: colors.AppColors.AppColor,
      ),
      child: Text(
        'Khám phá',
        style: TextStyle(color: colors.AppColors.AppColor, fontSize: 10),
      ),
    ),
    Tab(
      icon: Icon(
        Icons.ac_unit,
        color: colors.AppColors.AppColor,
      ),
      child: Text(
        '#Zingchart',
        style: TextStyle(color: colors.AppColors.AppColor, fontSize: 10),
      ),
    ),
    Tab(
      icon: Icon(
        Icons.ac_unit,
        color: colors.AppColors.AppColor,
      ),
      child: Text(
        'Radio',
        style: TextStyle(color: colors.AppColors.AppColor, fontSize: 10),
      ),
    ),
    Tab(
      icon: Icon(
        Icons.ac_unit,
        color: colors.AppColors.AppColor,
      ),
      child: Text(
        'Theo dỏi',
        style: TextStyle(color: colors.AppColors.AppColor, fontSize: 10),
      ),
    )
  ];

  static const _kTabPages = <Widget>[
    IndividualLayout(),
    DiscoverLayout(),
    ChartLayout(),
    RadioLayout(),
    TrackingLayout()
  ];
  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: _kTabPages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Phần TabBarView
          Expanded(
              child:
                  TabBarView(children: _kTabPages, controller: _tabcontroller)),
          // Phần hiển thị nhạc đang nghe
          Container(
            height: 55,
            color: Colors.red.withOpacity(0.2),
            child: Column(
              children: [
                Container(
                  height: 5,
                  color: colors.AppColors.AppColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.access_time,
                          color: colors.AppColors.AppColor,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Slider Text"),
                                Text("Tên ca sĩ")
                              ],
                            ))),
                    const Icon(Icons.favorite_border),
                    const Icon(Icons.play_arrow),
                    const Icon(Icons.arrow_right_outlined),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      // Phần BottomBar
      bottomNavigationBar: Material(
        child: TabBar(
          tabs: _kTabs,
          controller: _tabcontroller,
        ),
      ),
    );
  }
}
