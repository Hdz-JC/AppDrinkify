import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'widgets/bottom_nav_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

// --- AÑADIR ESTOS IMPORTS ---
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:appdrinkify/views/search_results_view.dart'; // (La vista que creamos antes)
import 'package:appdrinkify/models/bebidas_model.dart'; // (El modelo que creamos antes)
// --- FIN DE IMPORTS ---


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
  
  // --- AÑADIR UN CONTROLADOR PARA LA BARRA ---
  final TextEditingController _searchController = TextEditingController();

  // --- AÑADIR EL MÉTODO DISPOSE PARA LIMPIAR EL CONTROLADOR ---
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  // --- FIN DE AÑADIDOS ---

  @override
  Widget build(BuildContext context) {

    final username = context.watch<AuthProvider>().currentUser?.username ?? 'Usuario';
    
    // --- AÑADIR ESTA LÍNEA (para usarla en el onSubmitted) ---
    final bebidaProvider = context.read<BebidaProvider>();


    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.person_rounded, size: 80),
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
              
              // --- MODIFICAR EL WIDGET SearchBar ---
              SearchBar(
                controller: _searchController, // <-- Añadir
                leading: const Icon(Icons.search),
                hintText: "Busca una bebida",
                // Esta es la función que se ejecuta al presionar "Enter"
                onSubmitted: (String query) { // <-- Añadir
                  if (query.isNotEmpty) {
                    // 1. Llama al Provider para obtener la lista de resultados
                    final List<Bebida> resultados = bebidaProvider.buscarBebidas(query);

                    // 2. Navega a la nueva pantalla de resultados
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsView(
                          resultados: resultados,
                          query: query,
                        ),
                      ),
                    );

                    // 3. Opcional: Limpiar la barra de búsqueda después de buscar
                    _searchController.clear();
                    // 4. Opcional: Quitar el foco
                    FocusScope.of(context).unfocus(); 
                  }
                },
              ),
              // --- FIN DE LA MODIFICACIÓN ---
              
              const SizedBox(height: 40),
              CarouselSlider(
                items: imgCarru.map((e) => Center(
                child: Image.asset(
                  e,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,)
                )).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
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