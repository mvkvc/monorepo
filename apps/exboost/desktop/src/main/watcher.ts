import { ChildProcess, fork } from "child_process";
import path from "path";

export type WatcherEvent = "add" | "change" | "unlink";

export interface WatcherMessage {
  type: WatcherEvent;
  path: string;
}

export interface WatcherConfig {
  folderPaths: string[];
}

export const ignorePatterns = [
  "**/node_modules/**",
  "**/dist/**",
  "**/.git/**",
  "**/package-lock.json",
];

export const startWatcher = (
  watcherProcess: ChildProcess,
  config: WatcherConfig,
  handleFn: (message: WatcherMessage) => void,
): ChildProcess => {
  watcherProcess?.kill();

  const watcherPath = path.join(__dirname, "watcher.js");
  watcherProcess = fork(watcherPath);
  watcherProcess.send(config);

  watcherProcess.on("message", (message: WatcherMessage) => {
    handleFn(message);
  });

  return watcherProcess;
};
