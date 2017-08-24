<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="moves.aspx.vb" Inherits="reportes_moves" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <%--<script src="../Scripts/jquery.js"></script>--%>
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />    

    <script type="text/javascript">
        var day_date;
        $(document).ready(function () {
            var to_date = new Date();
            var d = to_date.getDay();
            var rest_day;

            var from_date = new Date();
            var rest_day_yest;

            if (d == 1) {
                rest_day = 3;
                rest_day_yest = 7;
            }
            else {
                rest_day = 1;
                rest_day_yest = (d - 1);
            }

            to_date.setDate(to_date.getDate());
            var dd = to_date.getDate();
            var mm = to_date.getMonth() + 1; //January is 0!
            var yyyy = to_date.getFullYear();
            if (dd < 10)
            { dd = '0' + dd };
            if (mm < 10)
            { mm = '0' + mm };
            to_date = mm + '/' + dd + '/' + yyyy;
            var to_text = document.getElementById("to_date");
            to_text.value = to_date;

            from_date.setDate(from_date.getDate() - rest_day_yest);
            var dd_f = from_date.getDate();
            var mm_f = from_date.getMonth() + 1;
            var yyyy_f = from_date.getFullYear();
            if (dd_f < 10)
            { dd_f = '0' + dd_f };
            if (mm_f < 10)
            { mm_f = '0' + mm_f };
            from_date = mm_f + '/' + dd_f + '/' + yyyy_f;
            var from_text = document.getElementById("from_date");
            from_text.value = from_date;

        });

        $(function () {
            var dates = $("#from_date, #to_date").datepicker({
                numberOfMonths: 1,
                changeYear: true,
                yearRange: '2010:2200',
                dateFormat: 'mm/dd/yy',
                //  showWeek: true,
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
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Reporte de movimientos</h1>
    <br /><hr />
<fieldset><legend>Filtrar Movimientos:</legend>
    Tipo:
    <asp:DropDownList ID="typeDDL" runat="server">
        <asp:ListItem Value="0">TODOS</asp:ListItem>
        <asp:ListItem Value="Salida">SALIDA</asp:ListItem>
        <asp:ListItem Value="Entrada">ENTRADA</asp:ListItem>
        <%--<asp:ListItem Value="Transferencia">TRANSFERENCIA</asp:ListItem>--%>
        <asp:ListItem Value="Ajuste">AJUSTE</asp:ListItem>
    </asp:DropDownList>&nbsp;&nbsp;&nbsp;
    Razón:
    <asp:DropDownList ID="ddl_rason" runat="server">
        <asp:ListItem Value="0">TODOS</asp:ListItem>
        <asp:ListItem Value="Ajuste Inventario">AJUSTE INVENTARIO</asp:ListItem>
        <asp:ListItem Value="Cambio">CAMBIO</asp:ListItem>
        <asp:ListItem Value="Compra">COMPRA</asp:ListItem>
        <asp:ListItem Value="Devolucion">DEVOLUCIÓN</asp:ListItem>
        <asp:ListItem Value="Scrap">SCRAP</asp:ListItem>
        <%--<asp:ListItem Value="Transferencia">TRANSFERENCIA</asp:ListItem>--%>
        <asp:ListItem Value="Venta">VENTA</asp:ListItem>
        <asp:ListItem Value="Pedido">PEDIDO</asp:ListItem>
    </asp:DropDownList>&nbsp;&nbsp;&nbsp;
    Sucursal:
    <asp:DropDownList ID="ddl_locations" runat="server" AppendDataBoundItems="true">
        <asp:ListItem Value="0">TODAS</asp:ListItem>
    </asp:DropDownList>&nbsp;&nbsp;&nbsp;
    Código:
    <asp:TextBox ID="tbx_codigo" runat="server"></asp:TextBox>&nbsp;&nbsp;&nbsp;
    Desde:
    <input type="text" id="from_date" name="from_date" class="textBox" style="width:100px; margin-top:3px;" />&nbsp;&nbsp;&nbsp;
    Hasta:
    <input type="text" id="to_date" name="to_date" class="textBox" style="width:100px; margin-top:3px;" />&nbsp;&nbsp;&nbsp;
    <br /><br /><asp:Button ID="btn_get_report" runat="server" Text="Generar Reporte" />&nbsp;&nbsp;&nbsp;
    <asp:Button ID="Button1" runat="server" Text="Exportar a Excel" />
</fieldset>
 
    <center><asp:GridView ID="movesGV" runat="server">
    </asp:GridView></center>
    <asp:Label ID="lblerro" runat="server" Text="" ForeColor="Red"></asp:Label>
    <asp:HiddenField ID="hifd_query" runat="server" />
</asp:Content>

