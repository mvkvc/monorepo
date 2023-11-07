import { createContext } from 'react';
import { Wallet } from './wallets/near';

export interface NearContextType {
  wallet: Wallet | undefined;
  signedAccountId: string;
}

export const NearContext = createContext<NearContextType>({
  wallet: undefined,
  signedAccountId: ''
});
