Imports System.Data

Partial Class productos_find_prod
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public strYear As String
    Public strYearq As String
    Public strMake As String
    Public strModel As String
    Public strMakeq As String

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Request.QueryString("year") <> "" Then
            strYear = Request.QueryString("year").ToString()
            panel_years.Visible = False
            panel_make.Visible = True
            LBL_step.Text = "Seleccione la Marca:"
            filltablemake(strYear)
        End If
        If Request.QueryString("make") <> "" Then
            strMake = Request.QueryString("make").ToString()
            strYearq = Request.QueryString("yearq").ToString()
            panel_years.Visible = False
            panel_make.Visible = False
            panel_model.Visible = True
            LBL_step.Text = "Seleccione el Modelo:"
            filltablemodel(strMake, strYearq)
        End If
        If Request.QueryString("model") <> "" Then
            strModel = Request.QueryString("model").ToString()
            strYearq = Request.QueryString("yearq").ToString()
            strMakeq = Request.QueryString("makeq").ToString()
            panel_years.Visible = False
            panel_make.Visible = False
            panel_model.Visible = False
            LBL_step.Text = "Seleccione el automovil para ver sus detalles:"
            panel_results.Visible = True
            GV_results.Visible = True
            fillgrid(strYearq, strMakeq, strModel)
        End If


        If Not IsPostBack Then
            'query = "select min(year_beg) as from_year, max(year_end) as to_year from models"
            'ds = Dataconnect.GetAll(query)
            'If ds.Tables(0).Rows.Count > 0 Then
            '    'filltable()
            'End If
        End If

    End Sub

    Public Sub filltablemake(ByVal stryear As String)
        LBL_table_make.Text = ""
        Dim rows As Integer
        Dim columns As Integer = 5
        Dim Print_rows As Integer
        query = "select make from models where year_beg <= " + stryear.ToString() + " and year_end >= " + stryear.ToString() + " group by make order by make"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
		
            rows = ds.Tables(0).Rows.Count
            If rows >= 4 Then

                Print_rows = rows / columns
                Dim start As Integer = 0
                Dim endc As Integer = Print_rows
                LBL_table_make.Text += "<table>"

                For i = 0 To endc + 1
                    LBL_table_make.Text += "<tr>"
                    If start < rows Then
                        LBL_table_make.Text += "<td><img alt='x' height='32' width='32' src='../images/logos/" + ds.Tables(0).Rows(start)("make").ToString() + ".png' /></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryear.ToString() + "&make=" + ds.Tables(0).Rows(start)("make").ToString() + "'>" + ds.Tables(0).Rows(start)("make").ToString() + "</a></td><td></td>"
                    End If
                    If (start + 1) < rows Then
                        LBL_table_make.Text += "<td><img alt='x' height='32' width='32' src='../images/logos/" + ds.Tables(0).Rows(start + 1)("make").ToString() + ".png' /></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryear.ToString() + "&make=" + ds.Tables(0).Rows(start + 1)("make").ToString() + "'>" + ds.Tables(0).Rows(start + 1)("make").ToString() + "</a></td><td></td>"

                    End If
                    If (start + 2) < rows Then
                        LBL_table_make.Text += "<td><img alt='x' height='32' width='32' src='../images/logos/" + ds.Tables(0).Rows(start + 2)("make").ToString() + ".png' /></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryear.ToString() + "&make=" + ds.Tables(0).Rows(start + 2)("make").ToString() + "'>" + ds.Tables(0).Rows(start + 2)("make").ToString() + "</a></td><td></td>"

                    End If
                    If (start + 3) < rows Then
                        LBL_table_make.Text += "<td><img alt='x' height='32' width='32' src='../images/logos/" + ds.Tables(0).Rows(start + 3)("make").ToString() + ".png' /></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryear.ToString() + "&make=" + ds.Tables(0).Rows(start + 3)("make").ToString() + "'>" + ds.Tables(0).Rows(start + 3)("make").ToString() + "</a></td><td></td>"

                    End If
                    LBL_table_make.Text += "</tr>"
                    start = start + 4
                Next


                LBL_table_make.Text += "</table>"
            Else
                For i = 0 To ds.Tables(0).Rows.Count - 1
                    LBL_table_make.Text += "<a href='find_prod.aspx?yearq=" + stryear.ToString() + "&make=" + ds.Tables(0).Rows(i)("make").ToString() + "'>" + ds.Tables(0).Rows(i)("make").ToString() + "</a><br />"
                Next
            End If

		Else
			LBL_table_make.Text = "No existen coincidencias para este año"
        End If
        

    End Sub


    Public Sub filltablemodel(ByVal strmake As String, ByVal stryearq As String)
        LBL_table_model.Text = ""
        Dim rows As Integer
        Dim columns As Integer = 5
        Dim Print_rows As Integer
        query = "select name from model where make = '" + strmake.ToString() + "' group by name order by name"
        ds = Dataconnect.GetAll(query)
        ''<img alt='x' src='../images/validyes.png' />
        If ds.Tables(0).Rows.Count > 0 Then

            rows = ds.Tables(0).Rows.Count
            If rows >= 4 Then

                Print_rows = rows / columns
                Dim start As Integer = 0
                Dim endc As Integer = Print_rows
                LBL_table_model.Text += "<table>"

                For i = 0 To endc + 1
                    LBL_table_make.Text += "<tr>"
                    If start < rows Then
                        LBL_table_model.Text += "<td></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryearq.ToString() + "&makeq=" + strmake.ToString() + "&model=" + ds.Tables(0).Rows(start)("name").ToString() + "'>" + ds.Tables(0).Rows(start)("name").ToString() + "</a></td>"
                    End If
                    If (start + 1) < rows Then
                        LBL_table_model.Text += "<td></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryearq.ToString() + "&makeq=" + strmake.ToString() + "&model=" + ds.Tables(0).Rows(start + 1)("name").ToString() + "'>" + ds.Tables(0).Rows(start + 1)("name").ToString() + "</a></td>"

                    End If
                    If (start + 2) < rows Then
                        LBL_table_model.Text += "<td></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryearq.ToString() + "&makeq=" + strmake.ToString() + "&model=" + ds.Tables(0).Rows(start + 2)("name").ToString() + "'>" + ds.Tables(0).Rows(start + 2)("name").ToString() + "</a></td>"

                    End If
                    If (start + 3) < rows Then
                        LBL_table_model.Text += "<td></td><td style='width:150px'><a href='find_prod.aspx?yearq=" + stryearq.ToString() + "&makeq=" + strmake.ToString() + "&model=" + ds.Tables(0).Rows(start + 3)("name").ToString() + "'>" + ds.Tables(0).Rows(start + 3)("name").ToString() + "</a></td>"

                    End If
                    LBL_table_model.Text += "</tr>"
                    start = start + 4
                Next


                LBL_table_make.Text += "</table>"
            Else
                For i = 0 To ds.Tables(0).Rows.Count - 1
                    LBL_table_model.Text += "<a href='find_prod.aspx?yearq=" + stryearq.ToString() + "&makeq=" + strmake.ToString() + "&model=" + ds.Tables(0).Rows(i)("name").ToString() + "'>" + ds.Tables(0).Rows(i)("name").ToString() + "</a><br />"
                Next
            End If

        Else
            LBL_table_make.Text = "No existen coincidencias para este año"

        End If


    End Sub

    Public Sub fillgrid(ByVal stryearq As String, ByVal strmakeq As String, ByVal strmodel As String)
        query = "select year_beg, year_end, ltr, cyl, remark, dpi_no, inlet_no, outlet_no from models where year_beg <= " + stryearq.ToString() + " and year_end >= " + stryearq.ToString() + " and make = '" + strmakeq.ToString() + "' and model = '" + strmodel.ToString() + "'"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            GV_results.DataSource = ds.Tables(0)
            GV_results.DataBind()

        End If
    End Sub

End Class
