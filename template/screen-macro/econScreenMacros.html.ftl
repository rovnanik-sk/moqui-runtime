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