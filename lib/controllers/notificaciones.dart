import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/theme.dart';
import '../widgets/save_button.dart';

class NotificacionesPage extends StatefulWidget {
  const NotificacionesPage({super.key});

  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  late Future<SharedPreferences> _prefsFuture;

  bool _notiGeneral = true;
  bool _notiPromos = false;
  bool _notiActualizaciones = true;
  bool _notiRecordatorios = true;

  @override
  void initState() {
    super.initState();
    _prefsFuture = _loadPreferences();
  }

  Future<SharedPreferences> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _notiGeneral = prefs.getBool('notiGeneral') ?? true;
        _notiPromos = prefs.getBool('notiPromos') ?? false;
        _notiActualizaciones = prefs.getBool('notiActualizaciones') ?? true;
        _notiRecordatorios = prefs.getBool('notiRecordatorios') ?? true;
      });
    }
    return prefs;
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notiGeneral', _notiGeneral);
    await prefs.setBool('notiPromos', _notiPromos);
    await prefs.setBool('notiActualizaciones', _notiActualizaciones);
    await prefs.setBool('notiRecordatorios', _notiRecordatorios);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuración guardada en el dispositivo'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      // --- MEJORA 1: AppBar con estilo profesional ---
      appBar: AppBar(
        title: Text(
          'Notificaciones',
          style: AppTheme.title.copyWith(
            color: const Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF30D5A0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // --- MEJORA 2: Envolvemos el body con SafeArea ---
      body: SafeArea(
        child: FutureBuilder<SharedPreferences>(
          future: _prefsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF30D5A0)));
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar la configuración'));
            }

            // Usamos un ListView para asegurar el scroll si la pantalla es muy pequeña
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                const SizedBox(height: 10), // Espacio extra desde el AppBar
                _buildSwitchTile(
                  'Notificaciones generales',
                  'Avisos importantes sobre tu cuenta.',
                  _notiGeneral,
                      (val) => setState(() => _notiGeneral = val),
                ),
                _buildSwitchTile(
                  'Promociones y novedades',
                  'Ofertas y características nuevas.',
                  _notiPromos,
                      (val) => setState(() => _notiPromos = val),
                ),
                _buildSwitchTile(
                  'Actualizaciones del sistema',
                  'Mantenimiento y nuevas funciones.',
                  _notiActualizaciones,
                      (val) => setState(() => _notiActualizaciones = val),
                ),
                _buildSwitchTile(
                  'Recordatorios',
                  'Alertas y recomendaciones personalizadas.',
                  _notiRecordatorios,
                      (val) => setState(() => _notiRecordatorios = val),
                ),
                // --- MEJORA 3: Posicionamiento del botón ---
                // El botón ahora está al final del contenido, no pegado al fondo
                const SizedBox(height: 40),
                SaveButton(
                  onPressed: _savePreferences,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: SwitchListTile(
        activeColor: const Color(0xFF30D5A0),
        title: Text(
          title,
          style: AppTheme.title.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.body.copyWith(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
