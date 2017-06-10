Imports System.Data

Partial Class add_to_stock
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Public username As String
    Public product_id As Integer
    Public location As String
    Public exist As String

    Protected Sub save_stock_Click(sender As Object, e As System.EventArgs) Handles save_stock.Click
        Dim code As String = ""
        Dim description As String = ""
        Dim model As String = ""
        Dim low_inventory As Integer
        Dim category As String
        Dim logevent As String

        Dim qty As Integer
        username = Membership.GetUser().UserName
        product_id = productDDL.SelectedValue
        code = productDDL.SelectedItem.Text.ToString().ToUpper()
        category = categoryDDL.SelectedItem.Text.ToString()
        location = locationDDL.SelectedItem.Text.ToString()
        qty = quantityTB.Text
        logevent = "Ingreso un nuevo producto al inventario de la sucursal: " + location.ToString().ToUpper() + ", producto: " + code.ToString().ToUpper() + ", categoria: " + categoryDDL.SelectedItem.Text.ToString().ToUpper() + ", cantidad: " + qty.ToString()


        VerifyStock()

        If exist = "No" Then

            query = "select * from products where id = " + product_id.ToString()
            ds = Dataconnect.GetAll(query)

            description = ds.Tables(0).Rows(0)("description").ToString()
            low_inventory = ds.Tables(0).Rows(0)("low_inventory").ToString()
            model = ds.Tables(0).Rows(0)("model").ToString()

            Try
                query = "INSERT INTO stock(product_id, product_code, product_description, product_model, product_low_inventory, product_category, qty, location, last_update"
                query = query + ",location_id) VALUES (" + product_id.ToString().ToUpper() + ", '" + code.ToString().ToUpper() + "', '" + description.ToString().ToUpper() + "', '" + model.ToString().ToUpper()
                query = query + "', " + low_inventory.ToString() + ", '" + category.ToString().ToUpper() + "', " + qty.ToString() + ", '" + location.ToString().ToUpper() + "', getDate(), " + locationDDL.SelectedValue.ToString().ToUpper() + ")"
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

            Response.Redirect("add_to_stock.aspx")
        Else
            errorLB.Text = "El producto ya existe en esta sucursal, si necesita modificar el inventario dirijase a la seccion de movimientos"
        End If



    End Sub

    Function VerifyStock() As String


        query = "select id from stock where product_id = " + product_id.ToString() + " and location = '" + location.ToString() + "'"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            exist = "yes"
        Else
            exist = "No"
        End If

        Return exist

    End Function

End Class