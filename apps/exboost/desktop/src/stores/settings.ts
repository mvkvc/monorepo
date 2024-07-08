import { create } from "zustand";
import { subscribeWithSelector } from "zustand/middleware";
import { immer } from "zustand/middleware/immer";
import { Settings, DEFAULT_SETTINGS } from "../main/settings";

type State = Settings;

type Actions = {
  getSettings: () => Settings;
  setSettings: (settings: Partial<Settings>) => void;
};

const useSettingsStore = create<State & Actions>()(
  subscribeWithSelector(
    immer((set, get) => ({
      ...DEFAULT_SETTINGS,
      getSettings: () => get(),
      setSettings: (settings: Partial<Settings>) => {
        set((state) => {
          Object.assign(state, settings);
        });
      },
    })),
  ),
);

useSettingsStore.subscribe(
  (state) => [state.URL, state.APIKey],
  async ([URL, APIKey]) => {
    const settings = {
      URL,
      APIKey,
    };
    await window.electronAPI.setSettings(settings);
  },
);

export default useSettingsStore;
