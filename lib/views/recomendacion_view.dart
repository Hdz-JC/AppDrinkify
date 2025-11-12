// 1. IMPORTAMOS LO QUE NECESITAMOS
import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:appdrinkify/models/bebidas_model.dart'; // Para el modelo Bebida
import 'package:appdrinkify/providers/bebidas_provider.dart'; // Para jalar las bebidas
import 'package:provider/provider.dart'; // Para usar context.read
import 'package:shared_preferences/shared_preferences.dart'; // Para la memoria persistente

// 2. CONVERTIMOS A STATEFULWIDGET
class RecomendacionView extends StatefulWidget {
  const RecomendacionView({super.key});

  @override
  State<RecomendacionView> createState() => _RecomendacionViewState();
}

class _RecomendacionViewState extends State<RecomendacionView> {
  
  // 3. VARIABLES DE ESTADO
  Bebida? _bebidaDelDia; // La bebida que vamos a mostrar (es '?' porque al inicio es nula)
  bool _isLoading = true; // Para mostrar un 'cargando...'

  @override
  void initState() {
    super.initState();
    // 4. AL INICIAR LA PANTALLA, BUSCAMOS LA BEBIDA
    _determinarBebidaDelDia();
  }

  Future<void> _determinarBebidaDelDia() async {
    // Obtenemos la fecha de hoy en formato "YYYY-MM-DD"
    final String hoy = DateTime.now().toIso8601String().substring(0, 10);

    // Obtenemos la instancia de SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Leemos la fecha y el ID que guardamos la última vez
    final String? fechaGuardada = prefs.getString('fechaRecomendacion');
    final int? idGuardado = prefs.getInt('idRecomendacion');

    // Jalamos el provider (sin 'listen', solo para leer)
    final provider = context.read<BebidaProvider>();

    // Fallback por si el provider aún no carga (aunque debería)
    if (provider.listaCompletaBebidas.isEmpty) {
      setState(() { _isLoading = false; });
      return;
    }
    
    Bebida bebidaParaMostrar;

    // 5. LÓGICA DE DECISIÓN
    if (hoy == fechaGuardada && idGuardado != null) {
      // SI LA FECHA ES LA MISMA: Ya habíamos elegido una bebida hoy.
      // Buscamos la bebida que ya habíamos guardado por su ID.
      bebidaParaMostrar = provider.listaCompletaBebidas.firstWhere(
        (b) => b.id == idGuardado,
        // Si por alguna razón no la encuentra, elegimos una random
        orElse: () => (provider.listaCompletaBebidas..shuffle()).first,
      );
    } else {
      // SI ES UN DÍA NUEVO (o la primera vez que se abre):
      // 1. Obtenemos la lista completa
      final List<Bebida> todasLasBebidas = provider.listaCompletaBebidas;
      
      // 2. Las barajamos (shuffle)
      (todasLasBebidas..shuffle());
      
      // 3. Elegimos la primera de la lista barajada
      bebidaParaMostrar = todasLasBebidas.first;

      // 4. GUARDAMOS la elección para que no cambie hoy
      await prefs.setString('fechaRecomendacion', hoy);
      await prefs.setInt('idRecomendacion', bebidaParaMostrar.id!); // Asumimos que el ID no es nulo
    }

    // 6. ACTUALIZAMOS LA UI
    // Usamos 'if (mounted)' para asegurarnos que la pantalla siga visible
    if (mounted) {
      setState(() {
        _bebidaDelDia = bebidaParaMostrar;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => NavigationController.navigateTo(context, '/home'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Recomendación del Día'),
        centerTitle: true,
      ),
      // 7. BODY DINÁMICO
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Muestra "cargando..."
            : _bebidaDelDia == null
                ? const Text("No se pudo cargar la bebida. Intenta de nuevo.") // Muestra error
                : _buildDetalleBebida(_bebidaDelDia!), // Muestra la bebida
      ),
    );
  }

  // 8. WIDGET AUXILIAR PARA MOSTRAR LA BEBIDA
  // (Este es básicamente el código de tu 'DetalleBebidaView'
  //  pero metido aquí directamente)
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