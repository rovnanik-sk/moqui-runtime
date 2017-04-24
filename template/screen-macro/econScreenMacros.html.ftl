<#include "rskScreenMacros.html.ftl"/>

<#macro "econ-docs-tags-display">
				<#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>

    <#switch fieldValue?lower_case>
								<#case "invoicesales">
												<h5><span class="label label-default">fa</span></h6>
    								<#break>
    				<#case "invoiceproforma">
    								<h5><span class="label label-info">zál</span></h6>
    								<#break>
    				<#case "invoicereturn">
												<h5><span class="label label-warning">dob</span></h6>
												<#break>
    				<#default>
    								<#break>
    </#switch>
</#macro>

<#macro "econ-general-docs-tags-display">
				<#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>

    <#switch fieldValue?lower_case>
								<#case "cashwithdrawal">
												<h5><span class="label label-default">hotovosť</span></h6>
    								<#break>
    				<#case "prescription">
    								<h5><span class="label label-info">predpis</span></h6>
    								<#break>
    				<#case "cardpayment">
												<h5><span class="label label-default">karta</span></h6>
												<#break>
    				<#default>
    								<#break>
    </#switch>
</#macro>

<#macro "company-id-tags-display">
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <#assign limitLength = .node["@limit-length"]!"12">
    <#assign maxTags = .node["@max-tags"]!"6">
    <#assign defMoreSign = .node["@default-more-sign"]!"...">
    <#assign defLongerSign = .node["@default-longer-sign"]!"..">
    <#assign defLabelType = .node["@label-type"]!"label-info">
    <#assign mapName = .node["@map-name"]!"">
    <#if ec.getContext().containsKey(mapName)>
								<#assign mapObject = context[mapName]>
								<#list mapObject.entrySet() as entry>
												<#if entry?counter &lt;= maxTags?number>
																<span class="label ${defLabelType}" data-toggle="tooltip" title="${entry.value?html}"><#if entry.value?length gt limitLength?number>${entry.key?html}: ${entry.value[0..*limitLength?number]?trim}${defLongerSign}<#else>${entry.key?html}: ${entry.value?trim}</#if></span>
																<#if entry?counter == maxTags?number && !entry?is_last>
																				<span class="label label-warning">${defMoreSign}</span>
																</#if>
												</#if>
								</#list>
				</#if>
</#macro>

<#macro "contact-info-display">
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <#assign maxTags = .node["@max-tags"]!"6">
    <#assign mapName = .node["@map-name"]!"">
    <#assign mapObject = context[mapName]>
    <#assign defMoreSign = .node["@default-more-sign"]!"...">
				<#if ec.getContext().containsKey(mapName)>
								<#assign mapObject = context[mapName]>
								<#list mapObject.entrySet() as entry>
												<#if entry?counter &lt;= maxTags?number>
																<div><span>${entry.value} (${entry.key})</span></div>
																<#if entry?counter == maxTags?number && !entry?is_last>
																				<span class="label label-warning">${defMoreSign}</span>
																</#if>
												</#if>
								</#list>
				</#if>
</#macro>