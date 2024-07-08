import fs from "fs/promises";
import { getSettingsPath } from "./config";

export type Settings = {
  URL: string;
  APIKey: string;
};

export const DEFAULT_SETTINGS: Settings = {
  URL: "https://exboost.replicantzk.com",
  APIKey: "",
};

export const saveSettings = async (settings: Settings) => {
  const settingsPath = getSettingsPath();
  await fs.writeFile(settingsPath, JSON.stringify(settings), "utf8");
};

export const loadSettings = async (
  reset: boolean = false,
): Promise<Settings> => {
  const settingsPath = getSettingsPath();

  try {
    const fileExists = await fs
      .stat(settingsPath)
      .then(() => true)
      .catch(() => false);
    if (reset || !fileExists) {
      return DEFAULT_SETTINGS;
    } else {
      const settingsData = await fs.readFile(settingsPath, "utf8");
      const persistedSettings = JSON.parse(settingsData);

      return {
        ...DEFAULT_SETTINGS,
        ...persistedSettings,
      };
    }
  } catch (err) {
    return DEFAULT_SETTINGS;
  }
};
