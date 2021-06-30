import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/common/custom_icon_button.dart';
import 'package:virtual_store/models/address.dart';
import 'package:virtual_store/models/cart_manager.dart';

class CepInputField extends StatefulWidget {
  const CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

final TextEditingController cepController = TextEditingController();

class _CepInputFieldState extends State<CepInputField> {
  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;
    if (widget.address.zipCode == null)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            enabled: !cartManager.loading,
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
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          ElevatedButton(
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      try {
                        await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('$e'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onSurface: Theme.of(context).primaryColor.withAlpha(100)),
            child: const Text('Buscar CEP'),
          )
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: () {
                context.read<CartManager>().removeAddress();
              },
            )
          ],
        ),
      );
  }
}
