import { app } from "./output.js";

export function init(ctx, payload) {
  ctx.importCSS("output.css");

  const app_lb = app.mount(ctx.root);
}
