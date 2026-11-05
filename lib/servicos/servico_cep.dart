import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/endereco.dart';

class ConsultaCepException implements Exception {
  final String mensagem;
  const ConsultaCepException(this.mensagem);
  @override
  String toString() => mensagem;
}

class ServicoCep {
  final http.Client _cliente;
  ServicoCep({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  Future<Endereco> buscar(String entrada) async {
    final cep = entrada.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      throw const ConsultaCepException('Digite um CEP com 8 números.');
    }

    try {
      final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      final resposta = await _cliente.get(url).timeout(const Duration(seconds: 12));
      if (resposta.statusCode != 200) {
        throw const ConsultaCepException('Não foi possível consultar o CEP.');
      }
      final json = jsonDecode(utf8.decode(resposta.bodyBytes));
      if (json is! Map<String, dynamic>) {
        throw const ConsultaCepException('Resposta inesperada da API.');
      }
      if (json['erro'] == true || json['erro'] == 'true') {
        throw const ConsultaCepException('CEP não encontrado.');
      }
      return Endereco.fromJson(json);
    } on TimeoutException {
      throw const ConsultaCepException('A consulta demorou demais. Tente novamente.');
    } on http.ClientException {
      throw const ConsultaCepException('Falha de conexão. Verifique sua internet.');
    } on FormatException {
      throw const ConsultaCepException('Os dados recebidos não são válidos.');
    }
  }

  void fechar() => _cliente.close();
}
