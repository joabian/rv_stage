<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link href="Styles/Site.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:LoginView ID="LoginView1" runat="server">
        <AnonymousTemplate>
            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/logovencedores2.png" />

            <h2>
                <%--Bienvenido al nuevo sistema de inventario de su empresa Radiadores Vencedores!--%>
            </h2>
            <p>
                <%--Por favor entre al sistema utilizando su usuario y contraseña--%>
            </p>
            <p>
                <%--Si tiene algun problema o no puede entrar al sistema, contacte a su administrador o envie un correo a soporte@radiadoresvencedores.com--%>
            </p>
        </AnonymousTemplate>
        <LoggedInTemplate>            
        </LoggedInTemplate>
    </asp:LoginView>
    <asp:Panel ID="pnl_prod_nuevos" runat="server" Visible="false">
        <%--<asp:Label runat="server" ID="lbl_prod_nuevos" CssClass="title" Text="Productos recien ingresados" Font-Size="Medium"></asp:Label>--%>
        <h1 align='center'>Productos recién ingresados </h1>
            <br />
            <hr />
           
        <asp:Label ID="lbl_table" runat="server" Text=""></asp:Label>
        <%--<asp:GridView ID="gv_prod_nuevos" runat="server" ></asp:GridView>--%>
        <hr />
    </asp:Panel>


    <asp:Panel ID="pnl_relleno" runat="server" Visible="false">
        <asp:Label runat="server" ID="lbl_relleno" CssClass="title" Text="Piezas de relleno de Valentin a Henequen"></asp:Label>
        <div style="clear: both"></div>
        <asp:GridView ID="gv_relleno" runat="server"></asp:GridView>
        <hr />

    </asp:Panel>

    <asp:Panel ID="pnl_pedidos" runat="server" Visible="false">
        <asp:Label runat="server" ID="lbl_pedidos" CssClass="title" Text="Pedidos Abiertos en Henequen"></asp:Label>
        <div style="clear: both"></div>
        <asp:GridView ID="gv_pedidos" runat="server"></asp:GridView>
        <hr />
    </asp:Panel>



</asp:Content>

