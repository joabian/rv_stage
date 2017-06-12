<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="add_category.aspx.vb" Inherits="productos_add_category" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center"> Agregar categoría </h1>
    <br /><hr />
<fieldset><legend>Nueva Categoría</legend>
    <asp:Label ID="Label1" runat="server" Text="Nombre de Categoría:"></asp:Label>&nbsp;&nbsp
    <asp:TextBox ID="category" runat="server" Width="200px"></asp:TextBox>&nbsp;&nbsp
    <asp:Button ID="save" runat="server" Text="Guardar" />
    <br />
    <asp:Label ID="errorlbl" runat="server" Text=""></asp:Label>
</fieldset>
</asp:Content>

