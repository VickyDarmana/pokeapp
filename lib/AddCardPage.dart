import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rarityController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  String resultMessage = "";

  Future<void> addPokemonCard() async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/cards.php';

    Map<String, dynamic> cardData = {
      'name': nameController.text,
      'type': typeController.text,
      'rarity': rarityController.text,
      'image_url': imageUrlController.text,
      'description': descriptionController.text,
      'price': double.tryParse(priceController.text) ?? 0.0,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(cardData),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          resultMessage = jsonResponse['status'] == 200
              ? 'Card Added Successfully'
              : jsonResponse['message'];
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to add card. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Pokémon Card")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Card Name'),
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
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addPokemonCard,
              child: const Text('Add Card'),
            ),
            const SizedBox(height: 16.0),
            if (resultMessage.isNotEmpty)
              Text(resultMessage, style: const TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
