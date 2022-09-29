#!/usr/bin/python2

import sys, os
import subprocess
import fcntl

dump = open("/tmp/dump", "w")
dump.write("### starting %s ###" % " ".join(sys.argv))

proc = subprocess.Popen(["<real app>"] + sys.argv[1:], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

def nonblocking(fd):
  fl = fcntl.fcntl(fd, fcntl.F_GETFL)
  fcntl.fcntl(fd, fcntl.F_SETFL, fl | os.O_NONBLOCK)

nonblocking(proc.stdin)
nonblocking(proc.stdout)
nonblocking(proc.stderr)

nonblocking(sys.__stdin__)
nonblocking(sys.__stdout__)
nonblocking(sys.__stderr__)

def me_to_proc():
  x_to_y(sys.__stdin__, proc.stdin, "~in> ")

def proc_to_me():
  x_to_y(proc.stdout, sys.__stdout__, "<out~ ")

def proc_to_me_err():
  x_to_y(proc.stderr, sys.__stderr__, "<err~ ")

def x_to_y(x, y, prefix=""):
  try:
    while True:
       line = x.readline()
       to_dump = "%s%s" % (prefix, line)
       print >> dump, to_dump
       print to_dump
       y.write(line)
       y.flush()
       dump.flush()
  except:
    pass

recode = None
while recode is None:
  proc_to_me()
  #proc_to_me_err()
  me_to_proc()

  retcode = proc.poll()

exit(retcode)
