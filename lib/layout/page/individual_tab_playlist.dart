import 'package:clone_zingmp3/layout/individual_layout.dart';
import 'package:flutter/material.dart';
import 'package:clone_zingmp3/mics/colors.dart' as colors;

class TabPlayList extends StatefulWidget {
  const TabPlayList({Key? key}) : super(key: key);

  @override
  _TabPlaylistState createState() => _TabPlaylistState();
}

class _TabPlaylistState extends State<TabPlayList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // CustomScrollView(
          //   slivers: [
          //     SliverToBoxAdapter(
          //       child:
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlaylist(10),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Gợi ý cho bạn",
            style: TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            "Dựa trên lịch sử và thư viện cá nhân",
            style: TextStyle(
                fontSize: 12,
                color: colors.AppColors.appUnSelectColor,
                fontWeight: FontWeight.normal),
          ),
          _buildPlaylist(2),
        ],
      ),
    )
        //     ],
        //   ),
        // )
        ;
  }

  Widget _buildPlaylist(int count) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) => index == 0
            ? ListTile(
                onTap: () {},
                // contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: colors.AppColors.appColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Icon(Icons.add_circle_outline)),
                ),
                title: const Text("Tạo playlist"),
                // dense: true,
              )
            : ListTile(
                onTap: () {},
                // contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: colors.AppColors.appColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Icon(Icons.add_circle_outline)),
                ),
                title: const Text("Title"),
                subtitle: const Text("Subtitle"),
              ));
  }
}
