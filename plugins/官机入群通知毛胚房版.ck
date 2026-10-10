[事件]group_request
id=@%event%#data#member_openid
reid=@%event%#data#join_request_id
bt = {
  "rows": [
    {
      "buttons": [
        {
          "id": id,
          "render_data": {
            "label": "同意进群",
            "style": 1
          },
          "action": {
            "type": 1,
            "data": f"同意进群_{reid}",
            "permission": {
              "type": 2,
            },
            "reply": True,
            "enter": True,
            "modal": {
              "content": "确认同意入群?",
              "confirm_text": "✔️确认",
              "cancel_text": "❌取消"
            },
          }
        }
      ]
    }
  ]
}
$发送 ±md±检测到入群申请±kd %bt%±$

同意进群_(.*)
user_id = @%event%#data#data#resolved#button_id
re_id = %括号1%
res = await approve_join_request(bot.bot_id,%群号%,user_id,re_id)