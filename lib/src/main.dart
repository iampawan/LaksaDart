import 'dart:math';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
// import 'package:crypto/crypto.dart';

import 'package:http/http.dart' as http;
import 'package:laksaDart/src/utils/numbers.dart' as numbers;
import 'package:laksaDart/src/utils/validators.dart' as validators;
import 'package:laksaDart/src/crypto/dartRandom.dart';
import 'package:laksaDart/src/account/wallet.dart';
import 'package:laksaDart/src/account/account.dart';
import 'package:laksaDart/src/account/address.dart';

import 'package:laksaDart/src/utils/unit.dart' as unit;

import 'package:laksaDart/src/provider/Http.dart';
import 'package:laksaDart/src/provider/net.dart';
import 'package:laksaDart/src/provider/Middleware.dart';
import 'package:laksaDart/src/messenger/Messenger.dart';
import 'package:laksaDart/src/transaction/transaction.dart';

import 'Laksa.dart' show Laksa;

main() async {
  // var provider = new HttpProvider('https://staging-api.aws.zilliqa.com');
  // provider.middleware.response
  //     .use((data) => new RPCMiddleWare(data), match: '*');
  // // provider.middleware.response.use((Map data) => data['result'], match: '*');
  // var result = await provider.send(RPCMethod.GetNetworkId, '');
  // var messenger = new Messenger(nodeProvider: provider);

  Laksa laksa = new Laksa('https://api.zilliqa.com');

  var acc = laksa.wallet
      .add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');
  var test = BigInt.from(2);
  var test2 = BigInt.from(3);
  await acc.updateBalance();
  print(acc.balance);
  // print(new ZilAddress('4BAF5FADA8E5DB92C3D3242618C5B47133AE003C')
  //     .checkSumAddress); // ==
  //'0x4BAF5faDA8e5Db92C3d3242618c5B47133AE003C');

  // var mGasPrice = await laksa.blockchain.getMinimumGasPrice();
  // // print('mGasPrice:${mGasPrice.result.toString()}');
  // // // await acc.updateBalance();
  // // // print(acc.balance);

  // Transaction txn = laksa.transactions.newTx({
  //   'version': 1,
  //   'toAddr': '2E3C9B415B19AE4035503A06192A0FAD76E04243',
  //   'amount': BigInt.from(123),
  //   'gasPrice': BigInt.from(num.parse(
  //       mGasPrice.result != null ? mGasPrice.result.toString() : '1000000000')),
  //   'gasLimit': 1,
  // });

  // var signed = await acc.signTransaction(txn);
  // print(signed.toPayload);
  // var sent = await signed.sendTransaction();
  // if (sent.transaction.TranID != null) {
  //   print(sent.transaction.TranID);
  //   var confirmed =
  //       await sent.transaction.confirm(txHash: sent.transaction.TranID);
  //   print(confirmed.TranID);
  // }

  // print(sent.transaction.TranID);
}
