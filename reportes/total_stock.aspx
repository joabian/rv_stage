<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="total_stock.aspx.vb" Inherits="reportes_total_stock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <fieldset title="Inventario Completo">
        <asp:CheckBox ID="chbx_pivot" runat="server" Text="Incluir Sucursales" />&nbsp&nbsp
        <asp:Button ID="btn_run" runat="server" Text="Generar Reporte" />&nbsp&nbsp
        <asp:Button ID="btn_export" runat="server" Text="Exportar a Excel" />
    </fieldset>
    <center><asp:GridView ID="gv_stock" runat="server" >
    </asp:GridView></center>
    
    </asp:Content>