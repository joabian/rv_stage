Imports System.Data
Imports System.Web.UI.WebControls

Public Class _Default
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim username, logevent, rackid, reason, comm, cliente, rol As String
        Dim intQty As Integer

        If User.Identity.Name = "" Then

        Else

            query = "select top 30 code, description, c.name as Categoria, Alias, convert(varchar, fecha_ingreso, 101) as Fecha_de_Ingreso "
            query += " from products p inner join categories c on p.category = c.id order by fecha_ingreso desc"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                pnl_prod_nuevos.Visible = True
                'Dim htmlTable As String = "<h1 align= 'center'> Productos recién ingresados </h1><br /><hr /><br />"
                'htmlTable += "<div style='clear:both'></div>"
                Dim htmlTable As String = "<div style='clear:both'></div>"
                htmlTable += "<table id='mytable' style='border-collapse:collapse; border:1px solid black;' border=1 align='center'><thead>"
                htmlTable += "<tr><th> Código </th><th> Descripción </th><th> Categoría </th><th> Alias </th><th> Fecha de Ingreso </th><th> Imagen </th></tr></thead><tbody>"
                For i = 0 To ds.Tables(0).Rows.Count - 1
                    htmlTable += "<tr>"
                    htmlTable += "<td align='center'>" + ds.Tables(0).Rows(i)("code").ToString() + "</td>"
                    htmlTable += "<td align='center'>" + ds.Tables(0).Rows(i)("description").ToString() + "</td>"
                    htmlTable += "<td align='center'>" + ds.Tables(0).Rows(i)("Categoria").ToString() + "</td>"
                    htmlTable += "<td align='center'>" + ds.Tables(0).Rows(i)("Alias").ToString() + "</td>"
                    htmlTable += "<td align='center'>" + ds.Tables(0).Rows(i)("Fecha_de_Ingreso").ToString() + "</td>"
                    htmlTable += "<td align='center'><img style='max-height: 200px;max-width: 200px;' src='images/tapas/" + ds.Tables(0).Rows(i)("code").ToString() + ".jpg' /></td>"
                    htmlTable += "</tr>"
                Next
                htmlTable += "</tbody></table>"
                lbl_table.Text = htmlTable

                'gv_prod_nuevos.DataSource = ds.Tables(0)
                'gv_prod_nuevos.DataBind()
            Else
                'gv_prod_nuevos.Visible = False
                lbl_table.Text = ""
            End If

            username = Membership.GetUser().UserName

            If username.ToUpper = "ADMIN" Or username.ToUpper = "SGONZALEZ" Or username.ToUpper = "ESTEFANIA" Then
                query = "select a.product_code as [Producto], a.product_category as [Categoria], qtyA as [Cantidad en Valentin]"
                query += " ,case when a.product_category = 'radiador' then 1 else (qtyA/2) end as [Cantidad para pedir]"
                query += " from ("
                query += " select product_code, sum(qty) as qtyA, max(product_category) as product_category from stock where location = 'Valentin' and product_category in ('tapa','radiador') group by product_code)a"
                query += " left join ("
                query += " select product_code, sum(qty) as qtyB, max(product_category) as product_category from stock where location = 'Henequen' and product_category in ('tapa','radiador') group by product_code)b"
                query += " on a.product_code = b.product_code"
                query += " where qtyA > 1 and qtyB is null"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    pnl_relleno.Visible = True
                    gv_relleno.DataSource = ds.Tables(0)
                    gv_relleno.DataBind()
                Else
                    pnl_relleno.Visible = False
                End If

            Else
                pnl_relleno.Visible = False
            End If



            If username.ToUpper = "ADMIN" Or username.ToUpper = "SGONZALEZ" Then

                query = "select "
                query += " sale_order.id as [Numero de Pedido]"
                query += " ,order_status.status as [Estatus]"
                query += " ,convert(varchar, sale_order.date, 101) as [Fecha de Apertura]"
                query += " ,convert(varchar, sale_order.rsd, 101) as [Fecha para Enviar]"
                query += " ,clients.name as [Cliente]"
                query += " ,tot.req as [Piezas Requeridas]"
                query += " ,tot.surtida as [Piezas Surtidas]"
                query += " ,tot.enstock as [Piezas Disponibles en Henequen]"
                query += " ,tot.falta as [Piezas no Disponibles en Henequen]"
                query += " from sale_order"
                query += " inner join clients on sale_order.customer = clients.id "
                query += " inner join order_status on sale_order.status = order_status.id"
                query += " inner join ("
                query += " select order_id, sum(qty) as req, sum(qty_picked) as surtida, sum(enstock) as enstock, sum(faltantes) as falta"
                query += " from ( select sale_order_items.order_id, sale_order_items.product_code, qty, qty_picked, isnull(cant, 0) as enStock "
                query += " ,case when qty - qty_picked > isnull(cant, 0) then (qty-isnull(cant, 0)) else 0 end as faltantes from sale_order_items "
                query += " left join (select product_code, sum(qty) as cant from stock where location = 'henequen' group by product_code) as mystock"
                query += " on sale_order_items .product_code = mystock.product_code where sale_order_items.active = 1)a group by order_id"
                query += " )tot"
                query += " on tot.order_id = sale_order.id"
                query += " where sale_order.status in (1,2,3) and sale_order.location = 1"
                ds = Dataconnect.GetAll(query)

                If ds.Tables(0).Rows.Count > 0 Then
                    'do something
                    pnl_pedidos.Visible = True
                    gv_pedidos.DataSource = ds.Tables(0)
                    gv_pedidos.DataBind()
                Else
                    'No data
                    pnl_pedidos.Visible = False
                    gv_pedidos.DataBind()
                    gv_pedidos.Visible = False
                End If

            Else
                pnl_pedidos.Visible = False

            End If

        End If



    End Sub


End Class
