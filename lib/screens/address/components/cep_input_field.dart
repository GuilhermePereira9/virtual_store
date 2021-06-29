import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/models/cart_manager.dart';

class CepInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cepController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: cepController,
          decoration: const InputDecoration(
              isDense: true, labelText: 'CEP', hintText: '12.123-234'),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CepInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          validator: (cep) {
            if (cep.isEmpty)
              return 'Campo Obrigatorio';
            else if (cep.length != 10) return 'Cep Invalido';
            return null;
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (Form.of(context).validate()) {
              context.read<CartManager>().getAddress(cepController.text);
            }
          },
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              onSurface: Theme.of(context).primaryColor.withAlpha(100)),
          child: const Text('Buscar CEP'),
        )
      ],
    );
  }
}
