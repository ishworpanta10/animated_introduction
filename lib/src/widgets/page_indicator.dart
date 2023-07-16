import 'dart:math';

import 'package:animated_introduction/src/constants/constants.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int? currentIndex;
  final int? pageCount;
  final Color? activeDotColor;
  final Color? inactiveDotColor;
  final IndicatorType? type;
  final VoidCallback? onTap;

  const PageIndicator({
    super.key,
    this.currentIndex,
    this.pageCount,
    this.activeDotColor,
    this.onTap,
    this.inactiveDotColor,
    this.type,
  });

  _indicator(bool isActive) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: buildIndicatorShape(type, isActive),
      ),
    );
  }

  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount!; i++) {
      indicatorList.add(i == currentIndex ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildPageIndicators(),
    );
  }

  Widget buildIndicatorShape(type, isActive) {
    double scaleFactor = isActive ? 1.4 : 1.0;
    double angle = type == IndicatorType.diamond ? pi / 4 : 0.0;
    return Transform.scale(
      scale: scaleFactor,
      child: Transform.rotate(
        angle: angle,
        child: AnimatedContainer(
          height: type == IndicatorType.circle || type == IndicatorType.diamond ? 8.0 : 4.8,
          width: type == IndicatorType.circle || type == IndicatorType.diamond ? 8.0 : 24.0,
          duration: const Duration(milliseconds: 300),
          decoration: decoration(isActive, type),
        ),
      ),
    );
  }

  BoxDecoration decoration(bool isActive, type) {
    return BoxDecoration(
      shape: type == IndicatorType.circle ? BoxShape.circle : BoxShape.rectangle,
      color: isActive ? activeDotColor : inactiveDotColor,
      borderRadius: type == IndicatorType.circle || type == IndicatorType.diamond ? null : BorderRadius.circular(50),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.02), offset: const Offset(0.0, 2.0), blurRadius: 2.0)],
    );
  }
}
