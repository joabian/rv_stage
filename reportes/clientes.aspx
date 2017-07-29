<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="clientes.aspx.vb" Inherits="reportes_clientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />    

    <script type="text/javascript">

        $(function () {
            var dates = $("#<%=from_date.ClientID%>, #<%=to_date.ClientID%>").datepicker({
                numberOfMonths: 1,
                changeYear: true,
                yearRange: '2010:2200', 
                dateFormat: 'mm/dd/yy',
                //  showWeek: true,
                firstDay: 1//,
                //onSelect: function (selectedDate) {
                //var option = this.id == "#<%=from_date.ClientID%>" ? "minDate" : "maxDate",
                //instance = $(this).data("datepicker"),
                //date = $.datepicker.parseDate(
                //instance.settings.dateFormat ||
                //$.datepicker._defaults.dateFormat,
                //selectedDate, instance.settings);
                //dates.not(this).datepicker("option", option, date);
                //}
            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Reporte por clientes</h1>
    <br /><hr />
    <fieldset>
        <legend>Filtros:</legend>
        <asp:Panel runat="server" ID="pnlDatosCliente" HorizontalAlign="Right" Visible="false">
            <asp:Table runat="server" ID="tblDatos" Caption="Datos de Cliente" HorizontalAlign="Right">                
                <asp:TableRow>
                    <asp:TableHeaderCell >
                        <asp:Label runat="server" Text="ID Cliente: "></asp:Label>
                    </asp:TableHeaderCell>
                    <asp:TableCell HorizontalAlign="Left">
                        <asp:Label runat="server" ID="lblIdCliente"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableHeaderCell>
                        <asp:Label runat="server" Text="Nombre: "></asp:Label>
                    </asp:TableHeaderCell>
                    <asp:TableCell HorizontalAlign="Left">
                        <asp:Label runat="server" ID="lblNombreCliente"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableHeaderCell>
                        <asp:Label runat="server" Text="Teléfono: "></asp:Label>
                    </asp:TableHeaderCell>
                    <asp:TableCell HorizontalAlign="Left">
                        <asp:Label runat="server" ID="lblTelefono"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>            
        </asp:Panel>
        <asp:DropDownList ID="ddl_cliente" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Value="-" Text="Seleccione un Cliente..."></asp:ListItem>
        </asp:DropDownList><br /><br />
        Periodo &nbsp;&nbsp;&nbsp;
        Desde:
        <asp:TextBox ID="from_date" runat="server"></asp:TextBox>&nbsp;&nbsp;
        Hasta:
        <asp:TextBox ID="to_date" runat="server"></asp:TextBox><br /><br />
        <asp:Button ID="btn_get_report" runat="server" Text="Generar Reporte" />&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btn_export" runat="server" Text="Exportar a Excel" Enabled="false" />        
    </fieldset><hr />
    <center>        
        <asp:Label runat="server" ID="lblProd" Text="Por Productos Comprados" Visible="false" Font-Bold="true" Font-Size="Medium"></asp:Label>
        <br />
        <br />
        <asp:GridView ID="gv_summary" runat="server">
        </asp:GridView>
        <br />
        <br />
        <asp:Label runat="server" ID="lblOrd" Text="Por Órdenes Pedidas" Visible="false" Font-Bold="true" Font-Size="Medium"></asp:Label>
        <br />
        <br />
        <asp:GridView ID="gv_results" runat="server">
        </asp:GridView>
        <asp:Label ID="lbl_error" runat="server" Text="" ForeColor="Red"></asp:Label>
    </center>

    <asp:HiddenField ID="hf_qry" runat="server" />
    <asp:HiddenField ID="hf_qry2" runat="server" />
</asp:Content>

