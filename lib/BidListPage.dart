import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BidListPage extends StatefulWidget {
  const BidListPage({super.key});

  @override
  _BidListPageState createState() => _BidListPageState();
}

class _BidListPageState extends State<BidListPage> {
  List<Map<String, dynamic>> bids = [];
  String resultMessage = "";

  Future<void> fetchBids() async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/bids.php';
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

  Future<void> addBid(Map<String, dynamic> bidData) async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/bids.php';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bidData),
      );
      if (response.statusCode == 200) {
        setState(() {
          resultMessage = 'Bid added successfully';
          fetchBids(); // Refresh the list after adding
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

  Future<void> updateBid(int id, Map<String, dynamic> updatedData) async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/bids.php?id=$id';
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );
      if (response.statusCode == 200) {
        setState(() {
          resultMessage = 'Bid updated successfully';
          fetchBids(); // Refresh the list after update
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to update bid. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultMessage = 'Error: $e';
      });
    }
  }

  Future<void> deleteBid(int id) async {
    final String apiUrl = 'http://192.168.100.6/PokemonAPI/bids.php?id=$id';
    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          resultMessage = 'Bid deleted successfully';
          fetchBids(); // Refresh the list after deletion
        });
      } else {
        setState(() {
          resultMessage =
              'Failed to delete bid. Status code: ${response.statusCode}';
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
      body: Column(
        children: [
          Expanded(
            child: bids.isEmpty
                ? Center(
                    child: Text(resultMessage.isNotEmpty
                        ? resultMessage
                        : 'Loading...'))
                : ListView.builder(
                    itemCount: bids.length,
                    itemBuilder: (context, index) {
                      final bid = bids[index];
                      return ListTile(
                        title: Text('Bid Price: ${bid['bid_price']}'),
                        subtitle: Text('Status: ${bid['status']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // Show update dialog or navigate to edit page
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteBid(bid['id']),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              // Show dialog for adding a new bid
            },
            child: const Text("Add New Bid"),
          ),
        ],
      ),
    );
  }
}
