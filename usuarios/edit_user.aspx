<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="edit_user.aspx.vb" Inherits="usuarios_edit_user" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h1 align="center">página para editar usuarios</h1>
<br />Seleccionar Usuario:
    <asp:DropDownList ID="ddl_users" runat="server" AutoPostBack="true">
        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
    </asp:DropDownList>
    <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
<fieldset>

<legend>Información de Usuario</legend>
    <table>
        <tr>
            <th style="text-align:right;">Estatus:&nbsp<br /><br /></th>
            <td align="center"><asp:Label runat="server" ID="lbl_userStatus" Text="" Font-Bold="true"></asp:Label><br /><br /></td>
            <td>&nbsp&nbsp<asp:Button ID="btn_unlock_user" runat="server" Text="Desbloquear" Enabled="false" /><br /><br /></td>
        </tr>
        <tr >
            <th style="text-align:right;">Contraseña:&nbsp</th>
            <td><asp:TextBox ID="txb_pass" runat="server" TextMode="Password"></asp:TextBox></td>
            <td rowspan="2">&nbsp&nbsp<asp:Button ID="btn_change_pass" runat="server" Text="Cambiar Contraseña" /><br /><br /></td>
        </tr>
        <tr>
            <th style="text-align:right;">Confirmar Contraseña:&nbsp<br /><br /></th>
            <td><asp:TextBox ID="txb_pass_conf" runat="server" TextMode="Password" ></asp:TextBox><br /><br /></td>
        </tr>
        <%--<tr>
            <th>Correo:</th>
            <td><asp:TextBox ID="txb_email" runat="server"></asp:TextBox></td>
            <td></td>
        </tr>--%>
        <tr>
            <th style="text-align:right;"><br />Acceso(s):&nbsp<br /><br /></th>
            <td align="center"><br /><asp:Label ID="lbl_roles" runat="server" Text="" Font-Bold="true"></asp:Label><br /><br /></td>
            <td>
                &nbsp&nbsp<asp:DropDownList ID="ddl_roles" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                </asp:DropDownList><br /><br />
                &nbsp&nbsp<asp:Button ID="btn_add_role" runat="server" Text="Agregar" />
                &nbsp&nbsp<asp:Button ID="btn_del_role" runat="server" Text="Remover" />
            </td>
            
        </tr>
        <tr>
            <th style="text-align:right;"><br />Sucursal:&nbsp</th>
            <td align="center"><br />
                <asp:DropDownList ID="ddl_locations" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Value="na">Seleccione...</asp:ListItem>
                    <asp:ListItem Value="0">Todas</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td><br />
                &nbsp&nbsp<asp:Button ID="btn_change_location" runat="server" Text="Cambiar" />
            </td>
            
        </tr>

    </table>
    <br /><br />
</fieldset>
    
</asp:Content>
