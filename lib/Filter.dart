import 'Ropa.dart';

abstract class Filter{
  List<Ropa> execute(List<Ropa> ropa, var valores);
}