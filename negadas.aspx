<%@ Page Language="VB" AutoEventWireup="false" CodeFile="negadas.aspx.vb" Inherits="negadas" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <%--<link href="Styles/Site.css" rel="stylesheet" type="text/css" />--%>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hifd_catego" runat="server" />
    <div style="text-align:center;">
            <asp:Label ID="lbl_report_auto" runat="server" Text="No contamos con este producto, porfavor reportelo negado" Visible="false"></asp:Label>
        
        <br />
        <table style="width:400px; margin-left:auto; margin-right:auto">
            <tr>
                <td style="text-align:right">Codigo</td>
                <td style="text-align:left">
                    <asp:TextBox ID="tbx_codigo" runat="server" Enabled="false" ></asp:TextBox></td>
            </tr>
            <%--<tr>
                <td style="text-align:right">Categoria</td>
                <td style="text-align:left"><asp:DropDownList ID="ddl_catego" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Value="0">Seleccionar...</asp:ListItem>
                    </asp:DropDownList></td>
            </tr>--%>
            <tr>
                <td style="text-align:right">Descripcion</td>
                <td style="text-align:left"><asp:TextBox ID="tbx_description" runat="server" TextMode="MultiLine" Width="250px" Height="55px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="text-align:right">Sucursal</td>
                <td style="text-align:left"><asp:DropDownList ID="ddl_location" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Value="0">Seleccionar...</asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td style="text-align:right">Cliente</td>
                <td style="text-align:left"><asp:TextBox ID="tbx_notas" runat="server" Width="250px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="text-align:right">Cantidad Requerida</td>
                <td style="text-align:left"><asp:TextBox ID="tbx_qty" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="text-align:right"></td>
                <td style="text-align:left"><asp:Button ID="btn_save" runat="server" Text="Guardar" />
                    
                </td>
            </tr>
            <tr>
                <td style="text-align:right"></td>
                <td style="text-align:left"><asp:Label ID="lbl_error" runat="server" Text="" CssClass="error" ForeColor="Red" ></asp:Label></td>
            </tr>
        </table>
            <asp:Button ID="btn_save_2" runat="server" Text="Si" Visible="false" /><br />
            <asp:Button ID="btn_return" runat="server" Text="Regresar" Visible="false" /><br /><br />
        <div style="width:40%; margin-left:auto; margin-right:auto;" >
            <asp:GridView ID="inventarioGV" runat="server" Width="100%">

            </asp:GridView><br />
        </div>


        
    </div>
    </form>
</body>
</html>
