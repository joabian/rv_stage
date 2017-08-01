Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports System.Data.SqlClient
Imports System.Web.UI

Partial Class movimientos_pagos
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public logevent As String
    Public username As String

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim username As String
            Dim loc_id As String = "0"
            username = Membership.GetUser().UserName
            Try
                query = "SELECT location FROM users LEFT JOIN locations ON users.location = locations.id WHERE user_name = '" + username + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    loc_id = ds.Tables(0).Rows(0)("location").ToString()
                    If loc_id = "0" Then
                        query = "SELECT DISTINCT clients.id, clients.name FROM clients "
                        query += "INNER JOIN sale_order ON clients.id = sale_order.customer AND sale_order.status <> 7 AND sale_order.estatus_pago <> 3"
                        query += "ORDER BY clients.name"
                    Else
                        query = "SELECT DISTINCT clients.id, clients.name FROM clients "
                        query += "INNER JOIN sale_order ON clients.id = sale_order.customer AND sale_order.status <> 7 AND sale_order.estatus_pago <> 3"
                        query += "WHERE clients.location = " + loc_id + " "
                        query += "ORDER BY clients.name"
                    End If
                End If

                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    ddlCliente.DataSource = ds.Tables(0)
                    ddlCliente.DataValueField = "id"
                    ddlCliente.DataTextField = "name"
                    ddlCliente.DataBind()
                Else
                    ddlCliente.DataSource = Nothing
                    ddlCliente.DataBind()
                End If
            Catch ex As Exception
                'MsgBox("Ha ocurrido un error: " + ex.Message)
            End Try

            If loc_id <> "0" Then
                ddlCliente.SelectedValue = loc_id
            End If
        Else
        End If
    End Sub

End Class