<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="edit_user.aspx.vb" Inherits="usuarios_edit_user" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 align="center">Editar usuarios</h1>
    <br />
    <hr />

    <fieldset>
        <legend>Información de Usuario</legend>
        <table>
            <tr>
                <th style="text-align: right;">Seleccionar Usuario:&nbsp<br />
                </th>
                <td align="center">
                    <asp:DropDownList ID="ddl_users" runat="server" AutoPostBack="true">
                        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
                </td>
            </tr>
            <tr>
                <th style="text-align: right;">Estatus:&nbsp<br />
                    <br />
                </th>
                <td align="center">
                    <asp:Label runat="server" ID="lbl_userStatus" Text="" Font-Bold="true"></asp:Label><br />
                    <br />
                </td>
                <td>&nbsp&nbsp<asp:Button ID="btn_unlock_user" runat="server" Text="Desbloquear" Enabled="false" /><br />
                    <br />
                </td>
            </tr>
            <tr>
                <th style="text-align: right;">Contraseña:&nbsp
                </th>
                <td>
                    <asp:TextBox ID="txb_pass" runat="server" TextMode="Password"></asp:TextBox>
                </td>
                <td rowspan="2">&nbsp&nbsp<asp:Button ID="btn_change_pass" runat="server" Text="Cambiar Contraseña" /><br />
                    <br />
                </td>
            </tr>
            <tr>
                <th style="text-align: right;">Confirmar Contraseña:&nbsp<br />
                    <br />
                </th>
                <td>
                    <asp:TextBox ID="txb_pass_conf" runat="server" TextMode="Password"></asp:TextBox><br />
                    <br />
                </td>
            </tr>
            <%--<tr>
                <th>Correo:</th>
                <td><asp:TextBox ID="txb_email" runat="server"></asp:TextBox></td>
                <td></td>
            </tr>--%>
            <tr>
                <th style="text-align: right;">
                    <br />
                    Acceso(s):&nbsp<br />
                    <br />
                </th>
                <td align="center">
                    <br />
                    <asp:Label ID="lbl_roles" runat="server" Text="" Font-Bold="true"></asp:Label><br />
                    <br />
                </td>
                <td>&nbsp&nbsp
                    <asp:DropDownList ID="ddl_roles" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                    </asp:DropDownList><br />
                    <br />
                    &nbsp&nbsp<asp:Button ID="btn_add_role" runat="server" Text="Agregar" />
                    &nbsp&nbsp<asp:Button ID="btn_del_role" runat="server" Text="Remover" />
                </td>
            </tr>
            <tr>
                <th style="text-align: right;">
                    <br />
                    Sucursal:&nbsp
                </th>
                <td align="center">
                    <br />
                    <asp:DropDownList ID="ddl_locations" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Value="na">Seleccione...</asp:ListItem>
                        <asp:ListItem Value="0">Todas</asp:ListItem>
                    </asp:DropDownList>
                </td>
                <td>
                    <br />
                    &nbsp&nbsp<asp:Button ID="btn_change_location" runat="server" Text="Cambiar" />
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    <hr />
                </td>
                <td>
                    <br />
                    <hr />
                </td>
                <td>
                    <br />
                    <hr />
                </td>
            </tr>
            <tr>
                <td></td>
                <th style="text-align: center">¿Eliminar Usuario?<br />
                </th>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td align="center">
                    <asp:Button ID="Button1" runat="server" Text="Eliminar Usuario" OnClientClick="return confirm('Esta seguro de borrar a este usuario?');" />
                </td>
                <td></td>
            </tr>
        </table>
        <br />
    </fieldset>
</asp:Content>
