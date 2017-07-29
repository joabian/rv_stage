<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="estado_de_cuenta.aspx.vb" Inherits="reportes_estado_de_cuenta" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">    
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <script src="../Scripts/colorbox/colorbox.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />    

    <style type="text/css">
        .tableItems {
            width: 80%;
            margin-left: auto;
            margin-right: auto;
            border-collapse: collapse;
        }

        .date_hide {
            display: none;
        }

    </style>
    <script type="text/javascript">
        $(function () {
            var dates = $("#<%=fromDate.ClientID%>, #<%=toDate.ClientID%>").datepicker({
                numberOfMonths: 1,
                changeYear: true,
                yearRange: '2010:2200', 
                dateFormat: 'mm/dd/yy',
                firstDay: 1,
                onSelect: function (selectedDate) {
                    var option = this.id == "<%=fromDate.ClientID%>" ? "minDate" : "maxDate",
					    instance = $(this).data("datepicker"),
					    date = $.datepicker.parseDate(
						    instance.settings.dateFormat ||
						    $.datepicker._defaults.dateFormat,
						    selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
            $("#<%=fromDate.ClientID%>").attr('readOnly', 'true')
            $("#<%=fromDate.ClientID%>").keypress(function (event) { event.preventDefault(); });
            $("#<%=toDate.ClientID%>").attr('readOnly', 'true')
            $("#<%=toDate.ClientID%>").keypress(function (event) { event.preventDefault(); });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Estados de cuentas</h1>
    <br /><hr />
    <fieldset>
        <legend>Filtros:</legend>
        <asp:DropDownList ID="ddlCliente" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Value="-" Text="Seleccione un Cliente..."></asp:ListItem>
        </asp:DropDownList>&nbsp&nbsp
        Desde:
        <asp:TextBox ID="fromDate" runat="server" ></asp:TextBox> &nbsp;&nbsp;
        Hasta:
        <asp:TextBox ID="toDate" runat="server"></asp:TextBox> <br /><br />
        <asp:Button ID="btnGetEdoCta" runat="server" Text="Generar Estado de Cuenta"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnExport" runat="server" Text="Exportar a Excel" Enabled="false" />        
    </fieldset><hr />
    <center>
        <asp:Label ID="lblTitulo" Text="Estado de Cuenta" runat="server" visible="false" style="font-size:medium; font-weight:700"/>
        <br /><br />
        <asp:GridView ID="gvEdoCta" runat="server" Width="85%" RowStyle-HorizontalAlign="Center"></asp:GridView>
        <asp:Label ID="lblError" runat="server" Text="" ForeColor="Red"></asp:Label>
    </center>

    <asp:HiddenField ID="hf_qry" runat="server" />
    <asp:HiddenField ID="hf_qry2" runat="server" />
</asp:Content>
