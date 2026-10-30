import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longpressdraggable/main.dart';

void main() {
  testWidgets('DragImageScreen builds a draggable image', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DragImageScreen()));

    expect(find.byType(LongPressDraggable<String>), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.pump();
    tester.takeException();
  });
}
