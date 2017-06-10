<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="agreg_prov.aspx.vb" Inherits="proveedores_agreg_prov" %>

<asp:Content ID="HeaderContent" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
<h1>pagina para agregar proveedores</h1>
<div>
        <fieldset>
            <legend>Datos de Compańia:</legend>
            <asp:Label ID="ComanyNameLabel" runat="server" Text="Nombre de Compańia:"></asp:Label>

        &nbsp;<asp:TextBox ID="CompanyName" runat="server"></asp:TextBox>
             
        &nbsp;<br />
            <asp:Label ID="ComapnayPhoneLabel" runat="server" Text="Tel:"></asp:Label>
             
        &nbsp;<asp:TextBox ID="phone" runat="server"></asp:TextBox>
             
        &nbsp;&nbsp;&nbsp; <asp:Label ID="CompanyFaxLabel" runat="server" Text="Fax:"></asp:Label>
             
        &nbsp;<asp:TextBox ID="CompanyFax" runat="server"></asp:TextBox>    
        &nbsp;&nbsp;&nbsp; <asp:Label ID="CompanyEmailLabel" runat="server" Text="email:"></asp:Label>
        &nbsp;<asp:TextBox ID="CompanyEmail" runat="server"></asp:TextBox>
            <br />
            <fieldset>
                <legend>Direccion:</legend>





                    <asp:Label ID="AddrsNumberLabel" runat="server" Text="Numero:"></asp:Label>
        &nbsp;<asp:TextBox ID="AddrsNumber" runat="server"></asp:TextBox>
&nbsp;&nbsp;&nbsp;
            <asp:Label ID="AddrsStreetLabel" runat="server" Text="Calle:"></asp:Label>
        &nbsp;<asp:TextBox ID="AddresStreet" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;
            <asp:Label ID="AddrsZipLabel" runat="server" Text="CP:"></asp:Label>
            &nbsp;<asp:TextBox ID="AddrsZip" runat="server"></asp:TextBox>
            <br />
&nbsp;&nbsp;&nbsp;
            <asp:Label ID="AddrsCityLabel" runat="server" Text="Ciudad:"></asp:Label>
        &nbsp;<asp:TextBox ID="AddrsCity" runat="server"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;
         &nbsp;<asp:Label ID="AddrsContryLabel" runat="server" Text="Pais:"></asp:Label> &nbsp;
            <asp:DropDownList ID="paises" runat="server">
                <asp:ListItem>Selecione Pais</asp:ListItem>
                <asp:ListItem>Mexico</asp:ListItem>
                <asp:ListItem>Estados Unidos</asp:ListItem>
                <asp:ListItem>China</asp:ListItem>
            </asp:DropDownList>
        &nbsp;&nbsp;&nbsp; <asp:Label ID="AddrsStateLabel" runat="server" Text="Estado:"></asp:Label>
        &nbsp;

                <asp:DropDownList ID="Estados" runat="server">
                <asp:ListItem>Seleccione Estado</asp:ListItem>
                <asp:ListItem>Aguascalientes</asp:ListItem>
                <asp:ListItem>Baja California Norte</asp:ListItem>
                <asp:ListItem>Baja California Sur</asp:ListItem>
                <asp:ListItem>Campeche</asp:ListItem>
                <asp:ListItem>Chiapas</asp:ListItem>
                <asp:ListItem>Chihuahua</asp:ListItem>
                <asp:ListItem>Coahuila</asp:ListItem>
                <asp:ListItem>Colima</asp:ListItem>
                <asp:ListItem>Distrito Federal</asp:ListItem>
                <asp:ListItem>Durango</asp:ListItem>
                <asp:ListItem>Estado de México</asp:ListItem>
                <asp:ListItem>Guanajuato</asp:ListItem>
                <asp:ListItem>Guerrero</asp:ListItem>
                <asp:ListItem>Hidalgo</asp:ListItem>
                <asp:ListItem>Jalisco</asp:ListItem>
                <asp:ListItem>Michoacįn</asp:ListItem>
                <asp:ListItem>Morelos</asp:ListItem>
                <asp:ListItem>Nayarit</asp:ListItem>
                <asp:ListItem>Nuevo León</asp:ListItem>
                <asp:ListItem>Oaxaca</asp:ListItem>
                <asp:ListItem>Puebla</asp:ListItem>
                <asp:ListItem>Querétaro</asp:ListItem>
                <asp:ListItem>Quintana Roo</asp:ListItem>
                <asp:ListItem>San Luis Potosķ</asp:ListItem>
                <asp:ListItem>Sinaloa</asp:ListItem>
                <asp:ListItem>Sonora</asp:ListItem>
                <asp:ListItem>Tabasco</asp:ListItem>
                <asp:ListItem>Tamaulipas</asp:ListItem>
                <asp:ListItem>Tlaxcala</asp:ListItem>
                <asp:ListItem>Veracruz</asp:ListItem>
                <asp:ListItem>Yucatįn</asp:ListItem>
                <asp:ListItem>Zacatecas</asp:ListItem>            
            </asp:DropDownList>
            </fieldset>
            
        </fieldset>

        <fieldset>
            <legend>Datos de Contacto:</legend>
            <asp:Label ID="ContactNameLabel" runat="server" Text="Nombre de Contacto:"></asp:Label>
             
        &nbsp;<asp:TextBox ID="ContactName" runat="server"></asp:TextBox><br />
            <asp:Label ID="ContactPhoneLabel" runat="server" Text="Tel:"></asp:Label>
        &nbsp;<asp:TextBox ID="ContactPhone" runat="server" style="margin-bottom: 0px"></asp:TextBox>
            
             
        &nbsp;&nbsp;&nbsp; <asp:Label ID="ContactExtLabel" runat="server" Text="EXT:"></asp:Label>
            
             
        &nbsp;<asp:TextBox ID="ContactExt" runat="server"></asp:TextBox>
            
             
            <br />
            <asp:Label ID="ContactMobileLabel" runat="server" Text="Mobil:"></asp:Label>
            &nbsp;<asp:TextBox ID="ContactMobile" runat="server"></asp:TextBox>
            &nbsp;&nbsp;&nbsp; <asp:Label ID="ContactRadioLabel" runat="server" Text="Radio/Nextel:"></asp:Label>
            &nbsp;<asp:TextBox ID="ContactRadio" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="ContactEmailLabel" runat="server" Text="email:"></asp:Label>
            &nbsp;<asp:TextBox ID="ContactEmail" runat="server"></asp:TextBox>
            
        </fieldset>

        <fieldset>
            <legend>Otros Datos:</legend>       
            
            <fieldset>
                <legend>Tipo de Productos:</legend>
                <asp:CheckBoxList ID="CheckBoxList1" runat="server">
                    <asp:ListItem>Tapas</asp:ListItem>
                    <asp:ListItem>Radiadores</asp:ListItem>
                    <asp:ListItem>Accesorios</asp:ListItem>
                </asp:CheckBoxList>
            </fieldset>

            <fieldset>
               <legend>Notas:</legend>                    
                <asp:Label ID="NotesWarrantyLabel" runat="server" Text="Garantķa:"></asp:Label>                    
            &nbsp;<asp:TextBox ID="Waranty" runat="server"></asp:TextBox>
                <br />
                <asp:Label ID="NotesETALabel" runat="server" Text="ETA:"></asp:Label>                    
            &nbsp;<asp:TextBox ID="ETA" runat="server"></asp:TextBox>
                <br />
                <asp:Label ID="PaymentTermsLabel" runat="server" Text="Terminos de Pago:"></asp:Label>                    
            &nbsp;<asp:TextBox ID="PaymentTerms" runat="server"></asp:TextBox>                    
            </fieldset>
        </fieldset>

            <p class="submitButton">
                <asp:Button ID="CreateProv" runat="server" Text="Crear Proveedor" />
            </p>                
        </div>
</asp:Content>

