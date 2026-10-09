签到
Y = %时间Y%
M = %时间M%
D = %时间D%
kd = $调用 签到按钮$
event_type = @%event%#event_type
如果 event_type != 'INTERACTION_CREATE'
id = %QQ%
如果尾
否则
id = @%event%#data#group_member_openid
如果尾
user_data = $读 系统/群数据/%群号%/用户数据/签到/%id%.txt None$
user_day = @%user_data%#%Y%#%M%
如果 user_data == None
user_data = {%Y%:{%M%:[int(%D%)]}}
$写 系统/群数据/%群号%/用户数据/签到/%id%.txt %user_data%$
$发送 ±md±±at %id%±签到成功!±kd %kd%±$
如果尾
另如果 int(D) not in user_day
user_day.append(int(%D%))
user_data[%Y%][%M%] = user_day
$写 系统/群数据/%群号%/用户数据/签到/%id%.txt %user_data%$
$发送 ±md±±at %id%±签到成功!±kd %kd%±$
如果尾
否则
$发送 ±md±±at %id%±你今天已经签到过了±kd %kd%±$

签到表
Y = %时间Y%
M = %时间M%
D = %时间D%
kd = $调用 签到按钮$
data = "\%Y-\%m-\%d"
data = data.replace("\\","")
import time
dayly = time.strptime(f"{Y}-{M}-1",data)
dayly = dayly.tm_wday
import calendar
days = calendar.monthrange(int(Y), int(M))[1]
event_type = @%event%#event_type
如果 event_type != 'INTERACTION_CREATE'
id = %QQ%
如果尾
否则
id = @%event%#data#group_member_openid
如果尾
user_data = $读 系统/群数据/%群号%/用户数据/签到/%id%.txt None$
如果 user_data == None
user_data = {%Y%:{%M%:[]}}
如果尾
user_day = @%user_data%#%Y%#%M%
all = rf"$\textcolor{{#8E44AD}}{{{{{len(user_day)}}}}}$"
md_text = "|一|二|三|四|五|六|七|\n|-|-|-|-|-|-|-|\n|"
d = 1
t = dayly + 1
l = 0
md_text += "|"*(t-1)
循环 d <= days
如果 d in user_day
如果 t == 7
如果 int(D) < d
md_text += f"{d}|\n|"
如果尾
否则
md_text += rf"$\textcolor{{#1ABC9C}}{{{{{d}}}}}$|\n|"
如果尾
t = 0
如果尾
否则
如果 int(D) < d
md_text += f"{d}|"
如果尾
否则
md_text += rf"$\textcolor{{#1ABC9C}}{{{{{d}}}}}$|"
如果尾
t += 1
如果尾
l += 1
如果尾
否则
如果 t == 7
如果 int(D) < d
md_text += f"{d}|\n|"
如果尾
否则
md_text += rf"$\textcolor{{#E74C3C}}{{{{{d}}}}}$|"+"\n|"
如果尾
t = 0
如果尾
否则
如果 int(D) < d
md_text += f"{d}|"
如果尾
否则
md_text += rf"$\textcolor{{#E74C3C}}{{{{{d}}}}}$|"
如果尾
t += 1
如果尾
如果 int(D) >= d
l = 0
如果尾
如果尾
d += 1
循环尾
lian = rf"$\textcolor{{#00CED1}}{{{{{l}}}}}$"
title = rf"$\mathbb{{{M} \; Sign-In Sheet}}$"
如果 int(D) not in user_day
$发送 ±md±±at %id%±\n#%title%\n%md_text%\n > 本月累计签到%all%天\n > 已连续签到%lian%天\n你今天还没有签到，即将断签了哦±kd %kd%±$
如果尾
否则
$发送 ±md±±at %id%±\n#%title%\n%md_text%\n > 本月累计签到%all%天\n > 已连续签到%lian%天±kd %kd%±$

[内部]签到按钮
bt = {
  "rows": [
    {
      "buttons": [
        {
          "id": "qiandao",
          "render_data": {
            "label": "我也要签到",
            "visited_label":"我也要签到",
            "style": 1
          },
          "action": {
            "type": 1,
            "data": f"签到",
            "permission": {
              "type": 2,
            },
            "reply": True,
            "enter": True,
          }
        },
                {
          "id": "qiandaobiao",
          "render_data": {
            "label": "查看本月签到",
            "visited_label":"查看本月签到",
            "style": 1
          },
          "action": {
            "type": 1,
            "data": f"签到表",
            "permission": {
              "type": 2,
            },
            "reply": True,
            "enter": True,
          }
        }
      ]
    }
  ]
}
返回 bt