import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String _idioma = 'Português';

  bool get isDarkMode => _isDarkMode;
  String get idioma => _idioma;

  // ✅ Compatível com HomeAdminPage (getter extra)
  String get currentLanguage {
    switch (_idioma) {
      case 'English':
        return 'en';
      case 'Español':
        return 'es';
      default:
        return 'pt';
    }
  }

  // ============================================================
  // 🌓 Alternar Tema com persistência
  // ============================================================
  void alternarTema(bool value) {
    _isDarkMode = value;
    _salvarPreferencias();
    notifyListeners();
  }

  // ============================================================
  // 🌍 Mudar Idioma com persistência
  // ============================================================
  void mudarIdioma(String novoIdioma) {
    _idioma = novoIdioma;
    _salvarPreferencias();
    notifyListeners();
  }

  // ============================================================
  // 💾 Persistência com SharedPreferences
  // ============================================================
  Future<void> carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _idioma = prefs.getString('idioma') ?? 'Português';
    notifyListeners();
  }

  Future<void> _salvarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setString('idioma', _idioma);
  }

  // ============================================================
  // 🌈 Configuração do Tema Global
  // ============================================================
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // ============================================================
  // 🌍 Sistema de Tradução leve
  // ============================================================
  static const Map<String, Map<String, String>> _traducoes = {
    'Português': {
      'home': 'Início',
      'abrir_chamado': 'Abrir Chamado',
      'relatorios': 'Relatórios',
      'notificacoes': 'Notificações',
      'configuracoes': 'Configurações',
      'sair': 'Sair',
      'ola': 'Olá',
      'painel_admin': 'Painel de Controle - Admin',
      'dados_gerais': 'Dados Gerais',
      'indicadores': 'Indicadores de Desempenho',
    },
    'English': {
      'home': 'Home',
      'abrir_chamado': 'Open Ticket',
      'relatorios': 'Reports',
      'notificacoes': 'Notifications',
      'configuracoes': 'Settings',
      'sair': 'Logout',
      'ola': 'Hello',
      'painel_admin': 'Admin Control Panel',
      'dados_gerais': 'General Data',
      'indicadores': 'Performance Indicators',
    },
    'Español': {
      'home': 'Inicio',
      'abrir_chamado': 'Abrir Ticket',
      'relatorios': 'Informes',
      'notificacoes': 'Notificaciones',
      'configuracoes': 'Configuraciones',
      'sair': 'Salir',
      'ola': 'Hola',
      'painel_admin': 'Panel de Control - Admin',
      'dados_gerais': 'Datos Generales',
      'indicadores': 'Indicadores de Rendimiento',
    },
  };

  // 🔹 Pega texto traduzido
  String t(String chave) {
    return _traducoes[_idioma]?[chave] ?? chave;
  }

  // 🔹 Locale para o MaterialApp
  Locale get locale {
    switch (_idioma) {
      case 'English':
        return const Locale('en', 'US');
      case 'Español':
        return const Locale('es', 'ES');
      default:
        return const Locale('pt', 'BR');
    }
  }
}
