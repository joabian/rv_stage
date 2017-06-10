
Partial Class movimientos_clientes
    Inherits System.Web.UI.Page

    Protected Sub btn_add_client_Click(sender As Object, e As EventArgs) Handles btn_add_client.Click
        Response.Redirect("nuevo_cliente.aspx")
    End Sub
End Class
