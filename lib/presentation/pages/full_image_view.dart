import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FullImageView extends StatelessWidget {
  FullImageView(this.image, {super.key});
  String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  image,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                  child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Center(
                        child: Icon(Icons.keyboard_arrow_left,
                            color: Colors.black)),
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
