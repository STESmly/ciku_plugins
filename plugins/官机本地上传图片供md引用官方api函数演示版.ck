测试bot
url = "/root/.config/ciku-bot/cikuapk/videos/qrcode/16723919BFBAA8F4B88C188E4921E73F.png"
##注意目前只支持绝对路径
data = $调用 上传图片 #%url%$
$发送 %data%$

测试bot1
data = $调用 图片列表 #False$
$发送 %data%$

测试删除
id="102334521_e27eab2e4823cb39"
data = $调用 删除图片 #%id%$
$发送 %data%$

[内部]检测token
import time
id = bot.self_id
data = $读 bot/%id%/token.text {"token":"","time":0}$
token = @%data%#token
dtime = @%data%#time
dtime = int(dtime)
如果 token and time.time() < dtime-60
返回 token
如果尾
config = bot.config
app_id = @%config%#app_id
secret = @%config%#bot_secret
body = {
    "appId":f'%app_id%',
    "clientSecret":%secret%
}
headers = {"Content-Type": "application/json"}
req = $访问 https://bots.qq.com/app/getAppAccessToken post %headers% %body%$
token = @%req%#access_token
dtime = @%req%#expires_in
dtime = time.time()+int(dtime)
data = {
    "token":token,
    "time":dtime
}
$写 bot/%id%/token.text %data%$
返回 token

[内部]申请上传[path]
import hashlib
p = Path(path)
raw = p.read_bytes()
file_size = len(raw)
ext = p.suffix.lower()
content_type_map = {
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".webp": "image/webp",
}
content_type = content_type_map.get(ext)
如果 content_type is False
返回 False
如果尾
body = {
  "file_name": p.name,
  "file_size": file_size,
  "content_type": content_type,
  "md5": hashlib.md5(raw).hexdigest(),
  "sha1": hashlib.sha1(raw).hexdigest(),
}
token = $调用 检测token$
token = f"QQBot {token}"
headers = {
    "Content-Type": "application/json",
    "Authorization": token
}
data = $访问 https://api.bot.qq.com/v2/media-images/prepare post %headers% %body%$
返回 data

[内部]预签名[url fbytes content]
import urllib.request
import ast
fbytes = ast.literal_eval(fbytes)
req = urllib.request.Request(
  url,
  data=fbytes,
  method="PUT",
  headers={"Content-Type": content},
)
with urllib.request.urlopen(req, timeout=120) as resp:
  etag = resp.headers.get("ETag", "")
  resp.read()  # 消费掉响应体
返回 etag.strip('"')

[内部]上传图片[path]
from pathlib import Path
p = Path(path)
raw = p.read_bytes()
prep = $调用 申请上传 #%path%$
upload_id = @%prep%#upload_id
presigned_url = @%prep%#presigned_url
ext = p.suffix.lower()
content_type_map = {
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".webp": "image/webp",
}
content_type = content_type_map[ext]
etag_md5 = $调用 预签名 #%presigned_url%#%raw%#%content_type%$
body = {
  "upload_id": upload_id,
  "md5": etag_md5,
}
token = $调用 检测token$
token = f"QQBot {token}"
headers = {
    "Content-Type": "application/json",
    "Authorization": token
}
data = $访问 https://api.bot.qq.com/v2/media-images/complete post %headers% %body%$
返回 data

[内部]图片列表[num=False]
import urllib.request
token = $调用 检测token$
token = f"QQBot {token}"
headers = {
    "Content-Type": "application/json",
    "Authorization": token
}
如果 num != False
url = f"https://api.bot.qq.com/v2/media-images?cursor={num}"
如果尾
否则
url = "https://api.bot.qq.com/v2/media-images"
如果尾
data = $访问 %url% get %headers% None$
返回 data

[内部]删除图片[id]
import aiohttp
token = $调用 检测token$
token = f"QQBot {token}"
headers = {
    "Content-Type": "application/json",
    "Authorization": token
}
url = f"https://api.bot.qq.com/v2/media-images/{id}/delete"
timeout_cfg = aiohttp.ClientTimeout(total=15)
async with aiohttp.ClientSession(timeout=timeout_cfg) as session:
  async with session.delete(url, headers=headers) as resp:
    raw = await resp.read()
    text = json.loads(raw.decode("utf-8", errors="replace")) if raw else {}
返回 text