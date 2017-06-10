<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="prod_categ.aspx.vb" Inherits="productos_prod_categ" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <link href="../Styles/Site.css" rel="stylesheet" />
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    
    <script type="text/javascript">
        function PrintElem(elem) {
            Popup($(elem).html());
        }
        
        function Popup(data) {
            var mywindow = window.open('', 'my div', 'height=600,width=900');
            mywindow.document.write('<html><head><title>my div</title>');
            /*optional stylesheet*/ //mywindow.document.write('<link rel="stylesheet" href="main.css" type="text/css" />');
            mywindow.document.write('</head><body >');
            mywindow.document.write(data);
            mywindow.document.write('</body></html>');

            mywindow.document.close(); // necessary for IE >= 10
            mywindow.focus(); // necessary for IE >= 10

            mywindow.print();
            mywindow.close();

            return true;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <fieldset><legend>Seleccione una Categoría:</legend>
        <asp:DropDownList ID="ddl_category" runat="server" AutoPostBack="True" AppendDataBoundItems="True">
            <asp:ListItem Value="0">Seleccione...</asp:ListItem>
        </asp:DropDownList>&nbsp&nbsp&nbsp&nbsp
        <asp:CheckBox ID="cb_catalogo" runat="server" Text="Incluir Productos dentro de catálogo" Checked="true" />&nbsp&nbsp&nbsp&nbsp
        <asp:CheckBox ID="cb_fuera_catalogo" runat="server" Text="Incluir productos fuera de catalogo" Checked="true" />&nbsp&nbsp&nbsp&nbsp
        <asp:Button ID="btn_run" runat="server" Text="Generar" />&nbsp&nbsp&nbsp&nbsp
        <button type="button" onclick="PrintElem('#Printdiv');">Imprimir</button>
    </fieldset>
    <br />
    <asp:Label ID="lbl_error" runat="server" CssClass="ErrorLabel"></asp:Label>
    <hr />

    <div id="Printdiv">
        <asp:Label ID="lbl_table" runat="server"></asp:Label>
        <%--<img alt="" src="../images/tapas/603-001.jpg" />--%>
    </div>

    
</asp:Content>


