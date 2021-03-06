' ============================================================================
' Dependencies:
' - quickSortArr1D()
' - ArrArrToArr2D()
' - PrintArr2D()
' ============================================================================

Sub Counter_by_Columns()
' Count frequency of unique values in selected columns.
'
    Dim L2 As Long
    Dim iRow As Long
    Dim iCol As Long
    Dim sheet_name As String
    Dim Arr2D()
    Dim urArr()
    Dim colArr()
    Dim valCountList()
    Dim valCountArrArrArr()
    
    With ActiveSheet
        urArr = .UsedRange.value
        sheet_name = .Name
    End With
    
    colArr = Selection.EntireColumn.Resize(UBound(urArr)).value
    
    ReDim valCountArrArrArr(1 To UBound(colArr, 2))
    
    For iCol = 1 To UBound(colArr, 2)
        ReDim valCountList(1)
        valCountList(0) = Array(colArr(1, iCol), vbNullString)
        valCountList(1) = Array("Value", "Count")
        
        For iRow = 2 To UBound(colArr)
            For L2 = 2 To UBound(valCountList)
                If CStr(colArr(iRow, iCol)) = valCountList(L2)(0) Then
                    valCountList(L2)(1) = valCountList(L2)(1) + 1
                    Exit For
                End If
            Next L2
            
            If L2 = UBound(valCountList) + 1 Then
                ReDim Preserve valCountList(0 To L2)
                valCountList(L2) = Array(CStr(colArr(iRow, iCol)), 1)
            End If
        Next iRow
        
        quickSortArr1D valCountList, LBound(valCountList) + 2, , 0
        valCountArrArrArr(iCol) = valCountList
    Next iCol
    
    Workbooks.Add
    Sheets(1).Name = sheet_name
    
    For iCol = 1 To UBound(colArr, 2)
        Arr2D = ArrArrToArr2D(valCountArrArrArr(iCol))
        PrintArr2D Arr2D, , (iCol - 1) * 3 + 1
        decorateCounts Arr2D, , (iCol - 1) * 3 + 1
    Next iCol
    
    Columns.AutoFit
    
    With ActiveWindow
        .SplitRow = 2
        .FreezePanes = True
    End With
End Sub

Function decorateCounts(Arr2D, Optional r1 = 1, Optional c1 = 1)
    Dim nRows As Long
    Dim nCols As Long
    Dim lightBlue As Long
    
    lightBlue = RGB(221, 235, 247)
    nRows = UBound(Arr2D) - LBound(Arr2D) + 1
    nCols = UBound(Arr2D, 2) - LBound(Arr2D, 2) + 1
    
    With Cells(r1, c1).Resize(2, 2)
        .Font.Bold = True
        .Interior.Color = lightBlue
        .BorderAround xlContinuous
    End With
    
    Cells(r1, c1).Resize(nRows, nCols).BorderAround xlContinuous
End Function
