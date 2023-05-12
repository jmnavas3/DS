// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_taller/myLib.dart';
import 'dart:convert';

import 'package:flutter_taller/main.dart';

Future<String> cargarJson() async {
  final String response = await rootBundle.loadString('lib/product.json');
  //final data = await json.decode(response);
  return response;
}

void main() async {
  // MVC y FILTROS DE INTERCEPCIÓN
  Cliente cliente = Cliente();
  Target target = Target();
  FilterManager gestor = FilterManager.constructor(target);

  gestor.setFilter = FiltroPrecio();
  gestor.setFilter = FiltroDistancia();
  gestor.setFilter = FiltroEstadoProducto();
  gestor.setFilter = FiltroTipo();
  cliente.setGestorFiltros = gestor;

  // CATÁLOGOS
  List<Ropa> catalogoInicial = [];

  TestWidgetsFlutterBinding.ensureInitialized(); // IMPORTANTE PARA QUE NO DE ERROR
  final List<dynamic> data = jsonDecode(await cargarJson());
  for(var producto in data) {
  catalogoInicial.add(Ropa.fromJson(producto));
  }

  Supervisor controlador = Supervisor(cliente, catalogoInicial);
  Actualizador vista = Actualizador(target, catalogoInicial);

  controlador.aplicarFiltros(catalogoInicial);

  testWidgets('Comprar producto y volver a catalogo', (WidgetTester tester) async {
    // definimos las dimensiones de la pantalla para que no haya ningún elemento oculto
    tester.binding.window.physicalSizeTestValue = const Size(720,1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MyApp(vista, controlador));
    final compras = find.text("Comprar producto");
    expect(compras, findsNWidgets(catalogoInicial.length));

    await tester.tap(find.byType(ElevatedButton).last);
    await tester.pumpAndSettle();
    final comprado = find.byType(ElevatedButton);
    expect(comprado, findsOneWidget);

    await tester.tap(comprado);
    await tester.pumpAndSettle();
    expect(compras, findsNWidgets(catalogoInicial.length));
  });

  testWidgets('Cambiar valor slider y comprobar productos', (WidgetTester tester) async {
    // definimos las dimensiones de la pantalla para que no haya ningún elemento oculto
    tester.binding.window.physicalSizeTestValue = const Size(720,1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MyApp(vista, controlador));
    final precioSlider = find.byKey(ValueKey('filtroPrecio'));
    await tester.drag(precioSlider, const Offset(-200, 0)); // Ajusto el precio a 20e
    await tester.pumpAndSettle(); // aplicao el filtro

    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();
    final comprado = find.text("Comprar producto");
    expect(comprado, findsOneWidget);
  });

}
