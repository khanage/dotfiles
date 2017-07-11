command: "pmset -g batt | tr -d '\n' | cut -f1 -d';' | awk '{print $4\":\"$8}'"

refreshFrequency: '10s'

render: (output) ->
  [power,percentage,...] = output.split ':'

  icon = if (power == "'AC") then "🔌" else "🔋"

  "<i>#{icon}</i><span>#{percentage}<span>"

style: """
  -webkit-font-smoothing: antialiased
  span { font: 16px Helvetica }
  i    { font: 14px Helvetica; padding-right: 10px }
  right: 120px
  padding-bottom: 8px
  bottom: 0px
  color: #D5C4A1
"""
