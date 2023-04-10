import 'Filter.dart';
import 'EstadoRopa.dart';
import 'Ropa.dart';

class FiltroEstadoProducto extends Filter{

  @override
  List<Ropa> execute(List<Ropa> ropa, var valores) {
    List<Ropa> result = [];
    List<EstadoRopa> estados = EstadoRopa.values;
    for (var rop in ropa) {
      for(int estado in valores) {
        if (rop.estado == estados[estado]) {
          result.add(rop);
        }
      }
    }

    return result;
  }

}