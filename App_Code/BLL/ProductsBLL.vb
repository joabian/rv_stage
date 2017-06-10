Imports Microsoft.VisualBasic
Imports vencedoresTableAdapters

<System.ComponentModel.DataObject()> _
Public Class ProductsBLL

    Private _productsAdapter As ProductsTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As ProductsTableAdapter
        Get
            If _productsAdapter Is Nothing Then
                _productsAdapter = New ProductsTableAdapter()
            End If

            Return _productsAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetProducts() As vencedores.productsDataTable
        Return Adapter.GetProducts()
    End Function

    <System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetProductByProductID(ByVal productID As Integer) As vencedores.productsDataTable
        Return Adapter.GetProductByProductID(productID)
    End Function

    <System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetProductsByCategoryID(ByVal categoryID As Integer) As vencedores.productsDataTable
        Return Adapter.GetProductsByCategoryID(categoryID)
    End Function

    '<System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Insert, True)> _
    'Public Function AddProduct(ByVal code As String, ByVal description As String, ByVal category As Nullable(Of Integer), ByVal price As Nullable(Of Decimal), ByVal cost As Nullable(Of Decimal), ByVal low_inventory As Nullable(Of Short)) As Boolean
    '    ' Create a new ProductRow instance
    '    Dim products As New vencedores.productsDataTable()
    '    Dim product As vencedores.productsRow = products.NewproductsRow()

    '    product.code = code
    '    product.description = description
    '    If Not category.HasValue Then product.SetcategoryNameNull() Else product.category = category.Value
    '    If Not price.HasValue Then product.SetpriceNull() Else product.price = price.Value
    '    If Not cost.HasValue Then product.SetcostNull() Else product.cost = cost.Value
    '    If Not low_inventory.HasValue Then product.Setlow_inventoryNull() Else product.low_inventory = low_inventory.Value

    '    ' Add the new product
    '    products.AddproductsRow(product)
    '    Dim rowsAffected As Integer = Adapter.Update(products)

    '    ' Return true if precisely one row was inserted, otherwise false
    '    Return rowsAffected = 1
    'End Function


    '<System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Update, True)> _
    'Public Function UpdateProduct(ByVal code As String, ByVal description As String, ByVal category As Nullable(Of Integer), ByVal price As Nullable(Of Decimal), ByVal cost As Nullable(Of Decimal), ByVal low_inventory As Nullable(Of Short), ByVal id As Integer) As Boolean
    '    Dim products As vencedores.productsDataTable = Adapter.GetProductByProductID(id)

    '    If products.Count = 0 Then
    '        ' no matching record found, return false
    '        Return False
    '    End If

    '    Dim product As vencedores.productsRow = products(0)

    '    ' Business rule check - cannot discontinue a product that's supplied by only
    '    ' one supplier

    '    product.code = code
    '    product.description = description
    '    If Not category.HasValue Then product.SetcategoryNameNull() Else product.category = category.Value
    '    If Not price.HasValue Then product.SetpriceNull() Else product.price = price.Value
    '    If Not cost.HasValue Then product.SetcostNull() Else product.cost = cost.Value
    '    If Not low_inventory.HasValue Then product.Setlow_inventoryNull() Else product.low_inventory = low_inventory.Value

    '    ' Update the product record
    '    Dim rowsAffected As Integer = Adapter.Update(product)

    '    ' Return true if precisely one row was updated, otherwise false
    '    Return rowsAffected = 1
    'End Function


    '<System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Delete, True)> _
    'Public Function DeleteProduct(ByVal productID As Integer) As Boolean
    '    Dim rowsAffected As Integer = Adapter.Delete(productID)

    '    'Return True if precisely one row was deleted, otherwise false
    '    Return rowsAffected = 1
    'End Function
End Class