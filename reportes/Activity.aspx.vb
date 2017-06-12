Imports System.Data
Partial Class reportes_Activity
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populate_sucursal()
        End If
        lblMsg.Text = ""
        query = "SELECT user_name AS [Usuario], event AS [Evento], date AS [Fecha] FROM logs WHERE date >= (getdate() - 15) ORDER BY date desc"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            GridView1.DataSource = ds.Tables(0)
            GridView1.DataBind()
        Else
            GridView1.DataSource = Nothing
            GridView1.DataBind()
        End If
    End Sub

    Public Sub populate_sucursal() 'Llena el dropdownlist de las sucursales
        query = "SELECT * FROM locations"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ddlSucursal.DataSource = ds.Tables(0)
            ddlSucursal.DataValueField = "alias"
            ddlSucursal.DataTextField = "alias"
            ddlSucursal.DataBind()
        End If
    End Sub

    Protected Sub btnBuscarRec_Click(sender As Object, e As EventArgs) Handles btnBuscarRec.Click
        Dim cantcode As Integer = txtCodigo.Text.LongCount 'cuenta la cantidad de caracteres que trae el código
        Dim cantsucursal As Integer = ddlSucursal.Text.LongCount 'cuenta la cantidad de caracteres que trae la sucursal
        Dim from_d As String = Request.Form("from_date") 'convierte a string la fecha de inicio
        Dim to_d As String = Request.Form("to_date") 'convierte a string la fecha final

        If cantcode > 0 And cantsucursal > 1 Then 'entra aquí si código y sucursal traen caracteres
            Dim sucursal As String = ddlSucursal.SelectedValue.ToString()
            Dim codigo As String = Replace(txtCodigo.Text & "'", "'", "").ToString()

            query = "SELECT user_name AS [Usuario], event AS [Evento], date AS [Fecha]"
            query += " FROM logs WHERE event LIKE '%" + sucursal + "%' AND event LIKE '% " + codigo + " %'"
            query += " AND cast(convert(varchar, date, 101) as date) >= '" + from_d + "' "
            query += " AND cast(convert(varchar, date, 101) as date) <= '" + to_d + "' "
            query += " ORDER BY date DESC"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                GridView1.DataSource = ds.Tables(0)
                GridView1.DataBind()
                lblMsg.Text = "Filtros: Fecha inicial: " + from_d + " - Fecha final: " + to_d + " - Código: " + codigo + " - Sucursal: " + sucursal
            Else
                GridView1.DataSource = Nothing
                GridView1.DataBind()
                lblMsg.Text = "No existen eventos para los filtros buscados"
            End If
        ElseIf cantcode > 0 And cantsucursal = 1 Then 'entra aquí si solo el código trae caracteres
            Dim codigo As String = Replace(txtCodigo.Text & "'", "'", "").ToString()

            query = "SELECT user_name AS [Usuario], event AS [Evento], date AS [Fecha]"
            query += " FROM logs WHERE event LIKE '% " + codigo + " %'"
            query += " AND cast(convert(varchar, date, 101) as date) >= '" + from_d + "' "
            query += " AND cast(convert(varchar, date, 101) as date) <= '" + to_d + "' "
            query += " ORDER BY date DESC"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                GridView1.DataSource = ds.Tables(0)
                GridView1.DataBind()
                lblMsg.Text = "Filtros: Fecha inicial: " + from_d + " - Fecha final: " + to_d + " - Código: " + codigo
            Else
                GridView1.DataSource = Nothing
                GridView1.DataBind()
                lblMsg.Text = "No existen eventos para los filtros buscados"
            End If
        ElseIf cantcode = 0 And cantsucursal > 1 Then 'entra aquí si solo la sucursal trae caracteres
            Dim sucursal As String = ddlSucursal.SelectedValue.ToString()

            query = "SELECT user_name AS [Usuario], event AS [Evento], date AS [Fecha]"
            query += " FROM logs WHERE event LIKE '%" + sucursal + "%'"
            query += " AND cast(convert(varchar, date, 101) as date) >= '" + from_d + "' "
            query += " AND cast(convert(varchar, date, 101) as date) <= '" + to_d + "' "
            query += " ORDER BY date DESC"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                GridView1.DataSource = ds.Tables(0)
                GridView1.DataBind()
                lblMsg.Text = "Filtros: Fecha inicial: " + from_d + " - Fecha final: " + to_d + " - Sucursal: " + sucursal
            Else
                GridView1.DataSource = Nothing
                GridView1.DataBind()
                lblMsg.Text = "No existen eventos para los filtros buscados"
            End If
        ElseIf cantcode = 0 And cantsucursal = 1 Then 'entra aquí si ni código ni sucursal traen caracteres
            query = "SELECT user_name AS [Usuario], event AS [Evento], date AS [Fecha]"
            query += " FROM logs WHERE cast(convert(varchar, date, 101) as date) >= '" + from_d + "' "
            query += " AND cast(convert(varchar, date, 101) as date) <= '" + to_d + "' "
            query += " ORDER BY date DESC"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                GridView1.DataSource = ds.Tables(0)
                GridView1.DataBind()
                lblMsg.Text = "Filtros: Fecha inicial: " + from_d + " - Fecha final: " + to_d
            Else
                GridView1.DataSource = Nothing
                GridView1.DataBind()
                lblMsg.Text = "No existen eventos para los filtros buscados"
            End If
        End If
    End Sub
End Class