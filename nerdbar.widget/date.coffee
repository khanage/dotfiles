command: "~/.local/bin/nice-date"

refreshFrequency: '10s'

render: (output) ->
  "#{output}"

style: """
  -webkit-font-smoothing: antialiased
  font: 16px Helvetica
  bottom: 0px
  color: #D5C4A1
  padding:4px 3px 3px 3px
  width: 300px
  margin:0 auto
"""
