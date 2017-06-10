Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO

Partial Class productos_prod_categ
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Public Sub mostrarTabla(ByVal category_id As String)

        Dim where As String = ""
        If cb_catalogo.Checked = True And cb_fuera_catalogo.Checked = False Then
            where = " and fuera_catalogo = 0"
        ElseIf cb_catalogo.Checked = False And cb_fuera_catalogo.Checked = True Then
            where = " and fuera_catalogo = 1"
        End If
        query = "select code, description from products where category = '" + category_id.ToString() + "'" + where.ToString() + " order by code"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim htmlTable As String = "<table id='mytable' style='border-collapse:collapse; border:1px solid black;' border=1><thead><tr><th> Código </th><th> Descripción </th><th> Imagen </th></tr></thead><tbody>"

            For i = 0 To ds.Tables(0).Rows.Count - 1
                htmlTable += "<tr>"
                htmlTable += "<td align='center'>" + ds.Tables(0).Rows(i)("code").ToString() + "</td>"
                htmlTable += "<td align='center'>" + ds.Tables(0).Rows(i)("description").ToString() + "</td>"
                htmlTable += "<td align='center'><img style='max-height: 200px;max-width: 200px;' src='../images/tapas/" + ds.Tables(0).Rows(i)("code").ToString() + ".jpg' /></td>"
                htmlTable += "</tr>"
            Next
            htmlTable += "</tbody></table>"
            lbl_error.Text = ""
            lbl_table.Text = htmlTable
        Else
            lbl_table.Text = ""
            lbl_error.Text = "No existen productos para esta seleccion"
        End If


    End Sub


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack() Then
            populateCategories()
        End If
    End Sub

    Public Sub populateCategories()
        query = "select id, name from categories"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ddl_category.DataSource = ds.Tables(0)
            ddl_category.DataTextField = "name"
            ddl_category.DataValueField = "id"
            ddl_category.DataBind()
        End If
    End Sub

    Protected Sub btn_run_Click(sender As Object, e As EventArgs) Handles btn_run.Click
        If ddl_category.SelectedValue.ToString() = "0" Then
            lbl_error.Text = "Seleccione una categoria"
        Else
            mostrarTabla(ddl_category.SelectedValue.ToString())
        End If
    End Sub
End Class
