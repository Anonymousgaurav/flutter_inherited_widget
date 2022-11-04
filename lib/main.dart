import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      home: DateTimeProvider(
          api: Api(), child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueKey _textKey = const ValueKey<String>("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateTimeProvider.of(context)?.api.dateAndTime ?? ""),
      ),
      body: GestureDetector(
        onTap: () async {
          final api = DateTimeProvider.of(context)?.api;
          final dateTime = await api?._getDateAndTime();
          setState(() {
            _textKey = ValueKey(dateTime);
          });
        },
        child: Center(
          child: Container(
            child: DateTimeWidget(),
          ),
        ),
      ),
    );
  }
}

class Api {
  String? dateAndTime;

  Future<String> _getDateAndTime() {
    return Future.delayed(
            const Duration(seconds: 1), () => DateTime.now().toIso8601String())
        .then((value) {
      dateAndTime = value;
      return value;
    });
  }
}

class DateTimeProvider extends InheritedWidget {
  final Api api;
  final String uuid;

  DateTimeProvider({
    Key? key,
    required Widget child,
    required this.api,
  })  : uuid = const Uuid().v4(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DateTimeProvider? of(BuildContext context) {
    return context.findAncestorWidgetOfExactType();
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = DateTimeProvider.of(context)?.api;
    return Text(api?.dateAndTime ?? "Tap on screen to fetch date and time");
  }
}
