#!/usr/bin/env bash
# gates/no-new-deps.sh — code in src/ may only import Node built-ins, relative files,
# and packages listed under "dependencies" in package.json. Something that merely happens to be
# in node_modules (installed by a dev tool) does not count: it would break on a clean install.
exec node --input-type=module <<'JS'
import { readFileSync, readdirSync } from "node:fs";
import { builtinModules } from "node:module";
import { join } from "node:path";
const deps = new Set(Object.keys(JSON.parse(readFileSync("package.json", "utf8")).dependencies ?? {}));
const builtins = new Set(builtinModules);
const files = (dir) => readdirSync(dir, { withFileTypes: true }).flatMap((e) =>
  e.isDirectory() ? files(join(dir, e.name)) : /\.(m|c)?[jt]sx?$/.test(e.name) ? [join(dir, e.name)] : []);
const found = [];
for (const file of files("src")) {
  const text = readFileSync(file, "utf8");
  for (const m of text.matchAll(/(?:from|import|require)\s*\(?\s*["']([^"']+)["']/g)) {
    const spec = m[1];
    if (spec.startsWith(".") || spec.startsWith("/") || spec.startsWith("node:")) continue;
    const pkg = spec.startsWith("@") ? spec.split("/").slice(0, 2).join("/") : spec.split("/")[0];
    if (!builtins.has(pkg) && !deps.has(pkg)) found.push(`${file}: imports "${pkg}", which is not a dependency in package.json`);
  }
}
if (found.length) {
  console.log(found.join("\n"));
  console.log("Adding a dependency is a human decision: open an issue for it instead.");
  process.exit(1);
}
console.log("No new dependencies.");
JS
