import { getFilesInFolder, hashFile } from "./files";
import { Folder, File } from "./schema";

export async function getFolders(): Promise<string[]> {
  try {
    const folders = await Folder.findAll();
    return folders.map((folder) => folder.dataValues.path);
  } catch (error) {
    console.error(error);
    return [];
  }
}

export async function addFolders(folderPaths: string[]) {
  try {
    for (const folderPath of folderPaths) {
      const folder = await Folder.create({
        path: folderPath,
      });

      const filePaths = await getFilesInFolder(folderPath);
      const filePromises = filePaths.map(async (filePath) => {
        const hash = await hashFile(filePath);
        const file = {
          path: filePath,
          hash,
          folderId: folder.dataValues.id,
        };

        return file;
      });

      const files = await Promise.all(filePromises);
      await File.bulkCreate(files);
    }
  } catch (error) {
    console.error(error);
  }
}

export async function deleteFolders(folderPaths: string[]): Promise<void> {
  try {
    for (const folderPath of folderPaths) {
      const result = await Folder.destroy({
        where: {
          path: folderPath,
        },
      });
    }
  } catch (error) {
    console.error(error);
  }
}

export async function deleteAllFolders(): Promise<void> {
  try {
    const result = await Folder.destroy({
      where: {},
    });
  } catch (error) {
    console.error(error);
  }
}
