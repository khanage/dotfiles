command: "date +\"%H:%M\""

refreshFrequency: '2s'

render: (output) ->
  "<span>#{output}<span>"

style: """
  -webkit-font-smoothing: antialiased
  font: 16px Helvetica
  color: #D5C4A1
  right: 0px
  width: 50px
  bottom: 0px
  padding: 4px 5px 6px 5px
  span
    float: right
    padding-right: 1px
"""
