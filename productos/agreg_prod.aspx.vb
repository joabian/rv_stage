Imports System.Data
Imports System.Data.SqlClient

Partial Class productos_agreg_prod
    Inherits System.Web.UI.Page

    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public username As String

    Protected Sub save_product_Click(sender As Object, e As System.EventArgs) Handles save_product.Click
        Dim code As String = ""
        Dim description As String = ""
        Dim model As String = ""
        Dim price As Double
        Dim cost As Double
        Dim low_inventory As Integer
        Dim category As Integer
        Dim logevent As String

        username = Membership.GetUser().UserName
        code = Replace(Replace(codeTB.Text, "'", ""), " ", "")
        description = Replace(descriptionTB.Text, "'", "''")
        model = Replace(Replace(modelTB.Text, "'", "''"), " ", "")
        price = priceTB.Text
        cost = costTB.Text
        low_inventory = low_inventoryTB.Text
        category = categoryDD.SelectedValue

        logevent = "Ha creado un nuevo producto en el sistema con codigo: " + code.ToString() + " bajo la categoria de: " + categoryDD.SelectedItem.Text.ToString()

        If code.Contains("(") Or code.Contains(")") Or code.Contains("/") Or code.Contains("=") Or code.Contains("\") Or code.Contains("*") _
            Or code.Contains(":") Or code.Contains(";") Or code.Contains(".") Or code.Contains("[") Or code.Contains("]") Or code.Contains("{") _
            Or code.Contains("}") Or code.Contains("&") Or code.Contains("%") Or code.Contains("$") Or code.Contains("@") Or code.Contains("!") _
            Or code.Contains("^") Or code.Contains("+") Or code.Contains("'") Or code.Contains("""") Or code.Contains("<") Or code.Contains(">") _
            Or code.Contains("?") Or code.Contains(",") _
        Then
            errorlbl.Text = "No se acepta los caracteres especiales: ( ) / = \ * : ; . , [ ] { } & % $ @ ! ^ + ' "" < > ?"
        Else
            query = "SELECT * FROM products WHERE code='" + code.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                errorlbl.Text = "El producto ya existe"
            Else

                query = "INSERT INTO products(code, description, category, price, cost, low_inventory, model, fuera_catalogo, fecha_ingreso,install_distribution_flag"
                query += ") VALUES ('" + code.ToString().ToUpper() + "', '" + description.ToString().ToUpper() + "', " + category.ToString() + ", " + price.ToString()
                query += ", " + cost.ToString() + ", " + low_inventory.ToString() + ", '" + model.ToString().ToUpper() + "',1,getdate(),0)"
                query += " insert into default_locators (code, location, rack) values ('" + code.ToString() + "','HENEQUEN','ALMACEN')"
                query += " insert into default_locators (code, location, rack) values ('" + code.ToString() + "','DURANGO','PB')"

                Dataconnect.runquery(query)

                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

                Response.Redirect("agreg_prod.aspx")
            End If

        End If



    End Sub

    Public Sub clearcontrols()

    End Sub




    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Roles.IsUserInRole("admin") Then
        Else
            Response.Redirect("role_no_access.aspx")
        End If
    End Sub
End Class
