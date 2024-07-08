import * as chokidar from "chokidar";
import { logger } from "../main/logger";
import { WatcherEvent, WatcherConfig, ignorePatterns } from "../main/watcher";

let watcher: chokidar.FSWatcher;

const sendMessage = (type: WatcherEvent, path: string) => {
  process.send?.({ type, path });
};

process.on("message", (config: WatcherConfig) => {
  watcher?.close();

  logger.info("Watcher started", config);

  watcher = chokidar.watch(config.folderPaths, {
    ignored: (ignore) =>
      ignorePatterns.some((pattern) => ignore.includes(pattern)),
    persistent: true,
    ignoreInitial: false,
  });

  watcher
    .on("add", (path) => sendMessage("add", path))
    .on("change", (path) => sendMessage("change", path))
    .on("unlink", (path) => sendMessage("unlink", path));
});

process.on("disconnect", () => {
  watcher?.close();
});
