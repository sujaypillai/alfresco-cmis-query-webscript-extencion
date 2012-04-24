[#ftl]
[#import "/org/alfresco/cmis/lib/links.lib.atom.ftl" as linksLib/]

[#import "/org/alfresco/cmis/lib/jsonentry.lib.atom.ftl" as entryLib/]
[#import "/org/alfresco/paging.lib.atom.ftl" as pagingLib/]
[#compress]
	"response" : [
		"info": {
			"query" : "${statement?xml}",
			"author" : "${person.properties.userName?xml}",
			"generator" : "Alfresco (${server.edition?xml})",
			"version" : "${server.version?xml}",
			"updated" : "${xmldate(date)}"
		},

		"paging" : {
			"totalResults" : "${cursor.totalRows?c}",
			"startIndex" : "${cursor.startRow?c}",
			"itemsPerPage" : "${cursor.pageSize?c}",
			"numItems" : "${cursor.totalRows?c}"
		},
			
		"result" : [
			[#assign rs = cmisresultset(resultset, cursor)]
			[#list rs.rows as row]
				[@entryLib.row row=row includeallowableactions=includeAllowableActions includerelationships=includeRelationships/][#if row_has_next],[/#if]
			[/#list]
		]
	]
[/#compress]