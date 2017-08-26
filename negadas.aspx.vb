Imports System.Data

Partial Class negadas
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public logevent As String
    Public username As String

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populate_locations()
            'populate_categories()
            showInfo()
        End If
    End Sub

    Public Sub populate_locations()
        Dim username As String
        Dim location_st As String = "0"
        Dim location_st_name As String = ""
        username = Membership.GetUser().UserName
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
            ddl_location.DataSource = ds.Tables(0)
            ddl_location.DataValueField = "alias"
            ddl_location.DataTextField = "alias"
            ddl_location.DataBind()

        Else
            ddl_location.DataSource = Nothing
            ddl_location.DataBind()

        End If

        If location_st <> "0" Then
            
                ddl_location.SelectedValue = location_st_name

        End If
    End Sub

    'Public Sub populate_categories()
    '    query = "select * from categories order by name"
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        ddl_catego.DataSource = ds.Tables(0)
    '        ddl_catego.DataValueField = "name"
    '        ddl_catego.DataTextField = "name"
    '        ddl_catego.DataBind()
    '    Else
    '        ddl_catego.DataSource = Nothing
    '        ddl_catego.DataBind()
    '    End If
    'End Sub

    Public Sub showInfo()
        Dim code As String = Replace(Request.QueryString("codigo"), " ", "")
        Dim exacta As String = Request.QueryString("exacta")
        
        If Request.QueryString("auto") = Nothing Then
            lbl_report_auto.Visible = False
            btn_return.Visible = False
        Else
            lbl_report_auto.Visible = True
            btn_return.Visible = True
        End If

        If Not IsNothing(Request.QueryString("cantidad")) Then
            tbx_qty.Text = Request.QueryString("cantidad")
        End If

        If Not IsNothing(Request.QueryString("cliente")) Then
            tbx_notas.Text = Request.QueryString("cliente")
        End If

        If Not IsNothing(Request.QueryString("sucursal")) Then
            ddl_location.SelectedValue = Request.QueryString("sucursal")
        End If

        tbx_codigo.Text = code

        query = "select * from products left join categories on products.category = categories.id where code = '" + code.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            tbx_description.Text = ds.Tables(0).Rows(0)("description").ToString()
            'ddl_catego.SelectedValue = ds.Tables(0).Rows(0)("name").ToString()
            hifd_catego.Value = ds.Tables(0).Rows(0)("name").ToString()
            tbx_description.Enabled = False
        Else
            tbx_description.Text = ""
            'ddl_catego.SelectedValue = ""
            btn_save.Enabled = True
            'lbl_error.Text = "Para reportar piezas que no existan comuníquese con su gerente"
        End If

        query = "select product_code as Codigo, location as [Sucursal], rack as [Rack], qty as [Cantidad]"
        query += " from stock "
        query += " left join products on stock.product_code = products.code"
        If exacta = "True" Then
            query += " where product_code = '" + code.ToString() + "' or products.alias = '" + code.ToString() + "' and qty > 0 order by location"
        Else
            query += " where product_code like '%" + code.ToString() + "%' or products.alias like '%" + code.ToString() + "%' and qty > 0 order by location"
        End If

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If Not User.IsInRole("guest") Then
                inventarioGV.Visible = True
                inventarioGV.DataSource = ds.Tables(0)
                inventarioGV.DataBind()
            End If
            
        Else
            inventarioGV.Visible = False
        End If

    End Sub

    Protected Sub btn_save_Click(sender As Object, e As EventArgs) Handles btn_save.Click
        Dim existe, qty_suc, qty_tot, qty_req, catego, desc, notas, loca As String
        
        'If ddl_catego.SelectedValue = "0" Or ddl_location.SelectedValue = "0" Or tbx_description.Text = "" Or tbx_notas.Text = "" Or tbx_qty.Text = "" Then
        '    lbl_error.Text = "Ingrese todos lo datos"

        'Else
        lbl_error.Text = ""
        qty_req = Replace(tbx_qty.Text, "'", "")

        If Not IsNumeric(qty_req) Then
            lbl_error.ForeColor = Drawing.Color.Red
            lbl_error.Text = "Corrija la cantidad"
        Else
            loca = ddl_location.SelectedValue
            catego = hifd_catego.Value.ToString()
            desc = Replace(tbx_description.Text, "'", "")
            notas = Replace(tbx_notas.Text, "'", "")
            If desc = "" Or notas = "" Then
                lbl_error.ForeColor = Drawing.Color.Red
                lbl_error.Text = "ingrese todos los datos"

            Else
                query = "select * from products where code = '" + tbx_codigo.Text + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    existe = "Si"
                    query = "select sum(qty) as tot from stock where product_code = '" + tbx_codigo.Text + "' and location = '" + loca.ToString() + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        qty_suc = ds.Tables(0).Rows(0)("tot").ToString
                    Else
                        qty_suc = "0"
                    End If

                    query = "select sum(qty) as tot from stock where product_code = '" + tbx_codigo.Text + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        qty_tot = ds.Tables(0).Rows(0)("tot").ToString
                    Else
                        qty_tot = "0"
                    End If
                Else
                    existe = "No"
                    qty_suc = "0"
                    qty_tot = "0"
                End If
                username = Membership.GetUser().UserName

                query = "select * from negadas where codigo = '" + tbx_codigo.Text + "'"
                query += " and sucursal = '" + loca.ToString() + "'"
                query += " and usuario = '" + username.ToString() + "'"
                query += " and row_date >= getdate()-0.003472222"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    lbl_error.ForeColor = Drawing.Color.Red
                    lbl_error.Text = "Este producto fue ingresado hace menos de 5 minos, desea ingresarlo de nuevo?"
                    btn_save.Visible = False
                    btn_save_2.Visible = True
                Else
                    btn_save_2.Visible = False
                    query = "insert into negadas (codigo, categoria, descripcion, sucursal, notas, qty_req, qty_suc, qty_tot, existe, usuario, row_date) values ("
                    query += "'" + Replace(tbx_codigo.Text.ToUpper(), " ", "") + "'"
                    query += ",'" + hifd_catego.Value.ToString() + "'"
                    query += ",'" + desc.ToString() + "'"
                    query += ",'" + loca.ToString() + "'"
                    query += ",'" + notas.ToString() + "'"
                    query += ",'" + qty_req.ToString() + "'"
                    query += ",'" + qty_suc.ToString() + "'"
                    query += ",'" + qty_tot.ToString() + "'"
                    query += ",'" + existe.ToString() + "'"
                    query += ",'" + username.ToString() + "'"
                    query += ",getdate())"
                    Dataconnect.runquery(query)

                    lbl_error.ForeColor = Drawing.Color.Green
                    lbl_error.Text = "Datos salvados!"

                End If
            End If
        End If
        
        'End If
    End Sub

    Protected Sub btn_return_Click(sender As Object, e As EventArgs) Handles btn_return.Click
        Response.Redirect("productos/buscar_codigo.aspx")
    End Sub

    Protected Sub btn_save_2_Click(sender As Object, e As EventArgs) Handles btn_save_2.Click
        Dim existe, qty_suc, qty_tot, qty_req, catego, desc, notas, loca As String

        'If ddl_catego.SelectedValue = "0" Or ddl_location.SelectedValue = "0" Or tbx_description.Text = "" Or tbx_notas.Text = "" Or tbx_qty.Text = "" Then
        '    lbl_error.Text = "Ingrese todos lo datos"

        'Else
        lbl_error.Text = ""
        qty_req = Replace(tbx_qty.Text, "'", "")

        If Not IsNumeric(qty_req) Then
            qty_req = "0"
        End If
        loca = ddl_location.SelectedValue
        catego = hifd_catego.Value.ToString()
        desc = Replace(tbx_description.Text, "'", "")
        notas = Replace(tbx_notas.Text, "'", "")
        If desc = "" Or notas = "" Then
            lbl_error.ForeColor = Drawing.Color.Red
            lbl_error.Text = "ingrese todos los datos"

        Else
            query = "select * from products where code = '" + tbx_codigo.Text + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                existe = "Si"
                query = "select sum(qty) as tot from stock where product_code = '" + tbx_codigo.Text + "' and location = '" + loca.ToString() + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    qty_suc = ds.Tables(0).Rows(0)("tot").ToString
                Else
                    qty_suc = "0"
                End If

                query = "select sum(qty) as tot from stock where product_code = '" + tbx_codigo.Text + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    qty_tot = ds.Tables(0).Rows(0)("tot").ToString
                Else
                    qty_tot = "0"
                End If
            Else
                existe = "No"
                qty_suc = "0"
                qty_tot = "0"
            End If
            username = Membership.GetUser().UserName

            query = "insert into negadas (codigo, categoria, descripcion, sucursal, notas, qty_req, qty_suc, qty_tot, existe, usuario, row_date) values ("
            query += "'" + Replace(tbx_codigo.Text.ToUpper(), " ", "") + "'"
            query += ",'" + catego.ToString() + "'"
            query += ",'" + desc.ToString() + "'"
            query += ",'" + loca.ToString() + "'"
            query += ",'" + notas.ToString() + " (se reporto en menos de 5 min)'"
            query += ",'" + qty_req.ToString() + "'"
            query += ",'" + qty_suc.ToString() + "'"
            query += ",'" + qty_tot.ToString() + "'"
            query += ",'" + existe.ToString() + "'"
            query += ",'" + username.ToString() + "'"
            query += ",getdate())"
            Dataconnect.runquery(query)

            lbl_error.ForeColor = Drawing.Color.Green
            lbl_error.Text = "Datos salvados!"

            btn_save_2.Visible = False
            btn_save.Visible = True

        End If
        
        'End If
    End Sub
End Class
