command: "ESC=`printf \"\e\"`; ps -A -o %cpu | awk '{s+=$1} END {printf(\"%.2f\",s/8);}'"

refreshFrequency: 2000 # ms

render: (output) ->
  "cpu <span>#{output}</span>"

style: """
  -webkit-font-smoothing: antialiased
  color: #D5C4A1
  width:70px;
  font: 16px Osaka-Mono
  right: 268px
  top: 6px
  padding: 0px 2px 3px 2px
  box-shadow: 0 4px 2px -2px #7AAB7E
  span
    float:right;
"""
