<%@ Page Title="Pedir Ajuste de Inventario" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="pedir_ajuste.aspx.vb" Inherits="movimientos_pedir_ajuste" %>

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

    <script type="text/javascript">
        var cantDisp = 0
        var alias = "";

        $(document).ready(function () {
            $('.solonumeros').keyup(function () {
                this.value = (this.value + '').replace(/[^0-9]/g, '');
            });
        });

        function verificarCombos() {
            if ($("#<%=type.ClientID%>").val() == "-" || $("#<%=location.ClientID%>").val() == "-") {
                document.getElementById('<%=lblMsg.ClientID%>').innerHTML = "Seleccione Tipo de Ajuste y Sucursal"
                $("#Codigo").val("")
                $("#qty").val("")
                $("#rack").val("")
                $("#racks").empty()
                document.getElementById("Codigo").focus();
                return true
            } else {
                document.getElementById('<%=lblMsg.ClientID%>').innerHTML = ""
                return false
            }
        }

        function validarTipo() {
            if ($("#<%=type.ClientID%>").val() == "SALIDA") {
                $("#Codigo").val("")
                $("#qty").val("")
                $("#rack").val("0")
                $("#racks").empty()
                document.getElementById("rack").style.display = 'none'
                document.getElementById("racks").style.display = ''
                document.getElementById("<%=Label7.ClientID%>").style.display = ''
                document.getElementById("cantDisponible").style.display = ''
            } else {
                $("#Codigo").val("")
                $("#qty").val("")
                $("#rack").val("")
                $("#racks").empty()
                document.getElementById("rack").style.display = ''
                document.getElementById("racks").style.display = 'none'
                document.getElementById("<%=Label7.ClientID%>").style.display = 'none'
                document.getElementById("cantDisponible").style.display = 'none'
            }
        }

        function getRacks() {
            if (verificarCombos() == false) {
                var codigo = $("#Codigo").val()
                var codigo_tras = codigo.toUpperCase()
                if ($("#<%=type.ClientID%>").val() == "SALIDA") {
                    var suc = $("#<%=location.ClientID%>").val()    
                    convSucursal(suc)
                    var serializedData = {}
                    serializedData.option = "getRacks"
                    serializedData.fromSuc = suc
                    serializedData.codigo_tras = codigo_tras
                        
                    $.ajax({
                        type: "POST",
                        url: "../ajax_response.aspx",
                        cache: false,
                        data: serializedData,
                        async: false,
                        success: function (data) {
                            if (data != "") {
                                var sel = $("#racks")
                                sel.empty()

                                var lines = [];
                                lines = data.split("]");
                                for (var i = 0; i < lines.length - 1; i++) {
                                    var lineVal = []
                                    lineVal = lines[i].split("}")
                                    sel.append('<option value="' + lineVal[0] + '">' + lineVal[1] + '</option>')
                                }
                                sel.focus()
                            } else {
                                document.getElementById("Codigo").focus()
                                document.getElementById('<%=lblMsg.ClientID%>').innerHTML = "En esa Sucursal no hay Racks con ese Código"
                                return false;
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert(textStatus + errorThrown);
                        }
                    });
                } else if ($("#<%=type.ClientID%>").val() == "ENTRADA") {
                    var suc = $("#<%=location.ClientID%>").val()
                    convSucursal(suc)
                    var serializedData = {}
                    serializedData.option = "validarCodigoforAjusteEntrada";
                    serializedData.Codigo = codigo;

                    $.ajax({
                        type: "POST",
                        url: "../ajax_response.aspx",
                        cache: false,
                        data: serializedData,
                        async: false,
                        success: function (data) {
                            if (data == "") {
                                document.getElementById('<%=lblMsg.ClientID%>').innerHTML = ""
                                return false;
                            } else {
                                document.getElementById("Codigo").focus()
                                document.getElementById('<%=lblMsg.ClientID%>').innerHTML = data
                                return false;
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert(textStatus + errorThrown);
                        }
                    });
                }
            }
        }

        function cantDisponible() {
            if (verificarCombos() == false) {
                if ($("#<%=type.ClientID%>").val() == "SALIDA") {
                    var suc = $("#<%=location.ClientID%>").val()
                    convSucursal(suc);
                    var sucursal = alias
                    var code = $("#Codigo").val()
                    var rack = $("#racks").val()
                    var serializedData = {};
                    serializedData.option = "cantDisponible";
                    serializedData.fromSuc = sucursal;
                    serializedData.codigo_tras = code;
                    serializedData.fromRack = rack;

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
                            $("#qty").focus()
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert(textStatus + errorThrown);
                        }
                    });
                }
            }
        }

        function convSucursal(id) { 
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

        function validarCant() {
            if (verificarCombos() == false) {
                if ($("#<%=type.ClientID%>").val() == "SALIDA") {
                    var cant = $("#qty").val()

                    if (cant == 0) {
                        document.getElementById('<%=lblMsg.ClientID%>').innerHTML = "Ingrese una cantidad mayor a cero"
                        document.getElementById("qty").focus();
                        $("#qty").val("")
                        return false;
                    } else if ((cantDisp - cant) < 0) {
                        document.getElementById('<%=lblMsg.ClientID%>').innerHTML = "Esa cantidad excede lo disponible en el Rack seleccionado"
                        document.getElementById("qty").focus();
                        $("#qty").val("")
                        return false;
                    } else {
                        $("#comments").focus()
                    }
                }
            }
        }

        function guardarAjuste() {
            var tipo = $("#<%=type.ClientID%>").val()
            var suc = $("#<%=location.ClientID%>").val()    
            convSucursal(suc)
            var sucursal = alias
            var codigo = $("#Codigo").val().toUpperCase()   
            var rackEnt = $("#rack").val()
            var rackSal = $("#racks").val()
            var cant = $("#qty").val()
            var comentario = $("#comments").val().toUpperCase()

            var serializedData = {};
            serializedData.option = "guardarAjuste"
            serializedData.tipoAjuste = tipo
            serializedData.suc = sucursal
            serializedData.Codigo = codigo
            serializedData.rackEnt = rackEnt
            serializedData.rackSal = rackSal
            serializedData.qty = cant
            serializedData.comments = comentario

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    alert(data)
                    location.reload(true)
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });            
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server" >
    <h1 align="center">Solicitar ajuste de inventario</h1>
    <br />
    <hr />
    <fieldset>
        <legend>Datos del Ajuste</legend>
        <asp:Label ID="Label2" runat="server" Text="Tipo: "></asp:Label>
        <asp:DropDownList ID="type" runat="server" onchange="validarTipo()">
            <asp:ListItem Value="-">Seleccionar...</asp:ListItem>
            <asp:ListItem Value="ENTRADA">ENTRADA</asp:ListItem>
            <asp:ListItem Value="SALIDA">SALIDA</asp:ListItem>
        </asp:DropDownList>&nbsp&nbsp&nbsp&nbsp
        <asp:Label ID="Label3" runat="server" Text="Sucursal: "></asp:Label>
        <asp:DropDownList ID="location" runat="server" AppendDataBoundItems="true" >
            <asp:ListItem Value="-">Seleccionar...</asp:ListItem>
        </asp:DropDownList>
    </fieldset>
    <hr />
    <center><asp:Label ID="lblMsg" runat="server" Text="" ForeColor="Red" Font-Bold="true"></asp:Label></center>    
    <asp:Panel ID="panel_add_item" runat="server" HorizontalAlign="Center">
        <div id="addItemsDiv" style="text-align: left; width: 50%; margin-left: auto; margin-right: auto;">
            <b>Datos de Producto a Ajustar: </b>
            <table style="width: 100%; border: 1px dotted black; margin-right: auto; margin-left: auto; margin-top: 3px;">
                <tr>                    
                    <td align="right">
                        <asp:Label ID="Label1" runat="server" Text="Producto: " ></asp:Label></td>
                    <td>
                        <div id="autocompleteCodigo" class="autocompleteCodigo">
                            <input type="text" id="Codigo" name="Codigo" class="textBox" autocomplete="on" search="Codigo" style="width: 100px;" onblur="getRacks()" required="true"/>
                        </div>
                    </td>      
                    <td align="right">
                        <asp:Label ID="Label5" runat="server" Text="Rack: " ></asp:Label></td>
                    <td>
                        <input type="text" id="rack" name="rack" style="width:100px;" required="true" />
                        <select id="racks" style="width: 100px; display: none" onblur="cantDisponible()" >
                            <option></option>
                        </select>
                    </td>              
                    <td align="right">
                        <asp:Label ID="Label4" runat="server" Text="Cantidad: "></asp:Label></td>
                    <td>
                        <input type="text" id="qty" name="qty" style="width: 100px;" class="solonumeros" onblur="validarCant()" required="true" />
                    </td>
                    <td ><asp:Label ID="Label7" runat="server" Text="Disponible: " style="display: none"></asp:Label> </td>
                    <td><span id="cantDisponible" style="display: none" >0</span></td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Label ID="Label6" runat="server" Text="Comentario:"></asp:Label></td>
                    <td colspan="7">
                        <textarea id="comments" name="comments" cols="80" rows="4" required="true"></textarea>
                    </td>
                </tr>
            </table>
            <br />
        </div>
        <input type="button" id="btnSave" value="Guardar" onclick="guardarAjuste()"/>
    </asp:Panel>
    <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>

    <script type="text/javascript">
        SetUpAutoComplete();
    </script>

</asp:Content>