/**
 * @Author      Jj Zettler
 * @Description This will be the service that will handle all the related functions for this named object.
 * @date        9/21/2023
 * @version     0.1
 * @Find        = Adventure
 */

component
	singleton
	accessors = "true"
	name      = "AdventureServer"
	extends   = "BaseServer"
{

	property
		name   = "accessPoint"
		inject = "AdventureAccess";

	/**
	 * ----------------------------------------------------------------------------------------------
	 * OBJECT INSTANTIATION
	 * ----------------------------------------------------------------------------------------------
	 */

	public function list ( ) {
		return getAll( accessPoint = accessPoint );
	}


	public function get ( required struct searchParams ) {
		validateParams( params = arguments.searchParams );

		return read(
			 accessPoint  = accessPoint
			,searchParams = searchParams
		);
	}


	public function getByDate ( required struct searchParams ) {
		validateParams( params = arguments.searchParams );

		return readByDate(
			 accessPoint  = accessPoint
			,searchParams = searchParams
		);
	}


	/**
	 * Gets all the pages within a given adventure.
	 *
	 * @param required string adventureId
	 * @return array
	 */
	public function getPages ( required string adventureId ) {
		var response = '';
		try {
			var data = accessPoint.getPages ( adventureId );

			// Data is a struct containing an array called pages, which are all objects with an id and text value.
			// We need to convert the text value to a struct.

			// Converts the JSON object 'choices' to a struct.
			for ( var i = 1; i <= arrayLen(data); i++ ) {
				if(data[i].choices == 'null'){
					data[i].choices = [];
				}else{
					data[i].choices = deserializeJSON(data[i].choices).pages;
				}
			}


			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'AdventureServer.getPages'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "AdventureServer.getPages"
			)
		}

		return response;
	}

}
