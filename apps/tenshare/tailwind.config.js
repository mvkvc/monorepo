/** @type {import('tailwindcss').Config} */

module.exports = {
  content: [
    "./tenshare/*/templates/**/*.html",
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    theme: [],
    logs: false
  },
};
