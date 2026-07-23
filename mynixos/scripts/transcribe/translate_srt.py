#!/usr/bin/env python3

import json
import sys
import urllib.request


API = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"


def call_gemini(api_key, lines):

    prompt = """
Translate every line to Arabic.

Rules:

- Translate ONLY.
- Keep line order.
- Return exactly one translated line for each input line.
- Do not number them.
- Do not explain.
"""

    prompt += "\n\n"

    prompt += "\n".join(lines)

    body = {
        "contents": [
            {
                "parts": [
                    {
                        "text": prompt
                    }
                ]
            }
        ]
    }

    req = urllib.request.Request(
        API + "?key=" + api_key,
        data=json.dumps(body).encode(),
        headers={"Content-Type": "application/json"},
    )

    with urllib.request.urlopen(req) as r:
        data = json.loads(r.read())

    text = (
        data["candidates"][0]
        ["content"]["parts"][0]
        ["text"]
    )

    result = [
        x.strip()
        for x in text.splitlines()
        if x.strip()
    ]

    return result


def parse_srt(path):

    with open(path, encoding="utf8") as f:
        lines = f.read().splitlines()

    subtitles = []

    i = 0

    while i < len(lines):

        if not lines[i].strip():
            i += 1
            continue

        number = lines[i]
        timestamp = lines[i + 1]

        i += 2

        text = []

        while i < len(lines) and lines[i].strip():
            text.append(lines[i])
            i += 1

        subtitles.append({
            "number": number,
            "time": timestamp,
            "text": " ".join(text)
        })

    return subtitles


def write_srt(path, subtitles, translated):

    with open(path, "w", encoding="utf8") as f:

        for sub, tr in zip(subtitles, translated):

            f.write(sub["number"] + "\n")
            f.write(sub["time"] + "\n")
            f.write(tr + "\n\n")


def main():

    src = sys.argv[1]
    dst = sys.argv[2]
    key = sys.argv[3]

    subtitles = parse_srt(src)

    texts = [x["text"] for x in subtitles]

    translated = []

    batch = 30

    for i in range(0, len(texts), batch):

        chunk = texts[i:i + batch]

        translated.extend(
            call_gemini(key, chunk)
        )

        print(f"{min(i+batch,len(texts))}/{len(texts)}")

    if len(translated) != len(subtitles):

        print("Translation count mismatch")
        sys.exit(1)

    write_srt(dst, subtitles, translated)

    print(dst)


if __name__ == "__main__":
    main()