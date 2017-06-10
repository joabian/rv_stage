Imports System.Data
Imports System.Runtime.InteropServices

Partial Class movimientos_surtir
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public sendEmail As New email_mng

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim user As String
            user = Membership.GetUser().UserName

            query = "select position, isnull(alias,'ALL') as sucursal from users"
            query += " left join locations on location = locations.id"
            query += " where user_name = '" + user + "'"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                Dim pos As String = ds.Tables(0).Rows(0)("position").ToString()

                If pos = "admin" Or pos = "inventory" Or pos = "vendedor" Then
                    If Request.QueryString("order") <> "" Then
                        lbl_order.Text = Request.QueryString("order").ToString()
                        populate_Cliente()
                    End If
                Else
                    Response.Redirect("../no_access.aspx")
                End If
            Else
                Response.Redirect("../no_access.aspx")
            End If
        End If

    End Sub

    Public Sub populate_Cliente()
        query = "select isnull(clients.name, 'Sin Definir') as cliente, isnull(sale_order.paqueteria,'Sin Definir') as paqueteria from sale_order left join clients on sale_order.customer = clients.id where sale_order.id = '" + lbl_order.Text + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            lbl_cliente.Text = ds.Tables(0).Rows(0)("cliente").ToString()
            lbl_paqueteria.Text = ds.Tables(0).Rows(0)("paqueteria").ToString()
        Else
            lbl_cliente.Text = "Sin definir"
            lbl_paqueteria.Text = "Sin definir"
        End If

    End Sub

    Function bodyHtml(ByVal order_id As String, ByVal username As String) As String
        Dim html As String = ""

        html += "<h1>Notificacion</h1><br />"
        html += "<h2>Ha sido surtido un pedido</h2><br />"
        html += "<h2>Numero de Pedido: <b>" + order_id.ToString() + "</b><br />"

        query = "select sale_order.shipping_address, contact_info, convert(varchar, date, 101) as fecha,"
        query += " convert(varchar, rsd, 101) as rsd, clients.name as cliente,"
        query += " employees.name + ' ' + employees.last_name as vendedor"
        query += " from sale_order"
        query += " inner join clients on sale_order.customer = clients.id"
        query += " inner join employees on sale_order.vendor = employees.id"
        query += " where sale_order.id = " + order_id.ToString()
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            Dim cliente, ship_address, contact, fecha, rsd, vendedor As String
            cliente = ds.Tables(0).Rows(0)("cliente").ToString()
            ship_address = ds.Tables(0).Rows(0)("shipping_address").ToString()
            contact = ds.Tables(0).Rows(0)("contact_info").ToString()
            fecha = ds.Tables(0).Rows(0)("fecha").ToString()
            rsd = ds.Tables(0).Rows(0)("rsd").ToString()
            vendedor = ds.Tables(0).Rows(0)("vendedor").ToString()

            html += "<h3><b>Informacion del pedido</b><br />"
            html += "Cliente: <b>" + cliente.ToString() + "</b><br />"
            html += "Contacto: <b>" + contact.ToString() + "</b><br />"
            html += "Vendedor: <b>" + vendedor.ToString() + "</b><br />"
            html += "Direccion de envio: <b>" + ship_address.ToString() + "</b><br />"
            html += "Fecha de apertura: <b>" + fecha.ToString() + "</b><br />"
            html += "Fecha requerido: <b>" + rsd.ToString() + "</b><br /></h3>"
        Else
            html += "<b> No se tiene mas informacion del pedido</b>"
        End If

        query = "select product_code, qty, qty_picked, (qty - qty_picked) as missing"
        query += " from sale_order_items where active = 1 and order_id = " + order_id.ToString()
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            html += "Lista de productos: <br /><br />"
            html += "<table border='1' style='border-collapse:collapse'><tr>"
            html += "<th>Producto</th><th>Cantidad Reqerida</th><th>Surtida</th><th>Faltante</th>"
            html += "</tr>"

            For i = 0 To ds.Tables(0).Rows.Count - 1
                html += "<tr>"
                html += "<td>" + ds.Tables(0).Rows(i)("product_code").ToString() + "</td>"
                html += "<td>" + ds.Tables(0).Rows(i)("qty").ToString() + "</td>"
                html += "<td>" + ds.Tables(0).Rows(i)("qty_picked").ToString() + "</td>"
                html += "<td>" + ds.Tables(0).Rows(i)("missing").ToString() + "</td>"
                html += "</tr>"
            Next

        Else
            'No data
        End If

        Return html
    End Function


End Class
