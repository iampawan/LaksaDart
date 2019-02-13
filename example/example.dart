import 'dart:convert';
import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:crypto/src/digest_sink.dart';
import "package:pointycastle/ecc/ecc_fp.dart";
import 'package:laksadart/src/utils/unit.dart' as unit;
import 'package:laksadart/laksadart.dart';

main() async {
  var laksa = new Laksa(
      nodeUrl: 'https://dev-api.zilliqa.com', // 'https://api.zilliqa.com',
      scillaUrl: 'https://scilla-runner.zilliqa.com',
      networkID: 'DevNet');

  var acc = laksa.wallet
      .add('e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

  void autoTransaction() async {
    await acc.updateBalance();
    var nonce = acc.nonce;
    var txn = laksa.transactions.newTx({
      'toAddr': '2E3C9B415B19AE4035503A06192A0FAD76E04243',
      'amount': unit.Unit.Li(nonce + 1).qa,
      'gasPrice': unit.Unit.Li(1000).qa,
      'gasLimit': 1,
      'version':
          laksa.messenger.setTransactionVersion(1, laksa.messenger.Network_ID)
    });

    var signed = await acc.signTransaction(txn);
    print(json.encode(signed.toPayload));
    var sent = await signed.sendTransaction();
    print(sent.transaction.TranID);
    var sendTime = DateTime.now();
    var result = await sent.transaction.confirm(
        txHash: sent.transaction.TranID, maxAttempts: 33, interval: 1000);
    print(result.receipt['success']);
    if (result != null) {
      var during = DateTime.now().difference(sendTime);
      print('confirmed during:$during');
    }
  }

  void deploy() async {
    File contract = new File('../test/contracts/helloworldversion.txt');
    await contract.readAsString().then((contractString) async {
      Laksa laksa = new Laksa(
          nodeUrl:
              'https://dev-api.zilliqa.com', //'https://staging-api.aws.z7a.xyz'
          scillaUrl: 'https://scilla-runner.zilliqa.com',
          networkID: 'DevNet');
      var init = [
        {
          'vname': '_scilla_version',
          'type': 'Uint32',
          'value': '0',
        },
        {
          'value': '0x9bfec715a6bd658fcb62b0f8cc9bfa2ade71434a',
          'vname': 'owner',
          'type': 'ByStr20'
        }
      ];

      laksa.wallet.add(
          'e19d05c5452598e24caad4a0d85a49146f7be089515c905ae6a19e8a578a6930');

      var newContract = laksa.contracts
          .newContract(code: contractString, init: init, version: 0);
      newContract.setDeployPayload(
          gasLimit: 10000, gasPrice: BigInt.from(1000000000), toDS: true);
      var sent = await newContract.sendContract();
      print(sent.transaction.toPayload);
      var sendTime = DateTime.now();
      print('sent contract at:$sendTime');
      print(sent.transaction.TranID);
      var deployed = await sent.confirmTx(maxAttempts: 33, interval: 1000);
      print(deployed.ContractAddress);
      if (deployed != null) {
        var during = DateTime.now().difference(sendTime);
        print('deployed confirmed during:$during');
      }

      // test call contract

      deployed.setCallPayload(
          transition: 'setHello',
          params: [
            {'vname': "msg", 'type': "String", 'value': "Test World"}
          ],
          gasLimit: 8000,
          gasPrice: unit.Unit.Li(1000).qa,
          amount: unit.Unit.Qa(0).qa,
          toDS: true);
      var sentCall = await deployed.sendContract();
      print(sentCall.transaction.toPayload);
      var calledTime = DateTime.now();
      print('sent called time:$calledTime');
      print(sentCall.transaction.TranID);

      await sentCall.confirmTx(maxAttempts: 33, interval: 1000);
      print(sentCall.ContractAddress);
      if (sentCall != null) {
        var during2 = DateTime.now().difference(calledTime);
        print('called confirmed during:$during2');
      }
      var state = await sentCall.getState();
      print("The state of the contract is:$state");
    });
  }

  void wallet() async {
    Laksa laksa = new Laksa(
        nodeUrl:
            'https://dev-api.zilliqa.com', //'https://staging-api.aws.z7a.xyz'
        scillaUrl: 'https://scilla-runner.zilliqa.com',
        networkID: 'DevNet');
    var newAcc = laksa.wallet.create();
    await newAcc.updateBalance();
    print(newAcc.balance);
  }

  // await wallet();
  // await autoTransaction();
  await deploy();
}
