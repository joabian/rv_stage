<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="entries.aspx.vb" Inherits="movimientos_entries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Label ID="Label1" runat="server" Text="Producto: "></asp:Label>
    <asp:TextBox ID="productId" runat="server" ></asp:TextBox>&nbsp&nbsp&nbsp
    <asp:Label ID="Label2" runat="server" Text="Motivo: "></asp:Label>
    <asp:DropDownList ID="type" runat="server">
        <asp:ListItem>COMPRA</asp:ListItem>
        <asp:ListItem>DEVOLUCIÓN</asp:ListItem>
        <asp:ListItem>AJUSTE INVENTARIO</asp:ListItem>
        <%--<asp:ListItem>Transferencia</asp:ListItem>--%>
    </asp:DropDownList>&nbsp&nbsp&nbsp
    <asp:Label ID="Label3" runat="server" Text="Sucursal: "></asp:Label>
    <asp:DropDownList ID="location" runat="server">
        <asp:ListItem Value="-">Seleccionar...</asp:ListItem>
    </asp:DropDownList>&nbsp&nbsp&nbsp
    
    <asp:Label ID="Label5" runat="server" Text="Rack: "></asp:Label>
    <asp:TextBox ID="rack" runat="server"></asp:TextBox>&nbsp&nbsp&nbsp
    <asp:Label ID="Label4" runat="server" Text="Cantidad: "></asp:Label>
    <asp:TextBox ID="qty" runat="server"></asp:TextBox><br /><br />
    <asp:Label ID="Label6" runat="server" Text="Comentario:"></asp:Label>
    <asp:TextBox ID="comments" runat="server" Width="150" TextMode="MultiLine"></asp:TextBox>&nbsp&nbsp&nbsp
    <asp:Button ID="save" runat="server" Text="Guardar" />

    <div style ="margin-left:auto; margin-right:auto; text-align:center">
        <b>Alta Masiva
        <br />
        Ejemplo de Archivo:<br /></b>
        Columna A: Código del Producto<br />
        Columna B: Rack<br />
        Columna C: Cantidad<br />
        <b>No incluir títulos de columnas, el archivo se empieza a leer desde la línea 1</b><br />
        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/upld_excel_file.PNG" Width="360px" /><br /><br />
        Cargar Excel: 
        <asp:FileUpload ID="File1" runat="server" Width="40%" />
        <asp:Button ID="leadexcel" runat="server" Text="Subir Excel" />
        <asp:Label ID="lbl_error_file" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
    </div>

    <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
</asp:Content>

