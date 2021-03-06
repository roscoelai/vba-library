' ============================================================================
' Dependencies:
' - quickSortArr1D()
' - ArrArrToArr2D()
' - PrintArr2D()
' ============================================================================

Sub Find_Similar_Rows()
' Sort table in order of ascending dissimilarity to a reference row.
' You have to select the range of columns for comparison.
'
    Const pre_cols As Long = 1 ' Number of new columns inserted to the left.
    
    Dim c1 As Long
    Dim cN As Long
    Dim rRow As Long
    Dim iRow As Long
    Dim iCol As Long
    Dim sheet_name As String
    Dim sorted_scores()
    Dim Arr2D()
    Dim urArr()
    Dim outArrArr()
    Dim outRow()
    
    c1 = Selection.Column
    cN = c1 + UBound(Selection.value, 2) - 1
    rRow = Selection.row
    
    With ActiveSheet
        urArr = .UsedRange.value
        sheet_name = .Name
    End With
    
    ReDim outArrArr(1 To UBound(urArr))
    
    sorted_scores = all_vs_one_row(urArr, rRow, c1, cN)
    
    For iRow = 1 To UBound(urArr)
        ReDim outRow(1 To UBound(urArr, 2) + pre_cols)
        
        outRow(1) = sorted_scores(iRow)(1)
        For iCol = 1 To UBound(urArr, 2)
            outRow(iCol + pre_cols) = urArr(sorted_scores(iRow)(0), iCol)
        Next iCol
        
        outArrArr(iRow) = outRow
    Next iRow
    
    Workbooks.Add
    Sheets(1).Name = sheet_name
    
    Arr2D = ArrArrToArr2D(outArrArr)
    PrintArr2D Arr2D
    
    highlight_similarities Arr2D, c1 + pre_cols, cN + pre_cols
    
    With ActiveWindow
        .SplitRow = 2
        .SplitColumn = 1 + pre_cols
        .FreezePanes = True
    End With
End Sub

Function all_vs_one_row(urArr, rRow, c1, cN) As Variant()
' Produce a list that gives a difference score for each row compared to a reference row.
'
    Dim not_blank As Boolean
    Dim iRow As Long
    Dim iCol As Long
    Dim diffCount As Long
    Dim diffCounts()
    
    ReDim diffCounts(1 To UBound(urArr))
    
    diffCounts(1) = Array(1, "differences")
    
    For iRow = 2 To UBound(urArr)
        not_blank = False
        For iCol = c1 To cN
            If LenB(urArr(iRow, iCol)) Then
                not_blank = True
                Exit For
            End If
        Next iCol
        
        If not_blank Then
            diffCount = 0
            For iCol = c1 To cN
                If urArr(iRow, iCol) <> urArr(rRow, iCol) Then
                    diffCount = diffCount + 1
                End If
            Next iCol
            diffCounts(iRow) = Array(iRow, diffCount)
        Else
            ' Give the maximum difference score for blank rows.
            diffCounts(iRow) = Array(iRow, cN - c1 + 1)
        End If
    Next iRow
    
    quickSortArr1D diffCounts, 2, , 1
    
    all_vs_one_row = diffCounts
End Function

Function highlight_similarities(Arr2D, c1, cN)
    Dim not_blank As Boolean
    Dim iRow As Long
    Dim iCol As Long
    Dim red As Long
    Dim green As Long
    Dim light_red As Long
    Dim light_green As Long
    
    red = RGB(255, 0, 0)
    green = RGB(0, 138, 62)
    light_red = RGB(255, 204, 204)
    light_green = RGB(204, 255, 204)
    
    For iRow = 3 To UBound(Arr2D)
        not_blank = False
        For iCol = c1 To cN
            If LenB(Arr2D(iRow, iCol)) Then
                not_blank = True
                Exit For
            End If
        Next iCol
        
        If not_blank Then
            For iCol = c1 To cN
                If Arr2D(iRow, iCol) = Arr2D(2, iCol) Then
                    With Cells(iRow, iCol)
                        .Font.Color = green
                        .Interior.Color = light_green
                    End With
                Else
                    With Cells(iRow, iCol)
                        .Font.Color = red
                        .Interior.Color = light_red
                    End With
                End If
            Next iCol
        End If
    Next iRow
End Function
