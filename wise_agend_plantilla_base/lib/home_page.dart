import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';
import 'widgets/add_note_button.dart';
import 'widgets/search_bar.dart';
import 'widgets/tarjetas/note_card.dart'; // <-- NUEVO IMPORT

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  int navIndex = 1; // Esta sección = Notas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 236, 237),

      floatingActionButton: AddNoteButton(onPressed: () {}),

      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 10),
            _buildFilterChips(),
            const SizedBox(height: 10),
            Expanded(child: _buildNotesList()),
          ],
        ),
      ),

      bottomNavigationBar: AnimatedNavBar(
        currentIndex: navIndex,
        onTap: (i) {
          setState(() => navIndex = i);
        },
      ),
    );
  }

  // -------------------------------
  // Top Search Bar + Menu Icon
  // -------------------------------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF2EB38E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.note_alt_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Notas y Apuntes",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.menu, size: 28),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          const CustomSearchBar(),
        ],
      ),
    );
  }

  // -------------------------------
  // Filter Chips
  // -------------------------------
  Widget _buildFilterChips() {
    final filters = ["Todas", "Escuela", "Trabajo", "Ideas", "Personal"];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2EB38E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.transparent : Colors.grey.shade300,
              ),
            ),
            child: Center(
              child: Text(
                filters[i],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------------------
  // Notes List
  // -------------------------------
  Widget _buildNotesList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        NoteCard(
          title: "Proyecto Final de Matemáticas",
          description:
              "Investigar sobre ecuaciones diferenciales y sus aplicaciones en física...",
          tags: ["Escuela", "Matemáticas"],
          date: "12 nov",
          isFavorite: true,
        ),
        NoteCard(
          title: "Ideas para la Startup",
          description:
              "App de aprendizaje colaborativo con IA. Conversión automática a flashcards...",
          tags: ["Ideas", "Trabajo"],
          date: "11 nov",
          share: true,
        ),
        NoteCard(
          title: "Ideas para la Startup",
          description:
              "App de aprendizaje colaborativo con IA. Conversión automática a flashcards...",
          tags: ["Ideas", "Trabajo"],
          date: "11 nov",
          share: true,
        ),
        NoteCard(
          title: "Ideas para la Startup",
          description:
              "App de aprendizaje colaborativo con IA. Conversión automática a flashcards...",
          tags: ["Ideas", "Trabajo"],
          date: "11 nov",
          share: true,
        ),
        NoteCard(
          title: "Lista de Compras Semanal",
          description:
              "Frutas, verduras, pan integral, huevos, pollo, arroz, pasta...",
          tags: ["Personal"],
          date: "10 nov",
        ),
      ],
    );
  }
}
