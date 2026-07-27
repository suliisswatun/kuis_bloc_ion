import 'package:flutter/material.dart';
import'package:hive_flutter/hive_flutter.dart';
import'package:flutter_bloc/flutter_bloc.dart';

import'bloc/memory/memory_bloc.dart';
import'models/memory.dart';
import'pages/home_page.dart';
import 'bloc/memory/memory_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MemoryAdapter());
  await Hive.openBox<Memory>('memories');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => MemoryBloc()..add(LoadMemories()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Memories',
       home: const HomePage(),
          
        ),
    );
  }
}