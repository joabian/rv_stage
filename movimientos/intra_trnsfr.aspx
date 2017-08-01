<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="intra_trnsfr.aspx.vb" Inherits="movimientos_intra_trnsfr" %>

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
        var i = 0; // Se utiliza en agregarTransfer(), para fungir como el índice de cada registro
        var rowTransfer = []; // Es el arreglo bidimensional usado para la guardar los registro de las transferencias
        var cantDisp = 0; // Se usa en cantDisponible(), para guardar la cantidad disponible del producto en la Sucursal y Rack seleccionados
        var alias = "";

        $(document).ready(function () {
            $('.solonumeros').keyup(function () {
                this.value = (this.value + '').replace(/[^0-9]/g, '');
            });
        });

        function saveTransfer() { // Se lleva a cabo la Transferencia con todos los registros guardados en el arreglo
            var serializedData = {};
            serializedData.option = "hacerTransferencia";
            serializedData.arrayTransfer = rowTransfer.toString();

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    dataLog = data
                    alert(dataLog);
                    location.reload();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function getRacks() { // Se trae los Racks disponibles con cantidades mayores a 0 de la Sucursal de origen seleccionada            
            var fromSuc = $("#<%=ddl_from_location.ClientID%>").val();
            var code = $("#Codigo").val();
            var codigo_tras = code.toUpperCase();
            var errorMsg = document.getElementById("errorMsg");
            errorMsg.innerHTML = "";

            if (fromSuc == "-") {
                errorMsg.innerHTML = "<b> Seleccione una Sucursal de origen </b>";                
                return false;
            } else {
                var serializedData = {};
                serializedData.option = "getRacks";
                serializedData.fromSuc = fromSuc;
                serializedData.codigo_tras = codigo_tras;

                $.ajax({
                    type: "POST",
                    url: "../ajax_response.aspx",
                    cache: false,
                    data: serializedData,
                    async: false,
                    success: function (data) {
                        if (data != "") {
                            var sel = $("#fromRack");
                            sel.empty();

                            var lines = [];
                            lines = data.split("]");
                            for (var i = 0; i < lines.length - 1; i++) {
                                var lineVal = [];
                                lineVal = lines[i].split("}");
                                sel.append('<option value="' + lineVal[0] + '">' + lineVal[1] + '</option>');
                            }
                        } else {
                            document.getElementById("Codigo").focus();
                            errorMsg.innerHTML = "<b> En la Sucursal de origen no hay Racks con ese Código </b>";
                            return false;
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert(textStatus + errorThrown);
                    }
                });
            }            
        }       
        
        function agregarTransfer() { // Se agrega un registro más al arreglo de Transferencias
            var deSuc = $("#<%=ddl_from_location.ClientID%>").val();  
            convSucursal(deSuc);
            var fromSuc = alias;
            var aSuc = $("#<%=ddl_to_location.ClientID%>").val();
            convSucursal(aSuc);
            var toSuc = alias;
            var fromRack = $("#fromRack").val();
            var toRack = $("#<%=toRack.ClientID%>").val();
            toRack = toRack.replace(" ", "");
            var code = $("#Codigo").val();
            var codigo = code.toUpperCase();
            var qty = $("#txtQty").val();
            qty = qty.replace(" ", "");
            var errorMsg = document.getElementById("errorMsg");
            errorMsg.innerHTML = "";

            if (fromSuc == "-" || toSuc == "-" || fromRack == "" || toRack == "" || codigo == "" || qty == "") {
                errorMsg.innerHTML = "<b> Ingrese los datos completos </b>";
                return false;
            } else if (qty == 0) {
                errorMsg.innerHTML = "<b> Ingrese una cantidad mayor a cero </b>";
                document.getElementById("txtQty").focus();
                return false;
            } else if ((cantDisp - qty) < 0) {                
                errorMsg.innerHTML = "<b> Esa cantidad excede lo disponible en el Rack seleccionado </b>";
                document.getElementById("txtQty").focus();
                return false;
            } else {
                rowTransfer[i] = [] // La variable i se declara al inicio del script, para que sea global
                for (j = 0; j < 8; j++) {
                    if (j == 0) {
                        rowTransfer[i][j] = i;
                    } else if (j == 1) {
                        rowTransfer[i][j] = codigo;
                    } else if (j == 2) {
                        rowTransfer[i][j] = fromSuc;
                    } else if (j == 3) {
                        rowTransfer[i][j] = fromRack;
                    } else if (j == 4) {
                        rowTransfer[i][j] = toSuc;
                    } else if (j == 5) {
                        rowTransfer[i][j] = toRack;
                    } else if (j == 6) {
                        rowTransfer[i][j] = qty;
                    } else if (j == 7) {
                        // Este caracter se agrega para ayudar a separar cada fila del arreglo y sea más sencillo recorrerlo en back end
                        rowTransfer[i][j] = "}"; 
                    }
                }
                cargarTablaTransfer();                
                limpiarCampos(toRack);
                i++;
            }            
        }

        function convSucursal(id) { // Los valores de los dropdownlist de Sucursales son id, aquí se convierten al alias, para mostrarlos en la tabla
            var serializedData = {};
            serializedData.option = "convSucursal";
            serializedData.idSucursal = id;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    alias = data;
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function limpiarCampos(toRack) { //  Se limpian los campos necesarios
            if (toRack != "TEMPORAL") {
                $("#<%=toRack.ClientID%>").val("");
            }
            $("#fromRack").empty();
            $("#txtQty").val("");
            $("#Codigo").val("");
            document.getElementById("btnTransfer").style.display = '';
            document.getElementById("Codigo").focus();
            cantDisp = 0;
            document.getElementById("cantDisponible").innerText = cantDisp;
        }

        function cargarTablaTransfer() { // Se carga la tabla de Transferencias
            var itemsTable = document.getElementById("itemsTable");
            var table = "";

            table = "<table class='tableItems' border='1' >";
            table += "<tr><th> Eliminar </th><th> Código </th><th> De Sucursal </th><th> De Rack </th><th> A Sucursal </th><th> A Rack </th><th> Cantidad </th></tr>";
            for (k = 0; k < rowTransfer.length; k++) {
                table += "<tr>";
                table += "<td><a href='#' onclick='deleteItemTransfer(" + k + ");'><img alt='Eliminar' src='../images/icons/gnome_edit_delete.png' style='width:25px' /></a></td>";
                for (j = 1; j < rowTransfer[k].length - 1; j++) { // El id del index 0 no se recorre por que no se muestra en la tabla
                    table += "<td> " + rowTransfer[k][j].toString() + " </td>";
                }
            }
            table += "</tr>";
            table += "</table>";
            itemsTable.innerHTML = table;
        }

        function deleteItemTransfer(id) { // Se elimina un registro de la primera dimensión del arreglo
            rowTransfer.splice(id, 1);
            if (rowTransfer.length == 0) {
                document.getElementById("itemsTable").innerHTML = "";
                document.getElementById("btnTransfer").style.display = 'none';
                document.getElementById("Codigo").focus();
            } else {
                cargarTablaTransfer();
            }            
            i--;
        }

        function cantDisponible() { // Se trae la cantidad disponible en stock del producto en el Rack y Sucursal seleccionados
            var deSuc = $("#<%=ddl_from_location.ClientID%>").val();    
            convSucursal(deSuc);
            var fromSuc = alias;
            var code = $("#Codigo").val();
            var codigo_tras = code.toUpperCase();
            var fromRack = $("#fromRack").val();

            var serializedData = {};
            serializedData.option = "cantDisponible";
            serializedData.fromSuc = fromSuc;
            serializedData.codigo_tras = codigo_tras;
            serializedData.fromRack = fromRack;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    var dataLog = data
                    cantDisp = dataLog
                    var txt = document.getElementById("cantDisponible");
                    txt.innerHTML = dataLog;                    
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Transferencia de productos</h1>
    <br />
    <hr />
    <fieldset>
        <legend>Sucursales de Transferencia</legend>
        De sucursal:&nbsp;&nbsp;
        <asp:DropDownList ID="ddl_from_location" runat="server" AppendDataBoundItems="true" AutoPostBack="true" asp_id="id_Sucursal">
            <asp:ListItem Value="-">Seleccione...</asp:ListItem>
        </asp:DropDownList>&nbsp;&nbsp;
        A sucursal:&nbsp;&nbsp;
        <asp:DropDownList ID="ddl_to_location" runat="server" AppendDataBoundItems="true" AutoPostBack="true" >
            <asp:ListItem Value="-">Seleccione...</asp:ListItem>
        </asp:DropDownList>
    </fieldset>
    <hr />
    <asp:Panel ID="panel_add_item" runat="server">
        <div id="addItemsDiv" style="text-align: left; width: 55%; margin-left: auto; margin-right: auto; display: true">
            <b>Agregar Producto a Transferir: </b>
            <br />
            <table style="width: 100%; border: 1px dotted black; margin-right: auto; margin-left: auto; margin-top: 3px;">
                <tr>
                    <td align="right">Modelo:</td>
                    <td>
                        <div id="autocompleteCodigo" class="autocompleteCodigo">
                            <input type="text" id="Codigo" name="Codigo" class="textBox" autocomplete="on" search="Codigo" style="width: 100px;" onchange="getRacks()" />
                        </div>
                    </td>
                    <td align="right">De Rack:</td>
                    <td>
                        <select id="fromRack" style="width: 100px;" onblur="cantDisponible()"></select>
                    </td>
                    <td align="right">A Rack:</td>
                    <td>
                        <asp:TextBox ID="toRack" runat="server" class="textBox" Style="width: 75px;"></asp:TextBox>
                    </td>
                    <td align="right">Cantidad:</td>
                    <td style="width: 50px">
                        <input type="text" id="txtQty" name="txtQty" style="width: 50px;" class="solonumeros" onblur="agregarTransfer();"/>
                    </td>
                    <td align="right">Disponible: </td>
                    <td><span id="cantDisponible">0</span></td>
                </tr>
            </table>
            <br />
        </div>
    </asp:Panel>
    <div style="clear: both"></div>
    <div id="errorMsg" style="text-align: center; color: red;"></div><br />
    <div id="itemsTable" style="text-align: center"></div><br />
    <center>
        <input type="button" id="btnTransfer" style="display: none;" value="Transferir" onclick="saveTransfer()"/>
        <br />
        <hr />
        <div style="width: 40%;">
            <asp:Label ID="lbl_error" runat="server" Text="" ForeColor="Red"></asp:Label>
            <br />
            <asp:Label ID="lbl_msg" runat="server" Text="" ForeColor="green"></asp:Label>
            <div style="margin-left: auto; margin-right: auto; text-align: center">
                <b>Alta Masiva
            <br />
                    Ejemplo de Archivo:<br />
                </b>
                Columna A: Código del producto<br />
                Columna B: Cantidad<br />
                Columna C: De Rack<br />
                Columna D: A Rack<br />
                <b>No incluir títulos de columnas, el archivo se empieza a leer desde la línea 1</b><br />
                <asp:Image ID="Image1" runat="server" ImageUrl="~/images/file_exemple2.PNG" Width="360px" /><br />
                <br />
                Cargar Excel: 
            <asp:FileUpload ID="File1" runat="server" Width="60%" />
                <asp:Button ID="leadexcel" runat="server" Text="Subir Excel" />
                <asp:Label ID="lbl_error_file" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
            </div>
        </div>
        <div style="clear: both"></div>
        <br />
        <br />
    </center>

    <script type="text/javascript">
        SetUpAutoComplete();
    </script>

</asp:Content>
