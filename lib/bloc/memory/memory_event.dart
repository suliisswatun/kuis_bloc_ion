import 'package:equatable/equatable.dart';

abstract class MemoryEvent extends Equatable{
  const MemoryEvent();

  @override
  List<Object?> get props => [];

}

class LoadMemories extends MemoryEvent{}

class AddMemory extends MemoryEvent {}