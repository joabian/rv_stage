<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="busc_user.aspx.vb" Inherits="usuarios_busc_user" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1 align="center">página para buscar usuarios</h1>
<fieldset><legend>Opciones de Búsqueda</legend>
Seleccione el campo:
    <asp:DropDownList ID="lista_campos" runat="server">
    </asp:DropDownList>&nbsp&nbsp&nbsp
Buscar:
    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>&nbsp&nbsp&nbsp
    <asp:Button ID="Button1" runat="server" Text="Buscar Usuario" />
</fieldset>

Tabla que muestre las coincidencias con link que lleve al record correcto y su información completa

</asp:Content>
