import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';

class RelatoriosPage extends StatefulWidget {
  final bool isAdmin;

  const RelatoriosPage({super.key, required this.isAdmin});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage>
    with SingleTickerProviderStateMixin {
  late String _selectedStatus;
  late String _selectedPrioridade;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  final List<Map<String, String>> chamados = [
    {
      "id": "14",
      "usuario": "teste",
      "titulo": "Servidor caiu",
      "descricao": "O servidor da empresa caiu.",
      "status": "Cancelado",
      "prioridade": "Baixa",
      "data": "31/10/2025 19:00",
    },
    {
      "id": "13",
      "usuario": "Admin",
      "titulo": "Perdi a senha",
      "descricao": "Perdi a senha do app",
      "status": "Em Aberto",
      "prioridade": "Baixa",
      "data": "24/10/2025 07:59",
    },
    {
      "id": "12",
      "usuario": "teste",
      "titulo": "Mouse não funciona",
      "descricao": "Meu mouse caiu no chão e não liga.",
      "status": "Em Andamento",
      "prioridade": "Baixa",
      "data": "23/10/2025 19:29",
    },
    {
      "id": "11",
      "usuario": "David",
      "titulo": "Notebook não liga",
      "descricao": "Meu notebook parou de ligar.",
      "status": "Concluído",
      "prioridade": "Baixa",
      "data": "22/10/2025 17:35",
    },
  ];

  List<Map<String, String>> get _filteredChamados {
    return chamados.where((c) {
      final matchStatus =
          _selectedStatus == "Todos" || c["status"] == _selectedStatus;
      final matchPrioridade =
          _selectedPrioridade == "Todos" || c["prioridade"] == _selectedPrioridade;
      return matchStatus && matchPrioridade;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus = "Todos";
    _selectedPrioridade = "Todos";

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Concluído":
        return Colors.green.shade600;
      case "Em Andamento":
        return Colors.orange.shade600;
      case "Cancelado":
        return Colors.red.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "Concluído":
        return Icons.check_circle;
      case "Em Andamento":
        return Icons.timelapse;
      case "Cancelado":
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(isAdmin: widget.isAdmin),
      appBar: AppBar(
        title: const Text('Relatórios de Chamados'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeIn,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildFiltros(),
                const SizedBox(height: 20),
                Expanded(
                  child: _filteredChamados.isEmpty
                      ? const Center(
                    child: Text(
                      "Nenhum chamado encontrado",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                      : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredChamados.length,
                    itemBuilder: (context, index) {
                      final c = _filteredChamados[index];

                      return AnimatedBuilder(
                        animation: _fadeIn,
                        builder: (_, __) {
                          final opacity = _fadeIn.value.clamp(0.0, 1.0);
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - opacity)),
                            child: Opacity(
                              opacity: opacity,
                              child: _buildResponsiveCard(context, c),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Exportando relatório..."),
              duration: Duration(seconds: 2),
            ),
          );
        },
        icon: const Icon(Icons.picture_as_pdf),
        label: const Text("Exportar"),
        backgroundColor: Colors.blue.shade700,
      )
          : null,
    );
  }

  // -------------------------------------------------------
  // CARD RESPONSIVO — AGORA SEM OVERFLOW
  // -------------------------------------------------------
  Widget _buildResponsiveCard(BuildContext context, Map<String, String> c) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool narrow = constraints.maxWidth < 360;

        final Widget avatar = CircleAvatar(
          radius: 22,
          backgroundColor: _statusColor(c["status"]!),
          child: Icon(
            _statusIcon(c["status"]!),
            color: Colors.white,
            size: 20,
          ),
        );

        final Widget middle = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c["titulo"] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text("Usuário: ${c["usuario"]}",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text("Descrição: ${c["descricao"]}",
                maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Text("Prioridade: ${c["prioridade"]}",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            Text("Data: ${c["data"]}",
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        );

        final Widget trailing = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(c["status"]!).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FittedBox(
                child: Text(
                  c["status"] ?? '',
                  style: TextStyle(
                    color: _statusColor(c["status"]!),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _showDetalhes(context, c),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        );

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                avatar,

                SizedBox(
                  width: narrow
                      ? constraints.maxWidth - 24
                      : constraints.maxWidth * 0.60,
                  child: middle,
                ),

                SizedBox(
                  width: narrow ? constraints.maxWidth : 110,
                  child: Align(
                    alignment:
                    narrow ? Alignment.centerRight : Alignment.topCenter,
                    child: trailing,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // DETALHES DO CARD
  // ==========================================================
  void _showDetalhes(BuildContext context, Map<String, String> c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(c["titulo"] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Usuário: ${c["usuario"]}"),
              const SizedBox(height: 6),
              Text("Descrição: ${c["descricao"]}"),
              const SizedBox(height: 6),
              Text("Prioridade: ${c["prioridade"]}"),
              const SizedBox(height: 6),
              Text("Data: ${c["data"]}"),
              const SizedBox(height: 6),
              Text("Status: ${c["status"]}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          )
        ],
      ),
    );
  }

  // ==========================================================
  // FILTROS — 100% RESPONSIVOS (CORRIGIDO)
  // ==========================================================
  Widget _buildFiltros() {
    return LayoutBuilder(builder: (context, constraints) {
      final bool small = constraints.maxWidth < 380;

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: small ? constraints.maxWidth : 160,
              child: _buildDropdown(
                "Status",
                _selectedStatus,
                ["Todos", "Em Aberto", "Em Andamento", "Concluído", "Cancelado"],
                    (v) => setState(() => _selectedStatus = v ?? "Todos"),
              ),
            ),
            SizedBox(
              width: small ? constraints.maxWidth : 160,
              child: _buildDropdown(
                "Prioridade",
                _selectedPrioridade,
                ["Todos", "Baixa", "Média", "Alta"],
                    (v) => setState(() => _selectedPrioridade = v ?? "Todos"),
              ),
            ),
            SizedBox(
              width: small ? constraints.maxWidth : 150,
              child: ElevatedButton.icon(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text("Atualizar"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================================
  // DROPDOWN — FIX FINAL PARA OVERFLOW
  // ==========================================================
  Widget _buildDropdown(
      String label,
      String value,
      List<String> items,
      ValueChanged<String?> onChange,
      ) {
    return DropdownButtonFormField<String>(
      isExpanded: true, // 🔥 IMPORTANTE
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      value: value,
      items: items
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(
          e,
          overflow: TextOverflow.ellipsis,
        ),
      ))
          .toList(),
      onChanged: onChange,
    );
  }
}
