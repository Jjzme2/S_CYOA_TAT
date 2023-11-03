/**
 * This will be the service that will handle all the BASE SERVER(SERVICE) functions.
 *
 * @Authors Jj Zettler
 * @date    9/09/2023
 * @version 0.1
 */
component
	singleton
	accessors = "true"
	name      = "BaseServer"
{

	property
		name   = "populator"
		inject = "wirebox:populator";
	property
		name   = "wirebox"
		inject = "Wirebox";


	public any function init ( ) {
		return this;
	}

	/**
	 * ----------------------------------------------------------------------------------------------
	 * Helper Functions
	 * ----------------------------------------------------------------------------------------------
	 */

	/**
	 * This will validate the parameters passed and return true, if valid and false, if not.
	 *
	 * @param {struct} params - The parameters to validate.
	 * @return {boolean} - True if valid, false if not.
	 */
	public boolean function validateParams( required struct params ) {
		var requiredKeys = ['searchTerm', 'sqlType', 'searchValue'];

		for (key in requiredKeys) {
			if (!structKeyExists(params, key)) {
				throw('You must pass ' AND key AND ' to the function.');
				return false;
			}
		}

		return true;
	}





	/**
	 * ----------------------------------------------------------------------------------------------
	 * Basic Crud Functions
	 * ----------------------------------------------------------------------------------------------
	 */

	/**
	 * This will check if the instance exists from the access point.
	 *
	 * @param {string} id - The id of the instance to check.
	 * @param {any} accessPoint - The access point to check.
	 *
	 * @return {boolean} - True if the instance exists, false if not.
	 */
	public boolean function exists (
		 required string id
		,required any accessPoint
	) {
		return accessPoint.get( id ) != null;
	}

	/**
	 * This will return a list of all the objects in the access point.
	 *
	 * @param {any} accessPoint - The access point to check.
	 *
	 * @return {any} - An array of all the objects in the access point.
	 */
	public any function getAll ( required any accessPoint ) {
		var response = { };
		try {
			var data = accessPoint.list( );

			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'BaseServer.getAll'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "BaseServer.getAll"
			)
		}

		return response;
	}

	/**
	 * This will return the object with the given id.
	 *
	 * @param   {struct} searchParams - The search parameters to use.
	 * @expects {string} searchTerm - The term to search for.
	 * @expects {string} sqlType - The sql type of the search term.
	 * @expects {string} searchValue - The value to search for.
	 * @expects {boolean} exactMatch - Whether or not to do an exact match.
	 *
	 * @return {any} - The object with the given id.
	 */
	public any function read (
		 required struct searchParams
		,required any accessPoint
	) {
		var response = { };

		validateParams(params=searchParams);

		try {
			var data = accessPoint.get(
				 searchTerm  = searchParams.searchTerm
				,sqlType     = searchParams.sqlType
				,searchValue = searchParams.searchValue
				,exactMatch  = structKeyExists(searchParams, 'exactMatch') ? searchParams.exactMatch : true
			);
			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'BaseServer.read'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "BaseServer.read"
			)
		}

		return response;
	}

	/**
	 * This will return any object with a creation date that has a specific relationship.
	 *
	 * @param   {struct} searchParams - The search parameters to use.
	 * @expects {string} relationship - The relationship to search for. (on, before, after, onOrBefore, onOrAfter)
	 * @expects {string} sqlType - The sql type of the search term. (cf_sql_date, cf_sql_timestamp)
	 * @expects {string} searchValue - The value to search for. (YYYY-MM-DD)
	 * @expects {string} searchTerm - The term to search for. (creationDate, recentChangeDate)
	 *
	 * @return {any} - The object with the given id.
	 */
	public any function readByDate (
		 required struct searchParams
		,required any accessPoint
	) {
		var response = { };

		validateParams(params=searchParams);

		try {
			var data = accessPoint.getByCreationDate(
				 relationship = searchParams.relationship
				,sqlType      = searchParams.sqlType
				,searchValue  = searchParams.searchValue
				,searchTerm   = searchParams.searchTerm
			);

			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'BaseServer.getByCreationDate'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "BaseServer.getByCreationDate"
			)
		}

		return response;
	}

	/**
	 * This will create a new object in the access point.
	 *
	 * @param {any} dto - The data to create the object with.
	 * @param {any} accessPoint - The access point to check.
	 *
	 * @return {any} - The object that was created.
	 */
	public any function create (
		 required any dto
		,required any accessPoint
	) {
		var response = { };
		try {
			var data = accessPoint.create( dto );
			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'BaseServer.create'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "BaseServer.create"
			)
		}

		return response;
	}

	/**
	 * This will update the object with the given id.
	 *
	 * @param {string} id - The id of the object to update.
	 * @param {any} data - The data to update the object with.
	 * @param {any} accessPoint - The access point to check.
	 *
	 * @return {any} - The object that was updated.
	 */
	public any function update (
		 required string id
		,required any data
		,required any accessPoint
	) {
		var response = { };
		try {
			var data = accessPoint.update(
				 id
				,data
			);
			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'BaseServer.update'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "BaseServer.update"
			)
		}

		return response;
	}

	/**
	 * This will delete the object with the given id.
	 *
	 * @param {string} id - The id of the object to delete.
	 * @param {any} accessPoint - The access point to check.
	 *
	 * @return {any} - The object that was deleted.
	 */
	public any function delete (
		 required string id
		,required any accessPoint
	) {
		var response = { };
		try {
			var data = accessPoint.delete( id );
			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'BaseServer.delete'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "BaseServer.delete"
			)
		}

		return response;
	}

	/**
	 * This will set the active status of the object with the given id.
	 *
	 * @param {string} id - The id of the object to set the active status of.
	 * @param {boolean} active - The active status to set the object to.
	 *
	 * @return {any} - The object that was updated.
	 */
	public any function setActive (
		 required string id
		,required boolean active
		,required any accessPoint
	) {
		var response = { };
		try {
			var data = accessPoint.setActive(
				 id
				,active
			);
			response = successResponse(
				data = data
				,successMessage = ''
				,functionName = 'BaseServer.setActive'
			)
		} catch ( any e ) {
			response = errorResponse(
				error = e
				,functionName = "BaseServer.setActive"
			)
		}

		return response;
	}

	public struct function successResponse(
		any data = "",
		string successMessage = "",
		string functionName = 'BaseServer.successResponse'
	) {
			var responder = wirebox.getInstance( 'ResponseService' );
		// Data wasn't passed in, so return an error message
		if( isEmpty(data) ) {
			responder.addMessage(
				message = "No data found, or passed in in #functionName#" );
			return responder.getResponse();
		}
			responder.setContents( contents = data );
			responder.addMessage( message = "Successfully found data in  #functionName#" );
			if( !isEmpty(successMessage) ) {
				responder.addMessage( message = "#successMessage#" );
			}
			return responder.getResponse();
	  }

	  public struct function errorResponse(
		any error = "",
		string functionName = 'BaseServer.errorResponse',
		array customMessages = [],
	  ) {
			var responder = wirebox.getInstance( 'ResponseService' );

			responder.addMessage( message = "#error.message#", type="Error");
			responder.addMessage( message = "An error has occurred in #arguments.functionName#" );
			for(m in customMessages) {
				responder.addMessage( message = "#m#", type="Custom");
			}

			return responder.getResponse();

	  }


	}
