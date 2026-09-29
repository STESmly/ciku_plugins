[\s\S]*https://www.bilibili.com/video/(.*)\?[\s\S]*
$调用 bv详情 #%括号1%$

[\s\S]*https://b23.tv/([A-Za-z0-9]{7})
bvid = await resolve_bvid(f"https://b23.tv/%括号1%")
$调用 bv详情 #%bvid%$

[内部]详情kb[括号 aid]
bt = {
  "rows": [
    {
      "buttons": [
        {
          "id": "diuleilaomou",
          "render_data": {
            "label": "获取视频ai总结",
            "style": 1
          },
          "action": {
            "type": 1,
            "data": f"获取b站ai总结_{括号}",
            "permission": {
              "type": 2,
            },
            "reply": True,
            "enter": True,
            "modal": {
              "content": "并不是所有的视频都会有总结的",
              "confirm_text": "✔️确认",
              "cancel_text": "❌取消"
            },
          }
        },
				{
          "id": "yeyeyaowoshouji",
          "render_data": {
            "label": "获取视频高赞评论",
            "style": 1
          },
          "action": {
            "type": 1,
            "data": f"获取b站评论区_{aid}",
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

[内部]bv详情[括号]
backbot = bot.self_id
botlist = $BOT$
c = 0
循环 c < len(botlist)
bot_type = @%botlist%#%c%#type
如果 bot_type == 'BLive'
bot = @%botlist%#%c%#bot
break
如果尾
c += 1
循环尾
res = await get_video_detail_info(bot,bvid=%括号%)
aid = @%res%#data#View#aid
title = @%res%#data#View#title
desc = @%res%#data#View#desc
pic = @%res%#data#View#pic
owner_name = @%res%#data#View#owner#name
owner_face = @%res%#data#View#owner#face
view = @%res%#data#View#stat#view
danmunum = @%res%#data#View#stat#danmaku
reply = @%res%#data#View#stat#reply
like = @%res%#data#View#stat#like
coin = @%res%#data#View#stat#coin
share = @%res%#data#View#stat#share
favorite = @%res%#data#View#stat#favorite
fannum = @%res%#data#Card#card#fans
attention = @%res%#data#Card#card#attention
sign = @%res%#data#Card#card#sign
level = @%res%#data#Card#card#level_info#current_level
like_n = @%res%#data#Card#like_num
md_text = f'#[%title%](https://www.bilibili.com/video/%括号%)\n![封面 #242px #136px](%pic%)\n***\n![头像 #70px #70px](%owner_face%) - %owner_name%\n```详情\n等级：lv.%level%\n粉丝数：%fannum%\n总获赞：%like_n%\n关注：%attention%\n主页签名：%sign%\n```\n***\n```作品信息\n观看数：%view%\n弹幕数：%danmunum%\n评论数：%reply%\n点赞：%like%\n投币：%coin%\n收藏：%favorite%\n转发：%share%\n简介：%desc%\n```'
d = 0
循环 d < len(botlist)
bot_data = @%botlist%#%d%#bot
如果 bot_data.self_id == backbot
bot = @%botlist%#%d%#bot
break
如果尾
d += 1
循环尾
bt = $调用 详情kb #%括号%#%aid%$
res = $发送 ±md±%md_text%±kd %bt%±$

获取b站评论区_(.*)
backbot = bot.self_id
botlist = $BOT$
md_text = "#高赞评论"
c = 0
循环 c < len(botlist)
bot_type = @%botlist%#%c%#type
如果 bot_type == 'BLive'
bot = @%botlist%#%c%#bot
break
如果尾
c += 1
循环尾
content_list = await get_video_reply(bot,%括号1%)
reply_list = @%content_list%#data#replies
i = 0
循环 i < 5
c_w_name = @%reply_list%#%i%#member#uname
c_w_ip = @%reply_list%#%i%#reply_control#location
c_w_time = @%reply_list%#%i%#reply_control#time_desc
c_w_rcount = @%reply_list%#%i%#rcount
c_w_pic = @%reply_list%#%i%#member#avatar
c_w_level = @%reply_list%#%i%#member#level_info#current_level
c_w_like = @%reply_list%#%i%#like
content = @%reply_list%#%i%#content#message
md_text += f'\n\n![头像 #30px #30px](%c_w_pic%) %c_w_name% - lv.%c_w_level%\n - %content%'
pic_list = @%reply_list%#%i%#content#pictures
i += 1
b = 0
循环 b < len(pic_list)
img_w = @%pic_list%#%b%#img_width
img_h = @%pic_list%#%b%#img_height
img_s = @%pic_list%#%b%#img_src
如果 img_w == ' '
pass
如果尾
否则
md_text += f'![表情包 #{int(img_w*2/(5**(len(str(img_w))-2)))}px #{int(img_h*2/(5**(len(str(img_w))-2)))}px](%img_s%)'
如果尾
b += 1
循环尾
md_text += f'\n > 点赞：%c_w_like%  回复：%c_w_rcount%条  %c_w_ip%  %c_w_time%'
循环尾
d = 0
循环 d < len(botlist)
bot_data = @%botlist%#%d%#bot
如果 bot_data.self_id == backbot
bot = @%botlist%#%d%#bot
break
如果尾
d += 1
循环尾
$发送 ±md±%md_text%$

获取b站ai总结_(.*)
backbot = bot.self_id
botlist = $BOT$
c = 0
循环 c < len(botlist)
bot_type = @%botlist%#%c%#type
如果 bot_type == 'BLive'
bot = @%botlist%#%c%#bot
break
如果尾
c += 1
循环尾
res = await get_video_detail_info(bot,bvid=%括号1%)
cid = @%res%#data#View#cid
title = @%res%#data#View#title
pic = @%res%#data#View#pic
res = await get_video_ai_text(bot,bvid=%括号1%,cid=cid)
summary = @%res%#data#model_result#summary
outline = @%res%#data#model_result#outline
md_text = f'#%title%\n![封面 #242px #136px](%pic%)\n***\n全文摘要：\n > %summary%\n***\n##分段总结'
i = 0
循环 i < len(outline)
part_title = @%outline%#%i%#title
logger.debug(part_title)
part_outline = @%outline%#%i%#part_outline
part_time = @%outline%#%i%#timestamp
use_time = format_duration(part_time)
md_text +=f'\n{i+1}. 【[🛬%use_time%](https://www.bilibili.com/video/%括号1%/?t=%part_time%)】 %part_title%'
i = i+1
b=0
循环 b < len(part_outline)
timestamp = @%part_outline%#%b%#timestamp
content = @%part_outline%#%b%#content
use_time = format_duration(timestamp)
md_text += f'\n	- 【[🛬%use_time%](https://www.bilibili.com/video/%括号1%/?t=%timestamp%)】 %content%'
b = b+1
循环尾
循环尾
d = 0
循环 d < len(botlist)
bot_data = @%botlist%#%d%#bot
如果 bot_data.self_id == backbot
bot = @%botlist%#%d%#bot
break
如果尾
d += 1
循环尾
$发送 ±md±%md_text%$