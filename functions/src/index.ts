import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';

import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, CaptureRequestModel, CancelTransactionRequestModel, EnumBrands} from 'cielo';

admin.initializeApp(functions.config().firebase);

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//

const merchantId = functions.config().cielo.merchantId;
const merchantKey = functions.config().cielo.merchantKey;

const cieloParams: CieloConstructor = {
    merchantId: merchantId,
    merchantKey: merchantKey,
    sandbox: true,
    debug: true
}

const cielo = new Cielo(cieloParams);

export const authorizeCreditCard = functions.https.onCall(async (data, context) => {
    if(data === null){
        return {
        "sucess": false,
        "error": {
            "code": -1,
            "message": "Dados não informados"
        }
    };
    }
    if(!context.auth){
        return {
            "sucess": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuario Logado"
            }
        };
    }
    const userId = context.auth.uid;

    const snapshot = await admin.firestore().collection("users").doc(userId).get();
    const userData = snapshot.data;

    console.log("Inicializando Autorização");

    let brand: EnumBrands;
    switch(data.creditCard.brand){
        case "VISA":
            brand = EnumBrands.VISA;
            break;
        case "MASTERCARD":
            brand = EnumBrands.MASTER;
            break;
        case "AMEX":
            brand = EnumBrands.AMEX;
            break;
        case "ELO":
            brand = EnumBrands.ELO;
            break;
        case "JCB":
            brand = EnumBrands.JCB;
            break;
        case "DINERSCLUB":
            brand = EnumBrands.DINERS;
            break;
        case "DISCOVER":
            brand = EnumBrands.DISCOVERY;
            break;
        case "HIPERCARD":
            brand = EnumBrands.HIPERCARD;
            break;
        default:
            return {
                "sucess": false,
                "error": {
                    "code": -1,
                    "message": "Cartão não suportado: " + data.creditCard.brand
                }
            };
    }
});

export const helloWorld = functions.https.onCall((data, context) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  return {data: "Hello from Firebase!"};
});

export const getUserData = functions.https.onCall( async (data, context) => {
    if(!context.auth){
        return {
            "data": "Nenhum usuário logado"
        };
    }

    console.log(context.auth.uid);

    const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();

    console.log(snapshot.data());

    return {
        "data": snapshot.data()
    };
});

export const onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate((snapshot, context) => {
    const orderId = context.params.orderId;
    console.log(orderId);
}); 