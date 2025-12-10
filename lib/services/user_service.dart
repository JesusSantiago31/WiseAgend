// lib/services/user_service.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user_model.dart'; // Asegúrate de importar tu modelo

class UserService {
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('usuarios');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Crea un documento de usuario en Firestore si es nuevo.
  /// Acepta un [nombrePersonalizado] opcional para registros con email/contraseña.
  Future<void> createUserDocument(User user, {String? nombrePersonalizado}) async { // <-- PARÁMETRO AÑADIDO
    final docRef = _userCollection.doc(user.uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      print("✨ Documento de usuario no existe. Creando uno nuevo para ${user.uid}...");

      // Lógica mejorada para elegir el nombre:
      // 1. Usa el nombre personalizado si se proporciona (del formulario de registro).
      // 2. Si no, usa el displayName del proveedor (para Google).
      // 3. Si ninguno existe, usa 'Nuevo Usuario' como último recurso.
      final String nombreFinal = nombrePersonalizado ?? user.displayName ?? 'Nuevo Usuario';

      print("ℹ️ Usando el nombre: '$nombreFinal' para el nuevo documento.");

      final newUser = UserModel(
        idUsuario: user.uid,
        nombre: nombreFinal, // <-- Usamos la variable con el nombre correcto
        correo: user.email ?? 'sin-correo@registrado.com',
        avatar: user.photoURL,
        monedas: 0,
        nivel: 1,
        tipoCuenta: 'free',
        rango: 'Principiante',
        fechaRegistro: DateTime.now().toIso8601String(),
        notificaciones: {
          "generales": true, "promociones": false, "actualizaciones": true, "recordatorios": true
        },
      );
      await docRef.set(newUser.toMap());
      print("✅ Documento creado exitosamente en Firestore.");
    } else {
      print("ℹ️ El documento para el usuario ${user.uid} ya existe.");
    }
  }

  /// Obtiene los datos de un usuario desde Firestore por su ID (UID).
  Future<UserModel?> getUser(String uid) async {
    try {
      final DocumentSnapshot doc = await _userCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      } else {
        print("ℹ️ No se encontró ningún documento para el UID: $uid");
        return null;
      }
    } catch (e) {
      print("❌ Error al obtener usuario de Firestore: $e");
      return null;
    }
  }

  /// Actualiza los datos de un usuario en Firestore.
  Future<bool> updateUser(UserModel user) async {
    try {
      await _userCollection.doc(user.idUsuario).update(user.toMap());
      print("✅ Usuario ${user.idUsuario} actualizado en Firestore.");
      return true;
    } catch (e) {
      print("❌ Error al actualizar usuario en Firestore: $e");
      return false;
    }
  }

  /// Sube una imagen de perfil a Firebase Storage y devuelve la URL.
  Future<String?> uploadProfileImage(File image, String userId) async {
    try {
      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("✅ Imagen subida a Storage. URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("❌ Error al subir imagen a Storage: $e");
      return null;
    }
  }

  /// Determina si el usuario actual inició sesión con Google.
  bool isGoogleUser() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return false;
    return currentUser.providerData.any((info) => info.providerId == 'google.com');
  }

  /// Elimina la cuenta del usuario actual de todos los servicios de Firebase.
  Future<String> deleteUser({String? password}) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return "No hay ningún usuario logueado.";

      final bool wasGoogleUser = isGoogleUser();
      final String uid = currentUser.uid;

      AuthCredential credential;

      if (wasGoogleUser) {
        print("ℹ️ Reautenticando usuario de Google...");
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return "Cancelaste el inicio de sesión con Google.";
        }
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else {
        print("ℹ️ Reautenticando usuario de Email/Contraseña...");
        if (password == null || password.isEmpty) {
          return "Se requiere la contraseña para eliminar la cuenta.";
        }
        credential = EmailAuthProvider.credential(
          email: currentUser.email!,
          password: password,
        );
      }

      print("✅ Reautenticando en Firebase...");
      await currentUser.reauthenticateWithCredential(credential);
      print("✅ Reautenticación exitosa. Procediendo con la eliminación...");

      await _userCollection.doc(uid).delete();
      print("✅ Documento de Firestore para el usuario $uid eliminado.");

      try {
        final String filePath = 'profile_images/$uid.jpg';
        await _storage.ref(filePath).delete();
        print("✅ Imagen de Storage para el usuario $uid eliminada.");
      } catch (e) {
        print("ℹ️ Info: No se encontró imagen de perfil para eliminar o ya fue borrada.");
      }

      await currentUser.delete();
      print("✅ Usuario de Firebase Auth ($uid) eliminado.");

      if (wasGoogleUser) {
        await _googleSignIn.signOut();
        print("✅ Sesión de Google Sign-In local cerrada para limpiar el caché.");
      }

      await _auth.signOut();
      print("✅ Sesión de Firebase Auth local cerrada.");

      print("🎉 Proceso de eliminación completado para el usuario $uid.");
      return "OK";

    } on FirebaseAuthException catch (e) {
      print("❌ Error de Firebase durante la eliminación: ${e.code}");
      if (e.code == 'wrong-password') {
        return "La contraseña es incorrecta.";
      }
      return "Ocurrió un error de seguridad. Inténtalo más tarde.";
    } catch (e) {
      print("❌ Error crítico durante la eliminación: $e");
      return "Ocurrió un error inesperado.";
    }
  }

  // --- NUEVAS FUNCIONES AÑADIDAS ---

  /// Determina si el usuario actual se autenticó con Email/Contraseña.
  bool isEmailPasswordUser() {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    // El ID del proveedor para Email/Contraseña es 'password'.
    return currentUser.providerData.any((info) => info.providerId == 'password');
  }

  /// Actualiza la contraseña del usuario actual.
  /// Devuelve un String con el resultado: "OK" si es exitoso, o un mensaje de error.
  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return "No hay sesión activa.";

      // Primero, reautenticar al usuario para seguridad.
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Si la reautenticación es exitosa, actualiza la contraseña.
      await user.updatePassword(newPassword);
      print("✅ Contraseña actualizada exitosamente.");
      return "OK";

    } on FirebaseAuthException catch (e) {
      print("❌ Error al cambiar contraseña: ${e.code}");
      if (e.code == 'wrong-password') {
        return "La contraseña actual es incorrecta.";
      }
      if (e.code == 'weak-password') {
        return "La nueva contraseña es muy débil. Debe tener al menos 6 caracteres.";
      }
      return "Ocurrió un error. Inténtalo más tarde.";
    } catch (e) {
      print("❌ Error inesperado: $e");
      return "Ocurrió un error inesperado.";
    }
  }
}
