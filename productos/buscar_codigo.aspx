<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="buscar_codigo.aspx.vb" Inherits="productos_buscar_codigo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/autocomplete.js" type="text/javascript"></script>
    <link href="../Styles/autocomplete.css" rel="stylesheet" type="text/css" />
    <script src="../Scripts/colorbox/colorbox.js" type="text/javascript"></script>
    <link href="../Scripts/colorbox/colorbox.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        function show_negadas(value) {
            myval = $('#<%=codigo.ClientID%>').val();
            if (myval == "") {
                alert("Ingrese un codigo")
            } else {
                //alert(myval);
                $.colorbox({
                    iframe: true, innerWidth: 550, innerHeight: 400,
                    href: '../negadas.aspx?codigo=' + myval + '&exacta=' + value
                });
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Búsqueda de productos por código </h1>
    <br />
    <hr />
    <div style="float: right">
        <asp:Image ID="img_item" runat="server" ImageUrl="~/images/tapas/no-image.jpg" Height="150px" />
    </div>
    <asp:Panel ID="Panel1" runat="server" DefaultButton="btn_search">        
        <fieldset style="width: 350px; height: 90px;">
            <legend>Código de Producto:</legend>
            <asp:TextBox ID="codigo" runat="server" Width="100px"></asp:TextBox>
            <%--<div id="autocompleteCodig" class="autocompleteContent">
                    <input id="Codigo" name="Codigo" class="textBox" type="text" autocomplete="on"
                        search="Codigo" style="width:200px;" />
            </div>--%>
            <asp:CheckBox ID="chbx_busq_exacta" runat="server" Checked="true" Text="Busqueda Exacta" />
            <asp:Button ID="btn_search" runat="server" Text="Buscar" />
            <br />
            <br />
            <input id="Button1" type="button" value="Reportar Negada" onclick="show_negadas();" />
            <asp:Label ID="lbl_error" runat="server" Text="" ForeColor="Red"></asp:Label>
        </fieldset><br />
    </asp:Panel>
    <hr />
    <br />
    <asp:Label ID="lbl_tot_piezas" runat="server" Font-Bold="true" Text="Total de Piezas: "></asp:Label>
    <asp:Label ID="lbl_total" runat="server" Text="" Font-Size="Large" Font-Bold="true" ForeColor="Blue"></asp:Label><br />
    <br />
    <center>
        <asp:Label ID="lbl_inv" runat="server" Font-Bold="true" Text="Inventario: "></asp:Label><br />
    </center>
    <br />
    <asp:Label ID="lblinvent" runat="server" Text="" ForeColor="Red"></asp:Label>
    <center>
        <asp:GridView ID="inventarioGV" runat="server">
        </asp:GridView>
    </center>
    <br />
    <center>
        <asp:Label ID="Label2" runat="server" Font-Bold="true" Text="Compatibilidad: "></asp:Label><br />
    </center>
    <br />
    <asp:Label ID="lbl_compatibilidad" runat="server" Text="" ForeColor="Red"></asp:Label>
    <center>
        <asp:GridView ID="gv_compativilidad" runat="server">
        </asp:GridView>
    </center>
    <br />
    <center>
        <asp:Label ID="Label4" runat="server" Font-Bold="true" Text="Información: "></asp:Label><br />
    </center>
    <br />
    <center>
        <asp:GridView ID="gv_general_info" runat="server">
        </asp:GridView>
    </center>
    <br />
    <br />


    <%--<script type="text/javascript">
        SetUpAutoComplete();
    </script>--%>
</asp:Content>

