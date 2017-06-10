
Partial Class impr_etiquetas
    Inherits System.Web.UI.Page



    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim code As String
            code = Request.QueryString("code")
            If code <> "" Then
                construct_tabla("*" + code + "*")
            End If
        End If
    End Sub

    Public Sub construct_tabla(ByVal code As String)
        Dim table_str As String = ""
        table_str = "<table style='width:900px; marging-left:auto; margin-right:auto; border-collapse:collapse'>"
        For i = 0 To 19
            table_str += "<tr>"
            For j = 0 To 4
                table_str += "<td style='border:1px solid black; width:180px; height:60px; vertical-align:middle; text-align:center'>" + code + "</td>"
            Next
            table_str += "</tr>"
        Next
        table_str += "</table>"

        lbl_tabla.Text = table_str

    End Sub
End Class
