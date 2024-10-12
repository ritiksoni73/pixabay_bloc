import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../../utills/contants.dart';

// Events
abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class LoadImagesEvent extends ImageEvent {
  final int page;
  final bool isLoadingMore;
  const LoadImagesEvent(this.page, this.isLoadingMore);

  @override
  List<Object?> get props => [page];
}

// States
abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object?> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoadingMore extends ImageState {}

class ImageLoaded extends ImageState {
  final List<ImageEntity> images;

  const ImageLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageRepository imageRepository;
  List<ImageEntity> allImages = [];
  ImageBloc(this.imageRepository) : super(ImageInitial()) {
    on<LoadImagesEvent>((event, emit) async {
      event.isLoadingMore ? emit(ImageLoadingMore()) : emit(ImageLoading());
      try {
        final images = await imageRepository.fetchImages(event.page);
        allImages.addAll(images);
        emit(ImageLoaded(allImages));
      } catch (e) {
        emit(const ImageError(Constants.failedFetchImages));
      }
    });
  }
}
