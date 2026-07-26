import 'package:flutter/material.dart';

class AddMemoryPage extends StatelessWidget {
  const AddMemoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Memory"),
        centerTitle: true,
      ),

      body: const Center(
        child: Text(
          "Form Tambah Memory",
        ),
      ),
    );
  }
}