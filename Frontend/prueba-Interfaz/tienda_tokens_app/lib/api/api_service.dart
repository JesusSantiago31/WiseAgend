import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:5000";

  Future<List<ProductoModel>> getProductos() async {
    final response = await http.get(Uri.parse("$baseUrl/productos"));

    if (response.statusCode != 200) {
      throw Exception("Error en la API: ${response.statusCode}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    // Validamos que exista la clave
    if (!data.containsKey("productos")) {
      throw Exception("El JSON no contiene 'productos'");
    }

    final List<dynamic> lista = data["productos"];

    // Convertimos cada entrada al modelo
    return lista.map((e) => ProductoModel.fromJson(e)).toList();
  }
}
