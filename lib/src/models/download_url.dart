import 'package:get/get.dart';
import 'package:sonicity/src/controllers/controllers.dart';
import 'package:sonicity/utils/sections/sections.dart';

class DownloadUrl {
  final List<DownloadData> _downloadData;

  DownloadUrl({required List<DownloadData> imageLinks}) : _downloadData = imageLinks;

  late final String q12kbps = _getImageUrl(DownloadQuality.q12kbps);
  late final String q48kbps = _getImageUrl(DownloadQuality.q48kbps);
  late final String q96kbps = _getImageUrl(DownloadQuality.q96kbps);
  late final String q160kbps = _getImageUrl(DownloadQuality.q160kbps);
  late final String q320kbps = _getImageUrl(DownloadQuality.q320kbps);

  String _getImageUrl(String quality) {
    final link = _downloadData.firstWhere(
      (dLoad) => dLoad.quality == quality,
      orElse: () => DownloadData(quality: '', link: ''),
    );
    return link.link;
  }

  factory DownloadUrl.fromJson(List<dynamic> json) {
    List<DownloadData> links = json.map((link) => DownloadData.fromJson(link)).toList();
    return DownloadUrl(imageLinks: links);
  }

  factory DownloadUrl.fromDb(List<Map<String,dynamic>> data) {
    return DownloadUrl.empty();
  }

  factory DownloadUrl.empty() {
    return DownloadUrl(
      imageLinks: []
    );
  }

  bool isEmpty() {
    return _downloadData.isEmpty;
  }

  List<Map<String,dynamic>> toMap() {
    return _downloadData.map((data) => data.toMap()).toList();
  }

  String get link {
    switch (Get.find<SettingsController>().getMusicQuality) {
      case "12kbps" : return q12kbps;
      case "48kbps" : return q48kbps;
      case "96kbps" : return q96kbps;
      case "160kbps" : return q160kbps;
      default: return q320kbps;
    }
  }
}

class DownloadData {
  final String quality;
  final String link;

  DownloadData({required this.quality, required this.link});

  factory DownloadData.fromJson(Map<String, dynamic> json) {
    return DownloadData(
      quality: json['quality'],
      link: json['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quality': quality,
      'url': link,
    };
  }
}
