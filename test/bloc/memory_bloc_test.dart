import 'dart:io';

import 'package:apk_my_memories/bloc/memory/memory_bloc.dart';
import 'package:apk_my_memories/bloc/memory/memory_event.dart';
import 'package:apk_my_memories/bloc/memory/memory_state.dart';
import 'package:apk_my_memories/models/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<Memory> box;
  late MemoryBloc memoryBloc;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_dir');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MemoryAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox<Memory>('test_memories_${DateTime.now().microsecondsSinceEpoch}');
    memoryBloc = MemoryBloc(box: box);
  });

  tearDown(() async {
    await memoryBloc.close();
    await box.clear();
    await box.close();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('initial state is MemoryInitial', () {
    expect(memoryBloc.state, isA<MemoryInitial>());
  });

  test('LoadMemories emits MemoryLoaded with box values', () async {
    memoryBloc.add(LoadMemories());
    await expectLater(
      memoryBloc.stream,
      emits(isA<MemoryLoaded>().having((s) => s.memories, 'memories', isEmpty)),
    );
  });

  test('AddMemory adds item to box and emits MemoryLoaded', () async {
    final memory = Memory(
      title: 'Liburan Pantai',
      description: 'Seru sekali di pantai',
      imagePath: '/path/to/image.jpg',
      createdAt: DateTime(2026, 8, 5),
    );

    memoryBloc.add(AddMemory(memory));

    await expectLater(
      memoryBloc.stream,
      emits(
        isA<MemoryLoaded>().having(
          (s) => s.memories.first.title,
          'title',
          'Liburan Pantai',
        ),
      ),
    );

    expect(box.length, equals(1));
    expect(box.getAt(0)?.title, equals('Liburan Pantai'));
  });

  test('UpdateDescription modifies description of existing memory', () async {
    final memory = Memory(
      title: 'Judul Lama',
      description: 'Deskripsi Lama',
      imagePath: '/path/image.jpg',
      createdAt: DateTime(2026, 8, 5),
    );

    await box.add(memory);
    memoryBloc.add(const UpdateDescription(0, 'Deskripsi Baru'));

    await expectLater(
      memoryBloc.stream,
      emits(
        isA<MemoryLoaded>().having(
          (s) => s.memories.first.description,
          'description',
          'Deskripsi Baru',
        ),
      ),
    );

    expect(box.getAt(0)?.description, equals('Deskripsi Baru'));
  });

  test('DeleteMemory removes item at index', () async {
    final memory = Memory(
      title: 'Hapus Saya',
      description: 'Akan dihapus',
      imagePath: '/path/image.jpg',
      createdAt: DateTime(2026, 8, 5),
    );

    await box.add(memory);
    expect(box.length, equals(1));

    memoryBloc.add(const DeleteMemory(0));

    await expectLater(
      memoryBloc.stream,
      emits(isA<MemoryLoaded>().having((s) => s.memories, 'memories', isEmpty)),
    );

    expect(box.length, equals(0));
  });
}
