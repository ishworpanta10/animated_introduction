import 'dart:developer';

import 'package:flutter/material.dart';

class ImageWithBubble extends StatelessWidget {
  const ImageWithBubble({
    super.key,
    required this.dotBgColor,
    required this.cardBgColor,
    this.imageAsset,
    this.imageNetwork,
    this.imageHeightMultiple = 0.5,
    required this.ballRadius,
  });

  /// image path for your slide
  /// [String]
  final String? imageAsset;

  /// image path from network
  /// [String]
  final String? imageNetwork;

  /// dot bg Color
  /// [Color]
  final Color dotBgColor;

  /// card bg Color
  /// [Color]
  final Color cardBgColor;

  ///image height for your slide
  ///[double]
  final double imageHeightMultiple;

  ///ball radius
  ///[double]
  final double ballRadius;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        /// main big circle avatar
        CircleAvatar(
          radius: ballRadius,
          backgroundColor: cardBgColor.withOpacity(0.6),
        ),
        Positioned(
          left: MediaQuery.sizeOf(context).width * 0.03,
          child: CircleAvatar(
            radius: 6,
            backgroundColor: dotBgColor,
          ),
        ),
        Positioned(
          left: MediaQuery.sizeOf(context).width * 0.08,
          top: MediaQuery.sizeOf(context).height * 0.2,
          child: CircleAvatar(
            radius: 2,
            backgroundColor: dotBgColor,
          ),
        ),
        Positioned(
          left: MediaQuery.sizeOf(context).width * 0.1,
          top: MediaQuery.sizeOf(context).height * 0.1,
          child: CircleAvatar(
            radius: 4,
            backgroundColor: dotBgColor,
          ),
        ),
        Positioned(
          left: MediaQuery.sizeOf(context).width * 0.3,
          top: -MediaQuery.sizeOf(context).height * 0.033,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: dotBgColor,
          ),
        ),
        Positioned(
          left: MediaQuery.sizeOf(context).width * 0.7,
          top: 0,
          child: CircleAvatar(
            radius: 3,
            backgroundColor: dotBgColor,
          ),
        ),
        Positioned(
          left: MediaQuery.sizeOf(context).width * 0.86,
          top: MediaQuery.sizeOf(context).height * 0.1,
          child: CircleAvatar(
            radius: 7,
            backgroundColor: dotBgColor,
          ),
        ),
        Positioned(
          left: MediaQuery.sizeOf(context).width * 0.92,
          child: CircleAvatar(
            radius: 2,
            backgroundColor: dotBgColor,
          ),
        ),
        if (imageAsset != null)
          Image.asset(
            imageAsset!,
            fit: BoxFit.contain,
            width: double.infinity,
            height: screenSize.height * imageHeightMultiple,
          )
        else if (imageNetwork != null)
          Image.network(
            imageNetwork!,
            fit: BoxFit.contain,
            width: double.infinity,
            height: screenSize.height * imageHeightMultiple,
            errorBuilder: (context, error, stackTrace) {
              log(error.toString());

              return const Center(child: Icon(Icons.error));
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
