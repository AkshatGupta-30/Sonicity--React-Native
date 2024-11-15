import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/src/views/player/player_view.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
import 'package:super_string/super_string.dart';

class ViewAllPlaylistsView extends StatelessWidget {
  ViewAllPlaylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: ViewAllSearchPlaylistsController(Get.arguments),
              builder: (controller) {
                if(controller.playlists.isEmpty) {
                  return Center(
                    child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                  );
                }
                return CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    _appBar(context, controller),
                    _playlistList(controller)
                  ],
                );
              }
            ),
          ),
          MiniPlayerView()
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context, ViewAllSearchPlaylistsController controller) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true, floating: true, snap:  true,
      toolbarHeight: kToolbarHeight,
      leading: BackButton(),
      title: Text("Playlists - ${Get.arguments}".title(), maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () => controller.sort(SortType.name, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_ascending, label: "Name Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.name, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_alphabetical_descending, label: "Name Desc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.duration, Sort.asc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Song Count Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.duration, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Song Count Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded, color: theme.appBarTheme.actionsIconTheme!.color),
          position: PopupMenuPosition.under, color: Colors.grey.shade900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        Gap(8)
      ],
      expandedHeight: 320,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Container>[
            Container(
              height: 360, width: double.maxFinite, decoration: BoxDecoration(),
              child: (controller.playlists.length == 1)
              ? CachedNetworkImage(
                imageUrl: controller.playlists.first.image.highQuality, fit: BoxFit.cover,
                height: 320, width: 320,
                errorWidget: (_,__,___) {
                  return Image.asset(
                    "assets/images/playlistCover/playlistCover500x500.jpg",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
                placeholder: (_,__) {
                  return Image.asset(
                    "assets/images/playlistCover/playlistCover500x500.jpg",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: 4, shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  String image = controller.playlists[index].image.medQuality;
                  return CachedNetworkImage(
                    imageUrl: image, fit: BoxFit.cover,
                    height: 40, width: 40,
                    errorWidget: (_,__,___) {
                      return Image.asset(
                        "assets/images/playlistCover/playlistCover50x50.jpg",
                        fit: BoxFit.cover, height: 40, width: 40,
                      );
                    },
                    placeholder: (_,__) {
                      return Image.asset(
                        "assets/images/playlistCover/playlistCover50x50.jpg",
                        fit: BoxFit.cover, height: 40, width: 40,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              height: 360, width: double.maxFinite,
              color: (theme.brightness == Brightness.light) ? Colors.white.withOpacity(0.45) : Colors.black.withOpacity(0.45)
            ),
            Container(
              margin: EdgeInsets.only(top: kToolbarHeight), alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Text>[
                  Text(
                    "Playlists",
                    style: theme.textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white
                    )
                  ),
                  Text(
                    "${controller.playlistCount.value} Playlists",
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: (theme.brightness == Brightness.light) ? Colors.grey.shade700 : Colors.grey.shade300
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SliverPadding _playlistList(ViewAllSearchPlaylistsController controller) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      sliver: SliverList.builder(
        itemCount: (controller.isLoadingMore.value)
          ? controller.playlists.length + 1
          : controller.playlists.length,
        itemBuilder: (context, index) {
          if(index < controller.playlists.length) {
            Playlist playlist = controller.playlists[index];
            return PlaylistTile(playlist, subtitle: "${playlist.songCount} Songs");
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    );
  }
}