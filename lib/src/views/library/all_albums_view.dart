import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

class AllAlbumsView extends StatelessWidget {
  AllAlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AllAlbumsController(),
      builder: (controller) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BackgroundGradientDecorator(
                child: CustomScrollView(
                  slivers: [
                    _appbar(context, controller),
                    _body(controller)
                  ],
                ),
              ),
              MiniPlayerView()
            ],
          ),
        );
      }
    );
  }

  SliverAppBar _appbar(BuildContext context, AllAlbumsController controller) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true, shadowColor: Colors.transparent,
      title: Text("All Albums"),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () => controller.sortAlbums(SortType.name, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortAlbums(SortType.name, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortAlbums(SortType.duration, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Duration Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortAlbums(SortType.duration, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Duration Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortAlbums(SortType.year, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_ascending, label: "Year Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sortAlbums(SortType.year, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_calendar_descending, label: "Year Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded,),
          position: PopupMenuPosition.under,
          color: (theme.brightness == Brightness.light) ? Colors.grey.shade100 : Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ],
      bottom: TabBar(
        controller: controller.tabController,
        labelColor: (theme.brightness == Brightness.light) ? Colors.black : Colors.white,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Get.find<SettingsController>().getAccent, dividerColor: Get.find<SettingsController>().getAccentDark,
        tabs: [Tab(text: "Starred"), Tab(text: "Clones")],
      ),
    );
  }

  SliverFillRemaining _body(AllAlbumsController controller) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: controller.tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.starAlbums.length,
            itemBuilder: (context, index) {
              Album album = controller.starAlbums[controller.starAlbums.length - index - 1];
              return AlbumTile(album, subtitle: '${album.songCount} Songs',);
            },
          )),
          Obx(() => ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            itemCount: controller.cloneAlbums.length,
            itemBuilder: (context, index) {
              Album album = controller.cloneAlbums[controller.cloneAlbums.length - index - 1];
              return AlbumTile(album, subtitle: '${album.songCount} Songs',);
            },
          )),
        ],
      ),
    );
  }
}
