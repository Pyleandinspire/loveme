import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:loveme/app.dart';
import 'package:loveme/core/services/storage_service.dart';

void main() {
  testWidgets('LoveMe app smoke test', (WidgetTester tester) async {
    // Create storage service
    final storage = StorageService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: storage,
        child: const MyApp(),
      ),
    );

    // Pump a few frames to let the widget build
    await tester.pump();

    // Verify that our app shows the welcome screen
    expect(find.text('LoveMe'), findsOneWidget);
    expect(find.text('开始恋爱'), findsOneWidget);
  });
}
