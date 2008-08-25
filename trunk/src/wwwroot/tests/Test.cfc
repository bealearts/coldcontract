<cfcomponent name="Test" 
	hint="DbC Test" 
	invariants="self.x lt 5"
>

	<cfset this.x = 3 />
	
	<cffunction name="init"
		hint="Constructor"
		access="public"
		output="false"
		returnType="Test"
	>
	
		<cfreturn this />
	</cffunction>

	<cffunction name="do"
		hint="Test Method"
		access="public"
		output="false"
		returnType="numeric"
		preconditions="arguments.y gt 0, arguments.y lt 5"
		postconditions="cfreturn lte  5, obj.x = arguments.y"
	>
		<cfargument name="y" type="numeric" required="true">
	
		<cfset this.x = arguments.y />
	
		<cfreturn 5 />
	</cffunction>

</cfcomponent>