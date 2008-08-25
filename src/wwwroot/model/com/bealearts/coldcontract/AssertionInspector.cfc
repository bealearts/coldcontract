<!---
/**
 *
 * Copyright (c) 2008 David Beale (http://www.BealeARTS.co.uk)
 *		
 **/
--->

<cfcomponent name="AssertionInspector"
	hint="Reads Assertions in a CFC"
	output="false"
>
	
	<!--- TODO: Recursivly parse inheritance chain, including interfaces --->
	
	<!--- PUBLIC --->

	<cffunction name="init"
		hint="Constructor"
		access="public"
		output="false"
		returnType="AssertionInspector"
	>
	
		<cfreturn this />
	</cffunction>
	
	
	<cffunction name="getInvariantAssertions"
		hint="Get an Object's Invariant Assertions, sub classes only allowed to add assertions"
		access="public"
		output="false"
		returnType="array"
	>
		<cfargument name="object" hint="Object to Inspect" type="any" required="true" /> 
		
		<!--- LOCALS --->
		<cfset var metaData = "" />
		<cfset var assertions = arrayNew(1) />
		
		<cfset metaData = getMetaData( arguments.object ) />
	
		<cfloop condition="true">
		
			<!--- Get Assertions --->
			<cfif structKeyExists(metaData, "invariants")>
				<cfset assertions.addAll( listToArray( metaData.invariants ) ) />
			</cfif>
			
			<!--- Parse inheritance chain --->
			<cfif structKeyExists(metaData, "extends")>
				<cfset metaData = metaData.extends />
			<cfelse>
				<cfbreak> />
			</cfif>
			
		</cfloop>	
			
			
		<cfreturn assertions />
	</cffunction>
	
	
	<cffunction name="getPreconditionAssertions"
		hint="Get an Object method's Precondition Assertions, sub classes only allowed to remove assertions (by overriding)"
		access="public"
		output="false"
		returnType="array"
	>
		<cfargument name="object" hint="Object to Inspect" type="any" required="true" />		
		<cfargument name="methodName" hint="Method Name" type="string" required="true" />
		
		<!--- LOCALS --->
		<cfset var metaData = "" />
		<cfset var assertions = arrayNew(1) />
		<cfset var currentMethod = "" />
		
		<cfset metaData = getMetaData( arguments.object ) />
		
		<cfloop condition="true">
		
			<!--- Find the method --->
			<cfif structKeyExists(metaData, 'functions') >
				<cfloop array="#metaData.functions#" index="currentMethod">
					<cfif currentMethod.Name eq arguments.methodName>
		
						<!--- Get Assertions --->
						<cfif structKeyExists(currentMethod, "preconditions")>
							<cfset assertions = listToArray( currentMethod.preconditions ) />
						</cfif>
						
						<!--- Return first assertions found in inheritance tree, as sub classes override precondition assertions --->
						<cfreturn assertions />	
						
					</cfif>
				</cfloop>
			</cfif>
			
			<!--- Parse inheritance chain --->
			<cfif structKeyExists(metaData, "extends")>
				<cfset metaData = metaData.extends />
			<cfelse>
				<cfbreak> />
			</cfif>
			
		</cfloop>			
			
		<cfreturn assertions />		
	</cffunction>	
	
	
	<cffunction name="getPostconditionAssertions"
		hint="Get an Object method's Postcondition Assertions, sub classes only allowed to add assertions"
		access="public"
		output="false"
		returnType="array"
	>
		<cfargument name="object" hint="Object to Inspect" type="any" required="true" />		
		<cfargument name="methodName" hint="Method Name" type="string" required="true" />
		
		<!--- LOCALS --->
		<cfset var metaData = "" />
		<cfset var assertions = arrayNew(1) />
		<cfset var currentMethod = "" />
		
		<cfset metaData = getMetaData( arguments.object ) />
		
		<cfloop condition="true">

			<!--- Find the method --->
			<cfif structKeyExists(metaData, 'functions') >
				<cfloop array="#metaData.functions#" index="currentMethod">
					<cfif currentMethod.Name eq arguments.methodName>
		
						<!--- Get Assertions --->
						<cfif structKeyExists(currentMethod, "postconditions")>
							<cfset assertions.addAll( listToArray( currentMethod.postconditions ) ) />
						</cfif>
						
						<cfbreak /> 
						
					</cfif>
				</cfloop>
			</cfif>
			
			<!--- Parse inheritance chain --->
			<cfif structKeyExists(metaData, "extends")>
				<cfset metaData = metaData.extends />
			<cfelse>
				<cfbreak> />
			</cfif>
			
		</cfloop>			
			
		<cfreturn assertions />					
	</cffunction>
	
	
	<!--- PRIVATE --->	

</cfcomponent>