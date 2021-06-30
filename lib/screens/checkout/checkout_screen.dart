import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/common/price_card.dart';
import 'package:virtual_store/models/cart_manager.dart';
import 'package:virtual_store/models/checkout_manager.dart';

class CheckOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckOutManager>(
      create: (_) => CheckOutManager(),
      update: (_, cartManager, checkOurManager) =>
          checkOurManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Pagamento'),
            centerTitle: true,
          ),
          body: Consumer<CheckOutManager>(
            builder: (_, checkOutManager, __) {
              return ListView(
                children: <Widget>[
                  PriceCard(
                    buttonText: 'Finalizar Pedido',
                    onPressed: () {
                      checkOutManager.checkOut();
                    },
                  )
                ],
              );
            },
          )),
    );
  }
}
