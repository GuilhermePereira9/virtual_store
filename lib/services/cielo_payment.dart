import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:virtual_store/models/credit_card.dart';
import 'package:virtual_store/models/user.dart';

class CieloPayment {
  final CloudFunctions functions = CloudFunctions.instance;

  Future<String> authorize(
      {CreditCard creditCard,
      num price,
      String orderId,
      User user,
      int installments}) async {
    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Violent Book',
        'installments': installments,
        'creditCard': creditCard.toJson(),
        'cpf': user.cpf,
        'paymentType': 'CreditCard',
      };

      final HttpsCallable callable =
          functions.getHttpsCallable(functionName: 'authorizeCreditCard');
      callable.timeout = const Duration(seconds: 60);
      final response = await callable.call(dataSale);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente Novamente.');
    }
  }

  Future<void> capture(String payId) async {
    final Map<String, dynamic> captureData = {'payId': payId};
    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'captureCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(captureData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Captura realizada deu bom!');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {'payId': payId};
    final HttpsCallable callable =
        functions.getHttpsCallable(functionName: 'cancelCreditCard');
    callable.timeout = const Duration(seconds: 60);
    final response = await callable.call(cancelData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Cancelamento realizado!');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }
}
