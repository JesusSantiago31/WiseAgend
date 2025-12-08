from flask import Blueprint, jsonify
from db import db

productos_bp = Blueprint("productos_bp", __name__)

@productos_bp.get("/productos")
def obtener_productos():
    productos_ref = db.collection('tienda_productos')
    docs = productos_ref.stream()

    productos = []
    for doc in docs:
        data = doc.to_dict()
        data['id_producto'] = doc.id
        productos.append(data)

    return jsonify({"productos": productos}), 200
