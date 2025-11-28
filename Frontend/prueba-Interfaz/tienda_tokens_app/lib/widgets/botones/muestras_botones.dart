import 'package:flutter/material.dart';

// Importa los botones
import '/widgets/botones/add_note_button.dart';
import '/widgets/botones/save_button.dart';
import '/widgets/botones/discard_button.dart';
import '/widgets/botones/cancel_button.dart';
import '/widgets/botones/export_button.dart';
import '/widgets/botones/complete_button.dart';
import '/widgets/botones/progress_bar.dart';
import '/widgets/botones/coin_button.dart';

class AddNoteButtonPreview extends StatelessWidget {
  const AddNoteButtonPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 232, 235),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3F4F6),
        foregroundColor: Colors.black,
        title: const Text(
          "Muestras de botones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          // ⬅️ Evita overflow si crecen los botones
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón de añadir
              AddNoteButton(
                onPressed: () {
                  debugPrint("AddNoteButton presionado en vista previa");
                },
              ),

              const SizedBox(height: 32),

              // Botón de guardar
              SaveButton(
                onPressed: () {
                  debugPrint("SaveButton presionado en vista previa");
                },
              ),

              const SizedBox(height: 32),

              // Botón de descartar
              DiscardButton(
                onPressed: () {
                  debugPrint("DiscardButton presionado en vista previa");
                },
              ),

              const SizedBox(height: 32),

              // Botón de cancelar
              CancelButton(
                onPressed: () {
                  debugPrint("CancelButton presionado en vista previa");
                },
              ),

              const SizedBox(height: 32),

              // Botón Exportar
              ExportButton(
                onPressed: () {
                  debugPrint("ExportButton presionado en vista previa");
                },
              ),

              const SizedBox(height: 32),
              CoinButton(
                onPressed: () {
                  debugPrint("boton monedas");
                },
              ),
              const SizedBox(height: 30),

              // ⭐ Botón Completar
              CompleteButton(
                onPressed: () {
                  debugPrint("CompleteButton presionado en vista previa");
                },
              ),

              const SizedBox(height: 30),

              // ⭐ Barra de progreso personalizada
              const Text(
                "Progreso:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2EB38E),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ), // ⭐ NUEVO MARGIN
                child: SizedBox(
                  width: 250,
                  child: CustomProgressBar(
                    initialValue: 0.4,
                    onChanged: (value) {
                      debugPrint(
                        "Progreso actualizado: ${(value * 100).round()}%",
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
