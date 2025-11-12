import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'widgets/bottom_nav_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:appdrinkify/views/search_results_view.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart';


class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    });

  @override
  State<HomeView> createState() => _HomeViewState();
}

  final List<String> imgCarru = [
    "assets/images/carrusel/alcohol.jpg",
    "assets/images/carrusel/batidos.jpg",
    "assets/images/carrusel/calientes.jpg",
    "assets/images/carrusel/clasicos.jpg",
    "assets/images/carrusel/fitness.jpg",
    "assets/images/carrusel/frescas.jpg",
  ];

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthProvider>().currentUser?.username ?? 'Usuario';
    //final bebidaProvider = context.read<BebidaProvider>();
    final bebidaProvider = context.watch<BebidaProvider>();
    final List<Bebida> bebidasCarousel = bebidaProvider.getBebidasPorCategoria("Calientes");

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $username',
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        ),
        actions: [
          IconButton(
            onPressed:(){
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
                NavigationController.navigateTo(context, '/inicio');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              SearchBar(
                controller: _searchController,
                leading: const Icon(Icons.search),
                hintText: "Busca una bebida",
                onSubmitted: (String query) {
                  final String trimmedQuery = query.trim();
                  final RegExp regexTextoValido = RegExp(r'^[a-zA-Z áéíóúÁÉÍÓÚñÑ]+$');
                  if (trimmedQuery.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Escribe el nombre de una bebida'),
                        ),
              );
              } else if (!regexTextoValido.hasMatch(trimmedQuery)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Solo puedes buscar bebidas'),
                  ),
                );
                } else {
                  final List<Bebida> resultados = bebidaProvider.buscarBebidas(trimmedQuery);
                  Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsView(
                      resultados: resultados,
                      query: trimmedQuery,
                    ),
                  ),
                );
                _searchController.clear();
                FocusScope.of(context).unfocus();
                }
              },
              ),
              const SizedBox(height: 40),
              
              bebidasCarousel.isEmpty
                ? Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Text("Cargando bebidas de temporada...")),
                  )
                : // 4. CAMBIO: Modificamos el CarouselSlider
                  CarouselSlider(
                    // Ahora usamos la lista dinámica 'bebidasCarousel'
                    // y 'bebida' es un objeto Bebida, no un String
                    items: bebidasCarousel.map((bebida) {
                      // 5. CAMBIO: Envolvemos la imagen en un GestureDetector
                      // para hacerla "tappable" (clicable)
                      return GestureDetector(
                        onTap: () {
                          // Y la mandamos a la pantalla de detalle
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleBebidaView(bebida: bebida),
                            ),
                          );
                        },
                        child: Center(
                          child: Image.asset(
                            bebida.imageUrl, // <--- Usamos la URL de la bebida
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.cover,
                            // Añadimos un errorBuilder por si falla la imagen
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.no_photography, color: Colors.grey),
                          )
                        ),
                      );
                    }).toList(), // <--- Convertimos el map a lista
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      height: 200,
                    ),
                  ),
              
              const SizedBox(height: 40),
              ElevatedButton(
                //onPressed: () {},
                onPressed:()=> NavigationController.navigateTo(context,'/categorias'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                ),
                child: const Text(
                  'Ver categorias',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed:()=> NavigationController.navigateTo(context,'/recomendacion'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Recomendación del día',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
  
}