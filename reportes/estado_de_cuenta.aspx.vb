Imports System.Data

Partial Class reportes_estado_de_cuenta
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds, ds2 As New DataSet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populateClientes()
        End If
    End Sub

    Public Sub populateClientes()
        Dim user As String
        user = Membership.GetUser().UserName

        query = "SELECT location FROM users WHERE user_name = '" + user + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim location As String = ds.Tables(0).Rows(0)("location").ToString()
            Dim location_st As String = ""
            If location <> "0" Then
                location_st = " AND location = " + location.ToString()
            End If

            query = "SELECT id, name FROM clients WHERE active = 1" + location_st.ToString() + " ORDER BY name"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                ddlCliente.DataSource = ds.Tables(0)
                ddlCliente.DataTextField = "name"
                ddlCliente.DataValueField = "id"
                ddlCliente.DataBind()
            End If
        End If
    End Sub

    Protected Sub btnGetEdoCta_Click(sender As Object, e As EventArgs) Handles btnGetEdoCta.Click
        Dim fromD As String = Replace(fromDate.Text & "'", "'", "").ToString()
        Dim toD As String = Replace(toDate.Text & "'", "'", "").ToString()
        Dim clientId As String = ddlCliente.SelectedValue.ToString()
        Dim idOrden, cliente, fecha, total, tipoProd, cantProd, strTable As String
        strTable = ""

        If IsDate(fromD) And IsDate(toD) And clientId <> "-" Then
            query = "SELECT sale_order.id As [Id Orden], clients.name As Cliente, CONVERT(varchar, sale_order.date, 101) As Fecha, sale_order.total As [Total $] "
            query += "FROM sale_order "
            query += "INNER JOIN clients ON sale_order.customer = clients.id AND sale_order.customer = " + clientId.ToString()
            query += "WHERE CAST(convert(varchar, sale_order.date, 101) As date) >= '" + fromD.ToString + "' "
            query += "AND CAST(convert(varchar, sale_order.date, 101) As date) <= '" + toD.ToString + "' "
            query += "ORDER BY sale_order.id DESC"
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                strTable = "<table class='tableItems' border='1'><tr><th>No. Orden</th><th>Cliente</th><th>Fecha</th><th>Productos</th><th>Estatus</th><th>Monto $</th></tr>"

                For i = 0 To ds.Tables(0).Rows.Count - 1
                    idOrden = ds.Tables(0).Rows(i)("Id Orden")
                    cliente = ds.Tables(0).Rows(i)("Cliente")
                    fecha = ds.Tables(0).Rows(i)("Fecha")
                    'total = ds.Tables(0).Rows(0)("Total $")

                    strTable += "<tr><td>" + idOrden.ToString() + "</td><td>" + cliente.ToString() + " </td><td>" + fecha.ToString() + "</td><td>"

                    query = "SELECT categories.name As Categoria, SUM(sale_order_items.qty_picked) As [Cantidad de piezas] "
                    query += "FROM sale_order_items "
                    query += "INNER JOIN sale_order  ON sale_order_items.order_id = sale_order.id AND sale_order.id = " + idOrden.ToString()
                    query += "INNER JOIN products ON sale_order_items.product_code = products.code "
                    query += "INNER JOIN categories ON products.category = categories.id AND (categories.id = 1 OR categories.id = 2 OR categories.id = 25) "
                    query += "WHERE sale_order_items.active = 1 "
                    query += "AND sale_order.customer = " + clientId.ToString() + " AND status > 4 AND status <> 7 "
                    query += "AND CAST(convert(varchar, sale_order.date, 101) As date) >= '" + fromD.ToString() + "' "
                    query += "AND CAST(convert(varchar, sale_order.date, 101) As date) <= '" + toD.ToString() + "' "
                    query += "GROUP BY categories.name "
                    query += "HAVING SUM(sale_order_items.qty_picked) > 0"
                    query += "ORDER BY categories.name DESC"
                    ds2 = Dataconnect.GetAll(query)

                    If ds2.Tables(0).Rows.Count > 0 Then
                        strTable += "<table class='tableItems'>"

                        For j = 0 To ds2.Tables(0).Rows.Count - 1
                            tipoProd = ds2.Tables(0).Rows(j)("Categoria")
                            cantProd = ds2.Tables(0).Rows(j)("Cantidad de piezas")

                            strTable += "<tr><td>" + tipoProd.ToString() + "</td><td>" + cantProd.ToString() + "</td></tr>"
                        Next
                        strTable += "</table>"
                    End If
                    strTable += "</td><td> Sin Definir </td><td> Sin definir </td></tr>"
                    '+ total.ToString() + "</td></tr>"
                Next
                strTable += "</table>"
            End If
            lblTitulo.Visible = True
            tblEdoCta.Text = strTable.ToString()
        Else
            btnExport.Enabled = False
            lblError.Text = "Ingrese todos los datos"
        End If

    End Sub
End Class
