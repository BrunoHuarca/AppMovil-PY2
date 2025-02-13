import 'package:flutter/material.dart';
import 'product_func.dart'; // Importa tu modelo de producto
import 'shopping.dart'; // Importa la pantalla del carrito

class ProductScreen extends StatefulWidget {
  final Product product;

  ProductScreen({required this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}
//comentario
class _ProductScreenState extends State<ProductScreen> {
  int selectedQuantity = 1; // Cantidad mínima inicial

  // Función para agregar el producto al carrito
  void addToCart() {
    final existingProductIndex = ShoppingScreen.cartItems
        .indexWhere((item) => item['id'] == widget.product.id);

    if (existingProductIndex != -1) {
      // Si ya está en el carrito, aumentar la cantidad
      ShoppingScreen.cartItems[existingProductIndex]['quantity'] += selectedQuantity;
    } else {
      // Si no está en el carrito, agregarlo
      ShoppingScreen.cartItems.add({
        'id': widget.product.id,
        'name': widget.product.name,
        'price': widget.product.price,
        'quantity': selectedQuantity,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // La imagen ocupará un tercio de la pantalla
          SizedBox(
            height: MediaQuery.of(context).size.height / 3, // Un tercio de la altura
            child: Image.network(
              widget.product.imageUrl,
              width: double.infinity, // Ocupa todo el ancho
              fit: BoxFit.cover, // Abarca todo el espacio posible
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 100.0);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Texto blanco
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Price: S/${widget.product.price}',
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
                SizedBox(height: 8.0),
                Text(
                  'Description: ${widget.product.description}',
                  style: TextStyle(color: Colors.white), // Texto blanco
                ),
                SizedBox(height: 16.0),

                // Contador de cantidad
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centrar horizontalmente
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      color: Colors.white, // Color blanco del icono
                      onPressed: () {
                        if (selectedQuantity > 1) {
                          setState(() {
                            selectedQuantity--;
                          });
                        }
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$selectedQuantity',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black, // Texto negro en el contador
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      color: Colors.white, // Color blanco del icono
                      onPressed: () {
                        setState(() {
                          selectedQuantity++;
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 16.0),

                // Botón de agregar al carrito
                ElevatedButton(
                  onPressed: () {
                    addToCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Producto agregado al carrito')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEA572A), // Color del botón (#EA572A)
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // Espaciado del botón
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    'Agregar al carrito',
                    style: TextStyle(color: Colors.white), // Letras blancas
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
