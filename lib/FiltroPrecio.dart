import 'Filter.dart';
import 'Ropa.dart';

class FiltroPrecio extends Filter{

  @override
  List<Ropa> execute(List<Ropa> ropa, var valores) { // valores: List<int>
    List<Ropa> result = [];
    for (var rop in ropa) {
      if(rop.precio <= valores[0]){
        result.add(rop);
      }
    }
    return result;
  }

}