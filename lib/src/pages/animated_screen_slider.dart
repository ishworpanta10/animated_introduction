import 'package:animated_introduction/src/constants/constants.dart';
import 'package:animated_introduction/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIntroduction extends StatefulWidget {
//  PageController get controller => this.createState()._controller;

  @override
  AnimatedIntroductionState createState() => AnimatedIntroductionState();

  ///sets the indicator type for your slides
  ///[IndicatorType]
  final IndicatorType? indicatorType;

  ///sets the next widget, the one used to move to the next screen
  ///[Widget]
  final Widget? nextWidget;

  ///sets the next text, the one used to move to the next screen
  ///[String]
  final String nextText;

  ///sets the done widget, the one used to end the slides
  ///[Widget]
  final Widget? doneWidget;

  ///set the radius of the footer part of your slides
  ///[double]
  final double footerRadius;

  ///sets the viewport fraction of your controller
  ///[double]
  final double viewPortFraction;

  ///sets your slides
  ///[List<IntroScreen>]
  final List<SingleIntroScreen> slides;

  ///sets the skip widget text
  ///[String]
  final String skipText;

  /// sets the done text
  /// [String]
  final String doneText;

  ///defines what to do when the skip button is tapped
  ///[Function]
  final Function? onSkip;

  ///defines what to do when the last slide is reached
  ///[Function]
  final Function onDone;

  /// set the color of the active indicator
  ///[Color]
  final Color activeDotColor;

  ///set the color of an inactive indicator
  ///[Color]
  final Color? inactiveDotColor;

  ///sets the padding of the footer part of your slides
  ///[EdgeInsets]
  final EdgeInsets footerPadding;

  ///sets the background color of the footer part of your slides
  ///[Color]
  final Color footerBgColor;

  ///sets the text color of your slides
  ///[Color]
  final Color textColor;

  ///sets the colors of the gradient for the footer widget of your slides
  ///[List<Color>]
  final List<Color> footerGradients;

  ///[ScrollPhysics]
  ///sets the physics for the page view
  final ScrollPhysics physics;

  ///[Color]
  ///sets the wrapper container's background color, defaults to white
  final Color containerBg;

  ///[double]
  ///sets the height of the footer widget
  final double? topHeightForFooter;

  ///[bool]
  ///is the screen full screen with systemNavigationBarColor
  final bool isFullScreen;

  const AnimatedIntroduction({
    super.key,
    required this.slides,
    this.footerRadius = 26.0,
    this.footerGradients = const [],
    this.containerBg = Colors.white,
    required this.onDone,
    this.indicatorType = IndicatorType.circle,
    this.physics = const BouncingScrollPhysics(),
    this.onSkip,
    this.nextWidget,
    this.doneWidget,
    this.activeDotColor = Colors.white,
    this.inactiveDotColor,
    this.skipText = 'Skip',
    this.nextText = 'Next',
    this.doneText = 'Login Now',
    this.viewPortFraction = 1.0,
    this.textColor = Colors.white,
    this.footerPadding = const EdgeInsets.all(24),
    this.footerBgColor = const Color(0xff51adf6),
    this.topHeightForFooter,
    this.isFullScreen = false,
  }) : assert(slides.length > 0);
}

class AnimatedIntroductionState extends State<AnimatedIntroduction> with TickerProviderStateMixin {
  PageController? _controller;
  double? pageOffset = 0;
  int currentPage = 0;
  bool lastPage = false;
  late AnimationController animationController;
  SingleIntroScreen? currentScreen;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: widget.viewPortFraction,
    )..addListener(() {
        pageOffset = _controller!.page;
      });

    currentScreen = widget.slides[0];
    animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
  }

  get onSkip => widget.onSkip ?? defaultOnSkip;

  defaultOnSkip() => _controller?.animateToPage(
        widget.slides.length - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );

  TextStyle get textStyle =>
      currentScreen!.textStyle ??
      Theme.of(context).textTheme.bodyLarge ??
      const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      );

  Widget get next =>
      widget.nextWidget ??
      Text(
        widget.nextText,
        style: textStyle.apply(
          color: widget.textColor,
          fontSizeFactor: .9,
          fontWeightDelta: 1,
        ),
      );

  Widget get done =>
      widget.doneWidget ??
      Text(
        widget.doneText,
        style: textStyle.apply(
          color: widget.textColor,
          fontSizeFactor: .9,
          fontWeightDelta: 1,
        ),
      );

  @override
  void dispose() {
    _controller!.dispose();
    animationController.dispose();
    super.dispose();
  }

  bool get existGradientColors => widget.footerGradients.isNotEmpty && widget.footerGradients.length > 1;

  LinearGradient get gradients => existGradientColors
      ? LinearGradient(colors: widget.footerGradients, begin: Alignment.topLeft, end: Alignment.topRight)
      : LinearGradient(
          colors: [
            widget.footerBgColor,
            widget.footerBgColor,
          ],
        );

  int getCurrentPage() => _controller!.page!.floor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: currentScreen?.headerBgColor?.withOpacity(.8) ?? Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: widget.isFullScreen ? gradients.colors.first : null,
        ),
        child: Container(
          color: widget.containerBg,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              PageView.builder(
                itemCount: widget.slides.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                    currentScreen = widget.slides[currentPage];
                    if (currentPage == widget.slides.length - 1) {
                      lastPage = true;
                      animationController.forward();
                    } else {
                      lastPage = false;
                      animationController.reverse();
                    }
                  });
                },
                controller: _controller,
                physics: widget.physics,
                itemBuilder: (context, index) {
                  if (index == pageOffset!.floor()) {
                    return AnimatedBuilder(
                        animation: _controller!,
                        builder: (context, _) {
                          return buildPage(
                            index: index,
                            angle: pageOffset! - index,
                          );
                        });
                  } else if (index == pageOffset!.floor() + 1) {
                    return AnimatedBuilder(
                      animation: _controller!,
                      builder: (context, _) {
                        return buildPage(
                          index: index,
                          angle: pageOffset! - index,
                        );
                      },
                    );
                  }
                  return buildPage(index: index);
                },
              ),
              //footer widget
              Positioned.fill(
                bottom: 0,
                left: 0,
                right: 0,
                top: widget.topHeightForFooter ?? MediaQuery.sizeOf(context).height * .72,
                child: Container(
                  padding: widget.footerPadding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(widget.footerRadius.toDouble()),
                      topLeft: Radius.circular(widget.footerRadius.toDouble()),
                    ),
                    color: widget.footerBgColor,
                    gradient: gradients,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Text(
                            currentScreen!.title!,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle.apply(
                              color: widget.textColor,
                              fontWeightDelta: 1,
                              fontSizeDelta: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentScreen!.description!,
                            softWrap: true,
                            style: textStyle.apply(
                              color: widget.textColor,
                              fontSizeFactor: .9,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //controls widget
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IgnorePointer(
                          ignoring: lastPage,
                          child: Opacity(
                            opacity: lastPage ? 0.0 : 1.0,
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: onSkip,
                                child: Text(
                                  widget.skipText,
                                  style: textStyle.apply(
                                    color: widget.textColor,
                                    fontSizeFactor: .9,
                                    fontWeightDelta: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 160,
                            child: PageIndicator(
                              type: widget.indicatorType,
                              currentIndex: currentPage,
                              activeDotColor: widget.activeDotColor,
                              inactiveDotColor: widget.inactiveDotColor ?? widget.activeDotColor.withOpacity(.5),
                              pageCount: widget.slides.length,
                              onTap: () {
                                _controller!.animateTo(
                                  _controller!.page!,
                                  duration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
                            ),
                          ),
                        ),
                        Material(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          type: MaterialType.transparency,
                          child: lastPage
                              ? InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: widget.onDone as void Function()?,
                                  child: done,
                                )
                              : InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  child: next,
                                  onTap: () => _controller!.nextPage(
                                    duration: const Duration(milliseconds: 800),
                                    curve: Curves.fastOutSlowIn,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPage({required int index, double angle = 0.0, double scale = 1.0}) =>
      // print(pageOffset - index);
      Container(
        color: Colors.transparent,
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, .001)
            ..rotateY(angle),
          child: widget.slides[index],
        ),
      );
}
