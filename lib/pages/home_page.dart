import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import '../theme/app_colors.dart';
import 'add_memory_page.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_state.dart';
import '../bloc/memory/memory_event.dart';

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
          return GestureDetector(
  onTap: () {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [

  ListTile(
    leading: const Icon(Icons.edit),
    title: const Text("Edit Deskripsi"),
    onTap: () {
      Navigator.pop(context);

      final controller = TextEditingController(
        text: memory.description,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Edit Deskripsi"),
          content: TextField(
            controller: controller,
            maxLines: 5,
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () {

                context.read<MemoryBloc>().add(
                  UpdateDescription(
                    index,
                    controller.text.trim(),
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),

          ],
        ),
      );
    },
  ),
          ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text("Hapus Memory"),
               onTap: () {
              print("Klik delete index: $index");

                  context.read<MemoryBloc>().add(
                    DeleteMemory(index),
                  );

                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Batal"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        );
      },
    );
  },

  child: Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: InteractiveViewer(
                  child: Image.file(
                    File(memory.imagePath),
                  ),
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(memory.imagePath),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                memory.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
  memory.description,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    color: Colors.grey.shade700,
  ),
),

Align(
  alignment: Alignment.centerLeft,
  child: TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(memory.title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(File(memory.imagePath)),
                const SizedBox(height: 12),
                Text(memory.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        ),
      );
    },
    child: const Text("Baca Selengkapnya"),
  ),
),

Text(
  "${memory.createdAt.day}/${memory.createdAt.month}/${memory.createdAt.year}",
  style: const TextStyle(
    fontSize: 12,
    color: Colors.grey,
  ),
),
            ],
          ),
        ),

      ],
    ),
  ),
),
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
              


