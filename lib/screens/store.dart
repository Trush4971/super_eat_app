import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../services/api'
    '_service.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart'; // ApiService


class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  // final List<Map<String, dynamic>> stores = [
  //   {"address": "202 Lester St.", "city": "Waterloo", "name": "Super Burger", "selected": false},
  //   {"address": "308 King St.", "city": "Waterloo", "name": "Super Burger", "selected": false},
  //   {"address": "300 University St.", "city": "Waterloo", "name": "Super Burger", "selected": false},
  //   {"address": "556 Victoria St.", "city": "Kitchener", "name": "Super Burger", "selected": true},
  // ];
  final List<Map<String, dynamic>> stores = [];

  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService(); //  ApiService
  List<dynamic> _searchResults = [];
  bool _isLoading = false; //

  // use ApiService search method
  Future<void> _searchStores(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _apiService.searchStores(query); // use new API method
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final isSearching = _searchController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stores & location',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // search bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search location",
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  setState(() {
                    _searchResults = [];
                  });
                } else {
                  _searchStores(value);
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: isSearching
                  ? _searchResults.length // show API data
                  : stores.length, // show local data
              itemBuilder: (context, index) {
                if (isSearching) {
                  final store = _searchResults[index];
                  return _buildApiStoreTile(store);
                } else {
                  final store = stores[index];
                  return _buildLocalStoreTile(store);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApiStoreTile(Map<String, dynamic> store) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store['display_name'] ?? 'Unknown Location',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  if (store['address'] != null)
                    Text(
                      store['address']['road'] ?? 'Unknown Address',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalStoreTile(Map<String, dynamic> store) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${store['address']}, ${store['city']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  store['name'],
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            Checkbox(
              value: store['selected'],
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  store['selected'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
