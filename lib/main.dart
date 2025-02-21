import 'package:flutter/material.dart';
import './screens/home_dashboard.dart';
import 'screens/cart_page.dart';
import './screens/product_page.dart';
import './screens/add_item_page.dart';



void main() {
  runApp(const MyApp());
} // Returns the MaterialApp

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeDashboard(),
      //home: ProductPage(),
      //home:AddItemPage(),
    );
  }

}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Home'),
    ),
    body: Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
        child: const Text('Go to Cart'),
      ),
    ),
  );
}
