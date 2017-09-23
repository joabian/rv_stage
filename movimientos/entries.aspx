<%@ Page Title="Entrada de Productos" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="entries.aspx.vb" Inherits="movimientos_entries" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Entrada de productos</h1>
    <br />
    <hr />
    <fieldset style="width:30%; float:left">
        <legend>Datos de Producto</legend>
        <asp:Label ID="lblMsg" runat="server" Text="PARA PEDIR UN AJUSTE HAGA CLICK " ForeColor="Red" Font-Bold="true" ></asp:Label>
        <asp:HyperLink ID="linkAjustes" runat="server" Text="AQUÍ" NavigateUrl="~/movimientos/pedir_ajuste.aspx" Font-Bold="true"></asp:HyperLink>
        <br /><br />
        <table>
            <tr>
                <th><asp:Label ID="Label1" runat="server" Text="Producto: "></asp:Label></th>
                <td><asp:TextBox ID="productId" runat="server"></asp:TextBox><br /></td>
            </tr>
            <tr>
                <th><asp:Label ID="Label2" runat="server" Text="Motivo: "></asp:Label></th>
                <td>
                    <asp:DropDownList ID="type" runat="server">
                        <asp:ListItem>COMPRA</asp:ListItem>
                        <asp:ListItem>DEVOLUCIÓN</asp:ListItem>
                        <%--<asp:ListItem>AJUSTE INVENTARIO</asp:ListItem>--%>
                        <%--<asp:ListItem>Transferencia</asp:ListItem>--%>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th><asp:Label ID="Label3" runat="server" Text="Sucursal: "></asp:Label></th>
                <td>
                    <asp:DropDownList ID="location" runat="server">
                        <asp:ListItem Value="-">Seleccionar...</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <th><asp:Label ID="Label5" runat="server" Text="Rack: "></asp:Label></th>
                <td><asp:TextBox ID="rack" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <th><asp:Label ID="Label4" runat="server" Text="Cantidad: "></asp:Label></th>
                <td><asp:TextBox ID="qty" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <th><asp:Label ID="Label6" runat="server" Text="Comentario:"></asp:Label></th>
                <td><asp:TextBox ID="comments" runat="server" Width="150px" Height="150px" TextMode="MultiLine"></asp:TextBox></td>
            </tr>
            <tr>
                <th></th>
                <td><asp:Button ID="save" runat="server" Text="Guardar" /></td>
            </tr>
        </table>
    </fieldset>

    <div style ="margin-top:20px; margin-left:100px; text-align:center; float:left;">
        <b>Alta Masiva
        <br />
            Ejemplo de Archivo:<br />
        </b>
        Columna A: Código del Producto<br />
        Columna B: Rack<br />
        Columna C: Cantidad<br />
        <b>No incluir títulos de columnas, el archivo se empieza a leer desde la línea 1</b><br />
        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/upld_excel_file.PNG" Width="360px" /><br />
        <br />
        Cargar Excel: 
        <asp:FileUpload ID="File1" runat="server"/>
        <asp:Button ID="leadexcel" runat="server" Text="Subir Excel" />
        <asp:Label ID="lbl_error_file" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
    </div>

    <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
</asp:Content>

