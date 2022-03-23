#!/usr/bin/env bash

gib_workspace_names() {
  wmctrl -d \
    | awk '{ print $1 " " $2 " " $9 }'
}

gib_workspace_yuck() {
  buffered=""
  gib_workspace_names $1 | while read -r id active name; do
    name="${name#*_}"
    if [ "$active" == '-' ]; then
      active_class="inactive"
    else
      active_class="active"
    fi

    if wmctrl -l | grep --regexp '.*\s\+'"$id"'\s\+.*' >/dev/null; then
      button_class="occupied"
      button_name="$name"
    else
      button_class="empty"
      button_name="E"
    fi
    buffered+="(button :class \"$active_class\"  :onclick \"wmctrl -s $id\" \"$button_name\")"
    if [ $button_class = "occupied" -o $active_class = "active" ]; then
      echo -n "$buffered"
      buffered=""
    fi
  done
}


box_attrs=':orientation "h" :class "workspaces" :space-evenly true :valign "center" :vexpand true'

eww -c ~/.config/eww update workspaces_dyn="(box $box_attrs $(gib_workspace_yuck 1))"
