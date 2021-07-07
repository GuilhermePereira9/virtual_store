import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:virtual_store/screens/checkout/components/card_text_field.dart';

class CardFront extends StatelessWidget {
  final dateFormatter = MaskTextInputFormatter(
      mask: '!#/##', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  CardFront({this.numberFocus, this.dateFocus, this.nameFocus, this.finished});

  final VoidCallback finished;

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 16,
        child: Container(
          height: 200,
          color: const Color(0xFF000000),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CardTextField(
                    title: 'Numero',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormattters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter()
                    ],
                    validator: (number) {
                      if (number.length != 19)
                        return 'Insira um Numero Valido';
                      else if (detectCCType(number) == CreditCardType.unknown)
                        return 'Numero do Cartão Invalido';
                      return null;
                    },
                    onSubmitted: (_) {
                      dateFocus.requestFocus();
                    },
                    focusNode: numberFocus,
                  ),
                  CardTextField(
                    title: 'Validade',
                    hint: '07/25',
                    textInputType: TextInputType.number,
                    inputFormattters: [
                      dateFormatter,
                    ],
                    validator: (date) {
                      if (date.length != 5) return 'Insira uma data Valida';
                      return null;
                    },
                    onSubmitted: (_) {
                      nameFocus.requestFocus();
                    },
                    focusNode: dateFocus,
                  ),
                  CardTextField(
                    title: 'Titular',
                    hint: 'Jonh Dear',
                    textInputType: TextInputType.text,
                    bold: true,
                    validator: (name) {
                      if (name.isEmpty) return 'Insira o nome do titular';
                      return null;
                    },
                    onSubmitted: (_) {
                      finished();
                    },
                    focusNode: nameFocus,
                  ),
                ],
              ))
            ],
          ),
        ));
  }
}
