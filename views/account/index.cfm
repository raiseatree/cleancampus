<cfparam name="data">
<cfoutput>
<section id="main">
				
	#loadLoggedInHeader()#
	
	<h1>Manage Account</h1>
	
	<section class="postRibbon">
	
		<ul id="tabNav">
			<li class="active"><a href="##tab1" class="tab">Personal Settings</a></li>
			<cfif IsUserInRole('uniadmin')>
				<li><a href="##tab2" class="tab">Plan Settings</a></li>
				<li><a href="##tab3" class="tab">Add User</a></li>
			</cfif>
			<li class="last"><a href="##tab4" class="tab">Edit Users</a></li>
		</ul>
		
		<div id="tab1" class="tabContent">
			<h2>Personal Settings</h2>
			<p>Change password etc. goes here...</p>
		</div>
	
		<cfif IsUserInRole('uniadmin')>
			<div id="tab2" class="tabContent hidden">
				<h2>Plan Settings</h2>
				<p>This is where the plan information goes - see Pivotal Tracker for a good example</p>
			</div>
		
		
			<div id="tab3" class="tabContent hidden">
				<h2>Add User</h2>
				<p>Here you can add new members of your university to manage problems sent in through Clean Campus.</p>
				
				#includePartial('/user/addUser')#
				
			</div>
		</cfif>
		
		<div id="tab4" class="tabContent hidden">
			<h2>Edit Users</h2>
			<p>Here you can view, edit and add all the facilities team within your university.</p>
			
			<table>
				<tr>
					<th>First Name</th>
					<th>Surname</th>
					<th>Email</th>
					<th>Assigned Categories</th>
					<th>Edit</th>
				</tr>
				<cfloop query="data.uniUsers">
					<tr>
						<td>#firstname#</td>
						<td>#surname#</td>
						<td>#email#</td>
						<td><cfloop list="#categories#" delimiters="," index="i">#i#<br /></cfloop></td>
						<td>#linkTo(controller="user", action="edit", params="ID=#id#", text=imageTag('edit.png'))#</td>
					</tr>
				</cfloop>
			</table>
			
		</div>
		
	</section>
</section>
</cfoutput>