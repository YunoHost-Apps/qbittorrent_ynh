#!/bin/bash

#=================================================
# QBITTORRENT WEBUI PASSWORD
#=================================================

# Hash <password> into the "<b64 salt>:<b64 key>" payload of WebUI\Password_PBKDF2,
# per upstream password.cpp. Passed through the env so it stays out of `ps`.
qbittorrent_password_pbkdf2() {
    QBITTORRENT_PASSWORD="$1" python3 -c '
import base64, hashlib, os

salt = os.urandom(16)
key = hashlib.pbkdf2_hmac("sha512", os.environb[b"QBITTORRENT_PASSWORD"], salt, 100000, 64)
print(base64.b64encode(salt).decode() + ":" + base64.b64encode(key).decode())
'
}

# Is the password stored in <file> equal to <password>? Hashes can't be compared
# directly since the salt differs per install, so the stored salt is reused.
qbittorrent_password_is() {
    QBITTORRENT_CONF="$1" QBITTORRENT_PASSWORD="$2" python3 -c '
import base64, hashlib, hmac, os, re, sys

conf = open(os.environ["QBITTORRENT_CONF"]).read()
stored = re.search(r"^WebUI\\Password_PBKDF2=\"?(?:@ByteArray\()?([^)\"\n]*)", conf, re.M)

if not stored or ":" not in stored.group(1):
    sys.exit(1)

salt, key = (base64.b64decode(part) for part in stored.group(1).split(":", 1))
candidate = hashlib.pbkdf2_hmac("sha512", os.environb[b"QBITTORRENT_PASSWORD"], salt, 100000, len(key))

sys.exit(0 if hmac.compare_digest(candidate, key) else 1)
'
}

#=================================================
# QBITTORRENT CONFIG FILE
#=================================================

# Set <key> to <value> in an existing qBittorrent.conf. qBittorrent rewrites that
# file on exit, so upgrades patch it in place instead of re-rendering the template.
qbittorrent_conf_set() {
    QBITTORRENT_CONF="$1" QBITTORRENT_KEY="$2" QBITTORRENT_VALUE="$3" python3 -c '
import os

path = os.environ["QBITTORRENT_CONF"]
key = os.environ["QBITTORRENT_KEY"]
line = key + "=" + os.environ["QBITTORRENT_VALUE"]

with open(path) as f:
    lines = f.read().splitlines()

for i, existing in enumerate(lines):
    if existing.split("=", 1)[0].strip() == key:
        lines[i] = line
        break
else:
    if "[Preferences]" not in lines:
        lines.append("[Preferences]")
    lines.insert(lines.index("[Preferences]") + 1, line)

with open(path, "w") as f:
    f.write("\n".join(lines) + "\n")
'
}
