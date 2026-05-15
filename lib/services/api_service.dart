import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://tfg-production-5844.up.railway.app/api';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('TOKEN GUARDADO: $token');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> headers() async {
    final token = await getToken();
    print('TOKEN ENVIADO: $token');

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('LOGIN status: ${response.statusCode}');
    print('LOGIN body: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await saveToken(data['token']);
      return data;
    }

    throw Exception(data['message'] ?? 'Error login');
  }

  static Future<Map<String, dynamic>> register({
    required String nombre,
    required String dni,
    required String email,
    required String password,
    required String cif,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'dni': dni,
        'email': email,
        'password': password,
        'cif': cif,
      }),
    );

    print('REGISTER status: ${response.statusCode}');
    print('REGISTER body: ${response.body}');

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await saveToken(data['token']);
      return data;
    }

    throw Exception(data['message'] ?? 'Error registro');
  }

  static Future<List<dynamic>> getAlmacenes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/almacenes'),
      headers: await headers(),
    );

    print('GET almacenes status: ${response.statusCode}');
    print('GET almacenes body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Error cargando almacenes: ${response.statusCode} - ${response.body}',
    );
  }

  static Future<void> crearAlmacen({
    required String direccion,
    required String provincia,
    required String pais,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/almacenes'),
      headers: await headers(),
      body: jsonEncode({
        'direccion': direccion,
        'provincia': provincia,
        'pais': pais,
      }),
    );

    print('POST almacenes status: ${response.statusCode}');
    print('POST almacenes body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception(
        'Error creando almacén: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<List<dynamic>> getProductos(int idAlmacen) async {
    final response = await http.get(
      Uri.parse('$baseUrl/almacenes/$idAlmacen/productos'),
      headers: await headers(),
    );

    print('GET productos status: ${response.statusCode}');
    print('GET productos body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      'Error cargando productos: ${response.statusCode} - ${response.body}',
    );
  }

  static Future<void> crearProducto({
    required int idAlmacen,
    required String nombre,
    required int cantidad,
    required double precio,
    required int stockMinimo,
    required String codigoBarras,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/productos'),
      headers: await headers(),
      body: jsonEncode({
        'id_almacen': idAlmacen,
        'nombre': nombre,
        'cantidad': cantidad,
        'precio': precio,
        'stock_minimo': stockMinimo,
        'codigo_barras': codigoBarras,
      }),
    );

    print('POST producto status: ${response.statusCode}');
    print('POST producto body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception(
        'Error creando producto: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<void> borrarProducto(int idProducto) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/productos/$idProducto'),
      headers: await headers(),
    );

    print('DELETE producto status: ${response.statusCode}');
    print('DELETE producto body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Error borrando producto: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<void> editarAlmacen({
    required int idAlmacen,
    required String direccion,
    required String provincia,
    required String pais,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/almacenes/$idAlmacen'),
      headers: await headers(),
      body: jsonEncode({
        'direccion': direccion,
        'provincia': provincia,
        'pais': pais,
      }),
    );

    print('PUT almacén status: ${response.statusCode}');
    print('PUT almacén body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Error al editar almacén: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<void> borrarAlmacen(int idAlmacen) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/almacenes/$idAlmacen'),
      headers: await headers(),
    );

    print('DELETE almacén status: ${response.statusCode}');
    print('DELETE almacén body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Error al borrar almacén: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<void> editarProducto({
    required int idProducto,
    required String nombre,
    required int cantidad,
    required double precio,
    required int stockMinimo,
    required String codigoBarras,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/productos/$idProducto'),
      headers: await headers(),
      body: jsonEncode({
        'nombre': nombre,
        'cantidad': cantidad,
        'precio': precio,
        'stock_minimo': stockMinimo,
        'codigo_barras': codigoBarras,
      }),
    );

    print('PUT producto status: ${response.statusCode}');
    print('PUT producto body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Error editando producto: ${response.statusCode} - ${response.body}',
      );
    }
  }
}