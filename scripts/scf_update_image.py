#!/usr/bin/env python3
"""将腾讯云 SCF 镜像函数（$LATEST）切换到指定镜像 digest。

SCF 在部署时会把镜像 tag 解析为 digest 并固定下来，仅向仓库推送新的 :latest
不会让函数使用新镜像，必须调用 UpdateFunctionCode 重新部署。

为避免覆盖函数已有的镜像配置（ImagePort / Command / Args / RegistryId 等），
脚本先通过 GetFunction 读取当前 ImageConfig，仅替换 ImageUri 后回写。
"""

from __future__ import annotations

import argparse
import os
import sys
import time

from tencentcloud.common import credential
from tencentcloud.common.common_client import CommonClient

SCF_API_VERSION = "2018-04-16"


def split_image_uri(uri: str) -> tuple[str, str]:
    """拆分为 (domain 之后的 repo:tag, digest)。"""
    ref, _, digest = uri.partition("@")
    _, _, repo_tag = ref.partition("/")
    return repo_tag, digest


def get_function(client: CommonClient, name: str, namespace: str) -> dict:
    return client.call_json(
        "GetFunction", {"FunctionName": name, "Namespace": namespace}
    )["Response"]


def wait_active(client: CommonClient, name: str, namespace: str, timeout: int) -> dict:
    deadline = time.monotonic() + timeout
    while True:
        fn = get_function(client, name, namespace)
        status = fn.get("Status", "")
        print(f"function status: {status}")
        if status == "Active":
            return fn
        if "Failed" in status:
            raise SystemExit(f"函数更新失败: {status} {fn.get('StatusDesc', '')}")
        if time.monotonic() > deadline:
            raise SystemExit(f"等待函数就绪超时（{timeout}s），当前状态: {status}")
        time.sleep(5)


def export_result(result: str, previous_digest: str) -> None:
    """写入 GITHUB_ENV，供后续“写入执行摘要”步骤展示。"""
    env_path = os.getenv("GITHUB_ENV")
    if env_path:
        with open(env_path, "a", encoding="utf-8") as handle:
            handle.write(f"SCF_DEPLOY_RESULT={result}\n")
            handle.write(f"SCF_PREVIOUS_DIGEST={previous_digest or 'unknown'}\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="更新 SCF 镜像函数到指定 digest")
    parser.add_argument("--region", required=True)
    parser.add_argument("--function", required=True)
    parser.add_argument("--namespace", default="default")
    parser.add_argument("--image", required=True, help="目标镜像，例如 ccr.ccs.tencentyun.com/ns/repo:latest")
    parser.add_argument("--digest", required=True, help="目标镜像 digest，例如 sha256:...")
    parser.add_argument("--timeout", type=int, default=600)
    parser.add_argument("--force", action="store_true", help="digest 相同也重新部署")
    args = parser.parse_args()

    secret_id = os.environ.get("TENCENTCLOUD_SECRET_ID", "")
    secret_key = os.environ.get("TENCENTCLOUD_SECRET_KEY", "")
    if not secret_id or not secret_key:
        print("缺少 TENCENTCLOUD_SECRET_ID / TENCENTCLOUD_SECRET_KEY", file=sys.stderr)
        return 1

    client = CommonClient(
        "scf", SCF_API_VERSION, credential.Credential(secret_id, secret_key), args.region
    )

    fn = wait_active(client, args.function, args.namespace, args.timeout)
    image_config = fn.get("ImageConfig") or {}
    current_uri = image_config.get("ImageUri", "")
    if not current_uri:
        print(f"函数 {args.function} 不是镜像部署函数（ImageConfig 为空）", file=sys.stderr)
        return 1

    current_repo, current_digest = split_image_uri(current_uri)
    target_repo, _ = split_image_uri(args.image)
    print(f"current ImageUri: {current_uri}")
    print(f"target digest: {args.digest}")

    # 防止把 digest 写进一个不相干的仓库（函数可能用 VPC 域名，因此只比较域名之后的部分）。
    if current_repo != target_repo:
        print(
            f"函数镜像仓库 {current_repo} 与同步目标 {target_repo} 不一致，拒绝更新",
            file=sys.stderr,
        )
        return 1

    if current_digest == args.digest and not args.force:
        print("函数已在使用目标 digest，跳过更新")
        export_result("skipped", current_digest)
        return 0

    new_uri = f"{current_uri.partition('@')[0]}@{args.digest}"
    new_config = {k: v for k, v in image_config.items() if v is not None and v != ""}
    new_config["ImageUri"] = new_uri
    print(f"new ImageUri: {new_uri}")

    client.call_json(
        "UpdateFunctionCode",
        {
            "FunctionName": args.function,
            "Namespace": args.namespace,
            "Code": {"ImageConfig": new_config},
        },
    )

    fn = wait_active(client, args.function, args.namespace, args.timeout)
    deployed_uri = (fn.get("ImageConfig") or {}).get("ImageUri", "")
    if split_image_uri(deployed_uri)[1] != args.digest:
        print(f"更新后 ImageUri 未指向目标 digest: {deployed_uri}", file=sys.stderr)
        return 1

    print("函数镜像已更新")
    export_result("updated", current_digest)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
