import 'package:flutter_taller/TipoRopa.dart';

import 'Cliente.dart';
import 'Ropa.dart';

class Supervisor {
  // atributos
  final           _numFiltros = 4;
  late Cliente    _cliente;               // late indica que se inicializará después
  List<Ropa>      _catalogoInicial = [];
  List<List<dynamic>> matrizFiltros = [];    // guarda arrays de filtros

  // getter
  List<Ropa> get catalogoInicial => _catalogoInicial;

  // constructor
  Supervisor (Cliente cli, List<Ropa> catalogo) {
    _cliente = cli;
    _catalogoInicial = catalogo;
    for (var i=0; i<_numFiltros; i++) {
      matrizFiltros.add(List.filled(1, -1));
    }
  }

  // modifica un único filtro
  void modificarFiltro(int index, var lista){
    //index: 0 Precio, 1 Distancia, 2 Estado, 3 Tipo
    if(index < _numFiltros) {
      matrizFiltros[index] = lista;
    }
  }

  // modifica la matriz de filtros
  void modificarFiltros(List<List<int>> nuevaMatriz){
    if(nuevaMatriz.length == _numFiltros) {
      matrizFiltros = nuevaMatriz;
    }
  }

  void aplicarFiltros(List<Ropa> catalogo){
    _cliente.buscarProducto (catalogo, matrizFiltros);
    
  }

}