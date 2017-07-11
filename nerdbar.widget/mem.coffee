command: "ESC=`printf \"\e\"`; ps -A -o %mem | awk '{s+=$1} END {print \"\" s}'"

refreshFrequency: '3s'

render: (output) ->
  "<span>#{output}%</span>
   <img src='androidicons-1.0/assets/purple_light/hdpi/ic_action_ticket.png' 
    width=25 
    height=25 />"

style: """
  -webkit-font-smoothing: antialiased
  font: 16px Helvetica
  color: #D5C4A1
  bottom: 0px
  right: 225px
  width: 90px
  span
    padding: 4px 3px 3px 3px
    float: right
"""
