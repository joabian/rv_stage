<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="cambios.aspx.vb" Inherits="movimientos_cambios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <table>
        <tr><td><asp:Label ID="Label3" runat="server" Text="Sucursal: "></asp:Label></td><td><asp:DropDownList ID="ddl_location" runat="server" AppendDataBoundItems="true">
        <asp:ListItem Value="-">Seleccionar...</asp:ListItem>
    </asp:DropDownList></td></tr>
        <tr><td><asp:Label ID="Label2" runat="server" Text="Producto devuelto: "></asp:Label></td><td><asp:TextBox ID="tb_product_ent" runat="server" ></asp:TextBox></td></tr>
        <tr><td><asp:Label ID="Label1" runat="server" Text="Producto que sale: "></asp:Label></td><td><asp:TextBox ID="tb_product_sal" runat="server" ></asp:TextBox></td></tr>
        <tr><td><asp:Label ID="Label5" runat="server" Text="Sale del rack: "></asp:Label></td><td><asp:TextBox ID="tb_rack" runat="server"></asp:TextBox></td></tr>
        <tr><td><asp:Label ID="Label6" runat="server" Text="Comentario:"></asp:Label></td><td><asp:TextBox ID="tb_comments" runat="server" Width="250px" Height="100px" TextMode="MultiLine"></asp:TextBox></td></tr>
        <tr><td></td><td><asp:Button ID="btn_save" runat="server" Text="Guardar" /></td></tr>
        <tr><td colspan="2"><asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label></td></tr>
    </table>
    
</asp:Content>

