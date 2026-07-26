import 'package:flutter/material.dart';

import 'add_memory_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Memories"),
        centerTitle: true,
      ),

      body: const Center(
        child: Text(
          "Belum ada memory",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

      
}