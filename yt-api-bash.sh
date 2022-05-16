YOUTUBE_API_KEY=""
YOUTUBE_API_URL="https://www.googleapis.com/youtube/v3"

function yt {

if [[ $# -eq 0 ]] ; then
cat << EOF
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
EOF
exit 1
fi

target_id="$(echo -n "${@:2}" | sed 's/ /,/g')"
req_type="video"

case $1 in

  "video")
    req_type="video"
    ;;

  "playlist")
    req_type="playlist"
    ;;

  "channel")
    req_type="channel"
    ;;

  "comments")
    req_type="comments"
    ;;

  "replies")
    req_type="replies"
    ;;

  *)
    target_id="$(echo -n "$@" | sed 's/ /,/g')"
    [ ${#1} -eq 11 ] && req_type="video"
    [ ${#1} -eq 18 ] && req_type="playlist"
    [ ${#1} -eq 34 ] && req_type="playlist"
    [ ${#1} -eq 24 ] && req_type="channel"
    [ ${#1} -eq 26 ] && req_type="replies"
    ;;
esac

case $req_type in

  "video")
    result="$(curl --silent "${YOUTUBE_API_URL}/videos?key=${YOUTUBE_API_KEY}&id=${target_id}&part=contentDetails,id,liveStreamingDetails,localizations,player,recordingDetails,snippet,statistics,status&maxResults=50")"
    echo "${result}"
    ;;

  "playlist")
    [ -z "${target_id}" ] || playlist_pagetoken=""
    [ -z "${target_id}" ] || playlist_id="${target_id}"
    result="$(curl --silent "${YOUTUBE_API_URL}/playlistItems?key=${YOUTUBE_API_KEY}&playlistId=${playlist_id}&part=contentDetails,id,snippet,status&maxResults=50&pageToken=${playlist_pagetoken}")"
    echo "${result}"
    playlist_pagetoken="$(echo "${result}" | jq -r .nextPageToken)"
    ;;

  "channel")
    result="$(curl --silent "${YOUTUBE_API_URL}/channels?key=${YOUTUBE_API_KEY}&id=${target_id}&part=brandingSettings,contentDetails,contentOwnerDetails,id,localizations,snippet,statistics,status,topicDetails&maxResults=50")"
    echo "${result}"
    ;;

  "comments")
    [ -z "${target_id}" ] || comments_pagetoken=""
    [ -z "${target_id}" ] || comments_videoid="${target_id}"
    result="$(curl --silent "${YOUTUBE_API_URL}/commentThreads?key=${YOUTUBE_API_KEY}&videoId=${comments_videoid}&part=id,snippet,replies&maxResults=100&order=relevance&pageToken=${comments_pagetoken}")"
    echo "${result}"
    comments_pagetoken="$(echo "${result}" | jq -r .nextPageToken)"
    ;;

  "replies")
    [ -z "${target_id}" ] || replies_pagetoken=""
    [ -z "${target_id}" ] || replies_parentid="${target_id}"
    result="$(curl --silent "${YOUTUBE_API_URL}/comments?key=${YOUTUBE_API_KEY}&parentId=${replies_parentid}&part=id,snippet&maxResults=100&order=relevance&pageToken=${replies_pagetoken}")"
    echo "${result}"
    replies_pagetoken="$(echo "${result}" | jq -r .nextPageToken)"
    ;;
esac

}
