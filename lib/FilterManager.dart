import 'FilterChain.dart';
import 'Target.dart';
import 'Ropa.dart';
import 'Filter.dart';


class FilterManager {

  late FilterChain _filterChain;

  FilterManager() {
    _filterChain = FilterChain();
  }

  FilterManager.constructor(Target target){
    FilterManager();
    _filterChain.setTarget = target;
  }

  List<Ropa> filterRequest(List<Ropa> productos, List<List<int>> valoresFiltro) =>
    _filterChain.execute(productos, valoresFiltro);

  set setFilter (Filter f) => _filterChain.addFilter(f);

}