[内部]图文卡片[title desc jump_url pic_url ref_msg_id=None]
data = event.get("data", {}) if isinstance(event.get("data"), dict) else {}
msg_id = data.get("id") or event.get("message_id") or ""
group_openid = data.get("group_openid") or event.get("group_id")
user_openid = (
    data.get("author", {}).get("user_openid")
    or event.get("user_id")
    or data.get("user_openid")
)
if group_openid:
    path = f"/v2/groups/{group_openid}/messages"
elif user_openid:
    path = f"/v2/users/{user_openid}/messages"
else:
    返回 {"error": "无法从 event 中识别到有效的 group_openid 或 user_openid"}
payload = {
        "msg_type": 8,
        "msg_id": msg_id,
        "msg_seq": 1,
        "card": {
            "type": "tuwen",
            "content": {
                "title": title,
                "description": desc,
                "url": jump_url,
                "pic_url": pic_url
            }
        }
}
如果 ref_msg_id is True
ref_msg_id = msg_id
如果尾
if ref_msg_id:
    payload["message_reference"] = {
    "message_id": ref_msg_id
}
if hasattr(bot, "send_http_post"):
    返回 await bot.send_http_post(path, payload)
else:
    from api.qq_official_group import _http_post
    返回 await _http_post(bot.bot_id, path, payload)