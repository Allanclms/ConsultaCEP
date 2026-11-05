import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../modelos/endereco.dart';
import '../servicos/servico_cep.dart';
import '../widgets/cartao_endereco.dart';

class PaginaConsultaCep extends StatefulWidget {
  const PaginaConsultaCep({super.key});

  @override
  State<PaginaConsultaCep> createState() => _PaginaConsultaCepState();
}

class _PaginaConsultaCepState extends State<PaginaConsultaCep> {
  final _controleCep = TextEditingController();
  final _servico = ServicoCep();
  Endereco? _endereco;
  String? _erro;
  bool _carregando = false;

  Future<void> _consultar() async {
    if (_carregando) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _carregando = true;
      _erro = null;
      _endereco = null;
    });
    try {
      final resultado = await _servico.buscar(_controleCep.text);
      if (!mounted) return;
      setState(() => _endereco = resultado);
    } on ConsultaCepException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.mensagem);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erro = 'Ocorreu um erro inesperado.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    _controleCep.dispose();
    _servico.fechar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FB),
        title: const Text('Consulta CEP', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 18),
                Text('Encontre qualquer endereço', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Digite um CEP brasileiro para consultar os dados.',
                    style: TextStyle(fontSize: 15, color: Colors.black54)),
                const SizedBox(height: 26),
                const Text('CEP', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('campo_cep'),
                  controller: _controleCep,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _consultar(),
                  decoration: const InputDecoration(hintText: 'Ex.: 01001000'),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    key: const Key('botao_consultar'),
                    onPressed: _carregando ? null : _consultar,
                    child: _carregando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Consultar CEP'),
                  ),
                ),
                if (_erro != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    key: const Key('mensagem_erro'),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      Expanded(child: Text(_erro!, style: const TextStyle(color: Color(0xFF991B1B)))),
                    ]),
                  ),
                ],
                if (_endereco != null) ...[
                  const SizedBox(height: 20),
                  CartaoEndereco(key: const Key('resultado_cep'), endereco: _endereco!),
                ],
                const SizedBox(height: 36),
                const Center(child: Text('Dados fornecidos por ViaCEP', style: TextStyle(fontSize: 12, color: Colors.black45))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
