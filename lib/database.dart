import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Abrir o crear la base de datos
  static Future<Database> openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'inventario.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE registros(id INTEGER PRIMARY KEY AUTOINCREMENT, producto TEXT, cantidad TEXT, unidad TEXT, fecha TEXT)",
        );
      },
      version: 1,
    );
  }

  // Insertar un registro nuevo
  static Future<void> insertarRegistro(String producto, String cantidad, String unidad) async {
    final db = await openDB();
    await db.insert(
      'registros',
      {
        'producto': producto,
        'cantidad': cantidad,
        'unidad': unidad,
        'fecha': DateTime.now().toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los registros guardados
  static Future<List<Map<String, dynamic>>> obtenerRegistros() async {
    final db = await openDB();
    return db.query('registros', orderBy: "fecha DESC");
  }

  // Obtener registros filtrados por fecha (ej: "2026-02-16")
  static Future<List<Map<String, dynamic>>> obtenerRegistrosPorFecha(String fecha) async {
    final db = await openDB();
    return db.query(
      'registros',
      where: "fecha LIKE ?",
      whereArgs: ["$fecha%"],
      orderBy: "fecha DESC",
    );
  }

  // Obtener lista de fechas distintas con inventarios guardados
  static Future<List<String>> obtenerFechasDisponibles() async {
    final db = await openDB();
    final result = await db.rawQuery(
        "SELECT DISTINCT substr(fecha, 1, 10) as dia FROM registros ORDER BY dia DESC");
    return result.map((row) => row['dia'] as String).toList();
  }

  // Borrar todos los registros (opcional, para limpiar historial)
  static Future<void> borrarRegistros() async {
    final db = await openDB();
    await db.delete('registros');
  }
}