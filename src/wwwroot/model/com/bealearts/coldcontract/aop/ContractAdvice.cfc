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
		
				 
		<cfset contract.validatePre( arguments.methodInvocation.getTarget(), methodName, args ) />
			
		<cfset rtn = arguments.methodInvocation.proceed() />
		
		<cfif isDefined('rtn')>
			<cfset contract.validatePost( arguments.methodInvocation.getTarget(), methodName, args, oldObject, rtn ) />
			<cfreturn rtn />
		<cfelse>
			<cfset contract.validatePost( arguments.methodInvocation.getTarget(), methodName, args, oldObject ) />
		</cfif>
	
	</cffunction>
	
	
	<!--- PRIVATE --->
	
	<cfset contract = createObject("component", "com.bealearts.coldcontract.Contract").init( false ) />
	
</cfcomponent>