import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/common/price_card.dart';
import 'package:virtual_store/models/cart_manager.dart';
import 'package:virtual_store/models/checkout_manager.dart';
import 'package:virtual_store/models/credit_card.dart';
import 'package:virtual_store/screens/checkout/components/cpf_field.dart';
import 'package:virtual_store/screens/checkout/components/credit_card_widget.dart';

class CheckOutScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckOutManager>(
      create: (_) => CheckOutManager(),
      update: (_, cartManager, checkOurManager) =>
          checkOurManager..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text('Pagamento'),
            centerTitle: true,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Consumer<CheckOutManager>(
              builder: (_, checkOutManager, __) {
                if (checkOutManager.loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Processando seu pagamento...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Form(
                  key: formKey,
                  child: ListView(
                    children: <Widget>[
                      CreditCardWidget(creditCard),
                      CpfField(),
                      PriceCard(
                        buttonText: 'Finalizar Pedido',
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            checkOutManager.checkOut(
                                creditCard: creditCard,
                                onStockFail: (e) {
                                  Navigator.of(context).popUntil((route) =>
                                      route.settings.name == '/cart');
                                },
                                onPayFail: (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text('$e'),
                                    backgroundColor: Colors.red,
                                  ));
                                },
                                onSuccess: (order) {
                                  Navigator.of(context).popUntil(
                                      (route) => route.settings.name == '/');
                                  Navigator.of(context).pushNamed(
                                      '/confirmation',
                                      arguments: order);
                                });
                          }
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          )),
    );
  }
}
