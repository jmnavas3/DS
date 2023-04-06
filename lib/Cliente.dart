import 'Ropa.dart';
import 'FilterManager.dart';

class Cliente {
  late FilterManager _gestor;

  void set setGestorFiltros(FilterManager value) => _gestor = value;

  List<Ropa> buscarProducto(List<Ropa> productos, List<List<int>> valoresFiltros) =>
    _gestor.filterRequest(productos, valoresFiltros);

}
