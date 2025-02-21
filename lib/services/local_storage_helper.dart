import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../entities/product.dart';

class LocalStorageHelper {
  // save data to local storage
  static Future<void> saveProductsToLocalStorage(String key, List<Product> products) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get product list
    List<String>? productList = prefs.getStringList(key);
    List<Product> existingProducts = [];

    if (productList != null) {
      existingProducts = productList
          .map((product) => Product.fromJson(jsonDecode(product)))
          .toList();
    }

    int categoryOffset = 0;
    if (key == 'hamburgers') {
      categoryOffset = 1000;
    } else if (key == 'pizzas') {
      categoryOffset = 2000;
    } else if (key == 'salads') {
      categoryOffset = 3000;
    }

    int maxId = existingProducts.isEmpty
        ? categoryOffset
        : existingProducts.map((e) => e.id).reduce((a, b) => a > b ? a : b);

    for (var product in products) {
      product.id = maxId + 1;
      maxId++;
    }

    existingProducts.addAll(products);

    List<String> updatedProductList = existingProducts
        .map((product) => jsonEncode(product.toJson()))
        .toList();
    await prefs.setStringList(key, updatedProductList);
  }

  static Future<List<Product>> loadProductsFromLocalStorage(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productList = prefs.getStringList(key);
    if (productList != null) {
      return productList.map((product) {
        var productData = jsonDecode(product);

        if (productData['image'] != null) {
          if (productData['image']!.startsWith('data:image')) {
            productData['image'] = base64Decode(productData['image'].split(',')[1]);
          } else {
          }
        }

        return Product.fromJson(productData);
      }).toList();
    } else {
      return [];
    }
  }

  static Future<void> initializeDefaultHamburgers() async {
    List<Product> defaultHamburgers = [
      Product(
        id: 1000,
        name: "Chicken Burger",
        image: "images/chickenburger.png",
        price: 25,
        description: "A juicy grilled chicken burger with fresh vegetables.",
        isHamburger: true,
        isRecommended: true,
      ),
      Product(
        id: 1001,
        name: "Cheese Burger",
        image: "images/Cheeseburger.png",
        price: 15,
        description: "A classic cheeseburger with a melted cheddar topping.",
        isHamburger: true,
      ),
      Product(
        id: 1002,
        name: "Extra Long Burger",
        image: 'images/extralongburger.png',
        price: 10.99,
        description: "A delicious extra-long burger with crispy lettuce.",
        isHamburger: true,
      ),
      Product(
        id: 1003,
        name: "Veggie Burger",
        image: "images/veggieburger.png",
        price: 50.00,
        description: "A delicious extra-long burger with crispy lettuce.",
        isHamburger: true,
      ),
    ];
    await saveProductsToLocalStorage('hamburgers', defaultHamburgers);
  }
  static Future<void> initializeDefaultPizzas() async {
    List<Product> defaultPizzas = [
      Product(
        id: 2000,
        name: "Hawaii Pizza",
        image: "images/Hawaiianpizza.jpg",
        price: 18,
        description: "Nice Pizza.",
        isHamburger: null,
        isRecommended: true,
      ),
      // Product(
      //   id: 2001,
      //   name: "pepperoni pizza",
      //   image: "images/Peperonipizza.jpeg",
      //   price: 10,
      //   description: "pizza with pepperoni meat.",
      //   isHamburger: null,
      // ),
      // Product(
      //   id: 2002,
      //   name: "roast chicken pizza",
      //   image: 'images/Roastchickenpizza.jpeg',
      //   price: 12,
      //   description: "pizza with roast chicken and mushroom.",
      //   isHamburger: null,
      // ),
      // Product(
      //   id: 2003,
      //   name: "Veggie Pizza",
      //   image: "images/Veggiepizza.jpeg",
      //   price: 8.00,
      //   description: "A pizza with many kinds of vegetable.",
      //   isHamburger: null,
      // ),
    ];
    await saveProductsToLocalStorage('pizzas', defaultPizzas);
  }
  static Future<void> initializeDefaultSalads() async {
    List<Product> defaultSalads = [
      Product(
        id: 3000,
        name: "Beef Salad",
        image: "images/beefSalad.png",
        price: 45.12,
        description: "A flavorful beef salad with a tangy vinaigrette dressing.",
        isHamburger: null,
      ),
      Product(
        id: 3001,
        name: "Caesar Salad",
        image: "images/caesarSalad.png",
        price: 25.12,
        description: "A classic Caesar salad with crunchy croutons and parmesan.",
        isHamburger: null,
      ),
      Product(
        id: 3002,
        name: "Chicken Salad",
        image: "images/chickenSalad.png",
        price: 15,
        description: "A hearty chicken salad with fresh greens and creamy dressing.",
        isHamburger: null,
      ),
    ];
    await saveProductsToLocalStorage('salads', defaultSalads);
  }





}
