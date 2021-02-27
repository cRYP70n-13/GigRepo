#!/bin/bash
function do_exit()
{
  echo "$2"
  exit $1
}
​
curl -s -f http://localhost/ >/dev/null || do_exit 1 "port 80/tcp down"
​
# for interesting files
sha512sum -c --status < /usr/local/lib/.sha512sum || do_exit 3 "files checksum fail"
​
# for environment variable
# ENVFLAG=$(env|grep ETSCTF_FLAG|sha256sum|awk '{print $1}')
# [ "$ENVFLAG" == "ENVFLAG_HASH" ] || do_exit 3 "env checksum fail"