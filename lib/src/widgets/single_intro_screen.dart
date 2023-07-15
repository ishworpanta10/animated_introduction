import 'package:flutter/material.dart';

import 'image_with_bubble.dart';

class SingleIntroScreen extends StatelessWidget {
  /// title of your slide
  ///[String]
  final String? title;

  ///description of your slide
  ///[String]
  final String? description;

  ///image path for your slide
  ///[String]
  final String? imageAsset;

  ///image path from network
  ///[String]
  final String? imageNetwork;

  ///textStyle for your slide
  ///[TextStyle]
  final TextStyle? textStyle;

  ///background color for your slide header
  ///[Color]
  final Color? headerBgColor;

  ///padding for the your slide header
  ///[EdgeInsets]
  final EdgeInsets slidePagePadding;

  ///widget to use as the header part of your screen
  ///[Widget]
  final Widget? headerWidget;

  ///image height for your slide
  ///[double]
  final double imageHeightMultiple;

  /// dot bg Color
  /// [Color]
  final Color sideDotsBgColor;

  /// card bg Color
  /// [Color]
  final Color mainCircleBgColor;

  /// image with bubble
  /// [bool]
  final bool imageWithBubble;

  /// ball radius
  /// [double]
  final double? centerBallRadius;

  const SingleIntroScreen({
    super.key,
    required this.title,
    required this.description,
    this.slidePagePadding = const EdgeInsets.all(12),
    this.headerWidget,
    this.headerBgColor,
    this.textStyle,
    this.imageAsset,
    this.imageHeightMultiple = 0.5,
    this.sideDotsBgColor = Colors.lightBlueAccent,
    this.mainCircleBgColor = Colors.blue,
    this.imageWithBubble = true,
    this.centerBallRadius,
    this.imageNetwork,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: double.infinity,
      height: screenSize.height,
      child: Column(
        children: <Widget>[
          Container(
            height: screenSize.height * .8,
            padding: slidePagePadding,
            decoration: BoxDecoration(color: headerBgColor),
            child: Center(
              child: imageAsset != null || imageNetwork != null
                  ? imageWithBubble
                      ? ImageWithBubble(
                          cardBgColor: mainCircleBgColor,
                          dotBgColor: sideDotsBgColor,
                          imageAsset: imageAsset,
                          imageNetwork: imageNetwork,
                          imageHeightMultiple: imageHeightMultiple,
                          ballRadius: centerBallRadius ?? screenSize.width * 0.3,
                        )
                      : imageAsset != null
                          ? Image.asset(
                              imageAsset!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: screenSize.height * imageHeightMultiple,
                            )
                          : Image.network(
                              imageNetwork!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: screenSize.height * imageHeightMultiple,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.error));
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            )
                  : headerWidget ??
                      Text(
                        "Header Widgets",
                        style: textStyle?.apply(
                          fontSizeDelta: 2,
                          fontWeightDelta: 3,
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
