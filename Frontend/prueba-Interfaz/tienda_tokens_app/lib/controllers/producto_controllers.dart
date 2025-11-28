import '../api/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';

class ProductosController {
  final ApiService api = ApiService();

  Future<List<dynamic>> cargarProductos() {
    return api.getProductos();
  }
}

class ApiService {
  final String baseUrl = "http://127.0.0.1:5000";

  Future<List<ProductoModel>> getProductos() async {
    final resp = await http.get(Uri.parse("$baseUrl/productos"));

    if (resp.statusCode != 200) {
      throw Exception("Error del servidor");
    }

    final data = jsonDecode(resp.body);

    List productosJson = data["productos"];

    return productosJson
        .map((item) => ProductoModel.fromJson(item))
        .toList();
  }
}