import { useEffect, useState, FC } from "react";
import { useWallet } from "@solana/wallet-adapter-react";

const WalletEffectHandler: FC<any> = ({ pushEventTo }) => {
  const { wallet, publicKey, connected, disconnecting } = useWallet();

  useEffect(() => {
    if (publicKey && pushEventTo) {
      pushEventTo("#wallet-adapter", "effect_public_key", {
        public_key: publicKey.toString(),
      });
    }
  }, [publicKey, pushEventTo]);

  useEffect(() => {
    if (connected && wallet && pushEventTo) {
      const wallet_name = wallet.adapter.name.toLowerCase();
      sessionStorage.setItem("_wallet_name", wallet_name);
      pushEventTo("#wallet-adapter", "effect_connected", {
        wallet: wallet_name,
      });
    }

    if (disconnecting && pushEventTo) {
      pushEventTo("#wallet-adapter", "effect_disconnecting", {});
    }
  }, [wallet, connected, disconnecting, pushEventTo]);

  return null;
};

export default WalletEffectHandler;
