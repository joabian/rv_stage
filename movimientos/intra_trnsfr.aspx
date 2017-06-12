<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="intra_trnsfr.aspx.vb" Inherits="movimientos_intra_trnsfr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center">Transferencia de productos</h1>
    <br /><hr />
    <fieldset> <!--style="width:40%; float:left;"-->
        <legend>Transferencias</legend>
        De sucursal:&nbsp;&nbsp;
        <asp:DropDownList ID="ddl_from_location" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
            <asp:ListItem Value="-">Seleccione...</asp:ListItem>
        </asp:DropDownList>&nbsp;&nbsp;A sucursal:&nbsp;&nbsp;
        <asp:DropDownList ID="ddl_to_location" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
            <asp:ListItem Value="-">Seleccione...</asp:ListItem>
        </asp:DropDownList>
    </fieldset>
    <hr />
    <div style="clear:both"> </div>
    <div style="float:left; padding:0px 15px 0px;">
        <table border="1" style="border-collapse:collapse;">
            <tr>
                <th style="width: 25px;">
                    No.
                </th>
                <th style="width: 100px;">
                    Modelo</th>
                <th style="width: 100px;">
                    de Rack</th>
                <th style="width: 100px;">
                    a Rack</th>
                <th style="width: 55px;">
                    Cantidad</th>
            </tr>
            <tr>
                <th>
                    1
                </th>
                <td>
                    <input id="codigo_1" name="codigo_1" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="from_R_1" name="from_R_1" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="to_R_1" name="to_R_1" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="qty_1" name="qty_1" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    2
                </th>
                <td>
                    <input id="codigo_2" name="codigo_2" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="from_R_2" name="from_R_2" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="to_R_2" name="to_R_2" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="qty_2" name="qty_2" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    3
                </th>
                <td>
                    <input id="Text1" name="codigo_3" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text2" name="from_R_3" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text3" name="to_R_3" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text4" name="qty_3" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    4
                </th>
                <td>
                    <input id="Text5" name="codigo_4" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text6" name="from_R_4" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text7" name="to_R_4" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text8" name="qty_4" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    5
                </th>
                <td>
                    <input id="Text9" name="codigo_5" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text10" name="from_R_5" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text11" name="to_R_5" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text12" name="qty_5" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    6
                </th>
                <td>
                    <input id="Text13" name="codigo_6" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text14" name="from_R_6" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text15" name="to_R_6" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text16" name="qty_6" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    7
                </th>
                <td>
                    <input id="Text17" name="codigo_7" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text18" name="from_R_7" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text19" name="to_R_7" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text20" name="qty_7" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    8
                </th>
                <td>
                    <input id="Text21" name="codigo_8" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text22" name="from_R_8" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text23" name="to_R_8" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text24" name="qty_8" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    9
                </th>
                <td>
                    <input id="Text25" name="codigo_9" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text26" name="from_R_9" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text27" name="to_R_9" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text28" name="qty_9" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    10
                </th>
                <td>
                    <input id="Text29" name="codigo_10" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text30" name="from_R_10" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text31" name="to_R_10" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text32" name="qty_10" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    11
                </th>
                <td>
                    <input id="Text33" name="codigo_11" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text34" name="from_R_11" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text35" name="to_R_11" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text36" name="qty_11" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    12
                </th>
                <td>
                    <input id="Text37" name="codigo_12" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text38" name="from_R_12" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text39" name="to_R_12" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text40" name="qty_12" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    13
                </th>
                <td>
                    <input id="Text41" name="codigo_13" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text42" name="from_R_13" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text43" name="to_R_13" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text44" name="qty_13" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    14
                </th>
                <td>
                    <input id="Text45" name="codigo_14" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text46" name="from_R_14" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text47" name="to_R_14" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text48" name="qty_14" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    15
                </th>
                <td>
                    <input id="Text49" name="codigo_15" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text50" name="from_R_15" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text51" name="to_R_15" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text52" name="qty_15" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    16
                </th>
                <td>
                    <input id="Text53" name="codigo_16" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text54" name="from_R_16" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text55" name="to_R_16" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text56" name="qty_16" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    17
                </th>
                <td>
                    <input id="Text57" name="codigo_17" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text58" name="from_R_17" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text59" name="to_R_17" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text60" name="qty_17" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    18
                </th>
                <td>
                    <input id="Text61" name="codigo_18" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text62" name="from_R_18" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text63" name="to_R_18" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text64" name="qty_18" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    19
                </th>
                <td>
                    <input id="Text65" name="codigo_19" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text66" name="from_R_19" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text67" name="to_R_19" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text68" name="qty_19" type="text" style="width:30px" />
                </td>
            </tr>
            <tr>
                <th>
                    20
                </th>
                <td>
                    <input id="Text69" name="codigo_20" type="text" style="width:75px" />
                </td>
                <td>
                    <input id="Text70" name="from_R_20" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text71" name="to_R_20" type="text" style="width:70px" />
                </td>
                <td>
                    <input id="Text72" name="qty_20" type="text" style="width:30px" />
                </td>
            </tr>
        </table>
    
    </div>
    <asp:Button ID="btn_transfer" runat="server" Text="Transferir" Enabled="False" /><br /><br />
    <div style="width:40%; float:left; margin-left:150px">
      
        <asp:Label ID="lbl_error" runat="server" Text="" ForeColor="Red"></asp:Label>
        <br />
        <asp:Label ID="lbl_msg" runat="server" Text="" ForeColor="green"></asp:Label>
        <div style ="margin-left:auto; margin-right:auto; text-align:center">
            <b>Alta Masiva
            <br />
            Ejemplo de Archivo:<br /></b>
            Columna A: Código del producto<br />
            Columna B: Cantidad<br />
            Columna C: De Rack<br />
            Columna D: A Rack<br />
            <b>No incluir títulos de columnas, el archivo se empieza a leer desde la línea 1</b><br />
            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/file_exemple2.PNG" Width="360px" /><br /><br />
            Cargar Excel: 
            <asp:FileUpload ID="File1" runat="server" Width="60%" />
            <asp:Button ID="leadexcel" runat="server" Text="Subir Excel" />
            <asp:Label ID="lbl_error_file" runat="server" Font-Size="Large" Text="" CssClass="ErrorLabel"></asp:Label>
        </div>

    </div>
    <div style="clear:both"> </div>
    <br /><br />
</asp:Content>

