<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="elim_suc.aspx.vb" Inherits="sucursales_elim_suc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1>pagina para eliminar sucursales</h1>
Seleccionar sucursal:
    <asp:DropDownList ID="DropDownList1" runat="server">
    </asp:DropDownList>
<asp:Button ID="elim_suc" runat="server" Text="Eliminar Sucursal" />
</asp:Content>

