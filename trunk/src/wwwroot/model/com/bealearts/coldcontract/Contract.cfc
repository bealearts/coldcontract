<!---
/**
 *
 * Copyright (c) 2008 David Beale (http://www.BealeARTS.co.uk)
 *		
 **/
--->

<cfcomponent name="Contract"
	hint="Parse and Enforce a Contract"
	output="false"
>
	
	<!--- PUBLIC --->

	<cffunction name="init"
		hint="Constructor"
		access="public"
		output="false"
		returnType="Contract"
	>
		<cfargument name="debug" hint="Enable easyer debugging by disabling error handling" type="Boolean" required="true" default="false" />

		<cfset variables.assertionInspector = createObject("component", "com.bealearts.coldcontract.AssertionInspector").init() />
		
		<cfset varaibles.debug = arguments.debug />
	
		<cfreturn this />
	</cffunction>


	<cffunction name="validatePre"
		hint="Validate Invariants and Preconditions"
		access="public"
		output="false"
		returnType="void"
	>
		<cfargument name="obj" hint="Object to validate" type="any" required="true">
		<cfargument name="methodName" hint="Name of Method to Validate" type="string" required="true" /> 
		<cfargument name="args" hint="Arguments passed to Method" type="struct" required="true" />

		<cfset variables.validateInvariants( arguments.obj ) />
		
		<cfset variables.validatePreconditions( arguments.obj, arguments.methodName, arguments.args ) />

	</cffunction>
	
	
	<cffunction name="validatePost"
		hint="Validate Invariants and Postconditions"
		access="public"
		output="false"
		returnType="void"
	>
		<cfargument name="obj" hint="Object to validate" type="any" required="true">
		<cfargument name="methodName" hint="Name of Method to Validate" type="string" required="true" />
		<cfargument name="args" hint="Arguments passed to Method" type="struct" required="true" />>
		<cfargument name="oldObj" hint="Object before method was called" type="any" required="true">
		<cfargument name="rtn" hint="Result of Method" type="any" required="false" default="NO_RETURN" />


		<cfset variables.validateInvariants( arguments.obj ) />
		
		<cfset variables.validatePostconditions( arguments.obj, arguments.methodName, arguments.args, arguments.rtn, arguments.oldObj ) />

	</cffunction>
	
		
	
	<!--- PRIVATE --->

	<cfset variables.assertionInspector = "" />
	
	<cfset varaibles.debug = false />
	
	
	
	<cffunction name="validateInvariants"
		hint="Validate Invariants"
		access="private"
		output="false"
		returnType="void"
	> 
		<cfargument name="obj" hint="Object to validate" type="any" required="true">		

		<!--- LOCALS --->
		<cfset var assertions = "" />
		
		<!--- Get assertions to test --->
		<cfset assertions = assertionInspector.getInvariantAssertions( arguments.obj ) />
		
		<cfloop array="#assertions#" index="assertion">
			
			<cftry>
			
				<!--- Test the assertion --->
				<cfif not variables.evaluateAssertion(arguments.obj, assertion, structNew()) >
					<cfthrow type="com.bealearts.coldcontract.Contract.INVARIANT_ASSERTION_FAILED" message="Invariant Assertion Failed: '#assertion#' for CFC '#getMetaData(arguments.obj).fullname#'" />
				</cfif>
			
 				<cfcatch type="any">
					<cfif (not cfcatch.type contains "com.bealearts.coldcontract.Contract") and not varaibles.debug>
						<!--- Handle invalide assertion --->
						<cfthrow type="com.bealearts.coldcontract.Contract.INVALID_INVARIANT_ASSERTION" message="Invalid Invariant Assertion: '#assertion#' for CFC '#getMetaData(arguments.obj).fullname#'" />
					<cfelse>
						<cfrethrow /> 
					</cfif>
					
				</cfcatch>
				
			</cftry>
			
		</cfloop>

	</cffunction>	



	<cffunction name="validatePreconditions"
		hint="Validate Preconditions"
		access="private"
		output="false"
		returnType="void"
	>
		<cfargument name="obj" hint="Object to validate" type="any" required="true">
		<cfargument name="methodName" hint="Name of Method to Validate" type="string" required="true" /> 
		<cfargument name="args" hint="Arguments passed to Method" type="struct" required="true" />

		<!--- LOCALS --->
		<cfset var assertions = "" />
		
		<!--- Get assertions to test --->
		<cfset assertions = assertionInspector.getPreconditionAssertions( arguments.obj, arguments.methodName ) />
		
		<cfloop array="#assertions#" index="assertion">
			
			<cftry>
			
				<!--- Test the assertion --->
				<cfif not variables.evaluateAssertion(arguments.obj, assertion, arguments.args) >
					<cfthrow type="com.bealearts.coldcontract.Contract.PRECONDITION_ASSERTION_FAILED" message="Precondition Assertion Failed: '#assertion#' for method '#arguments.methodName#' in CFC '#getMetaData(arguments.obj).fullname#'" />
				</cfif>
			
 				<cfcatch type="any">
					<cfif (not cfcatch.type contains "com.bealearts.coldcontract.Contract") and not varaibles.debug>
						<!--- Handle invalide assertion --->
						<cfthrow type="com.bealearts.coldcontract.Contract.INVALID_PRECONDITION_ASSERTION" message="Invalid Precondition Assertion: '#assertion#' for method '#arguments.methodName#' in CFC '#getMetaData(arguments.obj).fullname#'" />
					<cfelse>
						<cfrethrow /> 
					</cfif>
					
				</cfcatch>
				
			</cftry>
			
		</cfloop>

	</cffunction>



	<cffunction name="validatePostconditions"
		hint="Validate Preconditions"
		access="private"
		output="false"
		returnType="void"
	>
		<cfargument name="obj" hint="Object to validate" type="any" required="true">
		<cfargument name="methodName" hint="Name of Method to Validate" type="string" required="true" /> 
		<cfargument name="args" hint="Arguments passed to Method" type="struct" required="true" />
		<cfargument name="rtn" hint="Result of Method" type="any" required="true" />
		<cfargument name="oldObj" hint="Object before method was called" type="any" required="true">

		
		<!--- LOCALS --->
		<cfset var assertions = "" />
		
		<!--- Get assertions to test --->
		<cfset assertions = assertionInspector.getPostconditionAssertions( arguments.obj, arguments.methodName ) />
		
		<cfloop array="#assertions#" index="assertion">
			
			<cftry>

				<!--- Test the assertion --->
				<cfif not variables.evaluateAssertion(arguments.obj, assertion, arguments.args, arguments.rtn, arguments.oldObj) >
					<cfthrow type="com.bealearts.coldcontract.Contract.POSTCONDITION_ASSERTION_FAILED" message="Postcondition Assertion Failed: '#assertion#' for method '#arguments.methodName#' in CFC '#getMetaData(arguments.obj).fullname#'" />
				</cfif>
			
 				<cfcatch type="any">
					<cfif (not cfcatch.type contains "com.bealearts.coldcontract.Contract") and not varaibles.debug>
						<!--- Handle invalide assertion --->
						<cfthrow type="com.bealearts.coldcontract.Contract.INVALID_POSTCONDITION_ASSERTION" message="Invalid Postcondition Assertion: '#assertion#' for method '#arguments.methodName#' in CFC '#getMetaData(arguments.obj).fullname#'" />
					<cfelse>
						<cfrethrow /> 
					</cfif>
					
				</cfcatch>
				
			</cftry>
			
		</cfloop>

	</cffunction>



	<cffunction name="evaluateAssertion"
		hint="Evaluate an Assertion on the Object"
		access="private"
		output="false"
		returnType="boolean"
	>
	>
		<cfargument name="obj" hint="Object to validate" type="any" required="true">
		<cfargument name="assertion" hint="Assertion to Evaluate" type="string" required="true" /> 
		<cfargument name="methodArgs" hint="Arguments passed to Method" type="struct" required="true" />
		<cfargument name="methodReturn" hint="Result of Method" type="any" required="false" default="NO_RETURN" />
		<cfargument name="oldObj" hint="Object before method was called" type="any" required="false" default="">
		
		<!--- LOCALS --->
		<cfset var self = "" />
		<cfset var assertionResult = false />
		<cfset var thisArguments = structNew() />

		<!--- Save this methods arguments as they will be wiped over --->
		<cfset thisArguments = structCopy(arguments) />
		
		<!---
	 		Create a fake contract object environment to run assertion in.
	 		This method means asserstions can not use local scope or variables scope.
		 --->
		
		<!--- reference contract object as self --->
		<cfset self = thisArguments.obj />
		
		<!--- reference method's Arguments as arguments --->
		<cfset arguments = thisArguments.methodArgs />
		
		<!--- reference method's result as cfreturn --->
		<cfif not isSimpleValue(thisArguments.methodReturn) or thisArguments.methodReturn neq 'NO_RETURN'>
			<cfset cfreturn = thisArguments.methodReturn />	
		</cfif>
		
		<!--- reference to contract object before method was called as oldSelf --->
		<cfif isObject(thisArguments.oldObj) >
			<cfset oldSelf = thisArguments.oldObj />				
		</cfif>		
		
<!--- http://www.javaworld.com/javaworld/jw-02-2001/jw-0216-cooltools.html?page=4 --->

		<!--- Evaluate Assertion within the fake contract object environment --->
		<cfset assertionResult = evaluate( thisArguments.assertion ) />
		
		<cfreturn assertionResult />
	</cffunction>
	
	
</cfcomponent>