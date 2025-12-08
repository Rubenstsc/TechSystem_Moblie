import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/config_provider.dart';

import 'abrir_chamado_page.dart';
import 'notificacoes_page.dart';
import 'configuracoes_page.dart';
import 'relatorios_page.dart';

class HomeUserPage extends StatelessWidget {
  const HomeUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);

    String getText(String pt, String en, String es) {
      switch (config.idioma) {
        case 'English':
          return en;
        case 'Español':
          return es;
        default:
          return pt;
      }
    }

    return Scaffold(
      drawer: const DrawerMenuUser(isAdmin: false),
      appBar: AppBar(
        title: Text(getText(
            'TechSystem - Usuário', 'TechSystem - User', 'TechSystem - Usuario')),
        backgroundColor: Colors.blue.shade700,
      ),
      backgroundColor: Colors.grey.shade200,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Text(
              getText("Resumo dos Chamados", "Ticket Summary", "Resumen de Tickets"),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Center(
              child: SizedBox(
                height: 220,
                width: 220,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 45,
                    sectionsSpace: 2,
                    sections: [
                      PieChartSectionData(
                        value: 2,
                        color: Colors.orange,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 5,
                        color: Colors.teal,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 3,
                        color: Colors.green,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Legend(color: Colors.orange, text: "Abertos"),
                SizedBox(width: 15),
                Legend(color: Colors.teal, text: "Em Andamento"),
                SizedBox(width: 15),
                Legend(color: Colors.green, text: "Concluídos"),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              getText("Dados Gerais", "General Data", "Datos Generales"),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.35,
              children: [
                InfoCard(
                  title: getText("Total de Chamados", "Total Tickets", "Tickets Totales"),
                  value: "6",
                  color: Colors.purple,
                ),
                InfoCard(
                  title: getText("Tempo Médio", "Avg Time", "Tiempo Medio"),
                  value: "1h 45m",
                  color: Colors.blue,
                ),
                InfoCard(
                  title: getText("Satisfação", "Satisfaction", "Satisfacción"),
                  value: "88%",
                  color: Colors.green,
                ),
                InfoCard(
                  title: getText("Abertos", "Open", "Abiertos"),
                  value: "1",
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 28),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.1,
              children: [
                MenuCard(
                  icon: Icons.add_circle_outline,
                  text: getText("Abrir Chamado", "Open Ticket", "Abrir Ticket"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AbrirChamadoPage(isAdmin: false),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.list_alt,
                  text: getText("Meus Chamados", "My Tickets", "Mis Tickets"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RelatoriosPage(isAdmin: false),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.notifications_none,
                  text: getText("Notificações", "Notifications", "Notificaciones"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificacoesPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.settings,
                  text: getText("Configurações", "Settings", "Configuraciones"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfiguracoesPage(isAdmin: false),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// LEGENDA
//////////////////////////////////////////////////////////////
class Legend extends StatelessWidget {
  final Color color;
  final String text;

  const Legend({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////
// CARD DAS ESTATÍSTICAS
//////////////////////////////////////////////////////////////
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
          Text(
            value,
            style: const TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// CARD DO MENU
//////////////////////////////////////////////////////////////
class MenuCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(2, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: Colors.blue[700]),
            const SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// DRAWER
//////////////////////////////////////////////////////////////
class DrawerMenuUser extends StatelessWidget {
  final bool isAdmin;

  const DrawerMenuUser({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);

    String getText(String pt, String en, String es) {
      switch (config.idioma) {
        case 'English':
          return en;
        case 'Español':
          return es;
        default:
          return pt;
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade700),
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue, size: 45),
            ),
          ),

          _item(Icons.home, getText('Início', 'Home', 'Inicio'), () {
            Navigator.pop(context);
          }),

          _item(Icons.add_circle_outline,
              getText('Abrir Chamado', 'Open Ticket', 'Abrir Ticket'), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const AbrirChamadoPage(isAdmin: false)),
                );
              }),

          _item(Icons.notifications,
              getText('Notificações', 'Notifications', 'Notificaciones'), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificacoesPage()),
                );
              }),

          _item(Icons.settings,
              getText('Configurações', 'Settings', 'Configuraciones'), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const ConfiguracoesPage(isAdmin: false)),
                );
              }),

          _item(Icons.logout, getText('Sair', 'Logout', 'Salir'), () {
            _confirmarSaida(context);
          }),
        ],
      ),
    );
  }

  static ListTile _item(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  void _confirmarSaida(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja sair do aplicativo?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            child: const Text('Sair'),
          )
        ],
      ),
    );
  }
}
