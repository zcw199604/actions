from __future__ import annotations

from pathlib import Path
import re


def main() -> None:
    path = Path("/app/src/application/main_server.py")
    text = path.read_text(encoding="utf-8")

    # Idempotent: skip if the endpoint is already present.
    if "/douyin/account/page" in text:
        return

    block = '''
        @self.server.post(
            "/douyin/account/page",
            summary=_("分页获取账号作品数据"),
            description=_(
                dedent("""
                **参数**:

                - **cookie**: 抖音 Cookie；可选参数
                - **proxy**: 代理；可选参数
                - **source**: 是否返回原始响应数据；可选参数，默认值：False
                - **sec_user_id**: 抖音账号 sec_uid；必需参数
                - **tab**: 账号页面类型；可选参数，默认值：`post`
                - **earliest**: 作品最早发布日期；可选参数
                - **latest**: 作品最晚发布日期；可选参数
                - **cursor**: 游标；可选参数
                - **count**: 单页数量；可选参数
                """)
            ),
            tags=[_("抖音")],
            response_model=DataResponse,
        )
        async def handle_account_page(
            extract: Account, token: str = Depends(token_dependency)
        ):
            # Single-page pagination: return items + next_cursor + has_more.
            #
            # Note: the existing /douyin/account handler is a batch endpoint (fetches multiple pages
            # and returns an aggregated list). This endpoint is meant for remote UIs that need
            # cursor-based paging.
            from ..interface.account import Account as DouyinAccountAPI

            api_obj = DouyinAccountAPI(
                self.parameter,
                extract.cookie,
                extract.proxy,
                extract.sec_user_id,
                extract.tab,
                extract.earliest or "",
                extract.latest or "",
                extract.pages,
                cursor=extract.cursor,
                count=extract.count,
            )
            items = await api_obj.run(single_page=True)

            # When request_data fails, items is empty and api_obj.finished stays False.
            if not items and not api_obj.finished:
                return self.failed_response(extract)

            next_cursor = int(getattr(api_obj, "cursor", extract.cursor or 0) or 0)
            has_more = not bool(getattr(api_obj, "finished", True))

            if extract.source:
                items = self.extractor.source_date_filter(
                    items,
                    api_obj.earliest,
                    api_obj.latest,
                    tiktok=False,
                )
                return self.success_response(
                    extract,
                    {"items": items, "next_cursor": next_cursor, "has_more": has_more},
                )

            name = ""
            mark = ""
            same = extract.tab in {"post"}
            if same and items:
                try:
                    _, name, mark = self.extractor.preprocessing_data(
                        items,
                        False,
                        "post",
                        "",
                        extract.sec_user_id,
                    )
                except Exception:
                    name = ""
                    mark = ""

            root, params, logger = self.record.run(self.parameter, blank=True)
            async with logger(root, console=self.console, **params) as recorder:
                extracted = await self.extractor.run(
                    items,
                    recorder,
                    type_="batch",
                    tiktok=False,
                    name=name,
                    mark=mark,
                    earliest=api_obj.earliest,
                    latest=api_obj.latest,
                    same=same,
                )

            return self.success_response(
                extract,
                {
                    "items": extracted,
                    "next_cursor": next_cursor,
                    "has_more": has_more,
                },
            )
'''

    # Insert right before the existing /douyin/mix route to keep the docs organized.
    m = re.search(r'^\s*@self\.server\.post\(\s*\n\s*"/douyin/mix"', text, flags=re.M)
    if not m:
        raise SystemExit(
            "Failed to patch /app/src/application/main_server.py: cannot find /douyin/mix route"
        )

    patched = text[: m.start()] + block.lstrip("\n") + "\n" + text[m.start() :]
    if "/douyin/account/page" not in patched:
        raise SystemExit(
            "Patch logic error: generated content does not contain /douyin/account/page"
        )

    path.write_text(patched, encoding="utf-8")


if __name__ == "__main__":
    main()

