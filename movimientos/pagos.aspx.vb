Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports System.Data.SqlClient

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
            'Dim loc As String = ""
            Dim loc_id As String = "0"
            username = Membership.GetUser().UserName
            query = "SELECT location FROM users LEFT JOIN locations ON users.location = locations.id WHERE user_name = '" + username + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                loc_id = ds.Tables(0).Rows(0)("location").ToString()
                If loc_id = "0" Then
                    query = "SELECT DISTINCT clients.id, clients.name FROM clients "
                    query += "INNER JOIN sale_order ON clients.id = sale_order.customer "
                    query += "ORDER BY clients.name"
                Else
                    query = "SELECT DISTINCT clients.id, clients.name FROM clients "
                    query += "INNER JOIN sale_order ON clients.id = sale_order.customer "
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

            If loc_id <> "0" Then
                ddlCliente.SelectedValue = loc_id
            End If
        Else
        End If
    End Sub

    Protected Sub btnRegPago_Click(sender As Object, e As EventArgs) Handles btnRegPago.Click
        Dim idCte, idOrd, total, deuda, abono, restante As String
        idCte = hfClienteID.Value
        idOrd = hfOrden.Value
        total = hfTotal.Value
        deuda = hfAdeudo.Value
        abono = txtPago.Text

        restante = deuda - abono

        query = "INSERT INTO pagos (idOrden, idCliente, total, adeudo, pago, status, fechaPago) VALUES (" + idOrd + ", " + idCte + ", " + total + ", " + restante + ", " + abono + ", 1, getDate())"
        Dataconnect.runquery(query)


    End Sub

End Class