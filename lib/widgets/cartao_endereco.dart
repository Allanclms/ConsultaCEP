import 'package:flutter/material.dart';
import '../modelos/endereco.dart';

class CartaoEndereco extends StatelessWidget {
  final Endereco endereco;
  const CartaoEndereco({super.key, required this.endereco});

  @override
  Widget build(BuildContext context) {
    Widget linha(String titulo, String valor) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 2),
                  Text(valor.isEmpty ? 'Não informado' : valor,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Endereço encontrado', style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 28),
            linha('CEP', endereco.cep),
            linha('Logradouro', endereco.logradouro),
            linha('Bairro', endereco.bairro),
            linha('Cidade / UF', '${endereco.cidade} / ${endereco.uf}'),
            linha('Complemento', endereco.complemento),
            linha('DDD', endereco.ddd),
          ],
        ),
      ),
    );
  }
}
