<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="usuarios.aspx.vb" Inherits="usuarios_usuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Usuarios Activos</h1>
    <br /><br />
    <asp:GridView ID="gv_usuarios" runat="server">
    </asp:GridView>
    <asp:GridView ID="gv_profiles" runat="server">
    </asp:GridView>
</asp:Content>
