<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="sales_order.aspx.vb" Inherits="movimientos_sales_order" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />
    <script src="../Scripts/colorbox/colorbox.js" type="text/javascript"></script>
    <link href="../Scripts/colorbox/colorbox.css" rel="stylesheet" type="text/css" />
    <script src="../Scripts/autocomplete.js" type="text/javascript"></script>
    <link href="../Styles/autocomplete.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .tableItems {
            width: 80%;
            margin-left: auto;
            margin-right: auto;
            border-collapse: collapse;
        }

        .date_hide {
            display: none;
        }
    </style>

    <script type="text/javascript">
        $(function () {
            var dates = $("#<%=txt_ReqShipDate.ClientID%>").datepicker({
                numberOfMonths: 1,
                changeYear: true,
                yearRange: '2010:2200',
                dateFormat: 'mm/dd/yy',
                firstDay: 1
            });
        });

        function refresh() {
            location.reload();
        };

        function add_products(categ) {
            myval = $('#<%=lbl_order_number.ClientID%>').text();
            mylocation = $("#Sucursal").text();

            if (myval == "" || mylocation == 'Seleccionar...') {
                alert("Seleccione Sucursal");
            } else {
                $.colorbox({
                    iframe: true, innerWidth: '80%', innerHeight: 600,
                    href: '../add_products.aspx?orden=' + myval + "&categ=" + categ + "&location=" + mylocation,
                    onClosed: function () {
                        refresh();
                    }
                });
            }
        };

        function getLocations() {
            var serializedData = {};
            serializedData.option = "getLocations";

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    if (data != "") {
                        var sel = $("#Locations");
                        sel.empty();

                        var lines = [];
                        lines = data.split("]");
                        for (var i = 0; i < lines.length - 1; i++) {
                            var lineVal = [];
                            lineVal = lines[i].split("}");
                            sel.append('<option value="' + lineVal[0] + '">' + lineVal[1] + '</option>');
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function getVendedores() {
            var serializedData = {};
            serializedData.option = "getVendedores";

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    if (data != "") {
                        var sel = $("#Vendedores");
                        sel.empty();

                        var lines = [];
                        lines = data.split("]");
                        for (var i = 0; i < lines.length - 1; i++) {
                            var lineVal = [];
                            lineVal = lines[i].split("}");
                            sel.append('<option value="' + lineVal[0] + '">' + lineVal[1] + '</option>');
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function show_negadas(item) {
            cliente = $('#<%=lbl_Client.ClientID%>').text();
            sucursal = $("#Locations :selected").text();
            //alert(sucursal)

            $.colorbox({
                iframe: true, innerWidth: 450, innerHeight: 350,
                href: '../negadas.aspx?codigo=' + item + "&cliente=" + cliente + "&sucursal=" + sucursal
            });
        }

        function show_negadas_pedidos(value) {
            //alert(value);
            //if (myval == "") {
            //    alert("Ingrese un codigo")
            //} else {
            //    //alert(myval);
            $.colorbox({
                iframe: true, innerWidth: 450, innerHeight: 350,
                href: '../negadas.aspx' + value
            });
            //}
        }

        function refresh() {
            myorder = <%=hf_order_number.Value%>
            location.href = 'sales_order.aspx?order=' + myorder
            //hf_order_number
        };

        function DeleteItem(id) {
            var serializedData = {};
            serializedData.option = "removeItemFromPedido";
            serializedData.idItem = id;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    loatTableItems();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function cleanDiv() {
            var txt = document.getElementById("tableInventory");
            txt.innerHTML = "";
        }

        $(function () {
            //Tabs
            $('#tabs').tabs();
        });

        function showDispo() {
            var URL = "../ajax_response.aspx";
            URL += "?option=getInventoryNew";
            URL += "&code=" + $("#Codigo").val();
            URL += "&location=" + $("#Locations").val();

            $.ajax({
                type: "POST",
                url: URL,
                cache: false,
                async: false,
                success: function (data) {
                    //alert(data);
                    dataLOG = data;
                    var txt = document.getElementById("qty_dispo");
                    txt.innerHTML = dataLOG;
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function saveItem() {
            var pedido = $('#<%=lbl_order_number.ClientID%>').text();
            var item = $("#Codigo").val();
            var qty = $("#txt_qty").val();
            var suc = $("#Locations").val();

            var serializedData = {};
            serializedData.option = "ingresarItemAPedido";
            serializedData.item = item;
            serializedData.pedido = pedido;
            serializedData.qty = qty;
            serializedData.suc = suc;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    if (data == "ok") {
                        loatTableItems();
                        $("#Codigo").val("");
                        $("#txt_qty").val("");
                        var textbox = document.getElementById("Codigo");
                        textbox.focus();
                        textbox.scrollIntoView();
                    } else {
                        //alert(data)
                        show_negadas(item);
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function loatTableItems() {
            var pedido = $('#<%=lbl_order_number.ClientID%>').text();

            var serializedData = {};
            serializedData.option = "loadTableItems";
            serializedData.pedido = pedido;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    //alert(data);
                    dataLOG = data;
                    //itemsTable
                    var txt = document.getElementById("itemsTable");
                    txt.innerHTML = dataLOG;
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function editDate(id) {
            var mycontrol = "new_date_" + id
            var myeditimage = "img_" + id
            var mylabel = "label_" + id
            var mySaveImg = "img_save_" + id

            $("#" + mycontrol).show();
            $("#" + mySaveImg).show();
            $("#" + myeditimage).hide();
            $("#" + mylabel).hide();
        }

        function saveNewDate(id) {
            var mycontrol = "new_date_" + id;
            var newPrice = $("#" + mycontrol).val();

            if (newPrice == "") {
                alert("Enter date");
            } else {
                var serializedData = {};
                serializedData.option = "editPrice";
                serializedData.newPrice = newPrice;
                serializedData.id_item_pedido = id;
                $.ajax(
                {
                    type: "POST",
                    url: "../ajax_response.aspx",
                    cache: false,
                    data: serializedData,
                    async: false,
                    success: function (data) {
                        alert(data);
                    }
                });
            }
        }

        function loadOrderInfo() {
            var pedido = $('#<%=lbl_order_number.ClientID%>').text();

            var serializedData = {};
            serializedData.option = "loadOrderInfo";
            serializedData.pedido = pedido;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    if (data != "") {
                        var vals = [];
                        vals = data.split("}");
                        $("#Cliente").val(vals[0]);
                        $("#Locations").val(vals[1]);
                        $("#Vendedores").val(vals[2]);

                        if (vals[3] == "True") {
                            $("#chbx_urgency").prop('checked', true);
                        } else {
                            $("#chbx_urgency").prop('checked', false);
                        }

                        if (vals[4] == "True") {
                            $("#chbx_transfer").prop('checked', true);
                        } else {
                            $("#chbx_transfer").prop('checked', false);
                        }

                        if (vals[0] == "no data") {
                            $("#addItemsDiv").hide();
                            $("#div_actions").hide();
                            $("#div-excel").hide();
                            $("#btn_add_items").show();
                        } else {
                            $("#addItemsDiv").show();
                            $("#div_actions").show();
                            $("#div-excel").show();
                            $("#btn_add_items").hide();
                        }
                    }
                    loatTableItems();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function SaveOrderInfo() {
            var pedido = $('#<%=lbl_order_number.ClientID%>').text();
            var cliente = $('#Cliente').val();
            var sucursal = $('#Locations').val();
            var vendedor = $("#Vendedores").val();
            var paqueteria = $("#ddl_paqueteria").val();;
            var urgent;
            var transfer;
            if ($("#chbx_urgency").is(':checked')) {
                urgent = "1";
            } else {
                urgent = "0";
            }

            if ($("#chbx_transfer").is(':checked')) {
                transfer = "1";
            } else {
                transfer = "0";
            }

            var serializedData = {};
            serializedData.option = "SaveOrderInfo";
            serializedData.pedido = pedido;
            serializedData.cliente = cliente;
            serializedData.location = sucursal;
            serializedData.vendedor = vendedor;
            serializedData.paqueteria = paqueteria;
            serializedData.urgent = urgent;
            serializedData.transfer = transfer;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    $("#addItemsDiv").show();
                    $("#div_actions").show();
                    $("#div-excel").show();
                    $("#btn_add_items").hide();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:HiddenField ID="hf_order_number" runat="server" />
    <div id="tabs">
        <ul>
            <li><a href="#tabs-2">Nuevo Pedido</a></li>
            <%--<li><a href="#tabs-1">Informacion de Cliente</a></li>
            <li><a href="#tabs-3">Subir pedido ya surtido</a></li>
            <li><a href="#tabs-4">Tapas</a></li>
            <li><a href="#tabs-5">Radiadores</a></li>
            <li><a href="#tabs-6">Depositos</a></li>
            <li><a href="#tabs-7">Accesorios</a></li>--%>
            <%--<li><a href="#tabs-4">Totales</a></li>--%>
        </ul>
        <%--<div id="tabs-1">
            <div style="min-height:350px">
                
            </div>
        </div>--%>
        <div id="tabs-2">
            <asp:Panel ID="panel_header" runat="server">
                <table style="width: 750px; margin-left: auto; margin-right: auto;">
                    <tr>
                        <th style="text-align: right">
                            # Pedido: 
                        </th>
                        <td style="text-align: left">
                            <asp:Label ID="lbl_order_number" runat="server" Text="" Font-Size="Large" Font-Bold="true" ForeColor="Blue"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Estatus: </th>
                        <td style="text-align: left">
                            <asp:Label ID="lbl_status" runat="server" Text="" Font-Size="Large" Font-Bold="true" ForeColor="Blue"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">
                            Cliente: 
                        </th>
                        <td style="text-align: left">
                            <%--<asp:DropDownList ID="ddl_client" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
                                <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                            </asp:DropDownList>--%>
                            <div id="autocompleteCliente" class="autocompleteContent">
                                <input id="Cliente" name="Cliente" class="textBox" type="text" autocomplete="on"
                                search="Cliente" style="width:400px;"  />
                                <%--onblur="saveCliente();"--%>
                                <input class="textBox" style="display:none" id="id_Cliente" name="id_Cliente" asp_id="id_Cliente"  />
                            </div>
                            <%--<br />
                            <asp:LinkButton ID="LinkButton1" runat="server" PostBackUrl="~/proveedores/agreg_clie.aspx">Nuevo Cliente</asp:LinkButton>
                            <br />--%>
                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">
                            Paquetería: 
                        </th>
                        <td style="text-align: left">
                            <select id="ddl_paqueteria">
                                <option value="Estrella Blanca">Estrella Blanca</option>
                                <option value="Red Pack">Red Pack</option>
                                <option value="Megaexpress">Megaexpress</option>
                                <option value="Estafeta">Estafeta</option>
                                <option value="Omnibus">Omnibus</option>
                                <option value="Aeropuerto">Aeropuerto</option>
                                <option value="Particular">Particular</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                    <th style="text-align: right">Vendedor: </th>
                                <td style="text-align: left">
                                    <%--<asp:DropDownList ID="ddl_vendor" runat="server" Width="100%" AppendDataBoundItems="true">
                                        <asp:ListItem Value="0">Sin asignar</asp:ListItem>
                                    </asp:DropDownList>--%>
                                    <%--<div id="autocompleteVendedor" class="autocompleteContent">
                                        <input id="Vendedor" name="Vendedor" class="textBox" type="text" autocomplete="on"
                                        search="Vendedor" style="width:400px;" />--%>

                                        <%--onblur="saveVendedor();"--%>
                                        
                                        <%--<input class="textBox" style="display:none" id="id_Vendedor" name="id_Vendedor" asp_id="id_Vendedor"  />--%>
                                    <%--</div>--%>
                                    <select id="Vendedores">
                                        <option></option>

                                    </select>
                                </td>

                </tr>
                    <tr>
                        <th style="text-align: right">Punto de Venta: </th>
                        <td style="text-align: left"><%--<asp:Label ID="lbl_location" runat="server" Text=""></asp:Label>--%>
                            <%--<asp:DropDownList ID="ddl_location" runat="server" AppendDataBoundItems="true">
                                        <asp:ListItem Value="0">Seleccionar...</asp:ListItem>
                                    </asp:DropDownList>--%>
                            <%--<div id="autocompleteSucursalID" class="autocompleteContentID">
                                        <input id="Sucursal" name="Sucursal" class="textBox" type="text" autocomplete="on"
                                        search="Sucursal" style="width:400px;" />--%>
                                        <%--onblur="saveSucursal();"--%>
                                        <%--<input class="textBox" style="display:none" id="id_Sucursal" name="id_Sucursal" asp_id="id_Sucursal"  />--%>
                                        <%--4.0.0x18--%>
                                    <%--</div>--%>
                                    <select id="Locations"></select>
                                </td>
                            </tr>
                    <tr>
                        <th style="text-align: right">
                            Urgente: 
                        </th>
                        <td style="text-align: left">
                            <%--<asp:CheckBox ID="chbx_urgency" runat="server" />--%>
                            <input id="chbx_urgency" type="checkbox" />

                        </td>
                    </tr>
                    <tr>
                        <th style="text-align: right">
                            Transferencia: 
                        </th>
                        <td style="text-align: left">
                            <%--<asp:CheckBox ID="chbx_urgency" runat="server" />--%>
                            <input id="chbx_transfer" type="checkbox" />

                        </td>
                    </tr>

                    <tr>
                        <th style="text-align: right">
                        </th>
                        <td style="text-align: left">
                            <br />
                            <input id="btn_add_items" type="button" value="Agregar Articulo" onclick="SaveOrderInfo();" />
                        </td>
                    </tr>
                </table>
                <div style="width: 90%; margin-left: auto; margin-right: auto; display: none">
                    <table style="width: 100%">
                        <tr>
                            <th style="text-align: right; width: 10%">Orden</th>
                            <td style="text-align: left; width: 40%"></td>
                            <th style="text-align: right; width: 10%">Cliente</th>
                            <td style="text-align: left; width: 40%">
                                <asp:Label ID="lbl_Client" runat="server" Font-Size="Large" ForeColor="Blue"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: right">Contacto</th>
                            <td style="text-align: left">
                                <asp:TextBox ID="txt_contact" runat="server" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: right">Fecha de Captura</th>
                            <td style="text-align: left">
                                <asp:Label ID="lbl_date" runat="server" Text=""></asp:Label>
                            </td>
                            <th style="text-align: right">Telefono</th>
                            <td style="text-align: left">
                                <asp:TextBox ID="txt_Phones" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: right">Fecha de envio requerida</th>
                            <td style="text-align: left">
                                <asp:TextBox ID="txt_ReqShipDate" runat="server"></asp:TextBox>
                            </td>
                            <th style="text-align: right">Email</th>
                            <td style="text-align: left">
                                <asp:TextBox ID="txt_email" runat="server" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: right">Direccion de facturacion</th>
                            <td>
                                <asp:TextBox ID="txt_Billing_Address" runat="server" Height="70px" TextMode="MultiLine" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <th style="text-align: right">Notas: </th>
                            <td>
                                <asp:TextBox ID="txt_notes" runat="server" Height="80px" TextMode="MultiLine" Width="100%"></asp:TextBox>
                            </td>
                            <th style="text-align: right">Direccion de envio</th>
                            <td style="text-align: left">
                                <asp:TextBox ID="txt_Shipping_Address" runat="server" Height="70px" TextMode="MultiLine" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <%--<th style="text-align: right">Precio de tapa: </th>
                                <td><asp:TextBox ID="tbx_precio" runat="server" Width="100%"></asp:TextBox></td>--%>
                        </tr>
                        <tr>
                            <th style="text-align: right">Guia: </th>
                            <td>
                                <asp:TextBox ID="tbx_guia" runat="server" Width="100%"></asp:TextBox>
                            </td>
                            <th style="text-align: right"></th>
                            <td>
                                <asp:Button ID="btn_save" runat="server" Text="Guardar datos" />
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <div style="text-align: center;">
                        <asp:Label ID="lbl_error" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
                        <asp:Label ID="lbl_msg" ForeColor="Green" Font-Size="Large" runat="server" Text=""></asp:Label>
                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="panel_add_item" runat="server">
                <div id="addItemsDiv" style="text-align: left; width: 50%; margin-left: auto; margin-right: auto; display: none">
                    Agregar Producto:
                    <table style="width: 100%; border: 1px dotted black; margin-right: auto; margin-left: auto;">
                        <tr>
                            <td>Código:</td>
                            <td>
                                <%--<input type="text" id="txt_code" name="txt_code" style="Width:80px;" onkeyup="getInfo();" />--%>
                                <div id="autocompleteCodigo" class="autocompleteCodigo">
                                    <input id="Codigo" name="Codigo" class="textBox" type="text" autocomplete="on"
                                        search="Codigo" style="width: 150px;" onblur="showDispo();" />
                                </div>
                            </td>
                            <td>Cantidad:</td>
                            <td>
                                <input type="text" id="txt_qty" name="txt_qty" style="width: 47px;" onchange="saveItem();" />
                            </td>
                            <td>Disponible:</td>
                            <td style="width: 50px">
                                <span id="qty_dispo">0</span>
                            </td>
                            <%--<td>
                                <asp:Button ID="btn_Add" runat="server" Text="Agregar" />
                            </td>--%>
                        </tr>
                    </table>
                    <div id="tableInventory" style="text-align: left;"></div>
                    <br />
                    <%--<div style="text-align:center">
                
                        <asp:TextBox ID="codigo" runat="server" Width="100px"></asp:TextBox>
                            <input id="Button1" type="button" value="Reportar Negada" onclick="show_negadas();" />
            
                    </div>
                    <br />--%>
                </div>
            </asp:Panel>
            <%--<asp:Panel ID="panel_items" runat="server">
                <div style="text-align:center">
                    Lista de productos en la orden:</div>
                <div style="padding:10px; width:65%; text-align:center; margin-left:auto; margin-right:auto; border:2px double black;">
                    <asp:GridView ID="gv_Items" runat="server" Width="100%" BorderColor="Black" BorderStyle="Solid">
                        <AlternatingRowStyle BackColor="#99CCFF" />
                        <HeaderStyle BackColor="#003366" ForeColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="Borrar">
                                <ItemTemplate>
                                    <asp:ImageButton ID="img_btn_delete" runat="server" CausesValidation="False" 
                                        CommandName="Delete" ImageUrl="~/images/icons/gnome_edit_delete.png" Width="30px" 
                                        OnClientClick="return confirm('Esta seguro que desea eliminar este item de su orden?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>--%>
            <div style="text-align:center">
                <asp:Label ID="lbl_file_errors" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
            </div>
            <div id="itemsTable" style="text-align:center">
            </div>
            <br />
            <div id="div-excel" style ="margin-left:auto; margin-right:auto; text-align:center; display:none">
                    <hr />
                    
                    Cargar Excel: 
                    Ejemplo de Archivo:<br />
                Columna A: Código del Producto<br />
                Columna B: Cantidad Pedida<br />
                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/file_exemple1.PNG" Width="360px" />
                <br />
                <asp:FileUpload ID="File1" runat="server" Width="40%" />
                <asp:Button ID="leadexcel" runat="server" Text="Subir Excel" />
                <br />
                <asp:Label ID="lbl_error_file" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
                <hr />
            </div>
            <div id="div_actions" style="text-align: center; display: none">
                <asp:Button ID="btn_surtir" runat="server" Text="Mandar a surtir" CssClass="submitButton" />
                <asp:Button ID="btn_ship" runat="server" Text="Enviar a Cliente" CssClass="submitButton" />
                <asp:Button ID="btn_deliver" runat="server" Text="Entregada" CssClass="submitButton" />
            </div>
            <div id="div_c" style="text-align: center">
                <br />
                <br />
                <asp:Button ID="btn_cancel" runat="server" Text="Cancelar Orden" CssClass="submitButton" />
            </div>
            <br />
        </div>

        <%--<div id="tabs-3">
            <asp:Panel ID="panel_surtir_pedido" runat="server">
                <div style ="margin-left:auto; margin-right:auto; text-align:center">
                    <asp:Label ID="label11" runat="server" Text="Subir Excel de pedido ya surtido" Font-Size="Medium"></asp:Label>
                    <br />
                    Ejemplo de Archivo:<br />
                    Columna A: Codigo del producto<br />
                    Columna B: Cantidad Pedida<br />
                    Columna C: Cantidad Surtida<br />
                    Columna D: Rack de dende se doscontara<br /> <b>No incluir titulos de columnas, el archivo se empieza a leer desde la linea 1</b><br />
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/images/file_exemple3.PNG" Width="360px" />
                    <br />
                    <asp:FileUpload ID="fu_archivo_pedido" runat="server" Width="70%" />
                    <asp:Button ID="btn_surtir_pedido" runat="server" Text="Subir Excel" />
                    <br />
                    <asp:Label ID="lbl_error_surtir_pedido" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
                    <br />
                    <br />
                </div>
            </asp:Panel>
        </div>--%>

        <%--<div id="tabs-4">
            <asp:Panel ID="panel_totals" runat="server">
                <div style=" width:65%; text-align:right; margin-left:auto; margin-right:auto;">
                    <table style="width: 30%; border-collapse:collapse; border-color:black;" border="1" >
                        <tr>
                            <th style="text-align: right">Terminos de pago</th>
                            <td style="text-align: left;padding-left:5px;">
                                <asp:DropDownList ID="ddl_terms" runat="server">
                                    <asp:ListItem>EFECTIVO</asp:ListItem>
                                    <asp:ListItem>30-DIAS</asp:ListItem>
                                    <asp:ListItem>60-DIAS</asp:ListItem>
                                    <asp:ListItem>90-DIAS</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>    
                            <th style="text-align: right">Subtotal $:</th>
                            <td style="text-align: left;padding-left:5px;"><asp:Label ID="lbl_subtotal" runat="server" Text=""></asp:Label></td>
                        </tr>
                        <tr>
                            <th style="text-align:right;">IVA %:</th>
                            <td style="text-align: left;padding-left:5px;"><asp:TextBox ID="txt_Tax" runat="server"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <th style="text-align: right;">Total $:</th>
                            <td style="text-align: left;padding-left:5px;font-size:large; color:blue;"><asp:Label ID="lbl_total" runat="server" Text=""></asp:Label></td>
                        </tr>
                    </table>
                    
                </div>
        
            </asp:Panel>
        </div>--%>

        <%--<div id="tabs-4">
            <asp:Panel ID="panel1" runat="server" >
                <div style ="margin-left:auto; margin-right:auto; text-align:center">
                    <div id="div_table_tapas"></div>
                    <br />
                    <input id="btn_add_tapas" type="button" value="Agregar Tapas" onclick="add_tapas();" />
                </div>
            </asp:Panel>
        </div>--%>

        <%--<div id="tabs-5">
            <asp:Panel ID="panel2" runat="server" >
                <div style ="margin-left:auto; margin-right:auto; text-align:center">
                    <div id="div_table_radiadores"></div>
                    <br />
                    <input id="btn_add_radiadores" type="button" value="Agregar Radiadores" onclick="add_radiadores();" />
                </div>
            </asp:Panel>
        </div>--%>

        <%--<div id="tabs-6">
            <asp:Panel ID="panel3" runat="server" >
                <div style ="margin-left:auto; margin-right:auto; text-align:center">
                    <div id="div_table_depositos"></div>
                    <br />
                    <input id="btn_add_depositos" type="button" value="Agregar Depositos" onclick="add_depositos();" />
                </div>
            </asp:Panel>
        </div>--%>

        <%--<div id="tabs-7">
            <asp:Panel ID="panel4" runat="server" >
                <div style ="margin-left:auto; margin-right:auto; text-align:center">
                    <div id="div_table_accesorios"></div>
                    <br />
                    <input id="btn_add_accesorios" type="button" value="Agregar Accesorios" onclick="add_accesorios();" />
                </div>
            </asp:Panel>
        </div>--%>
    </div>
    <script type="text/javascript">
        getLocations();
        getVendedores();
        SetUpAutoComplete();
        loadOrderInfo();
    </script>
</asp:Content>
