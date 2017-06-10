<%@ Page Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="sort_stock.aspx.vb" Inherits="movimientos_sort_stock" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <script src="../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="../Scripts/jquery.js" type="text/javascript"></script>
    <script type="text/javascript">

        function reasignar(myid) {
            var mycontrol = "tb_" + myid;

            var newRack = $("#" + mycontrol).val();
            alert(newRack);
            if (newRack != "") {
                alert(newRack);
                //var URL = "../ajax_response.aspx";
                //URL += "?option=assignRack";
                //URL += "&id=" + myid;
                //URL += "&newRack=" + newRack;

                //$.ajax({
                //    type: "POST",
                //    url: URL,
                //    cache: false,
                //    async: false,
                //    success: function (data) {
                //        //alert(data);
                //        var txt;
                //        dataLOG = data;
                //        if (dataLOG != "El archivo se cargo con exito!") {
                //            txt = document.getElementById("div_errores");
                //        } else {
                //            txt = document.getElementById("div_msg");
                //        }

                //        txt.innerHTML = dataLOG;
                //        $("#btnOk").show();
                //    },
                //    error: function (jqXHR, textStatus, errorThrown) {
                //        alert(textStatus + errorThrown);
                //    }
                //});
            } else {
                alert("Ingrese un rack")
            }

            
        }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Label ID="LBL_error" runat="server" Text="" ForeColor="Red"></asp:Label><br /><br />

    Sucursal:&nbsp;&nbsp;
    <asp:DropDownList ID="ddl_from_location" runat="server" AppendDataBoundItems="true" AutoPostBack="true">
        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
    </asp:DropDownList><br />
    <hr />
    <br />
    <asp:Label ID="lbl_table" runat="server" Text="" ></asp:Label><br /><br />
    <asp:Button ID="btn_save" runat="server" Text="Salvar" />
    <asp:HiddenField ID="hifd_location" runat="server" />
    
    <%--<asp:GridView ID="GV_tranfers" runat="server" AutoGenerateColumns="False" OnRowCancelingEdit="GV_tranfers_RowCancelingEdit" 
        OnRowEditing="GV_tranfers_RowEditing" 
        OnRowUpdating="GV_tranfers_RowUpdating" >
        <Columns>
            <asp:TemplateField HeaderText="id">
                <ItemTemplate>
                    <asp:Label ID="LBL_id" runat="server" Text='<%# Bind("id") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Producto" >
                <ItemTemplate>
                    <asp:Label ID="LBL_product_code" runat="server" Text='<%# Bind("product_code") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Descripcion">
                <ItemTemplate>
                    <asp:Label ID="LBL_product_description" runat="server" Text='<%# Bind("product_description") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Categoria">
                <ItemTemplate>
                    <asp:Label ID="LBL_product_category" runat="server" Text='<%# Bind("product_category") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Sucursal">
                <ItemTemplate>
                    <asp:Label ID="LBL_location" runat="server" Text='<%# Bind("location") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField HeaderText="Rack">
                <EditItemTemplate>
                    <asp:TextBox ID="TB_rack" runat="server" Text='<%# Bind("rack") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="LBL_rack" runat="server" Text='<%# Bind("rack") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
    
            <asp:TemplateField HeaderText="Cantidad">
                <EditItemTemplate>
                    <asp:TextBox ID="TB_qty" runat="server" Text='<%# Bind("qty") %>'></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="LBL_qty" runat="server" Text='<%# Bind("qty") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            
            <asp:CommandField ShowEditButton="True" />
                
        </Columns>
    </asp:GridView>--%>
</asp:Content>

