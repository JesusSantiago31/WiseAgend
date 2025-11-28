import 'package:flutter/material.dart';
import 'note_card.dart';
import 'visual_summary_card.dart';
import 'user_status_card.dart';
import 'habit_task_card.dart';
import 'premium_unlock_card.dart';
import 'rank_status_card.dart'; // <-- IMPORTAMOS LA NUEVA TARJETA DE RANGO

class PreviewCardsPage extends StatelessWidget {
  const PreviewCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 236, 237),
      appBar: AppBar(
        title: const Text(
          "Catálogo de Tarjetas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2EB38E),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // -------------------------------
          // SECCIÓN TARJETA ESTÁNDAR
          // -------------------------------
          _section("Tarjeta estándar"),
          NoteCard(
            title: "Proyecto Final de Matemáticas",
            description:
                "Investigar sobre ecuaciones diferenciales y sus aplicaciones en física...",
            tags: ["Escuela", "Matemáticas"],
            date: "12 nov",
            isFavorite: true,
          ),

          const SizedBox(height: 25),

          // -------------------------------
          // SECCIÓN COMPARTIR
          // -------------------------------
          _section("Ejemplo con compartir"),
          NoteCard(
            title: "Ideas para Startup",
            description:
                "Aplicación educativa con IA y conversión automática a flashcards...",
            tags: ["Ideas", "Trabajo"],
            date: "11 nov",
            share: true,
          ),

          const SizedBox(height: 25),

          // -------------------------------
          // SECCIÓN TARJETA SIMPLE
          // -------------------------------
          _section("Tarjeta simple"),
          NoteCard(
            title: "Mi lista de compras",
            description: "Frutas, pollo, avena, pasta, ensalada, tortillas...",
            tags: ["Personal"],
            date: "08 nov",
          ),

          const SizedBox(height: 35),

          // -------------------------------
          // TARJETA PREMIUM VISUAL
          // -------------------------------
          _section("Tarjeta premium – estilo profesional"),
          VisualSummaryCard(
            title: "Resumen visual",
            subtitle: "Con secciones para diagramas y mapas mentales",
            locked: true,
            onPressed: () {
              print("Comprar tarjeta premium...");
            },
          ),

          const SizedBox(height: 35),

          // -------------------------------
          // TARJETA PREMIUM ANIMADA
          // -------------------------------
          _section("Desbloquear Premium – Tarjeta con animación"),
          PremiumUnlockCard(
            onPressed: () {
              print("Ir a comprar Premium...");
            },
          ),

          const SizedBox(height: 35),

          // -------------------------------
          // TARJETA DE USUARIO
          // -------------------------------
          _section("Tarjeta de usuario – Nivel y monedas"),
          UserStatusCard(
            username: "Usuario",
            level: 5,
            progress: 0.65,
            coins: 350,
          ),

          const SizedBox(height: 35),

          // -------------------------------
          // TARJETA DE HÁBITO
          // -------------------------------
          _section("Tarjeta de hábitos – estilo profesional"),
          HabitTaskCard(
            icon: Icons.directions_run,
            category: "Ejercicio",
            title: "Correr 30 minutos",
            progress: 0.65,
            days: const ["Lun", "Mié", "Vie"],
            calories: 12,
            time: "07:00",
            percent: 65,
            views: 450,
          ),

          const SizedBox(height: 35),

          // -------------------------------
          // ⚡ NUEVA TARJETA: RANGO / STATUS
          // -------------------------------
          _section("Tarjeta de rango – estilo profesional"),
          RankStatusCard(
            rankTitle: "Experto",
            nextRankTitle: "Maestro del Tiempo",
            currentTokens: 850,
            requiredTokens: 1000,
            level: 3,
            missingText: "Te faltan 150 tokens para el siguiente rango",
          ),
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
          color: Color(0xFF2EB38E),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
