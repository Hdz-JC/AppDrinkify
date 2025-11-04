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
    "https://lucavending.net/wp-content/uploads/2021/06/bebidas-calientes.jpg",
    "https://www.gob.mx/cms/uploads/article/main_image/24844/aguas.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS14sRbtoDJIDz3SJ2t1vZ19R5LJhXpSSQIAA&s",
    "https://s3.amazonaws.com/takami.co/thumbnails/productimage/75399ce2ab6242d8a683d822963e874c/nmj5mo4az3ka7gbkp4ufge_1280_800.jpg",
    "https://media.gq.com.mx/photos/61e83673f4e647708c8d6205/16:9/w_2992,h_1683,c_limit/diaet-shakes-abnehm-trend-abnehmen-gesundheit-fitness-aufm.jpg",
    "https://s2.abcstatics.com/media/bienestar/2020/07/04/batidos-saludables-kdhH--1248x698@abc.jpeg",
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
                child: Image.network(
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