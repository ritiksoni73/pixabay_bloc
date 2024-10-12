import 'package:pixabay_bloc/data/datasourses/image_remote_data_source.dart';

import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource remoteDataSource;

  ImageRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ImageEntity>> fetchImages(int page) async {
    return await remoteDataSource.fetchImages(page);
  }
}
