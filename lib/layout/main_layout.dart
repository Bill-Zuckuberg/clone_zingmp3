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

class _HomeLayoutState extends State<HomeLayout> {
  int _currentTabIndex = 1;

  @override
  Widget build(BuildContext context) {
    final _kTabScreens = <Widget>[
      const IndividualLayout(),
      const DiscoverLayout(),
      const ChartLayout(),
      const RadioLayout(),
      const TrackingLayout()
    ];

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
          Container(
            height: 55,
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
                      margin: const EdgeInsets.only(left: 10),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.access_time,
                          color: colors.AppColors.appColor,
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

      // Phần bottomNavigationBar
      bottomNavigationBar: _bottomNavBar,
    );
  }
}
