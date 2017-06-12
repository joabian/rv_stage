Imports System.Data
Partial Class productos_buscar_comp
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populate_dd_year()
        End If
    End Sub

    Sub populate_dd_year()
        query = "select distinct year_beg as [year] from models union select distinct year_end as [year] from models"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            lbx_year.DataSource = ds.Tables(0)
            lbx_year.DataValueField = "year"
            lbx_year.DataTextField = "year"
            lbx_year.DataBind()
        Else
            lbx_year.DataSource = Nothing
        End If
    End Sub

    Protected Sub lbx_year_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lbx_year.SelectedIndexChanged
        Dim year As String
        year = lbx_year.SelectedValue.ToString()
        lbx_make.DataSource = Nothing
        query = "select distinct make from models where year_beg <= " + year.ToString() + " and year_end >= " + year.ToString() + " order by make"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            lbx_make.DataSource = ds.Tables(0)
            lbx_make.DataValueField = "make"
            lbx_make.DataTextField = "make"
            lbx_make.DataBind()
        Else
            lbx_make.DataSource = Nothing
        End If


    End Sub

    Protected Sub lbx_make_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lbx_make.SelectedIndexChanged
        Dim make, year As String
        make = lbx_make.SelectedValue.ToString()
        year = lbx_year.SelectedValue.ToString()
        lbx_model.DataSource = Nothing
        query = "select distinct model from models where make = '" + make.ToString() + "' and year_beg <= " + year.ToString() + " and year_end >= " + year.ToString() + "order by model"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            lbx_model.DataSource = ds.Tables(0)
            lbx_model.DataValueField = "model"
            lbx_model.DataTextField = "model"
            lbx_model.DataBind()
        Else
            lbx_model.DataSource = Nothing
        End If
    End Sub

    Protected Sub lbx_model_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lbx_model.SelectedIndexChanged
        Dim model, make, year As String
        model = lbx_model.SelectedValue.ToString()
        make = lbx_make.SelectedValue.ToString()
        year = lbx_year.SelectedValue.ToString()

        query = "select * from models where model = '" + model.ToString() + "' and make = '" + make.ToString() + "' and year_beg <= " + year.ToString() + " and year_end >= " + year.ToString() + "order by model"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            lbl_comp.Text = "Compatibilidad:"
            gv_info.DataSource = ds.Tables(0)
            gv_info.DataBind()
            query = "select distinct convert(varchar, dpi_no) + ' (DPI)' as PROD from models where model = '" + model.ToString() + "' and make = '" + make.ToString() + "' and year_beg <= " + year.ToString() + " and year_end >= " + year.ToString()
            query += " union"
            query += " select distinct convert(varchar, inlet_no) + ' (INL)' from models where model = '" + model.ToString() + "' and make = '" + make.ToString() + "' and year_beg <= " + year.ToString() + " and year_end >= " + year.ToString()
            query += " union"
            query += " select distinct convert(varchar, outlet_no) + ' (OUT)' from models where model = '" + model.ToString() + "' and make = '" + make.ToString() + "' and year_beg <= " + year.ToString() + " and year_end >= " + year.ToString()
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                lbx_dpi.DataSource = ds.Tables(0)
                lbx_dpi.DataValueField = "PROD"
                lbx_dpi.DataTextField = "PROD"
                lbx_dpi.DataBind()
            End If
            'query = "select distinct inlet_no from models where model = '" + model.ToString() + "' and make = '" + make.ToString() + "' and year_beg <= " + year.ToString() + " and year_end >= " + year.ToString()
            'ds = Dataconnect.GetAll(query)
            'If ds.Tables(0).Rows.Count > 0 Then
            '    lbx_inlet.DataSource = ds.Tables(0)
            '    lbx_inlet.DataValueField = "inlet_no"
            '    lbx_inlet.DataTextField = "inlet_no"
            '    lbx_inlet.DataBind()
            'End If
            'query = "select distinct outlet_no from models where model = '" + model.ToString() + "' and make = '" + make.ToString() + "' and year_beg <= " + year.ToString() + " and year_end >= " + year.ToString()
            'ds = Dataconnect.GetAll(query)
            'If ds.Tables(0).Rows.Count > 0 Then
            '    lbx_outlet.DataSource = ds.Tables(0)
            '    lbx_outlet.DataValueField = "outlet_no"
            '    lbx_outlet.DataTextField = "outlet_no"
            '    lbx_outlet.DataBind()
            'End If

        Else
            lbl_comp.Text = ""
            gv_info.DataSource = Nothing
        End If
    End Sub

    Protected Sub btn_reset_Click(sender As Object, e As System.EventArgs) Handles btn_reset.Click
        Response.Redirect("buscar_comp.aspx")
    End Sub

    Protected Sub lbx_dpi_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lbx_dpi.SelectedIndexChanged
        showProductInfo("dpi")
    End Sub

    'Protected Sub lbx_inlet_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lbx_inlet.SelectedIndexChanged
    '    showProductInfo("inlet")
    'End Sub

    'Protected Sub lbx_outlet_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles lbx_outlet.SelectedIndexChanged
    '    showProductInfo("outlet")
    'End Sub

    Sub showProductInfo(ByVal type As String)
        If type = "dpi" Then
            Dim code, categ As String
            Dim prod_name() As String
            prod_name = lbx_dpi.SelectedValue.Split(" ")
            If prod_name.Length > 1 Then
                code = prod_name(0)
                categ = prod_name(1)
            Else
                code = "no-image"
                categ = "(DPI)"
            End If
            

            query = "select description from products where code = '" + code + "'"
            ds = Dataconnect.GetAll(query)
            img_product.ImageUrl = "~/images/tapas/" + code + ".jpg"
            'img_product.ImageUrl = "~/images/dpis/no-image.jpg" 'modificar cuando se tengan las imagenes
            If ds.Tables(0).Rows.Count > 0 Then
                lbl_product_info.Text = "Información del Producto:"
                gv_product_info.DataSource = ds.Tables(0)
                gv_product_info.DataBind()
            Else
                lbl_product_info.Text = "No existe informacion de este producto"
                gv_product_info.DataSource = Nothing
            End If

            query = "select location as Sucursal, rack as Rack, qty as Cantidad from stock where product_code = '" + code + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                If Not User.IsInRole("guest") Then
                    lbl_inventory.Text = "Inventario:"
                    gv_inventory.DataSource = ds.Tables(0)
                    gv_inventory.DataBind()
                End If
                
            Else
                lbl_inventory.Text = ""
                gv_inventory.DataSource = Nothing
            End If
            'ElseIf type = "inlet" Then
            '    query = "select description from products where code = '" + code + "'"
            '    ds = Dataconnect.GetAll(query)
            '    img_product.ImageUrl = "~/images/tapas/" + lbx_inlet.SelectedValue.ToString() + ".jpg"
            '    If ds.Tables(0).Rows.Count > 0 Then
            '        lbl_product_info.Text = "Informacion del Producto:"
            '        gv_product_info.DataSource = ds.Tables(0)
            '        gv_product_info.DataBind()
            '    Else
            '        lbl_product_info.Text = ""
            '        gv_product_info.DataSource = Nothing
            '    End If

            '    query = "select location as Sucursal, rack as Rack, qty as Cantidad from stock where product_code = '" + lbx_inlet.SelectedValue.ToString() + "'"
            '    ds = Dataconnect.GetAll(query)
            '    If ds.Tables(0).Rows.Count > 0 Then
            '        lbl_inventory.Text = "Inventario:"
            '        gv_inventory.DataSource = ds.Tables(0)
            '        gv_inventory.DataBind()
            '    Else
            '        lbl_inventory.Text = ""
            '        gv_inventory.DataSource = Nothing
            '    End If
            'ElseIf type = "outlet" Then
            '    query = "select description from products where code = '" + lbx_outlet.SelectedValue.ToString() + "'"
            '    ds = Dataconnect.GetAll(query)
            '    img_product.ImageUrl = "~/images/tapas/" + lbx_outlet.SelectedValue.ToString() + ".jpg"
            '    If ds.Tables(0).Rows.Count > 0 Then
            '        lbl_product_info.Text = "Informacion del Producto:"
            '        gv_product_info.DataSource = ds.Tables(0)
            '        gv_product_info.DataBind()
            '    Else
            '        lbl_product_info.Text = ""
            '        gv_product_info.DataSource = Nothing
            '    End If

            '    query = "select location as Sucursal, rack as Rack, qty as Cantidad from stock where product_code = '" + lbx_outlet.SelectedValue.ToString() + "'"
            '    ds = Dataconnect.GetAll(query)
            '    If ds.Tables(0).Rows.Count > 0 Then
            '        lbl_inventory.Text = "Inventario:"
            '        gv_inventory.DataSource = ds.Tables(0)
            '        gv_inventory.DataBind()
            '    Else
            '        lbl_inventory.Text = ""
            '        gv_inventory.DataSource = Nothing
            '    End If

        End If

    End Sub
End Class
