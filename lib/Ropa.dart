import 'TipoRopa.dart';
import 'EstadoRopa.dart';

class Ropa {
  String _nombre ='';
  String _descripcion = '';
  double _precio = 0;
  double _distancia_comp = 0;
  late TipoRopa _tipo;
  late EstadoRopa _estado;

  // constructor fromJson
  Ropa.fromJson( Map<String, dynamic> json) {
    _nombre         = json['nombre'];
    _descripcion    = json['descripcion'];
    _precio         = json['precio'];
    _distancia_comp = json['distancia'];
    _tipo           = setTipoJson(json['tipo']);
    _estado         = setEstadoJson(json['estado']);
  }

  // toJson
  Map<String, dynamic> toJson ( ) => {
    'nombre' : _nombre,
    'descripcion' : _descripcion,
    'precio' : _precio,
    'distancia' : _distancia_comp,
    'tipo' : tipoRopa,
    'estado' : estadoRopa
  };

  // Pasar de enum a String
  static List<String> listaRopa(){
    List<String> listado = [];
    for (var element in TipoRopa.values) { listado.add(enumAString(element)); }
    return listado;
  }
  static String enumAString (var value) => value.toString().split('.').last;
  String enumToString (var value) => value.toString().split('.').last;

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

  TipoRopa setTipoJson(String value) {
    TipoRopa nuevoTipo = TipoRopa.botas;
    for (TipoRopa prenda in TipoRopa.values) {
      if (value == enumToString(prenda)) {
        nuevoTipo = prenda;
      }
    }
    return nuevoTipo;
  }

  EstadoRopa setEstadoJson(String value) {
    EstadoRopa nuevoEstado = EstadoRopa.nulo;
    for (EstadoRopa estado in EstadoRopa.values) {
      if (value == enumToString(estado)) {
        nuevoEstado = estado;
      }
    }
    return nuevoEstado;
  }
  //Print
  @override
  String toString() =>
      "- $nombre ($precioString):\n$descripcion\n"
          "Tipo: $tipoRopa. Estado: $estadoRopa. Distancia: $distancia_comp km de ti.\n";

}