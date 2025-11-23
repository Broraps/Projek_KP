import 'package:flutter/foundation.dart';

import '../models/cart_item_model.dart';

class CartService {
  static final CartService _instance = CartService._internal();

  factory CartService() => _instance;

  CartService._internal();

  final ValueNotifier<List<CartItem>> items = ValueNotifier([]);

  ValueNotifier<int> get totalItemsNotifier {
    final notifier = ValueNotifier(0);
    items.addListener(() {
      notifier.value = items.value.fold(0, (sum, item) => sum + item.quantity);
    });
    return notifier;
  }

  void addToCart(Map<String, dynamic> product) {
    final existingIndex =
        items.value.indexWhere((item) => item.id == product['id'].toString());

    if (existingIndex != -1) {
      items.value[existingIndex].quantity++;
    } else {
      items.value.add(CartItem(
        id: product['id'].toString(),
        title: product['title'],
        imageUrl: product['image_url'],
        price: product['price'],
      ));
    }
    items.value = List.from(items.value);
  }

  void incrementQuantity(String productId) {
    final index = items.value.indexWhere((item) => item.id == productId);
    if (index != -1) {
      items.value[index].quantity++;
      items.value = List.from(items.value);
    }
  }

  void decrementQuantity(String productId) {
    final index = items.value.indexWhere((item) => item.id == productId);
    if (index != -1 && items.value[index].quantity > 1) {
      items.value[index].quantity--;
      items.value = List.from(items.value);
    } else if (index != -1 && items.value[index].quantity == 1) {
      removeFromCart(productId);
    }
  }

  void removeFromCart(String productId) {
    items.value.removeWhere((item) => item.id == productId);
    items.value = List.from(items.value);
  }

  double get totalPrice {
    return items.value
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
}
