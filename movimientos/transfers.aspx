<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="transfers.aspx.vb" Inherits="movimientos_transfers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

        <link href="../styles/sunny/jquery-ui-1.8.22.custom.css" rel="stylesheet" type="text/css" />
        <script src="../scripts/jquery.js" type="text/javascript"></script>
        <script src="../scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
        <script src="../scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript"></script>
        <script type="text/javascript">

            $(function () {

                // Tabs
                $('#tabs').tabs();

            });

        </script>

        <style type="text/css">
 
        #pnl1 {
            background-color: gray;
            width: 200px;
            color:White;
            font: 14pt Verdana;
            }
 
        #pnl1_contents {
            padding: 10px;
            }
 
        </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">

<h2 class="demoHeaders">Transferencias</h2>

<div id="tabs">
	<ul>

		<li><a href="#tabs-1">Salida</a></li>
		<li><a href="#tabs-2">Recibir</a></li>

	</ul>

	<div id="tabs-1">
        <table>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="prod_lbl" runat="server" Text="Producto:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="productId" runat="server" AutoPostBack="True"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="invlbl" runat="server" Text="Inventario:"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblinvent" runat="server" Text="" ForeColor="Red"></asp:Label>
                    <asp:GridView ID="invGR" runat="server">
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="fromloc_lbl" runat="server" Text="De Sucursal: "></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="fromlocation" runat="server" AppendDataBoundItems="True" >
                        <asp:ListItem Value="na">Seleccione...</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="fromrack_lbl" runat="server" Text="Rack:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="from_rackTB" runat="server"></asp:TextBox><br />
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="toloc_lbl" runat="server" Text="A Sucursal: "></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="tolocation" runat="server" AppendDataBoundItems="True" >
                        <asp:ListItem Value="na">Seleccione...</asp:ListItem>
                    </asp:DropDownList>
                    </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="qty_lbl" runat="server" Text="Cantidad: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="qty_TB" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="comm_lbl" runat="server" Text="Comentario:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="comments_TB" runat="server" Width="200" TextMode="MultiLine"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="transitlbl" runat="server" Text="Seleccione Transito:"></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="transit_locationDDL" runat="server" AppendDataBoundItems="True">
                        <asp:ListItem Value="na">Seleccione...</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
            <td></td>
            <td>
                <asp:Button ID="save" runat="server" Text="Guardar" />
            </td>
            </tr>
        </table>
        <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
    </div>

    <div id="tabs-2">
        <asp:Label ID="Label1" runat="server" Text="Seleccione Locacion Transitoria"></asp:Label>
        <asp:DropDownList ID="transit_receive_ddl" runat="server" 
            AppendDataBoundItems="True" AutoPostBack="True">
            <asp:ListItem Value="na">Seleccione...</asp:ListItem>
        </asp:DropDownList>
        <asp:Label ID="Label2" runat="server" Text="Inventrio:"></asp:Label>
        <asp:Label ID="lblerrortransit" runat="server" Text="" ForeColor="Red"></asp:Label>
        <asp:GridView ID="transit_inventoryGV" runat="server">
        </asp:GridView>
        <asp:Label ID="Label3" runat="server" Text="Seleccione Sucursal para Recibir:"></asp:Label>
        <asp:DropDownList ID="receive_location_DDL" runat="server">
        </asp:DropDownList><br />
        <asp:Button ID="Recieve" runat="server" Text="Recibir" />
        
    </div>
</div>
    
</asp:Content>

