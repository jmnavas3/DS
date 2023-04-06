import 'Filter.dart';
import 'TipoRopa.dart';
import 'Ropa.dart';

class FiltroTipo extends Filter{

  @override
  List<Ropa> execute(List<Ropa> ropa, var valores) {
    List<Ropa> result = [];
    for (var rop in ropa) {
      for(TipoRopa tipo in valores){
        if(rop.tipo == tipo){
          result.add(rop);
        }
      }
    }

    return result;
  }

}