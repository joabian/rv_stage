<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="ajustar_precios.aspx.vb" Inherits="productos_ajustar_precios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

    <script src="../Scripts/jquery.js"></script>
    <script src="../Scripts/jquery-1.7.2.min.js"></script>
    <script src="../Scripts/jquery.dataTables.min.js"></script>
    <script src="../Scripts/colorbox/colorbox.js" type="text/javascript"></script>
    <link href="../Scripts/colorbox/colorbox.css" rel="stylesheet" type="text/css" />
    
    <link href="../Styles/jquery.dataTables.min.css" rel="stylesheet" />



    <script type="text/javascript">
        function loadTableProductPrices() {
            var serializedData = {};
            serializedData.option = "loadTableProductPrices";

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
                    var txt = document.getElementById("div_tabla_productos");
                    txt.innerHTML = dataLOG;
                    $('#tabla_productos').dataTable();

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function modificarPrecio(code) {
            
            var myhtml = "<center><br /><h1>ajustar precio producto: " + code + "</h1>";
            myhtml += "<hr /><br />";
            myhtml += "Seleccionar Precio: &nbsp<select id='tipo_precio'>";
            myhtml += "<option value='0'>Seleccione...</option>";
            myhtml += "<option value='PRECIO_JUAREZ'>Juarez</option>";
            myhtml += "<option value='PRECIO_2_JUAREZ'>Juarez 2</option>";
            myhtml += "<option value='PRECIO_3_JUAREZ'>Juarez 3</option>";
            myhtml += "<option value='PRECIO_DLLS_JUAREZ'>Dolares</option>";
            myhtml += "<option value='PRECIO_MAYOREO_JUAREZ'>Juarez Mayoreo</option>";
            myhtml += "<option value='PRECIO_INSTALADO_JUAREZ'>Juarez Instalado</option>";
            myhtml += "<option value='PRECIO_LEON'>Leon</option>";
            myhtml += "<option value='PRECIO_TORREON'>Torreon</option>";
            myhtml += "<option value='PRECIO_DURANGO'>Durango</option>";
            myhtml += "<option value='precio_rito'>Rito</option>";
            myhtml += "<option value='precio_rito2'>Rito 2</option>";
            myhtml += "</select>";
            myhtml += "<br />";
            myhtml += "Nuevo Precio: &nbsp<input type='text' id='new_price' class='textBox' style='width:100px; margin-top:20px;' /><br /><br />";
            myhtml += "<button onclick=\"salvarNuevoPrecio('" + code + "');\">Salvar</button>";
            myhtml += "<br /><br /><span id='msg'></span></center>";
            //myhtml += "<div style='text-align:center'></div>";

            $.colorbox({
                html: myhtml,
                fixed: true,
                width: 360,
                height: 300,
                onClosed: function () { loadTableProductPrices(); }
            });

        }

        function salvarNuevoPrecio(code) {
            var selectedPrice = $("#tipo_precio :selected").val();
            var price = $("#new_price").val();

            if (selectedPrice === '0' || price === '' || isNaN(price)){
                alert("Ingrese todos los datos");
            } else {
                var serializedData = {};
                serializedData.option = "salvarNuevoPrecio";
                serializedData.item = code;
                serializedData.selectedPrice = selectedPrice;
                serializedData.newPrice = price;

                $.ajax({
                    type: "POST",
                    url: "../ajax_response.aspx",
                    cache: false,
                    data: serializedData,
                    async: false,
                    success: function (data) {
                        $("#msg").html("Precio Salvado!")
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert(textStatus + errorThrown);
                    }
                });

            }
            
        }
        
        function salvarAjusteMasivo() {
            var selectedPrice = $("#tipo_precio_masivo :selected").val();
            var qty_value = $("#qty_value").val();
            var increaseType;
            if ($('#percent').is(':checked')) {
                increaseType = 'porcentual';
            } else {
                increaseType = 'precio';
            }
                        
            if (selectedPrice === '0' || qty_value === '' || isNaN(qty_value)) {
                alert("Ingrese todos los datos");
            } else {
                var serializedData = {};
                serializedData.option = "salvarPreciosMasivo";
                serializedData.selectedPrice = selectedPrice;
                serializedData.qty_value = qty_value;
                serializedData.increaseType = increaseType;

                $.ajax({
                    type: "POST",
                    url: "../ajax_response.aspx",
                    cache: false,
                    data: serializedData,
                    async: false,
                    success: function (data) {
                        $("#msg").html("Ajustes Salvados");
                        loadTableProductPrices();
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        alert(textStatus + errorThrown);
                    }
                });

            }

        }


    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <center><h1>Ajuste de precios</h1></center>
    <fieldset>
        <legend>Opciones de Ajustes Masivos:</legend>
        <h2>Incrementar precio a todos los radiadores</h2><br />
        Seleccione el precio que desea incrementar: &nbsp
        <select id='tipo_precio_masivo'>
            <option value='0'>Seleccione...</option>
            <option value='1'>Todos</option>
            <option value='PRECIO_JUAREZ'>Juarez</option>
            <option value='PRECIO_2_JUAREZ'>Juarez 2</option>
            <option value='PRECIO_3_JUAREZ'>Juarez 3</option>
            <option value='PRECIO_DLLS_JUAREZ'>Dolares</option>
            <option value='PRECIO_MAYOREO_JUAREZ'>Juarez Mayoreo</option>
            <option value='PRECIO_INSTALADO_JUAREZ'>Juarez Instalado</option>
            <option value='PRECIO_LEON'>Leon</option>
            <option value='PRECIO_TORREON'>Torreon</option>
            <option value='PRECIO_DURANGO'>Durango</option>
            <option value='precio_rito'>Rito</option>
            <option value='precio_rito2'>Rito 2</option>
        </select>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="radio" id="percent" name="tipo" checked="checked" value="1" />Incremento porcentual &nbsp;&nbsp;&nbsp;
        <input type="radio" id="qty" name="tipo" value="0" />Incremento de precio
        <br /><br />
        Ingrese el porcentaje o cantidad que desea incrementar:&nbsp
        <input type="text" style="width:100px" id="qty_value" />&nbsp&nbsp
        <button onclick="salvarAjusteMasivo();">Salvar</button><br />
        <span id="msg_masivo"></span><br />
        <hr /><br />
    </fieldset>
    <br />
    <asp:Label ID="lbl_error" runat="server" CssClass="ErrorLabel"></asp:Label>


    <hr /><br />
    <div id="div_tabla_productos">


    </div>


    <script type="text/javascript">
        loadTableProductPrices();
        
    </script>
</asp:Content>

