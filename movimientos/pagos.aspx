<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="pagos.aspx.vb" Inherits="movimientos_pagos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {
            $('.solonumeros').keyup(function () {
                this.value = (this.value + '').replace(/[^0-9]/g, '');
            });
        });

        function getOrders() {
            document.getElementById("<%=tblFormPagos.ClientID%>").style.display = "none"            
            document.getElementById("noOrden").innerText = ""
            document.getElementById("noOrden").disabled = false
            document.getElementById("btnRegPago").style.display = "none"
            document.getElementById("<%=lblTitulo.ClientID%>").style.display = "none"
            document.getElementById("<%=lblError.ClientID%>").innerText = ""
            document.getElementById("<%=lblExito.ClientID%>").innerText = ""
            $("#<%=txtPago.ClientID%>").val("")

            var cliente = $("#<%=ddlCliente.ClientID%>").val();

            var serializedData = {};
            serializedData.option = "getOrdersfromClient";  
            serializedData.idCliente = cliente;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    if (data != "") {
                        var sel = $("#noOrden");
                        sel.empty();

                        var lines = [];
                        lines = data.split(",");
                        for (var i = 0; i < lines.length - 1; i++) {
                            sel.append('<option value="' + lines[i] + '">' + lines[i] + " - " + lines[i + 1] + '</option>');
                            i++
                        }
                        mostrarFormulario()
                    } else {
                        document.getElementById("noOrden").disabled = true
                        document.getElementById("<%=tblFormPagos.ClientID%>").style.display = "none"
                        document.getElementById("btnRegPago").style.display = "none"
                        document.getElementById("<%=lblTitulo.ClientID%>").style.display = "none"
                        document.getElementById("<%=lblError.ClientID%>").innerText = "El Cliente seleccionado no tiene órdenes pendientes de pago"
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    document.getElementById("noOrden").innerText = ""
                    document.getElementById("noOrden").disabled = false
                    alert(textStatus + errorThrown + ": Escoja un Cliente");
                }
            });
        }

        function mostrarFormulario() {
            var cliente = $("#<%=ddlCliente.ClientID%>").val() 
            var orden = $("#noOrden").val()
            $("#<%=hfClienteID.ClientID%>").val(cliente)      
            $("#<%=hfOrden.ClientID%>").val(orden)
            $("#<%=txtPago.ClientID%>").val("")
            
            document.getElementById("<%=tblFormPagos.ClientID%>").style.display = ""
            document.getElementById("<%=lblTitulo.ClientID%>").style.display = ""
            document.getElementById("btnRegPago").style.display = ""            
            document.getElementById("<%=noOrder.ClientID%>").innerText = orden
            document.getElementById("<%=lblExito.ClientID%>").innerText = ""
            
            var serializedData = {};
            serializedData.option = "getClient";
            serializedData.idCliente = cliente;
            serializedData.idOrden = orden;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    var lines = [];
                    lines = data.split("}");
                    for (var i = 0; i < lines.length; i++) {
                        if (i == 0) {
                            document.getElementById("<%=nombreCliente.ClientID%>").innerText = lines[i]
                        } else if (i == 1) {
                            $("#<%=hfTotal.ClientID%>").val(lines[i]) 
                            document.getElementById("<%=total.ClientID%>").innerText = lines[i+1]                            
                        } else if (i == 3) {
                            $("#<%=hfAdeudo.ClientID%>").val(lines[i]) 
                            document.getElementById("<%=adeudo.ClientID%>").innerText = lines[i+1]                            
                        }
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function checarPago() {
            document.getElementById("<%=lblExito.ClientID%>").innerText = ""
            pago = $("#<%=txtPago.ClientID%>").val()
            if (pago == "") {
                document.getElementById("<%=lblError.ClientID%>").innerText = "Ingrese una cantidad"
            } else if (pago == 0) {
                document.getElementById("<%=lblError.ClientID%>").innerText = "Ingrese una cantidad mayor a 0"
                $("#<%=txtPago.ClientID%>").val("")
                document.getElementById("<%=txtPago.ClientID%>").focus()
            } else {
                adeudo = $("#<%=hfAdeudo.ClientID%>").val()
                var resto = adeudo - pago
                if (resto < 0) {
                    document.getElementById("<%=lblError.ClientID%>").innerText = "El pago ingresado excede el adeudo, teclee el pago de nuevo"
                    $("#<%=txtPago.ClientID%>").val("")
                    document.getElementById("<%=txtPago.ClientID%>").focus()
                } else {
                    document.getElementById("<%=lblError.ClientID%>").innerText = ""                    
                    var cliente = $("#<%=ddlCliente.ClientID%>").val()
                    var orden = $("#noOrden").val()
                    var restante = resto.toString()

                    var serializedData = {};
                    serializedData.option = "registrarPago";
                    serializedData.idCliente = cliente;
                    serializedData.idOrden = orden;
                    serializedData.deuda = adeudo;
                    serializedData.abono = pago;
                    serializedData.restante = restante

                    $.ajax({
                        type: "POST",
                        url: "../ajax_response.aspx",
                        cache: false,
                        data: serializedData,
                        async: false,
                        success: function (data) {
                            document.getElementById("<%=lblExito.ClientID%>").innerText = data

                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            alert(textStatus + errorThrown);
                        }
                    });
                }
            }
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Registro de pagos</h1>
    <br />
    <hr />
    <fieldset>
        <legend>Filtros:</legend>
        <asp:Label runat="server">Cliente:</asp:Label>
        <asp:DropDownList ID="ddlCliente" runat="server" AppendDataBoundItems="true" onchange="getOrders()">
            <asp:ListItem Value="-" Text="Seleccionar..."></asp:ListItem>
        </asp:DropDownList>&nbsp&nbsp
        <asp:Label runat="server">Seleccionar Orden:</asp:Label>
        <select id="noOrden" style=" width: 130px" disabled="disabled" onchange="mostrarFormulario()"></select>       
    </fieldset>
    <hr />
    <center>
        <asp:Label ID="lblExito" runat="server" Text="" ForeColor="Blue"></asp:Label>
        <asp:Label ID="lblError" runat="server" Text="" ForeColor="Red"></asp:Label><br /><br />
        <asp:Label ID="lblTitulo" Text="DATOS DE LA ORDEN" runat="server" style="display: none; font-size:medium; font-weight:700"/><br /><br />
        <asp:Table ID="tblFormPagos" runat="server" style="display: none">
            <asp:TableRow>
                <asp:TableHeaderCell HorizontalAlign="Right" Text="Cliente: "></asp:TableHeaderCell>
                <asp:TableCell>
                    <asp:Label ID="nombreCliente" runat="server" style="color: blue; font-weight: 500" />
                </asp:TableCell></asp:TableRow><asp:TableRow>
                <asp:TableHeaderCell HorizontalAlign="Right" Text="No. de Orden: "></asp:TableHeaderCell><asp:TableCell>
                    <asp:Label ID="noOrder" runat="server" Text="" style="color: blue; font-weight: 500" />
                </asp:TableCell></asp:TableRow><asp:TableRow>
                <asp:TableHeaderCell HorizontalAlign="Right" Text="Monto Total:"></asp:TableHeaderCell><asp:TableCell>
                    <asp:Label ID="total" runat="server" Text="" style="color: blue; font-weight: 500" />
                </asp:TableCell></asp:TableRow><asp:TableRow>
                <asp:TableHeaderCell HorizontalAlign="Right" Text="Adeudo:"></asp:TableHeaderCell><asp:TableCell>
                    <asp:Label ID="adeudo" runat="server" Text="" style="color: blue; font-weight: 500" />
                </asp:TableCell></asp:TableRow><asp:TableRow>
                <asp:TableHeaderCell HorizontalAlign="Right" Text="Cantidad a Pagar: $"></asp:TableHeaderCell><asp:TableCell>
                    <asp:TextBox ID="txtPago" runat="server" style="color: blue; font-weight: 500" class="solonumeros" />
                </asp:TableCell></asp:TableRow></asp:Table><br />   
        <input type="button" id="btnRegPago" value="Registrar Pago" style="display: none" onclick="checarPago()" />

        <asp:HiddenField ID="hfClienteID" runat="server" /> 
        <asp:HiddenField ID="hfTotal" runat="server" /> 
        <asp:HiddenField ID="hfAdeudo" runat="server" /> 
        <asp:HiddenField ID="hfOrden" runat="server" />    
    </center>
</asp:Content>
