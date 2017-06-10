<%@ Page Language="VB" AutoEventWireup="false" CodeFile="add_products.aspx.vb" Inherits="add_products" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.dataTables.min.js" type="text/javascript"></script>
    <%--<link href="Styles/Site.css" rel="stylesheet" />--%>
    <link href="Styles/jquery.dataTables.min.css" rel="stylesheet" />
    <script type="text/javascript">
        //$(document).ready(function () {
        //    $('#tablaReportes').dataTable();
        //});
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hifd_order" runat="server" />
        <asp:HiddenField ID="hifd_type" runat="server" />
        <asp:HiddenField ID="hifd_categ" runat="server" />
        <asp:HiddenField ID="hifd_location" runat="server" />
    <div style="text-align:center"><br /><br />
        <asp:Label ID="lbl_html_table" runat="server" Text=""></asp:Label>
        <asp:Button ID="btn_add" runat="server" Text="Agregar" /><br />
        <asp:Label ID="lbl_error_surtir_pedido" runat="server" Text="" CssClass="ErrorLabel"></asp:Label><br /><br />
    </div>
    </form>
</body>
</html>
