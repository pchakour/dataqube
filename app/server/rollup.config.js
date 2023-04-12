// rollup.config.js
import typescript from '@rollup/plugin-typescript';

export default {
  input: 'build/index.js',
  output: {
    dir: 'dist',
    format: 'cjs'
  },
  plugins: [typescript()]
};