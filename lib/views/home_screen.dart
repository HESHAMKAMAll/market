import 'package:flutter/material.dart';
import '../widgets/appbar_custom.dart';
import '../widgets/banner_custom.dart';
import '../widgets/main_menu.dart';
import '../widgets/search_custom.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:
            MediaQuery.of(context).size.width >= 1045?
            Column(
              children: [
                SizedBox(
                  width: 1100,
                  child: Row(
                    children: [
                      AppbarCustom(onTap: () => Scaffold.of(context).openDrawer()),
                      Spacer(),
                      SearchCustom(),
                    ],
                  ),
                ),
                SizedBox(
                  width: 1300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BannerCustom(),
                      BannerCustom(),
                    ],
                  ),
                ),
                MainMenu(),
                // RowFilters(),
                // GridViewList(),
              ],
            ):
            Column(
              children: [
                AppbarCustom(onTap: () => Scaffold.of(context).openDrawer()),
                SearchCustom(),
                BannerCustom(),
                MainMenu(),
                // RowFilters(),
                // GridViewList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
