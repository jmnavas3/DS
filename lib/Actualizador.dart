import 'Ropa.dart';
import 'Target.dart';
import 'main.dart';
import 'package:flutter/material.dart';

class Actualizador {
  Target? _target;
  List<Ropa> _catalogoFinal = [];


  Actualizador (Target target, List<Ropa> catalogoInicial) {
    _target=target;
    _catalogoFinal=catalogoInicial;
  }

  set target(Target target) => _target = target;

  void actualizarProductos() {
    if (_target!.catalogoFinal.isNotEmpty) {
      _catalogoFinal = _target!.catalogoFinal;
    }else{
      print("no se han encontrado productos");
      _catalogoFinal = [];
    }
  }

  List<Ropa> get catalogo => _catalogoFinal;

  List<Ropa> getFiltrados() {
    actualizarProductos();
    return _catalogoFinal;
  }

  // Widget para mostrar lista de productos
  List<Widget> getProductosFiltrados () {
    List<Widget> widgetList = [];
    Widget aux;

    actualizarProductos();
    for (Ropa ropa in _catalogoFinal) {
      aux = Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "${ropa.nombre}(${ropa.precioString})",
              style : const TextStyle( fontWeight: FontWeight.bold )
            ),
            Text("Está a ${ropa.distString}"),
            Text(
              ropa.descripcion,
              style: const TextStyle( fontStyle: FontStyle.italic )
            ),
            Text("Estado"),
            Text("${ropa.estadoRopa}"),
            Text("Tipo:"),
            Text("${ropa.tipoRopa}"),
          ],
        ),
      );

      widgetList.add(aux);
    }

    return widgetList;
  }
}