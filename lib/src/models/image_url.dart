class ImageUrl {
  final List<ImageData> _imageData;

  ImageUrl({required List<ImageData> imageLinks}) : _imageData = imageLinks;

  late final String lowQuality = _getImageUrl('50x50');
  late final String medQuality = _getImageUrl('150x150');
  late final String highQuality = _getImageUrl('500x500');

  String _getImageUrl(String quality) {
    final link = _imageData.firstWhere(
      (img) => img.quality == quality,
      orElse: () => ImageData(quality: '', link: ''),
    );
    return link.link;
  }

  factory ImageUrl.fromJson(List<dynamic> json) {
    List<ImageData> links = json.map((link) => ImageData.fromJson(link)).toList();
    return ImageUrl(imageLinks: links);
  }

  factory ImageUrl.empty() {
    return ImageUrl(
      imageLinks: []
    );
  }

  bool isEmpty() {
    return _imageData.isEmpty;
  }

  List<Map<String,dynamic>> toMap() {
    return _imageData.map((data) => data.toMap()).toList();
  }
}

class ImageData {
  final String quality;
  final String link;

  ImageData({required this.quality, required this.link});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
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
