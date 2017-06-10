<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="pedidosParaSurtir.aspx.vb" Inherits="movimientos_pedidosParaSurtir" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />   
    <style type="text/css">
        .tableItems{
            width:80%;
            margin-left:auto;
            margin-right:auto;
            border-collapse:collapse;
        }
        
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            loadTablePedidos();
        });

        function loadTablePedidos() {
            var serializedData = {};
            serializedData.option = "loadTablePedidos";
            
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
                    var txt = document.getElementById("pedidosTable");
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

    <div id="pedidosTable" style="text-align:center">

    </div>
    

</asp:Content>

