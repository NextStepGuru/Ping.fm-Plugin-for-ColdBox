<cfcomponent hint="pingfm" output="false" extends="coldbox.system.Plugin" cache="true">

	<cffunction name="init" access="public" returnType="pingfm" output="false" hint="Constructor">
		<cfscript>
			// Setup Plugin
			setPluginName("Ping.fm API");
			setPluginVersion("1.0");
			setPluginDescription("A REST wrapper to the Ping.fm API service");
			setPluginAuthor("Jeremy R DeYoung");
			setPluginAuthorURL("http://www.lunarfly.com");

			instance.apiURL = "http://api.ping.fm/v1/";

			return this;
		</cfscript>
	</cffunction>

	<!--- Ping.fm User.Post API --->
    <cffunction name="userPost" output="false" access="public" returntype="any">
		<cfscript>
			var requiredFields = "post_method,body";
			var optionalFields = "title,service,location,tags,mood,media,encoding,exclude,debug,checksum,media_checksum";

			var argList = structKeyList(arguments);

			//check for required arguments
			checkRequiredFields(argList,requiredFields);

			//check invalid arguments
			checkInvalidArguments(argList,requiredFields & "," & requiredFields);

			arguments.httpMethod = "POST";
			arguments.restURLPrefix = "user.post";
			results = sendAndReceive(argumentCollection=arguments);
			return trim(results);
		</cfscript>
    </cffunction>


	<!--- Ping.fm User App Key --->
    <cffunction name="setUserAppKey" output="false" access="public" returntype="void" hint="Set the Bit.ly User App Key">
    	<cfargument name="user_app_key" type="string" required="true" default="" hint="The Bit.ly Login"/>
		<cfscript>
			instance.user_app_key = arguments.user_app_key;
		</cfscript>
    </cffunction>
    <cffunction name="getUserAppKey" output="false" access="public" returntype="string" hint="Set the Bit.ly User App Key">

		<cfreturn instance.user_app_key />
    </cffunction>


	<!--- Ping.fm API Key --->
    <cffunction name="setAPIKey" output="false" access="public" returntype="void" hint="Set the Bit.ly API Key">
    	<cfargument name="apikey" type="string" required="true" default="" hint="The Bit.ly API Key"/>
		<cfscript>
			instance.apikey = arguments.apikey;
		</cfscript>
    </cffunction>
    <cffunction name="getAPIKey" output="false" access="public" returntype="string" hint="Set the Bit.ly API Key">

		<cfreturn instance.apikey />
    </cffunction>


	<!--- Private Functions --->
    <cffunction name="sendAndReceive" output="false" access="private" returntype="any">
		<cfscript>
			var httpService = new http();
			var argumentsList = StructKeyList(arguments);
			var httpURL = instance.apiURL;
			var httpMethod = arguments.httpMethod;
			var restPrefix = arguments.restURLPrefix;
			var contentType = "";
			var queryString = "";

			for(var i=1;i<=ListLen(argumentsList);i++)
			{
				if(ListFindNoCase("httpMethod,httpURL,contentType,restURLPrefix",ListGetAt(argumentsList,i)))
				{
					structDelete(arguments,ListGetAt(argumentsList,i));
				}
				else
				{
					httpService.addParam(type="formfield",name=ListGetAt(argumentsList,i),value=arguments[ListGetAt(argumentsList,i)]);
				}
			}

			httpService.addParam(type="formfield",name="api_key",value=this.getAPIKey());
			httpService.addParam(type="formfield",name="user_app_key",value=this.getUserAppKey());

			httpService.setMethod(httpMethod);
		    httpService.setCharset("utf-8");
		    httpService.setUrl(httpURL & restPrefix);
			var result = httpService.send().getPrefix();

			return result.filecontent;
		</cfscript>
    </cffunction>

    <cffunction name="checkRequiredFields" output="false" access="private" returntype="void" hint="Checks for the Required Fields">
    	<cfargument name="args" type="string" required="true" default="" hint="String List of All Arguments"/>
    	<cfargument name="flds" type="string" required="true" default="" hint="String List of all Required Fields"/>
		<cfscript>
			for(var i=1;i<=ListLen(flds);i++)
			{
				if(!ListFindNoCase(args,ListGetAt(flds,i)))
				{
					$throw("#ListGetAt(flds,i)# is a required argument");
				}
			}
		</cfscript>
    </cffunction>

    <cffunction name="checkInvalidArguments" output="false" access="private" returntype="void" hint="Checks for the Required Fields">
    	<cfargument name="args" type="string" required="true" default="" hint="String List of All Arguments"/>
    	<cfargument name="flds" type="string" required="true" default="" hint="String List of all Required Fields"/>
		<cfscript>
			for(var a=1;a<=ListLen(args);a++)
			{
				if(!ListFindNoCase(flds,ListGetAt(args,a)))
				{
					$throw("#ListGetAt(args,a)# is not a valid Required or Optional Argument");
				}
			}
		</cfscript>
    </cffunction>

</cfcomponent>