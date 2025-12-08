import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/config_provider.dart';
import '../widgets/drawer_menu.dart';

class AbrirChamadoPage extends StatefulWidget {
  final bool isAdmin;
  const AbrirChamadoPage({super.key, this.isAdmin = true});

  @override
  State<AbrirChamadoPage> createState() => _AbrirChamadoPageState();
}

class _AbrirChamadoPageState extends State<AbrirChamadoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _analiseController = TextEditingController();
  String? _prioridade;
  bool _loading = false;

  // 🔹 Função de tradução com base no idioma do provider
  String getText(ConfigProvider config, String pt, String en, String es) {
    switch (config.idioma) {
      case 'English':
        return en;
      case 'Español':
        return es;
      default:
        return pt;
    }
  }

  // 🔹 Função simulada de análise via IA (OpenAI)
  Future<void> _gerarAnaliseIA() async {
    if (_tituloController.text.isEmpty || _descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o título e a descrição antes de gerar a análise.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer SUA_API_KEY_AQUI', // substitua pela sua key
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system",
              "content": "Você é uma IA que ajuda a analisar chamados técnicos."
            },
            {
              "role": "user",
              "content":
              "Analise o seguinte chamado:\nTítulo: ${_tituloController.text}\nDescrição: ${_descricaoController.text}\nPrioridade: $_prioridade.\nGere um resumo técnico e possíveis causas e soluções."
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final analise = data['choices'][0]['message']['content'];
        setState(() => _analiseController.text = analise);
      } else {
        throw Exception('Erro ao chamar API: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar análise: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context);

    return Scaffold(
      drawer: DrawerMenu(isAdmin: widget.isAdmin),
      appBar: AppBar(
        title: Text(getText(config, 'Abrir Chamado', 'Open Ticket', 'Abrir Ticket')),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getText(config, 'Informações do Chamado', 'Ticket Information', 'Información del Ticket'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Campo título
                  TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      labelText: getText(config, 'Título do Chamado', 'Ticket Title', 'Título del Ticket'),
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) => value!.isEmpty
                        ? getText(config, 'Digite o título do chamado', 'Enter the ticket title', 'Ingrese el título del ticket')
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Campo descrição
                  TextFormField(
                    controller: _descricaoController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: getText(config, 'Descrição', 'Description', 'Descripción'),
                      alignLabelWithHint: true,
                      prefixIcon: const Icon(Icons.description_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) => value!.isEmpty
                        ? getText(config, 'Digite a descrição do chamado', 'Enter the ticket description', 'Ingrese la descripción del ticket')
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Prioridade
                  DropdownButtonFormField<String>(
                    value: _prioridade,
                    items: [
                      DropdownMenuItem(
                        value: 'Baixa',
                        child: Text(getText(config, 'Baixa', 'Low', 'Baja')),
                      ),
                      DropdownMenuItem(
                        value: 'Média',
                        child: Text(getText(config, 'Média', 'Medium', 'Media')),
                      ),
                      DropdownMenuItem(
                        value: 'Alta',
                        child: Text(getText(config, 'Alta', 'High', 'Alta')),
                      ),
                      DropdownMenuItem(
                        value: 'Crítica',
                        child: Text(getText(config, 'Crítica', 'Critical', 'Crítica')),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: getText(config, 'Prioridade', 'Priority', 'Prioridad'),
                      prefixIcon: const Icon(Icons.flag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => setState(() => _prioridade = value),
                    validator: (value) =>
                    value == null ? getText(config, 'Selecione a prioridade', 'Select a priority', 'Seleccione la prioridad') : null,
                  ),
                  const SizedBox(height: 24),

                  // 🔹 Botão da IA
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _gerarAnaliseIA,
                      icon: const Icon(Icons.search),
                      label: Text(
                        _loading
                            ? getText(config, 'Gerando análise...', 'Generating analysis...', 'Generando análisis...')
                            : getText(config, 'Gerar Análise da IA', 'Generate AI Analysis', 'Generar Análisis de IA'),
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Campo da análise
                  Text(
                    getText(config, 'Análise Detalhada da IA:', 'Detailed AI Analysis:', 'Análisis Detallado de la IA:'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _analiseController,
                    maxLines: 8,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // 🔹 Botão flutuante
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(getText(
                        config,
                        'Chamado aberto com sucesso!',
                        'Ticket opened successfully!',
                        '¡Ticket abierto con éxito!',
                      )),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              label: Text(getText(config, 'Enviar Chamado', 'Submit Ticket', 'Enviar Ticket')),
              icon: const Icon(Icons.send),
              backgroundColor: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
