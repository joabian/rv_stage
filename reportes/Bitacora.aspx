<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Bitacora.aspx.vb" Inherits="reportes_Bitacora" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="../Scripts/jquery-ui-1.8.22.custom.min.js" type="text/javascript" ></script>
    <script src="../Scripts/jquery-ui-1.7.1.custom.min.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker.js" type="text/javascript"></script>
    <script src="../Scripts/calendar/datepicker-es.js" type="text/javascript"></script>
    <link href="../Styles/calendar/datepicker.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/redmond/jquery-ui-1.8.22.custom.css" type="text/css" rel="stylesheet" />    

    <script type="text/javascript">
        var day_date;
        //$(document).ready(function () {
        //    var to_date = new Date();
        //    to_date.setDate(to_date.getDate());
        //    var dd = to_date.getDate();
        //    var mm = to_date.getMonth() + 1; //January is 0!
        //    var yyyy = to_date.getFullYear();
        //    if (dd < 10)
        //    { dd = '0' + dd };
        //    if (mm < 10)
        //    { mm = '0' + mm };
        //    to_date = mm + '/' + dd + '/' + yyyy;
        //    var to_text = document.getElementById("to_date");
        //    to_text.value = to_date;

        //});

        $(function () {
            var dates = $("#to_date").datepicker({
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
    <fieldset><legend>Filtros:</legend>
    <%--Sucursal:
    <asp:DropDownList ID="ddl_locations" runat="server" AppendDataBoundItems="true">
        <asp:ListItem Value="0">Todas</asp:ListItem>
    </asp:DropDownList>&nbsp;&nbsp;&nbsp;
    --%>
    Fecha:
    <input type="text" id="to_date" name="to_date" class="textBox" style="width:100px; margin-top:3px;" />
    <asp:Button ID="btn_get_report" runat="server" Text="Generar Reporte" />
    <asp:Button ID="Button1" runat="server" Text="Exportar a Excel" />
</fieldset>
 
    <asp:GridView ID="gv_bitacora" runat="server">
        <Columns>
            <asp:TemplateField HeaderText="Borrar">
                <ItemTemplate>
                    <asp:ImageButton ID="img_btn_delete" runat="server" CausesValidation="False" 
                        CommandName="Delete" ImageUrl="~/images/icons/Erase.png" 
                        OnClientClick="return confirm('¿Esta seguro que desea eliminar este registro?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <asp:Label ID="lblerror" runat="server" Text="" ForeColor="Red"></asp:Label>



</asp:Content>

