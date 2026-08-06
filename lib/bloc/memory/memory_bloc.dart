import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/memory.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final Box<Memory>? _box;

  Box<Memory> get memoryBox =>
      _box ?? Hive.box<Memory>('memories');

  MemoryBloc({Box<Memory>? box})
      : _box = box,
        super(MemoryInitial()) {
    /// Load semua memory
    on<LoadMemories>((event, emit) {
      try {
        final memories = memoryBox.values.toList();
        emit(MemoryLoaded(memories));
      } on HiveError catch (e) {
        emit(MemoryError('Gagal memuat memory: ${e.message}'));
      }
    });

    /// Tambah memory
    on<AddMemory>((event, emit) async {
      try {
        await memoryBox.add(event.memory);
        emit(MemoryLoaded(memoryBox.values.toList()));
      } on HiveError catch (e) {
        emit(MemoryError('Gagal menyimpan memory: ${e.message}'));
      }
    });

    /// Hapus memory berdasarkan key
    on<DeleteMemory>((event, emit) async {
      try {
        final memory = memoryBox.get(event.key);
        await memoryBox.delete(event.key);

        // Hapus file gambar orphan (MEDIUM-003)
        if (memory != null) {
          try {
            final file = File(memory.imagePath);
            if (await file.exists()) {
              await file.delete();
            }
          } catch (_) {
            // Kegagalan hapus file tidak boleh menggagalkan penghapusan record
          }
        }

        emit(MemoryLoaded(memoryBox.values.toList()));
      } on HiveError catch (e) {
        emit(MemoryError('Gagal menghapus memory: ${e.message}'));
      }
    });

    /// Update deskripsi memory berdasarkan key
    on<UpdateDescription>((event, emit) async {
      try {
        final memory = memoryBox.get(event.key);
        if (memory != null) {
          await memoryBox.put(
            event.key,
            Memory(
              title: memory.title,
              description: event.description,
              imagePath: memory.imagePath,
              createdAt: memory.createdAt,
            ),
          );
        }
        emit(MemoryLoaded(memoryBox.values.toList()));
      } on HiveError catch (e) {
        emit(MemoryError('Gagal mengupdate deskripsi: ${e.message}'));
      }
    });
  }
}