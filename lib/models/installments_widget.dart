import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/models/cart_manager.dart';

class InstallmentsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final totalPrice = cartManager.totalPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
        child: DropdownButton<int>(
            isExpanded: true,
            isDense: true,
            value: cartManager.installments,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 0,
            dropdownColor: Colors.grey[200],
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(),
            onChanged: (int value) {
              cartManager.installments = value;
            },
            items: getInstallments(totalPrice)
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                    "${value}x de R\$${(totalPrice / value).toStringAsFixed(2).replaceAll(".", ",")} sem juros.",
                    style: TextStyle(color: Colors.black)),
              );
            }).toList()),
      ),
    );
  }
}

List<int> getInstallments(num totalPrice) {
  const int valuePerInstallments = 20;
  final List<int> listInstallments = [];
  int installments = totalPrice ~/ valuePerInstallments;

  if (installments < 1)
    installments = 1;
  else if (installments > 6) installments = 6;
  for (int i = 1; i <= installments; i++) listInstallments.add(i);

  return listInstallments;
}
