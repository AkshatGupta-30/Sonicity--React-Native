import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:lottie/lottie.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/contants/constants.dart';
import 'package:sonicity/utils/widgets/widgets.dart';
import 'package:super_string/super_string.dart';

class ViewAllArtistsView extends StatelessWidget {
  ViewAllArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BackgroundGradientDecorator(
            child: GetBuilder(
              init: ViewAllSearchArtistsController(Get.arguments),
              builder: (controller) {
                if(controller.artists.isEmpty) {
                  return Center(
                    child: LottieBuilder.asset("assets/lottie/gramophone2.json", width: 100),
                  );
                }
                return CustomScrollView(
                  controller: controller.scrollController,
                  slivers: [
                    _appBar(context, controller),
                    _albumList(controller)
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context, ViewAllSearchArtistsController controller) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true, floating: true, snap:  true,
      leading: BackButton(),
      title: Text("Artists - ${Get.arguments}".title(), maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return <PopupMenuItem>[
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
                child: PopUpButtonRow(icon: Mdi.sort_numeric_ascending, label: "Type Asc")
              ),
              PopupMenuItem(
                onTap: () => controller.sort(SortType.duration, Sort.dsc),
                child: PopUpButtonRow(icon: Mdi.sort_numeric_descending, label: "Type Desc")
              ),
            ];
          },
          icon: Iconify(MaterialSymbols.sort_rounded, color: Get.theme.appBarTheme.actionsIconTheme!.color),
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
              child: (controller.artists.length == 1)
              ? CachedNetworkImage(
                imageUrl: controller.artists.first.image!.highQuality, fit: BoxFit.cover,
                height: 320, width: 320,
                errorWidget: (_,__,___) {
                  return Image.asset(
                    "assets/images/artistCover/artistCover500x500.jpg",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
                placeholder: (_,__) {
                  return Image.asset(
                    "assets/images/artistCover/artistCover500x500.jpg",
                    fit: BoxFit.cover, height: 320, width: 320
                  );
                },
              )
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: 4, shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  String image = controller.artists[index].image!.medQuality;
                  return CachedNetworkImage(
                    imageUrl: image, fit: BoxFit.cover,
                    height: 40, width: 40,
                    errorWidget: (_,__,___) {
                      return Image.asset(
                        "assets/images/artistCover/artistCover50x50.jpg",
                        fit: BoxFit.cover, height: 40, width: 40,
                      );
                    },
                    placeholder: (_,__) {
                      return Image.asset(
                        "assets/images/artistCover/artistCover50x50.jpg",
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
                    "Artists",
                    style: theme.textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: (theme.brightness == Brightness.light) ? Colors.black : Colors.white
                    )
                  ),
                  Text(
                    "${controller.artistCount.value} Artists",
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

  SliverPadding _albumList(ViewAllSearchArtistsController controller) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      sliver: SliverList.builder(
        itemCount: (controller.isLoadingMore.value)
          ? controller.artists.length + 1
          : controller.artists.length,
        itemBuilder: (context, index) {
          if(index < controller.artists.length) {
            Artist artist = controller.artists[index];
            return ArtistTile(artist, subtitle: artist.dominantType!);
          } else {
            return Lottie.asset("assets/lottie/gramophone1.json", animate: true, height: 50);
          }
        },
      ),
    );
  }
}