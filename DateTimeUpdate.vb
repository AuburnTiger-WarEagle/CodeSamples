Sub Main(parm As String)
   Dim thisDate1 As Date = now
   hs.SetDeviceString(138, now.ToShortTimeString, True)
   'hs.WriteLog("Set 138 to ",now.ToShortTimeString)
   hs.SetDeviceString(140, thisDate1.ToString("dddd MMMM dd, yyyy"), True)
   'hs.WriteLog("Set 140 to ", thisDate1.ToString("dddd MMMM dd, yyyy"))
End Sub