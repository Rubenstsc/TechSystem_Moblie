import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/config_provider.dart';
import '../pages/abrir_chamado_page.dart';
import '../pages/configuracoes_page.dart';
import '../pages/notificacoes_page.dart';
import '../pages/relatorios_page.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ==========================================================
  // UI PRINCIPAL
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);
    final isDark = config.isDarkMode;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      drawer: const DrawerMenu(isAdmin: true),
      appBar: AppBar(
        title: Text(config.currentLanguage == 'pt'
            ? 'Painel de Controle - Admin'
            : 'Admin Dashboard'),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.currentLanguage == 'pt'
                          ? 'Resumo dos Chamados'
                          : 'Ticket Summary',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildChartSection(isWide),
                    const SizedBox(height: 24),
                    Text(
                      config.currentLanguage == 'pt'
                          ? 'Dados Gerais'
                          : 'General Data',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Total de Chamados'
                              : 'Total Tickets',
                          value: '11',
                          color: Colors.purple,
                          delay: 100,
                        ),
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Abertos'
                              : 'Open',
                          value: '2',
                          color: Colors.orange,
                          delay: 200,
                        ),
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Em Andamento'
                              : 'In Progress',
                          value: '5',
                          color: Colors.teal,
                          delay: 300,
                        ),
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Concluídos'
                              : 'Closed',
                          value: '4',
                          color: Colors.green,
                          delay: 400,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      config.currentLanguage == 'pt'
                          ? 'Indicadores de Desempenho'
                          : 'Performance Indicators',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Tempo Médio de Resposta'
                              : 'Avg. Response Time',
                          value: '2h 30min',
                          color: Colors.blueAccent,
                          delay: 500,
                        ),
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Satisfação do Cliente'
                              : 'Customer Satisfaction',
                          value: '92%',
                          color: Colors.greenAccent,
                          delay: 600,
                        ),
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Chamados Urgentes'
                              : 'Urgent Tickets',
                          value: '1',
                          color: Colors.redAccent,
                          delay: 700,
                        ),
                        AnimatedDashboardCard(
                          title: config.currentLanguage == 'pt'
                              ? 'Equipe Ativa'
                              : 'Active Team',
                          value: '5 Técnicos',
                          color: Colors.indigo,
                          delay: 800,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
    );
  }

  // ==========================================================
  // SEÇÃO DO GRÁFICO
  // ==========================================================
  Widget _buildChartSection(bool isWide) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 250,
            width: isWide ? 400 : double.infinity,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                startDegreeOffset: -90,
                sections: [
                  PieChartSectionData(color: Colors.orange, value: 2, title: ''),
                  PieChartSectionData(color: Colors.teal, value: 5, title: ''),
                  PieChartSectionData(color: Colors.green, value: 4, title: ''),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: const [
              LegendItem(color: Colors.orange, text: 'Abertos'),
              LegendItem(color: Colors.teal, text: 'Em Andamento'),
              LegendItem(color: Colors.green, text: 'Concluídos'),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// Animated Dashboard Card
// ==========================================================
class AnimatedDashboardCard extends StatefulWidget {
  final String title;
  final String value;
  final Color color;
  final int delay;

  const AnimatedDashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.delay = 0,
  });

  @override
  State<AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double cardWidth = width < 600 ? (width / 2 - 24).toDouble() : 230.0;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: cardWidth,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 15)),
              const SizedBox(height: 8),
              Text(
                widget.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// Drawer Menu
// ==========================================================
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
          _drawerItem(Icons.home, 'Início', () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.add_circle_outline, 'Abrir Chamado', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AbrirChamadoPage(isAdmin: isAdmin),
              ),
            );
          }),
          if (isAdmin)
            _drawerItem(Icons.bar_chart, 'Relatórios', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RelatoriosPage(isAdmin: isAdmin),
                ),
              );
            }),
          _drawerItem(Icons.notifications, 'Notificações', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificacoesPage(isAdmin: isAdmin),
              ),
            );
          }),
          _drawerItem(Icons.settings, 'Configurações', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfiguracoesPage(isAdmin: isAdmin),
              ),
            );
          }),
          _drawerItem(Icons.logout, 'Sair', () => _confirmarSaida(context)),
        ],
      ),
    );
  }

  static ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

// ==========================================================
// Legend Item
// ==========================================================
class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
