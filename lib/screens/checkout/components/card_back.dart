import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_store/models/credit_card.dart';
import 'package:virtual_store/screens/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {
  const CardBack({this.cvvFocus, this.creditCard});

  final FocusNode cvvFocus;
  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        height: 200,
        color: const Color(0xFF4F4F4F),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 70,
                  child: Container(
                    color: Colors.grey[500],
                    margin: const EdgeInsets.only(left: 12),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: CardTextField(
                      initialValue: creditCard.securityCode,
                      hint: '123',
                      maxLength: 3,
                      inputFormattters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.end,
                      textInputType: TextInputType.number,
                      validator: (cvv) {
                        if (cvv.length != 3) return 'CVV Invalido';
                        return null;
                      },
                      focusNode: cvvFocus,
                      onSaved: creditCard.setCVV,
                    ),
                  ),
                ),
                Expanded(flex: 30, child: Container())
              ],
            )
          ],
        ),
      ),
    );
  }
}
