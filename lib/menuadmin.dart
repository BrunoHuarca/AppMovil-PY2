import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_func.dart'; // Asegúrate de que este archivo esté bien definido
import 'shopping.dart'; // Importar la pantalla del carrito
import 'profile.dart'; // Importar la pantalla del perfil
import 'offers.dart'; // Importar la pantalla de ofertas
import 'dishes.dart'; // Importar la pantalla de platos
import 'ordersadmin.dart';

class MenuAdminScreen extends StatefulWidget {
  @override
  _MenuAdminScreenState createState() => _MenuAdminScreenState();
}

class _MenuAdminScreenState extends State<MenuAdminScreen> {
  List<Product> products = []; // Lista de productos
  List<Product> filteredProducts = []; // Lista filtrada de productos
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0; // Para controlar el índice seleccionado del BottomNavigationBar

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(_filterProducts);
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://mixturarosaaqp.com/api/productos'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          filteredProducts = products;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error al cargar productos');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("No se pudieron cargar los productos. Intenta más tarde."),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'ADMINISTRACIÓN DE RESTAURANT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar plato...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEA572A), // Color de fondo #EA572A
                ),
                onPressed: () {
                  // Aquí puedes agregar una acción cuando se presione el botón
                },
                child: Text('Licorería', style: TextStyle(color: Colors.white)), // Texto en blanco
              ),
            ),
            // Sección 'Las Mejores Ofertas' con el botón 'Administrar'
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Las Mejores Ofertas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEA572A), // Color de fondo #EA572A
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OffersScreen()),
                      );
                    },
                    child: Text('Administrar', style: TextStyle(color: Colors.white)), // Texto en blanco
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 250,
                    child: PageView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Image.network(
                          'https://via.placeholder.com/600x400',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                      onPageChanged: (index) {},
                    ),
                  ),
            // Sección 'Todos los platos' con el botón 'Administrar'
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Todos los platos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEA572A), // Color de fondo #EA572A
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DishesScreen()),
                      );
                    },
                    child: Text('Administrar', style: TextStyle(color: Colors.white)), // Texto en blanco
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: filteredProducts.isEmpty
                        ? products.map((product) {
                            return PlateItem(
                              name: product.name,
                              price: 'S/${product.price}',
                              time: 'N/A',
                              imageUrl: product.imageUrl,
                            );
                          }).toList()
                        : filteredProducts.map((product) {
                            return PlateItem(
                              name: product.name,
                              price: 'S/${product.price}',
                              time: 'N/A',
                              imageUrl: product.imageUrl,
                            );
                          }).toList(),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pedidos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // Color de íconos seleccionados
        unselectedItemColor: Colors.grey, // Color de íconos no seleccionados
        backgroundColor: Colors.black, // Color de fondo del navbar
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuAdminScreen()),
              );
              break;
            case 1: // Opción para "Pedidos"
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OrdersAdminScreen()), // Asegúrate de tener esta pantalla creada
              );
              break;
          }
        },
      ),
    );
  }
}

class PlateItem extends StatelessWidget {
  final String name;
  final String price;
  final String time;
  final String imageUrl;

  PlateItem({
    required this.name,
    required this.price,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes hacer algo cuando el usuario toque un plato
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Image.network(
                imageUrl,
                height: 60.0,
                width: 60.0,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes!)
                            : null,
                      ),
                    );
                  }
                },
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
