import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";

  final String authToken;

  ApiService({required this.authToken});

  // -----------------------------
  // OBTENER PRODUCTOS
  // -----------------------------
  Future<List<ProductoModel>> getProductos() async {
    final response = await http.get(
      Uri.parse("$baseUrl/productos"),
      headers: {
        "Authorization": "Bearer $authToken",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error en la API: ${response.statusCode}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (!data.containsKey("productos")) {
      throw Exception("El JSON no contiene 'productos'");
    }

    final List<dynamic> lista = data["productos"];
    return lista.map((e) => ProductoModel.fromJson(e)).toList();
  }

  // -----------------------------
  // COMPRAR PRODUCTO
  // -----------------------------
  Future<Map<String, dynamic>> comprarProducto({
    required String idUsuario,
    required String idProducto,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/comprar"),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode({
        "id_usuario": idUsuario,
        "id_producto": idProducto,
      }),
    );

    return jsonDecode(response.body);
  }

  // -----------------------------
  // OBTENER USUARIO LOGUEADO
  // -----------------------------
  Future<Map<String, dynamic>> getUsuario() async {
    final response = await http.get(
      Uri.parse("$baseUrl/usuario/me"),
      headers: {
        "Authorization": "Bearer $authToken",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Error obteniendo usuario");
    }

    return jsonDecode(response.body);
  }
}
