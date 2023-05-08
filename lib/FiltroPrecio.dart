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

  @override
  List<Ropa> filtrar(List<Ropa> ropa, var valor) { // valor: double
    List<Ropa> result = [];
    try {
      // comprobamos que sea estrictamente un double
      assert(valor.runtimeType==double);
      for (var prenda in ropa) {
        if (prenda.precio <= valor) {
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