<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="new_order.aspx.vb" Inherits="movimientos_new_order" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <script src="../Scripts/autocomplete.js" type="text/javascript"></script>

    <link href="../Styles/autocomplete.css" rel="stylesheet" type="text/css"/>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />    

    <script type="text/javascript">
        //$(function () {
        //    var dates = $("#to_date").datepicker({
        //        numberOfMonths: 1,
        //        changeYear: true,
        //        yearRange: '2010:2200',
        //        dateFormat: 'mm/dd/yy',
        //        //  showWeek: true,
        //        firstDay: 1
        //    });
        //});
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Hacer pedido</h1>
    <br /><hr />
    <asp:Panel ID="panel_header" runat="server">
        <div style="text-align:center">
            <asp:Button ID="btn_open" runat="server" Text="Abrir Nuevo Pedido" />
            <hr />
            
            <asp:Label ID="Label1" runat="server" Text="Modificar un Pedido Abierto:" Font-Bold="true" Font-Size="Medium" />
            <asp:DropDownList ID="ddl_opn_orders" runat="server" AppendDataBoundItems="true">
                <asp:ListItem Value="0">Seleccione...</asp:ListItem>
            </asp:DropDownList>&nbsp&nbsp&nbsp
            <asp:Button ID="btn_update_order" runat="server" Text="Modificar" /><br />
            <asp:Label ID="lbl_error_update" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>

        </div>
        
        <div style="text-align:center; margin-top:20px;">
            <%--<asp:Label ID="lbl_title" runat="server" Text="Nuevo Pedido" Font-Bold="true" Font-Size="Large" />--%>
            
        </div>
        <br /><br />
        <%--<div style=" width:75%; text-align:center; margin-left:auto; margin-right:auto;">
            <table style="width:650px; margin-left:auto; margin-right:auto;">
                <tr>
                    <th style="text-align: right">
                        Cliente
                    </th>
                    <td style="text-align: left">--%>
                        <%--<asp:DropDownList ID="ddl_client" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
                            <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                        </asp:DropDownList>--%>
                        <%--<div id="autocompleteCliente" class="autocompleteContent">
                            <input id="Cliente" name="Cliente" class="textBox" type="text" autocomplete="on"
                            search="Cliente" style="width:400px;" />
                        </div>
                        <asp:Button ID="client_search" runat="server" Text="Buscar" id_ASP="btn_search_client" />
                        <br />
                        <asp:LinkButton ID="LinkButton1" runat="server" PostBackUrl="~/proveedores/agreg_clie.aspx">Nuevo Cliente</asp:LinkButton>
                        <br />
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">
                        Terminos de pago
                    </th>
                    <td style="text-align: left">
                        <asp:DropDownList ID="ddl_terms" runat="server">
                            <asp:ListItem>EFECTIVO</asp:ListItem>
                            <asp:ListItem>30-DIAS</asp:ListItem>
                            <asp:ListItem>60-DIAS</asp:ListItem>
                            <asp:ListItem>90-DIAS</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">
                        Nombre de Contacto
                    </th>
                    <td style="text-align: left">
                        <asp:TextBox ID="tb_contact" runat="server" Width="90%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">
                        Telefono
                    </th>
                    <td style="text-align: left">
                        <asp:TextBox ID="txt_Phones" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">
                        Correo electronico
                    </th>
                    <td style="text-align: left">
                        <asp:TextBox ID="tb_email" runat="server" Width="90%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">
                        Direccion
                    </th>
                    <td style="text-align: left">
                        <asp:TextBox ID="txt_Billing_Address" runat="server" Height="70px" TextMode="MultiLine" 
                            Width="329px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">
                        Direccion de envio
                    </th>
                    <td style="text-align: left">
                        <asp:TextBox ID="txt_Shipping_Address" runat="server" Height="70px" TextMode="MultiLine" 
                            Width="329px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right">
                        Enviar para el dia:
                    </th>
                    <td style="text-align: left">
                        <input type="text" id="to_date" name="to_date" class="textBox" style="width:100px; margin-top:3px;" />
                    </td>

                </tr>
                <tr>
                    <th style="text-align: right">
                        Vendedor
                    </th>
                    <td style="text-align: left;">
                        <asp:DropDownList ID="ddl_vendor" runat="server" Width="90%">
                        </asp:DropDownList> 
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: right"><br />
                        
                    </td>
                </tr>
            </table>
        </div>--%>
        
    </asp:Panel>
    <%--<asp:HiddenField ID="hifd_client" runat="server" />
    <asp:HiddenField ID="hifd_clientName" runat="server" />
    <script type="text/javascript">
        SetUpAutoComplete();
    </script>--%>
    
</asp:Content>

