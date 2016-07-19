command: "date +\"%a %d %b\""

refreshFrequency: 10000

render: (output) ->
  "#{output}"

style: """
  -webkit-font-smoothing: antialiased
  color: #D5C4A1
  font: 16px Osaka-Mono
  padding:0px 3px 3px 3px
  box-shadow: 0 4px 2px -2px #B16286;
  right: 60px
  top: 6px
"""
