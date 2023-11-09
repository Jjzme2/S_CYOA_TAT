/**
 * @Author      Jj Zettler
 * @Description This will be the access point for the Quote table.
 * @date        9/21/2023
 * @version     0.1
 * @FindOBJECT  Quote
 * @FindCOLUMNS t.id
 * ,t.creation_date
 * ,t.modified_date
 * ,t.author
 * ,t.quote
 * ,t.source
 */

// cfformat-ignore-start
<cfcomponent output = 'false' extends = 'BaseAccess'>
	<cfset tableName = 'quotes'> /* ?Lowercase and plural this, following whatever is in the database. */
	<cfset dataSource = application.cbController.getSetting( 'tertiaryDatasource' )>

	<cffunction name = 'get'
				access = 'package'
				returntype = 'any'
				output = 'false'
				hint = 'Gets an entity by the key-value pairs provided'>

				<cfargument name = 'searchValue' type = 'string'  required = 'true'>
				<cfargument name = 'searchTerm'  type = 'string'  required = 'false' default = 'id'>
				<cfargument name = 'sqlType'     type = 'string'  required = 'false' default = 'cf_sql_varchar'>
				<cfargument name = 'exactMatch'  type = 'boolean' required = 'false' default = 'true'>
				<cfquery name = 'get' datasource = '#variables.dataSource#'>
					SELECT t.id
						  ,t.creation_date
						  ,t.modified_date
						  ,t.author
						  ,t.quote
						  ,t.source
					FROM
					#variables.tableName# t
					WHERE
						<cfif arguments.exactMatch>
							<cfqueryparam value = '#arguments.searchValue#' cfsqltype = '#arguments.sqlType#'>
						<cfelse>
							<cfqueryparam value = '%#arguments.searchValue#%' cfsqltype = '#arguments.sqlType#'>
						</cfif>
					<cfqueryparam value = '#arguments.searchTerm#' cfsqltype = 'cf_sql_varchar'>
				</cfquery>
			<cfreturn get>
	</cffunction>
</cfcomponent>
// cfformat-ignore-end
