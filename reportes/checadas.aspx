<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="checadas.aspx.vb" Inherits="reportes_checadas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" /> 
    <script type="text/javascript">
        $(function () {
            var dates = $("#<%=tbx_myDate.ClientID%>").datepicker({
                numberOfMonths: 1,
                changeYear: true,
                yearRange: '2010:2200',
                dateFormat: 'mm/dd/yy',
                //  showWeek: true,
                firstDay: 1
            });
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:TextBox ID="tbx_myDate" runat="server"></asp:TextBox>
    <asp:Button ID="btn_export" runat="server" Text="Exportar" />
    <asp:Label ID="lbl_error" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>

</asp:Content>

