import 'package:flutter/material.dart';

class NotesSideMenu extends StatelessWidget {
  const NotesSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 290,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),

          // -----------------------------
          // Header con imagen y título
          // -----------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2EB38E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/img/wise_agend.jpeg", // ← Ruta de tu imagen
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wise Agend",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Tu espacio de ideas",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Divider(height: 30),

          // -----------------------------
          // Secciones principales
          // -----------------------------
          _menuItem(Icons.sticky_note_2_outlined, "Todas las Notas", "24"),
          _menuItem(Icons.star_border, "Favoritas", "8"),
          _menuItem(Icons.archive_outlined, "Archivadas", "12"),
          _menuItem(Icons.share_outlined, "Compartidas", "3"),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Text(
              "Categorías",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
            ),
          ),

          // -----------------------------
          // Lista de Categorías
          // -----------------------------
          _categoryItem(Colors.blue, "Escuela"),
          _categoryItem(Colors.green, "Trabajo"),
          _categoryItem(Colors.purple, "Personal"),
          _categoryItem(Colors.orange, "Ideas"),

          const Spacer(),

          const Divider(),

          // -----------------------------
          // Sección inferior (Premium / Configuración)
          // -----------------------------
          _bottomItem(Icons.grid_view, "Plantillas"),
          _bottomItem(Icons.workspace_premium_outlined, "Premium", pro: true),
          _bottomItem(Icons.settings_outlined, "Configuración"),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // Widgets para ítems
  // ---------------------------------------------------------

  Widget _menuItem(IconData icon, String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF475569)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2F4EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count,
              style: const TextStyle(
                color: Color(0xFF2EB38E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(Color color, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Color(0xFF334155)),
          ),
        ],
      ),
    );
  }

  Widget _bottomItem(IconData icon, String title, {bool pro = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: const Color(0xFF475569)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          if (pro)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2EB38E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "PRO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
