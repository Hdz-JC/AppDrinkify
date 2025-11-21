// lib/providers/bebida_provider.dart
import 'dart:math';

import 'package:appdrinkify/models/categoria_model.dart';
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/config/datasource/sqlite_service.dart';

class BebidaProvider extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  List<Bebida> _listaCompletaBebidas = [];
  List<Bebida> _featuredBebidas = [];
  List<Categoria> _todasCategorias = [];
  bool _isLoading = false;
  final Random _random = Random();

  bool get isLoading => _isLoading;
  List<Bebida> get listaCompletaBebidas => _listaCompletaBebidas;
  List<Bebida> get featuredBebidas => _featuredBebidas;
  List<Categoria> get todasCategorias => _todasCategorias;

  BebidaProvider() {
    _inicializar();
  }

  Future<void> _inicializar() async {
    _isLoading = true;
    notifyListeners();
    
    await _sqliteService.popularDatosIniciales();
    _listaCompletaBebidas = await _sqliteService.getAllBebidas();
    _featuredBebidas = await _sqliteService.getFeaturedBebidas();
    _todasCategorias = await _sqliteService.getAllCategorias();
    
    _isLoading = false;
    notifyListeners();
  }

  List<Bebida> buscarBebidas(String query) {
    if (query.isEmpty) {
      return [];
    }
    
    final queryMinusculas = query.toLowerCase().trim();
    final resultados = _listaCompletaBebidas.where((bebida) {
      final nombreMinusculas = bebida.nombre.toLowerCase();
      final descripcionMinusculas = bebida.descripcion.toLowerCase();
      final categoriaMinusculas = bebida.categoria_nombre?.toLowerCase() ?? '';

      return nombreMinusculas.contains(queryMinusculas) || 
             descripcionMinusculas.contains(queryMinusculas) ||
             categoriaMinusculas.contains(queryMinusculas);     
    }).toList();
    return resultados;
  }

  List<Bebida> getBebidasPorCategoria(String nombreCategoria) {
    final nombreMinusculas = nombreCategoria.toLowerCase();
    final resultados = _listaCompletaBebidas.where((bebida) {
      final catNombreBebida = bebida.categoria_nombre?.toLowerCase() ?? '';
      return catNombreBebida == nombreMinusculas;
    }).toList();

    return resultados;
  }
}