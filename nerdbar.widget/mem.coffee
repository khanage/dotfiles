command: "ESC=`printf \"\e\"`; ps -A -o %mem | awk '{s+=$1} END {print \"\" s}'"

refreshFrequency: 30000 # ms

render: (output) ->
  "mem <span>#{output}</span>"

style: """
  -webkit-font-smoothing: antialiased
  color: #D5C4A1
  font: 16px Osaka-Mono
  right: 200px
  top: 6px
  box-shadow: 0 4px 2px -2px #9C9486;
  padding: 0px 3px 3px 3px
  width: 64px
  span
    float: right
"""
