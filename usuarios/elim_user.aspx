<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="elim_user.aspx.vb" Inherits="usuarios_elim_user" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1 align="center">página para eliminar usuarios</h1>
    <br /><br /><center>
Seleccionar Usuario:&nbsp
    <asp:DropDownList ID="lista_usuarios" runat="server">
    </asp:DropDownList><br /><br />
    <asp:Button ID="Button1" runat="server" Text="Eliminar Usuario" OnClientClick="return confirm('Esta seguro de borrar a este usuario?');" />
               </center>
</asp:Content>
