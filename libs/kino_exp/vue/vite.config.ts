import { fileURLToPath, URL } from 'node:url'
import { resolve } from 'path'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  build: {
    outDir: '../lib/assets',
    lib: {
      // Could also be a dictionary or array of multiple entry points
      entry: resolve(__dirname, 'src/output.ts'),
      name: 'KinoExperiment',
      // fileName: 'output.js'
    },
    rollupOptions: {
      // input: {
      //     index: "./src/main.ts"
      // },
      // external: ['vue'],
      output: {
        // Provide global variables to use in the UMD build
        // for externalized deps
        globals: {
          vue: 'Vue'
        },
        format: 'iife', // or 'umd' depending on your needs
        entryFileNames: '[name].js', // this will create one JS file only
        chunkFileNames: '[name].js' // this will merge all chunks into a single JS file
      },
    }
  }
})

