import 'package:flutter/material.dart';
import '../pages/home_admin_page.dart';
import '../pages/home_user_page.dart';
import '../pages/abrir_chamado_page.dart';
import '../pages/relatorios_page.dart';
import '../pages/notificacoes_page.dart';
import '../pages/configuracoes_page.dart';

class DrawerMenu extends StatelessWidget {
  final bool isAdmin;

  const DrawerMenu({super.key, required this.isAdmin});

  void _confirmarSaida(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deseja sair mesmo?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Não"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            },
            child: const Text("Sim"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔹 Cabeçalho do Drawer
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blue, size: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  isAdmin ? 'Administrador' : 'Usuário',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Início
          _drawerItem(Icons.home, 'Início', () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                isAdmin ? const HomeAdminPage() : const HomeUserPage(),
              ),
            );
          }),

          // 🔹 Abrir Chamado
          _drawerItem(Icons.add_circle_outline, 'Abrir Chamado', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AbrirChamadoPage(isAdmin: isAdmin),
              ),
            );
          }),

          // 🔹 Relatórios (somente admin)
          if (isAdmin)
            _drawerItem(Icons.bar_chart, 'Relatórios', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RelatoriosPage(isAdmin: isAdmin),
                ),
              );
            }),

          // 🔹 Notificações
          _drawerItem(Icons.notifications, 'Notificações', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificacoesPage(isAdmin: isAdmin),
              ),
            );
          }),

          // 🔹 Configurações
          _drawerItem(Icons.settings, 'Configurações', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfiguracoesPage(isAdmin: isAdmin),
              ),
            );
          }),

          // 🔹 Sair
          _drawerItem(Icons.logout, 'Sair', () {
            _confirmarSaida(context);
          }),
        ],
      ),
    );
  }

  // 🔹 Função para criar item do Drawer
  static ListTile _drawerItem(
      IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
