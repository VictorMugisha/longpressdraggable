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
  String dropped = "nothing yet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('last drop: $dropped'),
          DragTarget<String>(
            onWillAcceptWithDetails: (details) {
              debugPrint('TARGET willAccept  data=${details.data}');
              return true;
            },
            onAcceptWithDetails: (details) {
              debugPrint(
                'TARGET accept      data=${details.data}  '
                'offset=${details.offset}',
              );
              setState(() => dropped = details.data);
            },
            onLeave: (data) => debugPrint('TARGET leave       data=$data'),
            builder: (context, candidate, rejected) {
              return Container(
                width: 200,
                height: 200,
                alignment: Alignment.center,
                color: candidate.isNotEmpty
                    ? Colors.green
                    : rejected.isNotEmpty
                    ? Colors.red
                    : Colors.grey,
                child: Text(
                  'candidate=${candidate.length}  rejected=${rejected.length}',
                ),
              );
            },
          ),
          LongPressDraggable<String>(
            data: 'hello',
            feedback: Container(
              width: 100,
              height: 100,
              color: Colors.orange.withValues(alpha: 0.7),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: Container(width: 100, height: 100, color: Colors.blue),
            ),
            onDragStarted: () => debugPrint('DRAGGABLE started'),
            onDraggableCanceled: (v, o) => debugPrint('DRAGGABLE canceled'),
            onDragCompleted: () => debugPrint('DRAGGABLE completed'),
            onDragEnd: (d) =>
                debugPrint('DRAGGABLE end       accepted=${d.wasAccepted}'),
            child: Container(width: 100, height: 100, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
