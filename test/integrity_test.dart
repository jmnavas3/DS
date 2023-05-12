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

Future<void> widget_t(Actualizador vista,Supervisor controlador,List<Ropa> catalogoInicial) async{

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
}

Future<void> ropa_t(List<Ropa> catalogo) async{
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

Future<void> filtros_t(List<Ropa> catalogo) async{
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

void main() async{

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

  group('end-to-end test', () {
    widget_t(vista,controlador,catalogoInicial);
    ropa_t(catalogoInicial);
    filtros_t(catalogoInicial);
  });
}