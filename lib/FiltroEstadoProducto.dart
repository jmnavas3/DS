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

  @override
  List<Ropa> filtrar(List<Ropa> ropa, var valor) {
    List<Ropa> result = [];
    try {
      // comprobamos que sea estrictamente un double
      assert(valor.runtimeType==EstadoRopa);
      for (var prenda in ropa) {
        if (prenda.estado == valor) {
          result.add(prenda);
        }
      }
    } catch (e) {
      result = ropa;
      result.add(ropa.last);
      print("Error: $e");
    }

    return result;
  }

}