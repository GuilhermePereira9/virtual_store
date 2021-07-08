import 'package:cloud_functions/cloud_functions.dart';
import 'package:virtual_store/models/credit_card.dart';
import 'package:virtual_store/models/user.dart';

class CieloPayment {
  final CloudFunctions functions = CloudFunctions.instance;

  Future<void> authorize(
      {CreditCard creditCard, num price, String orderId, User user}) async {
    final Map<String, dynamic> dataSale = {
      'mercantOrderId': orderId,
      'amount': (price * 100).toInt(),
      'softDescriptor': 'Violent Store',
      'installments': 12,
      'creditCard': creditCard.toJson(),
      'cpf': user.cpf,
      'paymentType': 'creditCard',
    };

    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'authorizeCreditCard');
    final response = await callable.call(dataSale);
    print(response.data);
  }
}
