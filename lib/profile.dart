import 'package:flutter/material.dart';
import 'menu.dart'; // Importa la pantalla de inicio (menú)
import 'shopping.dart'; // Importa la pantalla del carrito
import 'main.dart'; // Importa la pantalla principal desde main.dart
import 'myorder.dart'; // Importa la pantalla de pedidos

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Sin altura
        child: Container(), // No tiene contenido
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Nombre
            Text(
              'Bruno Huarca',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Text('Celular: 902311395'),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    // Acción para editar
                  },
                  child: Text('Editar'),
                ),
              ],
            ),
            Divider(), // Línea de separación

            // Dirección
            Text(
              'Perfil',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Dirección'),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la dirección
                  },
                  child: Text('Cambiar'),
                ),
              ],
            ),
            Text('C. Miramar 105'),
            Divider(), // Línea de separación

            // Referencia
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Referencia'),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la referencia
                  },
                  child: Text('Cambiar'),
                ),
              ],
            ),
            Text('Portón negro'),
            Divider(), // Línea de separación

            // Ubicación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Ubicación'),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la ubicación
                  },
                  child: Text('Cambiar'),
                ),
              ],
            ),
            Text('Latitud: -12.0464, Longitud: -77.0428'),
            Divider(), // Línea de separación

            // Contraseña (opcional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Contraseña'),
                TextButton(
                  onPressed: () {
                    // Acción para cambiar la contraseña
                  },
                  child: Text('Cambiar'),
                ),
              ],
            ),
            Text('********'), // Texto ocultando la contraseña
            Divider(), // Línea de separación

            // Nuevo apartado para ver pedido
            GestureDetector(
              onTap: () {
                // Lógica para navegar a la pantalla de pedidos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyOrderScreen()), // Redirige a la pantalla de pedidos
                );
              },
              child: Text(
                'Ver tu pedido',
                style: TextStyle(
                  color: Colors.blue, // Color de letra azul para destacar
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(), // Línea de separación

            // Opción de Cerrar sesión
            GestureDetector(
              onTap: () {
                // Lógica para cerrar sesión y navegar a la pantalla principal (main.dart)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()), // Asegúrate de que 'MyApp' sea el widget principal de main.dart
                );
              },
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.black, // Color de letra negro
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10), // Espacio entre "Cerrar Sesión" y el nav bar
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Establecer el índice actual en "Mi perfil"
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi perfil',
          ),
        ],
        onTap: (index) {
          // Lógica de navegación para cada opción del bottom navigation
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShoppingScreen()),
              );
              break;
            case 2:
              break;
          }
        },
      ),
    );
  }
}
