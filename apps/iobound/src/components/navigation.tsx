import React from "react";
import { useEffect, useState, useContext } from "react";
import Link from "next/link";
import { NearContext } from "../context";

export const Navigation = () => {
  const { signedAccountId, wallet } = useContext(NearContext);
  const [action, setAction] = useState<(() => void) | undefined>(undefined);
  const [label, setLabel] = useState("Loading...");

  useEffect(() => {
    if (!wallet) return;

    if (signedAccountId) {
      setAction(() => wallet.signOut);
      setLabel(`Logout ${signedAccountId}`);
    } else {
      setAction(() => wallet.signIn);
      setLabel("Login");
    }
  }, [signedAccountId, wallet]);

  return (
    <nav className="navbar navbar-expand-lg flex flex-row justify-between p-4">
      <div className="flex flex-row space-x-2">
        <Link href="/" className="btn btn-primary">
          Home
        </Link>
        <Link href="/hello-near" className="btn btn-primary">
          Hello Near
        </Link>
      </div>
      <div className="navbar-nav pt-1">
        <button className="btn btn-secondary" onClick={action}>
          {" "}
          {label}{" "}
        </button>
      </div>
    </nav>
  );
};
