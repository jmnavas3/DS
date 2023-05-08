import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_taller/EstadoRopa.dart';
import 'package:flutter_taller/TipoRopa.dart';
import 'package:test/test.dart';
import 'package:flutter_taller/Ropa.dart';
// necesario para cargar el json
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

/// Grupos de pruebas del catálogo y de la ropa
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // IMPORTANTE PARA EL ARCHIVO JSON
  List<Ropa> catalogo = await cargarProductos();

  group('Gestión de Catálogo', () {
    test('se deben poder añadir productos nuevos al catálogo', () {
      Ropa productoNuevo = Ropa("Sobrecamisa PullBear", "una bonita prenda", 20.0, 5.0, TipoRopa.sobrecamisa, EstadoRopa.nuevo);
      catalogo.add(productoNuevo);
      expect(catalogo.last, productoNuevo);
    });

    test('se deben poder modificar los productos del catálogo', () {
      List<dynamic> nuevoValor = [EstadoRopa.roto, TipoRopa.falda, 15.0, "descripcion modificada"];
      catalogo[0].estado      = nuevoValor[0];
      catalogo[1].tipo        = nuevoValor[1];
      catalogo[2].precio      = nuevoValor[2];
      catalogo[3].descripcion = nuevoValor[3];
      // comprobamos cada modificación
      expect(catalogo[0].estado, EstadoRopa.roto);
      expect(catalogo[1].tipo, TipoRopa.falda);
      expect(catalogo[2].precio, 15.0);
      expect(catalogo[3].descripcion, "descripcion modificada");
    });

    test('se deben poder borrar productos del catálogo', () {
      int tam = catalogo.length;
      catalogo.removeAt(2);
      expect(catalogo.length, tam-1);
    });
  });
}