Public Sub Main(ByVal param As String)

    hs.WriteLog("Starting ", "decUpstairsCoolSetPointv2")

    Dim CoolSetPoint As Integer
    Dim newCoolSetPoint As Integer
    Dim deviceID As Integer
    Dim statusDeviceID As Integer

    deviceID = 686
    statusDeviceID = 667

    CoolSetPoint = hs.DeviceValue(deviceID)

    hs.WriteLog("Current Cool setpoint ", CoolSetPoint)

    newCoolSetPoint = CoolSetPoint - 1

    hs.WriteLog("Device ID", deviceID)
    hs.WriteLog("New CoolSetPoint", newCoolSetPoint)

    Dim results = SetDeviceByControlValue(deviceID, newCoolSetPoint)

    hs.WriteLog("CAPI results ", results)

    Dim statusString As String


    newCoolSetPoint = hs.DeviceValue(deviceID)
    If newCoolSetPoint = CoolSetPoint Then
        statusString = "Cool SetPoint did not change"
    Else
        statusString = "New Cool SetPoint: " & newCoolSetPoint
    End If

    hs.SetDeviceString(statusDeviceID, statusString, True)

    hs.WriteLog("Status", statusString)

End Sub

Function SetDeviceByControlValue(ByVal intDevRef As Integer, ByVal ctlValue As Integer) As CAPIControlResponse
    ' Sets this device (refID) by Control Value [CAPI: ControlValue] - e.g. 0 = off, 1 = Cool, 2 = Cool... 
    SetDeviceByControlValue = CAPIControlResponse.Indeterminate
    For Each objCAPIControl As CAPIControl In hs.CAPIGetControl(intDevRef)
        'hs.WriteLog("Control Value: ", LCase(objCAPIControl.ControlValue))
        If objCAPIControl.ControlValue = ctlValue Then
            SetDeviceByControlValue = hs.CAPIControlHandler(objCAPIControl)
            Exit For
        End If
    Next
End Function