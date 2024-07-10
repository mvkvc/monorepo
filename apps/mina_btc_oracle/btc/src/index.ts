// https://learnmeabitcoin.com/technical/transaction-data
// https://mempool.space/tx/148f45f26744058ca66bb9a30db671e7c54723eb259be3d76ec7f1c6c91a20f0
// https://www.blockchain.com/explorer/transactions/btc/148f45f26744058ca66bb9a30db671e7c54723eb259be3d76ec7f1c6c91a20f0

import { Struct, Bytes } from "o1js";

export class Bytes1 extends Bytes(1) {}
export class Bytes4 extends Bytes(4) {}
export class Bytes32 extends Bytes(32) {}

const txHex = "020000000001017ba6783fb83a9c181502b87ee75665b57636da08e3b77d8ea858bb0120dbefcd2c000000000000000001c8e602000000000016001401a7786479958549328517a9b228dc3f18e1234f024730440220369c70c720e4ddec27d21de32ca0f8681a10eb83bccd4bf51a5e9fd96d49e603022019846270739d65493175297e2cf94ea196a052cf9041f50787ebba6c7d903f4b01210201f2cc93ee5af55764c8fc4697aaf95a39ab1270b49a7db764460aed372c6d3d00000000"

const version = "02000000"; // Reverse
const inputCount = "00";
const txID = "01a6783fb83a9c181502b87ee75665b57636da08e3b77d8ea858bb0120dbefcd2c";
const vOut = "000000000000000001";
const scriptSigSize = "c8";
const scriptSig = "e602000000000016001401a7786479958549328517a9b228dc3f18e1234f024730440220369c70c720e4ddec27d21de32ca0f8681a10eb83bccd4bf51a5e9fd96d49e603022019846270739d65493175297e2cf94ea196a052cf9041f50787ebba6c7d903f4b01210201";
const sequence = "f2cc93ee";
const outputCount = "5a";
const outputValue = "f55764c8fc4697aa";
const scriptPubKeySize = "f9";
const scriptPubKey = "5a39ab1270b49a7db764460aed372c6d3d";
const lockTime = "00000000";

export class Transaction extends Struct({
    version: Bytes4.provable,
    inputCount: Bytes1.provable,
    varIn: Bytes1.provable,
    txId: Bytes32.provable
}) {}

const result = version + inputCount + varIn + txID + vOut + scriptSigSize + scriptSig + sequence + outputCount + outputValue + scriptPubKeySize + scriptPubKey + lockTime;

if (result === txHex) {
	console.log("EQUALS")
}

// 47304402200aa5891780e216bf1941b502de29890834a2584eb576657e340d1fa95f2c0268022010712e05b30bfa9a9aaa146927fce1819f2ec6d118d25946256770541a8117b6012103d2305c392cbd5ac36b54d3f23f7305ee024e25000f5277a8c065e12df5035926

// 6a == 106
// 212