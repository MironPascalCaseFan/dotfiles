# Build process should look something like this:
1. Transpile all TypeScript files from ./src/ (with entry point ./src/main.ts) into JavaScript output to the ./out/js/ directory.
2. Bundle all JavaScript files in ./out/js/ into a single file, ./out/bundled.js, including resolved dependencies from npm (e.g., an HTML parser package).
3. Transpile ./out/bundled.js into ES5-compliant code and output it to ./main.js.
