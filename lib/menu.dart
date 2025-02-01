import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_func.dart'; // Asegúrate de que este archivo esté bien definido
import 'shopping.dart'; // Importar la pantalla del carrito
import 'profile.dart'; // Importar la pantalla del perfil

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Product> products = []; // Lista de productos
  List<Product> filteredProducts = []; // Lista filtrada de productos
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0; // Para controlar el índice seleccionado del BottomNavigationBar

  @override
  void initState() {
    super.initState();
    // Obtener productos desde la API
    fetchProducts();
    searchController.addListener(_filterProducts);
  }

  // Función para hacer la solicitud HTTP
  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('https://mixturarosaaqp.com/api/productos'));

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, parsea los productos
        List<dynamic> data = json.decode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
          filteredProducts = products; // Inicializa la lista filtrada con todos los productos
          isLoading = false; // Cambiar el estado de carga
        });
      } else {
        // Si no fue exitosa, muestra un error
        setState(() {
          isLoading = false;
        });
        throw Exception('Error al cargar productos');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Si ocurrió un error, muestra un mensaje
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content:
                Text("No se pudieron cargar los productos. Intenta más tarde."),
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

  // Función para filtrar los productos
  void _filterProducts() {
    setState(() {
      filteredProducts = products
          .where((product) => product.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  // Función para cambiar entre las pantallas de la barra de navegación
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Acción para la opción 'Inicio'
        // Aquí podrías implementar la lógica para redirigir a la pantalla de inicio.
        break;
      case 1:
        // Acción para la opción 'Carrito'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingScreen()),
        );
        break;
      case 2:
        // Acción para la opción 'Perfil'
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
      body: SingleChildScrollView( // Hacemos que toda la página sea desplazable
        child: Column(
          children: <Widget>[
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
            // Cuadro de búsqueda
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
            // Botón 'Licorería'
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar una acción cuando se presione el botón
                },
                child: Text('Licorería'),
              ),
            ),
            // Texto 'Las Mejores Ofertas'
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Las Mejores Ofertas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // PageView de imágenes
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    height: 250, // Altura de la vista de las imágenes
                    child: PageView.builder(
                      itemCount: 3, // Cambiar el número según la cantidad de imágenes
                      itemBuilder: (context, index) {
                        return Image.network(
                          'https://via.placeholder.com/600x400', // Imagen de ejemplo
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                      onPageChanged: (index) {
                        // Aquí puedes hacer algo cuando cambie la página
                      },
                    ),
                  ),
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
            // Si estamos cargando, muestra un indicador de carga
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: filteredProducts.isEmpty
                        ? products.map((product) {
                            return PlateItem(
                              name: product.name,
                              price: 'S/${product.price}',
                              time: 'N/A', // Puedes añadir un campo 'time' si lo tienes
                              imageUrl: product.imageUrl,
                            );
                          }).toList()
                        : filteredProducts.map((product) {
                            return PlateItem(
                              name: product.name,
                              price: 'S/${product.price}',
                              time: 'N/A', // Puedes añadir un campo 'time' si lo tienes
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
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
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
              // Mostrar la imagen del producto
              Image.network(
                imageUrl,
                height: 60.0,
                width: 60.0,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Si la imagen ya está cargada, se muestra
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
                  return Icon(Icons.error,
                      size:
                          60.0); // Si la imagen no se carga, muestra un ícono de error
                },
              ),
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
