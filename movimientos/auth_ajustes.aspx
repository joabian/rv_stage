<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="auth_ajustes.aspx.vb" Inherits="movimientos_auth_ajustes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">

    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />
    <script src="../Scripts/colorbox/colorbox.js" type="text/javascript"></script>
    <link href="../Scripts/colorbox/colorbox.css" rel="stylesheet" type="text/css" />
       
    <script type="text/javascript">
        //$('form').preventDoubleSubmission();

        //$('form').submit(function () {
        //    $('input[type=submit]', this).attr('disabled', 'disabled');
        //});

        var items = new Array;
        var codigo_tras = "";
        var qty_ajust = "";
        var start_date;

        
        $(document).ready(function () {
            loadTableAjustesPendientes();
        
        });

        function getDateTime() {
            var now = new Date();
            var year = now.getFullYear();
            var month = now.getMonth() + 1;
            var day = now.getDate();
            var hour = now.getHours();
            var minute = now.getMinutes();
            var second = now.getSeconds();
            if (month.toString().length == 1) {
                var month = '0' + month;
            }
            if (day.toString().length == 1) {
                var day = '0' + day;
            }
            if (hour.toString().length == 1) {
                var hour = '0' + hour;
            }
            if (minute.toString().length == 1) {
                var minute = '0' + minute;
            }
            if (second.toString().length == 1) {
                var second = '0' + second;
            }
            var dateTime = year + '/' + month + '/' + day + ' ' + hour + ':' + minute + ':' + second;
            return dateTime;
        }

        //function ajustarCantidad() {
        //    var location = $("#Locations :selected").text();

        //    var serializedData = {};
        //    serializedData.option = "getItemInDefaltLocation";
        //    serializedData.location = location;
        //    serializedData.codigo_tras = codigo_tras;

        //    $.ajax({
        //        type: "POST",
        //        url: "../ajax_response.aspx",
        //        cache: false,
        //        data: serializedData,
        //        async: false,
        //        success: function (data) {
        //            //alert(data);


        //            var MyRows = $('table#htmlTable').find('tbody').find('tr');

        //            for (var i = 0; i < MyRows.length; i++) {
        //                var MyIndexValue = $(MyRows[i]).find('td:eq(0)').html().toUpperCase();
        //                //alert(MyIndexValue);
        //                if (codigo_tras.toUpperCase() == MyIndexValue) {

        //                    $(MyRows[i]).find('td:eq(4)').html(data);

        //                }
        //            }



        //            formatTable();
        //        },
        //        error: function (jqXHR, textStatus, errorThrown) {
        //            alert(textStatus + errorThrown);
        //        }
        //    });

        //}


        
        

        function loadTableAjustesPendientes() {
            var serializedData = {};
            serializedData.option = "loadTableAjustesPendientes";
            
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
                    var txt = document.getElementById("mydiv");
                    txt.innerHTML = dataLOG;

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
        }

        function showAjuste(id) {

            var myhtml = "<br /><h1>Resolver Ajuste";
            myhtml += "</h1><hr/>";
            myhtml += "Comentarios: <br /> <textarea id='txt_qty_for_trans' rows='4' cols='40' /><br /><br />";
            myhtml += "<div style='text-align:center'><button onclick='aprobar(" + id + ");'><img src='../images/icons/ok.png' width='20px'> <b>Aprobar</b></button>";
            myhtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            myhtml += "<button onclick='rechazar(" + id + ");'><img src='../images/icons/Erase.png' width='20px'> <b>Rechazar</b></button></div>";

            $.colorbox({
                html: myhtml,
                fixed: true,
                width: 360,
                height: 280,
                onClosed: function () { loadTableAjustesPendientes(); }
            });
            
        }

        function aprobar(id_ajuste) {
            var comments = $("#txt_qty_for_trans").val();

            if (comments == "") {
                alert("Ingrese todos los datos");
            } else {
                var serializedData = {};
                serializedData.option = "aprobarAjuste";
                serializedData.id_ajuste = id_ajuste;
                serializedData.comments = comments;

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
        };

        function rechazar(id_ajuste) {
            var comments = $("#txt_qty_for_trans").val();

            if (comments == "") {
                alert("Ingrese todos los datos");
            } else {
                var serializedData = {};
                serializedData.option = "rechazarAjuste";
                serializedData.id_ajuste = id_ajuste;
                serializedData.comments = comments;

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
        };


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Ajustes</h1>
    <br /><hr /><br />
    <div id="mydiv">            
    </div>
    <asp:Label ID="lbl_msg" runat="server" Text="" ForeColor="Green"></asp:Label>
</asp:Content>

