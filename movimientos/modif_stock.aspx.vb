Imports System.Data

Partial Class reportes_modif_stock
    Inherits System.Web.UI.Page
    Public username As String
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub save_qty_Click(sender As Object, e As System.EventArgs) Handles save_qty.Click
        Dim qty As Integer
        Dim logevent As String
        Dim product As String
        Dim loc As String
        Dim rack As String
        Dim comm As String

        rack = rack_id.Text
        product = Replace(Replace(product_id.Text, "'", "").ToString().ToUpper(), " ", "")
        loc = location.SelectedValue.ToString()
        username = Membership.GetUser().UserName
        comm = Replace(txb_comment.Text, "'", "''")

        qty = Replace(new_qtyTB.Text, "'", "''")

        logevent = "modificcion manual del inventario de: " + loc.ToString() + ", en rack: " + rack.ToString() + " por la cantidad de: " + qty.ToString()

        query = "select * from products where code = '" + product.ToString() + "'"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 And qty >= 0 Then
            Try
                query = "Update stock set qty = " + qty.ToString() + ", last_update = getDate() where product_code = '" + product.ToString() + "' and location = '" + loc.ToString() + "' and rack = '" + rack.ToString() + "'"
                query += " delete from stock where qty <= 0"
                Dataconnect.runquery(query)
            Catch ex As Exception
                Response.Write(ex)
            End Try
            Try
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)
            Catch ex As Exception
                Response.Write(ex)
            End Try
            Try
                query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (1, '" + product.ToString() + "', 'Ajuste', 'Ajuste', '" + comm.ToString() + "', '" + loc.ToString() + "', '" + rack.ToString() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
                Dataconnect.runquery(query)

            Catch ex As Exception
                Response.Write(ex)
            End Try

            lblerror.ForeColor = Drawing.Color.Green
            lblerror.Text = "Los cambios fueron completados"

            'Response.Redirect("modif_stock.aspx")
        Else
            lblerror.Text = "Verifique la informacion, el producto no esta en nuestra base de datos o la cantidad es invalida"
        End If


    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Response.Redirect("entries.aspx")

        If IsPostBack Then
            Dim prod As String
            prod = Replace(product_id.Text, "'", "''").ToString()

            inventoryGV.Visible = False

            query = "select location, rack, qty from stock where product_code = '" + prod.ToString() + "' order by qty desc"
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                inventoryGV.Visible = True
                inventoryGV.DataSource = ds
                inventoryGV.DataBind()
            End If

        Else
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
                    location.DataSource = ds.Tables(0)
                    location.DataValueField = "alias"
                    location.DataTextField = "alias"
                    location.DataBind()
                Else
                    location.DataSource = Nothing
                    location.DataBind()
                End If
            End If
        End If

    End Sub


End Class
