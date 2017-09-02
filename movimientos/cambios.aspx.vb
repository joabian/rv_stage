Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO

Partial Class movimientos_cambios
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet
    Public username As String
    Public sendemail As New email_mng
    
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        If Not IsPostBack Then
            populate_ddl_locations()
        End If

    End Sub

    Public Sub populate_ddl_locations()
        username = Membership.GetUser().UserName
        Dim location_st, location_alias As String

        query = "select location,alias from users left join locations on users.location = locations.id where user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st = ds.Tables(0).Rows(0)("location").ToString()
            location_alias = ds.Tables(0).Rows(0)("alias").ToString()
            If location_st = "0" Then
                query = "select alias from locations"
            Else
                query = "select alias from locations where id = " + location_st.ToString()
            End If
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                ddl_location.DataSource = ds.Tables(0)
                ddl_location.DataValueField = "alias"
                ddl_location.DataTextField = "alias"
                ddl_location.DataBind()
                If location_st <> "0" Then
                    ddl_location.SelectedValue = location_alias
                End If
            Else
                ddl_location.DataSource = Nothing
                ddl_location.DataBind()
            End If
        End If
    End Sub

    Protected Sub save_Click(sender As Object, e As EventArgs) Handles btn_save.Click
        Dim product_ent, product_sal, rack, comments, location_id, location_name, qty As String
        location_id = ddl_location.SelectedValue.ToString()
        location_name = ddl_location.SelectedItem.Text.ToString()

        username = Membership.GetUser().UserName

        product_ent = Replace(Replace(tb_product_ent.Text & "'", "'", ""), " ", "").ToString()
        product_sal = Replace(Replace(tb_product_sal.Text & "'", "'", ""), " ", "").ToString()
        rack = Replace(tb_rack.Text & "'", "'", "").ToString()
        comments = Replace(tb_comments.Text & "'", "'", "").ToString()
        qty = Replace(tb_qty.Text & "'", "'", "").ToString()

        If product_ent = "" Or product_sal = "" Or rack = "" Or comments = "" Or location_id = "-" Or qty = "" Then
            lbl_error.Text = "Ingrese todos los campos"
        ElseIf rack.ToUpper() = "TEMPORAL" Then
            lbl_error.Text = "No es posible dar de baja de rack Temporal"
        ElseIf Not IsNumeric(qty) Then
            lbl_error.Text = "Ingrese la cantidad numerica"
        Else
            query = "select * from products where code in ('" + product_ent.ToString() + "','" + product_sal.ToString() + "')"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count <= 1 Then
                'tiene que encontrar los dos registros
                lbl_error.Text = "Alguno de los modelos no existe en nuestra base de datos, verifique los codigos"
            Else
                query = "select * from stock where product_code = '" + product_sal.ToString() + "' and location = '"
                query += location_name.ToString() + "' and rack = '" + rack.ToString() + "' and qty >= " + qty
                ds = Dataconnect.GetAll(query)

                If ds.Tables(0).Rows.Count <= 0 Then
                    'tiene que tener stock suficiente en el rack
                    lbl_error.Text = "El producto de salida no tiene suficiente cantidad en el rack especificado"
                Else
                    Dim id_record As String = ds.Tables(0).Rows(0)("id").ToString()
                    'las condisiones son apropiadas
                    'actualizar stock salida de producto
                    query = "update stock set qty = (qty - " + qty + ") where id = " + id_record.ToString()

                    'insetamos en movimientos la salida
                    query += " insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (0"
                    query += ", '" + product_sal.ToString().ToUpper() + "', 'CAMBIO'"
                    query += ", 'SALIDA', '" + comments.ToString() + "', '" + location_name.ToString().ToUpper() + "', '"
                    query += rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty + ")"

                    'actualizar stock entrada de producto en rack temporal
                    query += " insert into stock (product_id,product_code,product_description,product_model,product_low_inventory"
                    query += ",product_category,qty,location,last_update,rack,"
                    query += "from_location) select products.id, products.code, products.description, products.model,"
                    query += " products.low_inventory, categories.name, " + qty + ", '" + location_name.ToString().ToUpper()
                    query += "', getDate(), 'TEMPORAL', 'Cambio' from products inner join categories on products.category"
                    query += " = categories.id where products.code = '" + product_ent.ToString() + "'"

                    'insetamos en movimientos la entrada
                    query += " insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (0"
                    query += ", '" + product_ent.ToString().ToUpper() + "', 'CAMBIO'"
                    query += ", 'ENTRADA', '" + comments.ToString() + "', '" + location_name.ToString().ToUpper() + "', '"
                    query += rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty + ")"
                    Dataconnect.runquery(query)

                    Dim logevent As String = "Cambio de producto, devuelto: " + product_ent.ToString() + ", salio: " + product_sal.ToString()
                    logevent += ", del rack " + rack.ToString() + " en la sucursal: " + location_name.ToString().ToUpper()
                    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + Membership.GetUser().UserName.ToString() + "', '" + logevent.ToString() + "', getDate())"
                    Dataconnect.runquery(queryLog)
                    cleancontrols()
                    lbl_error.ForeColor = Color.Green
                    lbl_error.Text = "Cambios gruardados!"
                End If
            End If
        End If
    End Sub

    Public Sub cleancontrols()
        lbl_error.Text = ""
        tb_comments.Text = ""
        tb_product_ent.Text = ""
        tb_product_sal.Text = ""
        tb_rack.Text = ""
        ddl_location.SelectedValue = "-"
    End Sub
End Class
