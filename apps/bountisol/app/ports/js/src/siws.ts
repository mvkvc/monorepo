import { SIWS } from "@web3auth/sign-in-with-solana";
import bs58 from "bs58";

export default async function siws(message: any, signature: any): Promise<boolean> {
  const signature_data = Uint8Array.from(Buffer.from(signature));
  const header = message.header;
  const payload = message.payload;

  const signature_formatted = {
    t: "sip99",
    s: bs58.encode(signature_data)
  };

  const msg = new SIWS({ header, payload });
  const resp = await msg.verify({ payload: payload, signature: signature_formatted });

  return resp.success;
};
