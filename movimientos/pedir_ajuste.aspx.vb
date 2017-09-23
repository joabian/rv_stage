Imports System.Data

Partial Class movimientos_pedir_ajuste
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public username As String
    Public sendemail As New email_mng

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        username = Membership.GetUser().UserName
        If Not IsPostBack Then
            populate_ddl_locations()
        End If
    End Sub

    Public Sub populate_ddl_locations()
        Dim location_st, location_alias As String

        query = "SELECT location, alias FROM users LEFT JOIN locations ON users.location = locations.id WHERE user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st = ds.Tables(0).Rows(0)("location").ToString()
            location_alias = ds.Tables(0).Rows(0)("alias").ToString()
            If location_st = "0" Then
                query = "SELECT id, alias FROM locations"
            Else
                query = "SELECT id, alias FROM locations WHERE id = " + location_st
            End If
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                location.DataSource = ds.Tables(0)
                location.DataValueField = "id"
                location.DataTextField = "alias"
                location.DataBind()
                If location_st <> "0" Then
                    location.SelectedValue = location_st
                End If
            Else
                location.DataSource = Nothing
                location.DataBind()
            End If
        End If
    End Sub

End Class