[事件]group_request
logger.info(event)
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
              "content": "确认授权机器人获取你的真实QQ号?",
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

获取禁言
res = await get_restrict_chat_setting(bot.bot_id,%群号%)
$发送 %res%$

解除禁言
res = await get_restrict_chat_setting(bot.bot_id,%群号%)
id = @%res%#members#0#member_openid
await unmute_group_member_v2(bot.bot_id,%群号%,%id%)

获取入群
res = await get_join_request_list(bot.bot_id,%群号%,limit=5)
$发送 %res%$

测试日志
bot_list = $BOT$
bot1 = @%bot_list%#0#type
bot2 = @%bot_list%#1#type
bot1_u = @%bot_list%#0#bot
如果 bot1 == "OneBot V11" and bot != bot1_u
bot = @%bot_list%#0#bot
$发送 群 907202438 7788$

测试直播(.*)
logger.debug(f"收到消息 %括号1%")

测试排序
data = $转json 测试.txt$
data1 = [{"user": {"name": "Tom", "age": 30}},{"user": {"name": "Jerry", "age": 25}}]
data_res = $排序 %data% 降序 None None \n {index}. 【{key}】 : {value}$
$发送 %data_res%$
data_res = $排序 %data% 升序 3 None \n {index}. 【{key}】 : {value}$
$发送 %data_res%$
data_res = $排序 %data1% 升序 None user.age \n {index}. 【{user.name}】 : {user.age}$
$发送 %data_res%$

测试时间
res = $发送 %时间%Y-%m-%d %H:%M:%S%$
logger.debug(res)

测试群
res = $群信息 %群号%$
$发送 %res%$

测试视频
res = $发送 ±vid https://fastcdn.mihoyo.com/content-v2/kl/165734/84e18bd58dd26666dc0156b96347ba7b_9090349905002196837.mp4±$
logger.debug(res)

测试主动
$发送 群 44F1A33CF8767783AEAE690763E6F10D 主动消息$

测试QQ
$发送 %QQ%$

测试渲染
res = $html index.html$
$发送 ±img %res%±$

[内部]用户QQ
返回 %QQ%

/测试(.*)
res = $AI %括号1%$
logger.debug(res)