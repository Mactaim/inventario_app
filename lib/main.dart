import 'package:flutter/material.dart';
import 'database.dart'; // Importamos la base de datos

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Lista de productos actualizada y depurada
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
    "Inca Kola"
  ];

  // Set para marcar productos ya registrados
  Set<String> productosMarcados = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario Diario',
      theme: ThemeData(
        primaryColor: Color(0xFF6B4226), // Marrón café
        scaffoldBackgroundColor: Color(0xFFF5E6D3), // Fondo beige claro
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF6B4226), // Barra superior marrón
          foregroundColor: Colors.white, // Texto blanco
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6B4226), // Botones marrón
            foregroundColor: Colors.white, // Texto blanco
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFA3B18A), // Verde suave para íconos
        ),
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
                    final fechas = await DatabaseHelper.obtenerFechasDisponibles();
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
                                  DatabaseHelper.insertarRegistro(producto, "0", "Se acabó");
                                  setState(() {
                                    productosMarcados.add(producto);
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
                                              DatabaseHelper.insertarRegistro(producto, cantidad, unidad);
                                              setState(() {
                                                productosMarcados.add(producto);
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
                final registros = await DatabaseHelper.obtenerRegistros();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistorialScreen(registros: registros),
                  ),
                );
              },
              label: Text("Listo"),
              icon: Icon(Icons.save),
              backgroundColor: Color(0xFF6B4226), // Botón flotante marrón
              foregroundColor: Colors.white,
            ),
          );
        },
      ),
    );
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
              final registros = await DatabaseHelper.obtenerRegistrosPorFecha(fecha);
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