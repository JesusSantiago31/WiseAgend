import 'package:flutter/material.dart';
import 'home_page.dart';
import '/widgets/botones/muestras_botones.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';




// ⭐ Importamos tu pantalla de vista previa de inputs
import '/widgets/inputs/preview_inputs_page.dart';

// ⭐ NUEVO: Importamos la pantalla de catálogo de tarjetas
import '/widgets/tarjetas/preview_cards_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const StartMenuPage(), // 👈 pantalla inicial ahora es un menú
    );
  }
}

class StartMenuPage extends StatelessWidget {
  const StartMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona una pantalla")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ➤ Ir al Home Page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotesHomePage()),
                );
              },
              child: const Text("Ir a Home Page"),
            ),

            const SizedBox(height: 20),

            // ➤ Ir a vista previa de BOTONES
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddNoteButtonPreview(),
                  ),
                );
              },
              child: const Text("Plantillas para botones"),
            ),

            const SizedBox(height: 20),

            // ➤ Ir a vista previa de INPUTS
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PreviewInputsPage()),
                );
              },
              child: const Text("Plantillas para Inputs"),
            ),

            const SizedBox(height: 20),

            // ⭐ NUEVO ➤ Ir a vista previa de TARJETAS
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PreviewCardsPage()),
                );
              },
              child: const Text("Catálogo de Tarjetas"),
            ),
          ],
        ),
      ),
    );
  }
}
