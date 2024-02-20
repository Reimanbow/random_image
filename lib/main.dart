import "dart:typed_data";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

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
  late Future<Uint8List> url;

  Future<Uint8List> getURL() async {
    final response =
        await http.get(Uri.parse("https://source.unsplash.com/random"));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Error");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    url = getURL();
  }

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
        child: FutureBuilder(
            future: MyStatefulWidget.of(context).url,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(snapshot.data!);
              } else if (snapshot.hasError) {
                return const Text("Error");
              }
              return const CircularProgressIndicator();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //MyStatefulWidget.of(context).changeURL();
        },
        child: const Icon(Icons.refresh),
        tooltip: "refresh image",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
