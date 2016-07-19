command: "pmset -g batt | tr -d '\n' | cut -f1 -d';' | awk '{print $4\":\"$7}'"

refreshFrequency: 2000 # ms

render: (output) ->
  [power,percentage,...] = output.split ':'

  icon = if (power == "'AC") then "🔌" else "🔋"

  "<i>#{icon}</i><span>#{percentage}<span>"

style: """
  -webkit-font-smoothing: antialiased
  font: 14px Osaka-Mono
  top: 4px
  box-shadow: 0 4px 2px -2px #FABD2F
  padding: 0px 3px 2px 3px
  right: 145px
  color: #D5C4A1
"""
