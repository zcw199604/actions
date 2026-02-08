const fs = require("fs");

const targetPath = "/app/danmu_api/server.js";
const oldListen = /mainServer\.listen\(\s*9321\s*,/;
const oldLog = /Server running on http:\/\/0\.0\.0\.0:9321/g;

if (!fs.existsSync(targetPath)) {
  throw new Error(`未找到目标文件: ${targetPath}`);
}

const original = fs.readFileSync(targetPath, "utf8");
if (!oldListen.test(original)) {
  throw new Error("未匹配到 mainServer.listen(9321, ...)，无法应用端口补丁");
}

let patched = original.replace(oldListen, "mainServer.listen(9000,");
patched = patched.replace(oldLog, "Server running on http://0.0.0.0:9000");

if (!patched.includes("mainServer.listen(9000,")) {
  throw new Error("端口替换失败：未找到 mainServer.listen(9000,");
}
if (patched.includes("mainServer.listen(9321,")) {
  throw new Error("端口替换失败：仍存在 mainServer.listen(9321,");
}

fs.writeFileSync(targetPath, patched, "utf8");
console.log("[danmu-api-wrapper] 已将默认端口从 9321 替换为 9000");
