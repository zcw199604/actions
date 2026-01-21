#!/usr/bin/env node
/**
 * 用于演示 GitHub Actions 调用的 Node.js 示例脚本。
 * 支持 --name 与 --fail 参数，用于输出与失败演示。
 */

const fs = require("node:fs");

function printUsage() {
  console.log(`用法:
  node scripts/hello.js [--name <name>] [--fail]

参数:
  --name <name>  设置输出名称（默认: world）
  --fail         强制失败（返回非 0）
  -h, --help     显示帮助
`);
}

function parseArgs(argv) {
  let name = "world";
  let fail = false;

  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === "--name") {
      const value = argv[i + 1];
      if (!value) {
        throw new Error("缺少 --name 参数值");
      }
      name = value;
      i += 1;
      continue;
    }
    if (arg === "--fail") {
      fail = true;
      continue;
    }
    if (arg === "-h" || arg === "--help") {
      printUsage();
      process.exit(0);
    }
    throw new Error(`未知参数: ${arg}`);
  }

  return { name, fail };
}

let parsed;
try {
  parsed = parseArgs(process.argv.slice(2));
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error));
  printUsage();
  process.exit(2);
}

console.log(`name=${parsed.name}`);
console.log(`fail=${parsed.fail}`);
console.log(`message=Hello, ${parsed.name}!`);

const summaryPath = process.env.GITHUB_STEP_SUMMARY;
if (summaryPath) {
  fs.appendFileSync(
    summaryPath,
    `### hello.js\n- name: \`${parsed.name}\`\n- result: ${parsed.fail ? "failed" : "success"}\n`,
    { encoding: "utf8" }
  );
}

if (parsed.fail) {
  console.error("人为触发失败（--fail）");
  process.exit(1);
}

