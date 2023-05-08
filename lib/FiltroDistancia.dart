import 'Filter.dart';
import 'Ropa.dart';
/* 
Ropa atributos:
nombre
precio
distancia
descripcion
tipo
estado
 */

class FiltroDistancia extends Filter{

  @override
  List<Ropa> execute(List<Ropa> ropa, var valores) {
    List<Ropa> result = [];
    for (var rop in ropa) {
      if(rop.distancia_comp <= valores[0]){
        result.add(rop);
      }
    }

    return result;
  }

  @override
  List<Ropa> filtrar(List<Ropa> ropa, var valor) {
    List<Ropa> result = [];
    try {
      // comprobamos que sea estrictamente un double
      assert(valor.runtimeType==double);
      for (var prenda in ropa) {
        if (prenda.distancia_comp <= valor) {
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