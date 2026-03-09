import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class NetworkImageHelper extends StatelessWidget {
  final String imageUrl;
  final double width;
  final BoxFit fit;
  final double height;

  const NetworkImageHelper({
    Key? key,
    required this.imageUrl,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.height = 200.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => const LoadingIndicator(),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
    );
  }
}
