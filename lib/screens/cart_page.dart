import 'package:flutter/material.dart';
import '../entities/cart_items.dart';
import '../entities/product.dart';
import 'home_dashboard.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  final String? pageTitle;
  const CartPage({Key? key, this.pageTitle}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isTipIncluded = false; // include 10% tip

  // total price
  double getTotalPrice() {
    double total = Cartitems.items.fold(0.0, (sum, item) => sum + item.totalPrice);
    if (isTipIncluded) {
      total += total * 0.1;
    }
    return total;
  }

  // removeItem
  void removeItem(int index) {
    setState(() {
      Cartitems.items.removeAt(index);
    });
  }

  // increment
  void incrementQuantity(int index) {
    setState(() {
      Cartitems.items[index].quantity++;
    });
  }

  // decrement
  void decrementQuantity(int index) {
    setState(() {
      if (Cartitems.items[index].quantity > 1) {
        Cartitems.items[index].quantity--;
      } else {
        removeItem(index);
      }
    });
  }

  // empty
  void clearCart() {
    setState(() {
      Cartitems.items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeDashboard()),
            );
          },
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Cartitems.items.isEmpty
              ? Expanded(
            child: Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: Cartitems.items.length,
              itemBuilder: (context, index) {
                final item = Cartitems.items[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),

                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: _getImageProvider(item.product.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${item.product.price.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: () => decrementQuantity(index),
                          ),
                          Text(
                            "${item.quantity}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                            onPressed: () => incrementQuantity(index),
                          ),
                          const SizedBox(width: 8),
                          // delete button
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => removeItem(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Includes a 10% default tip?:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: isTipIncluded,
                      onChanged: (bool newValue) {
                        setState(() {
                          isTipIncluded = newValue;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${getTotalPrice().toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // payment button
                ElevatedButton(
                  onPressed: () {
                    if (Cartitems.items.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment Successful!")),
                      );
                      clearCart();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Pay Now",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: clearCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Clear Cart",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
ImageProvider _getImageProvider(String imagePathOrBase64) {
  if (imagePathOrBase64.endsWith('.png') ||
      imagePathOrBase64.endsWith('.jpg') ||
      imagePathOrBase64.endsWith('.jpeg')) {
    return AssetImage(imagePathOrBase64);
  }

  try {
    final decodedBytes = base64Decode(imagePathOrBase64);
    return MemoryImage(decodedBytes);
  } catch (e) {
    return AssetImage('assets/placeholder_image.png');
  }
}
