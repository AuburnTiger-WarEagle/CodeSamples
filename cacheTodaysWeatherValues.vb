Public Sub Main(ByVal param As String)
      
   '159 Precipitation -999 = Unknown 451 vpTodaysForecastPrecipitation
   '38 LowTemp 450 vbTodaysForecastLow
   '172 HighTemp 449 vpTodaysForecastHigh

   hs.WriteLog("Starting Weather Script","cacheTodaysWeatherValues")

   Dim deviceTodaysPrecipitation as Integer = 587
   Dim deviceTonightsPrecipitation as Integer = 593
   Dim deviceTodaysForecast as Integer = 153
   Dim deviceTonightsForecast as Integer = 281
   Dim deviceLocationLow as Integer = 190
   Dim deviceLocationHigh as Integer = 189

   Dim vdTodaysPrecipitation as Integer = 451
   Dim vdTonightsPrecipitation as Integer = 455
   Dim vdTodaysForecastLow as Integer = 463
   Dim vdTodaysForecastHigh as Integer = 449

   Dim results

   Dim todaysPrecipitation as Integer = hs.DeviceValue(deviceTodaysPrecipitation)
   hs.WriteLog(“Todays Precipitation Value: “, todaysPrecipitation)

   Dim tonightsPrecipitation as Integer = hs.DeviceValue(deviceTonightsPrecipitation)
   hs.WriteLog(“Tonights Precipitation Value: “, tonightsPrecipitation)

   Dim todaysForecastStr as String = hs.DeviceString(deviceTodaysForecast)
   hs.WriteLog(“Todays Forecast: “, todaysForecastStr)
   
   Dim tonightsForecastStr as String = hs.DeviceString(deviceTonightsForecast)
   hs.WriteLog(“Tonights Forecast: “, tonightsForecastStr)
   
   Dim todaysHigh as Integer = hs.DeviceValue(deviceLocationHigh)
   hs.WriteLog(“Todays High Temp Value: “, todaysHigh)

   Dim todaysLow as Integer = hs.DeviceValue(deviceLocationLow)
   hs.WriteLog(“Todays Low Temp Value: “, todaysLow)

   If todaysLow <> -999 Then
       results = SetDeviceByControlValue(vdTodaysForecastLow, todaysLow)
          hs.WriteLog(“Set todaysLow RC: “, results)
   End If

   If todaysHigh <> -999 Then
       results = SetDeviceByControlValue(vdTodaysForecastHigh, todaysHigh)
                 hs.WriteLog(“Set todaysHigh RC: “, results)
   End If

   If todaysPrecipitation <> -999 Then
       results = SetDeviceByControlValue(vdTodaysPrecipitation, todaysPrecipitation)
   Else
        Dim loc1 as Integer = InStr(todaysForecastStr,"Chance of precipitation is ")
        if loc1 > 0 Then
            Dim precipitationStr as String = Mid(todaysForecastStr, loc1) 
            hs.WriteLog("Precipitation Str Value 1 ", precipitationStr) 
            precipitationStr = Mid(precipitationStr, 28)
            hs.WriteLog("Precipitation Str Value 2 ", precipitationStr)
            loc1 = InStr(precipitationStr, ”%”)
            precipitationStr = Left(precipitationStr, loc1 - 1)
            hs.WriteLog("Precipitation Str Value 3 ", precipitationStr)
            todaysPrecipitation = precipitationStr
            results = SetDeviceByControlValue(vdTodaysPrecipitation, todaysPrecipitation)
            hs.WriteLog(“Parsed Precipitation “, todaysPrecipitation)
        End If
   End If

   If tonightsPrecipitation <> -999 Then
       results = SetDeviceByControlValue(vdTonightsPrecipitation, tonightsPrecipitation)
   Else
        Dim loc1 as Integer = InStr(todaysForecastStr,"Chance of precipitation is ")
        if loc1 > 0 Then
            Dim precipitationStr as String = Mid(todaysForecastStr, loc1) 
            hs.WriteLog("Precipitation Str Value 1 ", precipitationStr) 
            precipitationStr = Mid(precipitationStr, 28)
            hs.WriteLog("Precipitation Str Value 2 ", precipitationStr)
            loc1 = InStr(precipitationStr, ”%”)
            precipitationStr = Left(precipitationStr, loc1 - 1)
            hs.WriteLog("Precipitation Str Value 3 ", precipitationStr)
            tonightsPrecipitation = precipitationStr
            Dim results1 = SetDeviceByControlValue(vdTonightsPrecipitation, tonightsPrecipitation)
            hs.WriteLog("Parsed Precipitation ", tonightsPrecipitation)
        End If
   End If

End Sub

Function SetDeviceByControlValue(ByVal intDevRef As Integer, ByVal ctlValue As Integer) As CAPIControlResponse
    ' Sets this device (refID) by Control Value [CAPI: ControlValue] - e.g. 0 = off, 1 = cool, 2 = Cool... 
    SetDeviceByControlValue = CAPIControlResponse.Indeterminate
    For Each objCAPIControl As CAPIControl In hs.CAPIGetControl(intDevRef)
        'hs.WriteLog("Control Value: ", LCase(objCAPIControl.ControlValue))
        If LCase(objCAPIControl.ControlValue) = ctlValue Then
            SetDeviceByControlValue = hs.CAPIControlHandler(objCAPIControl) ' SET
            Exit For
        End If
    Next
End Function