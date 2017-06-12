<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="relleno.aspx.vb" Inherits="reportes_relleno" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Reporte de relleno</h1>
    <br /><hr />
    <!-- <fieldset style="width:40%; float:left;"> -->
    <fieldset>
        <legend>Filtrar Relleno</legend>
        De sucursal:
        <asp:DropDownList ID="ddl_from_location" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Value="0">Seleccione...</asp:ListItem>
        </asp:DropDownList>&nbsp&nbsp&nbsp
        a sucursal:
        <asp:DropDownList ID="ddl_to_location" runat="server" AppendDataBoundItems="true">
            <asp:ListItem Value="0">Seleccione...</asp:ListItem>
        </asp:DropDownList><br /><br />
        <asp:Button ID="btn_run" runat="server" Text="Generar Reporte vs Inventario" Enabled="true" />&nbsp&nbsp&nbsp
        <asp:Button ID="btn_run_ventas" runat="server" Text="Generar Reporte vs Ventas" Enabled="true" />
        <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel" ForeColor="Red"></asp:Label>
    </fieldset>
    

</asp:Content>

