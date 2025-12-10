import 'package:flutter/material.dart';
import '../widgets/theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  double _passwordStrength = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    // Animación inicial
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
    _fadeController.forward();

    // Escucha para fuerza de contraseña
    _newController.addListener(() {
      setState(() {
        _passwordStrength = _calculatePasswordStrength(_newController.text);
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
        centerTitle: true,
        elevation: 1,
      ),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Row(
                  children: [
                    const Icon(Icons.lock_outline, color: AppTheme.accent, size: 26),
                    const SizedBox(width: 8),
                    Text("Seguridad de la cuenta", style: AppTheme.title.copyWith(fontSize: 22)),
                  ],
                ),
                const SizedBox(height: 8),

                Text("Actualiza tu contraseña para mantener protegida tu cuenta.",
                    style: AppTheme.body),

                const SizedBox(height: 25),

                _buildInput(
                  controller: _currentController,
                  label: "Contraseña actual",
                  obscureText: _obscureCurrent,
                  toggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                const SizedBox(height: 18),

                _buildInput(
                  controller: _newController,
                  label: "Nueva contraseña",
                  obscureText: _obscureNew,
                  toggle: () => setState(() => _obscureNew = !_obscureNew),
                  validator: (value) {
                    if (value == null || value.length < 8) return "Debe tener al menos 8 caracteres";
                    return null;
                  },
                ),
                _buildStrengthIndicator(),
                const SizedBox(height: 18),

                _buildInput(
                  controller: _confirmController,
                  label: "Confirmar contraseña",
                  obscureText: _obscureConfirm,
                  toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  validator: (value) {
                    if (value != _newController.text) return "Las contraseñas no coinciden";
                    return null;
                  },
                ),

                const SizedBox(height: 35),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==== CAMPO DE INPUT ESTILIZADO ====
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: AppTheme.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTheme.body.copyWith(color: AppTheme.textColor.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off,
              color: AppTheme.textColor.withOpacity(0.6)),
          onPressed: toggle,
        ),
      ),
    );
  }

  // 🔥 Indicador de fuerza
  Widget _buildStrengthIndicator() {
    final List<String> levels = ["Muy débil", "Débil", "Regular", "Fuerte", "Muy fuerte"];
    int strengthIndex = (_passwordStrength * 4).clamp(0, 4).toInt();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: _passwordStrength,
              minHeight: 6,
            ),
          ),
          const SizedBox(width: 8),
          Text(levels[strengthIndex],
              style: AppTheme.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Botón principal con animación al presionar
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleChangePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
            "Actualizar contraseña",
            style: AppTheme.body.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Cálculo simple de fortaleza
  double _calculatePasswordStrength(String password) {
    double strength = 0;
    if (password.isEmpty) return 0;

    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    return strength.clamp(0, 1);
  }

  // Acción final
  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2)); // 🔥 futura integración Firebase

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contraseña actualizada correctamente")),
        );
        Navigator.pop(context);
      }
    }
  }
}
