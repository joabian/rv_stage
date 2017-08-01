Imports System.Data

Partial Class productos_buscar_codigo
    Inherits System.Web.UI.Page
    Public query As String
    Public queryalias As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub gv_compativilidad_RowCreated(sender As Object, e As GridViewRowEventArgs) Handles gv_compativilidad.RowCreated
        e.Row.Cells(0).Visible = False
    End Sub

    Protected Sub inventarioGV_RowDataBound(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles inventarioGV.RowDataBound
        Dim sucursal As String
        sucursal = UCase(e.Row.Cells(4).Text)

        Select Case sucursal
            Case "HENEQUEN"
                e.Row.Cells(4).Style("background-color") = "orange"
                e.Row.Cells(4).Style("color") = "white"
            Case "VALENTIN"
                e.Row.Cells(4).Style("background-color") = "blue"
                e.Row.Cells(4).Style("color") = "white"
            Case "GOMEZ MORIN"
                e.Row.Cells(4).Style("background-color") = "yellow"
            Case "TORREON"
                e.Row.Cells(4).Style("background-color") = "green"
                e.Row.Cells(4).Style("color") = "white"
            Case "DURANGO"
                e.Row.Cells(4).Style("background-color") = "red"
                e.Row.Cells(4).Style("color") = "white"
            Case "LEON"
                e.Row.Cells(4).Style("background-color") = "black"
                e.Row.Cells(4).Style("color") = "white"
        End Select

    End Sub


    Protected Sub gv_compativilidad_RowDataBound(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_compativilidad.RowDataBound
        Dim dpi_no, inlet_no, outlet_no As String
        dpi_no = e.Row.Cells(8).Text
        inlet_no = e.Row.Cells(9).Text
        outlet_no = e.Row.Cells(10).Text
        If dpi_no <> "dpi_no" Then

            If dpi_no <> "&nbsp;" Then
                Dim Location As String = ResolveUrl("~/productos/ProductsforModelDetails.aspx") & "?dpi_no=" & dpi_no & "&inlet_no=" & inlet_no & "&outlet_no=" & outlet_no
                e.Row.Cells(11).Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
                e.Row.Cells(11).Style("cursor") = "pointer"
                e.Row.Cells(11).Style("color") = "blue"
                'e.Row.Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
                'e.Row.Style("cursor") = "pointer"
            End If
            
        Else

        End If

    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        
    End Sub

    Protected Sub btn_search_Click(sender As Object, e As EventArgs) Handles btn_search.Click
        If codigo.Text = "" Then
            lbl_error.Text = "Ingrese código"
        Else
            lbl_error.Text = ""
            search(codigo.Text)
        End If
    End Sub

    Public Sub search(ByVal cod As String)
        Dim myalias As String()
        Dim aliaslistExac As String = ""
        Dim aliaslistLike As String = ""
        Dim dpi_noListExac As String = ""
        Dim inletListExac As String = ""
        Dim outletListExac As String = ""
        Dim dpi_noListLike As String = ""
        Dim inletListLike As String = ""
        Dim outletListLike As String = ""
        Dim aliaslistExac2 As String = ""
        Dim aliaslistLike2 As String = ""


        queryalias = "select alias from products where alias is not null and code = '" + cod.ToString() + "'"
        ds = Dataconnect.GetAll(queryalias)
        If ds.Tables(0).Rows.Count > 0 Then
            myalias = Split(ds.Tables(0).Rows(0)("alias"), ",")
            For i = 0 To myalias.Length - 1

                aliaslistExac += " or product_code = '" + myalias(i).ToString() + "'"
                aliaslistExac2 += " or code = '" + myalias(i).ToString() + "'"
                dpi_noListExac = "or dpi_no = '" + myalias(i).ToString() + "'"
                inletListExac = "or inlet_no = '" + myalias(i).ToString() + "'"
                outletListExac = "or outlet_no = '" + myalias(i).ToString() + "'"

                aliaslistLike += " or product_code like '%" + myalias(i).ToString() + "%'"
                aliaslistLike2 += " or code like '%" + myalias(i).ToString() + "%'"
                dpi_noListLike += " or dpi_no like '%" + myalias(i).ToString() + "%'"
                inletListLike += " or inlet_no like '%" + myalias(i).ToString() + "%'"
                outletListLike += " or outlet_no like '%" + myalias(i).ToString() + "%'"

            Next
        End If

        query = "select sum(qty) as qty "
        query += " from stock "
        query += " left join products on products.code = stock.product_code"

        If chbx_busq_exacta.Checked = True Then

            query += " where (product_code = '" + cod.ToString() + "' "
            If aliaslistExac <> "" Then
                query += aliaslistExac
            End If
            query += " or alias like '%" + cod.ToString() + "%') and location <> 'PEDIDO'"
        Else
            query += " where (product_code like '%" + cod.ToString() + "%' "
            If aliaslistLike <> "" Then
                query += aliaslistLike
            End If
            query += " or alias like '%" + cod.ToString() + "%') and location <> 'PEDIDO'"
        End If
        If Not User.IsInRole("guest") Then
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                lbl_total.ForeColor = Drawing.Color.Blue
                lbl_total.Text = ds.Tables(0).Rows(0)("qty").ToString()
            Else
                lbl_total.ForeColor = Drawing.Color.Red
                lbl_total.Text = "0"
            End If
        End If
        
        Dim username, precios, location As String
        username = Membership.GetUser().UserName

        query = "select precios, alias from users "
        query += " left join locations on users.location = locations.id"
        query += " where user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            precios = ds.Tables(0).Rows(0)("precios").ToString()
            location = ds.Tables(0).Rows(0)("alias").ToString()
        Else
            precios = ""
            location = ""
        End If

        query = "select code as [Código], description as [Decripción], model as [Modelo],low_inventory as [Mínimo], categories.name as [Categoría]"
        query += precios
        query += " from products "
        query += " inner join categories on products.category = categories.id"

        If chbx_busq_exacta.Checked = True Then
            query += " where (code = '" + cod.ToString() + "' "
            If aliaslistExac2 <> "" Then
                query += aliaslistExac2
            End If
            query += " or alias like '%" + cod.ToString() + "%')"

        Else
            query += " where (code like '%" + cod.ToString() + "%' "
            If aliaslistLike2 <> "" Then
                query += aliaslistLike2
            End If

            query += " or alias like '%" + cod.ToString() + "%')"


        End If

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            gv_general_info.DataSource = ds.Tables(0)
            gv_general_info.DataBind()

        Else
            gv_general_info.DataSource = Nothing
            gv_general_info.DataBind()
        End If

        query = "select product_code as [Código], products.description as [Decripción], product_category as [Categoría], qty as [Cantidad], "
        query += " location as [Sucursal], rack as [Rack] " + precios + " from stock "
        query += " left join products on stock.product_code = products.code"

        If chbx_busq_exacta.Checked = True Then
            query += " where (product_code = '" + cod.ToString() + "' "
            If aliaslistExac <> "" Then
                query += aliaslistExac
            End If
            query += " or products.alias like '%" + cod.ToString() + "%') and qty > 0 order by location"

        Else
            query += " where (product_code like '%" + cod.ToString() + "%' "
            If aliaslistLike <> "" Then
                query += aliaslistLike
            End If

            query += " or products.alias like '%" + cod.ToString() + "%') and qty > 0 order by location"


        End If

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If Not User.IsInRole("guest") Then
                inventarioGV.Visible = True
                inventarioGV.DataSource = ds.Tables(0)
                inventarioGV.DataBind()
                lblinvent.Text = ""

                'comentado por la funcionalidad de negadas (rquiere diseno)
                If location <> "" Then
                    If location = "HENEQUEN" Or location = "VALENTIN" Then
                        query = "select * "
                        query += " from stock "
                        query += " left join products on stock.product_code = products.code"

                        If chbx_busq_exacta.Checked = True Then
                            query += " where (location in ('HENEQUEN','VALENTIN')) and (product_code = '" + cod.ToString() + "' "
                            If aliaslistExac <> "" Then
                                query += aliaslistExac
                            End If
                            query += " or products.alias like '%" + cod.ToString() + "%') and qty > 0 "
                        Else
                            query += " where (location in ('HENEQUEN','VALENTIN')) and (product_code like '%" + cod.ToString() + "%' "
                            If aliaslistLike <> "" Then
                                query += aliaslistLike
                            End If
                            query += " or products.alias like '%" + cod.ToString() + "%') and qty > 0 "
                        End If

                        ds = Dataconnect.GetAll(query)
                        If ds.Tables(0).Rows.Count = 0 Then
                            ScriptManager.RegisterStartupScript(Page, Page.GetType(), Page.ClientID, "show_negadas('" + chbx_busq_exacta.Checked.ToString() + "')", True)
                        End If
                    Else
                        query = "select * "
                        query += " from stock "
                        query += " left join products on stock.product_code = products.code"
                        If chbx_busq_exacta.Checked = True Then
                            query += " where (location = '" + location.ToString() + "') and (product_code = '" + cod.ToString() + "' "
                            If aliaslistExac <> "" Then
                                query += aliaslistExac
                            End If
                            query += " or products.alias like '%" + cod.ToString() + "%') and qty > 0 "
                        Else
                            query += " where (location = '" + location.ToString() + "') and (product_code like '%" + cod.ToString() + "%' "
                            If aliaslistLike <> "" Then
                                query += aliaslistLike
                            End If
                            query += " or products.alias like '%" + cod.ToString() + "%') and qty > 0 "
                        End If

                        ds = Dataconnect.GetAll(query)
                        If ds.Tables(0).Rows.Count = 0 Then
                            ScriptManager.RegisterStartupScript(Page, Page.GetType(), Page.ClientID, "show_negadas('" + chbx_busq_exacta.Checked.ToString() + "')", True)
                        End If
                    End If


                End If
            Else
                lbl_tot_piezas.Visible = False
                lbl_inv.Visible = False
            End If
            

        Else
            If chbx_busq_exacta.Checked = True Then
                query = "select * from products where code = '" + cod.ToString() + "' or alias like '%" + cod.ToString() + "%'"
            Else
                query = "select * from products where code like '%" + cod.ToString() + "%' or alias like '%" + cod.ToString() + "%'"
            End If

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                If Not User.IsInRole("guest") Then
                    inventarioGV.Visible = True
                    inventarioGV.DataSource = Nothing
                    inventarioGV.DataBind()
                    lblinvent.Text = "Este producto si lo manejamos pero no hay en existencia"
                Else
                    lbl_tot_piezas.Visible = False
                    lbl_inv.Visible = False
                End If
                
            Else
                inventarioGV.Visible = False
                inventarioGV.DataSource = Nothing
                inventarioGV.DataBind()
                lblinvent.Text = "Este producto no lo manejamos"
                Response.Redirect("../negadas.aspx?codigo=" + cod.ToString() + "&auto=Si&exacta=True")
            End If

        End If

        query = "select models.id, models.year_beg,models.year_end,models.make,models.model,models.ltr,models.cyl,models.remark,models.dpi_no,models.inlet_no,models.outlet_no, 'ver detalles' as link from models "
        query += " left join products dpi on dpi.code = models.dpi_no"
        query += " left join products inlet on inlet.code = models.inlet_no"
        query += " left join products outlet on outlet.code = models.outlet_no"

        If chbx_busq_exacta.Checked = True Then
            query += " where dpi_no = '" + codigo.Text + "' or inlet_no = '" + codigo.Text + "' or outlet_no = '" + codigo.Text + "' "
            If dpi_noListExac <> "" Then
                query += dpi_noListExac + inletListExac + outletListExac
            End If

            query += " or dpi.alias = '" + codigo.Text + "' or inlet.alias = '" + codigo.Text + "' or outlet.alias = '" + codigo.Text + "'"

        Else
            query += " where dpi_no like '%" + codigo.Text + "%' or inlet_no like '%" + codigo.Text + "%' or outlet_no like '%" + codigo.Text + "%' "
            If dpi_noListLike <> "" Then
                query += dpi_noListLike + inletListLike + outletListLike
            End If

            query += " or dpi.alias like '%" + codigo.Text + "%' or inlet.alias like '%" + codigo.Text + "%' or outlet.alias like '%" + codigo.Text + "%'"

        End If
        query += "order by make, model"

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            gv_compativilidad.DataSource = ds.Tables(0)
            gv_compativilidad.DataBind()
            lbl_compatibilidad.Text = ""
        Else
            gv_compativilidad.DataSource = Nothing
            gv_compativilidad.DataBind()
            lbl_compatibilidad.Text = "Este producto no es compatible con ningún auto de la base de datos"
        End If

        showImage(cod)

    End Sub

    Public Sub showImage(ByVal code As String)
        Dim HTML_IMG As String = ""
        Dim dsAlias As DataSet
        Dim myalias As String()
        Dim mycode As String
        Dim myCodeList As List(Of String) = New List(Of String)


        'imagen directa:
        myCodeList.Add(code)

        'alias de producto
        queryalias = "select alias from products where alias is not null and code = '" + code.ToString() + "'"
        ds = Dataconnect.GetAll(queryalias)
        If ds.Tables(0).Rows.Count > 0 Then
            myalias = Split(ds.Tables(0).Rows(0)("alias"), ",")
            For i = 0 To myalias.Length - 1
                myCodeList.Add(myalias(i).ToString())
            Next
        End If

        'parent de producto
        queryalias = "select code from products where code <> '" + code.ToString() + "' and alias like '%" + code.ToString() + "%'"
        ds = Dataconnect.GetAll(queryalias)
        If ds.Tables(0).Rows.Count > 0 Then
            For j = 0 To ds.Tables(0).Rows.Count - 1
                mycode = ds.Tables(0).Rows(j)(0).ToString()
                queryalias = "select alias from products where code = '" + mycode + "'"
                dsAlias = Dataconnect.GetAll(queryalias)
                If dsAlias.Tables(0).Rows.Count > 0 Then
                    myalias = Split(dsAlias.Tables(0).Rows(0)("alias"), ",")
                    For m = 0 To myalias.Length - 1
                        If myalias(m).ToString() = code.ToString() Then
                            myCodeList.Add(mycode)
                        End If
                    Next
                End If
            Next
        End If

        Dim result As List(Of String) = myCodeList.Distinct().ToList

        For Each element As String In result
            HTML_IMG += "<div style='float:right'> <b>" + element.ToUpper() + "</b> <img style='height:150px' src='../images/tapas/" + element.ToUpper() + ".jpg' /></div>"
        Next

        imgs.Text = HTML_IMG
    End Sub

End Class
