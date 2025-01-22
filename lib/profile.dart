import 'package:flutter/material.dart';
import 'menu.dart'; // Importa la pantalla de inicio (menú)
import 'shopping.dart'; // Importa la pantalla del carrito

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removemos el AppBar y usamos un Container vacío
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Sin altura
        child: Container(), // No tiene contenido
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Nombre y celular
            Text(
              'Bruno Huarca',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Text('Celular: 902311395'),
                SizedBox(width: 10),
                ElevatedButton(
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
                ElevatedButton(
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
                ElevatedButton(
                  onPressed: () {
                    // Acción para cambiar la referencia
                  },
                  child: Text('Cambiar'),
                ),
              ],
            ),
            Text('Porton negro'),
            Divider(), // Línea de separación

            // Opción de Cerrar sesión
            GestureDetector(
              onTap: () {
                // Lógica para cerrar sesión, navegar al MenuScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
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
              // Navegar a la pantalla de inicio
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
              break;
            case 1:
              // Navegar a la pantalla del carrito
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShoppingScreen()),
              );
              break;
            case 2:
              // Ya estamos en la pantalla de perfil, no hacemos nada
              break;
          }
        },
      ),
    );
  }
}
