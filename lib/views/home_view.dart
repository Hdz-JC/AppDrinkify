import 'package:appdrinkify/views/categorias_view.dart';
import 'package:appdrinkify/views/recomendacion_view.dart';
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
    final bebidaProvider = context.watch<BebidaProvider>();

    int mesActual = DateTime.now().month;
    String categoriaTemporada = "";

    switch (mesActual) {
      case 12: // Diciembre
      case 1:  // Enero
      case 2:  // Febrero
        categoriaTemporada = "Calientes";
        break;

      case 3: // Marzo
      case 4: // Abril
      case 5: // Mayo
        categoriaTemporada = "Aguas frescas";
        break;

      case 6: // Junio
      case 7: // Julio
      case 8: // Agosto
        categoriaTemporada = "Batidos"; 
        break;

      case 9:  // Septiembre
      case 10: // Octubre
      case 11: // Noviembre
        categoriaTemporada = "Con alcohol"; 
        break;

      default:
        categoriaTemporada = "Jugos Clasicos";
    }
    final List<Bebida> bebidasCarousel = bebidaProvider.getBebidasPorCategoria(categoriaTemporada);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              
              SearchBar(
                controller: _searchController,
                leading: const Icon(Icons.search),
                hintText: "Busca una bebida",
                onSubmitted: (String query) {
                  final String trimmedQuery = query.trim();
                  final RegExp regexTextoValido = RegExp(r'^[a-zA-Z áéíóúÁÉÍÓÚñÑ]+$');
                  if (trimmedQuery.isEmpty) {
                            messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(content: Text('Escribe el nombre de una bebida')),
        );
              } else if (!regexTextoValido.hasMatch(trimmedQuery)) {
                                            messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(content: Text('Solo puedes buscar bebidas')),
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
              const SizedBox(height: 50),
              
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
                :
                  CarouselSlider(
                    items: bebidasCarousel.map((bebida) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleBebidaView(bebida: bebida),
                            ),
                          );
                        },
                        child: Center(
                          child: Image.asset(
                            bebida.imageUrl,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.no_photography, color: Colors.grey),
                          )
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      height: 280,
                    ),
                  ),
              
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed:() => Navigator.push(context,MaterialPageRoute(builder: (context) => CategoriasView()),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: const Text(
                  'Ver categorias',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0)
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed:() => Navigator.push(context,MaterialPageRoute(builder: (context) => RecomendacionView()),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: const Text(
                  'Recomendación del día',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 0, 0)
                  ),
                ),
              ),
            ],
          ),
          ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}