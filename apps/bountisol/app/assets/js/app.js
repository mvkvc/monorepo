// @ts-nocheck

// import "./user_socket.js"
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

import LiveReact, { initLiveReact } from "phoenix_live_react";
import WalletAdapter from "./components/WalletAdapter";

import TrackClientCursor from "./hooks/cursor";
import Wallet from "./hooks/wallet";
import Deploy from "./hooks/deploy";
// import Pay from "./hooks/pay";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

window.Components = {
  WalletAdapter,
};

let Hooks = { LiveReact };
Hooks.TrackClientCursor = TrackClientCursor;
Hooks.Wallet = Wallet;
Hooks.Deploy = Deploy;
// Hooks.Pay = Pay;

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
});

document.addEventListener("DOMContentLoaded", (e) => {
  initLiveReact();
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
