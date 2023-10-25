<cfcomponent name="ConversionService">
	<!---
		Taken from https://www.bennadel.com/blog/124-ask-ben-converting-a-query-to-an-array.htm
	--->
	<cffunction
		name      ="QueryToArray"
		access    ="public"
		returntype="array"
		output    ="false"
		hint      ="This turns a query into an array of structures."
	>
		<!--- Define arguments. --->
		<cfargument name="Data" type="query" required="yes"/>

		<cfscript>
		// Define the local scope.
		var LOCAL        = structNew( );
		// Get the column names as an array.
		LOCAL.Columns    = listToArray( ARGUMENTS.Data.ColumnList );
		// Create an array that will hold the query equivalent.
		LOCAL.QueryArray = arrayNew( 1 );
		// Loop over the query.
		for (
			LOCAL.RowIndex = 1; LOCAL.RowIndex LTE ARGUMENTS.Data.RecordCount; LOCAL.RowIndex = (
				LOCAL.RowIndex + 1
			)
		) {
			// Create a row structure.
			LOCAL.Row = structNew( );
			// Loop over the columns in this row.
			for (
				LOCAL.ColumnIndex = 1; LOCAL.ColumnIndex LTE arrayLen( LOCAL.Columns ); LOCAL.ColumnIndex = (
					LOCAL.ColumnIndex + 1
				)
			) {
				// Get a reference to the query column.
				LOCAL.ColumnName              = LOCAL.Columns[ LOCAL.ColumnIndex ];
				// Store the query cell value into the struct by key.
				LOCAL.Row[ LOCAL.ColumnName ] = ARGUMENTS.Data[ LOCAL.ColumnName ][
					LOCAL.RowIndex
				];
			}
			// Add the structure to the query array.
			arrayAppend(
				 LOCAL.QueryArray
				,LOCAL.Row
			);
		}
		// Return the array equivalent.
		return ( LOCAL.QueryArray );
		</cfscript>
	</cffunction>
</cfcomponent>
