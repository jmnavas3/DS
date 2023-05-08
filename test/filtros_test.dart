import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_taller/EstadoRopa.dart';
import 'package:flutter_taller/TipoRopa.dart';
import 'package:flutter_taller/FiltroPrecio.dart';
import 'package:flutter_taller/FiltroDistancia.dart';
import 'package:flutter_taller/FiltroTipo.dart';
import 'package:flutter_taller/FiltroEstadoProducto.dart';
import 'package:test/test.dart';
import 'package:flutter_taller/Ropa.dart';
import 'package:flutter/services.dart';

/// Carga el archivo de productos json
Future<List<dynamic>> cargarJson() async {
  final String response = await rootBundle.loadString('lib/product.json');
  final data = await jsonDecode(response);
  return data;
}

/// Carga el catálogo inicial
Future<List<Ropa>> cargarProductos() async {
  List<Ropa> productos = [];
  final List<dynamic> data = await cargarJson();
  for (var producto in data) {
    productos.add(Ropa.fromJson(producto));
  }
  return productos;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // IMPORTANTE PARA EL ARCHIVO JSON
  final List<Ropa> catalogo = await cargarProductos();
  final tamCatalogo = catalogo.length;

  group("Filtros de catálogo", () {
    test("Precio esperado", () {
      FiltroPrecio filtro = FiltroPrecio();
      double precioMax = 50.0;
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, precioMax);
      // para cada prenda, comprobamos que su precio es menor o igual al máximo
      for (Ropa prenda in catalogoFiltrado) {
        expect(prenda.precio <= precioMax, true);
      }
    });

    test("Distancia esperada", () {
      FiltroDistancia filtro = FiltroDistancia();
      double distanciaMax = 10;
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, distanciaMax);
      // para cada prenda, comprobamos que su distancia es menor o igual a la máxima
      for (Ropa prenda in catalogoFiltrado) {
        expect(prenda.distancia_comp <= distanciaMax, true);
      }
    });

    test("Estado esperado", () {
      FiltroEstadoProducto filtro = FiltroEstadoProducto();
      EstadoRopa busquedaEstado = EstadoRopa.values[0];
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, busquedaEstado);
      for(Ropa prenda in catalogoFiltrado) {
        expect(prenda.estado, busquedaEstado);
      }
    });

    test("Categoria esperada", () {
      FiltroTipo filtro = FiltroTipo();
      TipoRopa categoriaRopa = TipoRopa.values[0];
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, categoriaRopa);
      for(Ropa prenda in catalogoFiltrado) {
        expect(prenda.tipo, categoriaRopa);
      }
    });

    test("Precio inválido", () {
      FiltroPrecio filtro = FiltroPrecio();
      int precioMax = 10;
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, precioMax);
      // esperamos que se devuelva un catálogo más grande que el original
      expect(catalogoFiltrado.length > tamCatalogo, true);
    });

    test("Distancia inválida", () {
      FiltroDistancia filtro = FiltroDistancia();
      int distanciaMax = 10;
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, distanciaMax);
      // esperamos que se devuelva un catálogo más grande que el original
      expect(catalogoFiltrado.length > tamCatalogo, true);
    });

    test("Estado inexistente", () {
      FiltroEstadoProducto filtro = FiltroEstadoProducto();
      TipoRopa busquedaEstado = TipoRopa.values[0];
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, busquedaEstado);
      expect(catalogoFiltrado.length > tamCatalogo, true);
    });

    test("Categoría inexistente", () {
      FiltroTipo filtro = FiltroTipo();
      EstadoRopa categoriaRopa = EstadoRopa.values[0];
      List<Ropa> catalogoFiltrado = filtro.filtrar(catalogo, categoriaRopa);
      expect(catalogoFiltrado.length > tamCatalogo, true);
    });
  });
}