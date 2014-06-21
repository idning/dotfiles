#!/usr/bin/env python
#coding: utf-8
#file   : torrent2magent.py
#author : ning
#date   : 2013-02-24 17:02:59

import bencode, hashlib, sys, base64, urllib


def convert(torrent_file):
    torrent_name = torrent_file.replace('.torrent', '')

    torrent = open(torrent_file,"rb").read()
    info = bencode.bdecode(torrent)["info"]
    infohash = hashlib.sha1( bencode.bencode(info) )
    #print "Infohash: %s" % infohash.hexdigest()
    return "magnet:?xt=urn:btih:%s&dn=%s" % ( base64.b32encode(infohash.digest()), urllib.quote_plus(torrent_name) )


for f in sys.argv[1:]:
    try:
        print convert(f)
    except Exception, e:
        print 'err ', e
