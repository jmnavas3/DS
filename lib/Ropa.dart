import 'TipoRopa.dart';
import 'EstadoRopa.dart';

class Ropa {
  String _nombre ='';
  String _descripcion = '';
  double _precio = 0;
  double _distancia_comp = 0;
  late TipoRopa _tipo;
  late EstadoRopa _estado;

  // getters
  String get nombre => _nombre;
  String get descripcion => _descripcion;
  String get estadoRopa => _estado.toString().split('.').last;
  String get tipoRopa => _tipo.toString().split('.').last;
  String get precioString => _precio.toString() + "€";
  String get distString => _distancia_comp.toString() + "km de ti";
  double get precio => _precio;
  double get distancia_comp => _distancia_comp;
  TipoRopa   get tipo => _tipo;
  EstadoRopa get estado => _estado;

  // Setters
  set nombre(String value) => _nombre = value;
  set descripcion(String value) => _descripcion = value;
  set precio(double value) => _precio = value;
  set distancia_comp(double value) => _distancia_comp = value;
  set tipo(TipoRopa value) => _tipo = value;
  set estado(EstadoRopa value) => _estado = value;

  //Print
  @override
  String toString() =>
      "- $nombre ($precio):\n$descripcion\n"
          "Tipo: $tipoRopa. Estado: $estadoRopa. Distancia: $distancia_comp km de ti.\n";

}