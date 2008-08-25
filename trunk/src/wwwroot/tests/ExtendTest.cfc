<cfcomponent name="ExtendTest" 
	hint="DbC Extend Test" 
	extends="tests.Test"
	invariants="self.x gt 2"
>


	<cffunction name="do"
		hint="Test Method"
		access="public"
		output="false"
		returnType="numeric"
		preconditions="arguments.y eq 3"
		postconditions="cfreturn eq 4"
	>
		<cfargument name="y" type="numeric" required="true">
	
		<cfset this.x = arguments.y />
	
		<cfreturn 4 />
	</cffunction>

</cfcomponent>