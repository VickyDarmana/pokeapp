import 'package:flutter/material.dart';
import 'package:pokeapp/AddNewBid.dart';
import 'package:pokeapp/ShowAllbid.dart';

class BidListPage extends StatelessWidget {
  const BidListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bids"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBidPage()),
                );
              },
              child: const Text("Add New Bid"),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShowBidsPage()),
                );
              },
              child: const Text("Show All Bids"),
            ),
          ],
        ),
      ),
    );
  }
}
