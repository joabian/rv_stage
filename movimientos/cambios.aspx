<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="cambios.aspx.vb" Inherits="movimientos_cambios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Cambios de productos</h1>
    <br />
    <hr />
    <fieldset>
        <legend>Datos de Producto</legend>
        <table>
            <tr>
                <th>
                    <asp:Label ID="Label3" runat="server" Text="Sucursal: "></asp:Label></th>
                <td>
                    <asp:DropDownList ID="ddl_location" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Value="-">Seleccionar...</asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="Label2" runat="server" Text="Producto devuelto: "></asp:Label></th>
                <td>
                    <asp:TextBox ID="tb_product_ent" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="Label1" runat="server" Text="Producto que sale: "></asp:Label></th>
                <td>
                    <asp:TextBox ID="tb_product_sal" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="Label5" runat="server" Text="Sale del rack: "></asp:Label></th>
                <td>
                    <asp:TextBox ID="tb_rack" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="Label4" runat="server" Text="Cantidad: "></asp:Label></th>
                <td>
                    <asp:TextBox ID="tb_qty" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="Label6" runat="server" Text="Comentario:"></asp:Label></th>
                <td>
                    <asp:TextBox ID="tb_comments" runat="server" Width="250px" Height="100px" TextMode="MultiLine"></asp:TextBox></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:Button ID="btn_save" runat="server" Text="Guardar" /></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label></td>
            </tr>
        </table>
    </fieldset>
</asp:Content>

