import 'package:flutter/material.dart';

const String imageUrl = 'https://tinyurl.com/4fjh44fx';

void main() => runApp(const MaterialApp(home: DragImageScreen()));

class DragImageScreen extends StatefulWidget {
  const DragImageScreen({super.key});

  @override
  State<DragImageScreen> createState() => _DragImageScreenState();
}

class _DragImageScreenState extends State<DragImageScreen> {
  double x = 100;
  double y = 200;

  Widget buildImage() {
    return Image.network(imageUrl, width: 150, height: 150, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Drag Image"),),
      body: Stack(
        children: [
          Positioned(
            left: x,
            top: y,
            child: LongPressDraggable<String>(
              data: 'image',
              feedback: Opacity(opacity: 0.7, child: buildImage()),
              childWhenDragging: Opacity(opacity: 0.3, child: buildImage()),
              onDragEnd: (details) {
                setState(() {
                  x = details.offset.dx;
                  y = details.offset.dy;
                });
              },
              child: buildImage(),
            ),
          ),
        ],
      ),
    );
  }
}
