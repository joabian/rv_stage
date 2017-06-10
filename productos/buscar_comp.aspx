<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="buscar_comp.aspx.vb" Inherits="productos_buscar_comp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<div>
    <table style="width: 70%;">
        <tr><th>Año</th><th>Fabricante</th><th>Modelo</th><th>Producto</th>
        </tr>
        <tr>
            <td>
                <asp:ListBox ID="lbx_year" runat="server" Width="100px" AutoPostBack="True"></asp:ListBox>
            </td>
            <td><asp:ListBox ID="lbx_make" runat="server" Width="250px" AutoPostBack="True"></asp:ListBox></td>
            <td><asp:ListBox ID="lbx_model" runat="server" Width="250px" AutoPostBack="True"></asp:ListBox></td>
            <td><asp:ListBox ID="lbx_dpi" runat="server" Width="200px" AutoPostBack="True"></asp:ListBox></td>
        </tr>
    </table>
    <br /><asp:Button ID="btn_reset" runat="server" Text="Reset" />
    <br /><br />
    <table>
    <tr>
    <td style=" width:700px;"><asp:Label ID="lbl_comp" runat="server" Text=""></asp:Label><br />
        <asp:GridView ID="gv_info" runat="server" Width="95%">
        </asp:GridView><br />
        <asp:Label ID="lbl_product_info" runat="server" Text=""></asp:Label>
        <asp:GridView ID="gv_product_info" runat="server" Width="95%">
        </asp:GridView><br />
        <asp:Label ID="lbl_inventory" runat="server" Text=""></asp:Label>
        <asp:GridView ID="gv_inventory" runat="server" Width="95%">
        </asp:GridView></td>
    <td style=" width:400px;">
        <asp:Image ID="img_product" runat="server" /></td>
    </tr>
    </table>
    <div style=" width:100%;">
        
    </div>
    <div style="width:30%; float:left;">
    
    </div>

</div>
</asp:Content>

