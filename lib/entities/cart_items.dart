import 'product.dart';

class Cartitems {

  final Product product;
  int quantity;

  Cartitems({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  static List<Cartitems> items = [];

  static void addToCart(Product product, int quantity) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      items[index].quantity += quantity;
    } else {
      items.add(Cartitems(product: product, quantity: quantity));
    }
  }

  static void removeFromCart(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  static void clearCart() {
    items.clear();
  }

  static double getTotalPrice() {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
