// See the Electron documentation for details on how to use preload scripts:
// https://www.electronjs.org/docs/latest/tutorial/process-model#preload-scripts

import { contextBridge, ipcRenderer } from "electron";
import { Settings } from "./main/settings";
import { WatcherConfig } from "./main/watcher";

contextBridge.exposeInMainWorld("electronAPI", {
  selectFolders: () => ipcRenderer.invoke("selectFolders"),
  getFolders: () => ipcRenderer.invoke("getFolders"),
  addFolders: (folderPaths: string[]) =>
    ipcRenderer.invoke("addFolders", folderPaths),
  deleteFolders: (folderPaths: string[]) =>
    ipcRenderer.invoke("deleteFolders", folderPaths),
  deleteAllFolders: () => ipcRenderer.invoke("deleteAllFolders"),
  getSettings: () => ipcRenderer.invoke("getSettings"),
  setSettings: (settings: Settings) =>
    ipcRenderer.invoke("setSettings", settings),
  startWatcher(config: WatcherConfig) {
    ipcRenderer.invoke("startWatcher", config);
  },
  startQueue: () => ipcRenderer.invoke("startQueue"),
});
