import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../theme/app_colors.dart';
import '../bloc/memory/memory_bloc.dart';
import '../bloc/memory/memory_event.dart';
import '../models/memory.dart';

class AddMemoryPage extends StatefulWidget {
  const AddMemoryPage({super.key});

  @override
  State<AddMemoryPage> createState() => _AddMemoryPageState();
}

class _AddMemoryPageState extends State<AddMemoryPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${timestamp}_${path.basename(image.path)}';

    final savedImage = await File(image.path).copy(
      '${appDir.path}/$fileName',
    );

    setState(() {
      selectedImage = savedImage;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tambah Memory",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                  ),
                  child: selectedImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Icon(
                        Icons.add_a_photo_outlined,
                        size: 55,
                        color: AppColors.primary,
                        ),
                            SizedBox(height: 12),
                            Text(
                          "Tap untuk memilih foto",
                          style: TextStyle(
                            color: AppColors.subtitle,
                          ),
                        )
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 55,
                                  color: AppColors.subtitle,
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 28),


              const Text(
                "Judul Memory",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "liburann",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                 borderSide: BorderSide(
                 color: AppColors.border,
               ),
             ),

                  enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(16),
                 borderSide: BorderSide(
                 color: AppColors.border,
                 ),
                  ),

                focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                color: AppColors.secondary,
                width: 2,
                ),
               ),
                  
                  ),
                ),
              

              const SizedBox(height: 20),


              const Text(
                "Cerita Hari Ini",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                hintText: "Tuliskan ceritamu...",
                hintStyle: TextStyle(
                  color: AppColors.subtitle,
                ),
                filled: true,
                fillColor: Colors.white,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.border,
                    width: 1.5,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.secondary,
                    width: 2,
                  ),
                ),
              ),
              ),
              const SizedBox(height: 30),


              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
  // Validasi foto
  if (selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Silakan pilih foto terlebih dahulu."),
      ),
    );
    return;
  }

  // Validasi judul
  if (titleController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Judul memory tidak boleh kosong."),
      ),
    );
    return;
  }

  // Validasi deskripsi
  if (descriptionController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Deskripsi memory tidak boleh kosong."),
      ),
    );
    return;
  }

  final memory = Memory(
    title: titleController.text.trim(),
    description: descriptionController.text.trim(),
    imagePath: selectedImage!.path,
    createdAt: DateTime.now(),
  );

  context.read<MemoryBloc>().add(
    AddMemory(memory),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Memory berhasil disimpan."),
    ),
  );

  Navigator.pop(context);
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Simpan Memory",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}