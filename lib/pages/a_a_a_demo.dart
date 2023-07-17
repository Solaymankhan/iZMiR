import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Define the initial cart object
Map<String, List<Map<String, dynamic>>> cart = {};

// Function to add a product to the cart
void addProductToCart(Map<String, dynamic> product) async {
  final brand = product['brand'];
  final productId = product['id'];
  final preferences = await SharedPreferences.getInstance();

  if (!cart.containsKey(brand)) {
    // If the brand does not exist in the cart, add it as a new key
    cart[brand] = [];
  }

  // Check if the product already exists in the cart
  final productIndex = cart[brand]!.indexWhere((item) => item['id'] == productId);

  if (productIndex != -1) {
    // If the product already exists, increase its item count
    cart[brand]![productIndex]['itemCount']++;
  } else {
    // If the product does not exist, add it to the array of products under the brand in the cart
    product['itemCount'] = 1; // Set the initial item count to 1
    cart[brand]!.add(product);
  }

  // Store the updated cart object in shared preferences
  preferences.setString('cart', json.encode(cart));

}


void removeProductFromCart(Map<String, dynamic> product) async {
  final brand = product['brand'];  final preferences = await SharedPreferences.getInstance();
  if (cart.containsKey(brand)) {
    final productIndex = cart[brand]!.indexWhere((item) => item['id'] == product['id']);
    if (productIndex != -1) {
      cart[brand]!.removeAt(productIndex);
      if (cart[brand]!.isEmpty) {
        cart.remove(brand);
      }
      preferences.setString('cart', json.encode(cart));
    }
  }
}

// Function to retrieve the cart data from shared preferences
Future<Map<String, List<Map<String, dynamic>>>> getCartData() async {
  final preferences = await SharedPreferences.getInstance();
  final cartData = preferences.getString('cart');

  return cartData != null ? json.decode(cartData) : {};
}

// Function to clear the cart data from shared preferences
void clearCart() async {
  final preferences = await SharedPreferences.getInstance();
  preferences.remove('cart');
  cart = {};
}






// Function to add a product to the cart or increase item count if already exists

