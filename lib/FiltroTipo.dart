import 'Filter.dart';
import 'TipoRopa.dart';
import 'Ropa.dart';

class FiltroTipo extends Filter{

  @override
  List<Ropa> execute(List<Ropa> ropa, var valores) {
    List<Ropa> result = [];
    List<TipoRopa> tipos = TipoRopa.values;
    for (var rop in ropa) {
      for(int tipo in valores){
        if(rop.tipo == tipos[tipo]){
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
      assert(valor.runtimeType==TipoRopa);
      for (var prenda in ropa) {
        if (prenda.tipo == valor) {
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