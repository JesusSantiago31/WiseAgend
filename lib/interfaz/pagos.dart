// lib/interfaz/pagos.dart

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'dart:convert'; // Para codificar el cuerpo de la petición (JSON)

// --- IMPORTS PARA LA LÓGICA DE PAGO ---
import 'package:http/http.dart' as http; // Para hacer la llamada a la API
import 'package:firebase_auth/firebase_auth.dart'; // Para obtener el ID del usuario

import '../../widgets/theme.dart'; // Asegúrate que la ruta sea correcta

class PaymentScreenUI extends StatefulWidget {
  const PaymentScreenUI({super.key});

  @override
  State<PaymentScreenUI> createState() => _PaymentScreenUIState();
}

class _PaymentScreenUIState extends State<PaymentScreenUI> {
  late final Future<PaymentConfiguration> _googlePayConfig;
  final _paymentItems = [
    const PaymentItem(
      label: 'Wist Agenda - Suscripción Anual',
      amount: '199.99',
      status: PaymentItemStatus.final_price,
    )
  ];

  @override
  void initState() {
    super.initState();
    _googlePayConfig =
        PaymentConfiguration.fromAsset('assets/config/default_payment_profile.json');
  }

  // --- FUNCIÓN DE PAGO ACTUALIZADA PARA LLAMAR A LA API FLASK ---
  void onGooglePayResult(paymentResult) async {
    // 1. Muestra un indicador de carga al usuario.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⏳ Verificando tu pago, por favor espera...'),
        backgroundColor: Colors.orangeAccent,
        duration: Duration(seconds: 15), // Duración más larga
      ),
    );

    try {
      // 2. Obtiene el token de pago de Google. Este es el "cheque" que enviaremos.
      final token = paymentResult['paymentMethodData']['tokenizationData']['token'];

      // 3. Obtiene el ID del usuario actual.
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuario no autenticado. Por favor, inicia sesión de nuevo.");
      }

      // --- ¡AQUÍ ESTÁ LA LÓGICA CLAVE! ---
      // 4. Llama a tu API creada con Flask.
      // ¡IMPORTANTE! Reemplaza esta URL con la URL real de tu API cuando la despliegues.
      final url = Uri.parse('https://tu-api-desplegada.com/process-payment');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'paymentToken': token,
          'amount': 19999, // El monto debe ir en centavos (199.99 * 100).
          'currency': 'mxn', // O la moneda que uses.
          'userId': user.uid, // Enviamos el ID del usuario para saber a quién hacer premium.
        }),
      );

      // 5. Procesa la respuesta de la API.
      final responseData = json.decode(response.body);

      // Quita el SnackBar de "verificando" para mostrar el resultado final.
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 ¡Felicidades! Tu cuenta ahora es Premium.'),
            backgroundColor: AppTheme.primary,
          ),
        );
        // Cierra la pantalla de pagos y vuelve a la anterior.
        Navigator.of(context).pop();
      } else {
        // Si la API devolvió un error (ej. status 400, 500, etc.).
        throw Exception(responseData['message'] ?? 'El pago no pudo ser procesado.');
      }

    } catch (e) {
      // Si algo falla (no hay internet, la URL es incorrecta, etc.)
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      debugPrint('Error al procesar el pago: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void onGooglePayError(error) {
    debugPrint('Error en Google Pay: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('❌ Hubo un error al iniciar el pago o fue cancelado.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Suscripción y Pagos',
          style: AppTheme.title.copyWith(color: AppTheme.textColor),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        children: [
          _buildSubscriptionCard(),
          const SizedBox(height: 35),
          Text(
            'MÉTODOS GUARDADOS',
            style: AppTheme.caption.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 15),
          _buildPaymentCard(
            'Visa - **** 4567',
            'Expira 12/26',
            Icons.credit_card,
            AppTheme.primary,
            isDefault: true,
          ),
          _buildPaymentCard(
            'PayPal',
            'Cuenta de respaldo',
            Icons.paypal,
            Colors.blue.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber.shade600, size: 30),
              const SizedBox(width: 10),
              Text(
                'Wist Agenda Premium',
                style: AppTheme.title.copyWith(fontSize: 22),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Accede a todas las funciones exclusivas y lleva tu organización al siguiente nivel con nuestra suscripción anual.',
            style: AppTheme.body.copyWith(color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          FutureBuilder<PaymentConfiguration>(
            future: _googlePayConfig,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: GooglePayButton(
                    paymentConfiguration: snapshot.data!,
                    paymentItems: _paymentItems,
                    type: GooglePayButtonType.subscribe,
                    onPaymentResult: onGooglePayResult, // Llama a nuestra nueva función
                    onError: onGooglePayError,
                    loadingIndicator: const Center(child: CircularProgressIndicator()),
                    height: 50,
                    width: double.infinity,
                    theme: GooglePayButtonTheme.dark,
                    cornerRadius: AppTheme.borderRadius.bottomLeft.x.toInt(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'No se puede procesar pagos en este momento.',
                    style: AppTheme.caption.copyWith(color: Colors.red),
                  ),
                );
              }
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
      String title,
      String subtitle,
      IconData icon,
      Color color, {
        bool isDefault = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: AppTheme.title.copyWith(fontSize: 18),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.caption,
        ),
        trailing: isDefault
            ? Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Text(
            'Default',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
            : const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
        onTap: () => print('Editar método: $title'),
      ),
    );
  }
}