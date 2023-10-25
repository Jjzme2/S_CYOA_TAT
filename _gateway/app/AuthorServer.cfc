/**
 * @Author      Jj Zettler
 * @Description This will be the service that will handle all the related functions for this named object.
 * @date        9/21/2023
 * @version     0.1
 * @Find        = Author
 */
component
	singleton
	accessors = "true"
	name      = "AuthorServer"
	extends   = "BaseServer"
{

	property
		name   = "accessPoint"
		inject = "AuthorAccess";

	/**
	 * ----------------------------------------------------------------------------------------------
	 * OBJECT INSTANTIATION
	 * ----------------------------------------------------------------------------------------------
	 */

	/** Private functions for this service. */


	/** Common functions for this service. */

	/**
	 * This will get an empty AuthorDTO.
	 *
	 * @return An empty Author DTO.
	 */
	public AuthorDTO function getEmpty ( ) {
		return new models.DTO.AuthorDTO( ); // Check path
	}

	public function list ( ) {
		return getAll( accessPoint = accessPoint );
	}


	public function get ( required struct searchParams ) {
		if (
			!structKeyExists(
				 searchParams
				,'searchTerm'
			)
		) {
			throw( "You must pass a search term to the get function. This is the column we should search, for example 'id'" );
		} else if (
			!structKeyExists(
				 searchParams
				,'sqlType'
			)
		) {
			throw( "You must pass a sql type to the get function. This is the sql type that we want to validate with, for example 'cf_sql_varchar'" );
		} else if (
			!structKeyExists(
				 searchParams
				,'searchValue'
			)
		) {
			throw( 'You must pass a search value to the get function. This is the value to find, for example, the id of the object we want to find.' );
		}

		return read(
			 accessPoint  = accessPoint
			,searchParams = searchParams
		);
	}


	public function getByDate ( required struct searchParams ) {
		if (
			!structKeyExists(
				 searchParams
				,'searchTerm'
			)
		) {
			throw( "You must pass a search term to the get function. This is the column we should search, for example 'id'" );
		} else if (
			!structKeyExists(
				 searchParams
				,'sqlType'
			)
		) {
			throw( "You must pass a sql type to the get function. This is the sql type that we want to validate with, for example 'cf_sql_varchar'" );
		} else if (
			!structKeyExists(
				 searchParams
				,'searchValue'
			)
		) {
			throw( 'You must pass a search value to the get function. This is the value to find, for example, the id of the object we want to find.' );
		} else if (
			!structKeyExists(
				 searchParams
				,'relationship'
			)
		) {
			throw( "You must pass a relationship to the get function. This is the relationship to use, for example, 'on' or 'before'." );
		}

		return readByDate(
			 accessPoint  = accessPoint
			,searchParams = searchParams
		);
	}

}
