Imports System.Data
Imports System.Runtime.InteropServices


Partial Class movimientos_verif_pedido
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

            query = "select position, isnull(alias,'ALL') as sucursal from users "
            query += " left join locations on location = locations.id"
            query += " where user_name = '" + user + "'"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                Dim pos As String = ds.Tables(0).Rows(0)("position").ToString()
                hifd_location.Value = ds.Tables(0).Rows(0)("sucursal").ToString()

                If pos = "admin" Or pos = "inventory" Or pos = "vendedor" Then
                    If Request.QueryString("order") <> "" Then
                        hf_order_id.Value = Request.QueryString("order").ToString()
                        ddl_opn_orders.Visible = False
                    Else
                        ddl_opn_orders.Visible = True
                        populate_open_orders()
                    End If
                    populate_gv_items()
                Else
                    Response.Redirect("../no_access.aspx")
                End If


            Else
                Response.Redirect("../no_access.aspx")
            End If
        End If

    End Sub

    Public Sub populate_open_orders()
        Dim user As String
        user = Membership.GetUser().UserName
        query = "select location from users where user_name = '" + user + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim location As String = ds.Tables(0).Rows(0)("location").ToString()
            Dim location_st As String = ""
            If location <> "0" Then
                location_st = " and sale_order.location = " + location.ToString()
            End If

            query = "select sale_order.id, convert(varchar, sale_order.id, 100) + ' - ' + clients.name + ' ('"
            query += " + convert(varchar, order_status.status, 101) + ')' as cust from sale_order"
            query += " inner join clients on sale_order.customer = clients.id "
            query += " inner join order_status on sale_order.status = order_status.id"
            query += " where sale_order.status in (1,2,3,4,5) " + location_st.ToString()
            query += " order by sale_order.id"
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                'do something
                ddl_opn_orders.DataSource = ds.Tables(0)
                ddl_opn_orders.DataValueField = "id"
                ddl_opn_orders.DataTextField = "cust"
                ddl_opn_orders.DataBind()

            Else
                'No data
                ddl_opn_orders.DataSource = Nothing
                ddl_opn_orders.DataBind()
            End If
        Else
            'No data
            ddl_opn_orders.DataSource = Nothing
            ddl_opn_orders.DataBind()
        End If

    End Sub

    Protected Sub ddl_opn_orders_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_opn_orders.SelectedIndexChanged
        lbl_error.Text = ""
        'tbx_code.Text = ""
        populate_gv_items()
    End Sub

    Public Sub populate_gv_items()
        Dim order As String
        If hf_order_id.Value <> "" Then
            order = hf_order_id.Value.ToString()
        Else
            order = ddl_opn_orders.SelectedValue.ToString()
        End If
        
        query = "select pedido.product_code as [Codigo], pedido.qty as [Cantidad Pedida], 0 as [Cantidad Verificada],"
        query += " pedido.qty as [Cantidad faltante] "
        query += " from sale_order_items as pedido"
        query += " where pedido.active = 1 and pedido.order_id = " + order.ToString() + " order by update_date desc"

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            createTable(ds)
        Else
            lbl_items.Text = ""
        End If
    End Sub

    Public Sub createTable(ByVal ds As DataSet)
        Dim html_table As String
        html_table = "<table id='htmlTable' style='width:100%;border-collapse:collapse' border=1><thead><tr>"
        For j = 0 To ds.Tables(0).Columns.Count - 1
            html_table += "<th>" + ds.Tables(0).Columns(j).ColumnName.ToString() + "</th>"
        Next
        html_table += "<th>or</th></tr></thead><tbody>"

        For i = 0 To ds.Tables(0).Rows.Count - 1
            html_table += "<tr>"
            For m = 0 To ds.Tables(0).Columns.Count - 1
                html_table += "<td>" + ds.Tables(0).Rows(i)(m).ToString() + "</td>"
            Next
            html_table += "<td>2</td></tr>"
        Next
        html_table += "</tbody></table>"

        lbl_items.Text = html_table

    End Sub

    

    


End Class
