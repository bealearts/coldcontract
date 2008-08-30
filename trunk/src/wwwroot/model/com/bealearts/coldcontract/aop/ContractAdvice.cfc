<!---
/**
 *
 * Copyright (c) 2008 David Beale (http://www.BealeARTS.co.uk)
 *		
 **/
--->

<cfcomponent name="ContractAdvice" 
	hint="Advice to enforce contract"
	extends="coldspring.aop.MethodInterceptor"
	output="false"
>

	<!--- PUBLIC --->
	
	<cffunction name="invokeMethod"
		hint="Method Interceptor" 
		access="public"
		output="false" 
		returntype="any"
	>
	
		<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="true" /> 
	 
		<!--- LOCALS --->
		<cfset var args = structNew() />
		<cfset var methodName = '' />
		<cfset var objName = '' />
		<cfset var oldObject = '' />
		
		<!--- Get object and method details --->
		<cfset args = arguments.methodInvocation.getArguments() />
		<cfset methodName = arguments.methodInvocation.getMethod().getMethodName() />
		<cfset objName = getMetadata(arguments.methodInvocation.getTarget()).name />
		
		<!--- Copy existing object state --->
		<cfset oldObject = duplicate(arguments.methodInvocation.getTarget()) />
		
		<!--- Inject getVariables function --->
		<cfset oldObject.getVariablesScope = variables.contract.getVariablesScope />
		<cfset arguments.methodInvocation.getTarget().evaluateAssertion = variables.contract.evaluateAssertion />
				 
		<cfset contract.validatePre( arguments.methodInvocation.getTarget(), methodName, args ) />
			
		<cfset rtn = arguments.methodInvocation.proceed() />
		
		<cfif isDefined('rtn')>
			<cfset variables.contract.validatePost( arguments.methodInvocation.getTarget(), methodName, args, oldObject, rtn ) />
			<cfset structDelete(arguments.methodInvocation.getTarget(), 'evaluateAssertion') />
			<cfreturn rtn />
		<cfelse>
			<cfset variables.contract.validatePost( arguments.methodInvocation.getTarget(), methodName, args, oldObject ) />
			<cfset structDelete(arguments.methodInvocation.getTarget(), 'evaluateAssertion') />
		</cfif>
	
	</cffunction>
	
	
	<!--- PRIVATE --->
	
	<cfset variables.contract = createObject("component", "com.bealearts.coldcontract.Contract").init( true ) />
	
</cfcomponent>