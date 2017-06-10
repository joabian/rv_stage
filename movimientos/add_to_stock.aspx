<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="add_to_stock.aspx.vb" Inherits="add_to_stock" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Label ID="Label1" runat="server" Text="Categoria: "></asp:Label>
    <asp:DropDownList ID="categoryDDL" runat="server" AutoPostBack="True" 
        DataSourceID="categoryDS" DataTextField="name" DataValueField="id">
    </asp:DropDownList>
    <asp:ObjectDataSource ID="categoryDS" runat="server" InsertMethod="Insert" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetCategories" 
        TypeName="vencedoresTableAdapters.categoriesTableAdapter">
        <InsertParameters>
            <asp:Parameter Name="name" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:Label ID="Label2" runat="server" Text="Producto: "></asp:Label>
    <asp:DropDownList ID="productDDL" runat="server" AutoPostBack="True" 
        DataSourceID="ProductDS" DataTextField="code" DataValueField="id">
    </asp:DropDownList>
    <asp:ObjectDataSource ID="ProductDS" runat="server" 
        OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetProductsByCategoryID" 
        TypeName="vencedoresTableAdapters.productsTableAdapter">
        <SelectParameters>
            <asp:ControlParameter ControlID="categoryDDL" Name="CategoryID" 
                PropertyName="SelectedValue" Type="Byte" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:Label ID="Label3" runat="server" Text="Sucursal: "></asp:Label>
    <asp:DropDownList ID="locationDDL" runat="server" DataSourceID="LocationDS" 
        DataTextField="alias" DataValueField="id">
    </asp:DropDownList>
    <asp:ObjectDataSource ID="LocationDS" runat="server" InsertMethod="Insert" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetLocations" 
        TypeName="vencedoresTableAdapters.locationsTableAdapter">
        <InsertParameters>
            <asp:Parameter Name="_alias" Type="String" />
            <asp:Parameter Name="address" Type="String" />
            <asp:Parameter Name="city" Type="String" />
            <asp:Parameter Name="state" Type="String" />
            <asp:Parameter Name="country" Type="String" />
            <asp:Parameter Name="tel" Type="String" />
            <asp:Parameter Name="tel_sec" Type="String" />
            <asp:Parameter Name="nextel" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:Label ID="Label4" runat="server" Text="Cantidad: "></asp:Label>
    <asp:TextBox ID="quantityTB" runat="server"></asp:TextBox>
    <asp:Button ID="save_stock" runat="server" Text="Guardar" /><br /><br />
    <asp:Label ID="errorLB" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
</asp:Content>

