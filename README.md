Simple Animated Introduction Screen for Flutter

## Features

Add this to your flutter app to get a simple animated introduction screen.

<img src="assets/example_gif.gif" width="270" alt="example">


## Getting started

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  animated_introduction: ^latest_version
```

## Usage

#### Import the package

```dart
import 'package:animated_introduction/animated_introduction.dart';
```

#### Create a list of `SingleIntroScreen` objects

```dart
final List<SingleIntroScreen> slides = [
  const SingleIntroScreen(
    title: 'Welcome to the Event Management App !',
    description: 'You plans your Events, We\'ll do the rest and will be the best! Guaranteed!  ',
    imageAsset: 'assets/onboard_one.png',
  ),
  const SingleIntroScreen(
    title: 'Book tickets to cricket matches and events',
    description: 'Tickets to the latest movies, crickets matches, concerts, comedy shows, plus lots more !',
    imageAsset: 'assets/onboard_two.png',
  ),
  const SingleIntroScreen(
    title: 'Grabs all events now only in your hands',
    description: 'All events are now in your hands, just a click away ! ',
    imageAsset: 'assets/onboard_three.png',
  ),
];
```

#### Pass the list to `AnimatedIntroduction` widget

```dart
AnimatedIntroduction(
    slides: slides,
    // indicatorType: IndicatorType.circle,
    onDone: () {
    /// TODO: Go to desire page like login or home
    },
),
```





