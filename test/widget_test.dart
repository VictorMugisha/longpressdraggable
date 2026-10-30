import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:longpressdraggable/main.dart';

void main() {
  testWidgets('DragPhotoScreen builds the draggable photo demo', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DragPhotoScreen()));

    expect(find.text('Drag the photo'), findsOneWidget);
    expect(find.byType(LongPressDraggable<String>), findsOneWidget);
    expect(find.byType(PhotoImage), findsOneWidget);
  });
}
