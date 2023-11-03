/**
 * @Author Jj Zettler
 * @Description This will be the service that will handle all the related functions for this named object.
 * @date 9/21/2023
 * @version 0.1
 * @Find = LearningCategory
 */
component singleton accessors="true" name="LearningCategoryServer" extends="BaseServer" {

	property name="accessPoint" inject="LearningCategoryAccess";

	/**
	* ----------------------------------------------------------------------------------------------
    * OBJECT INSTANTIATION
	* ----------------------------------------------------------------------------------------------
	*/

	/** Private functions for this service. */


	/** Common functions for this service. */

	/**
	 * This will get an empty LearningCategoryDTO.
	 * @return An empty LearningCategory DTO.
	 */
	public LearningCategoryDTO function getEmpty()
	{
		return new models.DTO.LearningCategoryDTO(); // Check path
	}

	public function list(){
		return getAll(accessPoint=accessPoint);
	}

// Searches

	public function getById(required string value)
	{
		var searchParams = {
			searchTerm  : "id"
			,sqlType 	: "cf_sql_varchar"
			,searchValue: value
		};
		return read( accessPoint = accessPoint, searchParams = searchParams );
	}

	public function getByName(required string value)
	{
		var searchParams = {
			searchTerm  : "name"
			,sqlType 	: "cf_sql_varchar"
			,searchValue: value
		};
		return read( accessPoint = accessPoint, searchParams = searchParams );
	}

	public function getByActivity(required boolean status)
	{
		var searchParams = {
			searchTerm  : "active"
			,sqlType 	: "cf_sql_bit"
			,searchValue: status
		};
		return read( accessPoint = accessPoint, searchParams = searchParams );
	}

	public function getByCreatedDate(required date value)
	{
		var searchParams = {
			searchTerm  : "creationDate"
			,sqlType 	: "cf_sql_datetime"
			,searchValue: value
			,relationship: "on"
		};
		return readByDate( accessPoint = accessPoint, searchParams = searchParams );
	}

	public function getByModifiedDate(required date value)
	{
		var searchParams = {
			searchTerm  : "recentChangeDate"
			,sqlType 	: "cf_sql_datetime"
			,searchValue: value
			,relationship: "on"
		};
		return readByDate( accessPoint = accessPoint, searchParams = searchParams );
	}

	
}
