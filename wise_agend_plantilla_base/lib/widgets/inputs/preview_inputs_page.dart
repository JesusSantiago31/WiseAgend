import 'package:flutter/material.dart';
import 'glass_input.dart';
import 'glow_input.dart';
import 'minimal_input.dart';
import 'premium_input.dart'; // <-- NUEVO IMPORT

class PreviewInputsPage extends StatelessWidget {
  const PreviewInputsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 238, 238),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 244, 243, 243),
        elevation: 0,
        title: const Text(
          "Catálogo de Inputs",
          style: TextStyle(
            color: Color.fromARGB(255, 4, 4, 4),
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // =======================
          // GLASS INPUT
          // =======================
          _section("Glass Input"),
          GlassInput(
            icon: Icons.person,
            label: "Nombre",
            hint: "Escribe tu nombre",
          ),

          const SizedBox(height: 25),

          // =======================
          // GLOW INPUT
          // =======================
          _section("Glow Input"),
          GlowInput(
            icon: Icons.email,
            label: "Correo",
            hint: "ejemplo@correo.com",
          ),

          const SizedBox(height: 25),

          // =======================
          // MINIMALISTA
          // =======================
          _section("Minimalista"),
          MinimalInput(icon: Icons.lock, label: "Contraseña"),

          const SizedBox(height: 25),

          // =======================
          // PREMIUM INPUT
          // =======================
          _section("Premium Elegant"),
          PremiumInput(icon: Icons.phone_android, label: "Teléfono"),
        ],
      ),
    );
  }

  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF34D1A1),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
