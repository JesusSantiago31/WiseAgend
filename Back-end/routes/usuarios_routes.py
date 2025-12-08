from flask import Blueprint, jsonify, request
from utils import verificar_token, actualizar_productos_usuario

usuarios_bp = Blueprint("usuarios_bp", __name__)

@usuarios_bp.get("/usuario/<id_usuario>/productos")
def productos_usuario(id_usuario):

    if not verificar_token(request):
        return jsonify({"error": "Token inválido"}), 401

    productos = actualizar_productos_usuario(id_usuario)

    return jsonify({"productos_vigentes": productos}), 200
