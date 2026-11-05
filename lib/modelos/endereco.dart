class Endereco {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String cidade;
  final String uf;
  final String ddd;

  const Endereco({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.uf,
    required this.ddd,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    String texto(String chave) => (json[chave] ?? '').toString();
    return Endereco(
      cep: texto('cep'),
      logradouro: texto('logradouro'),
      complemento: texto('complemento'),
      bairro: texto('bairro'),
      cidade: texto('localidade'),
      uf: texto('uf'),
      ddd: texto('ddd'),
    );
  }
}
