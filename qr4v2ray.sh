image_url=$(curl https://view.freev2ray.org/|grep -E "image-1" -B1 |grep href|awk -F[\"] '{print "https://view.freev2ray.org/"$2}')
echo $image_url
curl -o code.png $image_url
code_base64=$(cat code.png |base64 --wrap=0)
sha_str=$("blob $(printf "$code_base64" | wc -c)\0$code_base64" | sha1sum)
shasum=$(echo ${sha_str:0:40})
sha=$(curl -H "Accept: application/vnd.github.v3+json"   https://qr4v2ray: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@api.github.com/repos/qr4v2ray/qrcode/contents/code.png |grep "\"sha\":"|awk -F[\"\"] '{print $4}')
if [[ "$shasum" != "$sha" ]];then
  echo update
  json="{\"message\":\"message\",\"content\":\"$code_base64\",\"sha\":\"$sha\"}"
  echo $json
  curl -X PUT -H "Accept: application/vnd.github.v3+json" https://qr4v2ray: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@api.github.com/repos/qr4v2ray/qrcode/contents/code.png -d "$json"
fi
