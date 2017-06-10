<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="remove_categ.aspx.vb" Inherits="productos_remove_categ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<fieldset><legend>Eliminar Categoría</legend>
    <asp:DropDownList ID="categoryDD" runat="server" 
        DataSourceID="ObjectDataSource1" DataTextField="name" DataValueField="id">
    </asp:DropDownList>&nbsp&nbsp
    <asp:CheckBox ID="trans_prods" runat="server" 
        Text="Transferir todos los productos a esta categoría:" 
        AutoPostBack="True" />&nbsp&nbsp
    <asp:DropDownList ID="trans_categDDL" runat="server" 
        DataSourceID="ObjectDataSource2" DataTextField="name" DataValueField="id" Visible="false">
    </asp:DropDownList>&nbsp&nbsp
    <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetCategories" 
        TypeName="CategoriesBLL"></asp:ObjectDataSource>
    <br />
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetCategories" 
        TypeName="CategoriesBLL"></asp:ObjectDataSource>
    <br /><asp:Button ID="Remove" runat="server" Text="Eliminar" OnClientClick="return confirm('¿Confirma que desea eliminar esta categoría?');" /><br />
    <br /><asp:Label ID="lblerror" runat="server" Text="" ForeColor="Red"></asp:Label>
    </fieldset>
</asp:Content>


