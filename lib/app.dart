import 'package:flutter/material.dart';

import 'features/image_to_pdf/image_to_pdf_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZ PDF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const ImageToPdfPage(),
    );
  }
}