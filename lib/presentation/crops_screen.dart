import 'package:flutter/material.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text('Crops')),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          itemCount: 10, // Example count, replace with actual data length
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Crop ${index + 1}'),
                subtitle: Text('Details for crop ${index + 1}'),
                onTap: () {
                  // Handle tap on crop
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
