import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay_bloc/utills/contants.dart';
import '../bloc/image_bloc.dart';
import '../../domain/entities/image_entity.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({super.key});

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  List<ImageEntity> allImages = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ImageBloc>().add(LoadImagesEvent(_page, false));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        _page++;
        context.read<ImageBloc>().add(LoadImagesEvent(_page, true));
      }
    }
  }

  Future<void> _onRefresh() async {
    _page = 1;
    allImages.clear(); // Clear the existing images for refresh
    context.read<ImageBloc>().add(LoadImagesEvent(_page, false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.pixabayImageGallery)),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<ImageBloc, ImageState>(
          builder: (context, state) {
            if (state is ImageLoading && _page == 1) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ImageLoaded) {
              allImages.addAll(state.images);
              _isLoadingMore = false;
            } else if (state is ImageError) {
              _isLoadingMore = false;
              return Center(child: Text(state.message));
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverGrid.count(
                  crossAxisCount: _calculateCrossAxisCount(context),
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                  children: List.generate(
                    allImages.length,
                    (index) {
                      final image = allImages[index];
                      return _buildImageItem(image);
                    },
                  ),
                ),
                if (_isLoadingMore)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageItem(ImageEntity image) {
    return Column(
      children: [
        Expanded(
          child: Image.network(image.imageUrl, fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${Constants.likes} ${image.likes} ${Constants.views} ${image.views}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      return 2;
    } else if (screenWidth <= 1200) {
      return 4;
    } else {
      return 6;
    }
  }
}
