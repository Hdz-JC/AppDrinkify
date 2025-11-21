import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';

class RecomendacionView extends StatefulWidget {
  const RecomendacionView({super.key});

  @override
  State<RecomendacionView> createState() => _RecomendacionViewState();
}

class _RecomendacionViewState extends State<RecomendacionView> {

  Bebida? _bebidaDelDia;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinarBebidaDelDia();
  }

  Future<void> _determinarBebidaDelDia() async {
    final String hoy = DateTime.now().toIso8601String().substring(0, 10);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? fechaGuardada = prefs.getString('fechaRecomendacion');
    final int? idGuardado = prefs.getInt('idRecomendacion');
    final provider = context.read<BebidaProvider>();

    if (provider.listaCompletaBebidas.isEmpty) {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
      return;
    }
    
    Bebida bebidaParaMostrar;

    if (hoy == fechaGuardada && idGuardado != null) {
      bebidaParaMostrar = provider.listaCompletaBebidas.firstWhere(
        (b) => b.id == idGuardado,
        orElse: () => (provider.listaCompletaBebidas..shuffle()).first,
      );
    } else {
      final List<Bebida> todasLasBebidas = provider.listaCompletaBebidas;
      (todasLasBebidas..shuffle());
      bebidaParaMostrar = todasLasBebidas.first;
      await prefs.setString('fechaRecomendacion', hoy);
      await prefs.setInt('idRecomendacion', bebidaParaMostrar.id!);
    }
    if (mounted) {
      setState(() {
        _bebidaDelDia = bebidaParaMostrar;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritosProvider = context.watch<FavoritosProvider>();
    final bool esFav = (_bebidaDelDia != null && _bebidaDelDia!.id != null)
        ? favoritosProvider.esFavorita(_bebidaDelDia!.id!)
        : false;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
          onPressed: () => NavigationController.navigateTo(context, '/home'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Recomendación del Día'),
        centerTitle: true,
        actions: [
          if (!_isLoading && _bebidaDelDia != null)
            IconButton(
              icon: Icon(
                esFav ? Icons.favorite : Icons.favorite_border,
                color: esFav ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                context.read<FavoritosProvider>().toggleFavorito(_bebidaDelDia!);
              },
            ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _bebidaDelDia == null
                ? const Text("No se pudo cargar la bebida. Intenta de nuevo.")
                : _buildDetalleBebida(_bebidaDelDia!),
      ),
    );
  }

  Widget _buildDetalleBebida(Bebida bebida) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            bebida.nombre,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            bebida.categoria_nombre ?? 'Sin Categoría',
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              bebida.imageUrl,
              height: 250,
              width: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  width: 250,
                  color: Colors.grey[200],
                  child: const Icon(Icons.no_photography, color: Colors.grey, size: 100),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Instrucciones",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bebida.preparacion,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}