<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="edit_suc.aspx.vb" Inherits="sucursales_edit_suc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1>pagina para editar sucursales</h1>
Seleccionar sucursal:
    <asp:DropDownList ID="DropDownList1" runat="server">
    </asp:DropDownList>
<fieldset>
<legend>Nueva Información de Sucursal</legend>
    Nombre: 
    <asp:TextBox ID="nombre_suc" runat="server"></asp:TextBox>
    Teléfono:
    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
    Direccion:
    <asp:TextBox ID="dir_suc" runat="server"></asp:TextBox>
    Ciudad:
    <asp:DropDownList ID="ciud_suc" runat="server">
    </asp:DropDownList>
    Estado:
    <asp:DropDownList ID="est_suc" runat="server">
    </asp:DropDownList>
    Pais:
    <asp:DropDownList ID="pais_suc" runat="server">
    </asp:DropDownList>
    Gerente:
    <asp:DropDownList ID="ger_suc" runat="server">
    </asp:DropDownList>
    Correo Gerente:
    <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
</fieldset>
<asp:Button ID="edit_suc" runat="server" Text="Editar Sucursal" />
</asp:Content>

