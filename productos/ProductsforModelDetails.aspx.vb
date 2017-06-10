Imports System.Data
Partial Class productos_ProductsforModelDetails
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    'Protected Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init


    '    'query = "select * from stock where product_code = '" + Request.QueryString("dpi_no").ToString() + "' order by qty desc"
    '    'ds = Dataconnect.GetAll(query)
    '    'dpiInventoryGV.DataBind()

    '    'query = "select * from stock where product_code = '" + Request.QueryString("inlet_no").ToString() + "' order by qty desc"
    '    'ds = Dataconnect.GetAll(query)
    '    'inletInventoryGV.DataBind()

    '    'query = "select * from stock where product_code = '" + Request.QueryString("outlet_no").ToString() + "' order by qty desc"
    '    'ds = Dataconnect.GetAll(query)
    '    'outletInventoryGV.DataBind()

    'End Sub



    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Len(Request.QueryString("dpi_no")) = 0 Or Len(Request.QueryString("inlet_no")) = 0 Or Len(Request.QueryString("outlet_no")) = 0 Then
            lblMessage1.Visible = True
            lblMessage1.Text = "One or more fields were not found in the QueryString collection!"
        Else
            dpi_img.ImageUrl = "~/images/tapas/" & Request.QueryString("dpi_no").ToString() & ".jpg" 'modificar cuando se tengan las imagenes
            inlet_img.ImageUrl = "~/images/tapas/" & Request.QueryString("inlet_no").ToString() & ".jpg"
            outlet_img.ImageUrl = "~/images/tapas/" & Request.QueryString("outlet_no") & ".jpg"

            hifd_dpi.Value = Request.QueryString("dpi_no").ToString()
            hifd_inlet.Value = Request.QueryString("inlet_no").ToString()
            hifd_outlet.Value = Request.QueryString("outlet_no").ToString()

            showInfo()

        End If
    End Sub

    Public Sub showInfo()

        query = "select description from products where code = '" + hifd_dpi.Value.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then

            dpiGV.DataSource = ds.Tables(0)
            dpiGV.DataBind()


        Else
            dpiGV.Visible = False
        End If

        query = "select location,rack,qty from stock where product_code = '" + hifd_dpi.Value.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If Not User.IsInRole("guest") Then
                lbl_inv3.Visible = True
                dpiInventoryGV.DataSource = ds.Tables(0)
                dpiInventoryGV.DataBind()
            End If
        Else
            dpiInventoryGV.Visible = False
        End If


        query = "select description from products where code = '" + hifd_inlet.Value.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then

            inletGV.DataSource = ds.Tables(0)
            inletGV.DataBind()

        Else
            inletGV.Visible = False
        End If

        query = "select location,rack,qty from stock where product_code = '" + hifd_inlet.Value.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If Not User.IsInRole("guest") Then
                lbl_inv1.Visible = True
                inletInventoryGV.DataSource = ds.Tables(0)
                inletInventoryGV.DataBind()
            End If
        Else
            inletInventoryGV.Visible = False
        End If

        query = "select description from products where code = '" + hifd_outlet.Value.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            outletGV.DataSource = ds.Tables(0)
            outletGV.DataBind()
        Else
            outletGV.Visible = False
        End If

        query = "select location,rack,qty from stock where product_code = '" + hifd_outlet.Value.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If Not User.IsInRole("guest") Then
                lbl_inv2.Visible = True
                outletInventoryGV.DataSource = ds.Tables(0)
                outletInventoryGV.DataBind()
            End If
            
        Else
            outletInventoryGV.Visible = False
        End If

    End Sub

End Class
