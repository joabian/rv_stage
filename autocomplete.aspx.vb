Imports System.Data
Partial Class autocomplete
    Inherits System.Web.UI.Page

    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Public SearchText As String
    Public OP As String
    Public ID As String
    Public tpl As String
    Public text As String

    Protected Sub Page_PreInit(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreInit
        _REQUEST()

        If OP = "Codigo" Then SearchCodigo()
        If OP = "Cliente" Then SearchCliente()
        If OP = "Vendedor" Then SearchVendedor()
        If OP = "Sucursal" Then SearchSucursal()

    End Sub

    Protected Sub _REQUEST()
        OP = Request.QueryString("op")
        ID = Request.QueryString("id_element")
        SearchText = Request.QueryString("q")
    End Sub

    Protected Sub SearchVendedor()
        Dim location_st As String = ""
        Dim username As String = Membership.GetUser().UserName
        query = "select location from users where user_name = '" + username + "' "
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If ds.Tables(0).Rows(0)("location") <> "0" Then
                location_st = " and location = " + ds.Tables(0).Rows(0)("location").ToString()
            End If
        End If

        query = "select top 15 *, name + ' ' + last_name as emp from employees "
        query += " where position = 'vendedor' and active = 1 and (name LIKE '%" + SearchText.ToString() + "%' or last_name like '%" + SearchText.ToString()
        query += "%') " + location_st.ToString() + " order by name"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            For i As Integer = 0 To ds.Tables(0).Rows.Count - 1
                Response.Write(rows_result(i, ds.Tables(0).Rows(i)("id").ToString(), ds.Tables(0).Rows(i)("emp").ToString(), ID))
            Next i
        Else
            Response.Write(rows_result(-1, "-1", "No Search Result", ID))
        End If
    End Sub

    Protected Sub SearchSucursal()
        Dim location_st As String = ""
        Dim username As String = Membership.GetUser().UserName
        query = "select location from users where user_name = '" + username + "' "
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If ds.Tables(0).Rows(0)("location") <> "0" Then
                location_st = " and location = " + ds.Tables(0).Rows(0)("location").ToString()
            End If
        End If

        query = "select top 15 * from locations "
        query += " where alias LIKE '%" + SearchText.ToString() + "%'"
        query += location_st.ToString() + " order by alias"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            For i As Integer = 0 To ds.Tables(0).Rows.Count - 1
                Response.Write(rows_result(i, ds.Tables(0).Rows(i)("id").ToString(), ds.Tables(0).Rows(i)("alias").ToString(), ID))
            Next i
        Else
            Response.Write(rows_result(-1, "-1", "No Search Result", ID))
        End If
    End Sub

    Protected Sub SearchCodigo()
        Dim query As String
        query = "select top 15 code from products "
        query += " where code LIKE '%" + SearchText.ToString() + "%' or alias like '%" + SearchText.ToString() + "%' order by code"

        ds = Dataconnect.GetAll(query)
        
        If ds.Tables(0).Rows.Count > 0 Then
            For i As Integer = 0 To ds.Tables(0).Rows.Count - 1
                Response.Write(rows_result_codigo(i, ds.Tables(0).Rows(i)("code").ToString(), ds.Tables(0).Rows(i)("code").ToString(), ID))
            Next i
        Else
            Response.Write(rows_result(-1, "-1", "No Search Result", ID))
        End If
    End Sub

    Protected Sub SearchCliente()
        Dim location_st As String = ""
        Dim username As String = Membership.GetUser().UserName
        query = "select location from users where user_name = '" + username + "' "
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If ds.Tables(0).Rows(0)("location") <> "0" Then
                location_st = " and location = " + ds.Tables(0).Rows(0)("location").ToString()
            End If
        End If

        query = "select top 15 * from clients "
        query += " where (name LIKE '%" + SearchText.ToString() + "%' or contact_name like '%" + SearchText.ToString()
        query += "%') " + location_st.ToString() + " order by name"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            For i As Integer = 0 To ds.Tables(0).Rows.Count - 1
                Response.Write(rows_result(i, ds.Tables(0).Rows(i)("id").ToString(), ds.Tables(0).Rows(i)("name").ToString(), ID))
            Next i
        Else
            Response.Write(rows_result(-1, "-1", "No Search Result", ID))
        End If
    End Sub

    Protected Function rows_result(ByVal Index As Integer, ByVal id_element As String, ByVal text As String, ByVal Pref As String) As String
        Dim html As String
        Dim onclick As String

        If id_element <> "-1" Then
            onclick = " onclick = ""ClickOnResult(" + Index.ToString() + ",'" + Pref + "')"" "
        Else
            onclick = ""
        End If

        html = "<div id= """ + Pref + Index.ToString() + """ id_element = '" + id_element + "' class=""resultsNormal"" " + onclick + " onmouseover=""SelectResult(" + Index.ToString() + ",'" + Pref + "')"" >"

        html += id_element + " - " + text

        html += "</div>"

        Return html
    End Function


    Protected Function rows_result_codigo(ByVal Index As Integer, ByVal id_element As String, ByVal text As String, ByVal Pref As String) As String
        Dim html As String
        Dim onclick As String

        If id_element <> "-1" Then
            onclick = " onclick = ""ClickOnResult(" + Index.ToString() + ",'" + Pref + "')"" "
        Else
            onclick = ""
        End If

        html = "<div id= """ + Pref + Index.ToString() + """ id_element = '" + id_element + "' class=""resultsNormal"" " + onclick + " onmouseover=""SelectResult(" + Index.ToString() + ",'" + Pref + "')"" >"

        html += id_element

        html += "</div>"

        Return html
    End Function

End Class