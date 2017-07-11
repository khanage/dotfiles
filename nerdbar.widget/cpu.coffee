command: "ESC=`printf \"\e\"`; ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"

refreshFrequency: '2s'

render: (output) ->
  "<span>#{output}%</span><img src='androidicons-1.0/assets/green_dark/hdpi/ic_action_gear.png' width=25 height=25 />"

style: """
  -webkit-font-smoothing: antialiased
  font: 16px Helvetica
  color: #D5C4A1
  width: 85px
  bottom: 0px
  right: 365px
  span
    padding: 4px 2px 3px 2px
    float:right;
"""
