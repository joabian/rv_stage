<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="busc_prod.aspx.vb" Inherits="productos_busc_prod" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <fieldset><legend>Opciones de Busqueda:</legend>
        <fieldset style="width: 100px; float: left; height:50px;"><legend>Año:</legend>
            &nbsp;<asp:TextBox ID="year" runat="server" AutoPostBack="True" Width="50px"></asp:TextBox>
            &nbsp;
    
        </fieldset>
        <fieldset style="width: 150px; float: left; height:50px;"><legend>Fabricante:</legend>
            <asp:DropDownList ID="makeDDL" runat="server" AutoPostBack="True" 
                    DataSourceID="MakeDS" DataTextField="name" DataValueField="alias">
            </asp:DropDownList>
        </fieldset>
        <fieldset style="width: 200px; height:50px;"><legend>Modelo:</legend>
            <asp:DropDownList ID="modelDDL" runat="server" AutoPostBack="True" 
                    DataSourceID="ModelDS" DataTextField="name" DataValueField="alias">
            </asp:DropDownList>
        </fieldset>
    
        <asp:ObjectDataSource ID="MakeDS" runat="server" InsertMethod="Insert" 
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetMake" 
            TypeName="vencedoresTableAdapters.makeTableAdapter">
            <InsertParameters>
                <asp:Parameter Name="name" Type="String" />
                <asp:Parameter Name="_alias" Type="String" />
            </InsertParameters>
        </asp:ObjectDataSource>
        <asp:ObjectDataSource ID="ModelDS" runat="server" 
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetModel" 
            TypeName="vencedoresTableAdapters.modelTableAdapter">
            <SelectParameters>
                <asp:ControlParameter ControlID="makeDDL" Name="make" 
                    PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    
    </fieldset>
    <br />
    <br />
        <asp:GridView ID="GridView1" runat="server" AllowSorting="True" 
            AutoGenerateColumns="False" DataSourceID="GridDataSource1" 
        DataKeyNames="dpi_no,inlet_no,outlet_no">
            <Columns>
                <asp:BoundField DataField="year_beg" HeaderText="year_beg" 
                    SortExpression="year_beg" />
                <asp:BoundField DataField="year_end" HeaderText="year_end" 
                    SortExpression="year_end" />
                <asp:BoundField DataField="make" HeaderText="make" 
                    SortExpression="make" />
                <asp:BoundField DataField="model" HeaderText="model" SortExpression="model" />
                <asp:BoundField DataField="ltr" HeaderText="ltr" SortExpression="ltr" />
                <asp:BoundField DataField="cyl" HeaderText="cyl" SortExpression="cyl" />
                <asp:BoundField DataField="remark" HeaderText="remark" 
                    SortExpression="remark" />
                <asp:BoundField DataField="dpi_no" HeaderText="dpi_no" 
                    SortExpression="dpi_no" />
                <asp:BoundField DataField="inlet_no" HeaderText="inlet_no" 
                    SortExpression="inlet_no" />
                <asp:BoundField DataField="outlet_no" HeaderText="outlet_no" 
                    SortExpression="outlet_no" />
                <asp:HyperLinkField DataNavigateUrlFields="dpi_no,inlet_no,outlet_no" 
                    DataNavigateUrlFormatString="ProductsforModelDetails.aspx?dpi_no={0}&amp;inlet_no={1}&amp;outlet_no={2}" 
                    Text="Ver Detalles" />
            </Columns>
            <SelectedRowStyle CssClass="SelectedRowStyle" /> 
        </asp:GridView>
        <asp:ObjectDataSource ID="GridDataSource1" runat="server"  
            OldValuesParameterFormatString="original_{0}" 
            SelectMethod="GetModelByYearMakeModel" 
            TypeName="vencedoresTableAdapters.modelsTableAdapter">
            <SelectParameters>
                <asp:ControlParameter ControlID="year" Name="year" PropertyName="Text" 
                    Type="Int32" />
                <asp:ControlParameter ControlID="makeDDL" Name="make" 
                    PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="modelDDL" Name="model" 
                    PropertyName="SelectedValue" Type="String" />
            </SelectParameters>
            
        </asp:ObjectDataSource>

</asp:Content>

