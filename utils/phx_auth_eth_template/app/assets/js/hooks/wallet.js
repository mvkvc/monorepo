import {ethers} from "ethers";

const web3Provider = new ethers.providers.Web3Provider(window.ethereum)

export const Wallet = {
    mounted() {
        let signer = web3Provider.getSigner()

        window.addEventListener('load', async () => {
            console.log("load")
            web3Provider.listAccounts().then((accounts) => {
                if (accounts.length > 0) {
                    signer = web3Provider.getSigner();
                    signer.getAddress().then((address) => {
                        this.pushEvent("account-check", {connected: true, current_wallet_address: address})
                    });
                }
                else {
                    this.pushEvent("account-check", {connected: false, current_wallet_address: null})
                }
            })
        })

        window.addEventListener(`phx:has-wallet`, (e) => {
            let has_wallet = false
            if (window.ethereum) {
                has_wallet = true
            }
            console.log("has_wallet", has_wallet)
            this.pushEvent("has-wallet", {has_wallet: has_wallet})
        })

        window.addEventListener(`phx:get-current-wallet`, (e) => {
            console.log("phx:get-current-wallet")
            signer.getAddress().then((address) => {
                const message = `You are signing this message to sign in with Akashi. Nonce: ${e.detail.nonce}`
                signer.signMessage(message).then((signature) => {
                    this.pushEvent("verify-signature", {public_address: address, signature: signature})

                    return;
                })
            })
        })

        window.addEventListener(`phx:connect-wallet`, (e) => {
            console.log("phx:connect-wallet")
            web3Provider.provider.request({method: 'eth_requestAccounts'}).then((accounts) => {
              if (accounts.length > 0) {
                signer.getAddress().then((address) => {
                    this.pushEvent("wallet-connected", {public_address: address})
                });
              }
            }, (error) => console.log(error))
        })
    },
}
