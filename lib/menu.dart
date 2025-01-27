import 'package:flutter/material.dart';
import 'dart:async';
import 'product.dart'; // Importa la pantalla del producto
import 'shopping.dart'; // Importa la pantalla del carrito
import 'profile.dart'; // Importa la pantalla del perfil

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  double _precio = 20; // Precio inicial
  double _maxPrice = 100; // Precio máximo
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Configura un temporizador para cambiar las páginas automáticamente
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
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

                  // Buscador de platos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Buscar plato...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Filtro de precio
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Filtrar por precio: S/$_precio'),
                        Slider(
                          value: _precio,
                          min: 0,
                          max: _maxPrice,
                          divisions: 10,
                          label: 'S/$_precio',
                          onChanged: (value) {
                            setState(() {
                              _precio = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Botón Licorería
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
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Título 'Las mejores ofertas'
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Las mejores ofertas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Carrusel de imágenes
                  Container(
                    height: 200.0,
                    child: PageView(
                      controller: _pageController,
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

                  // Título 'Todos los platos'
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Todos los platos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Lista de platos
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'Mi Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShoppingScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
          }
        },
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
