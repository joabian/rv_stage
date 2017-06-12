<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="edit_prod.aspx.vb" Inherits="productos_edit_prod" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <h1 align="center"> Editar producto </h1>
    <br />
    <hr />
    <fieldset><legend>Campos de búsqueda: </legend>
        <asp:Label ID="Label16" runat="server" Text="Código: " ></asp:Label>
        <asp:TextBox ID="tbx_search" runat="server"></asp:TextBox>
        <asp:Button ID="btn_search" runat="server" Text="Buscar" />
        <asp:Image ID="img_item" runat="server" ImageUrl="~/images/tapas/no-image.jpg" Height="150px" align="right"/>
    </fieldset>
    <fieldset><legend>Información Actual:</legend>
        <div style="text-align:center">
            <asp:Label ID="errorlbl" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
        </div>
        
        <table>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label1" runat="server" Text="Código: "></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="codeTB" runat="server"></asp:TextBox>
                </td>

                <td width="200px" align="right">
                    <asp:Label ID="Label3" runat="server" Text="Precio Juárez: "></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_juarez" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right" rowspan="4">
                    <asp:Label ID="Label2" runat="server" Text="Descripción: "></asp:Label>
                </td>
                <td rowspan="4">
                   <asp:TextBox ID="descriptionTB" runat="server" Width="500px" 
                        TextMode="MultiLine" Height="100px"></asp:TextBox>
                </td>

                <td width="200px" align="right">
                    <asp:Label ID="Label8" runat="server" Text="Precio Mayoreo Juárez:"></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_mayoreo_juarez" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label9" runat="server" Text="Precio Juárez 2:"></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_2_juarez" runat="server"></asp:TextBox>
                </td>
            </tr>
                <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label10" runat="server" Text="Precio Juárez 3:"></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_3_juarez" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label11" runat="server" Text="Precio Juárez Dlls:"></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_dlls_juarez" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label6" runat="server" Text="Modelo"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="modelTB" runat="server"></asp:TextBox>
                </td>
                <td width="200px" align="right">
                    <asp:Label ID="Label12" runat="server" Text="Precio Juárez Instalado:"></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_instalado_juarez" runat="server"></asp:TextBox>
                </td>
            </tr>
            <%--<tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label3" runat="server" Text="Precio:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="priceTB" runat="server"></asp:TextBox>
                </td>
            </tr>--%>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label4" runat="server" Text="Costo: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="costTB" runat="server"></asp:TextBox>
                </td>

                <td width="200px" align="right">
                    <asp:Label ID="Label13" runat="server" Text="Precio Durango: "></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_durango" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label5" runat="server" Text="Inventario Mínimo: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="low_inventoryTB" runat="server"></asp:TextBox>
                </td>

                <td width="200px" align="right">
                    <asp:Label ID="Label14" runat="server" Text="Precio Torreón: "></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_torreon" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label7" runat="server" Text="Categoría: "></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="ddl_category2" runat="server"></asp:DropDownList>
                </td>

                <td width="200px" align="right">
                    <asp:Label ID="Label15" runat="server" Text="Precio León: "></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tbx_precio_leon" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label18" runat="server" Text="Alias: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="tbx_alias" runat="server"></asp:TextBox>
                </td>
                <td width="200px" align="right">
                    <asp:Label ID="Label20" runat="server" Text="Dimensiones: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="tb_dimensions" runat="server"></asp:TextBox>
                </td>
                
            </tr>

            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label21" runat="server" Text="Accesorios: "></asp:Label>
                </td>
                <td>    
                    <asp:TextBox ID="tb_accesories" Width="400px" runat="server"></asp:TextBox>
                </td>
                <td width="200px" align="right">
                    <asp:Label ID="Label22" runat="server" Text="Accesorio se distribuye instalado: "></asp:Label>
                </td>
                <td>
                    <asp:CheckBox ID="cb_install_distribution_flag" runat="server" Text="Si" />
                </td>
                
            </tr>


            <tr>
                <td width="200px" align="right">
                    <asp:Label ID="Label19" runat="server" Text="Fuera del Catálogo: "></asp:Label>
                </td>
                <td>
                    <asp:CheckBox ID="chbx_fuera_catalago" runat="server" Text="Si" />
                </td>
                <td width="200px" align="right">
                    <asp:Button ID="btn_delete_prod" runat="server" Text="Eliminar Producto" Enabled="false" OnClientClick="return confirm('¿Seguro que desea eliminar el producto seleccionado? También eliminaría el inventario para todas las sucursales!!');" />
                </td>
                <td>    
                    &nbsp&nbsp&nbsp&nbsp<asp:Button ID="edit_product" runat="server" Text="Salvar Cambios" Enabled="false" />
                </td>
            </tr>
    

            


        </table>
        <hr />
        <div style="text-align:center;width:320px;margin-left:auto;margin-right:auto">
            <asp:GridView ID="gv_default_locators" runat="server" Width="300px"></asp:GridView>
            <table style="width:100%">
                <tr>
                    <td colspan="2">
                        <asp:Label ID="Label17" runat="server" Text="Editar Rack por Default"></asp:Label><br /><br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:DropDownList ID="ddl_locations" runat="server"></asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="tbx_new_rack" runat="server"></asp:TextBox>
                    </td>   
                </tr>
                <tr>
                    <td colspan="2">
                        <br /><asp:Button ID="btn_rack_edit" runat="server" Text="Guardar Rack" Enabled="false" />
                    </td>
                </tr>
            </table>
        </div>
        <hr />
        <div style="text-align:center;width:50%;margin-left:auto;margin-right:auto">
            <i>NOTA: Solo son soportados archivos con extensión '.jpg'</i><br /><br />
            <asp:FileUpload ID="UploadTest" runat="server" Width="450"/>&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="UploadButton" runat="server" Text="Subir Imagen" CssClass="w-button button" /><br />
            <asp:Label ID="lbl_msg_img" runat="server" Text="" CssClass="ErrorLabel"></asp:Label>
        </div>
        
        
    
    </fieldset>
</asp:Content>

