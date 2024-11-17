import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShowBidsPage extends StatefulWidget {
  const ShowBidsPage({super.key});

  @override
  _ShowBidsPageState createState() => _ShowBidsPageState();
}

class _ShowBidsPageState extends State<ShowBidsPage> {
  List<Map<String, dynamic>> bids = [];
  String resultMessage = "";

  Future<void> fetchBids() async {
    final String apiUrl =
        'http://192.168.100.4/PokemonAPI/bids.php'; // Replace with actual API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          bids = List<Map<String, dynamic>>.from(jsonResponse['data']);
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to load bids. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Bids")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: bids.isEmpty
            ? Center(
                child: Text(
                  resultMessage.isNotEmpty ? resultMessage : 'Loading...',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : ListView.builder(
                itemCount: bids.length,
                itemBuilder: (context, index) {
                  final bid = bids[index];
                  return ListTile(
                    title: Text('Bid Price: ${bid['bid_price']}'),
                    subtitle: Text('Status: ${bid['status']}'),
                  );
                },
              ),
      ),
    );
  }
}
