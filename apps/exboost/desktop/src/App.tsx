import React from "react";
import { useEffect } from "react";
import { createBrowserRouter, RouterProvider } from "react-router-dom";
import Root from "./routes/Root";
import Error from "./routes/Error";
import Sources from "./routes/Sources";
import Settings from "./routes/Settings";
import useFilesStore from "./stores/files";
import useSettingsStore from "./stores/settings";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Root />,
    errorElement: <Error />,
    children: [
      {
        path: "/",
        element: <Sources />,
      },
      {
        path: "/settings",
        element: <Settings />,
      },
    ],
  },
]);

export default function App() {
  const setFolders = useFilesStore((state) => state.setFolders);
  const setSettings = useSettingsStore((state) => state.setSettings);

  const handleInit = async () => {
    const settings = await window.electronAPI.getSettings();
    setSettings(settings);

    await window.electronAPI.startQueue();

    const storedFolderPaths = await window.electronAPI.getFolders();
    if (storedFolderPaths.length >= 0) {
      setFolders(storedFolderPaths);
    }
    await window.electronAPI.startWatcher({ folderPaths: storedFolderPaths });
  };

  useEffect(() => {
    handleInit();
  }, []);

  return <RouterProvider router={router} />;
}
