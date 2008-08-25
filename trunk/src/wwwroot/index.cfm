
<cfset variables.coldspring = createObject("component","coldspring.beans.DefaultXmlBeanFactory").init() />
<cfset variables.coldspring.loadBeansFromXmlFile(expandPath("coldspring.xml"), true) />

<!cfset variables.test = variables.coldspring.getBean("test") />

<!cfset variables.test.do(2) />


<cfset variables.test = variables.coldspring.getBean("extendTest") />

<!cfset variables.test.do(3) /> <!--- Should fail due to inherited postconditions --->


<cfset variables.stack = variables.coldspring.getBean('stack') />

<cfset variables.stack.push('there') />
<cfset variables.stack.push('hi') />

<cfoutput>#variables.stack.pop()#</cfoutput>
<cfoutput>#variables.stack.pop()#</cfoutput>
<!---><cfoutput>#variables.stack.pop()#</cfoutput>--->  <!--- Should fail precondition --->

<!---<cfset variables.stack.push(variables.stack) />--->  <!--- Should fail precondition --->

