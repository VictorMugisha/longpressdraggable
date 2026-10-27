import 'package:flutter/material.dart';

const double kPhotoSize = 160;
const String kPhotoUrl = 'https://tinyurl.com/4fjh44fx';

void main() => runApp(const MaterialApp(home: DragPhotoScreen()));

// ---------- 1. The screen: owns the position and the feedback state ----------

class DragPhotoScreen extends StatefulWidget {
  const DragPhotoScreen({super.key});

  @override
  State<DragPhotoScreen> createState() => _DragPhotoScreenState();
}

class _DragPhotoScreenState extends State<DragPhotoScreen> {
  final GlobalKey _areaKey = GlobalKey();
  final ValueNotifier<Offset> _finger = ValueNotifier(Offset.zero);
  Offset _photoPos = const Offset(24, 24);

  @override
  void dispose() {
    _finger.dispose();
    super.dispose();
  }

  void _handleDragEnd(DraggableDetails details) {
    final box = _areaKey.currentContext!.findRenderObject()! as RenderBox;
    final local = box.globalToLocal(details.offset);
    final maxX = box.size.width - kPhotoSize;
    final maxY = box.size.height - kPhotoSize;
    setState(() {
      _photoPos = Offset(
        local.dx.clamp(0.0, maxX).toDouble(),
        local.dy.clamp(0.0, maxY).toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drag the photo')),
      body: Stack(
        key: _areaKey,
        children: [
          Positioned(
            left: _photoPos.dx,
            top: _photoPos.dy,
            child: LongPressDraggable<String>(
              data: 'photo',
              feedback: _PhotoFeedback(finger: _finger),
              childWhenDragging: const Opacity(
                opacity: 0.25,
                child: PhotoImage(),
              ),
              onDragUpdate: (d) => _finger.value = d.globalPosition,
              onDragEnd: _handleDragEnd,
              child: const PhotoImage(),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- 2. The image itself, reused by child, childWhenDragging, feedback ----------

class PhotoImage extends StatelessWidget {
  const PhotoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        kPhotoUrl,
        width: kPhotoSize,
        height: kPhotoSize,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            width: kPhotoSize,
            height: kPhotoSize,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stack) {
          debugPrint('Image failed: $error');
          return Container(
            width: kPhotoSize,
            height: kPhotoSize,
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, size: 48),
          );
        },
      ),
    );
  }
}

// ---------- 3. The feedback: its own widget, its own state ----------

class _PhotoFeedback extends StatelessWidget {
  const _PhotoFeedback({required this.finger});

  final ValueNotifier<Offset> finger;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: kPhotoSize,
        height: kPhotoSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                const PhotoImage(),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ValueListenableBuilder<Offset>(
                    valueListenable: finger,
                    builder: (context, pos, _) => Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      alignment: Alignment.center,
                      child: Text(
                        'x ${pos.dx.round()}   y ${pos.dy.round()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
