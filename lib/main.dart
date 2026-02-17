import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart'; // Tu helper para SQLite en móvil

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> productos = [
  "Bolsas para hacer chantilly",
  "Bolsas de basura grande",
  "Queso dambo",
  "Queso cheddar",
  "Pechugas de pollo",
  "Alitas",
  "Tocino",
  "Carne molida",
  "Hot dog",
  "Jamón inglés",
  "Chorizo",
  "Pan multigrano",
  "Pan de molde blanco",
  "Croissant",
  "Ciabatta",
  "Pan hamburguesa",
  "Pan broche",
  "Papa",
  "Palta",
  "Tomate",
  "Lechuga",
  "Cebolla",
  "Apio",
  "Albaca",
  "Culantro",
  "Limón",
  "Mango",
  "Piña fresca",
  "Piña en lata",
  "Papaya",
  "Fresa fresca",
  "Fresa para waffle",
  "Plátano",
  "Lucuma",
  "Maracuyá fresca",
  "Maracuyá en caja",
  "Jugo de maracuyá",
  "Azúcar blanca",
  "Azúcar rubia",
  "Azúcar glass",
  "Azúcar impalpable",
  "Harina",
  "Avena",
  "Miel",
  "Aceite",
  "Oliva",
  "Vinagre",
  "Orégano",
  "Vainilla",
  "Huevo",
  "Leche",
  "Mantequilla",
  "Chantilly",
  "Fudge",
  "Ketchup balde",
  "Mostaza balde",
  "Salsa BBQ",
  "Salsa acevichada",
  "Salsa de tomate",
  "Jarabe de goma",
  "Jarabe de menta",
  "Jarabe de menta (duplicado corregido)",
  "Matcha",
  "Togarashi",
  "Ayudín",
  "Taper chico para llevar",
  "Bolsa papel delivery (pequeño y grande)",
  "Bolsa celofán 7x10",
  "Bolsa para llevar",
  "Vasos acrílicos",
  "Vasos de jugo transparentes 18 oz",
  "Vasito de helados",
  "Vaso de frappe",
  "Cucharitas descartables",
  "Sorbetes para jugo",
  "Cañas frappe",
  "Servilletas",
  "Papel manteca",
  "Papel toalla cocina",
  "Papel toalla baño",
  "Pañitos amarillos",
  "Galleta Oreo",
  "Rosquitas",
  "Pecanas",
  "Bouls para producción",
  "Lapicero azul o negro",
  "Cuaderno para lista",
  "Hielo",
  "Agua con gas",
  "Agua sin gas",
  "Coca Cola",
  "Inca Kola",
];

  Set<String> productosMarcados = {};
  List<Map<String, String>> registrosPendientes = []; // 👈 lista temporal

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Diario',
      theme: ThemeData(
        primaryColor: Color(0xFF6B4226),
        scaffoldBackgroundColor: Color(0xFFF5E6D3),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6B4226),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6B4226),
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFFA3B18A)),
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Inventario Diario"),
              actions: [
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () async {
                    final fechas = kIsWeb
                        ? await _obtenerFechasWeb()
                        : await DatabaseHelper.obtenerFechasDisponibles();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InventariosScreen(fechas: fechas),
                      ),
                    );
                  },
                )
              ],
            ),
            body: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                final marcado = productosMarcados.contains(producto);

                return Card(
                  child: ListTile(
                    leading: Icon(
                      marcado ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: marcado ? Color(0xFFA3B18A) : Colors.grey,
                    ),
                    title: Text(producto),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: marcado
                              ? null
                              : () {
                                  setState(() {
                                    productosMarcados.add(producto);
                                    registrosPendientes.add({
                                      'producto': producto,
                                      'cantidad': "0",
                                      'unidad': "Se acabó",
                                    });
                                  });
                                },
                          child: Text("Se acabó"),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: marcado
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final cantidadController = TextEditingController();
                                      final unidadController = TextEditingController();
                                      return AlertDialog(
                                        title: Text("Registrar cantidad de $producto"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: cantidadController,
                                              decoration: InputDecoration(labelText: "Cantidad"),
                                              keyboardType: TextInputType.number,
                                            ),
                                            TextField(
                                              controller: unidadController,
                                              decoration: InputDecoration(labelText: "Unidad (ej: kilos, litros)"),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Cancelar"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              final cantidad = cantidadController.text;
                                              final unidad = unidadController.text;
                                              setState(() {
                                                productosMarcados.add(producto);
                                                registrosPendientes.add({
                                                  'producto': producto,
                                                  'cantidad': cantidad,
                                                  'unidad': unidad,
                                                });
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("Guardar"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                          child: Text("Queda"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final fecha = DateTime.now().toIso8601String();
                if (kIsWeb) {
                  await _guardarInventarioWeb(fecha, registrosPendientes);
                  registrosPendientes.clear();
                  final registros = await _obtenerInventariosWeb();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorialScreen(registros: registros),
                    ),
                  );
                } else {
                  for (var r in registrosPendientes) {
                    await DatabaseHelper.insertarRegistro(
                      r['producto']!,
                      r['cantidad']!,
                      r['unidad']!,
                      fecha,
                    );
                  }
                  registrosPendientes.clear();
                  final registros = await DatabaseHelper.obtenerRegistros();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorialScreen(registros: registros),
                    ),
                  );
                }
              },
              label: Text("Listo"),
              icon: Icon(Icons.save),
              backgroundColor: Color(0xFF6B4226),
              foregroundColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  // Métodos para Web usando SharedPreferences
  Future<void> _guardarInventarioWeb(String fecha, List<Map<String, String>> registros) async {
    final prefs = await SharedPreferences.getInstance();
    final inventarios = prefs.getStringList('inventarios') ?? [];
    final inventario = registros.map((r) => "${r['producto']}|${r['cantidad']}|${r['unidad']}").join(';');
    inventarios.add("$fecha::$inventario");
    await prefs.setStringList('inventarios', inventarios);
  }

  Future<List<Map<String, dynamic>>> _obtenerInventariosWeb() async {
    final prefs = await SharedPreferences.getInstance();
    final inventarios = prefs.getStringList('inventarios') ?? [];
    List<Map<String, dynamic>> resultado = [];
    for (var inv in inventarios) {
      final partes = inv.split("::");
      final fecha = partes[0];
      final productos = partes[1].split(';');
      for (var p in productos) {
        final datos = p.split('|');
        resultado.add({
          'producto': datos[0],
          'cantidad': datos[1],
          'unidad': datos[2],
          'fecha': fecha,
        });
      }
    }
    return resultado;
  }

  Future<List<String>> _obtenerFechasWeb() async {
    final prefs = await SharedPreferences.getInstance();
    final inventarios = prefs.getStringList('inventarios') ?? [];
    return inventarios.map((inv) => inv.split("::")[0]).toList();
  }
}

// Pantalla para mostrar historial completo
class HistorialScreen extends StatelessWidget {
  final List<Map<String, dynamic>> registros;

  HistorialScreen({required this.registros});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial Guardado")),
      body: ListView.builder(
        itemCount: registros.length,
        itemBuilder: (context, index) {
          final r = registros[index];
          return Card(
            child: ListTile(
              title: Text("${r['producto']} - ${r['cantidad']} ${r['unidad']}"),
              subtitle: Text("Fecha: ${r['fecha']}"),
            ),
          );
        },
      ),
    );
  }
}

// Pantalla para mostrar inventarios guardados por día
class InventariosScreen extends StatelessWidget {
  final List<String> fechas;

  InventariosScreen({required this.fechas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inventarios Guardados")),
      body: ListView.builder(
        itemCount: fechas.length,
        itemBuilder: (context, index) {
          final fecha = fechas[index];
          return ListTile(
            title: Text("Inventario del $fecha"),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final inventarios = prefs.getStringList('inventarios') ?? [];
              List<Map<String, dynamic>> registros = [];
              for (var inv in inventarios) {
                final partes = inv.split("::");
                if (partes[0] == fecha) {
                  final productos = partes[1].split(';');
                  for (var p in productos) {
                    final datos = p.split('|');
                    registros.add({
                      'producto': datos[0],
                      'cantidad': datos[1],
                      'unidad': datos[2],
                      'fecha': fecha,
                    });
                  }
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistorialScreen(registros: registros),
                ),
              );
            },
          );
        },
      ),
    );
  }
}