import fsSync from "fs";
import os from "os";
import path from "path";

export const getConfigPath = () => {
  const homeDir = os.homedir();
  const configPath = path.join(homeDir, ".config", "exboost");
  try {
    // Using sync version as this is a param to sync functions
    fsSync.mkdirSync(configPath, { recursive: true });
  } catch (err) {
    if (err.code !== "EEXIST") {
      throw err;
    }
  }

  return configPath;
};

export const getDBPath = () => {
  const configDir = getConfigPath();
  return path.join(configDir, "exboost.db");
};

export const getQueuePersistPath = () => {
  const configDir = getConfigPath();
  return path.join(configDir, "queue.json");
};

export const getSettingsPath = () => {
  const configDir = getConfigPath();
  return path.join(configDir, "settings.json");
};
