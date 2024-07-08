import { ChildProcess } from "child_process";
import path from "path";
import { app, BrowserWindow, ipcMain } from "electron";
import { getQueuePersistPath } from "./main/config";
import {
  getFolders,
  addFolders,
  deleteFolders,
  deleteAllFolders,
} from "./main/db";
import { selectFolders } from "./main/files";
import { logger } from "./main/logger";
import { startQueue } from "./main/queue";
import { umzug } from "./main/schema";
import { Settings, loadSettings, saveSettings } from "./main/settings";
import { WatcherConfig, startWatcher } from "./main/watcher";

let mainWindow: BrowserWindow;
let watcherProcess: ChildProcess | null = null;
let queueProcess: ChildProcess | null = null;
let settings: Settings | null = null;

// Handle creating/removing shortcuts on Windows when installing/uninstalling.
if (require("electron-squirrel-startup")) {
  app.quit();
}

const createWindow = () => {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, "preload.js"),
    },
  });

  // and load the index.html of the app.
  if (MAIN_WINDOW_VITE_DEV_SERVER_URL) {
    mainWindow.loadURL(MAIN_WINDOW_VITE_DEV_SERVER_URL);
  } else {
    mainWindow.loadFile(
      path.join(__dirname, `../renderer/${MAIN_WINDOW_VITE_NAME}/index.html`),
    );
  }
  // Open the DevTools.
  mainWindow.webContents.openDevTools();
};

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
// app.on("ready", createWindow);
app.on("ready", async () => {
  settings = await loadSettings();
  logger.info("Desktop started", settings);

  ipcMain.handle("getSettings", (_event) => settings);
  ipcMain.handle("setSettings", (_event, newSettings) => {
    settings = newSettings;
  });
  ipcMain.handle("selectFolders", selectFolders);
  ipcMain.handle("getFolders", getFolders);
  ipcMain.handle("addFolders", (_event, folderPaths) =>
    addFolders(folderPaths),
  );
  ipcMain.handle("deleteFolders", (_event, folderPaths) =>
    deleteFolders(folderPaths),
  );
  ipcMain.handle("deleteAllFolders", deleteAllFolders);
  ipcMain.handle("startQueue", (_event) => {
    const config = { queueFilePath: getQueuePersistPath() };
    queueProcess = startQueue(queueProcess, config);
  });

  ipcMain.handle("startWatcher", (_event, config: WatcherConfig) => {
    watcherProcess = startWatcher(watcherProcess, config, (message) => {
      queueProcess?.send({ action: "push", data: message });
    });
  });

  await umzug.up();

  createWindow();
});

// Quit when all windows are closed, except on macOS. There, it's common
// for applications and their menu bar to stay active until the user quits
// explicitly with Cmd + Q.
app.on("window-all-closed", () => {
  saveSettings(settings);

  watcherProcess?.kill();
  queueProcess?.kill();

  if (settings) {
    saveSettings(settings);
  }

  if (process.platform !== "darwin") {
    app.quit();
  }
});

app.on("activate", () => {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});

// In this file you can include the rest of your queueProcess: ChildProcess, config: QueueConfig, handleFn?: (data: any) => voidt them in separate files and import them here.
