<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="update_prices.aspx.vb" Inherits="movimientos_update_prices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <br /><br />

    <div style ="margin-left:auto; margin-right:auto; text-align:center">
        <b>Actualización Masiva de Precios<br />
        Ejemplo de Archivo:<br /></b>
        Columna A: Código del Producto<br />
        Columna B: Precio del Producto<br />
        <b>No incluir títulos de columnas, el archivo se empieza a leer desde la línea 1</b><br />
        <br />
        Campo a Actualizar: 
        <asp:DropDownList ID="ddlFieldToUpdate" runat="server">
            <asp:ListItem>PRECIO_JUAREZ</asp:ListItem>
            <asp:ListItem>PRECIO_DURANGO</asp:ListItem>
            <asp:ListItem>PRECIO_LEON</asp:ListItem>
            <asp:ListItem>PRECIO_TORREON</asp:ListItem>
            <asp:ListItem>PRECIO_MAYOREO_JUAREZ</asp:ListItem>
            <asp:ListItem>PRECIO_2_JUAREZ</asp:ListItem>
            <asp:ListItem>PRECIO_3_JUAREZ</asp:ListItem>
            <asp:ListItem>PRECIO_INSTALADO_JUAREZ</asp:ListItem>
            <asp:ListItem>PRECIO_DLLS_JUAREZ</asp:ListItem>
            <asp:ListItem>precio_rito</asp:ListItem>
            <asp:ListItem>precio_rito2</asp:ListItem>
        </asp:DropDownList>
        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/excel image update prices.PNG" Width="360px" /><br /><br />
        Cargar Excel: 
        <asp:FileUpload ID="File1" runat="server" Width="40%" />
        <asp:Button ID="leadexcel" runat="server" Text="Subir Excel" />
        <asp:Label ID="lbl_error_file" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
    </div>

    <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
</asp:Content>