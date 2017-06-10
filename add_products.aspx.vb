Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports Excel

Partial Class add_products
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public email As New email_mng
    'Public username As String = Membership.GetUser().UserName

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            hifd_order.Value = Request.QueryString("orden").ToString()
            hifd_categ.Value = Request.QueryString("categ").ToString()
            hifd_location.Value = Request.QueryString("location").ToString()
            loadTable()
        End If
    End Sub

    Public Sub loadTable()
        Dim myprice As String
        If hifd_categ.Value = "2" Then
            query = "select default_price from sale_order inner join clients on sale_order.customer = clients.id where sale_order.id = " + hifd_order.Value.ToString()
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                myprice = ds.Tables(0).Rows(0)("default_price").ToString()
                If myprice = "" Then
                    myprice = ""
                End If
            Else
                myprice = ""
            End If
        Else
            myprice = ""
        End If


        query = "select code, isnull(a.total, 0) as total_suc from products "
        query += " left join (select product_code, sum(qty) as total from stock where location = '" + hifd_location.Value.ToString() + "' group by product_code)a"
        query += " on products.code = a.product_code"
        query += " where products.category in (" + hifd_categ.Value.ToString() + ") order by products.code"
        ds = Dataconnect.GetAll(query)

        Dim html_table As String
        html_table = "<table border='1' style='width:500px;font-size:12px' id='tablaReportes'>"

        'construct the Title 
        html_table += "<thead><tr>"
        'construct the headers for each column      
        html_table += "<th>Codigo</th><th>Disponible en Sucursal</th><th>Cantidad requerida</th><th>Precio</th>"
        html_table += "<th>Codigo</th><th>Disponible en Sucursal</th><th>Cantidad requerida</th><th>Precio</th>"
        html_table += "<th>Codigo</th><th>Disponible en Sucursal</th><th>Cantidad requerida</th><th>Precio</th>"
        html_table += "<th>Codigo</th><th>Disponible en Sucursal</th><th>Cantidad requerida</th><th>Precio</th>"
        html_table += "</tr></thead><tbody>"
        Dim mycounter As Integer = 1
        For y = 0 To ds.Tables(0).Rows.Count - 1
            Dim code, total As String
            'code = Replace(Replace(Replace(Replace(ds.Tables(0).Rows(y)("code").ToString(), "/", "_"), "=", "_"), "(", "_"), ")", "_")
            code = ds.Tables(0).Rows(y)("code").ToString()
            total = ds.Tables(0).Rows(y)("total_suc").ToString()
            If mycounter = 1 Then
                html_table += "<tr>"
            End If

            html_table += "<td>" + code.ToString() + "</td>"
            html_table += "<td>" + total.ToString() + "</td>"
            html_table += "<td><input type='text' id='tb_" + code.ToString() + "' name='tb_" + code.ToString() + "' size='3' /></td>"
            html_table += "<td><input type='text' id='tb_precio_" + code.ToString() + "' name='tb_precio_" + code.ToString() + "' size='3' value='" + myprice.ToString() + "' /></td>"

            If mycounter = 4 Then
                html_table += "</tr>"
                mycounter = 0
            End If

            mycounter += 1
        Next

        Dim lines As Integer = ds.Tables(0).Rows.Count
        Dim res As Integer = 4 - (lines Mod 4)
        If res >= 1 And res < 4 Then
            For j = 1 To res
                html_table += "<td></td><td></td><td></td><td></td>"
            Next
            html_table += "</tr>"
        End If

        html_table += "</tbody></table>"
        lbl_html_table.Text = html_table
    End Sub

    Function isDivisible(x As Integer, d As Integer) As Boolean
        Return (x Mod d) = 0
    End Function


    Protected Sub btn_add_Click(sender As Object, e As EventArgs) Handles btn_add.Click
        query = "select code from products where category in (" + hifd_categ.Value.ToString() + ")"
        ds = Dataconnect.GetAll(query)
        For i = 0 To ds.Tables(0).Rows.Count - 1
            Dim code As String = ds.Tables(0).Rows(i)("code").ToString().ToUpper()
            Dim qty As String = Request.Form("tb_" + code.ToString())
            Dim precio As String = Request.Form("tb_precio_" + code.ToString())
            If Not IsNothing(qty) And Not IsNothing(precio) Then
                If qty <> "" And precio <> "" Then
                    If IsNumeric(qty) And IsNumeric(precio) Then
                        query = "select id from sale_order_items where order_id = " + hifd_order.Value.ToString + " and product_code = '"
                        query += code.ToString() + "' and active = 1"
                        Dim ds_chec As DataSet
                        ds_chec = Dataconnect.GetAll(query)
                        If ds_chec.Tables(0).Rows.Count > 0 Then
                            query = "update sale_order_items set qty = qty + " + qty.ToString() + " where id = " + ds_chec.Tables(0).Rows(0)("id").ToString()
                        Else
                            query = "insert into sale_order_items (order_id,qty,sold_price,product_code,qty_picked,active,update_date) values ("
                            query += " '" + hifd_order.Value.ToString() + "',"
                            query += " '" + qty.ToString() + "',"
                            query += " '" + precio.ToString() + "',"
                            query += " '" + code.ToString() + "',"
                            query += " '0',"
                            query += " '1',"
                            query += " getdate())"
                        End If
                        Dataconnect.runquery(query)
                    End If
                End If
            End If
        Next

        Response.Write("<script language='javascript'> { parent.$.fn.colorbox.close(); }</script>")
    End Sub
End Class
