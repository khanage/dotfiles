command: "ifconfig | grep -c utun1"

refreshFrequency: 2000 # ms

render: (output) ->
  console.log(output)
  res = if (output > 0) then "<span class='vpn-connected'>📶 VPN</span>" else "<span class='vpn-disconnected'>🌐 VPN</span>"
  res

style: """
  -webkit-font-smoothing: antialiased
  font: 14px Osaka-Mono
  top: 6px
  right: 340px
  color: #D5C4A1
  span
    padding: 0px 10px 3px 0px
  span.vpn-disconnected
    box-shadow: 0 4px 2px -2px #FF0000
  span.vpn-connected
    box-shadow: 0 4px 2px -2px #00FF00
"""
