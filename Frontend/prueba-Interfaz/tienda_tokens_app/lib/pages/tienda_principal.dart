import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../api/api_service.dart';
import '../styles/app_colors.dart';

// Widgets reutilizados del proyecto "Notes"
import '../widgets/add_note_button.dart';
import '../widgets/search_bar.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/tarjetas/note_card.dart';
import './side_menu.dart';

class TiendaPrincipalPage extends StatefulWidget {
  const TiendaPrincipalPage({super.key});

  @override
  State<TiendaPrincipalPage> createState() => _TiendaPrincipalPageState();
}

class _TiendaPrincipalPageState extends State<TiendaPrincipalPage> {
  final ApiService api = ApiService();

  String selectedCategory = 'recompensa';
  int tokens = 850;

  final List<String> categories = [
    'Todas', 'recompensa', 'Producto'
  ];

  String searchText = "";

  List<ProductoModel> productsOriginal = [];
  List<ProductoModel> products = [];
  bool isLoading = true;

  int navIndex = 1;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    setState(() => isLoading = true);

    try {
      final lista = await api.getProductos();

      setState(() {
        productsOriginal = List.from(lista); // SIEMPRE LA BASE
        products = List.from(lista);         // lista mostrada
      });
    } catch (e) {
      debugPrint('ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error cargando productos')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // --------------------------------------
  // FILTRO CORREGIDO: SIEMPRE USA ORIGINAL
  // --------------------------------------
  List<ProductoModel> get filtered {
    final base = productsOriginal;   // <<< SIEMPRE esta lista
    final text = searchText.toLowerCase().trim();
    final hasSearch = text.isNotEmpty;

    return base.where((p) {
      final matchCategory = selectedCategory.toLowerCase() == 'todas'
          ? true
          : p.category.trim().toLowerCase() ==
              selectedCategory.trim().toLowerCase();

      final matchSearch = !hasSearch
          ? true
          : p.title.toLowerCase().contains(text) ||
              p.subtitle.toLowerCase().contains(text);

      return matchCategory && matchSearch;
    }).toList();
  }

  void tryUnlock(ProductoModel p) {
    if (p.cost > tokens) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tienes suficientes tokens')),
      );
      return;
    }

    setState(() {
      tokens -= p.cost;

      final idx = productsOriginal.indexWhere((e) => e.id == p.id);
      if (idx >= 0) {
        productsOriginal[idx] = ProductoModel(
          id: p.id,
          title: p.title,
          subtitle: p.subtitle,
          cost: p.cost,
          premium: p.premium,
          category: p.category,
          locked: false,
          vencimiento: p.vencimiento,
        );
      }
    });
  }

  Widget _buildProductCard(ProductoModel p) {
    final tags = <String>[
      p.category,
      if (p.premium) 'Premium',
      '${p.cost} tokens'
    ];

    return NoteCard(
      title: p.title,
      description: p.subtitle,
      tags: tags,
      date: p.vencimiento.toString() + ' días para vencer',
      vencimiento: p.vencimiento,
      
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2EB38E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront_outlined,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tienda de Recompensas',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A)),
                ),
                SizedBox(height: 2),
                Text(
                  'Canjea tus tokens por recompensas',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04), blurRadius: 8)
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on_outlined,
                    color: Color(0xFF0EA78D)),
                const SizedBox(width: 8),
                Text('$tokens',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final c = categories[i];
          final isSelected =
              c.toLowerCase().trim() == selectedCategory.toLowerCase().trim();

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = c),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2EB38E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: Colors.green.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 4))
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  c,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final list = filtered;

    if (list.isEmpty) {
      return Center(
        child: Text(
          'No hay items en esta categoría',
          style: TextStyle(color: AppColors.disabled, fontSize: 14),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final p = list[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductCard(p),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6)
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on_outlined,
                          size: 16, color: Color(0xFF0EA78D)),
                      const SizedBox(width: 8),
                      Text('${p.cost} tokens',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: p.locked ? () => tryUnlock(p) : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: p.locked
                        ? const Color(0xFF0EA78D)
                        : Colors.grey.shade300,
                    elevation: p.locked ? 4 : 0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Text(
                      p.locked ? 'Desbloquear' : 'Desbloqueado',
                      style: TextStyle(
                          color: p.locked
                              ? Colors.white
                              : Colors.grey.shade800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9F8),
      drawer: const NotesSideMenu(),
      floatingActionButton: AddNoteButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Recargar tokens'),
              content: const Text(
                  'Aquí colocarías la lógica para comprar tokens.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (_) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.textPrimary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(''),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            _buildHeader(),
            const SizedBox(height: 12),

            // -----------------------------
            // BARRA DE BÚSQUEDA CORREGIDA
            // -----------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomSearchBar(
                hintText: 'Buscar recompensas',
                onChanged: (q) {
                  setState(() {
                    searchText = q; // ahora sí funciona el filtro
                  });
                },
              ),
            ),

            const SizedBox(height: 12),
            _buildCategoryChips(),
            const SizedBox(height: 12),

            Expanded(child: _buildProductsList()),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedNavBar(
        currentIndex: navIndex,
        onTap: (i) => setState(() => navIndex = i),
      ),
    );
  }
}
