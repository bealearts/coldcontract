
<cfcomponent displayname="Application">

	<cfset this.mappings["/"] = getDirectoryFromPath(getCurrentTemplatePath()) />

	<cfset this.mappings["/com"] = getDirectoryFromPath(getCurrentTemplatePath()) & 'model/com' />

	<cfset this.mappings["/tests"] = getDirectoryFromPath(getCurrentTemplatePath()) & 'tests' />
	
</cfcomponent>