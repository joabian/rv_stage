<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="find_prod.aspx.vb" Inherits="productos_find_prod" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Label ID="LBL_step" runat="server" Text="Seleccione el Año:" ForeColor="Red" Font-Size="XX-Large"></asp:Label><br />
	<br />
	<div style="height:300px">
	<asp:Panel ID="panel_years" runat="server" Visible="true" Width="80%" Height="450px" ScrollBars="Auto">
        
        <table style=" text-align:center; width:90%; ">
            <tr>
                <th><asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1969">1969</asp:HyperLink></th>
                <th><asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1970">1970</asp:HyperLink></th>
                <th><asp:HyperLink ID="HyperLink3" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1980">1980</asp:HyperLink></th>
                <th><asp:HyperLink ID="HyperLink4" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1990">1990</asp:HyperLink></th>
                <th><asp:HyperLink ID="HyperLink5" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2000">2000</asp:HyperLink></th>
                <th><asp:HyperLink ID="HyperLink6" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2010">2010</asp:HyperLink></th>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink8" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1971">1971</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink9" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1981">1981</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink10" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1991">1991</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink11" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2001">2001</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink12" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2011">2011</asp:HyperLink></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink7" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1972">1972</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink13" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1982">1982</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink14" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1992">1992</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink15" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2002">2002</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink16" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2012">2012</asp:HyperLink></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink17" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1973">1973</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink18" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1983">1983</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink19" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1993">1993</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink20" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2003">2003</asp:HyperLink></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink21" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1974">1974</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink22" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1984">1984</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink23" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1994">1994</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink24" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2004">2004</asp:HyperLink></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink25" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1975">1975</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink26" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1985">1985</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink27" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1995">1995</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink28" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2005">2005</asp:HyperLink></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink29" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1976">1976</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink30" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1986">1986</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink31" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1996">1996</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink32" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2006">2006</asp:HyperLink></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink33" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1977">1977</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink34" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1987">1987</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink35" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1997">1997</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink36" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2007">2007</asp:HyperLink></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink37" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1978">1978</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink38" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1988">1988</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink39" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1998">1998</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink40" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2008">2008</asp:HyperLink></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:HyperLink ID="HyperLink41" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1979">1979</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink42" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1989">1989</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink43" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=1999">1999</asp:HyperLink></td>
                <td><asp:HyperLink ID="HyperLink44" runat="server" NavigateUrl="~/productos/find_prod.aspx?year=2009">2009</asp:HyperLink></td>
                <td></td>
            </tr>
        </table>

    </asp:Panel>
    <asp:Panel ID="panel_make" runat="server" Visible="false" Width="50%" Height="450px" ScrollBars="Auto">
        <asp:Label ID="LBL_table_make" runat="server" Text=""></asp:Label>
    </asp:Panel>
    
    <asp:Panel ID="panel_model" runat="server" Visible="false" Width="50%" Height="450px" ScrollBars="Auto">
        <asp:Label ID="LBL_table_model" runat="server" Text=""></asp:Label>
    </asp:Panel>
    <asp:Panel ID="panel_results" runat="server" Visible="false" Width="50%" Height="450px" ScrollBars="Auto">
        <asp:GridView ID="GV_results" runat="server" AllowSorting="True" 
            AutoGenerateColumns="False" DataKeyNames="dpi_no,inlet_no,outlet_no">
            <Columns>
                <asp:BoundField DataField="year_beg" HeaderText="year_beg" 
                    SortExpression="year_beg" />
                <asp:BoundField DataField="year_end" HeaderText="year_end" 
                    SortExpression="year_end" />
                
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
             
        </asp:GridView>
    </asp:Panel>
    </div>

</asp:Content>

