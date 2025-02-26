import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _allShops = [
    {"id": 1, "name": "Magnum"},
    {"id": 2, "name": "Galmart"},
    {"id": 3, "name": "Fermag"},
    {"id": 4, "name": "KFC"},
    {"id": 5, "name": "Mcdonalds"},
    {"id": 6, "name": "Dodo Pizza"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH"),
      ),
      body: ListView.builder(
        itemCount: _allShops.length,
        itemBuilder: (context, index) => Card(
          key: ValueKey(_allShops[index]["id"]),
          color: Colors.green,
          elevation: 4,
        ),
      ),
    );
  }
}
