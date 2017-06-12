<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Activity.aspx.vb" Inherits="reportes_Activity" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript">

        $(function () {
            var dates = $("#from_date, #to_date").datepicker({
                numberOfMonths: 1,
                changeYear: true,
                yearRange: '2010:2200',
                dateFormat: 'mm/dd/yy',
                firstDay: 1,
                onSelect: function (selectedDate) {
                    var option = this.id == "from_date" ? "minDate" : "maxDate",
					    instance = $(this).data("datepicker"),
					    date = $.datepicker.parseDate(
						    instance.settings.dateFormat ||
						    $.datepicker._defaults.dateFormat,
						    selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Actividad reciente</h1>
    <br />
    <hr />
    <fieldset>
        <legend>Filtrar Actividad Reciente </legend>
        <asp:DropDownList ID="ddlSucursal" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Value="-" Text="Seleccione sucursal"></asp:ListItem>
        </asp:DropDownList>&nbsp&nbsp
        <asp:Label ID="lblCodigo" runat="server" Text="Código: "></asp:Label>
        <asp:TextBox ID="txtCodigo" runat="server" ></asp:TextBox>&nbsp&nbsp
        <asp:Label runat="server" Text="Desde: "></asp:Label>
        <input type="text" id="from_date" name="from_date" class="textBox" required />&nbsp&nbsp
        <asp:Label runat="server" Text="Hasta: "></asp:Label>
        <input type="text" id="to_date" name="to_date" class="textBox" required />
        <br />
        <br />
        <asp:Button ID="btnBuscarRec" runat="server" Text="Buscar" />
    </fieldset>
    <hr />
    <center>
        <asp:Label ID="lblMsg" runat="server"></asp:Label><br />
        <br />
        <asp:GridView ID="GridView1" runat="server">
        </asp:GridView>
    </center>
</asp:Content>

