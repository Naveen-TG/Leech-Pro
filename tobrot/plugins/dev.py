import io, uuid, subprocess

from tobrot import app as pbot
from pyrogram import filters

def get_as_document(text_string: str, ext: str = "txt"):
    filename = f"{uuid.uuid4()}.{ext}"
    file = io.BytesIO(str.encode(text_string))
    file.name = filename
    return file

@pbot.on_message(filters.command('logs') & filters.user(config.dev_list))
async def Logs(_, message):
     m = message 
     logs_text = subprocess.getoutput('tail Torrentleech-Gdrive.txt')
     file = get_as_document(logs_text)
     await m.reply_document(
            document = file, 
            caption = "logs are here"
 
     )
