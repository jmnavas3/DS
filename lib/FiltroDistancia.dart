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

}