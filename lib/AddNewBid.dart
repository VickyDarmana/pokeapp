import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBidPage extends StatefulWidget {
  const AddBidPage({super.key});

  @override
  _AddBidPageState createState() => _AddBidPageState();
}

class _AddBidPageState extends State<AddBidPage> {
  final TextEditingController cardIdController = TextEditingController();
  final TextEditingController profileIdController = TextEditingController();
  final TextEditingController bidPriceController = TextEditingController();
  String status = 'open'; // Default value for status
  String resultMessage = "";

  Future<void> addBid() async {
    final String apiUrl =
        'http://192.168.100.4/PokemonAPI/bids.php'; // Replace with actual API URL

    Map<String, dynamic> bidData = {
      'card_id': int.tryParse(cardIdController.text) ?? 0,
      'profile_id': int.tryParse(profileIdController.text) ?? 0,
      'bid_price': double.tryParse(bidPriceController.text) ?? 0.0,
      'status': status,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(bidData),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          resultMessage = jsonResponse['status'] == 200
              ? 'Bid Added Successfully'
              : jsonResponse['message'];
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to add bid. Status code: ${response.statusCode}';
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
      appBar: AppBar(title: const Text("Add New Bid")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: cardIdController,
              decoration: const InputDecoration(labelText: 'Card ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: profileIdController,
              decoration: const InputDecoration(labelText: 'Profile ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: bidPriceController,
              decoration: const InputDecoration(labelText: 'Bid Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: status,
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'open', child: Text("Open")),
                DropdownMenuItem(value: 'next bid', child: Text("Next Bid")),
                DropdownMenuItem(
                    value: 'buy it now', child: Text("Buy It Now")),
              ],
              decoration: const InputDecoration(labelText: "Status"),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addBid,
              child: const Text('Add Bid'),
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
