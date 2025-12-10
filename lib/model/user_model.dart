// lib/model/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String idUsuario;
  final String nombre;
  final String correo;
  final String? avatar;
  final int monedas;
  final int nivel;
  final String tipoCuenta;
  final String rango;
  final String fechaRegistro;
  final Map<String, dynamic> notificaciones;

  UserModel({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    this.avatar,
    required this.monedas,
    required this.nivel,
    required this.tipoCuenta,
    required this.rango,
    required this.fechaRegistro,
    required this.notificaciones,
  });

  // --- MÉTODO PARA LEER DESDE FIRESTORE ---
  /// Crea un objeto UserModel a partir de un documento de Firestore.
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      idUsuario: doc.id, // El ID del documento es la fuente de verdad
      nombre: data['nombre'] ?? 'Sin nombre',
      correo: data['correo'] ?? '',
      avatar: data['avatar'], // Es un String?, así que puede ser nulo
      monedas: data['monedas'] ?? 0,
      nivel: data['nivel'] ?? 1,
      tipoCuenta: data['tipo_cuenta'] ?? 'free',
      rango: data['rango'] ?? 'principiante',
      fechaRegistro: data['fecha_registro'] ?? DateTime.now().toIso8601String(),
      notificaciones: data['notificaciones'] is Map
          ? Map<String, dynamic>.from(data['notificaciones'])
          : { // Valor por defecto si no existe
        "generales": true,
        "promociones": false,
        "actualizaciones": true,
        "recordatorios": true
      },
    );
  }

  // --- MÉTODO PARA LEER DESDE TU API (JSON) ---
  /// Crea un objeto UserModel a partir de un Map (normalmente de una respuesta JSON de una API).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsuario: json['id_usuario'] ?? json['idUsuario'] ?? '',
      nombre: json['nombre'] ?? 'Sin nombre',
      correo: json['correo'] ?? '',
      avatar: json['avatar'],
      monedas: json['monedas'] ?? 0,
      nivel: json['nivel'] ?? 1,
      tipoCuenta: json['tipo_cuenta'] ?? 'free',
      rango: json['rango'] ?? 'principiante',
      fechaRegistro: json['fecha_registro'] ?? DateTime.now().toIso8601String(),
      notificaciones: json['notificaciones'] is Map
          ? Map<String, dynamic>.from(json['notificaciones'])
          : {}, // Un mapa vacío como valor por defecto
    );
  }

  // --- MÉTODO PARA ESCRIBIR EN FIRESTORE (CORREGIDO) ---
  /// Convierte el objeto UserModel a un Map para guardarlo en Firestore.
  Map<String, dynamic> toMap() {
    return {
      // 'id_usuario': idUsuario, // ESTA LÍNEA SE HA ELIMINADO PARA PERMITIR ACTUALIZACIONES CORRECTAS
      'nombre': nombre,
      'correo': correo,
      'avatar': avatar,
      'monedas': monedas,
      'nivel': nivel,
      'tipo_cuenta': tipoCuenta,
      'rango': rango,
      'fecha_registro': fechaRegistro,
      'notificaciones': notificaciones,
    };
  }

  // --- MÉTODO PARA CREAR COPIAS MODIFICADAS ---
  /// Crea una copia del objeto con valores modificados.
  UserModel copyWith({
    String? idUsuario,
    String? nombre,
    String? correo,
    String? avatar,
    int? monedas,
    int? nivel,
    String? tipoCuenta,
    String? rango,
    String? fechaRegistro,
    Map<String, dynamic>? notificaciones,
  }) {
    return UserModel(
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      avatar: avatar ?? this.avatar,
      monedas: monedas ?? this.monedas,
      nivel: nivel ?? this.nivel,
      tipoCuenta: tipoCuenta ?? this.tipoCuenta,
      rango: rango ?? this.rango,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      notificaciones: notificaciones ?? this.notificaciones,
    );
  }
}
