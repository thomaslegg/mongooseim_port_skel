--- tools/generate_vsn.sh.orig	2016-02-15 07:47:05 UTC
+++ tools/generate_vsn.sh
@@ -1,5 +1,5 @@
-#!/bin/bash
-DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
+#!/bin/sh
+DIR="$( cd "$( dirname $0 )" && pwd )"
 GIT_VSN=`git describe --always --tags 2>/dev/null`
 
 if [ $? -eq 0 ]; then
