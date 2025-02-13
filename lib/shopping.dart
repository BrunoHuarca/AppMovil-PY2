import 'package:flutter/material.dart';
import 'order.dart';

class ShoppingScreen extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems =
      []; // Lista global para almacenar los productos

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}
//comentario
class _ShoppingScreenState extends State<ShoppingScreen> {
  // Función que calcula el subtotal sumando el precio por cantidad de cada producto
  double get subtotal {
    return ShoppingScreen.cartItems.fold(0, (sum, item) {
      return sum + (item['price'] * item['quantity']);
    });
  }

  // Función que cuenta el total de platos
  num get totalItems {
    return ShoppingScreen.cartItems.fold(0, (total, item) {
      return total + item['quantity'];
    });
  }

  // Función para eliminar un producto del carrito
  void removeItem(int index) {
    setState(() {
      ShoppingScreen.cartItems.removeAt(index);
    });
  }

  // Función para aumentar la cantidad de un producto
  void incrementQuantity(int index) {
    setState(() {
      ShoppingScreen.cartItems[index]['quantity']++;
    });
  }

  // Función para disminuir la cantidad de un producto, con un mínimo de 1
  void decrementQuantity(int index) {
    setState(() {
      if (ShoppingScreen.cartItems[index]['quantity'] > 1) {
        ShoppingScreen.cartItems[index]['quantity']--;
      }
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            item['name'],
                            style: TextStyle(
                                color: Colors.black), // Nombre en negro
                          ),
                          subtitle: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => decrementQuantity(index),
                              ),
                              Text(
                                '${item['quantity']}',
                                style: TextStyle(
                                    color: Colors.black), // Cantidad en negro
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => incrementQuantity(index),
                              ),
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Text(
                                'S/${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors
                                        .black), // Precio total por plato en negro
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    removeItem(index), // Eliminar plato
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total de platos:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Total de platos en blanco
                            ),
                          ),
                          Text(
                            '$totalItems',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Total de platos en blanco
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total precio:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Subtotal en blanco
                            ),
                          ),
                          Text(
                            'S/${subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Subtotal en blanco
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16), // Espacio antes del botón
                      Center(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFEA572A), // Fondo del botón
      foregroundColor: Colors.white, // Color del texto del botón
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Tamaño del botón
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen()), // Navega a OrderScreen
      );
    },
    child: Text(
      'Realizar Pedido',
      style: TextStyle(fontSize: 18),
    ),
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
