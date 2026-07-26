import 'package:flutter_bloc/flutter_bloc.dart';
import 'memory_event.dart';
import 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState>{
  MemoryBloc() :super(MemoryInitial()){

    on<LoadMemories>((event, emit) {

    });
    on<AddMemory>((event,emit){

    });
  }
}