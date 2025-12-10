import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../model/user_model.dart';
import '../../services/user_service.dart';
import '../../widgets/theme.dart';
// Asegúrate de importar tu SaveButton si está en otro archivo
import '../widgets/save_button.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserModel user;

  const ProfileEditScreen({super.key, required this.user});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.nombre);
    _emailController = TextEditingController(text: widget.user.correo);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (img != null) {
      setState(() => _profileImage = File(img.path));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF30D5A0)),
      ),
    );

    String? newImageUrl;
    if (_profileImage != null) {
      newImageUrl = await _userService.uploadProfileImage(_profileImage!, widget.user.idUsuario);
    }

    UserModel updatedUser = widget.user.copyWith(
      nombre: _nameController.text.trim(),
      avatar: newImageUrl ?? widget.user.avatar,
    );

    bool ok = await _userService.updateUser(updatedUser);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // Cierra el diálogo de carga
    }

    if (mounted) {
      if (ok) {
        _showFeedbackSnackbar(
          message: 'Perfil actualizado con éxito',
          isSuccess: true,
        );
        Navigator.pop(context, updatedUser);
      } else {
        _showFeedbackSnackbar(
          message: 'Error al actualizar el perfil. Inténtalo de nuevo.',
          isSuccess: false,
        );
      }
    }
  }

  void _showFeedbackSnackbar({required String message, required bool isSuccess}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Editar Perfil', style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF30D5A0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(width * 0.05, width * 0.05, width * 0.05, 120), // Aumenta el padding inferior
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: width * 0.36,
                          height: width * 0.36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(blurRadius: 6, offset: const Offset(0, 3), color: Colors.black.withOpacity(0.2)),
                            ],
                          ),
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(_profileImage!, fit: BoxFit.cover)
                                : (widget.user.avatar != null && widget.user.avatar!.isNotEmpty
                                ? Image.network(widget.user.avatar!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Image.asset("assets/image/logo.png", fit: BoxFit.cover))
                                : Image.asset("assets/image/logo.png", fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _pickImage,
                              icon: Icon(Icons.camera_alt, size: width * 0.06, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    controller: _nameController,
                    label: "Nombre completo",
                    icon: Icons.person,
                    validator: (v) => v!.isEmpty ? "Campo requerido" : null,
                    width: width,
                  ),
                  _buildInputField(
                    controller: _emailController,
                    label: "Correo electrónico",
                    icon: Icons.email_outlined,
                    validator: (v) => v == null || !v.contains("@") ? "Correo inválido" : null,
                    width: width,
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),

          // --- AQUÍ ESTÁ EL CAMBIO ---
          // Botón fijo en la parte inferior usando tu widget SaveButton
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
              color: AppTheme.background,
              child: SaveButton(
                onPressed: _saveProfile,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required double width,
    bool enabled = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: width * 0.04),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[200],
        borderRadius: AppTheme.borderRadius,
        boxShadow: [
          BoxShadow(blurRadius: 4, offset: const Offset(0, 2), color: AppTheme.primary.withOpacity(0.25)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          style: AppTheme.body,
          decoration: InputDecoration(
            icon: Icon(icon, color: AppTheme.primary),
            labelText: label,
            labelStyle: TextStyle(
              color: AppTheme.primary, // <-- Usa tu color verde primario
              fontWeight: FontWeight.w500, // Opcional: puedes ajustar el grosor
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
