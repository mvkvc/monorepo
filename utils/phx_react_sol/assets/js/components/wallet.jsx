import React, { useMemo, useEffect, useState } from "react";
import { WalletAdapterNetwork } from "@solana/wallet-adapter-base";
import {
  WalletModalProvider,
  WalletDisconnectButton,
  WalletMultiButton,
} from "@solana/wallet-adapter-react-ui";
import {
  ConnectionProvider,
  WalletProvider,
  // useConnection,
  useWallet,
} from "@solana/wallet-adapter-react";
import { WalletConnectWalletAdapter } from "@solana/wallet-adapter-walletconnect";
import { SolflareWalletAdapter } from "@solana/wallet-adapter-solflare";
import { clusterApiUrl } from "@solana/web3.js";

const Counter = ({ handleEvent }) => {
  const [count, setCount] = useState(0);

  useEffect(() => {
    if (handleEvent) {
      handleEvent("increment", (event) => {
        if (event.amount) {
          console.log("increment", event.amount);
          setCount((prevCount) => prevCount + event.amount);
        }
      });
      handleEvent("reset", () => {
        console.log("reset");
        setCount(0);
      });
    }}, [handleEvent]);

  return (
    <div className="flex flex-row items-center">
      <p>Counter: {count}</p>
    </div>
  );
};

const WalletEventTracker = ({ pushEventTo }) => {
  const { publicKey } = useWallet();
  const [hasConnected, setHasConnected] = useState(false)

  useEffect(() => {
    if (publicKey) {
      setHasConnected(true);
        console.log("connected");
        pushEventTo("#wallet", "connected");
    } else {
      if (hasConnected) {
        console.log("disconnected");
        pushEventTo("#wallet", "disconnected");
        setHasConnected(false);
      }
  }}, [publicKey]);

  return null;
}

const SolanaWalletConnector = ({ network_type, pushEventTo, handleEvent }) => {
  const network =
    network_type === "main"
      ? WalletAdapterNetwork.Mainnet
      : WalletAdapterNetwork.Devnet;
  const endpoint = useMemo(() => clusterApiUrl(network), [network]);
  const wallets = useMemo(() => [
    new WalletConnectWalletAdapter(),
    new SolflareWalletAdapter()
  ], [network]);

  return (
    <ConnectionProvider endpoint={endpoint}>
      <WalletProvider wallets={wallets} autoConnect>
        <WalletModalProvider>
          <div className="flex space-x-4">
            <Counter handleEvent={handleEvent} />
            <WalletEventTracker pushEventTo={pushEventTo} />
            <WalletMultiButton />
            <WalletDisconnectButton />
          </div>
        </WalletModalProvider>
      </WalletProvider>
    </ConnectionProvider>
  );
};

export default SolanaWalletConnector;
