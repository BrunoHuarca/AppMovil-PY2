import 'package:flutter/material.dart';
import 'menu.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Puedes definir las variables de precio como desees
    double subtotal = 100;
    double shippingFee = 10;
    double totalPrice = subtotal + shippingFee;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Sin AppBar
        child: Container(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Título
            Text(
              'Confirmar Pedido',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),

            // Pregunta de cómo pagar
            Text(
              '¿Cómo quieres pagar?',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 20),

            // Opciones de pago
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Efectivo color plomo
                    minimumSize: Size(150, 50), // Botón más grande
                  ),
                  onPressed: () {},
                  child: Text(
                    'Efectivo',
                    style: TextStyle(color: Colors.white, fontSize: 18), // Letra blanca
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Yape color morado
                    minimumSize: Size(150, 50), // Botón más grande
                  ),
                  onPressed: () {},
                  child: Text(
                    'Yape',
                    style: TextStyle(color: Colors.white, fontSize: 18), // Letra blanca
                  ),
                ),
              ],
            ),
            Divider(color: Colors.white), // Línea de separación
            SizedBox(height: 20),

            // Datos de Entrega
            Text(
              'Datos de Entrega',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 10),

            // Lista de entrega
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('Delivery:', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Text('30-45 min', style: TextStyle(color: Colors.white)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text('Dirección:', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Text('C. Miramar 105', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Cambiar'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Text('Referencia:', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    Text('Porton negro', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Cambiar'),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.white), // Línea de separación
            SizedBox(height: 20),

            // Resumen de la compra
            Text(
              'Resumen',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            SizedBox(height: 10),

            // Detalles del resumen
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'S/\$${subtotal.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Envío:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'S/\$${shippingFee.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'S/\$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Expanded para que el contenido ocupe el espacio restante
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    // Botón de "Pedir"
                    ElevatedButton(
                      onPressed: () {
                        // Acción para navegar a la pantalla de OrderScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrderScreen()), // Asegúrate de que "OrderScreen" esté en el archivo order.dart
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        child: Text(
                          'Pedir',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Enlace de "Cancelar Pedido"
                    TextButton(
                      onPressed: () {
                        // Acción para navegar a la pantalla menu.dart
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MenuScreen()), // Asegúrate de que "MenuScreen" esté en el archivo menu.dart
                        );
                      },
                      child: Text(
                        'Cancelar Pedido',
                        style: TextStyle(fontSize: 14, color: Colors.blue), // Estilo del texto
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
