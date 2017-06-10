<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="productos.aspx.vb" Inherits="productos_productos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <fieldset>
        <asp:Button ID="Button1" runat="server" Text="Exportar a Excel" />
    </fieldset>
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        InsertMethod="AddProduct" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetProducts" TypeName="ProductsBLL" UpdateMethod="UpdateProduct">
        <InsertParameters>
            <asp:Parameter Name="code" Type="String" />
            <asp:Parameter Name="description" Type="String" />
            <asp:Parameter Name="category" Type="Int32" />
            <asp:Parameter Name="price" Type="Decimal" />
            <asp:Parameter Name="cost" Type="Decimal" />
            <asp:Parameter Name="low_inventory" Type="Int16" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="code" Type="String" />
            <asp:Parameter Name="description" Type="String" />
            <asp:Parameter Name="category" Type="Int32" />
            <asp:Parameter Name="price" Type="Decimal" />
            <asp:Parameter Name="cost" Type="Decimal" />
            <asp:Parameter Name="low_inventory" Type="Int16" />
            <asp:Parameter Name="id" Type="Int32" />
        </UpdateParameters>
    </asp:ObjectDataSource>
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" DataSourceID="ObjectDataSource1">
        <Columns>
            <asp:BoundField DataField="code" HeaderText="CODIGO" 
                SortExpression="code" />
            <asp:BoundField DataField="categoryName" HeaderText="CATEGORIA" 
                SortExpression="categoryName" ReadOnly="True" />
            <asp:BoundField DataField="description" HeaderText="DESCRIPCION" 
                SortExpression="description" />
        </Columns>
    </asp:GridView>
</asp:Content>

