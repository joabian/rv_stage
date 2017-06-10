<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="stock_by_location.aspx.vb" Inherits="reportes_stock_by_location" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <fieldset><legend>Seleccione Sucursal:</legend>
    <asp:DropDownList ID="DDL_Location" runat="server" AppendDataBoundItems="True">
        <asp:ListItem Value="-">Seleccione...</asp:ListItem>
    </asp:DropDownList>
        &nbsp;&nbsp;
        <asp:CheckBox ID="chbx_rack" runat="server" Text="Incluir Racks" />
        &nbsp;&nbsp;
        &nbsp;&nbsp;
        <asp:CheckBox ID="chbx_rack_col" runat="server" Text="Racks en columnas (sólo para exportar)" />
        <br /><br />
        <asp:Button ID="btn_run_report" runat="server" Text="Correr" />&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btn_merc_ceros" runat="server" Text="Mercancia en ceros" />&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="btn_export" runat="server" Text="Exportar a Excel" />
        <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel" ForeColor="Red"></asp:Label>
</fieldset>
<br />
    <asp:Label ID="lbl_table" runat="server" Text=""></asp:Label>
    <asp:HiddenField ID="hifd_query" runat="server" />
</asp:Content>

