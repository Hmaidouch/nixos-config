#!/usr/bin/env python3

import json
import sys
from pathlib import Path


def format_srt(seconds: float) -> str:
    ms = int((seconds - int(seconds)) * 1000)
    s = int(seconds)
    h = s // 3600
    m = (s % 3600) // 60
    s = s % 60
    return f"{h:02}:{m:02}:{s:02},{ms:03}"


def format_vtt(seconds: float) -> str:
    ms = int((seconds - int(seconds)) * 1000)
    s = int(seconds)
    h = s // 3600
    m = (s % 3600) // 60
    s = s % 60
    return f"{h:02}:{m:02}:{s:02}.{ms:03}"


def main():

    if len(sys.argv) != 2:
        print("Usage:")
        print("json_to_srt.py file.json")
        sys.exit(1)

    json_file = Path(sys.argv[1])

    with json_file.open("r", encoding="utf-8") as f:
        data = json.load(f)

    segments = data["segments"]

    base = json_file.with_suffix("")

    txt_file = base.with_suffix(".txt")
    srt_file = base.with_suffix(".srt")
    vtt_file = base.with_suffix(".vtt")

    # TXT
    with txt_file.open("w", encoding="utf-8") as txt:
        for seg in segments:
            txt.write(seg["text"].strip())
            txt.write("\n")

    # SRT
    with srt_file.open("w", encoding="utf-8") as srt:
        for i, seg in enumerate(segments, start=1):

            start = format_srt(seg["start"])
            end = format_srt(seg["end"])

            srt.write(f"{i}\n")
            srt.write(f"{start} --> {end}\n")
            srt.write(seg["text"].strip())
            srt.write("\n\n")

    # VTT
    with vtt_file.open("w", encoding="utf-8") as vtt:

        vtt.write("WEBVTT\n\n")

        for seg in segments:

            start = format_vtt(seg["start"])
            end = format_vtt(seg["end"])

            vtt.write(f"{start} --> {end}\n")
            vtt.write(seg["text"].strip())
            vtt.write("\n\n")

    print("Generated:")
    print(txt_file)
    print(srt_file)
    print(vtt_file)


if __name__ == "__main__":
    main()