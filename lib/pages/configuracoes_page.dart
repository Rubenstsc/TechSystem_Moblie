import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/config_provider.dart';
import '../widgets/drawer_menu.dart';

class ConfiguracoesPage extends StatefulWidget {
  final bool isAdmin;
  const ConfiguracoesPage({super.key, required this.isAdmin});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void redefinirSenha(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void salvarConfiguracoes(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);

    // 🔹 Textos dinâmicos por idioma
    final traducoes = {
      'Português': {
        'title': 'Configurações',
        'theme': 'Tema',
        'darkMode': 'Modo Escuro',
        'lightMode': 'Modo Claro',
        'language': 'Idioma',
        'resetPassword': 'Redefinir Senha',
        'save': 'Salvar Configurações',
        'snackbar': 'Configurações salvas!',
        'dev': 'Função de redefinir senha em desenvolvimento!',
      },
      'English': {
        'title': 'Settings',
        'theme': 'Theme',
        'darkMode': 'Dark Mode',
        'lightMode': 'Light Mode',
        'language': 'Language',
        'resetPassword': 'Reset Password',
        'save': 'Save Settings',
        'snackbar': 'Settings saved!',
        'dev': 'Password reset feature in development!',
      },
      'Español': {
        'title': 'Configuraciones',
        'theme': 'Tema',
        'darkMode': 'Modo Oscuro',
        'lightMode': 'Modo Claro',
        'language': 'Idioma',
        'resetPassword': 'Restablecer Contraseña',
        'save': 'Guardar Configuración',
        'snackbar': '¡Configuraciones guardadas!',
        'dev': '¡Función en desarrollo!',
      },
    };

    final t = traducoes[config.idioma]!;
    final isDark = config.isDarkMode;

    return AnimatedTheme(
      duration: const Duration(milliseconds: 500),
      data: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: Colors.blue.shade700,
        scaffoldBackgroundColor:
        isDark ? Colors.grey.shade900 : Colors.blue.shade50,
        cardColor: isDark ? Colors.grey.shade900 : Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey.shade900,
          ),
        ),
      ),
      child: Scaffold(
        drawer: DrawerMenu(isAdmin: widget.isAdmin),
        appBar: AppBar(
          title: Text(t['title']!),
          backgroundColor: Colors.blue.shade700,
          elevation: 2,
        ),
        body: FadeTransition(
          opacity: _fadeIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildCard(
                  icon: Icons.brightness_6,
                  title: t['theme']!,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isDark ? t['darkMode']! : t['lightMode']!),
                      Switch(
                        value: config.isDarkMode,
                        activeColor: Colors.blue.shade700,
                        onChanged: (v) => config.alternarTema(v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  icon: Icons.language,
                  title: t['language']!,
                  child: DropdownButton<String>(
                    value: config.idioma,
                    underline: const SizedBox(),
                    isExpanded: true,
                    dropdownColor:
                    isDark ? Colors.grey.shade800 : Colors.white,
                    onChanged: (String? novo) =>
                        config.mudarIdioma(novo ?? 'Português'),
                    items: ['Português', 'English', 'Español']
                        .map(
                          (idioma) => DropdownMenuItem(
                        value: idioma,
                        child: Text(idioma),
                      ),
                    )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  icon: Icons.lock_reset,
                  title: t['resetPassword']!,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          redefinirSenha(context, t['dev']!),
                      icon: const Icon(Icons.lock),
                      label: Text(t['resetPassword']!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => salvarConfiguracoes(context, t['snackbar']!),
          label: Text(t['save']!),
          icon: const Icon(Icons.save),
          backgroundColor: Colors.blue.shade700,
        ),
      ),
    );
  }

  // 🔹 Card bonitinho com ícone e sombra
  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
