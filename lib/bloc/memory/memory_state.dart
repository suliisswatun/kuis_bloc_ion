import 'package:equatable/equatable.dart';

import '../../models/memory.dart';

abstract class MemoryState extends Equatable {
  const MemoryState();

  @override
  List<Object?> get props => [];
}

/// State awal ketika aplikasi pertama kali dibuka
class MemoryInitial extends MemoryState {}

/// State ketika daftar memory berhasil dimuat
class MemoryLoaded extends MemoryState {
  final List<Memory> memories;

  const MemoryLoaded(this.memories);

  @override
  List<Object?> get props => [memories];
}

/// State ketika terjadi error pada operasi Hive
class MemoryError extends MemoryState {
  final String message;

  const MemoryError(this.message);

  @override
  List<Object?> get props => [message];
}