import "package:flutter/material.dart";

void main() => runApp(const MyApp());

class _InheritedScaffold extends InheritedWidget {
  const _InheritedScaffold({
    required this.data,
    required super.child,
  });

  final MyState data;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  static MyState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedScaffold>()!
        .data;
  }

  @override
  State<MyStatefulWidget> createState() => MyState();
}

class MyState extends State<MyStatefulWidget> {
  String url = "https://source.unsplash.com/random";

  void changeURL() => setState(() {
        url = "https://source.unsplash.com/random";
      });

  @override
  Widget build(BuildContext context) {
    return _InheritedScaffold(
      data: this,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyStatefulWidget(
      child: MaterialApp(
        title: "Random Image",
        home: MyScaffold(),
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: const Text(
          "Random Image",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Image.network(
          MyStatefulWidget.of(context).url,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.refresh),
        tooltip: "refresh image",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
