import 'package:flutter/material.dart';
import 'offers.dart'; // Importa la pantalla de ofertas
import 'product.dart'; // Importa la pantalla del producto
import 'dishes.dart'; // Importa la pantalla de administración de platos

class MenuAdminScreen extends StatefulWidget {
  @override
  _MenuAdminScreenState createState() => _MenuAdminScreenState();
}

class _MenuAdminScreenState extends State<MenuAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Título "RESTAURANT"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'RESTAURANT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Botón Licorería (más grande)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Acción para "Licorería"
                },
                child: Text('Licorería'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  textStyle: TextStyle(fontSize: 22),
                  minimumSize: Size(double.infinity, 50), // Hacer el botón más grande
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Sección "Las mejores ofertas" con botón "Administrar"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Las mejores ofertas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de administración de ofertas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OffersScreen(), // Navegar a OffersScreen
                        ),
                      );
                    },
                    child: Text('Administrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color del botón
                    ),
                  ),
                ],
              ),
            ),

            // Carrusel de imágenes: "Las mejores ofertas"
            Container(
              height: 200.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Card(
                    child: Image.asset('assets/offer1.jpg'),
                  ),
                  Card(
                    child: Image.asset('assets/offer2.jpg'),
                  ),
                  Card(
                    child: Image.asset('assets/offer3.jpg'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),

            // Sección "Todos los platos" con botón "Administrar"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Todos los platos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de administración de platos
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DishesScreen(), // Navegar a DishesScreen
                        ),
                      );
                    },
                    child: Text('Administrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color del botón
                    ),
                  ),
                ],
              ),
            ),

            // Lista de platos con nombre, precio y tiempo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PlateItem(name: 'Chicharron', price: 'S/15.00', time: '30-45 min'),
                  PlateItem(name: 'Lomo Saltado', price: 'S/20.00', time: '20-30 min'),
                  PlateItem(name: 'Ceviche', price: 'S/18.00', time: '15-25 min'),
                  PlateItem(name: 'Arroz Chaufa', price: 'S/12.00', time: '20 min'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para mostrar los platos
class PlateItem extends StatelessWidget {
  final String name;
  final String price;
  final String time;

  PlateItem({required this.name, required this.price, required this.time});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la pantalla del producto al hacer clic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              name: name,
              price: price,
              time: time,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.restaurant_menu, size: 40.0),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(price),
                  Text('Tiempo: $time'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
