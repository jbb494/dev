#!/usr/bin/env bash

# Adding evdev rules
if grep -q "ergodox-dvorak" /usr/share/X11/xkb/rules/evdev.xml; then
	echo "evdev.xml already has ergodox-dvorak layout definition"
	exit 0
fi

dvorak_env="
<layout>
      <configItem>
        <name>ergodox-dvorak</name>
        <shortDescription>epd</shortDescription>
        <description>Ergodox Dvorak English (US)</description>
      </configItem>
      <variantList>
	<variant>
	    <configItem>
		<name>ergodox-dvorak</name>
		<description>English (Ergodox dvorak)</description>
		<vendor>MichaelPaulson</vendor>
	    </configItem>
	</variant>
      </variantList>
</layout>
"

layout_list=$(cat /usr/share/X11/xkb/rules/evdev.xml | grep "<layoutList>" -n  | cut -f1 -d:)
total_lines=$(cat /usr/share/X11/xkb/rules/evdev.xml | wc -l)
tail_lines=$(($total_lines - $layout_list))

up_to=$(cat /usr/share/X11/xkb/rules/evdev.xml | head -$layout_list)
remaining=$(cat /usr/share/X11/xkb/rules/evdev.xml | tail -$tail_lines)

echo "$up_to
$dvorak_env
$remaining
" > /usr/share/X11/xkb/rules/evdev.xml

# Adding types to complete
if grep -q "capsnumber" /usr/share/X11/xkb/types/complete; then
	echo "complete type already has capsnumber"
	exit 0
fi

type_env='    include "capsnumber"'


total_lines=$(cat /usr/share/X11/xkb/types/complete | wc -l)
up_to_lines=$((total_lines-1))

up_to=$(cat /usr/share/X11/xkb/types/complete | head -$up_to_lines)
remaining=$(cat /usr/share/X11/xkb/types/complete | tail -1)

echo "$up_to
$type_env
$remaining" >/usr/share/X11/xkb/types/complete  

echo "don't forget to log out to let these changes take effect"
