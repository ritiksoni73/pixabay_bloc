import '../../domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  ImageModel({
    required String imageUrl,
    required int likes,
    required int views,
  }) : super(imageUrl: imageUrl, likes: likes, views: views);

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageUrl: json['webformatURL'],
      likes: json['likes'],
      views: json['views'],
    );
  }
}
