import asyncio
from _mainWIndow import window
from model import *

async def controllerStream():
    cs = asyncio.start_server(_handleIns, host="127.0.0.1", port=85)
    async with cs:
        await cs.serve_forever()

async def _handleIns(reader, writer):
    data = await reader.read(100)
    message = data.decode()
    addr = writer.get_extra_info('peername')
    print(f"Received {message!r} from {addr!r}")

    window.tablepanel.buildList(names=list(names.keys()))
    

async def inStream(start=bool):
    r, w = asyncio.open_connection(host="127.0.0.1", port=85)
    w.write(start)