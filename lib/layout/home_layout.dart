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
      body: TabBarView(children: _kTabPages, controller: _tabcontroller),
      bottomNavigationBar: Material(
        child: TabBar(
          tabs: _kTabs,
          controller: _tabcontroller,
        ),
      ),
    );
  }
}
