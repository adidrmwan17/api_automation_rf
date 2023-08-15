from excelLibrary import excelLibrary
import pytest
import os

class Test_ExcelLibrary(object):
    def path(file):
        return os.path.join(os.getcwd(), file)
    
    @pytest.fixture
    def excel(self):
        return excelLibrary()

    @pytest.mark.excel_test
    @pytest.mark.parametrize(
        'doc_id, cell_value',
        [
            (
                path('data/sample/test.xlsx'),
                'nama'
            )
        ]
    )
    @pytest.mark.parametrize(
        'column_value',
        [
            (
                'awan',
                'adi'
            )
        ]
    )
    @pytest.mark.parametrize(
        'row_value',
        [
            (
                'alamat',
                'nomor handphone'
            )
        ]
    )
    def test_write_new_excel_file(self, excel, doc_id, cell_value, row_value, column_value):
        excel.create_excel_document(doc_id)
        excel.write_excel_cell(1,1,cell_value)
        excel.write_excel_row(1,row_value,1)
        excel.write_excel_column(1, column_value,1)
        excel.save_excel_document(doc_id)
        
        list_row_value = list(row_value)
        list_column_value = list(column_value)
        
        assert excel.read_excel_cell(1,1,None) == cell_value
        assert excel.read_excel_row(1,1,2) == list_row_value
        assert excel.read_excel_column(1,1,2) == list_column_value
        
        excel.close_current_excel_document
        
        if os.path.exists(doc_id):
            os.remove(doc_id)
        else:
            print("The file does not exist")
            
    @pytest.mark.excel_test
    @pytest.mark.parametrize(
        'pathfile, doc_id, row_num, col_num, value',
        [
            (
                path('data/sample/sample_test_excel.xlsx'),
                'sample_test.xlsx',
                2,
                1,
                'AWB12319023'
            )
        ]
    )
    def test_update_existing_excel_file(self, excel, pathfile, doc_id, row_num, col_num, value):
        excel.open_excel_document(pathfile,doc_id)
        excel.write_excel_cell(row_num,col_num,value)
        excel.save_excel_document(pathfile)
        
        assert excel.read_excel_cell(row_num,col_num,None) == value
        
        excel.close_all_excel_documents
    
    @pytest.mark.excel_test
    @pytest.mark.parametrize(
        'pathfile, doc_id',
        [
            (
                path('data/sample/sample_test_excel.xlsx'),
                'sample_test_excel.xlsx'
            )
        ]
    )
    @pytest.mark.parametrize(
        'sheet',
        [
            (
                'Sheet1',
                'Sheet2'
            )
        ]
    )
    def test_get_existing_sheet_from_excel(self, excel, pathfile, doc_id, sheet):
        excel.open_excel_document(pathfile,doc_id)
        list_actual_sheet = excel.get_list_sheet_names()
        sheets = list(sheet)
        
        assert list_actual_sheet==sheets
        
        excel.close_all_excel_documents
        
    @pytest.mark.excel_test
    @pytest.mark.parametrize(
        'pathfile_1, doc_id_1,pathfile_2,doc_id_2,sheet_1,sheet_2',
        [
            (
                path('data/sample/sample_test_excel.xlsx'),
                'sample_test_excel.xlsx',
                path('data/sample/sample_test_excel_2.xlsx'),
                'sample_test_excel.xlsx_2',
                'Sheet1',
                'Tokopedia'
            )
        ]
    )
    def test_switch_current_excel(self, excel, pathfile_1, pathfile_2, doc_id_1, doc_id_2, sheet_1, sheet_2):
        excel.open_excel_document(pathfile_1,doc_id_1)
        excel.open_excel_document(pathfile_2,doc_id_2)
        excel.switch_current_excel_document(doc_id_1)
        get_sheet_doc_1 = excel.get_list_sheet_names() 
        excel.switch_current_excel_document(doc_id_2)
        get_sheet_doc_2 = excel.get_list_sheet_names()
        
        assert sheet_1 in get_sheet_doc_1
        assert sheet_2 in get_sheet_doc_2
        
        excel.close_all_excel_documents