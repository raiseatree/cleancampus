<cfcomponent hint="I contain the main functions for the log Analyzer plugin" extends="railo-context.admin.plugin.Plugin">
<!---
/*
 * Action.cfc, enhanced by Paul Klinkenberg
 * Originally written by Gert Franz
 * http://www.railodeveloper.com/post.cfm/railo-admin-log-analyzer
 *
 * Date: 2010-12-02 15:27:00 +0100
 * Revision: 2.1.1
 *
 * Copyright (c) 2010 Paul Klinkenberg, railodeveloper.com
 * Licensed under the GPL license.
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *    ALWAYS LEAVE THIS COPYRIGHT NOTICE IN PLACE!
 */
--->		
	<cffunction name="init" hint="this function will be called to initalize">
		<cfargument name="lang" type="struct">
		<cfargument name="app" type="struct">
	</cffunction>
	
	
	<cffunction name="getWebContexts" returntype="query" access="public" output="no">
		<cfargument name="fromCache" type="boolean" default="true" />
		<cfset var qWebContexts = "" />
		
		<cfif not structKeyExists(variables, "qWebContexts") or not arguments.fromCache>
			<!--- get all web contexts --->
			<cfadmin
				action="getContextes"
				type="server"
				password="#session.passwordserver#"
				returnVariable="qWebContexts" />
			<cfset variables.qWebContexts = qWebContexts />
		</cfif>
		<cfreturn variables.qWebContexts />
	</cffunction>
	
	
	<cffunction name="getLogPath" returntype="string" output="no" hint="This function returns the full log file path, and does some security checking">
		<cfargument name="file" type="string" required="false" hint="When given, we check and return the full path to this file. Otherwise, we just return the log files directory" />
		<cfif request.admintype eq "web">
			<cfset var logDir = expandPath("{railo-web}/logs/") />
		<cfelseif session.logAnalyzer.webID eq "serverContext">
			<cfset var logDir = expandPath("{railo-server}/logs/") />
		<cfelse>
			<cfset var logDir = getLogPathByWebID(session.logAnalyzer.webID) />
		</cfif>
		<cfif structKeyExists(arguments, "file") and len(arguments.file)>
			<cfset logDir = rereplace(logDir, "\#server.separator.file#$", "") & server.separator.file & listLast(arguments.file, "/\") />
			<cfif not fileExists(logDir)>
				<cfthrow message="log directory '#logDir#' does not exist!" />
			</cfif>
		</cfif>
		<cfreturn logDir />
	</cffunction>


	<cffunction name="getLogPathByWebID" returntype="string" output="no" hint="I return the path to the log directory for a given web context">
		<cfargument name="webID" type="string" required="true" />
		<cfif request.admintype eq "web">
			<cfthrow message="Function getLogPathByWebID() may only be used in the server admin!" />
		</cfif>
		<cfset var cacheKey = "webContextLogPaths" />
		<cfif not structKeyExists(variables, cacheKey)>
			<cfset var webContexts = getWebContexts() />
			<cfset var tmp = {} />
			<cfloop query="webContexts">
				<cfset tmp[webContexts.id] = rereplace(webContexts.config_file, "[^/\\]+$", "") & "logs" & server.separator.file />
			</cfloop>
			<cfset variables[cacheKey] = tmp />
		</cfif>
		<cfreturn variables[cacheKey][arguments.webID] />
	</cffunction>


	<cffunction name="getWebRootPathByWebID" returntype="string" output="no" hint="I return the path to the webroot for a given web context">
		<cfargument name="webID" type="string" required="true" />
		<cfif request.admintype eq "web">
			<cfthrow message="Function getWebRootPathByWebID() may only be used in the server admin!" />
		</cfif>
		<cfset var cacheKey = "webrootPaths" />
		<cfif not structKeyExists(variables, cacheKey)>
			<cfset var webContexts = getWebContexts() />
			<cfset var tmp = {} />
			<cfloop query="webContexts">
				<cfset tmp[webContexts.id] = webContexts.path />
			</cfloop>
			<cfset variables[cacheKey] = tmp />
		</cfif>
		<cfreturn variables[cacheKey][arguments.webID] />
	</cffunction>


	<cffunction name="getTextTimeSpan" output="no" hint="creates a text string indicating the timespan between NOW and given datetime">
		<cfargument name="date" type="date" required="yes" />
		<cfargument name="lang" type="struct" required="yes" />
		<cfset var diffSecs = dateDiff('s', arguments.date, now()) />
		<cfif diffSecs lt 60>
			<cfreturn replace(lang.Xsecondsago, '%1', diffSecs) />
		<cfelseif diffSecs lt 3600>
			<cfreturn replace(lang.Xminutesago, '%1', int(diffSecs/60)) />
		<cfelseif diffSecs lt 86400>
			<cfreturn replace(lang.Xhoursago, '%1', int(diffSecs/3600)) />
		<cfelse>
			<cfreturn replace(lang.Xdaysago, '%1', int(diffSecs/86400)) />
		</cfif>
	</cffunction>
	
	<cffunction name="overview" output="yes" hint="list all files from the local web">
		<cfargument name="lang" type="struct">
		<cfargument name="app" type="struct">
		<cfargument name="req" type="struct">
		
		<cfparam name="session.loganalyzer.webID" default="" />
		<!--- web context chosen? --->
		<cfif request.admintype eq "server" and structKeyExists(form, "webID") and len(form.webID)>
			<cfset session.logAnalyzer.webID = form.webID />
		</cfif>
		
		<cfif request.admintype neq "server" or len(session.loganalyzer.webID)>
			<cfset arguments.req.logfiles = getLogs() />
		</cfif>
	</cffunction>
	
	<cffunction name="getLogs" output="Yes" returntype="query">
		<cfset var qGetLogs = ""/>
		<cfset var tempFilePath = getLogPath() />
		<cfdirectory action="list" listinfo="Name,datelastmodified,size" directory="#tempFilePath#" filter="*.log|*.bak" name="qGetLogs" sort="name asc" />
		<cfreturn qGetLogs />
	</cffunction>	
	
	<cffunction name="list" output="no" hint="analyze the logfile">
		<cfargument name="lang" type="struct">
		<cfargument name="app" type="struct">
		<cfargument name="req" type="struct">
		<cfset var i        = 0>
		<cfset var j        = 0>
		<cfset var stErrors = StructNew()>
		<cfset var sLine    = "">
		<cfset var aDump    = ArrayNew(1)>
		<cfset var sTmp     = "">
		<cfset var st       = arrayNew(1)>
		
		<!--- when viewing logs in the server admin, then a webID must be defined --->
		<cfif request.admintype eq "server">
			<cfparam name="session.loganalyzer.webID" default="" />
			<cfif not len(session.loganalyzer.webID)>
				<cfset var gotoUrl = rereplace(action('overview'), "^[[:space:]]+", "") />
				<cflocation url="#gotoUrl#" addtoken="no" />
			</cfif>
		</cfif>
		
		<cfparam name="url.logfile" default="" />
		<cfparam name="form.logfile" default="#url.logfile#" />
		<cfset form.logfile = getLogPath(file=form.logfile) />
		
		<cfparam name="url.sort" default="date" />
		<cfparam name="url.dir" default="desc" />
		
		<cfloop file="#form.logfile#" index="sLine">
			<!--- If line starts with a quote, then it is either an error line, or the end of a dump--->
			<cfif left(sLine, 1) eq '"'>
				<!--- if not a new error --->
				<cfif not refind('^"[A-Z-]+","', sLine)>
					<cfif isDefined("aDump") and ArrayLen(aDump) gt 1>
						<cfif isStruct(aDump[6])>
				 			<cfset aDump[6].detail &= Chr(13) & Chr(10) & sLine>
						<cfelse>
							<cfset sTmp = aDump[6]>
							<cfset aDump[6]          = structNew()>
							<cfset aDump[6].error    = sTmp>
				 			<cfset aDump[6].detail   = sLine>
							<cfset aDump[6].fileName = "" />
							<cfset aDump[6].lineNo   = "" />
							<cfset sTmp = "" />
						</cfif>
					</cfif>
				<!--- new error --->
				<cfelse>
					<cfset aTmp = ListToArray(rereplace(rereplace(trim(sLine), '(^"|"$)', '', 'all'), '",("|$)', chr(10), "all"), chr(10), true) />
					<!--- was there a previous error --->
					<cfif ArrayLen(aDump) eq 6>
						<cfset __addError(aDump, stErrors) />
					</cfif>
					<!--- create new error container --->
					<cfset aDump = aTmp>
					<cfset sTmp = aDump[6]>
					<!--- in some cases, there is no message text on the first line of the error output.
					This seems to have to do with customly thrown errors, where message="". --->
					<cfif sTmp eq "">
						<cfset sTmp = "no error msg #structCount(stErrors)#" />
					</cfif>
					<cfset aDump[6]          = structNew()>
					<cfset aDump[6].error    = sTmp>
		 			<cfset aDump[6].detail   = sLine>
					<cfset aDump[6].fileName = "">
					<cfset aDump[6].lineNo   = 0>
					<cfset sTmp = "">
				</cfif>
			<!--- within a dump output --->
			<cfelse>
				<cfif isDefined("aDump") and ArrayLen(aDump) gt 1>
					<cfif isStruct(aDump[6])>
			 			<cfset aDump[6].detail &= Chr(13) & Chr(10) & sLine>
					<cfelse>
						<cfset sTmp = aDump[6]>
						<cfset aDump[6]          = structNew()>
						<cfset aDump[6].error    = sTmp>
			 			<cfset aDump[6].detail   = sLine>
						<cfset aDump[6].fileName = "">
						<cfset aDump[6].lineNo   = 0>
						<cfset sTmp = "">
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<!--- add the last error --->
		<cfif ArrayLen(aDump) eq 6>
			<cfset __addError(aDump, stErrors) />
		</cfif>
		<!--- orderby can change--->
		<cfif url.sort eq "msg">
			<cfset st = structSort(stErrors, "textnocase", url.dir, "message")>
		<cfelseif url.sort eq "date">
			<cfset st = structSort(stErrors, "textnocase", url.dir, "lastdate")>
		<cfelse>
			<cfset st = structSort(stErrors, "numeric", url.dir, "icount")>
		</cfif>
		<cfset req.result.sortOrder = st>
		<cfset req.result.stErrors  = stErrors>
	</cffunction>
	
	<cffunction name="__addError" access="public" returntype="void" output="no">
		<cfargument name="aDump" type="array" />
		<cfargument name="stErrors" type="struct" />
		<cftry>
			<!--- 	at test_cfm$cf.call(/developing/tools/test.cfm:1):1 --->
			<cfset var aLine = REFind("\(([^\(\)]+\.cfm):([0-9]+)\)", aDump[6].detail, 1, true) />
			<cfif aLine.pos[1] gt 0>
				<cfset aDump[6].fileName = Mid(aDump[6].detail, aLine.pos[2], aLine.len[2])>
				<cfset aDump[6].lineNo   = Mid(aDump[6].detail, aLine.pos[3], aLine.len[3])>
			</cfif>
			<cfset var sHash = Hash(aDump[6].error)>
			<cfset var tempdate = parsedatetime(aDump[3] & " " & aDump[4]) />
			<cfif structKeyExists(stErrors, sHash)>
				<cfset stErrors[sHash].iCount++ />
				<cfset ArrayAppend(stErrors[sHash].datetime, tempdate) />
				<cfset stErrors[sHash].lastdate = tempdate />
			<cfelse>
				<cfset stErrors[sHash] = {
					"message":aDump[6].error,
					"detail":aDump[6].detail,
					"file":aDump[6].fileName,
					"line":aDump[6].lineNo,
					"type":aDump[1],
					"thread":aDump[2],
					"datetime":[tempdate],
					"iCount":1
					, "firstdate": tempdate
					, "lastdate": tempdate
				} />
			</cfif>
			<cfcatch></cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>