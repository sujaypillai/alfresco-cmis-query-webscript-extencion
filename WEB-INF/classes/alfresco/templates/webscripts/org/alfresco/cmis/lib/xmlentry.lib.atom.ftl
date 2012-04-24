[#ftl]

[#--            --]
[#-- ATOM Entry --]
[#--            --]

[#macro entry ns=""]
<node>
	[#nested]
</node>
[/#macro]

[#macro objectCMISProps object propfilter][@typeCMISProps object cmistype(object) propfilter/][/#macro]

[#macro typeCMISProps object typedef propfilter]
  [#list typedef.propertyDefinitions?values as propdef]
    [@filter propfilter propdef.queryName][@prop object propdef/][/@filter]
  [/#list]
[/#macro]

[#--                          --]
[#-- ATOM Entry for Query Row --]
[#--                          --]
[#-- TODO: spec issue 47 --]
[#macro row row renditionfilter="cmis:none" includeallowableactions=false includerelationships="none"]
	[@entry]
		[#-- TODO: calculate multiNodeResultSet from result set --]
		[#if row.node??]
			[#assign node = row.node/]
			<author>${node.properties.creator!""}</author>
			[@contentstream node/]
			<id>urn:uuid:${node.id}</id>
			<title>${node.name?xml}</title>
			<updated>${xmldate(node.properties.modified)}</updated>
		[#else]
			<author>${person.properties.userName?xml}</author>
			<id>urn:uuid:row-${row.index?c}</id>
			<title>Row ${row.index?c}</title>
			<updated>${xmldate(now)}</updated>
		[/#if]

		[#assign rowvalues = row.values]
		[#list rowvalues?keys as colname]
		  [#assign coltype = row.getColumnType(colname)]
		  [#if row.getPropertyDefinition(colname)??]
			[#assign propdef = row.getPropertyDefinition(colname)]
			[#if rowvalues[colname]??]
			  [@propvalue rowvalues[colname] coltype propdef.propertyId.id propdef.displayName colname propdef.propertyId.localName/]
			[#else]
			  [@propnull coltype propdef.propertyId.id propdef.displayName colname propdef.propertyId.localName/]
			[/#if]
		  [#else]
			[#if rowvalues[colname]??]
			  [@propvalue value=rowvalues[colname] type=coltype queryname=colname/]
			[#else]
			  [@propnull type=coltype queryname=colname/]
			[/#if]
		  [/#if]
		[/#list]
		[#if node??]
			[#if includeallowableactions][@allowableactions node/][/#if]
			[@relationships node includerelationships includeallowableactions/]
		[/#if]
	[/@entry]
[/#macro]


[#--                 --]
[#-- CMIS Properties --]
[#--                 --]

[#macro filter filter value]
	[#if filter == "*" || filter?index_of(value) != -1 || filter?matches(value,'i')][#nested][/#if]
[/#macro]

[#macro prop object propdef]
	[#assign value=cmisproperty(object, propdef.propertyId.id)/]
	[#if value?is_string || value?is_number || value?is_boolean || value?is_date || value?is_enumerable][@propvaluedef value propdef/]
	[#elseif value.class.canonicalName?ends_with("NULL")][@propnulldef propdef/]
	[/#if]
[/#macro]

[#macro propvaluedef value propdef]
  [@propvalue value propdef.dataType.label propdef.propertyId.id propdef.displayName propdef.queryName propdef.propertyId.localName/]
[/#macro]

[#macro propvalue value type defid="" displayname="" queryname="" localname=""]
	[#if type == cmisconstants.DATATYPE_STRING]
		[@propargs defid displayname queryname localname type][@values value;v][@stringvalue v/][/@values][/@propargs]
	[#elseif type == cmisconstants.DATATYPE_INTEGER]
		[@propargs defid displayname queryname localname type][@values value;v][@integervalue v/][/@values][/@propargs]
	[#elseif type == cmisconstants.DATATYPE_DECIMAL]
		[@propargs defid displayname queryname localname type][@values value;v][@decimalvalue v/][/@values][/@propargs] 
	[#elseif type == cmisconstants.DATATYPE_BOOLEAN]
		[@propargs defid displayname queryname localname type][@values value;v][@booleanvalue v/][/@values][/@propargs] 
	[#elseif type == cmisconstants.DATATYPE_DATETIME]
		[@propargs defid displayname queryname localname type][@values value;v][@datetimevalue v/][/@values][/@propargs] 
	[#elseif type == cmisconstants.DATATYPE_URI]
		[@propargs defid displayname queryname localname type][@values value;v][@urivalue absurl(url.serviceContext) + v/][/@values][/@propargs] 
	[#elseif type == cmisconstants.DATATYPE_ID]
		[@propargs defid displayname queryname localname  type][@values value;v][@idvalue v/][/@values][/@propargs] 
	[/#if]
[/#macro]

[#macro propnulldef propdef]
	[@propnull propdef.dataType.label propdef.propertyId.id propdef.displayName propdef.queryName propdef.propertyId.localName/]
[/#macro]


[#--                 --]
[#-- Print null args --]
[#--                 --]
[#macro propnull type defid="" displayname="" queryname="" localname=""]
	[@propargs defid displayname queryname localname]
		[@values value;v][/@values]
	[/@propargs] 
[/#macro]


[#--            --]
[#-- Print args --]
[#--            --]
[#macro propargs defid="" displayname="" queryname="" localname="" type=""]
	[#if defid !=""]
		<${defid?xml?replace(":","_")} type="${type}">[#nested]</${defid?xml?replace(":","_")}>
	[#elseif displayname != ""] 
		<${displayname?xml?replace(":","_")} type="${type}">[#nested]</${displayname?xml?replace(":","_")}>
	[#elseif queryname != ""] 
		<${queryname?xml?replace(":","_")} type="${type}">[#nested]</${queryname?xml?replace(":","_")}>
	[/#if]
[/#macro]

[#macro values vals=""]
	[#if vals?is_enumerable]
		[#list vals as val]
			[#nested val]
		[/#list]
	[#else]
		[#nested vals]
	[/#if]
[/#macro]

[#macro stringvalue value]${value?xml}[/#macro]
[#macro integervalue value]${value?c}[/#macro]
[#macro decimalvalue value]${value?c}[/#macro]
[#macro booleanvalue value]${value?string}[/#macro]
[#macro datetimevalue value]${xmldate(value)}[/#macro]
[#macro urivalue value]${value?xml}[/#macro]
[#macro idvalue value][#if value?is_hash && value.nodeRef??]${value.nodeRef?xml}[#else]${value?xml}[/#if][/#macro]

[#--                    --]
[#-- CMIS Relationships --]
[#--                    --]
[#macro relationships node includerelationships="none" includeallowableactions=false propfilter="*"]
	[#if includerelationships != "none"]
		[#list cmisassocs(node, includerelationships) as assoc]
		  <cmis_relationship>
			[@objectCMISProps assoc propfilter/]
			[#if includeallowableactions][@assocallowableactions assoc/][/#if]
		  </cmis_relationship>
		[/#list]
	[/#if]
[/#macro]

[#--                        --]
[#-- CMIS Allowable Actions --]
[#--                        --]
[#macro allowableactions node ns=""]
	<cmis_allowableActions[#if ns != ""] ${ns}[/#if]>
		[#nested]
		[#assign typedef = cmistype(node)]
		[#list typedef.actionEvaluators?values as actionevaluator]
		  [@allowableaction node actionevaluator/]
		[/#list]
	</cmis_allowableActions>
[/#macro]

[#macro allowableaction node actionevaluator]
	<cmis_${actionevaluator.action.label}>${actionevaluator.isAllowed(node.nodeRef)?string}</cmis_${actionevaluator.action.label}>
[/#macro]

[#macro assocallowableactions assoc ns=""]
	<cmis_allowableActions[#if ns != ""] ${ns}[/#if]>
		[#nested]
		[#assign typedef = cmistype(assoc)]
		[#list typedef.actionEvaluators?values as actionevaluator]
		  [@assocallowableaction assoc actionevaluator/]
		[/#list]
	</cmis_allowableActions>
[/#macro]

[#macro assocallowableaction assoc actionevaluator]
	<cmis_${actionevaluator.action.label}>${actionevaluator.isAllowed(assoc.associationRef)?string}</cmis_${actionevaluator.action.label}>
[/#macro]

[#-- Helper to render atom content element --]
[#macro contentstream node]<content [#if node.mimetype??]type="${node.mimetype}"[/#if]>[@linksLib.contenturi node/]</content>[/#macro]
