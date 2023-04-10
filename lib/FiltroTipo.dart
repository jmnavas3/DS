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

}