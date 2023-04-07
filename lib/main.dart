import 'package:flutter_taller/Actualizador.dart';

import 'Ropa.dart';
import 'TipoRopa.dart';
import 'EstadoRopa.dart';
import 'Cliente.dart';
import 'Target.dart';
import 'Filter.dart';
import 'FilterManager.dart';
import 'FilterChain.dart';
import 'FiltroDistancia.dart';
import 'FiltroEstadoProducto.dart';
import 'FiltroPrecio.dart';
import 'FiltroTipo.dart';
import 'Supervisor.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


Future<String> cargarJson() async {
  final String response = await rootBundle.loadString('lib/product.json');
  //final data = await json.decode(response);

  return response;
}

void main() async {
  runApp(const MyApp());
  // cargar JSON
  final List<dynamic> data = jsonDecode(await cargarJson());
  List<Ropa> catalogoInicial = [];
  // añadir JSON a catalogo inicial y mostrar productos
  for(var producto in data) {
    catalogoInicial.add(Ropa.fromJson(producto));
    print(catalogoInicial.last);
  }

  // Patrones MVC y Filtros de intercepción


}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Actualizador? _act;
  // Supervisor?   _sup;

  /*MyApp(Actualizador act, Supervisor sup, {Key? key}) :
      _act = act,
      _sup = sup,
      super(key: key);*/

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Json sample',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Home Page'),
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
