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
        home: const HomePage());
  }
}

final sliderData = SliderData();

class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    required Widget child,
    required SliderData sliderData,
    Key? key,
  }) : super(
          notifier: sliderData,
          child: child,
          key: key,
        );

  /// to get the data from sliderData class and notifies the listeners
  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My HomePage"),
      ),
      body: SliderInheritedNotifier(
          sliderData: sliderData,
          child: Builder(builder: (context) {
            return Column(
              children: [
                Slider(
                  value: SliderInheritedNotifier.of(context),
                  onChanged: (value) {
                    sliderData.newValue = value;
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200.0,
                        width: 100.0,
                        color: Colors.yellow,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200.0,
                        width: 100.0,
                        color: Colors.red,
                      ),
                    )
                  ].equallyExpaned().toList(),
                ),
              ],
            );
          })),
    );
  }
}

extension ExpandEqually on Iterable<Widget> {
  Iterable<Widget> equallyExpaned() => map((widget) => Expanded(child: widget));
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;

  double get value => _value;

  set newValue(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}
