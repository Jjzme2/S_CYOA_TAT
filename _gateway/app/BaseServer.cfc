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
	// property name="calculator"  inject="MathService";
	property
		name   = "responder"
		inject = "ResponseService";
	// property name="timeService" inject="TimeService";
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
			response = responder.sendData( data = data );
		} catch ( any e ) {
			response = responder.sendData( messages = [
				'Base Server - getAll - Failed'
				,'Error Message: ' & e
			]);
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

		// Validate Search Params
		if (
			!structKeyExists(
				 searchParams
				,'searchTerm'
			)
		)
			searchParams.searchTerm = 'id'
		if (
			!structKeyExists(
				 searchParams
				,'sqlType'
			)
		)
			searchParams.sqlType = 'cf_sql_varchar'
		if (
			!structKeyExists(
				 searchParams
				,'searchValue'
			)
		)
			throw( 'Search Value is required.' );
		if (
			!structKeyExists(
				 searchParams
				,'exactMatch'
			)
		)
			searchParams.exactMatch = true;

		try {
			var data = accessPoint.get(
				 searchTerm  = searchParams.searchTerm
				,sqlType     = searchParams.sqlType
				,searchValue = searchParams.searchValue
				,exactMatch  = searchParams.exactMatch
			);

			if (
				isNull( data ) || !structKeyExists(
					 data
					,'id'
				) || data.id == '' || len( data ) EQ 0
			)
				response = responder.sendData(
					 messages = [
						 'No Records found for { #searchParams.searchTerm# = #searchParams.searchValue# } -- Searching #arguments.searchParams.exactMatch ? 'exact' : 'non-exact'# match.'
					]
				);
			else {
				response = responder.sendData( data = data );
			}
		} catch ( any e ) {
			response = responder.sendData( messages = [
				'Base Server - read - Failed'
				,'Error Message: ' & serializeJSON( e.message )
			]);			throw( e );
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

		// Validate Search Params
		if (
			!structKeyExists(
				 searchParams
				,'relationship'
			)
		)
			searchParams.relationship = 'on'
		if (
			!structKeyExists(
				 searchParams
				,'sqlType'
			)
		)
			searchParams.sqlType = 'cf_sql_date'
		if (
			!structKeyExists(
				 searchParams
				,'searchValue'
			)
		)
			throw( 'Search Value is required.' );
		if (
			!structKeyExists(
				 searchParams
				,'searchTerm'
			)
		)
			searchParams.searchTerm = 'creationDate'

		searchParams.searchTerm = searchParams.searchTerm == 'creationDate' ? 'created_on' : 'modified_on';

		try {
			var data = accessPoint.getByCreationDate(
				 relationship = searchParams.relationship
				,sqlType      = searchParams.sqlType
				,searchValue  = searchParams.searchValue
				,searchTerm   = searchParams.searchTerm
			);

			if (
				isNull( data ) || !structKeyExists(
					 data
					,'id'
				) || data.id == '' || len( data ) EQ 0
			)
				response = responder.sendData(
					 messages = [
						 'No Records found for { #searchParams.searchTerm# = #searchParams.searchValue# } -- Searching #arguments.searchParams.exactMatch ? 'exact' : 'non-exact'# match.'
					]
				);
			else {
				response = responder.sendData( data = data );
			}
		} catch ( any e ) {
			response = responder.sendData( messages = [
				'Base Server - readByDate - Failed'
				,'Error Message: ' & serializeJSON( e.message )
			]);			throw( e );
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
			response = responder.sendData( data = data );
		} catch ( any e ) {
			response = responder.sendData( messages = [
				'Base Server - create - Failed'
				,'Error Message: ' & serializeJSON( e.message )
			]);			throw( e );
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
			response = responder.sendData( data = data );
		} catch ( any e ) {
			response = responder.sendData( messages = [
				'Base Server - update - Failed'
				,'Error Message: ' & serializeJSON( e.message )
			]);			throw( e );
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
			response = responder.sendData( data = data );
		} catch ( any e ) {
			response = responder.sendData( messages = [
				'Base Server - delete - Failed'
				,'Error Message: ' & serializeJSON( e.message )
			]);			throw( e );
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
			response = responder.sendData( data = data );
		} catch ( any e ) {
			response = responder.sendData( messages = [
				'Base Server - setActive - Failed'
				,'Error Message: ' & serializeJSON( e.message )
			]);			throw( e );
		}

		return response;
	}
}
