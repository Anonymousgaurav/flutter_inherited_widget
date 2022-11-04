import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: GestureDetector(
        onTap: () async {},
        child: AvailableColorsWidget(
          color1: color1,
          color2: color2,
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          color1 = allColors.getRandomElement();
                        });
                      },
                      child: const Text("change color 1")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          color2 = allColors.getRandomElement();
                        });
                      },
                      child: const Text("change color 2")),
                ],
              ),
              const ColorWidget(colors: AvailableColors.one),
              const ColorWidget(colors: AvailableColors.two)
            ],
          ),
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

final allColors = [
  Colors.blue,
  Colors.red,
  Colors.yellow,
  Colors.orange,
  Colors.cyan,
  Colors.purple,
  Colors.brown,
  Colors.amber,
  Colors.green
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget({
    Key? key,
    required Widget child,
    required this.color1,
    required this.color2,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    /// if it returns true inherited model will rebuild the widget but if it returns false then flutter will say
    /// nothing changed and widget will not rebuilt
    debugPrint("update should notify");
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  /// it says what is going to change in our data
  /// it comes in updateShouldNotifyDependent after updateShouldNotify returns true
  @override
  bool updateShouldNotifyDependent(
    covariant AvailableColorsWidget oldWidget,
    Set<AvailableColors> dependencies,
  ) {
    debugPrint("updateShouldNotifyDependent");
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }

    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }

    return false;
  }

  static AvailableColorsWidget? of(
      BuildContext context, AvailableColors aspect) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(
      context,
      aspect: aspect,
    );
  }
}

class ColorWidget extends StatelessWidget {
  final AvailableColors colors;

  const ColorWidget({
    Key? key,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (colors) {
      case AvailableColors.one:
        debugPrint("Color1 widget got rebuilt");
        break;
      case AvailableColors.two:
        debugPrint("Color2 widget got rebuilt");
        break;
    }
    final provider = AvailableColorsWidget.of(context, colors);
    return Container(
      height: 100,
      color:
          colors == AvailableColors.one ? provider?.color1 : provider?.color2,
    );
  }
}
