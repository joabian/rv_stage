Imports System.Data
Partial Class movimientos_transfers
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public ds_transit As DataSet
    Public logevent As String
    Public username As String
    Public prod As String


    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        username = Membership.GetUser().UserName

        If Not IsPostBack Then
            populate_ddl()
        Else

        End If

    End Sub
    Public Sub populate_ddl()
        Dim username As String
        Dim location_st As String
        username = Membership.GetUser().UserName
        query = "select location from users where user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st = ds.Tables(0).Rows(0)("location").ToString()
            If location_st = "0" Then
                query = "select alias from locations"
            Else
                query = "select alias from locations where id = " + location_st.ToString()
            End If
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                fromlocation.DataSource = ds.Tables(0)
                fromlocation.DataValueField = "alias"
                fromlocation.DataTextField = "alias"
                fromlocation.DataBind()
                receive_location_DDL.DataSource = ds.Tables(0)
                receive_location_DDL.DataTextField = "alias"
                receive_location_DDL.DataValueField = "alias"
                receive_location_DDL.DataBind()

                If location_st <> "0" Then
                    fromlocation.SelectedValue = location_st
                    receive_location_DDL.SelectedValue = location_st
                End If

            Else
                fromlocation.DataSource = Nothing
                fromlocation.DataBind()
                receive_location_DDL.DataSource = Nothing
                receive_location_DDL.DataBind()

            End If
        End If


        tolocation.DataSource = ds.Tables(0)
        tolocation.DataTextField = "alias"
        tolocation.DataValueField = "alias"
        tolocation.DataBind()


        query = "select alias from locations where transit = 1"
        ds = Dataconnect.GetAll(query)
        transit_locationDDL.DataSource = ds
        transit_locationDDL.DataTextField = "alias"
        transit_locationDDL.DataValueField = "alias"
        transit_locationDDL.DataBind()

        transit_receive_ddl.DataSource = ds
        transit_receive_ddl.DataTextField = "alias"
        transit_receive_ddl.DataValueField = "alias"
        transit_receive_ddl.DataBind()
    End Sub

    Protected Sub save_Click(sender As Object, e As System.EventArgs) Handles save.Click
        Dim fromloc As String
        Dim toloc As String
        Dim tran_loc As String
        Dim rack_f As String
        fromloc = fromlocation.SelectedValue.ToString()
        toloc = tolocation.SelectedValue.ToString()
        tran_loc = transit_locationDDL.SelectedValue.ToString()
        rack_f = from_rackTB.Text
        prod = Replace(Replace(productId.Text, "'", "").ToUpper(), " ", "")
        Dim comm As String
        Dim intQty As Integer = Replace(qty_TB.Text, "'", "''").ToString()
        If comments_TB.Text <> "" Then
            comm = Replace(comments_TB.Text, "'", "''")
        Else
            comm = ""
        End If
        If fromloc = toloc Then
            errorlbl.Text = "No es posible transferir productos entre locaciones iguales"
        Else
            query = "select * from stock where product_code = '" + prod.ToString() + "' and location = '" + fromloc.ToString() + "' and rack = '" + rack_f.ToString() + "'"
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 And intQty > 0 Then
                Dim fromoldqty As Integer, fromnewqty As Integer
                fromoldqty = ds.Tables(0).Rows(0)("qty").ToString()
                fromnewqty = fromoldqty - qty_TB.Text
                If fromnewqty < 0 Then
                    errorlbl.Text = "No existe suficiente inventario en la locacion de la que se desea transferir el producto"
                Else
                    query = "update stock set qty = " + fromnewqty.ToString() + ", last_update = getDate() where product_code = '" + prod.ToString() + "' and location = '" + fromlocation.SelectedValue.ToString() + "'"
                    query += " delete from stock where qty <= 0"
                    Dataconnect.runquery(query)
                    query = "select qty from stock where product_code = '" + prod.ToString() + "' and location = '" + tran_loc.ToString() + "' and rack = 't'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        Dim tooldqty As Integer, tonewqty As Integer
                        tooldqty = ds.Tables(0).Rows(0)("qty").ToString()
                        tonewqty = tooldqty + qty_TB.Text

                        query = "update stock set qty = " + tonewqty.ToString() + ", last_update = getDate() where product_code = '" + prod.ToString() + "' and location = '" + tran_loc.ToString() + "'"
                        query += " delete from stock where qty <= 0"
                        Dataconnect.runquery(query)

                        logevent = "Transferencia del producto: " + prod.ToString() + ", de sucursal: " + fromloc.ToString() + " a sucursal: " + toloc.ToString() + " por la cantidad de " + qty_TB.Text.ToString() + ", dejando a " + fromloc.ToString() + " con " + fromnewqty.ToString() + " items y a " + toloc.ToString() + " con " + tonewqty.ToString() + " items, se transfirio mediante la locacion transitaria: " + tran_loc.ToString() + "."
                    Else
                        query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location) select products.id, products.code, products.description, products.model, products.low_inventory, categories.name, " + qty_TB.Text.ToString() + ", '" + tran_loc.ToString() + "', getDate(), 't', 'Entrada' from products inner join categories on products.category = categories.id where products.code = '" + prod.ToString() + "'"
                        ds = Dataconnect.GetAll(query)

                        logevent = "Transferencia del producto: " + prod.ToString() + ", de sucursal: " + fromloc.ToString() + " rack: " + rack_f.ToString() + " a sucursal: " + toloc.ToString() + " por la cantidad de " + qty_TB.Text.ToString() + ", dejando a " + fromloc.ToString() + " con " + fromnewqty.ToString() + " items y a " + toloc.ToString() + " con " + qty_TB.Text.ToString() + " items, se transfirio mediante la locacion transitoria: " + tran_loc.ToString() + "."

                    End If

                    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                    Dataconnect.runquery(queryLog)

                    query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (1, '" + prod.ToString() + "', 'Transferencia', 'Transferencia', '" + comm.ToString() + "', '" + fromloc.ToString() + " -> " + tran_loc.ToString() + "', '" + rack_f.ToString() + " -> t', '" + username.ToString() + "', getDate(), " + qty_TB.Text + ")"
                    Dataconnect.runquery(query)

                    Response.Redirect("transfers.aspx")
                End If
            Else
                errorlbl.Text = "Verifique los datos, esta tratando de ingresar cantidades no validas o el producto no existe en nuestra base de datos"
            End If
        End If
    End Sub


    Protected Sub transit_receive_ddl_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles transit_receive_ddl.SelectedIndexChanged
        Dim trans_receive As String
        trans_receive = transit_receive_ddl.SelectedValue.ToString()
        prod = Replace(productId.Text, "'", "''")

        query = "select * from stock where location = '" + trans_receive.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            lblerrortransit.Text = ""
            transit_inventoryGV.Visible = True
            transit_inventoryGV.DataSource = ds
            transit_inventoryGV.DataBind()
        Else
            lblerrortransit.Text = "No existe inventario en esta locacion"
            transit_inventoryGV.Visible = False
        End If

    End Sub


    Protected Sub Recieve_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Recieve.Click
        Dim rec_loc As String
        rec_loc = receive_location_DDL.SelectedValue.ToString()

        Dim trans_receive As String
        trans_receive = transit_receive_ddl.SelectedValue.ToString()

        query = "select * from stock where location = '" + trans_receive.ToString() + "'"
        ds_transit = Dataconnect.GetAll(query)
        If ds_transit.Tables(0).Rows.Count > 0 Then
            lblerrortransit.Text = ""

            For index As Integer = 0 To ds_transit.Tables(0).Rows.Count - 1
                Dim id_inv As Integer = ds_transit.Tables(0).Rows(index)("id").ToString()
                Dim qty As Integer = ds_transit.Tables(0).Rows(index)("qty").ToString()
                Dim product As Integer = ds_transit.Tables(0).Rows(index)("product_id").ToString().ToUpper()
                Dim code As String = ds_transit.Tables(0).Rows(index)("product_code").ToString()
                Dim desc As String = ds_transit.Tables(0).Rows(index)("product_description").ToString()
                Dim categ As String = ds_transit.Tables(0).Rows(index)("product_category").ToString()

                query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location) values (" + product.ToString() + ", '" + code.ToString().ToUpper() + "',  '" + desc.ToString() + "', 'n/a', 10, '" + categ.ToString() + "', " + qty.ToString() + ", '" + rec_loc.ToString() + "', getDate(), 'tran', 'Entrada')"
                Dataconnect.runquery(query)

                logevent = "se recivio transferencia de la locacion transitoria: " + trans_receive.ToString() + " producto: " + ds_transit.Tables(0).Rows(index)("product_code").ToString() + " por la cantidad de: " + qty.ToString()

                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

                query = "delete from stock where id = " + id_inv.ToString()
                Dataconnect.runquery(query)

            Next

        Else
            lblerrortransit.Text = "No existe inventario en esta locacion"
            transit_inventoryGV.Visible = False
        End If



    End Sub

    Protected Sub productId_TextChanged(sender As Object, e As System.EventArgs) Handles productId.TextChanged
        prod = Replace(productId.Text, "'", "''")
        query = "select location, rack, qty from stock where product_code = '" + prod.ToString() + "' and qty > 0"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            lblinvent.Text = ""
            invGR.Visible = True
            invGR.DataSource = ds
            invGR.DataBind()
        Else
            lblinvent.Text = "Producto sin inventario"
            invGR.Visible = False
        End If
    End Sub
End Class
