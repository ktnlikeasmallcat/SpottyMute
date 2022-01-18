#!/bin/bash
## ~/.local/bin/5nowplaying.sh ##

ad(){ #is spotify trying to sell me something and calling it a song?
local SONG=$( eval spotifycli --song )
test
[[ $SONG == "Advertisement" ]]
}

checkmute(){ # am I muted already? returns 1 if unmuted. !checkmute means muted
test
[[ $( eval amixer -D pulse sget Master | grep -F [on] ) ]]
}

ifad(){ #prints now playing for clementine, "muted," and cmus
local C=$( np -n )
local M="MUTED ·"
local CMUS=$( tail -n 1 ~/.cmus/now-playing )
echo -n $C $M $CMUS
}

ifnoad(){ #prints now playing for clementine, spotify, and cmus
local C=$( np -n )
local S=$( spotifycli --status )
local CMUS=$( tail -n 1 ~/.cmus/now-playing )
echo -n $C $S $CMUS
}

if ad ; then ifad ;
elif ! ad ; then ifnoad;
else ifnoad ; fi #something's gone wrong

while ad && checkmute ; #if there's an ad and alsa is unmuted, runs fuckads.sh
    do
    #    fuckads.sh    #
    toggle(){ #flip the switch
    amixer -q -D pulse sset Master toggle
    }
    if ad ; then #yea spotify is trying to sell me something
        while ad ; #right now?
        do
            if checkmute ; #am I muted yet?
                then
                toggle && notify-send "🔇️FUCKADS🔇️ MUTING THAT SHIT" ; #mute
                sleep 30 #each ad is like 30 secs
            fi; continue; # another one ??
        done;
        while ! ad ; #ok spotify isn't trying to sell me something
        do
            if ! checkmute ; #am I still muted?
                then
                toggle && notify-send "✅️FUCKADS✅️ MUTED THAT SHIT" ; #unmute
                sleep 30 #wait to check for another ad
            fi
        done
    fi
break; sleep 30 ; done #waits 30 seconds before checking and unmuting


