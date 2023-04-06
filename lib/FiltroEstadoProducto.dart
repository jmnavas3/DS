import 'Filter.dart';
import 'EstadoRopa.dart';
import 'Ropa.dart';

class FiltroEstadoProducto extends Filter{

  @override
  List<Ropa> execute(List<Ropa> ropa, var valores) {
    List<Ropa> result = [];
    for (var rop in ropa) {
      for(EstadoRopa estado in valores) {
        if (rop.estado == estado) {
          result.add(rop);
        }
      }
    }

    return result;
  }

}