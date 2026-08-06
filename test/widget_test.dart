import 'dart:io';

import 'package:apk_my_memories/bloc/memory/memory_bloc.dart';
import 'package:apk_my_memories/bloc/memory/memory_event.dart';
import 'package:apk_my_memories/models/memory.dart';
import 'package:apk_my_memories/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<Memory> box;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('widget_test_dir');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MemoryAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox<Memory>('widget_test_box_${DateTime.now().microsecondsSinceEpoch}');
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('HomePage displays title and empty state text', (WidgetTester tester) async {
    final memoryBloc = MemoryBloc(box: box)..add(LoadMemories());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: memoryBloc,
          child: const HomePage(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.text('🌸 My Memories'), findsOneWidget);
    expect(find.text('Belum ada memory'), findsOneWidget);

    await memoryBloc.close();
  });
}
