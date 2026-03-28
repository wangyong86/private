#!/usr/bin/env python3
import argparse
import mimetypes
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

mimetypes.add_type("text/markdown; charset=utf-8", ".md")


class Handler(SimpleHTTPRequestHandler):
    extensions_map = {
        **SimpleHTTPRequestHandler.extensions_map,
        ".md": "text/markdown; charset=utf-8",
    }


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Serve a directory and return .md as text/markdown; charset=utf-8"
    )
    parser.add_argument(
        "directory",
        nargs="?",
        default=".",
        help="Directory to serve (default: current directory)",
    )
    parser.add_argument(
        "-p",
        "--port",
        type=int,
        default=8765,
        help="Port to listen on (default: 8765)",
    )
    parser.add_argument(
        "--host",
        default="0.0.0.0",
        help="Bind address (default: 0.0.0.0, accessible from other machines)",
    )
    args = parser.parse_args()

    directory = str(Path(args.directory).resolve())
    handler = partial(Handler, directory=directory)
    server = ThreadingHTTPServer((args.host, args.port), handler)

    print(f"Serving {directory}")
    print(f"Listening on http://{args.host}:{args.port}/")
    server.serve_forever()


if __name__ == "__main__":
    main()
