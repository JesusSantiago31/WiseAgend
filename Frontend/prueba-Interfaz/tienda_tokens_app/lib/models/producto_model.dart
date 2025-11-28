class ProductoModel {
  final String id;
  final String title;
  final String subtitle;
  final int cost;
  final bool locked;
  final bool premium;
  final String category;
  final int vencimiento;

  ProductoModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cost,
    required this.vencimiento,
    this.locked = true,
    this.premium = false,
    this.category = 'General',
  });

   factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      id: json["id_producto"] ?? "",
      title: json["nombre"] ?? "",
      subtitle: json["descripcion"] ?? "",
      cost: json["costo"] ?? 0,
      locked: !(json["canjeado"] ?? false),
      premium: json["premium"] ?? false,
      category: json["tipo"] ?? "",
      vencimiento: json["vencimiento"] ?? 1,
    );
  }
}