import 'package:equatable/equatable.dart';

abstract class MemoryState extends Equatable{
  const MemoryState();

  @override
  List<Object?> get props => [];
}

class MemoryInitial extends MemoryState{}
class MemoryLoaded extends MemoryState{}