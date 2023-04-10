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
    _filterChain = FilterChain();
    _filterChain.setTarget = target;
  }

  List<Ropa> filterRequest(List<Ropa> productos, List<List<dynamic>> valoresFiltro) =>
    _filterChain.execute(productos, valoresFiltro);

  set setFilter (Filter f) => _filterChain.addFilter(f);

}