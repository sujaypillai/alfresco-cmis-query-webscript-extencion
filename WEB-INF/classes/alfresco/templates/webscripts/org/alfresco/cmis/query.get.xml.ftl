[#ftl]
[#import "/org/alfresco/cmis/lib/links.lib.atom.ftl" as linksLib/]

[#import "/org/alfresco/cmis/lib/xmlentry.lib.atom.ftl" as entryLib/]
[#import "/org/alfresco/paging.lib.atom.ftl" as pagingLib/]
[#compress]
	<?xml version="1.0" encoding="UTF-8"?>
	<cmisquery>
		<info>
			<query>${statement?xml}</query>
			<author>${person.properties.userName?xml}</author>
			<generator version="${server.version?xml}">Alfresco (${server.edition?xml})</generator>
			<updated>${xmldate(date)}</updated>
		</info>

		<paging>
			<totalResults>${cursor.totalRows?c}</totalResults>
			<startIndex>${cursor.startRow?c}</startIndex>
			<itemsPerPage>${cursor.pageSize?c}</itemsPerPage>
			<numItems>${cursor.totalRows?c}</numItems>
		</paging>
			
		<result>
			[#assign rs = cmisresultset(resultset, cursor)]
			[#list rs.rows as row]
				[@entryLib.row row=row includeallowableactions=includeAllowableActions includerelationships=includeRelationships/]
			[/#list]
		</result>
	</cmisquery>
[/#compress]
