import { create } from "zustand";
import { subscribeWithSelector } from "zustand/middleware";
import { immer } from "zustand/middleware/immer";
import { WatcherConfig } from "../main/watcher";

type State = {
  folderPaths: string[];
};

type Actions = {
  setFolders: (folderPaths: string[]) => void;
  addFolders: (folderPaths: string[]) => void;
  deleteFolders: (folder: string[]) => void;
};

const useFilesStore = create<State & Actions>()(
  subscribeWithSelector(
    immer((set) => ({
      folderPaths: [],
      setFolders: (folderPaths: string[]) => {
        set((state) => {
          state.folderPaths = folderPaths;
        });
      },
      addFolders: (folderPaths: string[]) => {
        set((state) => {
          folderPaths.forEach((folderPath) => {
            if (state.folderPaths.findIndex((f) => f === folderPath) === -1) {
              state.folderPaths.push(folderPath);
            }
          });
        });
      },
      deleteFolders: (folderPaths: string[]) => {
        set((state) => {
          state.folderPaths = state.folderPaths.filter(
            (f) => !folderPaths.includes(f),
          );
        });
      },
    })),
  ),
);

useFilesStore.subscribe(
  (state) => [state.folderPaths],
  async ([folderPaths]) => {
    const config: WatcherConfig = {
      folderPaths,
    };
    await window.electronAPI.startWatcher(config);
  },
);

export default useFilesStore;
