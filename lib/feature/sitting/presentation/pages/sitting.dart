import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_translater_admin/feature/sitting/presentation/controller/sitting_cubit.dart';

class Sitting extends StatelessWidget {
  const Sitting({super.key});

  static const List<String> _fonts = [
    'Default',
    'Roboto',
    'Open Sans',
    'Lato',
    'Poppins',
    'Courier',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SittingCubit, SittingState>(
      builder: (context, state) {
        final bool isDarkMode = state.themeMode == ThemeMode.dark;
        final String currentFont = state.fontFamily;

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Appearance Section Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        "Appearance",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Divider(),

                    // Dark Mode Switch
                    SwitchListTile(
                      secondary: Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: isDarkMode ? Colors.amber : Colors.orange,
                      ),
                      title: const Text("Dark Mode"),
                      subtitle: Text(
                        isDarkMode
                            ? "Dark theme enabled"
                            : "Light theme enabled",
                      ),
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<SittingCubit>().toggleTheme(value);
                      },
                    ),

                    const Divider(),

                    // Font Selector
                    ListTile(
                      leading: const Icon(Icons.font_download_outlined),
                      title: const Text("Font Family"),
                      subtitle: Text("Current font: $currentFont"),
                      trailing: DropdownButton<String>(
                        value: _fonts.contains(currentFont)
                            ? currentFont
                            : 'Default',
                        underline: const SizedBox(),
                        items: _fonts.map((String font) {
                          return DropdownMenuItem<String>(
                            value: font,
                            child: Text(font),
                          );
                        }).toList(),
                        onChanged: (String? newFont) {
                          if (newFont != null) {
                            context.read<SittingCubit>().setFontFamily(newFont);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Preview Section
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Preview",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "The quick brown fox jumps over the lazy dog.",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: currentFont == 'Default'
                            ? null
                            : currentFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
