import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowCardsPage extends StatefulWidget {
  const ShowCardsPage({super.key});

  @override
  _ShowCardsPageState createState() => _ShowCardsPageState();
}

class _ShowCardsPageState extends State<ShowCardsPage> {
  List<Map<String, dynamic>> pokemonCards = [];
  String resultMessage = "";

  Future<void> fetchPokemonCards() async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/cards.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          pokemonCards = List<Map<String, dynamic>>.from(jsonResponse['data']);
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to load cards. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
      });
    }
  }

  Future<void> deleteCard(int id) async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/cards.php?id=$id';
    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          resultMessage = 'Card deleted successfully';
          fetchPokemonCards(); // Refresh the list after deletion
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to delete card. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
      });
    }
  }

  Future<void> updateCard(int id, Map<String, dynamic> updatedData) async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/cards.php?id=$id';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );
      if (response.statusCode == 200) {
        setState(() {
          resultMessage = 'Card updated successfully';
          fetchPokemonCards(); // Refresh the list after update
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to update card. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
      });
    }
  }

  void showUpdateDialog(Map<String, dynamic> card) {
    final nameController = TextEditingController(text: card['name']);
    final typeController = TextEditingController(text: card['type']);
    final rarityController = TextEditingController(text: card['rarity']);
    final priceController =
        TextEditingController(text: card['price'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: rarityController,
              decoration: const InputDecoration(labelText: 'Rarity'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedData = {
                'name': nameController.text,
                'type': typeController.text,
                'rarity': rarityController.text,
                'price': double.tryParse(priceController.text) ?? 0.0,
              };
              updateCard(int.parse(card['id']), updatedData);
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Pokémon Cards")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pokemonCards.isEmpty
            ? Center(
                child: Text(
                  resultMessage.isNotEmpty ? resultMessage : 'Loading...',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : ListView.builder(
                itemCount: pokemonCards.length,
                itemBuilder: (context, index) {
                  final card = pokemonCards[index];
                  return ListTile(
                    leading: card['image_url'] != null
                        ? Image.network(card['image_url'],
                            width: 50, height: 50)
                        : const Icon(Icons.image),
                    title: Text(card['name']),
                    subtitle: Text(
                        'Type: ${card['type']}, Rarity: ${card['rarity']}, Price: ${card['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showUpdateDialog(card),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteCard(int.parse(card['id'])),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
