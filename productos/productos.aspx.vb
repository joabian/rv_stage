Imports System.Data
Imports vencedoresTableAdapters
Partial Class productos_productos
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    
    End Sub
    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        Dim strFilename As String = "Lista_de_Productos_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

        Response.AddHeader("content-disposition", "attachment;filename=" & strFilename & ".xls")
        Response.Clear()
        Response.Charset = ""
        Response.ContentType = "application/vnd.ms-excel"

        Dim stringWrite As System.IO.StringWriter = New System.IO.StringWriter()
        Dim htmlWrite As System.Web.UI.HtmlTextWriter = New System.Web.UI.HtmlTextWriter(stringWrite)
        Dim dg As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid()
        query = "select products.code as modelo, categories.name as categoria, products.description as descripcion from products"
        query += " inner join categories on products.category = categories.id"
        query += " order by products.code"
        ds = Dataconnect.GetAll(query)

        dg.DataSource = ds.Tables(0)
        dg.DataBind()
        dg.RenderControl(htmlWrite)
        Response.Write(stringWrite.ToString())
        Response.End()
    End Sub
End Class
