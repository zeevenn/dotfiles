#!/bin/sh
#
# This corrects a shitty point of confusion with macOS where if you bounce
# between wireless and wired connections, macOS will suddenly throw up its hands
# and add a random-ass number to your hostname. Do it a couple times and you're
# in like, the thousands appended to your hostname, which makes you look like a
# chump when your machine is called "incredible-programmer-9390028", like
# you're behind 9,390,027 other better programmers before you. Sheesh.
#
# Anyway, this runs in `dot` and only asks for your permission (usually TouchID)
# if it actually needs to change your hostname for you, otherwise it's fast to
# toss into `dot` anyway.
#
# None of this really matters in the big scheme of things, but it bothered me.

PREFERRED_HOSTNAME="pixel"

local_hostname=$(scutil --get LocalHostName)
computer_name=$(scutil --get ComputerName)
hostname=$(scutil --get HostName 2>/dev/null || echo "")

# Set all hostnames to preferred hostname if any of them differ
if [ "$local_hostname" != "$PREFERRED_HOSTNAME" ] || [ "$computer_name" != "$PREFERRED_HOSTNAME" ] || [ "$hostname" != "$PREFERRED_HOSTNAME" ]; then
  echo "Setting hostname to $PREFERRED_HOSTNAME"
  sudo scutil --set LocalHostName "$PREFERRED_HOSTNAME"
  sudo scutil --set ComputerName "$PREFERRED_HOSTNAME"
  sudo scutil --set HostName "$PREFERRED_HOSTNAME"
fi
