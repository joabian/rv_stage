<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="ProductsforModelDetails.aspx.vb" Inherits="productos_ProductsforModelDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Label ID="lblMessage1" runat="server" Text="" Visible="true"></asp:Label>
    <div>

        <div style="width:350px; float:left">
            <fieldset>
                <legend>DPI:</legend>
                <asp:GridView ID="dpiGV" runat="server" Width="300px" >
                </asp:GridView>
                <br />
                <asp:Label ID="lbl_inv1" runat="server" Text="En inventario: " Visible="false" Font-Size="Medium" Font-Bold="true"></asp:Label>
                <br />
                <asp:GridView ID="dpiInventoryGV" runat="server" >
                </asp:GridView>
                <br />
                <asp:Image ID="dpi_img" AlternateText="No Existe Imagen" runat="server" Width="300px" />
            </fieldset>
        </div>
        <div style="width:3px; height:100px; float:left">
        .
        </div>
        <div style="width:350px; float:left">
            <fieldset>
                <legend>INLET:</legend>
                <asp:GridView ID="inletGV" runat="server" Width="300px"  >
                </asp:GridView>
                <br />
                <asp:Label ID="lbl_inv2" runat="server" Text="En inventario: " Font-Size="Medium" Visible="false" Font-Bold="true"></asp:Label>
                <br />
                <asp:GridView ID="inletInventoryGV" runat="server"  >
                </asp:GridView>
                <br />
                <asp:Image ID="inlet_img" AlternateText="No Existe Imagen" runat="server" Width="300px" />
            </fieldset>
        </div>
        <div style="width:3px; height:100px; float:left">
        .
        </div>
        <div style="width:350px; float:left">
            <fieldset>
                <legend>OUTLET:</legend>
                <asp:GridView ID="outletGV" runat="server" Width="300px" >
                </asp:GridView>
                <br />
                <asp:Label ID="lbl_inv3" runat="server" Text="En inventario: " Font-Size="Medium" Font-Bold="true" Visible="false"></asp:Label>
                <br />
                <asp:GridView ID="outletInventoryGV" runat="server"  >
                </asp:GridView>
   
                <br />
                <asp:Image ID="outlet_img" AlternateText="No Existe Imagen" runat="server" Width="300px" />
            </fieldset>
        </div>
    
    </div>
    <div style="clear:both;">

    </div>
    
    <asp:HiddenField ID="hifd_dpi" runat="server" />
    <asp:HiddenField ID="hifd_inlet" runat="server" />
    <asp:HiddenField ID="hifd_outlet" runat="server" />

</asp:Content>

