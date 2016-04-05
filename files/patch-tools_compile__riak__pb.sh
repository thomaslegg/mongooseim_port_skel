--- tools/compile_riak_pb.sh.orig	2016-02-15 07:47:05 UTC
+++ tools/compile_riak_pb.sh
@@ -1,3 +1,3 @@
-#!/bin/bash
+#!/bin/sh
 
-cd deps/riak_pb; ./rebar compile deps_dir=..
\ No newline at end of file
+cd deps/riak_pb; ./rebar compile deps_dir=..
