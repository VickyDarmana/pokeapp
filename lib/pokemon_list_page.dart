import 'package:flutter/material.dart';
import 'ShowCardsPage.dart';
import 'AddCardPage.dart';

class PokemonListPage extends StatelessWidget {
  const PokemonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon Cards"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to AddCardPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCardPage()),
                );
              },
              child: const Text("Add Card"),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to ShowCardsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShowCardsPage()),
                );
              },
              child: const Text("Show All Cards"),
            ),
          ],
        ),
      ),
    );
  }
}
