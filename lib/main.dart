import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget Presentation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'LongPressDraggable Widget Demo'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          LongPressDraggable<String>(
            data: "Hello World",
            feedback: Material(
              color: Colors.transparent,
              elevation: 8,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.orange.withValues(alpha: 0.7),
                child: const Text("Dragging..."),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: Container(width: 100, height: 100, color: Colors.blue),
            ),
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              child: const Text("Drag me!"),
            ),
          ),
          Container(width: 100, height: 100, color: Colors.green),
        ],
      ),
    );
  }
}
