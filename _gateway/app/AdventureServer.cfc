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
		return accessPoint.getPages ( adventureId );
	}

}
