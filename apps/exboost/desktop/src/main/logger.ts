import path from "path";
// import { app } from "electron";
import { createLogger, format, transports } from "winston";
import { getConfigPath } from "./config";

// const nodeEnv = app.isPackaged ? "prod" : "dev";

export const logger = createLogger({
  // level: nodeEnv === "prod" ? "error" : "debug",
  level: "info",
  format: format.combine(
    format.timestamp({
      format: "YYYY-MM-DD HH:mm:ss",
    }),
    format.errors({ stack: true }),
    format.splat(),
    format.json(),
  ),
  transports: [
    new transports.File({
      filename: path.join(getConfigPath(), "desktop.log"),
    }),
  ],
});
