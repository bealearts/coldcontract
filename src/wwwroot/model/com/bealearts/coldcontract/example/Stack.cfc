<!---
/**
 *
 * Copyright (c) 2008 David Beale (http://www.BealeARTS.co.uk)
 *		
 **/
--->

<cfcomponent displayname="Stack"
	hint="A FILO Stack example showing the use of ColdContract assertions. Stack items cannot be objects (Components)."
	invariants="this.getNumberOfItems() gte 0"
>
	
	<!--- INIT --->

	<cffunction name="init"
		hint="Constructor"
		access="public"
		returnType="Stack"
		output="false"
	>
		<cfreturn this />
	</cffunction>


	<!--- PUBLIC --->

	<cffunction name="push"
		hint="Push an item onto the stack"
		access="public"
		returnType="void"
		output="false"
		preconditions="not isObject(arguments.item)"
		postconditions="this.getNumberOfItems() eq oldThis.getNumberOfItems() + 1, variables.stackIndex eq oldVariables.stackIndex + 1"
	>
		<cfargument name="item" hint="Item to add" type="any" required="true" />
		
		<cfset arrayAppend(variables.stack, arguments.item) />
		<cfset variables.stackIndex++ />
	
	</cffunction>
	

	<cffunction name="pop"
		hint="Pop an item off the stack"
		access="public"
		returnType="any"
		output="false"
		preconditions="this..getNumberOfItems() gt 0"
		postconditions="this.getNumberOfItems() eq oldThis.getNumberOfItems() - 1, not isObject(cfreturn), variables.stackIndex eq oldVariables.stackIndex - 1"
	>
	
		<!--- LOCALS --->
		<cfset item = '' />
		
		<cfset item = variables.stack[variables.stackIndex] />
		<cfset arrayDeleteAt(variables.stack, variables.stackIndex) />
		<cfset variables.stackIndex-- />
	
		<cfreturn item />
	</cffunction>	
	
	
	<cffunction name="getNumberOfItems"
		hint="Get the number of items on the stack"
		access="public"
		returnType="numeric"
		output="false"
	>
		<cfreturn arrayLen(variables.stack) />
	</cffunction>		
	
	
	<!--- PRIVATE --->
	
	<cfset variables.stack = arrayNew(1) />
	
	<cfset variables.stackIndex = 0 />

</cfcomponent>