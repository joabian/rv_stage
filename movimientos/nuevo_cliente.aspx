<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="nuevo_cliente.aspx.vb" Inherits="movimientos_nuevo_cliente" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

    <style type="text/css">
        .textEntry {}
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Agregar Cliente</h1>
<div>
        <fieldset>
            <legend>Datos de la Compañía:</legend>
            <table>
                <tr>
                    <td><asp:Label ID="ComanyNameLabel" runat="server" Text="Nombre de Compañía: "></asp:Label></td>
                    <td><asp:TextBox ID="tbx_company" runat="server" CssClass="textEntry"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label7" runat="server" Text="RFC: "></asp:Label></td>
                    <td><asp:TextBox ID="tbx_rfc" runat="server" CssClass="textEntry"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="ContactNameLabel" runat="server" Text="Nombre del Contacto: "></asp:Label></td>
                    <td><asp:TextBox ID="tbx_contact" runat="server" CssClass="textEntry"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="CompanyPhoneLabel" runat="server" Text="Teléfono: "></asp:Label></td>
                    <td><asp:TextBox ID="tbx_phone" runat="server" CssClass="textEntry"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="CompanyEmailLabel" runat="server" Text="Correo Electrónico: "></asp:Label></td>
                    <td><asp:TextBox ID="tbx_email" runat="server" CssClass="textEntry"></asp:TextBox></td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label6" runat="server" Text="Términos de Pago: "></asp:Label></td>
                    <td>
                        <asp:DropDownList ID="ddl_terms" runat="server">
                            <asp:ListItem>N/A</asp:ListItem>
                            <asp:ListItem>EFECTIVO</asp:ListItem>
                            <asp:ListItem>30-DIAS</asp:ListItem>
                            <asp:ListItem>60-DIAS</asp:ListItem>
                            <asp:ListItem>90-DIAS</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td><asp:Label ID="Label9" runat="server" Text="Precio por Default:"></asp:Label></td>
                    <td>
                        <asp:TextBox ID="tbx_precio" runat="server" CssClass="textEntry"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <th colspan="2">Dirección de Facturación</th>
                </tr>
                <tr>
                    <td><asp:Label ID="AddrsStreetLabel" runat="server" Text="Dirección: "></asp:Label></td>
                    <td><asp:TextBox ID="tbx_bill_address" runat="server" CssClass="textEntry" TextMode="MultiLine" Height="150px" Width="312px"></asp:TextBox></td>
                </tr>
                

                <tr>
                    <th colspan="2">Dirección de Envío<br />
                        <asp:CheckBox ID="cbx_same_address" runat="server" Text="Utilizar la misma de facturación" />
                    </th>
                </tr>
                <tr>
                    <td><asp:Label ID="Label1" runat="server" Text="Dirección: "></asp:Label></td>
                    <td><asp:TextBox ID="tbx_ship_address" runat="server" CssClass="textEntry" TextMode="MultiLine" Height="150px" Width="312px"></asp:TextBox></td>
                </tr>
                
                <tr>
                    <td><asp:Label ID="Label8" runat="server" Text="Punto de Venta: "></asp:Label></td>
                    <td>
                        <asp:DropDownList ID="location" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Value="0">Seleccionar...</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lbl_paq" runat="server" Text="Paquetería: "></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbx_paqueteria" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label10" runat="server" Text="Servicio de Paquetería: "></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbx_serv_paq" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label11" runat="server" Text="Flete ($): "></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="tbx_flete" runat="server"></asp:TextBox>
                    </td>
                </tr>


            </table>
            <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
            <br />
            <asp:Button ID="btn_save" runat="server" Visible="false" Text="Guardar" />
            <asp:Button ID="btn_update" runat="server" Visible="false" Text="Actualizar" />
            <asp:HiddenField ID="hifd_cliente" runat="server" />
        </fieldset>
                            
        </div>

</asp:Content>

