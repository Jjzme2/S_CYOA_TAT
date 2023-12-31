/**
 * @Author Jj Zettler
 * @Description This will be the access point for the Adventure table.
 * @date 9/21/2023
 * @version 0.1
 * @FindOBJECT Adventure
 * @FindCOLUMNS t.id
 * ,t.modified_on
 * ,t.active
 * ,t.name
 * ,t.description
 * ,t.author_id
 *
 */
<cfcomponent output="false" extends="BaseAccess">

	<cfset tableName  = "cyoa_adventures">

	<!---
	 * -------------------------------------------------------------
	 * 	CRUD FUNCTIONS -- In General, these will be the content from the database directly, as that is what we will be
	 *  create or updating.
	 * -------------------------------------------------------------
	 --->

	<cffunction name="create" access="package" returntype="boolean" output="false" hint="Adds a new entry into the database.">
		<cfargument name="entity" type="AdventureDTO" required="true">

		<cftry>
			<cfquery datasource=#dataSource#>
				INSERT INTO #tableName# (t.id
				,t.active
				,t.name
				,t.description
				,t.author_id
				)
				VALUES (
					<cfqueryparam  value="#entity.getId()#"  cfsqltype="cf_sql_varchar">
					, <cfqueryparam  value="#entity.getActive()#"  cfsqltype="cf_sql_bit">
					, <cfqueryparam  value="#entity.getName()#"  cfsqltype="cf_sql_varchar">
					, <cfqueryparam  value="#entity.getDescription()#"  cfsqltype="cf_sql_varchar">
					, <cfqueryparam  value="#entity.getAuthorId()#"  cfsqltype="cf_sql_varchar">
				)
			</cfquery>

			<cfcatch type="any">
				<cfset var message = {
					"customMessage": "Error occurred in Adventure Access CREATE.",
					"errorMessage": "#cfcatch.message#" }>
				<cfthrow type="CustomError" message=#serializeJSON(message)#>
				<cfreturn false>
			</cfcatch>
		</cftry>

		<cfreturn true>
	</cffunction>

	<cffunction name="updateById" access="package" returntype="boolean" output="false" hint="Updates an entry based on the id provided and the new Content">
		<cfargument name="currentId"type="string" required="true">
		<cfargument name="entity" 	type="struct" required="true">

		<cftry>
			<cfquery datasource=#dataSource#>
				UPDATE #tableName# t
				SET
					t.id = <cfqueryparam  value="#entity.getId()#"  cfsqltype="cf_sql_varchar">
					, t.active = <cfqueryparam  value="#entity.getActive()#"  cfsqltype="cf_sql_bit">
					, t.name = <cfqueryparam  value="#entity.getName()#"  cfsqltype="cf_sql_varchar">
					, t.description = <cfqueryparam  value="#entity.getDescription()#"  cfsqltype="cf_sql_varchar">
					, t.author_id = <cfqueryparam  value="#entity.getAuthorId()#"  cfsqltype="cf_sql_varchar">

				WHERE t.id       = <cfqueryparam value="#currentId#" 			 cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfcatch type="any">
				<cfset var message = {
					"customMessage": "Error occurred in Adventure Access UPDATE.",
					"errorMessage": "#cfcatch.message#" }>

				<cfthrow type="CustomError" message=#serializeJSON(message)#>

			</cfcatch>
		</cftry>

		<cfreturn true>
	</cffunction>


	<!---
	 * -------------------------------------------------------------
	 * 	GETTERS -- These will generally be the content that we want rendered, so it might include joins or other logic.
	 * -------------------------------------------------------------
	 --->

	<cffunction name="get" access="package" returntype="any" output="false" hint="Gets an entity by the key-value pairs provided">

		<cfargument name="searchValue" type="string"  required="true">
		<cfargument name="searchTerm"  type="string"  required="false" default="id">
		<cfargument name="sqlType"     type="string"  required="false" default="cf_sql_varchar">
		<cfargument name="exactMatch"  type="boolean" required="false" default="true">
		<cfargument name="showInactive"type="boolean" required="false" default="false">


		<cfset searchTerm = 't.' & arguments.searchTerm>

		<cftry>
			<cfquery name="get" datasource="#dataSource#">
				SELECT t.id
				,t.modified_on
				,t.active
				,t.name
				,t.description
				,t.author_id
				,a.pseudonym

				FROM #tableName# t
				LEFT JOIN authors a ON t.author_id = a.id
				<cfif arguments.exactMatch>
					WHERE #searchTerm# = <cfqueryparam value="#searchValue#" cfsqltype="#sqlType#">
						<cfif arguments.searchTerm NEQ 'active'>
							AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
						</cfif>
				<cfelse>
					WHERE #searchTerm# LIKE <cfqueryparam value="%#searchValue#%" cfsqltype="#sqlType#">
					<cfif arguments.searchTerm NEQ 'active'>
						AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
					</cfif>
				</cfif>
			</cfquery>

			<cfcatch type="any">
				<cfset var message = {
					"customMessage": "Error occurred in Adventure Access GET.",
					"errorMessage": "#cfcatch.message#",
					"additionalInfo": #arguments# }>

				<cfthrow type="CustomError" message=#serializeJSON(message)#>

			</cfcatch>
		</cftry>

		<cfreturn get>
	</cffunction>

	<cffunction
		name      ="getByCreationDate"
		access    ="package"
		returntype="query"
		output    ="false"
		hint      ="Gets an entity by the creation date provided"
	>
		<cfargument name="searchTerm" type="string" required="false" default="created_on">
		<cfargument name="sqlType" type="string" required="false" default="cf_sql_timestamp">
		<cfargument name="searchValue" type="string" required="false" default="">
		<cfargument name="showInactive" type="boolean" required="false" default="false">
		<cfargument
			name    ="relationship"
			type    ="string"
			required="false"
			default ="on"
			hint    ="on|onOrBefore|onOrAfter|after|before"
		>

		<cfset searchTerm = "t." & arguments.searchTerm>

		<cftry>
			<cfquery name="getByCreationDate" datasource="#dataSource#">
				SELECT t.id
				,t.modified_on
				,t.active
				,t.name
				,t.description
				,t.author_id
				,a.pseudonym


				FROM #tableName# t
				LEFT JOIN authors a ON t.author_id = a.id

				<cfswitch expression=#arguments.relationship#>
					<cfcase value="on">
					WHERE #searchTerm# = <cfqueryparam value="#searchValue#" cfsqltype="#sqlType#">
						<cfif arguments.searchTerm NEQ "active">
							AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
						</cfif>
					</cfcase>

					<cfcase value="onOrBefore">
					WHERE #searchTerm# <= <cfqueryparam value="#searchValue#" cfsqltype="#sqlType#">
						<cfif arguments.searchTerm NEQ "active">
							AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
						</cfif>
					</cfcase>

					<cfcase value="onOrAfter">
					WHERE #searchTerm# >= <cfqueryparam value="#searchValue#" cfsqltype="#sqlType#">
						<cfif arguments.searchTerm NEQ "active">
							AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
						</cfif>
					</cfcase>

					<cfcase value="after">
					WHERE #searchTerm# > <cfqueryparam value="#searchValue#" cfsqltype="#sqlType#">
						<cfif arguments.searchTerm NEQ "active">
							AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
						</cfif>
					</cfcase>

					<cfcase value="before">
					WHERE #searchTerm# <cfqueryparam value="#searchValue#" cfsqltype="#sqlType#">
						<cfif arguments.searchTerm NEQ "active">
							AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
						</cfif>
					</cfcase>

					<cfdefaultcase>
					WHERE #searchTerm# = <cfqueryparam value="#searchValue#" cfsqltype="#sqlType#">
						<cfif arguments.searchTerm NEQ "active">
							AND t.active = <cfqueryparam value="#!arguments.showInactive#" cfsqltype="cf_sql_bit">
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfquery>
			<cfcatch type="any">
				<cfset var message = {
					"customMessage" : "Error occurred in Adventure Access GETBYCREATIONDATE.",
					"errorMessage"  : "#cfcatch.message#"
				}>

				<cfthrow type="CustomError" message=#serializeJSON( message )#>
			</cfcatch>
		</cftry>

		<cfreturn getByCreationDate>
	</cffunction>

	<cffunction
		name      ="getPages"
		access    ="package"
		returntype="Array"
		output    ="false"
		hint      ="Gets all pages for a given adventure"
	>

		<cfargument name="adventureId" type="string" required="true">
		<cfargument name="onlyActive" type="boolean" required="false" default="true">

		<cftry>
			<cfquery name="getPages" datasource="#dataSource#">
				SELECT p.id
				,p.modified_on
				,p.active
				,p.name
				,p.description
				,p.adventure_id
				,p.content
				,p.choices
				FROM adventure_pages p
				WHERE p.adventure_id = <cfqueryparam value="#arguments.adventureId#" cfsqltype="cf_sql_varchar">
				AND p.active = <cfqueryparam value="#onlyActive#" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfset var result = lowerCaseColumns(query=getPages)>

			<cfcatch type="any">
				<cfset var message = {
					"customMessage" : "Error occurred in Adventure Access GETPAGES.",
					"errorMessage"  : "#cfcatch.message#"
				}>

				<cfthrow type="CustomError" message=#serializeJSON( message )#>
			</cfcatch>
		</cftry>

		<!--- <cfreturn converter.QueryToArray(getPages)> --->
		<cfreturn result>
	</cffunction>
</cfcomponent>
