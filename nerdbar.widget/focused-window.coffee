command: "echo $(/usr/local/bin/kwmc query focused) | awk '{for (i=2; i<=NF; i++) print $i}'"

refreshFrequency: 1000 # ms

render: (output) ->
  "#{output}"

style: """
  -webkit-font-smoothing: antialiased
  color: #D6E7EE
  font: 12px "Meslo LG S for Powerline"
  height: 16px
  left: 10px
  overflow: hidden
  text-overflow: ellipsis
  top: 4px
  width: 1000px
"""
