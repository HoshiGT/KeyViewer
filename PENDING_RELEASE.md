# 账号解封后待执行（KeyViewer v4.14.5）

本地已有: commit badb8a4 + tag v4.14.5 + KeyViewer-v4.14.5.zip
远端已有: 8c8967b (两个核心修复已在线)

解封后执行:
1. cd ~/adofaimods/KeyViewer-src && git push origin v4 v4.14.5
2. gh release create v4.14.5 KeyViewer-v4.14.5.zip --title "KeyViewer v4.14.5 — Linux fixes" --notes-file RELEASE_NOTES.md

另: adofai-linux-fix 的 v1.0.1 release 在暂停前已成功发布 (zip+deb 均已上传)。
