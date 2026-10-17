import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: RecipeScreen()),
  );
}

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<String> titles = [];
  String error = 'Loading recipes...';

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    try {
      final jsonString = await rootBundle.loadString('asset/recipes.json');

      final data = jsonDecode(jsonString);
      final List recipes = data['recipes'];

      setState(() {
        titles = recipes
            .map<String>((item) => item['title'].toString())
            .toList();
        error = '';
      });

      debugPrint('JSON SUCCESS: ${titles.length} recipes');
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      debugPrint('JSON ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe List'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: error.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            )
          : ListView.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.deepOrange,
                  ),
                  title: Text(titles[index]),
                );
              },
            ),
    );
  }
}
