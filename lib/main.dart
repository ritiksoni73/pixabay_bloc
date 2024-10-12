import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:pixabay_bloc/data/datasourses/image_remote_data_source.dart';
import 'package:pixabay_bloc/domain/repositories/image_repository.dart';
import 'package:pixabay_bloc/presentation/bloc/image_bloc.dart';
import 'package:pixabay_bloc/utills/contants.dart';
import 'data/repositories/image_repository_impl.dart';
import 'presentation/pages/image_gallery_page.dart';

void main() {
  final dio = Dio();
  final imageRemoteDataSource = ImageRemoteDataSourceImpl(dio);
  final imageRepository = ImageRepositoryImpl(imageRemoteDataSource);
  runApp(MyApp(imageRepository: imageRepository));
}

class MyApp extends StatelessWidget {
  final ImageRepository imageRepository;

  const MyApp({super.key, required this.imageRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ImageBloc(imageRepository),
        ),
      ],
      child: MaterialApp(
        title: Constants.pixabayImageGallery,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ImageGalleryPage(),
      ),
    );
  }
}
