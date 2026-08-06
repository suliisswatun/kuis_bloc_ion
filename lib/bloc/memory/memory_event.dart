import 'package:equatable/equatable.dart';

import '../../models/memory.dart';

abstract class MemoryEvent extends Equatable {
  const MemoryEvent();

  @override
  List<Object?> get props => [];
}

/// Memuat seluruh data memory dari Hive
class LoadMemories extends MemoryEvent {}

/// Menambahkan memory baru
class AddMemory extends MemoryEvent {
  final Memory memory;

  const AddMemory(this.memory);

  @override
  List<Object?> get props => [memory];
}

/// Menghapus memory berdasarkan key Hive
class DeleteMemory extends MemoryEvent {
  final dynamic key;

  const DeleteMemory(this.key);

  @override
  List<Object?> get props => [key];
}

/// Mengupdate deskripsi memory berdasarkan key Hive
class UpdateDescription extends MemoryEvent {
  final dynamic key;
  final String description;

  const UpdateDescription(this.key, this.description);

  @override
  List<Object?> get props => [key, description];
}