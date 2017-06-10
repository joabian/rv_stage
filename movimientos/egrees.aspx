<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="egrees.aspx.vb" Inherits="movimientos_egrees" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div style="width:30%;float:left">
        <table>
            <tr>
                <td><asp:Label ID="Label1" runat="server" Text="Producto:"></asp:Label></td>
                <td><asp:TextBox ID="productId" runat="server" AutoPostBack="True"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Label ID="Label2" runat="server" Text="Motivo: "></asp:Label></td>
                <td><asp:DropDownList ID="type" runat="server">
                    <asp:ListItem>VENTA</asp:ListItem>
                    <asp:ListItem>SCRAP</asp:ListItem>
                    <asp:ListItem>AJUSTE INVENTARIO</asp:ListItem>
                    <%--<asp:ListItem>Transferencia</asp:ListItem>--%>
                </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td><asp:Label ID="Label3" runat="server" Text="Sucursal: "></asp:Label></td>
                <td><asp:DropDownList ID="location" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Value="0">Seleccionar...</asp:ListItem>
                    </asp:DropDownList>

                </td>
            </tr>
            <tr>
                <td><asp:Label ID="Label5" runat="server" Text="Rack: "></asp:Label></td>
                <td><asp:TextBox ID="rack" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Label ID="Label4" runat="server" Text="Cantidad: "></asp:Label></td>
                <td><asp:TextBox ID="qty" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Label ID="Label6" runat="server" Text="Comentario:"></asp:Label></td>
                <td><asp:TextBox ID="comments" runat="server" Width="150px" Height="150px" TextMode="MultiLine"></asp:TextBox></td>
            </tr>
            <tr>
                <td><asp:Label ID="Label7" runat="server" Text="Cliente:"></asp:Label></td>
                <td><asp:TextBox ID="tbx_cliente" runat="server" Width="200px"></asp:TextBox></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:Button ID="save" runat="server" Text="Guardar" /></td>
            </tr>
        </table>

        <br />
        <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
    </div>
    <div style="width:3px;height:100px;float:left">

    </div>
    <div style="width:20%;float:left">
        <asp:Label ID="lblinvent" runat="server" Text="" ForeColor="Green"></asp:Label>
        <asp:GridView ID="invGR" runat="server">
        </asp:GridView>
    </div>
    <div style ="margin-left:auto; margin-right:auto; text-align:center; float:left;">
        <b>Baja Masiva
        <br />
        Ejemplo de Archivo:<br /></b>
        Columna A: Código del producto<br />
        Columna B: Rack<br />
        Columna C: Cantidad<br />
        <b>No incluir títulos de columnas, el archivo se empieza a leer desde la línea 1</b><br />
        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/upld_excel_file.PNG" Width="360px" /><br /><br />
        Cargar Excel: 
        <asp:FileUpload ID="File1" runat="server" Width="80%" />
        <asp:Button ID="leadexcel" runat="server" Text="Subir Excel" />
        <asp:Label ID="lbl_error_file" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
    </div>
</asp:Content>

