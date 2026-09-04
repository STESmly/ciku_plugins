[内部]登录按钮[uid]
bt = {
  "rows": [
    {
      "buttons": [
        {
          "id": %uid%,
          "render_data": {
            "label": "登录验证",
            "visited_label": "已验证",
            "style": 1
          },
          "action": {
            "type": 1,
            "data": "登录验证",
            "permission": {
              "type": 0,
              "specify_user_ids":[%uid%]
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
$发送 ±md±请点击登录验证按钮，确认授权你的真实QQ号±kd %bt%±$
$写文件 官机绑定/用户/%uid% %群号%$

登录
a = event
如果 event.get("event_type",None) != None
$调用 登录按钮 #%QQ%$


[\s\S]*请点击登录验证[\s\S]*
a=event
如果 event.get("event_type",None) == None
b=@%a%#raw#elements#0#inlineKeyboardElement#rows#0#buttons#0#specifyTinyids#0
c=@%a%#raw#elements#0#inlineKeyboardElement#rows#0#buttons#0#id
d=@%a%#raw#elements#0#inlineKeyboardElement#rows#0#buttons#0#label
如果 %d%=="登录验证"
info = await get_group_member_info(bot.bot_id,%群号%,%b%,True)
group = $读文件 官机绑定/用户/%c% None$
$写文件 官机绑定/%group%/%c%.json %info%$

登录验证
a=event
如果 event.get("event_type",None) != None
user_id = @%a%#data#group_member_openid
b=$读文件 官机绑定/%群号%/%user_id%.json 暂未绑定$
$发送 绑定成功$

[内部]排队列表
kb = {
  "rows": [
    {
      "buttons": [
        {
          "id": "btn_1786524414926",
          "render_data": {
            "label": "排队",
            "visited_label": "已排",
            "style": 1
          },
          "action": {
            "type": 1,
            "data": "排队",
            "permission": {
              "type": 2
            }
          }
        }
      ]
    }
  ]
}
list = $读文件 排队.json []$
num = len(list)
n =0
msg = "#排队表\n"
循环 n < num
kd = $直发按钮 删除 删除%n%$
msg += f"{n+1}. 平台:{list[n]['prot']}\n![text #32px #32px]({list[n]['url']}) {list[n]['name']}  {kd}\n"
n = n+1
循环尾
$发送 ±md±%msg%±kd %kb%±$

排队
event_type = @%event%#protocol
list = $读文件 排队.json []$
如果 event_type == "BLive"
data = {
   "name":%昵称%,
   "uid":%QQ%,
   "prot":"哔哩哔哩",
   "url":@%event%#sender#face
}
如果 data not in list
list.append(data)
$写文件 排队.json %list%$
如果尾
如果尾
另如果 event.get("event_type",None) != None
u_id_d = event.get("data",{})
data = None
如果 u_id_d.get("group_member_openid",None) != None
uid = u_id_d["group_member_openid"]
name_list = $读文件 官机绑定/%群号%/%uid%.json 暂未绑定$
如果 name_list == "暂未绑定"
$调用 登录按钮 #%uid%$
如果尾
否则
name =""
如果 len(name_list["data"]["card"]) <1
name = name_list["data"]["nickname"]
如果尾
否则
name = name_list["data"]["card"]
如果尾
data = {
   "name":%name%,
   "uid":u_id_d["group_member_openid"],
   "prot":"QQ",
   "url":f'https://q.qlogo.cn/qqapp/{bot.self_id}/{uid}/640'
}
如果尾
如果尾
否则
data = {
   "name":%昵称%,
   "uid":%QQ%,
   "prot":"QQ",
   "url":f'https://q.qlogo.cn/qqapp/{bot.self_id}/%QQ%/640'
}
如果尾
如果 data is not None
如果 data not in list
list.append(data)
$写文件 排队.json %list%$
如果尾
$调用 排队列表$

排队表
如果 event.get("event_type",None) != None
$调用 排队列表$

.*删除(.*)
event_type = @%event%#protocol
list = $读文件 排队.json []$
如果 len(list)>0
如果 event_type == "BLive"
pass
如果尾
另如果 event.get("event_type",None) != None
user_info = $读文件 官机绑定/%群号%/%QQ%.json 暂未绑定$
如果 user_info == "暂未绑定"
$调用 登录按钮 #%QQ%$
如果尾
uid = @%user_info%#data#user_id
如果 uid in [3791398858,1593848565]
list.pop(int(%括号1%))
$写文件 排队.json %list%$
$调用 排队列表$