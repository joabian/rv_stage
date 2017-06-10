<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="agreg_prod.aspx.vb" Inherits="productos_agreg_prod" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<table>
    <tr>
        <td width="200px" align="right">
            <asp:Label ID="Label1" runat="server" Text="Código: "></asp:Label><br /><br />
        </td>
        <td>    
            <asp:TextBox ID="codeTB" runat="server"></asp:TextBox><br /><br />
        </td>
    </tr>
    <tr>
        <td width="200px" align="right">
            <asp:Label ID="Label2" runat="server" Text="Descripción: "></asp:Label><br /><br />
        </td>
        <td>
           <asp:TextBox ID="descriptionTB" runat="server" Width="500px" 
                TextMode="MultiLine" Height="100px"></asp:TextBox><br /><br />
        </td>
    </tr>
    <tr>
        <td width="200px" align="right">
            <asp:Label ID="Label6" runat="server" Text="Modelo: "></asp:Label><br /><br />
        </td>
        <td>
            <asp:TextBox ID="modelTB" runat="server"></asp:TextBox><br /><br />
        </td>
    </tr>
    <tr>
        <td width="200px" align="right">
            <asp:Label ID="Label3" runat="server" Text="Precio: "></asp:Label><br /><br />
        </td>
        <td>
            <asp:TextBox ID="priceTB" runat="server"></asp:TextBox><br /><br />
        </td>
    </tr>
    <tr>
        <td width="200px" align="right">
            <asp:Label ID="Label4" runat="server" Text="Costo: "></asp:Label><br /><br />
        </td>
        <td>
            <asp:TextBox ID="costTB" runat="server"></asp:TextBox><br /><br />
        </td>
    </tr>
    <tr>
        <td width="200px" align="right">
            <asp:Label ID="Label5" runat="server" Text="Inventario Mínimo: "></asp:Label><br /><br />
        </td>
        <td>
            <asp:TextBox ID="low_inventoryTB" runat="server"></asp:TextBox><br /><br />
        </td>
    </tr>
    <tr>
        <td width="200px" align="right">
            <asp:Label ID="Label7" runat="server" Text="Categoría: "></asp:Label><br /><br />
        </td>
        <td>
            <asp:DropDownList ID="categoryDD" runat="server" DataSourceID="ObjectDataSource1" DataTextField="name" DataValueField="id"></asp:DropDownList><br /><br />
        </td>
    </tr>
    <tr>
        <td></td>
        <td>
            <br /><asp:Button ID="save_product" runat="server" Text="Guardar Producto" />
        </td>
    </tr>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetCategories" 
        TypeName="vencedoresTableAdapters.categoriesTableAdapter">
        <InsertParameters>
            <asp:Parameter Name="name" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
</table>
    <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
    <asp:GridView ID="GridView1" runat="server">
    </asp:GridView>

</asp:Content>

