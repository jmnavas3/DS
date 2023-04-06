import 'Ropa.dart';


class Target {
  List<Ropa> _catalogoFinal = List<Ropa>.empty();

  List<Ropa> get catalogoFinal => _catalogoFinal;

  void ejecutar (List<Ropa> productos) {
    _catalogoFinal = productos;
    for (Ropa i in productos) {
      print(i);
    }
  }

}