command: "date +\"%H:%M\""

refreshFrequency: 2000 # ms

render: (output) ->
  "#{output}"

style: """
  -webkit-font-smoothing: antialiased
  color: #D5C4A1
  font: 16px Osaka-Mono
  right: 10px
  top: 6px
  box-shadow: 0 4px 2px -2px #458588
  padding: 0px 5px 3px 5px
"""
