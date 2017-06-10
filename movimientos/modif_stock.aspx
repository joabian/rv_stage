<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="modif_stock.aspx.vb" Inherits="reportes_modif_stock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <table>
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="Producto"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="product_id" runat="server" AutoPostBack="True"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="Inventario"></asp:Label>
            </td>
            <td>
                <asp:GridView ID="inventoryGV" runat="server">
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Locacion"></asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="location" runat="server" AppendDataBoundItems="True">
                    <asp:ListItem Value="na">Seleccione...</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Rack"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="rack_id" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="new_qtyLB" runat="server" Text="Nueva Cantidad:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="new_qtyTB" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="Comentario:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txb_comment" runat="server" TextMode="MultiLine" Width="414px"></asp:TextBox>
            </td>
        </tr>
        <tr>
        <td><asp:Button ID="save_qty" runat="server" Text="Guardar" /></td>
        <td><asp:Label ID="lblerror" runat="server" Text="" ForeColor="Red"></asp:Label></td>
        </tr>
    </table>
    
</asp:Content>

