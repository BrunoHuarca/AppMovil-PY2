import 'package:flutter/material.dart';

class ShoppingScreen extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems = []; // Lista global para almacenar los productos

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  double get subtotal {
    return ShoppingScreen.cartItems.fold(0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
  }

  void removeItem(int index) {
    setState(() {
      ShoppingScreen.cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito'),
      ),
      body: ShoppingScreen.cartItems.isEmpty
          ? Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: ShoppingScreen.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = ShoppingScreen.cartItems[index];
                      return ListTile(
                        title: Text(item['name']),
                        subtitle: Text('Cantidad: ${item['quantity']}'),
                        trailing: Text('S/${item['price']}'),
                        onLongPress: () {
                          removeItem(index);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Subtotal: S/$subtotal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
    );
  }
}
