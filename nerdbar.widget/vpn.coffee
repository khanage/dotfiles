command: "ifconfig | grep -c utun1"

refreshFrequency: 2000 # ms

render: (output) ->
  console.log(output)
  res = if (output > 0) then "<div class='vpn-connected'>vpn<span class='vpn-icon'>📶</span></div>" else "<div class='vpn-disconnected'>vpn <span class='vpn-icon'>🌐</span></div>"
  res

style: """
  -webkit-font-smoothing: antialiased
  font: 16px Osaka-Mono
  top: 5px
  right: 340px
  color: #D5C4A1
  width: 70px
  span.vpn-icon
    float: right
  div.vpn-disconnected
    padding: 0px 4px 4px 4px
    box-shadow: 0 4px 2px -2px #FF0000
  div.vpn-connected
    padding: 0px 4px 4px 4px
    box-shadow: 0 4px 2px -2px #00FF00
"""
