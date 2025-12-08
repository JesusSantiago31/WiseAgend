from flask import Blueprint, jsonify, request
from datetime import datetime, timedelta
from utils import verificar_token
from db import db

compras_bp = Blueprint("compras_bp", __name__)

# Comprar un producto
@compras_bp.post("/comprar")
def comprar():
    if not verificar_token(request):
        return jsonify({"error": "Token inválido"}), 401

    data = request.json
    id_usuario = data.get("id_usuario")
    id_producto = data.get("id_producto")

    if not id_usuario or not id_producto:
        return jsonify({"error": "Datos incompletos"}), 400

    # Usuario
    user_ref = db.collection("usuarios").document(id_usuario)
    user_doc = user_ref.get()

    if not user_doc.exists:
        return jsonify({"error": "Usuario no existe"}), 404

    usuario = user_doc.to_dict()

    # Producto
    prod_ref = db.collection("tienda_productos").document(id_producto)
    prod_doc = prod_ref.get()

    if not prod_doc.exists:
        return jsonify({"error": "Producto no existe"}), 404

    producto = prod_doc.to_dict()

    # Validación premium
    if producto.get("tipo") == "premium" and usuario.get("tipo_cuenta") == "free":
        return jsonify({"error": "Requiere cuenta premium"}), 403

    # Validación monedas
    if usuario["monedas"] < producto["costo"]:
        return jsonify({"error": "No tienes suficientes monedas"}), 403

    # Registrar compra
    fecha = datetime.utcnow()
    dias = producto.get("dias_vigencia", 0)

    compra_data = {
        "id_usuario": id_usuario,
        "id_producto": id_producto,
        "fecha_compra": fecha,
        "fecha_vencimiento": fecha + timedelta(days=dias) if dias else None
    }

    db.collection("usuarios_productos").add(compra_data)

    # Descontar monedas
    user_ref.update({"monedas": usuario["monedas"] - producto["costo"]})

    return jsonify({"mensaje": "Compra realizada con éxito"}), 200


# Renovar producto
@compras_bp.post("/renovar")
def renovar():
    if not verificar_token(request):
        return jsonify({"error": "Token inválido"}), 401

    data = request.json
    id_usuario = data.get("id_usuario")
    id_producto = data.get("id_producto")

    if not id_usuario or not id_producto:
        return jsonify({"error": "Datos incompletos"}), 400

    user_ref = db.collection("usuarios").document(id_usuario)
    user_doc = user_ref.get()

    if not user_doc.exists:
        return jsonify({"error": "Usuario no existe"}), 404

    usuario = user_doc.to_dict()

    prod_ref = db.collection("tienda_productos").document(id_producto)
    prod_doc = prod_ref.get()

    if not prod_doc.exists:
        return jsonify({"error": "Producto no existe"}), 404

    producto = prod_doc.to_dict()

    costo = producto.get("costo")
    dias = producto.get("dias_vigencia")

    if usuario["monedas"] < costo:
        return jsonify({"error": "No tienes suficientes monedas"}), 403

    # Pagar renovación
    user_ref.update({"monedas": usuario["monedas"] - costo})

    fecha_compra = datetime.utcnow()
    fecha_venc = fecha_compra + timedelta(days=dias)

    compras_ref = db.collection("usuarios_productos")
    compras = compras_ref.where("id_usuario", "==", id_usuario)\
                         .where("id_producto", "==", id_producto).stream()

    found = False
    for doc in compras:
        found = True
        compras_ref.document(doc.id).update({
            "fecha_compra": fecha_compra,
            "fecha_vencimiento": fecha_venc
        })

    if not found:
        compras_ref.add({
            "id_usuario": id_usuario,
            "id_producto": id_producto,
            "fecha_compra": fecha_compra,
            "fecha_vencimiento": fecha_venc
        })

    return jsonify({"mensaje": "Renovación exitosa"}), 200
