import 'package:flutter/material.dart';
import '../entities/product.dart';
import '../shared/colors.dart';
import '../shared/styles.dart';
import '../entities/cart_items.dart';
import 'dart:convert';
import 'dart:typed_data';
Widget foodItem(Product food,
    {double? imgWidth, onLike, onTapped, bool isProductPage = false}) {
  return GestureDetector(
    onTap: onTapped, //  let onTapped combine with GestureDetector
    child: Container(
      width: 180,
      height: 300,
      margin: const EdgeInsets.only(left: 20),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.thumb_up,
                  color: food.isRecommended == true ? Colors.green : Colors.grey,
                ),
                onPressed: () {
                  if (onLike != null) {
                    onLike();
                  }
                },
              ),
            ],
          ),
          // picture
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
              child: food.image != null && food.image!.isNotEmpty
                  ? food.image!.endsWith('.png') || food.image!.endsWith('.jpg')
                  ? Image.asset(
                food.image!,
                width: 180,
                fit: BoxFit.cover,
              )
                  : food.image!.startsWith('http')
                  ? Image.network(
                food.image!,
                width: 180,
                fit: BoxFit.cover,
              )
                  : Image.memory(
                base64Decode(food.image!),
                width: 180,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/placeholder_image.png',
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 分割线
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name, style: foodNameText),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${food.price.toStringAsFixed(2)}",
                        style: priceText),
                    TextButton(
                      onPressed: () {
                        Cartitems.addToCart(food, 1);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


