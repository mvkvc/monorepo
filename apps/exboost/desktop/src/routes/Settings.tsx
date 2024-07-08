import React from "react";
import { useState } from "react";
import useSettingsStore from "../stores/settings";
import { DEFAULT_SETTINGS, Settings as TSettings } from "../main/settings";

export default function Settings() {
  const getSettings = useSettingsStore((state) => state.getSettings);
  const setSettings = useSettingsStore((state) => state.setSettings);

  const [formData, setFormData] = useState(getSettings());
  const [savedSettings, setSavedSettings] = useState(getSettings());
  const [unsavedChanges, setUnsavedChanges] = useState(false);

  const settingsChanged = (oldSettings: TSettings, newSettings: TSettings) => {
    return !Object.entries(newSettings).every(
      ([key, value]) => oldSettings[key as keyof TSettings] === value,
    );
  };

  const handleReset = async (event: React.MouseEvent<HTMLButtonElement>) => {
    event.preventDefault();

    await window.electronAPI.setSettings(DEFAULT_SETTINGS);

    const updatedSettings = {
      ...savedSettings,
      ...DEFAULT_SETTINGS,
    };

    setSettings(updatedSettings);
    setFormData(updatedSettings);
    setUnsavedChanges(false);
  };

  const handleSubmit = (event: React.MouseEvent<HTMLButtonElement>) => {
    event.preventDefault();

    setSettings({ ...formData });
    setSavedSettings({ ...formData });
    setUnsavedChanges(false);
  };

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = event.target;
    const newFormData = { ...formData, [name]: value };

    setFormData(newFormData);
    setUnsavedChanges(settingsChanged(savedSettings, newFormData));
  };

  return (
    <>
      <div className="flex flex-col space-y-4 align-middle">
        <h1>Settings</h1>
        <div className="flex flex-row space-x-2 items-center">
          <button onClick={handleSubmit} className="btn">
            Save
          </button>
          <button onClick={handleReset} className="btn">
            Reset
          </button>
          {unsavedChanges && (
            <p className="text-sm align-middle">You have unsaved changes.</p>
          )}
        </div>
        <form className="form-control w-full max-w-lg">
          <div className="flex items-center mb-4">
            <label className="label flex-none w-1/4" htmlFor="URL">
              <span>URL server</span>
            </label>
            <input
              type="text"
              id="URL"
              name="URL"
              value={formData.URL}
              onChange={handleChange}
              className="input input-bordered"
            />
          </div>
          <div className="flex items-center mb-4">
            <label className="label flex-none w-1/4" htmlFor="APIKey">
              <span>API Key</span>
            </label>
            <input
              type="password"
              id="APIKey"
              name="APIKey"
              value={formData.APIKey}
              onChange={handleChange}
              className="input input-bordered"
            />
          </div>
        </form>
      </div>
    </>
  );
}
