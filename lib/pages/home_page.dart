import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../theme/app_colors.dart';
import 'add_memory_page.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text(
          "🌸 My Memories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),

    body: BlocBuilder<MemoryBloc, MemoryState>(
  builder: (context, state) {
    if (state is MemoryLoaded) {

      if (state.memories.isEmpty) {
        return const Center(
          child: Text("Belum ada memory"),
        );
      }

      return ListView.builder(
        itemCount: state.memories.length,
        itemBuilder: (context, index) {
          final memory = state.memories[index];
print(memory.imagePath);
          return ListTile(
  leading: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: Image.file(
      File(memory.imagePath),
      width: 60,
      height: 60,
      fit: BoxFit.cover,
    ),
  ),
  title: Text(memory.title),
  subtitle: Text(memory.description),
);
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  },
),      
 floatingActionButton: FloatingActionButton(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddMemoryPage(),
          ),
        );
      },
      child: const Icon(Icons.add),
    ),
  );
} 
  }