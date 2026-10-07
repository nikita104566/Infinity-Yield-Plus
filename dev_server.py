import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

PORT = 8765
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class LocalScriptHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, HEAD, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        self.send_header('Cache-Control', 'no-cache, no-store, must-revalidate')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()

    def guess_type(self, path):
        base = os.path.basename(path).lower()
        if base in ('source', 'source.lua', 'loader.luau', 'crosshair.luau') or base.endswith(('.lua', '.luau')):
            return 'text/plain; charset=utf-8'
        return super().guess_type(path)

    def log_message(self, format, *args):
        sys.stdout.write(f"[IYP Server] {self.address_string()} - {format % args}\n")
        sys.stdout.flush()

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', PORT), LocalScriptHandler)
    print(f"[IYP Server] Serving from {DIRECTORY}")
    print(f"[IYP Server] Listening on http://127.0.0.1:{PORT}/source")
    sys.stdout.flush()
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
