import { getAllDomains, reverseLookup } from "@bonfida/spl-name-service";
import { PublicKey } from "@solana/web3.js";
import createConnection from "./utils/rpc";
// I want to save domains to a file
// import fs from "fs";

export default async function sns(address: string): Promise<string> {
  const network = process.env.RPC_NETWORK || "mainnet";
  const api_key = process.env.RPC_API_KEY || "";
  const connection = createConnection(network, api_key);
  const ownerWallet = new PublicKey(address);
  const allDomainKeys = await getAllDomains(connection, ownerWallet);
  if (!(allDomainKeys.length > 0 && allDomainKeys[0] !== undefined)) {
    throw new Error('No domain keys found');
  }
  const domain = await reverseLookup(connection, allDomainKeys[0]);
    //   const result = {
    //   keys: allDomainKeys,
    //   domain: domain,
    // }
    // fs.writeFileSync("domains.json", JSON.stringify(result, null, 2));
  if (domain.startsWith("Error")) {
    throw new Error(domain);
  }

  return domain

  // const domains = await Promise.all(
  //   allDomainKeys.map((key) => reverseLookup(connection, key)),
  // );
  // const result = {
  //   keys: allDomainKeys,
  //   domain: domain,
  //   domains: domains,
  // }
  // fs.writeFileSync("domains.json", JSON.stringify(result, null, 2));
}

