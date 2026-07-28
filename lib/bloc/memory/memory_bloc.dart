import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/memory.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final Box<Memory> memoryBox = Hive.box<Memory>('memories');

  MemoryBloc() : super(MemoryInitial()) {
    /// Load semua memory
    on<LoadMemories>((event, emit) {
      emit(
        MemoryLoaded(
          memoryBox.values.toList(),
        ),
      );
    });

    /// Tambah memory
    on<AddMemory>((event, emit) async {
      print("Bloc menerima AddMemory");

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

      emit(
        MemoryLoaded(
          memoryBox.values.toList(),
        ),
      );
    });

    /// Hapus memory
    on<DeleteMemory>((event, emit) async {
      print("Delete diterima Bloc: ${event.index}");

      await memoryBox.deleteAt(event.index);

      emit(
        MemoryLoaded(
          memoryBox.values.toList(),
        ),
      );
    });
  }
}