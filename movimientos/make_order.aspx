<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="make_order.aspx.vb" Inherits="movimientos_make_order" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />   
    <script type="text/javascript">
        var items = new Array;

        function additem() {
            var item = $("#tbx_code_html").val();
            //alert(item);
            items.push(item);
            $("#tbx_code_html").focus();
            updateitemList();

            $("#tbx_code_html").val("");
            
        }

        function updateitemList() {
            var html_table;
            html_table = "<table><tr><th>Codigo</th><tr>"
            for (i = 0; i <= items.length - 1; i++) {
                html_table += "<tr><td>" + items[i] + "</td></tr>"
            }
            html_table += "</table>"
            //$("#scanned_items").innerHTML(html_table);

            var mydiv = document.getElementById("scanned_items");
            mydiv.innerHTML = items.toString();
            
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:HiddenField ID="hf_order_id" runat="server" />
    <div style="text-align:center">
        <asp:Label ID="Label1" runat="server" Text="Pedidos Abiertos" Font-Bold="true" Font-Size="Medium" />
        <asp:DropDownList ID="ddl_opn_orders" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
            <asp:ListItem Value="0">Seleccione...</asp:ListItem>
        </asp:DropDownList>
        
    </div>
    <div style="text-align:center; margin-top:30px;">
        <asp:Label ID="Label3" runat="server" Text="Seleccione Sucursal:"></asp:Label>
        <asp:DropDownList ID="ddl_locations" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
            <asp:ListItem Value="0" Text="Seleccione..."></asp:ListItem>
        </asp:DropDownList>
        <asp:Label ID="Label2" runat="server" Text="Ingrese Producto:"></asp:Label>
        <asp:TextBox ID="tbx_code" runat="server" AutoPostBack="true"></asp:TextBox><br />
        <%--<input id="tbx_code_html" type="text" onChange="additem();"/>--%>

        <asp:Button ID="btn_complete_order" runat="server" Enabled="false" Text="Completar pedido" OnClientClick="return confirm('¿Esta seguro que desea completar este pedido?');" /><br />
        <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
        <asp:Label ID="lbl_msg" runat="server" Text="" ForeColor="Green"></asp:Label>

    </div>
    <%--<div id="scanned_items"></div>--%>
    <div style="text-align:center; margin-left:auto; margin-right:auto; width:1000px; margin-top:20px;">
        <asp:GridView ID="gv_items" runat="server" Width="100%"></asp:GridView>
    </div>
    <asp:HiddenField ID="hifd_location" runat="server" />
</asp:Content>

