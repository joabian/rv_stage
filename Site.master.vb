Imports System.Data
Imports System.Management
Imports System.Net.NetworkInformation
Imports System.Web.UI.WebControls
Imports System.Security.Principal
'Imports Microsoft.VisualBasic.ApplicationServices

Partial Class Site
    Inherits System.Web.UI.MasterPage
    Protected ipAddress As String
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim username As String
        'ipAddress = My.Computer.Name
        'Dim sysID As String = String.Empty
        'Dim manClass As New ManagementClass("Win32_Processor")
        'Dim mObjCol As ManagementObjectCollection = manClass.GetInstances
        'Dim m As ManagementObject

        'For Each m In mObjCol
        '    If sysID = "" Then
        '        sysID = m.Properties("ProcessorId").Value
        '        Exit For
        '    End If
        'Next


        'ipAddress = ""

        'ipAddress = System.Web.HttpContext.Current.Request.UserHostAddress
        'ipAddress = System.Web.HttpContext.Current.Request.UserHostName

        'query = "select * from ips where ip_num = '" + ipAddress.ToString() + "' and active = 1"
        'ds = Dataconnect.GetAll(query)
        'If ds.Tables(0).Rows.Count <= 0 Then
        '    Response.Redirect("access_denied.aspx")
        'End If
        'If ipAddress <> "187.158.174.84" And ipAddress <> "189.220.91.230" And ipAddress <> "187.158.210.135" And ipAddress <> "187.131.124.155" And ipAddress <> "216.115.160.40" And ipAddress <> "216.115.160.41" And ipAddress <> "187.158.224.117" Then
        'Response.Redirect("access_denied.aspx")
        ''End If


        

    End Sub
End Class

