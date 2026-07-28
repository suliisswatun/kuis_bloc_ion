import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/memory.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final Box<Memory> memoryBox = Hive.box<Memory>('memories');

  MemoryBloc() : super(MemoryInitial()) {

    on<LoadMemories>((event, emit) {
      final memories = memoryBox.values.toList();

      emit(
        MemoryLoaded(memories),
      );
    });

    on<AddMemory>((event, emit) async {
      print("bloc menerima addmemory");

      await memoryBox.add(event.memory);

print("===== DATA HIVE =====");

for (int i = 0; i < memoryBox.length; i++) {
  final memory = memoryBox.getAt(i);

  print("Memory ${i + 1}");
  print("Title      : ${memory?.title}");
  print("Description: ${memory?.description}");
  print("Image Path : ${memory?.imagePath}");
  print("Created At : ${memory?.createdAt}");
  print("----------------------------");
}
      print("data berhasil disimpan");

      final memories = memoryBox.values.toList();

      emit(
        MemoryLoaded(memories),
      );
    });
  }
}