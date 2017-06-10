Imports Microsoft.VisualBasic
Imports vencedoresTableAdapters
<System.ComponentModel.DataObject()>
Public Class CategoriesBLL
    Private _categoriesAdapter As categoriesTableAdapter = Nothing
    Protected ReadOnly Property Adapter() As categoriesTableAdapter
        Get
            If _categoriesAdapter Is Nothing Then
                _categoriesAdapter = New categoriesTableAdapter()
            End If
            Return _categoriesAdapter
        End Get
    End Property

    <System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Select, True)> _
    Public Function GetCategories() As vencedores.categoriesDataTable
        Return Adapter.GetCategories()
    End Function

    <System.ComponentModel.DataObjectMethodAttribute(System.ComponentModel.DataObjectMethodType.Select, False)> _
    Public Function GetCategoryByCategoryID(ByVal categoryID As Integer) As vencedores.categoriesDataTable
        Return Adapter.GetCategoryByCategoryID(categoryID)
    End Function
End Class
