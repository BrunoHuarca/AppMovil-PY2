import 'package:flutter/material.dart';
import 'order.dart'; // Importa la pantalla de order.dart

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Chicharron',
      'price': 15.00,
      'quantity': 1,
      'description': 'Delicioso chicharrón crujiente con camote.',
    },
    {
      'name': 'Lomo Saltado',
      'price': 20.00,
      'quantity': 2,
      'description': 'Clásico lomo saltado con papas fritas.',
    },
    {
      'name': 'Ceviche',
      'price': 18.00,
      'quantity': 1,
      'description': 'Ceviche fresco con ají y limón.',
    },
  ];

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double shippingFee = 5.00;

  double get totalPrice {
    return subtotal + shippingFee;
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      } else {
        cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Título centrado
              Center(
                child: Text(
                  'Carrito',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              // Listado de productos
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cuadro plomo en lugar de la imagen
                            Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300], // Cuadrado plomo
                            ),
                            SizedBox(width: 16),
                            // Detalles del producto
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItems[index]['name'],
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    cartItems[index]['description'],
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(height: 10),
                                  Text('S/${cartItems[index]['price']}'),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      // Botones para aumentar y disminuir cantidad
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () => decreaseQuantity(index),
                                      ),
                                      Text('${cartItems[index]['quantity']}'),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () => increaseQuantity(index),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Sección de Subtotal y Envío
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'S/$subtotal',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Envío:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'S/$shippingFee',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Sección de Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'S/$totalPrice',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Botón de "Realizar pedido"
              ElevatedButton(
                onPressed: () {
                  // Acción para navegar a la pantalla de order.dart
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderScreen()), // Asegúrate de que "OrderScreen" esté en el archivo order.dart
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Text(
                    'Siguiente',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
