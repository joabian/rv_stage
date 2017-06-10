<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="order_details.aspx.vb" Inherits="reportes_order_details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />    
    <script type="text/javascript">

        function PrintElem(elem) {
            Popup($(elem).html());
        }

        function Popup(data) {
            var mywindow = window.open('', 'my div', 'height=400,width=600');
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
    <asp:HiddenField ID="hf_order_number" runat="server" />
    <div id="Printdiv">

    <asp:Panel ID="panel_header" runat="server">
        <div style=" width:80%; text-align:center; margin-left:auto; margin-right:auto;">
            <div style="text-align:right;padding-right:100px">
                <asp:Button ID="btn_export_word" runat="server" Text="Exportar a Excel" />
                <input type=button name=print value="Imprimir" onclick="PrintElem('#Printdiv')">
                <asp:Button ID="btn_ship" runat="server" Text="Pedido Enviado" />
            </div>
            
            <div style="float:left; width:50%;">
                <table>
                    <tr>
                        <th style="text-align: right; font-size:large">Orden</th>
                        <td style="text-align: left"><asp:Label ID="lbl_order_number" runat="server" Text="" Font-Size="Large" Font-Bold="true" ForeColor="Blue"></asp:Label></td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Fecha de Orden</th>
                        <td style="text-align: left"><asp:Label ID="lbl_date" runat="server" Text=""></asp:Label></td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Estatus</th>
                        <td style="text-align: left">
                            <asp:Label ID="ddl_Status" runat="server" Text=""></asp:Label>
                            
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Fecha de envio requerida</th>
                        <td style="text-align: left">
                            <asp:Label ID="txt_ReqShipDate" runat="server" Text=""></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Vendedor</th>
                        <td style="text-align: left">
                            <asp:Label ID="ddl_vendor" runat="server" Text=""></asp:Label>
                            
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Notas: </th>
                        <td style="text-align: left">
                            <asp:Label ID="txt_notes" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Cajas: </th>
                        <td style="text-align: left">
                            <asp:Label ID="lbl_cajas" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                </table>
            </div>
            <div style="float:left; width:40%; margin-left:5px">
                <table >
                    <tr>
                        <th style="text-align: right">Cliente</th>
                        <td style="text-align: left"><asp:Label ID="lbl_Client" runat="server" Font-Size="Large" ForeColor="Blue"></asp:Label></td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Contacto</th>
                        <td style="text-align: left"><asp:Label ID="txt_contact" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Telefono</th>
                        <td style="text-align: left"><asp:Label ID="txt_Phones" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Email</th>
                        <td style="text-align: left"><asp:Label ID="txt_email" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Direccion de facturacion</th>
                        <td style="text-align: left"><asp:Label ID="txt_Billing_Address" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Direccion de envio</th>
                        <td style="text-align: left"><asp:Label ID="txt_Shipping_Address" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Paqueteria</th>
                        <td style="text-align: left"><asp:Label ID="lbl_paqueteria" runat="server" Text=""></asp:Label>
                            </td>
                    </tr>
                </table>
            </div>
            <br />
            <br />
        </div>
    </asp:Panel>
    <div style="text-align:center;">
        <asp:Label ID="lbl_error" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
        <asp:Label ID="lbl_msg" ForeColor="Green" Font-Size="Large" runat="server" Text=""></asp:Label>
    </div>
    <br /><br />
    <div style="clear:both"></div>    
    <asp:Panel ID="panel_items" runat="server">
        <div style="text-align:center">Lista de productos en la orden:</div>
        <div style="padding:10px; width:65%; text-align:center; margin-left:auto; margin-right:auto; border:2px double black;">
            <asp:GridView ID="gv_Items" runat="server" Width="100%" BorderColor="Black" BorderStyle="Solid">

                <AlternatingRowStyle BackColor="#99CCFF" />
                <HeaderStyle BackColor="#003366" ForeColor="White" />
            </asp:GridView>
        </div>
    </asp:Panel>
    <br />
    <br />
    <asp:Panel ID="panel_totals" runat="server">
        <div style=" width:65%; text-align:right; margin-left:auto; margin-right:auto;">
            <table style="width: 30%; border-collapse:collapse; border-color:black;" border="1" >
                <tr>
                    <th style="text-align: right">Terminos de pago</th>
                    <td style="text-align: left;padding-left:5px;">
                        <asp:Label ID="ddl_terms" runat="server" Text=""></asp:Label>
                        
                    </td>
                </tr>
                <tr>    
                    <th style="text-align: right">Subtotal $:</th>
                    <td style="text-align: left;padding-left:5px;"><asp:Label ID="lbl_subtotal" runat="server" Text=""></asp:Label></td>
                </tr>
                <tr>
                    <th style="text-align: right">Flete:</th>
                    <td style="text-align: left;padding-left:5px;">
                        <asp:TextBox ID="tbx_flete" runat="server"></asp:TextBox>        
                    </td>
                </tr>
                <tr>
                    <th style="text-align: right; ">Total $:</th>
                    <td style="text-align: left;padding-left:5px;font-size:large; color:blue;"><asp:Label ID="lbl_total" runat="server" Text=""></asp:Label></td>
                </tr>
            </table>
            
        </div>
        
    </asp:Panel>
    
    </div>
</asp:Content>

