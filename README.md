# Consulta CEP — Flutter

Aplicativo desenvolvido como atividade da disciplina de desenvolvimento mobile. Ele consome uma API REST externa, realiza uma requisição HTTP `GET`, interpreta o JSON recebido e apresenta os dados na interface.

## API escolhida

- **Nome:** ViaCEP
- **Site e documentação:** https://viacep.com.br/
- **Exemplo de endpoint:** https://viacep.com.br/ws/01001000/json/
- **Método:** GET
- **Formato:** JSON
- **Autenticação:** não é necessária

## Funcionalidades

- Campo para digitar CEP com oito números.
- Busca assíncrona com indicação de carregamento.
- Visualização de CEP, logradouro, bairro, cidade, UF, complemento e DDD.
- Mensagens para CEP inválido, inexistente e falhas de conexão.

## Executando o aplicativo

1. Instale Flutter, Dart e os componentes do Android ou use um dispositivo compatível.
2. Abra a pasta deste projeto no VS Code.
3. Como este pacote contém o código-fonte e as configurações, **gere as pastas de plataforma** usando `flutter create --platforms=android,ios,web .`
4. Execute `flutter pub get` e depois `flutter run`.
5. Para testes automatizados, use `flutter test`.

## Organização

- `lib/main.dart`: inicialização e tema do aplicativo.
- `lib/paginas/pagina_consulta_cep.dart`: entrada, estados da requisição e interface.
- `lib/servicos/servico_cep.dart`: HTTP, JSON, async/await e erros.
- `lib/modelos/endereco.dart`: modelo de dados.
- `lib/widgets/cartao_endereco.dart`: apresentação do resultado.
- `test/servico_cep_test.dart`: testes com API simulada (MockClient).
