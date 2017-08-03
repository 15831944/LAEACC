<%@ WebService Language="VB" Class="WebService" %>

Imports System
Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports LAEACC

<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<System.Web.Script.Services.ScriptService()> _
Public Class WebService
    Inherits System.Web.Services.WebService

    '--��Ʈw�@���ܼ�--
    Dim WSDNS As String = ConfigurationManager.ConnectionStrings("DNS_ACC").ConnectionString
    
#Region "���O�Ҳ�"
    '��Ʈw
    Dim ADO As New ADO
    '�t��
    Dim Controller As New Controller
    Dim Models As New Models
#End Region
#Region "��Ʈw�@���ܼ�"
    Dim WSobjCon As SqlConnection
    Dim WSobjCmd As SqlCommand
    Dim WSobjDR As SqlDataReader
    Dim WSstrSQL As String
#End Region
    
    
    '++ �d�߱M��[��ƥ��t�S��N��] ++
    
    '** �d�ߺK�n **
    <WebMethod(EnableSession:=True)> _
    Public Function GetCompletionListRemark(ByVal prefixText As String, ByVal count As Integer) As String()
        If count = 0 Then
            count = 10
        End If
        
        '���b
        If prefixText.Equals("%#)*)*)*DDD") Then
            Return New String(0) {}
        End If
                
        Dim i As Integer = 0
        Dim items As List(Of String) = New List(Of String)(count)
        
        
        '�}�Ҭd��
        WSobjCon = New SqlConnection(WSDNS)
        WSobjCon.Open()
        
        If Trim(prefixText) = "" Then
            WSstrSQL = "SELECT psstr  FROM psname where unit='" & HttpContext.Current.Session("UserUnit") & "' and  seq<>9999 "
        Else
            WSstrSQL = "SELECT psstr  FROM psname where unit='" & HttpContext.Current.Session("UserUnit") & "' and  seq<>9999 and psstr LIKE '%" & prefixText & "%'"
        End If

        WSobjCmd = New SqlCommand(WSstrSQL, WSobjCon)
        WSobjDR = WSobjCmd.ExecuteReader

        Do While WSobjDR.Read
            items.Add(Trim(WSobjDR("psstr")))
            System.Math.Min(System.Threading.Interlocked.Increment(i), i - 1)
        Loop

        WSobjCon.Close()
        
        
        Return items.ToArray
    End Function
    
    '** �d�ߥI�ڤH **
    <WebMethod(EnableSession:=True)> _
    Public Function GetCompletionListSubject(ByVal prefixText As String, ByVal count As Integer) As String()
        If count = 0 Then
            count = 10
        End If
        
        '���b
        If prefixText.Equals("%#)*)*)*DDD") Then
            Return New String(0) {}
        End If
                
        Dim i As Integer = 0
        Dim items As List(Of String) = New List(Of String)(count)
        
        
        '�}�Ҭd��
        WSobjCon = New SqlConnection(WSDNS)
        WSobjCon.Open()
        If Trim(prefixText) = "" Then
            WSstrSQL = "SELECT psstr  FROM psname where unit='" & HttpContext.Current.Session("UserUnit") & "' and  seq=9999 "
        Else
            WSstrSQL = "SELECT psstr  FROM psname where unit='" & HttpContext.Current.Session("UserUnit") & "' and  seq=9999 and psstr LIKE '" & prefixText & "%'"
        End If
        
        

        WSobjCmd = New SqlCommand(WSstrSQL, WSobjCon)
        WSobjDR = WSobjCmd.ExecuteReader

        Do While WSobjDR.Read
            items.Add(Trim(WSobjDR("psstr").ToString))
            System.Math.Min(System.Threading.Interlocked.Increment(i), i - 1)
        Loop

        WSobjCon.Close()
        
        
        Return items.ToArray
    End Function
    
    '** �d�߶ǲ��|�p��� **
    <WebMethod(EnableSession:=True)> _
    Public Function GetAC010Accno(ByVal prefixText As String, ByVal count As Integer) As String()
        If count = 0 Then
            count = 10
        End If
        
        '���b
        If prefixText.Equals("%#)*)*)*DDD") Then
            Return New String(0) {}
        End If
        
        prefixText = prefixText.Replace("-", "")
        prefixText = prefixText.Replace("_", " ")
                
        Dim i As Integer = 0
        Dim items As List(Of String) = New List(Of String)(count)
        
        
        '�}�Ҭd��
        WSobjCon = New SqlConnection(WSDNS)
        WSobjCon.Open()
        
       
        'WSstrSQL = "SELECT psstr  FROM psname where unit='" & HttpContext.Current.Session("UserUnit") & "' and  seq<>9999 and psstr LIKE '%" & prefixText & "%'"
        If Trim(prefixText) = "" Then
            WSstrSQL = "SELECT top 10 rtrim(accno) as accno, rtrim(left(accno+space(17),17)+accname) as accname FROM accname where belong<>'B' and outyear=0  order by accno"
        Else
            WSstrSQL = "SELECT top 10 rtrim(accno) as accno, rtrim(left(accno+space(17),17)+accname) as accname FROM accname where belong<>'B' and outyear=0 and left(accno+space(17),17)+accname LIKE '" & Trim(prefixText) & "%' order by accno"
        End If
        

        WSobjCmd = New SqlCommand(WSstrSQL, WSobjCon)
        WSobjDR = WSobjCmd.ExecuteReader

        Do While WSobjDR.Read
            items.Add(Trim(WSobjDR("accname").ToString))
            System.Math.Min(System.Threading.Interlocked.Increment(i), i - 1)
        Loop

        WSobjCon.Close()
        
        
        Return items.ToArray
    End Function
    
    '** �d�߶ǲ��K�n **
    <WebMethod(EnableSession:=True)> _
    Public Function GetAC010Remark(ByVal prefixText As String, ByVal count As Integer) As String()
        If count = 0 Then
            count = 10
        End If
        
        '���b
        If prefixText.Equals("%#)*)*)*DDD") Then
            Return New String(0) {}
        End If
                
        Dim i As Integer = 0
        Dim items As List(Of String) = New List(Of String)(count)
        
        
        '�}�Ҭd��
        WSobjCon = New SqlConnection(WSDNS)
        WSobjCon.Open()
        
       
        'WSstrSQL = "SELECT psstr  FROM psname where unit='" & HttpContext.Current.Session("UserUnit") & "' and  seq<>9999 and psstr LIKE '%" & prefixText & "%'"
        If Trim(prefixText) = "" Then
            WSstrSQL = "SELECT psstr  FROM psname where left(unit,3)='050' order by psstr"
        Else
            WSstrSQL = "SELECT psstr  FROM psname where left(unit,3)='050' and psstr LIKE '%" & prefixText & "%' order by psstr"
        End If
        

        WSobjCmd = New SqlCommand(WSstrSQL, WSobjCon)
        WSobjDR = WSobjCmd.ExecuteReader

        Do While WSobjDR.Read
            items.Add(Trim(WSobjDR("psstr")))
            System.Math.Min(System.Threading.Interlocked.Increment(i), i - 1)
        Loop

        WSobjCon.Close()
        
        
        Return items.ToArray
    End Function
    
    '** �d�ߥX�ǺK�n **
    <WebMethod(EnableSession:=True)> _
    Public Function GetPayRemark(ByVal prefixText As String, ByVal count As Integer) As String()
        If count = 0 Then
            count = 10
        End If
        
        '���b
        If prefixText.Equals("%#)*)*)*DDD") Then
            Return New String(0) {}
        End If
                
        Dim i As Integer = 0
        Dim items As List(Of String) = New List(Of String)(count)
        
        
        '�}�Ҭd��
        WSobjCon = New SqlConnection(WSDNS)
        WSobjCon.Open()
        
        If Trim(prefixText) = "" Then
            WSstrSQL = "SELECT DISTINCT TOP 20 psstr FROM psname where unit='0403' order by psstr DESC "
        Else
            WSstrSQL = "SELECT DISTINCT TOP 20 psstr FROM psname where unit='0403' and psstr LIKE '%" & prefixText & "%' order by psstr DESC"
        End If
                      '
        WSobjCmd = New SqlCommand(WSstrSQL, WSobjCon)
        WSobjDR = WSobjCmd.ExecuteReader

        Do While WSobjDR.Read
            items.Add(Trim(WSobjDR("psstr")))
            System.Math.Min(System.Threading.Interlocked.Increment(i), i - 1)
        Loop

        WSobjCon.Close()
        
        
        Return items.ToArray
    End Function
  
    
    '** �D�p�t��Api�걵�{�� **
    ''' <summary>
    ''' ��D�p�t�Τ��A�������ͤ@��������
    ''' </summary>
    ''' <param name="NowDate">����(����)���</param>
    ''' <param name="AccNo">�|�p��إN��(���ʬ��)</param>
    ''' <param name="ReMark">���ʨƥ�</param>
    ''' <param name="Amt">����(����)���B</param>
    ''' <param name="Subject">���ڤH(�i�ť�)</param>
    ''' <returns>�x�s���A(True�G���\ False�G����)</returns>
    <WebMethod()> _
    Public Function GoBGF020(ByVal NowDate As String, ByVal AccNo As String, _
                     ByVal ReMark As String, ByVal Amt As String, ByVal Subject As String) As String
        Dim blnCheck As Boolean = False
        Dim strKind, strDC As String
        
        '���o���ʽs��
        Dim intBgNo As String = Controller.RequireNO(WSDNS, Mid(NowDate, 1, 3), "B") '�ثe�s����
        Dim strBgNo As String = Format(CInt(Mid(NowDate, 1, 3)), "000") + Format(CInt(intBgNo), "00000") '���s����
        
        
        '���b�ˬd
        If NowDate = "" Then Return "" : Exit Function
        If AccNo = "" Then Return "" : Exit Function
        If ReMark = "" Then Return "" : Exit Function
        If Amt = "" Or Amt = "0" Then Return "" : Exit Function
        
        
        '�P�_�ǲ����A
        If Mid(AccNo, 1, 1) = "4" Then
            If CDbl(Amt) > 0 Then   '���J���  ���ƪ�ܦ��J�ǲ�, �U����B
                strKind = "1" : strDC = "2"
            Else
                strKind = "2" : strDC = "1"
            End If
        Else
            If CDbl(Amt) > 0 Then  '��X���  ���ƪ�ܤ�X�ǲ�, �ɤ���B
                strKind = "2" : strDC = "1"
            Else
                strKind = "1" : strDC = "2"
            End If
        End If
        
        
        '��ƳB�z(�s�W�@����BGF020 & UPDATE BGF010->TOTPER)
        ADO.GenInsSql("BGNO", strBgNo, "T")
        ADO.GenInsSql("ACCYEAR", Mid(NowDate, 1, 3), "N")
        ADO.GenInsSql("ACCNO", AccNo, "T")
        ADO.GenInsSql("KIND", strKind, "T")
        ADO.GenInsSql("DC", strDC, "T")
        ADO.GenInsSql("DATE1", Models.strStrToDate(NowDate), "D")
        ADO.GenInsSql("REMARK", ReMark, "U")
        ADO.GenInsSql("AMT1", Amt, "N")
        ADO.GenInsSql("USEABLEAMT", Amt, "N")
        ADO.GenInsSql("SUBJECT", Subject, "U")
        ADO.GenInsSql("CLOSEMARK", " ", "T")
        
        WSstrSQL = "INSERT INTO BGF020 " & ADO.GenInsFunc
        blnCheck = ADO.dbExecute(WSDNS, WSstrSQL)
        If blnCheck = False Then Return "" : Exit Function '�s�W���ѶǦ^
        
        
        'UPDATE BGF010->TOTPER+AMT 
        WSstrSQL = "UPDATE BGF010 SET"
        WSstrSQL &= " TOTPER = TOTPER + " & Models.ValComa(Amt)
        WSstrSQL &= " WHERE ACCYEAR = '" & Mid(NowDate, 1, 3) & "'"
        WSstrSQL &= " AND ACCNO = '" & AccNo & "'"
        
        blnCheck = ADO.dbExecute(WSDNS, WSstrSQL)
        If blnCheck = False Then Return "" : Exit Function '�s�W���ѶǦ^
        
        
        Return strBgNo
    End Function
End Class
