<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="agreg_suc.aspx.vb" Inherits="sucursales_agreg_suc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1>pagina para agregar sucursales</h1>
<fieldset>
<legend>Información de Sucursal</legend>
    Nombre: 
    <asp:TextBox ID="tbx_nombre" runat="server"></asp:TextBox>
    Teléfono:
    <asp:TextBox ID="tbx_tel" runat="server"></asp:TextBox>
    Teléfono adicional:
    <asp:TextBox ID="tbx_tel2" runat="server"></asp:TextBox>
    Nextel:
    <asp:TextBox ID="tbx_nextel" runat="server"></asp:TextBox>
    Direccion:
    <asp:TextBox ID="tbx_dir" runat="server"></asp:TextBox>
    Ciudad:
    <asp:TextBox ID="tbx_ciudad" runat="server"></asp:TextBox>
    Estado:
    <asp:TextBox ID="tbx_estado" runat="server"></asp:TextBox>
    Pais:
    <asp:DropDownList ID="ddl_pais" runat="server">
        <asp:ListItem Value="Mexico" Text="Mexico"></asp:ListItem>
        <asp:ListItem Value="USA" Text="USA"></asp:ListItem>
    </asp:DropDownList>
    Gerente:
    <asp:TextBox ID="tbx_gerente" runat="server"></asp:TextBox>
    E-Mail:
    <asp:TextBox ID="tbx_correo" runat="server"></asp:TextBox>
    Transitoria (carros)?:
    <asp:DropDownList ID="ddl_trans" runat="server">
        <asp:ListItem Value="0" Text="No"></asp:ListItem>
        <asp:ListItem Value="1" Text="Si"></asp:ListItem>
    </asp:DropDownList>
</fieldset>
    <asp:Button ID="agreg_suc" runat="server" Text="Agregar Sucursal" />
    <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
</asp:Content>

