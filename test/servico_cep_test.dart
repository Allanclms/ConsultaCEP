import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:consulta_cep_flutter/servicos/servico_cep.dart';

void main() {
  test('Converte JSON da API para endereço', () async {
    final cliente = MockClient((request) async {
      expect(request.url.toString(), 'https://viacep.com.br/ws/01001000/json/');
      return http.Response(jsonEncode({
        'cep': '01001-000', 'logradouro': 'Praça da Sé', 'complemento': 'lado ímpar',
        'bairro': 'Sé', 'localidade': 'São Paulo', 'uf': 'SP', 'ddd': '11'
      }), 200, headers: {'content-type': 'application/json; charset=utf-8'});
    });
    final servico = ServicoCep(cliente: cliente);
    final endereco = await servico.buscar('01001-000');
    expect(endereco.cidade, 'São Paulo');
    expect(endereco.logradouro, 'Praça da Sé');
    servico.fechar();
  });

  test('Rejeita CEP incompleto', () async {
    final servico = ServicoCep(cliente: MockClient((_) async => http.Response('{}', 200)));
    expect(() => servico.buscar('123'), throwsA(isA<ConsultaCepException>()));
    servico.fechar();
  });

  test('Trata CEP inexistente', () async {
    final servico = ServicoCep(cliente: MockClient((_) async => http.Response('{"erro":true}', 200)));
    expect(() => servico.buscar('99999999'), throwsA(isA<ConsultaCepException>()));
    servico.fechar();
  });
}
