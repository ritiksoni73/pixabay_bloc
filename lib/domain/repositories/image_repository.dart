import 'package:pixabay_bloc/domain/entities/image_entity.dart';

abstract class ImageRepository {
  Future<List<ImageEntity>> fetchImages(int page);
}
