/**
 * @Author      Jj Zettler
 * @Description This will be the service that will handle all the related functions for this named object.
 * @date        9/21/2023
 * @version     0.1
 * @Find        = Quote
 */
component
	singleton
	accessors = "true"
	name      = "QuoteServer"
	extends   = "BaseServer"
{

	property
		name   = "accessPoint"
		inject = "QuoteAccess";

	public function list ( ) {
		return getAll( accessPoint = accessPoint );
	}

	public function getById ( required string value ) {
		var searchParams = {
			 'searchTerm' : 'id'
			,'sqlType'    : 'cf_sql_varchar'
			,'searchValue': value
		};
		return read(
			 accessPoint  = accessPoint
			,searchParams = searchParams
		);
	}

}
