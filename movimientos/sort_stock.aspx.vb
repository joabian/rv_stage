Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports GemBox.Spreadsheet

Partial Class movimientos_sort_stock
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public logevent As String
    Public username As String = Membership.GetUser().UserName


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populateLocation()
        End If
    End Sub

    Public Sub populateLocation()
        Dim location_st As String = "0"
        Dim location_st_name As String = ""

        query = "select location, alias from users left join locations on users.location = locations.id where user_name = '" + username + "' "
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st_name = ds.Tables(0).Rows(0)("alias").ToString()
            location_st = ds.Tables(0).Rows(0)("location").ToString()
            If location_st = "0" Then
                query = "select alias from locations"
            Else
                query = "select alias from locations where id = " + location_st.ToString()
            End If
        End If

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ddl_from_location.DataSource = ds.Tables(0)
            ddl_from_location.DataValueField = "alias"
            ddl_from_location.DataTextField = "alias"
            ddl_from_location.DataBind()

        Else
            ddl_from_location.DataSource = Nothing
            ddl_from_location.DataBind()

        End If

        If location_st <> "0" Then
            ddl_from_location.SelectedValue = location_st_name
            hifd_location.Value = location_st_name
            CreateTable(location_st_name)
        End If
    End Sub

    Public Sub CreateTable(ByVal location_st_name As String)
        query = "select id, product_code, product_description, qty, convert(varchar, last_update, 101) as fecha, from_location from stock where location = '" + location_st_name.ToString() + "' and rack = 'Temporal'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim myhtmltable As String = ""
            myhtmltable = "<table style='border-collapse:collapse;border:solid 1px black;' border=1 align='center'><tr><th>De Sucursal</th><th>Fecha</th><th>Código</th><th>Descripción</th><th>Cantidad</th><th><b>Nuevo Rack</b></th></tr>"
            For i = 0 To ds.Tables(0).Rows.Count - 1
                Dim stockid As String = ds.Tables(0).Rows(i)("id").ToString()
                myhtmltable += "<tr>"
                myhtmltable += "<td align='center'>" + ds.Tables(0).Rows(i)("from_location").ToString() + "</td>"
                myhtmltable += "<td align='center'>" + ds.Tables(0).Rows(i)("fecha").ToString() + "</td>"
                myhtmltable += "<td align='center'>" + ds.Tables(0).Rows(i)("product_code").ToString() + "</td>"
                myhtmltable += "<td align='center'>" + ds.Tables(0).Rows(i)("product_description").ToString() + "</td>"
                myhtmltable += "<td align='center'>" + ds.Tables(0).Rows(i)("qty").ToString() + "</td>"
                'myhtmltable += "<td><input type='button' value='Asignar' onclick='reasignar(" + stockid.ToString() + ");' /></td>"
                myhtmltable += "<td><input id='tb_" + stockid.ToString() + "' name='tb_" + stockid.ToString() + "' type='text' size='5' /></td>"

                myhtmltable += "</tr>"
            Next
            myhtmltable += "</table>"
            lbl_table.Text = myhtmltable
        Else
            lbl_table.Text = "No existen piezas en rack temporal para reasignar"
        End If
    End Sub

    Protected Sub btn_save_Click(sender As Object, e As EventArgs) Handles btn_save.Click
        'Dim value As String = Request.Form("tb_test")
        'Dim value2 As String = Request.Form("tb_test2")


        'If Not IsNothing(value2) Then
        '    lbl_table.Text = "entre"
        'Else
        '    lbl_table.Text = "mp emtr"

        'End If
        query = "select id, product_code, product_description, qty from stock where location = '" + hifd_location.Value.ToString() + "' and rack = 'Temporal'"

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            For i = 0 To ds.Tables(0).Rows.Count - 1
                Dim stockid As String = ds.Tables(0).Rows(i)("id").ToString()
                Dim product_code As String = Replace(ds.Tables(0).Rows(i)("product_code").ToString(), " ", "")
                Dim qty As String = ds.Tables(0).Rows(i)("qty").ToString()
                Dim rack As String = Request.Form("tb_" + stockid.ToString())
                If Not IsNothing(rack) Then
                    If rack <> "" Then
                        query = "select * from stock where rack = '" + rack.ToString() + "' and product_code = '" + product_code.ToString() + "' and location = '" + hifd_location.Value.ToString() + "'"
                        Dim newds As DataSet
                        newds = Dataconnect.GetAll(query)
                        If newds.Tables(0).Rows.Count > 0 Then
                            Dim newstokiId As String = newds.Tables(0).Rows(0)("id").ToString()
                            query = "update stock set qty = (qty + " + qty.ToString() + ") where id = " + newstokiId.ToString()
                            query += " delete from stock where id = " + stockid.ToString()
                        Else
                            query = "update stock set rack = '" + rack.ToString() + "' where id = " + stockid.ToString()
                        End If

                        query += " insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (0, '" + product_code.ToString().ToUpper() + "', 'TRANSFERENCIA', 'ENTRADA'"
                        query += ",'Transferencia entre sucursales', '" + hifd_location.Value.ToString().ToUpper() + "'"
                        query += ",'Temporal', '" + Membership.GetUser().UserName.ToString() + "', getDate(), " + qty.ToString() + ")"
                        Dataconnect.runquery(query)

                        logevent = "Transferencia interna de producto: " + product_code.ToString() + " de la sucursal: " + hifd_location.Value.ToString() + " de rack Temporal al rack: " + rack.ToString()
                        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                        Dataconnect.runquery(queryLog)


                    End If
                End If
            Next
            CreateTable(hifd_location.Value.ToString())
        Else
            lbl_table.Text = "No existen piezas en rack temporal para reasignar"
        End If
    End Sub

    'Public Sub populateGV()
    '    query = "select stock.id, stock.product_code, stock.product_description, stock.product_category, stock.location, loc.rack,"
    '    query += " stock.qty from stock left join (select product_code, rack, location from stock where rack <> 't' and rack <> 'tran')loc on loc.product_code = stock.product_code"
    '    query += " and loc.location = stock.location where stock.rack = 'Temporal' order by stock.location, loc.rack"
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        GV_tranfers.DataSource = ds.Tables(0)
    '        GV_tranfers.DataBind()
    '    Else
    '        LBL_error.text = "No existen transferencias por acomodar"
    '    End If
    'End Sub

    'Protected Sub GV_tranfers_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GV_tranfers.RowCreated
    '    e.Row.Cells(0).Visible = False
    'End Sub

    'Protected Sub GV_tranfers_RowCancelingEdit(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCancelEditEventArgs) Handles GV_tranfers.RowCancelingEdit
    '    GV_tranfers.EditIndex = -1
    '    populateGV()
    'End Sub

    'Protected Sub GV_tranfers_RowEditing(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewEditEventArgs) Handles GV_tranfers.RowEditing
    '    GV_tranfers.EditIndex = e.NewEditIndex
    '    populateGV()
    'End Sub

    'Protected Sub GV_tranfers_RowUpdating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewUpdateEventArgs) Handles GV_tranfers.RowUpdating
    '    Dim strIdInv As String = (CType((GV_tranfers.Rows(e.RowIndex).Cells(0).Controls(1)), Label)).Text
    '    Dim strProCode As String = (CType((GV_tranfers.Rows(e.RowIndex).Cells(1).Controls(1)), Label)).Text
    '    Dim strLocation As String = (CType((GV_tranfers.Rows(e.RowIndex).Cells(4).Controls(1)), Label)).Text
    '    Dim strRack As String = (CType((GV_tranfers.Rows(e.RowIndex).Cells(5).Controls(1)), TextBox)).Text
    '    Dim intQty As Integer = (CType((GV_tranfers.Rows(e.RowIndex).Cells(6).Controls(1)), TextBox)).Text

    '    If intQty > 0 And strRack <> "tran" Then
    '        Dim intTransQty As Integer
    '        Dim intVerQty As Integer

    '        query = "select qty from stock where id = " + strIdInv.ToString()
    '        ds = Dataconnect.GetAll(query)
    '        intTransQty = ds.Tables(0).Rows(0)("qty")
    '        intVerQty = intTransQty - intQty
    '        If intVerQty < 0 Then
    '            LBL_error.Text = "Verifique la cantidad proporcionada, no puede recibir mas de lo que llega"
    '        Else
    '            Dim intNewQty As Integer
    '            query = "select * from stock where product_code = '" + strProCode.ToString() + "' and location = '" + strLocation.ToString() + "' and rack = '" + strRack.ToString() + "'"
    '            ds = Dataconnect.GetAll(query)
    '            If ds.Tables(0).Rows.Count > 0 Then
    '                Dim intOldQty As Integer = ds.Tables(0).Rows(0)("qty")

    '                intNewQty = intOldQty + intQty
    '                query = "update stock set qty = " + intNewQty.ToString() + " where product_code = '" + strProCode.ToString() + "' and location = '" + strLocation.ToString() + "' and rack = '" + strRack.ToString() + "'"
    '                Dataconnect.runquery(query)

    '                logevent = "Transferencia recibida del producto: " + strProCode.ToString() + ", en sucursal: " + strLocation.ToString() + " y rack: " + strRack.ToString() + " por la cantidad de " + intQty.ToString() + ", dejando el inventario con " + intNewQty.ToString() + " items"
    '                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
    '                Dataconnect.runquery(queryLog)

    '            Else
    '                query = "insert into stock select products.id, products.code, products.description, products.model, products.low_inventory, categories.name, " + intQty.ToString() + ", '" + strLocation.ToString() + "', getDate(), '" + strRack.ToString() + "' from products inner join categories on products.category = categories.id where products.code = '" + strProCode.ToString() + "'"
    '                Dataconnect.runquery(query)

    '                logevent = "Transferencia recibida del producto: " + strProCode.ToString() + ", en sucursal: " + strLocation.ToString() + " y rack: " + strRack.ToString() + " por la cantidad de " + intQty.ToString() + ", dejando el inventario con " + intQty.ToString() + " items"

    '                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
    '                Dataconnect.runquery(queryLog)
    '            End If

    '            If intVerQty <= 0 Then
    '                query = "delete from stock where id = " + strIdInv.ToString()
    '                Dataconnect.runquery(query)

    '            Else
    '                query = "update stock set qty = " + intVerQty.ToString() + " where id = " + strIdInv.ToString()
    '                Dataconnect.runquery(query)

    '            End If
    '            Response.Redirect("sort_stock.aspx")
    '        End If

    '    Else
    '        LBL_error.Text = "Verifique los datos proporcionados"
    '    End If

    'End Sub


    Protected Sub ddl_from_location_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_from_location.SelectedIndexChanged
        If ddl_from_location.SelectedValue = "0" Then
            lbl_table.Text = ""
            LBL_error.Text = "Seleccione Sucursal"
        Else
            hifd_location.Value = ddl_from_location.SelectedValue
            CreateTable(ddl_from_location.SelectedValue)
        End If
    End Sub


End Class
