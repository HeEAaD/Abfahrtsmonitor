#!/usr/bin/env sh

Copy () {
  convert $1 -resize $2 "$3"
  open -a ImageOptim "$3"
}

Copy app_icon.png 48 ../Abfahrtmonitor\ WatchKit\ App/Assets.xcassets/AppIcon.appiconset/48.png
Copy app_icon.png 55 ../Abfahrtmonitor\ WatchKit\ App/Assets.xcassets/AppIcon.appiconset/55.png
Copy app_icon.png 58 ../Abfahrtmonitor\ WatchKit\ App/Assets.xcassets/AppIcon.appiconset/58.png
Copy app_icon.png 80 ../Abfahrtmonitor\ WatchKit\ App/Assets.xcassets/AppIcon.appiconset/80.png
Copy app_icon.png 87 ../Abfahrtmonitor\ WatchKit\ App/Assets.xcassets/AppIcon.appiconset/87.png
Copy app_icon.png 172 ../Abfahrtmonitor\ WatchKit\ App/Assets.xcassets/AppIcon.appiconset/172.png
Copy app_icon.png 196 ../Abfahrtmonitor\ WatchKit\ App/Assets.xcassets/AppIcon.appiconset/196.png

Copy app_icon_alpha.png 32 ../Abfahrtmonitor\ WatchKit\ Extension/Assets.xcassets/Complication.complicationset/Circular.imageset/32.png
Copy app_icon_alpha.png 36 ../Abfahrtmonitor\ WatchKit\ Extension/Assets.xcassets/Complication.complicationset/Circular.imageset/36.png
Copy app_icon_alpha.png 40 ../Abfahrtmonitor\ WatchKit\ Extension/Assets.xcassets/Complication.complicationset/Utilitarian.imageset/40.png
Copy app_icon_alpha.png 44 ../Abfahrtmonitor\ WatchKit\ Extension/Assets.xcassets/Complication.complicationset/Utilitarian.imageset/44.png
Copy app_icon_alpha.png 52 ../Abfahrtmonitor\ WatchKit\ Extension/Assets.xcassets/Complication.complicationset/Modular.imageset/52.png
Copy app_icon_alpha.png 58 ../Abfahrtmonitor\ WatchKit\ Extension/Assets.xcassets/Complication.complicationset/Modular.imageset/58.png
