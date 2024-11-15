import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/src/models/models.dart';
import 'package:sonicity/utils/widgets/widgets.dart';

enum ImgQuality {low, med, high}
class ImageQuality {
  static String get q50x50 => "50x50";
  static String get q150x150 => "150x150";
  static String get q500x500 => "500x500";
}

class CoverImageSection extends StatelessWidget {
  final ImageUrl image;
  CoverImageSection({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Container>[
          _column(
            context, q: ImgQuality.high, url: image.highQuality,
            onTap: () {
              FlutterClipboard.copy(image.highQuality).then(
                (_) => Get.showSnackbar(GetSnackBar(
                  messageText: Row(
                    children: [
                      Obx(() => Text(
                        "Copied cover image high quality url",
                        style: TextStyle(color: Get.find<SettingsController>().getAccent, fontSize: 18),
                      )),
                      Iconify(
                        MaterialSymbols.done, size: 25,
                        color: (theme.brightness == Brightness.light) ? Colors.green : Colors.greenAccent,
                      ),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ))
              );
            }
          ),
          Container(width: 0.5, height: 150, color: Colors.white38),
          _column(context,
            q: ImgQuality.med, url: image.highQuality,
            onTap: () {
              FlutterClipboard.copy(image.medQuality).then(
                (_) => Get.showSnackbar(GetSnackBar(
                  messageText: Row(
                    children: [
                      Obx(() => Text(
                        "Copied cover image medium quality url",
                        style: TextStyle(color: Get.find<SettingsController>().getAccent, fontSize: 18),
                      )),
                      Iconify(
                        MaterialSymbols.done, size: 25,
                        color: (theme.brightness == Brightness.light) ? Colors.green : Colors.greenAccent,
                      ),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ))
              );
            }
          ),
          Container(width: 0.5, height: 150, color: Colors.white38),
          _column(context,
            q: ImgQuality.low, url: image.highQuality,
            onTap: () {
              FlutterClipboard.copy(image.lowQuality).then(
                (_) => Get.showSnackbar(GetSnackBar(
                  messageText: Row(
                    children: [
                      Obx(() => Text(
                        "Copied cover image low quality url",
                        style: TextStyle(color: Get.find<SettingsController>().getAccent, fontSize: 18),
                      )),
                      Iconify(
                        MaterialSymbols.done, size: 25,
                        color: (theme.brightness == Brightness.light) ? Colors.green : Colors.greenAccent,
                      ),
                    ],
                  ),
                  duration: Duration(seconds: 2),
                ))
              );
            }
          ),
        ],
      ),
    );
  }

  Container _column(BuildContext context, {required ImgQuality q, required String url, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    String quality = (q == ImgQuality.high)
      ? "High Quality"
      : ((q == ImgQuality.med) ? "Medium Quality" : "Low Quality");
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        children: [
          Text(quality, style: theme.textTheme.bodyMedium),
          Gap(4),
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: url, fit: BoxFit.cover, height: 120, width: 120,
                placeholder: (_,__) {
                  return Image.asset(
                    "assets/images/appLogo/appLogo500x500.png",
                    fit: BoxFit.cover, height: 120, width: 120
                  );
                },
                errorWidget: (_,__,___) {
                  return Image.asset(
                    "assets/images/appLogo/appLogo500x500.png",
                    fit: BoxFit.cover, height: 120, width: 120,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}