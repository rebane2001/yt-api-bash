# yt-api-bash
A simple bash function to use the YouTube API

## Setup
Add your API key into the script and source this file into your bashrc or whatever.

## Usage

```
It is recommened to pipe the output into jq and do further processing.

Retrieve a video:
yt dQw4w9WgXcQ
yt video dQw4w9WgXcQ

Retrieve multiple videos:
yt dQw4w9WgXcQ dQw4w9WgXcQ dQw4w9WgXcQ
yt video dQw4w9WgXcQ dQw4w9WgXcQ dQw4w9WgXcQ

Retrieve a playlist:
yt PL3AD277545C29B0C3
yt playlist PLlaN88a7y2_rosKX2WQt2VjFbjyDQXOkR

Retrieve a channel:
yt UCuAXFkgsw1L7xaCfnd5JJOw
yt channel UCuAXFkgsw1L7xaCfnd5JJOw

Retrieve multiple channels:
yt UCuAXFkgsw1L7xaCfnd5JJOw UCuAXFkgsw1L7xaCfnd5JJOw
yt channel UCuAXFkgsw1L7xaCfnd5JJOw UCuAXFkgsw1L7xaCfnd5JJOw

Retrieve comments of a video:
yt comments dQw4w9WgXcQ

Retrieve replies to a comment (parent comment ID as arg):
yt Ugyl5HNrAdGgGu4ewaN4AaABAg
yt replies Ugyl5HNrAdGgGu4ewaN4AaABAg

Retrieve the next page of playlist/comment/reply results:
yt playlist
yt comments
yt replies
```
