<cfparam name="pageTitle" default="Welcome to Clean Campus">
<cfoutput>
<html>
	<head>
		<title>#pageTitle#</title>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
		<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
		#javaScriptIncludeTag(sources="jquery.globalfunctions,jquery.livequery,jquery.lightbox-0.5.min")#
		<!--[if lt IE 9]>
			<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		#styleSheetLinkTag(sources="global,jquery.lightbox-0.5")#
		<link href="http://fonts.googleapis.com/css?family=Open+Sans:400,300,700,600" rel="stylesheet">
	</head>
	<body>
		
		<div id="mainHolder">
			<!--- Display main content --->
			#includeContent()#	
		</div>
		
		<footer>
			<ul>
				<li><a href="##">About</a></li>
				<li><a href="##">Contact</a></li>
				<li><a href="##">Press</a></li>
				<li class="last">&copy; #LoadSiteTitle()# 2011-#year(now())#</li>
			</ul>
		</footer>
		
		<!--- Display any flash messages --->
		<cfif NOT flashIsEmpty()>
			<div id="notification" class="notification <cfif flashKeyExists('success')>success<cfelseif flashKeyExists('error')>error</cfif>">
				<span id="notification-text"><cfif flashKeyExists("success")>#flash("success")#<cfelseif flashKeyExists("error")>#flash("error")#</cfif></span>
			</div>
		</cfif>
	</body>
</html>
</cfoutput>