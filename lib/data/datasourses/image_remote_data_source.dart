import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pixabay_bloc/data/models/image_model.dart';

import '../../utills/contants.dart';

abstract class ImageRemoteDataSource {
  Future<List<ImageModel>> fetchImages(int page);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final Dio dio;

  ImageRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ImageModel>> fetchImages(int page) async {
    List<ImageModel> images = [];
    try {
      String apiKey = const String.fromEnvironment(Constants.pixabayKey);
      final response = await dio.get(
          'https://pixabay.com/api/?key=$apiKey&image_type=photo&per_page=20&page=$page');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['hits'];
        images = data.map((json) => ImageModel.fromJson(json)).toList();
        return images;
      } else {
        throw Exception(Constants.failedFetchImages);
      }
    } catch (e) {
      debugPrint(e.toString());
      return images;
    }
  }
}
