import 'package:flutter/services.dart';

import 'package:flutter_taller/Actualizador.dart';
import 'Ropa.dart';
import 'TipoRopa.dart';
import 'EstadoRopa.dart';
import 'Cliente.dart';
import 'Target.dart';
import 'FilterManager.dart';
import 'FiltroDistancia.dart';
import 'FiltroEstadoProducto.dart';
import 'FiltroPrecio.dart';
import 'FiltroTipo.dart';
import 'Supervisor.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


Future<String> cargarJson() async {
  final String response = await rootBundle.loadString('lib/product.json');
  //final data = await json.decode(response);
  return response;
}

void main() async {
  // MVC y FILTROS DE INTERCEPCIÓN
  Cliente cliente = Cliente();
  Target target = Target();
  FilterManager gestor = FilterManager.constructor(target);

  gestor.setFilter = FiltroPrecio();
  gestor.setFilter = FiltroDistancia();
  gestor.setFilter = FiltroEstadoProducto();
  gestor.setFilter = FiltroTipo();
  cliente.setGestorFiltros = gestor;

  // CATÁLOGOS
  List<Ropa> catalogoInicial = [];

  WidgetsFlutterBinding.ensureInitialized(); // IMPORTANTE PARA QUE NO DE ERROR
  final List<dynamic> data = jsonDecode(await cargarJson());
  for(var producto in data) {
    catalogoInicial.add(Ropa.fromJson(producto));
  }

  Supervisor controlador = Supervisor(cliente, catalogoInicial);
  Actualizador vista = Actualizador(target, catalogoInicial);

  controlador.aplicarFiltros(catalogoInicial);


  // INTERFAZ DE FLUTTER
  runMyApp(vista, controlador);
  //runApp(MyApp(vista, controlador));
}

Future<void> runMyApp(Actualizador a, Supervisor s) {
  return Future.delayed(const Duration(seconds: 2), () => runApp(MyApp(a,s)));
}



class MyApp extends StatelessWidget {
  Supervisor _controlador;
  Actualizador _vista;

  // CONSTRUCTOR
  MyApp(Actualizador v, Supervisor c, {Key? key}) :
      _vista = v,
      _controlador = c,
      super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Filter sample',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.red,
      ),
      home: MyShopPage('Shop Page', _vista, _controlador),
    );
  }
}


class MyShopPage extends StatefulWidget {
  String title;
  Actualizador _vista;
  Supervisor _controlador;

  MyShopPage(this.title, Actualizador v, Supervisor c, {Key? key}) :
      _vista = v,
      _controlador = c,
      super(key: key);

  @override
  State<MyShopPage> createState() => _MyShopPageSate();
}



class _MyShopPageSate extends State<MyShopPage> {
  int _precioActual = 0, _distActual = 0;
  String? _tipo = null, _estado = null;
  final _tiposProductos = Ropa.listaRopa();
  final _estadosProductos = Ropa.listaEstado();

  // MÉTODOS PARA SELECCIONAR Y MODIFICAR FILTROS
   // 0 PRECIO, 1 DISTANCIA
  void _selecPrecioDist (int index) {
    int valorFiltro;
    if (index==0) {
      valorFiltro = _precioActual==0 ? -1 : _precioActual;
    } else {
      valorFiltro = _distActual==0 ? -1 : _distActual;
    }
    widget._controlador.modificarFiltro(index, [valorFiltro]);
  }
   // 2 ESTADO ROPA, 3 TIPO ROPA
  void _selecEstadoTipo (int index) {
    int i = 0;
    var filtro = index==3 ? TipoRopa.values : EstadoRopa.values;
    var value  = index==3 ? _tipo : _estado;

    for (var prenda in filtro) {
      if ( value == Ropa.enumAString(prenda) ) {
        widget._controlador.modificarFiltro(index, [i]);
      }
      i++;
    }
  }
   // 0 PRECIO, 1 DISTANCIA, 2 ESTADO, 3 TIPO
  void _selecFiltro (int index) => (index < 2) ? _selecPrecioDist(index) : _selecEstadoTipo(index);

  // APLICAR FILTROS INTERCEPCIÓN
  void _aplicarFiltros () {
    const int numFiltros = 4;
    setState(() {
      for (int i=0; i<numFiltros; i++) {
        _selecFiltro(i);
      }
      widget._controlador.aplicarFiltros(widget._controlador.catalogoInicial);
    });
  }

  // WIDGET
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top:2, bottom:2, right:10, left:10),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 200, 186, 220),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),

                child: Column(
                  children: <Widget>[

                    const Text("Precio menor que: "),
                    Slider(
                      key: const Key ('filtroPrecio'),
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: "$_precioActual",
                      value: _precioActual.toDouble(),
                      onChanged: (value) {
                        setState(() => _precioActual = value.toInt());
                      },
                    ),

                    const Text("Distancia menor que: "),
                    Slider(
                      key: const Key('filtroDistancia'),
                      min: 0, max: 100, divisions: 10,
                      label: "$_distActual",
                      value: _distActual.toDouble(),
                      onChanged: (value) {
                        setState( () => _distActual = value.toInt());
                      },
                    ),

                    const Text("Estado nuevo: "),
                    DropdownButton(
                      value: _estado,
                      items: _estadosProductos.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items)
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState( () => _estado=value );
                      },
                    ),

                    const Text("Tipo: "),
                    DropdownButton(
                      value: _tipo,
                      items: _tiposProductos.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items)
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState( () => _tipo=value );
                      },
                    ),

                    SizedBox(
                      child: ElevatedButton(
                        onPressed: _aplicarFiltros,
                        child: const Text('Aplicar filtros'),
                      ),
                    )

                  ],
                ),
              ),

              for (Widget filtrada in widget._vista.getProductosFiltrados() )
                Container(
                  margin: const EdgeInsets.only(top:2.5, bottom:2.5, right:10, left:10),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 198, 177, 233),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),

                  child: Column(
                    children: <Widget>[
                      filtrada,
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Compra()),
                          );
                        },
                        child: const Text("Comprar producto"),
                      )
                    ],
                  ),
                ),


            ],
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem (Enum item) =>
      DropdownMenuItem(
        value: Ropa.enumAString(item),
        child: Text( Ropa.enumAString(item) )
      );

} // _MyShopPageState


class Compra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compra")
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Text("Compra finalizada."),
            ElevatedButton(
                onPressed: () { Navigator.pop(context); },
                child: const Text("Volver a página principal"),
            )
          ],
        ),
      ),
    );
  }
}


// Aplicación Básica de Flutter
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List _items = [];

  // fetch content from the json File
  // source: https://stackoverflow.com/questions/71294190/how-to-read-local-json-file-in-flutter
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/product.json');
    final data = await json.decode(response);
    setState(() {
      _items = data;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // JSON
            ElevatedButton(onPressed: readJson, child: const Text('Cargar Archivo')),
            _items.isNotEmpty? Expanded(
                child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Text("${_items[index]["precio"]} €"),
                          title: Text(_items[index]["nombre"]),
                          subtitle: Text(_items[index]["descripcion"]),
                        ),
                      );
                    },
                ),
            )
            : Container(),
            // DEFAULT
            const Text(
              'You have clicked the plus button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// PRUEBA
// STATEFUL --> State<STATEFUL>
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidget();
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build (BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration( hintText: 'Introducir ropa'),
            validator: (String? value) {
              if(value==null || value.isEmpty) return 'No has escrito nada';
              return null;
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                child: const Text('Confirmar'),
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    // ENVIAR A CONTROLADOR
                  }
                },
              )
          )
        ],
      ),
    );
  }
}
