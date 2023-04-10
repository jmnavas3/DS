import 'Target.dart';
import 'Filter.dart';
import 'Ropa.dart';


class FilterChain {
  Target _target = Target();
  List<Filter> filterList = [];


  set setTarget(Target target) => _target = target;

  // Precio, Distancia, EstadoRopa, TipoRopa
  void addFilter (Filter filtro) => filterList.add(filtro);


  List<Ropa> execute(List<Ropa> productos, List<List<dynamic>> valoresFiltros){
    List<Ropa> ropaFiltrada = productos;
    int i=0;

    // Ejecutar Filtros de la cadena
    for (Filter f in filterList) {
      if(valoresFiltros[i][0] != -1) {
        print("aplicando filtro $i: ${valoresFiltros[i][0]}");
        ropaFiltrada = f.execute(ropaFiltrada, valoresFiltros[i]);
      }
      i++;
    }

    _target.ejecutar(ropaFiltrada);
    return ropaFiltrada;
  }

}