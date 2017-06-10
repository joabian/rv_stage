<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="resurtido.aspx.vb" Inherits="reportes_resurtido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <%--<script src="../Scripts/jquery.js" type="text/javascript"></script>--%>
    <script src="../Scripts/colorbox/colorbox.js" type="text/javascript"></script>
    <link href="../Scripts/colorbox/colorbox.css" rel="stylesheet" type="text/css" />



    <script type="text/javascript">

        var codigo_tras = "";
        var qty_ajust = "";

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

        function showTransferDiv(code) {
            //alert(code);
            var location = $("#Locations :selected").text();
            codigo_tras = code;
            var serializedData = {};

            serializedData.option = "getRacks";
            serializedData.location = location;
            serializedData.codigo_tras = codigo_tras;

            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: false,
                success: function (data) {
                    var myhtml = "<br /><h1>Transferencia de codigo " + codigo_tras;
                    myhtml += "</h1><hr/>"
                    if (data == "n/a") {
                        myhtml += "<h1>No existe cantidad disponible</h1>"
                    } else {
                        myhtml += data + "<br /><br />"
                        myhtml += "Cantidad: <input type='text' id='txt_qty_for_trans' /><br /><br />"
                        myhtml += "<input type='button' value='Transferir' onClick='trasferir();' />"
                    }


                    $.colorbox({
                        html: myhtml,
                        fixed: true,
                        onClosed: function () { prg(); }
                    });
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });

        };

        function trasferir() {
            var location = $("#Locations :selected").text();
            var rack = $("#ddl_rack_for_trans :selected").text();
            var qty = $("#txt_qty_for_trans").val();


            if (codigo_tras == "" || rack == "" || qty == "" || isNaN(qty)) {
                alert("Ingrese todos los datos");
            } else {
                var serializedData = {};
                serializedData.option = "TransferenciaRapida";
                serializedData.location = location;
                serializedData.codigo_tras = codigo_tras;
                serializedData.rack = rack;
                serializedData.qty = qty;

                $.ajax({
                    type: "POST",
                    url: "../ajax_response.aspx",
                    cache: false,
                    data: serializedData,
                    async: false,
                    success: function (data) {
                        alert(data);
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert(textStatus + errorThrown);
                    }
                });

            }
        }


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

        function prg() {
            $("#progress_bar_pd").show();
            document.getElementById("mydiv").innerHTML = "";

            setTimeout(function () {
                loadTableResurtido();
            }, 1000);
        }

        function loadTableResurtido() {
            var location = $("#Locations :selected").text();
            var location_id = $("#Locations :selected").val();

            var serializedData = {};
            serializedData.option = "loadTableResurtido";
            serializedData.location = location;
            serializedData.location_id = location_id;
            
            $.ajax({
                type: "POST",
                url: "../ajax_response.aspx",
                cache: false,
                data: serializedData,
                async: true,
                success: function (data) {
                    //alert(data);
                    dataLOG = data;
                    //itemsTable
                    var txt = document.getElementById("mydiv");
                    txt.innerHTML = dataLOG;

                    $("#progress_bar_pd").hide();

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });

            

        }

        $(document).ready(function () {
            getLocations();
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">

    <fieldset><legend>Seleccione Sucursal:</legend>
        <select id="Locations"></select>&nbsp&nbsp&nbsp  
        <%--<asp:DropDownList ID="DDL_Location" runat="server" AppendDataBoundItems="True">
            <asp:ListItem Value="-">Seleccione...</asp:ListItem>
        </asp:DropDownList>--%>
        <input type='button' value='Correr' onClick='prg();' />&nbsp&nbsp&nbsp
        <%--<asp:Button ID="btn_export" runat="server" Text="Exportar a Excel" />--%>
        <button type="button" onclick="PrintElem('#Printdiv');">Imprimir</button>
    </fieldset>
    <br />
    <div style="text-align:center;">
        <%--style="/*display:none; width:30px;*/"--%>
        <img id="progress_bar_pd" alt="Prossecing..." src="../images/progress_bar.gif" style="display:none;"/>
    </div>
    <div id="Printdiv">
        <div id="mydiv">
            
        </div>
    </div>
</asp:Content>

