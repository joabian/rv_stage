<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="busc_suc.aspx.vb" Inherits="sucursales_busc_suc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
        DataSourceID="ObjectDataSource1">
        <Columns>
            <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" 
                ReadOnly="True" SortExpression="id" />
            <asp:BoundField DataField="alias" HeaderText="alias" SortExpression="alias" />
            <asp:BoundField DataField="address" HeaderText="address" 
                SortExpression="address" />
            <asp:BoundField DataField="city" HeaderText="city" SortExpression="city" />
            <asp:BoundField DataField="state" HeaderText="state" SortExpression="state" />
            <asp:BoundField DataField="country" HeaderText="country" 
                SortExpression="country" />
            <asp:BoundField DataField="tel" HeaderText="tel" SortExpression="tel" />
            <asp:BoundField DataField="tel_sec" HeaderText="tel_sec" 
                SortExpression="tel_sec" />
            <asp:BoundField DataField="nextel" HeaderText="nextel" 
                SortExpression="nextel" />
        </Columns>
    </asp:GridView>

    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetLocations" 
        TypeName="vencedoresTableAdapters.locationsTableAdapter">
        <InsertParameters>
            <asp:Parameter Name="_alias" Type="String" />
            <asp:Parameter Name="address" Type="String" />
            <asp:Parameter Name="city" Type="String" />
            <asp:Parameter Name="state" Type="String" />
            <asp:Parameter Name="country" Type="String" />
            <asp:Parameter Name="tel" Type="String" />
            <asp:Parameter Name="tel_sec" Type="String" />
            <asp:Parameter Name="nextel" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>

</asp:Content>

