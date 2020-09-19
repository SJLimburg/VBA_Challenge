Option Explicit

Sub VBAHomework()
'Set-up to loopthrough every worksheet in workbook
Dim wbk As Workbook
Dim wks As Worksheet
Set wbk = ThisWorkbook

    For Each wks In Worksheets
        wks.Activate
        Call StockReport
    Next wks
End Sub



Sub StockReport()

Dim Ticker As String
Dim NextTicker As String
Dim PrevTicker As String
Dim CurrentRow As Long
Dim TradeVol As Double
Dim YoYChange As Currency
Dim YoYPercentage As Double
Dim LastRow As Long
Dim ReportRow As Long
Dim YearOpenPrice As Currency
Dim YearClosePrice As Currency

Dim wbk As Workbook
Dim wks As Worksheet
Set wbk = ThisWorkbook

'Add headings and formats for output columns j-m in workbook
    Cells(1, 10).Value = "Ticker"
    Cells(1, 11).Value = "Year Change"
    Cells(1, 12).Value = "Percent Change"
    Cells(1, 13).Value = "Total Volume"
    Range("j1:M1").Font.Bold = True
    Range("j1:M1").Interior.ColorIndex = 15
    
    
    
'Create a Performance Measures table
    Cells(1, 16).Value = "Performance Measure"
    Cells(2, 16).Value = "Greatest % increase"
    Cells(3, 16).Value = "Greatest % decrease"
    Cells(4, 16).Value = "Greatest total volume"
    Cells(1, 17).Value = "Ticker"
    Cells(1, 18).Value = "Value"
    Range("p1:r1").Font.Bold = True
    Range("p1:r1").Interior.ColorIndex = 15
   

'Start the reporting loop at row two to avoid over-writing headers- this will be incremented for adding data to the report row
    ReportRow = 2
    
'Figure out the LastRow of populated data so you can limit run time of loop.
    LastRow = Cells(Rows.Count, 1).End(xlUp).Row
    
   
    For CurrentRow = 2 To LastRow
        
        'Use Ticker variables to compare the ticker symbols to start a new loop when the symbol changes
        'Also used to identify the Year Open Price - the first open price with a new ticker - This data is ordered by date
        
        Ticker = Cells(CurrentRow, 1).Value
        NextTicker = Cells(CurrentRow + 1, 1).Value
        PrevTicker = Cells(CurrentRow - 1, 1).Value
            
    
        If Ticker = NextTicker Then
        
                'Conditional Check for First Entry
                If Ticker <> PrevTicker Then
                
                    YearOpenPrice = Cells(CurrentRow, 3).Value
                    'Debug.Print ("YearOpenPrice is " & YearOpenPrice)
                    
                End If
            
        'Add daily trade volume
        TradeVol = TradeVol + Cells(CurrentRow, 7).Value
          
        'When the final row for the current ticker is reached - do the calculations for the year
        
        Else:
        
        YearClosePrice = Cells(CurrentRow, 6).Value
        
        'Now we have the YearClose as well as open so we can begin our calculations
        
        YoYChange = YearClosePrice - YearOpenPrice
        
        'To calculate Year over Year Percentage and we cannot divide by zero - since it is undefined
        'The following cares for that by setting the percentage change to zero. A visual review of the data indicated all zeroes
        
            If YearOpenPrice = 0 Then
                Dim ZeroOpen As Double
                ZeroOpen = 0
                Cells(ReportRow, 12).Value = ZeroOpen
            Else
              YoYPercentage = YoYChange / YearOpenPrice
              Cells(ReportRow, 12).Value = FormatPercent(YoYPercentage)
            
            End If
         
        'Add the final day trade volume to get the total trade volume for the year
        
        TradeVol = TradeVol + Cells(CurrentRow, 7).Value
        
        'Record values into the Stock Report
        
        Cells(ReportRow, 13).Value = TradeVol
        Cells(ReportRow, 10).Value = Ticker
        Cells(ReportRow, 11).Value = YoYChange
        
        'Format year over year change to show gains (green) and losses (red)
            
            If YoYChange > 0 Then
            Cells(ReportRow, 11).Interior.ColorIndex = 43
            
            Else
            
            'I did not like the lack of readability of setting the color index to red - 3 So I used 'bad' style
            'If you want to change To the default red - uncomment the next line and comment out the Style line
            'Cells(ReportRow, 11).Interior.ColorIndex = 3
            
            Cells(ReportRow, 11).Style = "Bad"
                   
            
            End If
        
        
        'Increment row for reporting the data
        ReportRow = ReportRow + 1
    
        'Reset TradeVol to zero for next ticker
        TradeVol = 0
            
                  
        End If
        
           
    Next CurrentRow
    
    'Use the loop to record ticker and values for the challenge
    'ReportRow is the last row in the report at this point
    'Need to set up variables to hold the performance data and ticker
    
    Dim BestPctInc As Double
    Dim BestTicker As String
    
    Dim WorstPctInc As Double
    Dim WorstTicker As String
    
    Dim MostVolume As Double
    Dim MostVolTicker As String
    
    'Initialize Variables to the first set of values - The loop will compae each in turn to find Best;Worst;Most
    BestPctInc = Cells(2, 12).Value
    BestTicker = Cells(2, 10).Value
    WorstPctInc = Cells(2, 12).Value
    WorstTicker = Cells(2, 10).Value
    MostVolume = Cells(2, 13).Value
    MostVolTicker = Cells(2, 10).Value
    
    Dim CR As LongLong
    
    
    For CR = 3 To ReportRow
    
        If Cells(CR, 12).Value > BestPctInc Then
        BestPctInc = Cells(CR, 12).Value
        BestTicker = Cells(CR, 10).Value
        End If
        
        If Cells(CR, 12).Value < WorstPctInc Then
        WorstPctInc = Cells(CR, 12).Value
        WorstTicker = Cells(CR, 10).Value
        End If
        
        If Cells(CR, 13).Value > MostVolume Then
        MostVolume = Cells(CR, 13).Value
        MostVolTicker = Cells(CR, 10).Value
        End If
        
        
    Next CR
    
    'Record the values from the loop into the table
    Cells(2, 17).Value = BestTicker
    Cells(2, 18).Value = FormatPercent(BestPctInc)
    Cells(3, 17).Value = WorstTicker
    Cells(3, 18).Value = FormatPercent(WorstPctInc)
    
    Cells(4, 17).Value = MostVolTicker
    Cells(4, 18).Value = MostVolume
    
'AutoFit the columns to make them look better

Range("J:M").EntireColumn.AutoFit
Range("P:R").EntireColumn.AutoFit

End Sub