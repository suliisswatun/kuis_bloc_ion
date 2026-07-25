import 'package:flutter/material.dart';
import'package:hive_flutter/hive_flutter.dart';
import'models/memory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(MemoryAdapter());
  await Hive.openBox<Memory>('memories');
  final memoryBox = Hive.box<Memory>('memories');

await memoryBox.add(
  Memory(
    title: 'Belajarrr Hive',
    description: 'testing penyimpanan',
    imagePath: '',
    createdAt: DateTime.now(),
  )
);
print(memoryBox.length);
final firstMemory = memoryBox.getAt(0);
print(firstMemory?.title);
print(firstMemory?.description);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Memories',
      home: const Scaffold(
        body: Center(
          child: Text(
            'My Memories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}