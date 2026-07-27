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