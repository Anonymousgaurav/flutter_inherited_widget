import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreadCrumbProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {'/new': (context) => const NewBreadCrumbWidget()},
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Column(
        children: [
          Consumer<BreadCrumbProvider>(builder: (context, value, child) {
            return BreadCrumbsWidget(breadCrumbs: value.items);
          }),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/new");
            },
            child: const Text("Add new bread crump"),
          ),
          TextButton(
            onPressed: () {
              /// on press we have to communicate with provider
              /// read when we want to communicate with provider. Like we want to tell provider, Hey Provider Do this
              /// use read when you are going to do one way communication generallly on Tap
              context.read<BreadCrumbProvider>().reset();
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}

class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  const BreadCrumbsWidget({required this.breadCrumbs, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map(
        (crumps) {
          return Text(
            crumps.title,
            style:
                TextStyle(color: crumps.isActive ? Colors.blue : Colors.black),
          );
        },
      ).toList(),
    );
  }
}

class BreadCrumb {
  bool isActive;
  final String name;
  final String uuid;

  BreadCrumb({required this.isActive, required this.name})
      : uuid = const Uuid().v4();

  void activate() {
    isActive = true;
  }

  /// This operator is useful when you need to compare actual values of two objects/classses,
  /// because flutter by default Compares instances of objects and that case two objects will never be same even
  /// their actual values are same
  @override
  bool operator ==(covariant BreadCrumb other) => uuid == other.uuid;

  /// if we override the equality operator (==) in our subclass, we SHOULD override the hashCode method too.
  /// hash-based collection, both equality operator (==) and hashCode are used when doing the comparison.
  @override
  int get hashCode => uuid.hashCode;

  String get title => name + (isActive ? ">" : "");
}

class BreadCrumbProvider extends ChangeNotifier {
  final List<BreadCrumb> _items = [];

  ///  It creates a copy of the original List, and that copy cannot be mutated. Mutating the original List will not affect the copy.
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  void add(BreadCrumb crumb) {
    for (final item in _items) {
      item.activate();
    }
    _items.add(crumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({Key? key}) : super(key: key);

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new BreadCrumb"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
                hintText: "Enter new Bread Crumb Here....."),
          ),
          TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  final breadCrumb =
                      BreadCrumb(isActive: false, name: _controller.text);
                  context.read<BreadCrumbProvider>().add(breadCrumb);
                  Navigator.of(context).pop(context);
                }
              },
              child: const Text("Add New..."))
        ],
      ),
    );
  }
}
