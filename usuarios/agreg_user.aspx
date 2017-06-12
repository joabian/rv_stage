<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="agreg_user.aspx.vb" Inherits="usuarios_agreg_user" %>

<script runat="server">

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 align="center">Nuevo Usuario</h1>
    <br /><hr />
    <fieldset>
        <legend>Datos de la Nueva Cuenta</legend>
<table>

        <tr>
            <td align="right">
                <asp:Label ID="Label3" runat="server">Nombre:&nbsp</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="tbx_name" runat="server"></asp:TextBox>
            </td>
        </tr>

        <tr>
            <td align="right">
                <asp:Label ID="Label4" runat="server">Apellido Paterno:&nbsp</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="tbx_flastname" runat="server"></asp:TextBox>
            </td>
        </tr>

        <tr>
            <td align="right">
                <asp:Label ID="Label5" runat="server">Apellido Materno:&nbsp</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="tbx_slastname" runat="server"></asp:TextBox>
            </td>
        </tr>

        <tr>
            <td align="right">
                <asp:Label ID="UserNameLabel" runat="server">Usuario:&nbsp</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="tbx_userName" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="PasswordLabel" runat="server">Contraseña:&nbsp</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="tbx_password1" runat="server" TextMode="Password"></asp:TextBox>

            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="ConfirmPasswordLabel" runat="server">Confirmar Contraseña:&nbsp</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="tbx_password2" runat="server" TextMode="Password"></asp:TextBox>

            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="EmailLabel" runat="server">Correo Electrónico:&nbsp</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="tbx_email" runat="server"></asp:TextBox>

            </td>
        </tr>
        <tr>
            <td align="right">
                <br />
                <asp:Label ID="Label1" runat="server">Acceso(s):</asp:Label>
                <br />
            </td>
            <td>
                <br />
                <asp:CheckBox ID="chbx_admin" runat="server" Text="Admin" />
                <asp:CheckBox ID="chbx_emp" runat="server" Text="Empleado" />
                <asp:CheckBox ID="chbx_inven" runat="server" Text="Inventario" />
                <br />
            </td>
        </tr>
        <tr>
            <td align="right">
                <br />
                <asp:Label ID="Label2" runat="server">Sucursal:</asp:Label>
                <br />
            </td>
            <td>
                <br />
                <asp:DropDownList ID="ddl_locations" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Value="-" Text="Seleccione..."></asp:ListItem>
                    <asp:ListItem Value="0" Text="Todas"></asp:ListItem>

                </asp:DropDownList>
                <br />
            </td>
        </tr>



        <tr>
            <td align="center" colspan="2" style="color: Red;">
                <asp:Label ID="lbl_error" runat="server" Text=""></asp:Label>
            </td>
        </tr>

        <tr>
            <td></td>
            <td>
                <br />
                <asp:Button ID="btn_save" runat="server" Text="Salvar" />
            </td>
        </tr>


    </table>
    </fieldset>
    


</asp:Content>
