import React from "react";
import useFilesStore from "../stores/files";

export default function Sources() {
  const folderPaths = useFilesStore((state) => state.folderPaths);
  const setFolders = useFilesStore((state) => state.setFolders);
  const addFolders = useFilesStore((state) => state.addFolders);
  const deleteFolders = useFilesStore((state) => state.deleteFolders);

  const handleSelectFolders = async () => {
    const folderPaths = await window.electronAPI.selectFolders();
    if (folderPaths && folderPaths.length >= 0) {
      addFolders(folderPaths);
      await window.electronAPI.addFolders(folderPaths);
    }
  };

  const handleDeleteFolders = async (folders: string[]) => {
    deleteFolders(folders);
    await window.electronAPI.deleteFolders(folders);
  };

  const handleDeleteAllFolders = async () => {
    setFolders([]);
    await window.electronAPI.deleteAllFolders();
  };

  return (
    <>
      <div className="flex flex-col space-y-4">
        <h1>Sources</h1>
        <div className="flex flex-row space-x-4">
          <button className="btn" onClick={handleSelectFolders}>
            Add Folder
          </button>
          <button className="btn" onClick={handleDeleteAllFolders}>
            Delete All Folders
          </button>
        </div>
        {folderPaths.map((folderPath) => (
          <div key={folderPath} className="flex flex-row space-x-4">
            <p>{folderPath}</p>
            <button onClick={() => handleDeleteFolders([folderPath])}>
              Remove
            </button>
          </div>
        ))}
      </div>
    </>
  );
}
