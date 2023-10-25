// TODO: This is taken from ChatGPT and should be used as a refrence only.

component name = "ExcelGen" {

	// ----------------------------------------------------------- Imports ----------------------------------------------------------- //
	import spreadsheet.*; // https://helpx.adobe.com/coldfusion/cfml-reference/coldfusion-functions/functions-by-category/spreadsheet-functions.html
	// ----------------------------------------------------------- Variables ----------------------------------------------------------- //

	// ----------------------------------------------------------- Objects/Models ----------------------------------------------------------- //

	// ----------------------------------------------------------- Log Entry Types ----------------------------------------------------------- //

	// ----------------------------------------------------------- Private Functions ----------------------------------------------------------- //
	private string function getMacroRange (
		 any sheet
		,string range
	) {
		var startCell = listFirst( range );
		var endCell   = listLast( range );

		return '#spreadsheetGetColumnLetter(
			 sheet
			,startCell
		)##spreadsheetGetRowNumber( startCell )#:#spreadsheetGetColumnLetter(
			 sheet
			,endCell
		)##spreadsheetGetRowNumber( endCell )#';
	}
	// ----------------------------------------------------------- Excel Functions ----------------------------------------------------------- //
	public void function generateExcel ( ) {
		// Create a new Excel workbook
		var workbook = spreadsheetNew( );

		// Add a worksheet
		var sheet1 = spreadsheetAddSheet(
			 workbook
			,'Sheet1'
		);

		// Define headers
		var headers = [
			 'A'
			,'B'
			,'C'
			,'D'
		];

		// Write headers to cells
		for ( var i = 1; i <= arrayLen( headers ); i++ ) {
			spreadsheetSetCellValue(
				 sheet1
				,headers[ i ] & '1'
				,headers[ i ]
			);
		}

		// Write data to cells
		spreadsheetSetCellValue(
			 sheet1
			,'A2'
			,'Hello'
		);
		spreadsheetSetCellValue(
			 sheet1
			,'B2'
			,10
		);
		spreadsheetSetCellValue(
			 sheet1
			,'C2'
			,20
		);
		spreadsheetSetCellValue(
			 sheet1
			,'D2'
			,30
		);

		// Define a macro that calculates the sum of a range
		spreadsheetSetMacro(
			 workbook
			,'CalculateSum'
			,'SUM(#getMacroRange(
				 sheet1
				,'B2:D2'
			)#)'
		);

		// Call the macro in a cell
		spreadsheetSetCellValue(
			 sheet1
			,'E1'
			,'Total:'
		);
		spreadsheetSetCellFormula(
			 sheet1
			,'E2'
			,'CalculateSum'
		);

		// Save the Excel file
		spreadsheetwrite(
			 workbook
			,'C:/path/to/excel.xlsx'
			,true
		);
	}

}
