<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="negadas.aspx.vb" Inherits="reportes_negadas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript">
        var day_date;
        $(document).ready(function () {
            var to_date = new Date();
            var d = to_date.getDay();
            var rest_day;

            var from_date = new Date();
            var rest_day_yest;

            if (d == 1) {
                rest_day = 3;
                rest_day_yest = 7;
            }
            else {
                rest_day = 1;
                rest_day_yest = (d - 1);
            }

            to_date.setDate(to_date.getDate());
            var dd = to_date.getDate();
            var mm = to_date.getMonth() + 1; //January is 0!
            var yyyy = to_date.getFullYear();
            if (dd < 10)
            { dd = '0' + dd };
            if (mm < 10)
            { mm = '0' + mm };
            to_date = mm + '/' + dd + '/' + yyyy;
            var to_text = document.getElementById("to_date");
            to_text.value = to_date;

            from_date.setDate(from_date.getDate() - rest_day_yest);
            var dd_f = from_date.getDate();
            var mm_f = from_date.getMonth() + 1;
            var yyyy_f = from_date.getFullYear();
            if (dd_f < 10)
            { dd_f = '0' + dd_f };
            if (mm_f < 10)
            { mm_f = '0' + mm_f };
            from_date = mm_f + '/' + dd_f + '/' + yyyy_f;
            var from_text = document.getElementById("from_date");
            from_text.value = from_date;

        });

        $(function () {
            var dates = $("#from_date, #to_date").datepicker({
                numberOfMonths: 1,
                changeYear: true,
                yearRange: '2010:2200',
                dateFormat: 'mm/dd/yy',
                //  showWeek: true,
                firstDay: 1,
                onSelect: function (selectedDate) {
                    var option = this.id == "from_date" ? "minDate" : "maxDate",
					    instance = $(this).data("datepicker"),
					    date = $.datepicker.parseDate(
						    instance.settings.dateFormat ||
						    $.datepicker._defaults.dateFormat,
						    selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h1 align="center">Reporte de piezas negadas</h1>
    <br />
    <hr />
    <fieldset>
        <legend>Filtrar Piezas Negadas</legend>
        <asp:CheckBox ID="cbx_existente" runat="server" Text="Existentes" Checked="true" />
        <asp:CheckBox ID="cbx_no_existentes" runat="server" Text="No Existentes" />&nbsp;&nbsp;&nbsp;&nbsp;
    Desde:
    <input type="text" id="from_date" name="from_date" class="textBox" style="width: 100px; margin-top: 3px;" />&nbsp;&nbsp;&nbsp;
    Hasta:
    <input type="text" id="to_date" name="to_date" class="textBox" style="width: 100px; margin-top: 3px;" />&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="btn_get_report" runat="server" Text="Generar Reporte" />&nbsp;&nbsp;&nbsp;&nbsp;
    <asp:Button ID="btn_export" runat="server" Text="Exportar a Excel" />
    </fieldset>
    <hr />
    <center>
        <asp:GridView ID="gv_report" runat="server">
        </asp:GridView>
    </center>
    <asp:Label ID="lblerror" runat="server" Text="" ForeColor="Red"></asp:Label>
    <asp:HiddenField ID="hifd_query" runat="server" />
</asp:Content>

