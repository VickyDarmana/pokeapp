import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String hasilResponse = "";
  bool isLoading = false; // Flag to manage loading state

  Future<void> registerUser() async {
    final String apiUrl =
        'http://192.168.100.4/PokemonAPI/profiles.php'; // Update with your IP address if needed

    if (emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> userData = {
      'email': emailController.text,
      'name': nameController.text,
      'password': passwordController.text,
    };

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json"},
            body: json.encode(userData),
          )
          .timeout(const Duration(seconds: 10)); // Timeout for 10 seconds

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("Response from server: ${response.body}");

        setState(() {
          hasilResponse =
              "Response: ${jsonResponse['status'] == 200 ? 'User Registered' : jsonResponse['message']}";
        });

        if (jsonResponse['status'] == 200) {
          // Registration successful, navigate to the home page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Registration failed, show error message from the response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${jsonResponse['message']}')),
          );
        }
      } else {
        // Server returned an error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to register user. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle network or JSON parsing errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      // Hide loading indicator
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    await registerUser();
                  },
            child: isLoading
                ? const CircularProgressIndicator() // Show loading spinner
                : const Text('Register'),
          ),
          const SizedBox(height: 20),
          Text(hasilResponse),
        ],
      ),
    );
  }
}
