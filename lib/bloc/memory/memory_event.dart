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
class DeleteMemory extends MemoryEvent {
  final int index;

  const DeleteMemory(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateDescription extends MemoryEvent {
  final int index;
  final String description;

  const UpdateDescription(this.index, this.description);

  @override
  List<Object?> get props => [
        index,
        description,
      ];
}