import { Program, Provider } from "@coral-xyz/anchor";
import { Connection, PublicKey } from "@solana/web3.js";
// import { Bounty } from "../../../../programs/target/types/bounty";
import { IDL } from "../idl/bounty";
import { getConnection, getProvider } from "./wallet";

// export function getProgramID() {
//   // console.log("process.env.PROGRAM_ID", process.env.PROGRAM_ID);
//   return new PublicKey(process.env.PROGRAM_ID?.toString() ?? new PublicKey("HF6z2ujyhfeBxDV3KQr8T8mCGo8ATzSK16Hf7swvX49v");
// }

export async function getBounty() {
  return new Program(IDL, new PublicKey("HF6z2ujyhfeBxDV3KQr8T8mCGo8ATzSK16Hf7swvX49v"), await getProvider());
}

// "name": "create",
// "accounts": [
//   {
//     "name": "bounty",
//     "isMut": true,
//     "isSigner": false
//   },
//   {
//     "name": "payer",
//     "isMut": true,
//     "isSigner": true
//   },
//   {
//     "name": "systemProgram",
//     "isMut": false,
//     "isSigner": false
//   }
// ],
// "args": [
//   {
//     "name": "deadlineWork",
//     "type": "u64"
//   },
//   {
//     "name": "deadlineDispute",
//     "type": "u64"
//   },
//   {
//     "name": "admin",
//     "type": "publicKey"
//   }
// ]
// },
