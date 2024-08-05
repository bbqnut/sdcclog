; simple dcc log by bbqnut : bbqnut@github
; version 0.1 08.05.2024
on *:load:set %sdccl 0
on *:unload:unset %sdccl
on *:start:if (%sdccl == 1) opensdccl
on *:FILESENT:*.*:if (%sdccl == 1) simdcclog DCC Send Complete to $+(,$nick,,$chr(32),,$nopath($filename),) $+($bytes($send(-1).cps,k3).suf,$chr(47),Second)
on *:FILERCVD:*.*:if (%sdccl == 1) simdcclog DCC Get Complete from $+(,$nick,,$chr(32),,$nopath($filename),) $+($bytes($get(-1).cps,k3).suf,$chr(47),Second)
on *:SENDFAIL:*.*:if (%sdccl == 1) simdcclog DCC Send Incomplete to $+(,$nick,,$chr(32),,$nopath($filename),) $+($bytes($send(-1).cps,k3).suf,$chr(47),Second)
on *:GETFAIL:*.*:if (%sdccl == 1) simdcclog DCC Get Incomplete from $+(,$nick,,$chr(32),,$nopath($filename),) $+($bytes($get(-1).cps,k3).suf,$chr(47),Second)
alias sdccl return $iif(%sdccl,%sdccl,0)
alias opensdccl {
  set %sdccl 1
  var %a0 = $len($timestamp)
  var %a1 = $calc(%a0 + 1)
  var %a2 = $calc(%a1 + 8)
  window -g0k0nwzl -t $+ %a1 $+ , $+ %a2 @SDCCLog $scriptdirsdcclog.ico
}
alias closesdccl { set %sdccl 0 | window -c @SDCCLog }
alias simdcclog {
  if (!$window(@SDCCLog)) {
    opensdccl
  }
  aline $iif((incomplete isin $1-),$+($chr(45),c5)) @SDCCLog $+($chr(91),$date,$chr(93),$timestamp,$chr(32),$network,$chr(32),$iif(!$1,Null,$1-))
  window -b @SDCCLog
}
menu @SDCCLog {
  $active [Click to Clear]:clear $active
  -
  Copy Line(s) to Clipboard: {
    if (!$sline($active,0)) halt
    var %c = 1
    clipboard
    while (%c <= $sline($active,0)) {
      if ($sline($active,0) == 1) {
        clipboard $strip($sline($active,1))
        halt
      }
      clipboard -an $strip($sline($active,%c))
      inc %c
    }
  }
  -
  Close:closesdccl
}
menu channel,status,toolbar {
  Simple DCC Log
  .$iif($sdccl == 0,Disabled [Click to Enable]) :opensdccl
  .$iif($sdccl == 1,$style(1) Enabled [Click to Disable]) :closesdccl
}
