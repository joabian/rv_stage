<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="pedidos_tapa.aspx.vb" Inherits="reportes_pedidos_tapa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Reporte de pedidos por tapa</h1>
    <br /><hr />
    <fieldset>
        <legend>Filtrar Pedidos</legend>
        # de Pedido:
        <asp:TextBox ID="order_number" runat="server"></asp:TextBox>&nbsp&nbsp&nbsp
        <asp:Button ID="btn_get_report" runat="server" Text="Generar Reporte" />&nbsp&nbsp&nbsp
        <asp:Button ID="btn_export" runat="server" Text="Exportar a Excel" Enabled="false" />
    </fieldset>
    <hr />
    <center><asp:GridView ID="gv_results" runat="server">
    </asp:GridView></center>
    <asp:Label ID="lbl_error" runat="server" Text="" ForeColor="Red"></asp:Label>

    <asp:HiddenField ID="hf_qry" runat="server" />

</asp:Content>

