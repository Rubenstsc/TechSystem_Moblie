import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/config_provider.dart';
import '../widgets/drawer_menu.dart';

class NotificacoesPage extends StatefulWidget {
  final bool isAdmin;

  const NotificacoesPage({super.key, this.isAdmin = false});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  // 🔹 Lista simulada de notificações
  final List<Map<String, dynamic>> _notificacoes = [
    {
      'id': 10,
      'mensagem': "O status do seu chamado #10 mudou para 'concluído'",
      'data': '01/11/2025 09:32',
      'lida': false,
    },
    {
      'id': 14,
      'mensagem': "O status do seu chamado #14 mudou para 'cancelado'",
      'data': '31/10/2025 19:01',
      'lida': true,
    },
    {
      'id': 1,
      'mensagem': "O status do seu chamado #1 foi atualizado para 'concluído'",
      'data': '31/10/2025 10:54',
      'lida': true,
    },
    {
      'id': 10,
      'mensagem': "O status do seu chamado #10 mudou para 'cancelado'",
      'data': '31/10/2025 10:21',
      'lida': true,
    },
  ];

  void marcarComoLida(int index) {
    setState(() {
      _notificacoes[index]['lida'] = true;
    });
  }

  void limparNotificacoesLidas(BuildContext context, String mensagem) {
    setState(() {
      _notificacoes.removeWhere((n) => n['lida'] == true);
    });

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
    final isDark = config.isDarkMode;

    // 🔹 Textos traduzidos
    final traducoes = {
      'Português': {
        'title': 'Minhas Notificações',
        'markRead': 'Marcar como lida',
        'read': 'Lida',
        'clearRead': 'Limpar Lidas',
        'cleared': 'Notificações lidas foram removidas.',
        'updated': 'Chamado # atualizado',
      },
      'English': {
        'title': 'My Notifications',
        'markRead': 'Mark as read',
        'read': 'Read',
        'clearRead': 'Clear Read',
        'cleared': 'Read notifications have been removed.',
        'updated': 'Ticket # updated',
      },
      'Español': {
        'title': 'Mis Notificaciones',
        'markRead': 'Marcar como leída',
        'read': 'Leída',
        'clearRead': 'Limpiar Leídas',
        'cleared': 'Notificaciones leídas fueron eliminadas.',
        'updated': 'Caso # actualizado',
      },
    };

    final t = traducoes[config.idioma]!;

    return AnimatedTheme(
      duration: const Duration(milliseconds: 400),
      data: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: Colors.blue.shade700,
        scaffoldBackgroundColor:
        isDark ? Colors.grey.shade900 : Colors.blue.shade50,
        cardColor: isDark ? Colors.grey.shade800 : Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey.shade900,
          ),
        ),
      ),
      child: Scaffold(
        drawer: DrawerMenu(isAdmin: widget.isAdmin),
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.notifications, color: Colors.white),
              const SizedBox(width: 8),
              Text(t['title']!),
            ],
          ),
          backgroundColor: Colors.blue.shade700,
        ),
        body: Stack(
          children: [
            // 🔹 Lista de notificações
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notificacoes.length,
              itemBuilder: (context, index) {
                final notificacao = _notificacoes[index];
                final bool lida = notificacao['lida'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isDark ? Colors.white12 : Colors.black26,
                    ),
                  ),
                  color: lida
                      ? (isDark ? Colors.grey.shade800 : Colors.grey[200])
                      : (isDark ? Colors.grey.shade900 : Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 🔹 Cabeçalho com título e data
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${t['updated']} ${notificacao['id']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              notificacao['data'],
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                isDark ? Colors.white60 : Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // 🔹 Mensagem da notificação
                        Text(
                          notificacao['mensagem'],
                          style: TextStyle(
                            fontSize: 14,
                            color: lida
                                ? (isDark
                                ? Colors.white54
                                : Colors.black54)
                                : (isDark
                                ? Colors.white
                                : Colors.black),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 🔹 Botão "Lida" ou "Marcar como lida"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: lida
                                ? null
                                : () => marcarComoLida(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lida
                                  ? Colors.grey
                                  : Colors.blue.shade700,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              lida ? t['read']! : t['markRead']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // 🔹 Botão flutuante "Limpar Lidas"
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                onPressed: () =>
                    limparNotificacoesLidas(context, t['cleared']!),
                label: Text(t['clearRead']!),
                icon: const Icon(Icons.delete_outline),
                backgroundColor: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
