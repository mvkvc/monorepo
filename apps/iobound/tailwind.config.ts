import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}"
  ],
  theme: {},
  plugins: [
    require("daisyui"),
  ],
  daisyui: {
    themes: ["dim"],
    logs: false
  }
};

export default config;
