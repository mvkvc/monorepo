import { createSolanaMessage, getProvider } from "../utils/wallet";
// import { Bounty } from "../idl/bounty";
// import { SystemProgram } from "@coral-xyz/anchor";
import { PublicKey, SystemProgram } from "@solana/web3.js";
import { getBounty } from "../utils/anchor";
import { getTimePlus } from "../utils/time";

const Wallet = {
  mounted() {
    window.addEventListener("phx:signature", async (e: any) => {
      const { address, statement, nonce } = e.detail;

      try {
        const provider: any = await getProvider();
        const message = createSolanaMessage(address, statement, nonce);
        const encodedMessage = new TextEncoder().encode(
          message.prepareMessage(),
        );
        const signedMessage = await provider.signMessage(
          encodedMessage,
          "utf8",
        );

        console.log("Message", message)
        console.log("Signed message:", signedMessage);

        (this as any).pushEventTo("#wallet", "verify-signature", {
          message: JSON.stringify(message),
          signature: JSON.stringify(signedMessage.signature),
        });
      } catch (e) {
        console.error("Error signing message:", e);
      }
    });
  }
};

export default Wallet;
