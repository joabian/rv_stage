<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="clientes.aspx.vb" Inherits="movimientos_clientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery.js"></script>
    <script src="../Scripts/jquery-1.7.2.min.js"></script>
    <script src="../Scripts/jquery.dataTables.min.js"></script>

    <link href="../Styles/jquery.dataTables.min.css" rel="stylesheet" />

    <script type="text/javascript">
        function loadTableItemsdePedidosparaSurtir() {
            var serializedData = {};
            serializedData.option = "loadTableClientes";
            
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
                    var txt = document.getElementById("div_tabla_clientes");
                    txt.innerHTML = dataLOG;

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

    </script>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <center><h1>Lista de Clientes</h1></center>
    <div style="text-align:right;">
        <asp:Button ID="btn_add_client" runat="server" Text="+ Agregar Cliente" />
    </div>
    <br /><hr /><br />
    <div id="div_tabla_clientes">


    </div>


    <script type="text/javascript">
        loadTableItemsdePedidosparaSurtir();
        $(document).ready(function () {
            $('#tabla_clientes').dataTable();
        });
    </script>

</asp:Content>

