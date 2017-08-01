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
        query = "SELECT user_name AS [Usuario], event AS [Evento], date AS [Fecha] FROM logs WHERE date >= (getdate() - 1) ORDER BY date desc"
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
        GridView1.DataSource = Nothing
        GridView1.DataBind()

        Dim code As String = Replace(txtCodigo.Text & "'", "'", "") 'cuenta la cantidad de caracteres que trae el código
        Dim sucursal As String = ddlSucursal.SelectedValue.ToString() 'cuenta la cantidad de caracteres que trae la sucursal
        Dim from_d As String = Request.Form("from_date") 'convierte a string la fecha de inicio
        Dim to_d As String = Request.Form("to_date") 'convierte a string la fecha final


        query = "SELECT user_name AS [Usuario], event AS [Evento], date AS [Fecha]"
        query += " FROM logs WHERE cast(convert(varchar, date, 101) as date) >= '" + from_d + "' "
        query += " AND cast(convert(varchar, date, 101) as date) <= '" + to_d + "' "
        If code <> "" Then
            query += " and event LIKE '%" + code + "%'"
        End If
        If sucursal <> "-" Then
            query += " and event LIKE '%" + sucursal + "%'"
        End If
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




    End Sub
End Class
