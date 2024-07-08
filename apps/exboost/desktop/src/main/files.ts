import crypto from "crypto";
import fs from "fs";
import { dialog } from "electron";

export async function selectFolders() {
  const { canceled, filePaths } = await dialog.showOpenDialog({
    properties: [
      "openDirectory",
      // "multiSelections" // Not working on Linux for some reason
    ],
  });
  if (!canceled) {
    return filePaths;
  }
}

export async function getFilesInFolder(
  folderPath: string,
  ignorePatterns: string[] = [],
): Promise<string[]> {
  const files = await fs.promises.readdir(folderPath, {
    recursive: true,
    withFileTypes: true,
  });

  return files
    .filter((file) => !file.isDirectory())
    .map((file) => file.parentPath + "/" + file.name)
    .filter((fileName) => {
      return !ignorePatterns.some((pattern) => fileName.includes(pattern));
    });
}

export async function hashFile(path: string): Promise<string> {
  const hash = crypto.createHash("sha256");
  const data = await fs.promises.readFile(path);
  hash.update(data);
  return hash.digest("hex");
}
