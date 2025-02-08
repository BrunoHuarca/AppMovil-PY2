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
        title: Text(
          'Carrito',
          style: TextStyle(color: Colors.black), // Texto negro en el AppBar
        ),
        backgroundColor: Color(0xFFC44949), // Fondo del AppBar en color #C44949
      ),
      body: ShoppingScreen.cartItems.isEmpty
          ? Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Texto blanco para el cuerpo
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: ShoppingScreen.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = ShoppingScreen.cartItems[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            item['name'],
                            style: TextStyle(color: Colors.black), // Nombre en negro
                          ),
                          subtitle: Text(
                            'Cantidad: ${item['quantity']}',
                            style: TextStyle(color: Colors.grey[700]), // Subtítulo en gris oscuro
                          ),
                          trailing: Text(
                            'S/${item['price']}',
                            style: TextStyle(color: Colors.black), // Precio en negro
                          ),
                          onLongPress: () {
                            removeItem(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Subtotal en negro
                        ),
                      ),
                      Text(
                        'S/$subtotal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Subtotal en negro
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
