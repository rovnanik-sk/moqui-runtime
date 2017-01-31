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

<#macro "text-find">
				<span class="form-text-find">
								<#assign defaultOperator = .node["@default-operator"]!"contains">
								<#assign placeholderText = .node["@placeholder"]!"">
								<#assign curFieldName><@fieldName .node/></#assign>
								<#if .node["@hide-options"]! == "true" || .node["@hide-options"]! == "operator">
												<input type="hidden" name="${curFieldName}_op" value="${defaultOperator}">
								<#else>
												<span><input type="checkbox" class="form-control" placeholder="${placeholderText?html}" name="${curFieldName}_not" value="Y"<#if ec.getWeb().parameters.get(curFieldName + "_not")! == "Y"> checked="checked"</#if>>&nbsp;${ec.getL10n().localize("Not")}</span>
												<select name="${curFieldName}_op" class="form-control">
																<option value="equals"<#if defaultOperator == "equals"> selected="selected"</#if>>${ec.getL10n().localize("Equals")}</option>
																<option value="like"<#if defaultOperator == "like"> selected="selected"</#if>>${ec.getL10n().localize("Like")}</option>
																<option value="contains"<#if defaultOperator == "contains"> selected="selected"</#if>>${ec.getL10n().localize("Contains")}</option>
																<option value="begins"<#if defaultOperator == "begins"> selected="selected"</#if>>${ec.getL10n().localize("Begins With")}</option>
																<option value="empty"<#rt/><#if defaultOperator == "empty"> selected="selected"</#if>>${ec.getL10n().localize("Empty")}</option>
												</select>
								</#if>
								<input type="text" class="form-control" placeholder="${placeholderText?html}" name="${curFieldName}" value="${sri.getFieldValueString(.node)?html}" size="${.node.@size!"30"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if> id="<@fieldId .node/>"<#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if>>
								<#assign ignoreCase = (ec.getWeb().parameters.get(curFieldName + "_ic")! == "Y") || !(.node["@ignore-case"]?has_content) || (.node["ignore-case"] == "true")>
								<#if .node["@hide-options"]! == "true" || .node["@hide-options"]! == "ignore-case">
												<input type="hidden" name="${curFieldName}_ic" value="Y"<#if ignoreCase> checked="checked"</#if>>
								<#else>
												<span><input type="checkbox" class="form-control" placeholder="${placeholderText?html}" name="${curFieldName}_ic" value="Y"<#if ignoreCase> checked="checked"</#if>>&nbsp;${ec.getL10n().localize("Ignore Case")}</span>
								</#if>
				</span>
</#macro>

<#macro display>
    <#assign dispFieldId><@fieldId .node/></#assign>
    <#assign dispFieldNode = .node?parent?parent>
    <#assign dispAlign = dispFieldNode["@align"]!"left">
    <#assign dispHidden = (!.node["@also-hidden"]?has_content || .node["@also-hidden"] == "true") && !(skipForm!false)>
    <#assign fieldValue = "">
    <#assign fieldClass = sri.getFieldValueClass(dispFieldNode)>
    <#if .node["@hide-current-year"]?has_content><#assign hideCurrYear = .node["@hide-current-year"]?boolean><#else><#assign hideCurrYear = false></#if>
    <#if .node["@text"]?has_content>
        <#assign textMap = "">
        <#if .node["@text-map"]?has_content><#assign textMap = ec.getResource().expression(.node["@text-map"], "")!></#if>
        <#if textMap?has_content>
            <#assign fieldValue = ec.getResource().expand(.node["@text"], "", textMap)>
        <#else>
            <#assign fieldValue = ec.getResource().expand(.node["@text"], "")>
        </#if>
        <#if .node["@currency-unit-field"]?has_content>
            <#assign fieldValue = ec.getL10n().formatCurrency(fieldValue, ec.getResource().expression(.node["@currency-unit-field"], ""))>
        </#if>
    <#elseif .node["@currency-unit-field"]?has_content>
        <#assign fieldValue = ec.getL10n().formatCurrency(sri.getFieldValue(dispFieldNode, ""), ec.getResource().expression(.node["@currency-unit-field"], ""))>
    <#else>
        <#assign fieldValue = sri.getFieldValueString(.node)>
    </#if>
    <#if fieldClass== "Timestamp" && fieldValue?has_content && hideCurrYear>
    				<#if fieldValue?date["dd.MM.yyyy"]?string.yyyy == .now?date?string.yyyy>
    								<#assign fieldValue = fieldValue?date["dd.MM.yyyy"]?string["dd.MM."]>
    				</#if>
    </#if>
    <#t><span id="${dispFieldId}_display" class="${fieldClass}<#if .node["@currency-unit-field"]?has_content> currency</#if><#if dispAlign == "center"> text-center<#elseif dispAlign == "right"> text-right</#if>">
    <#t><#if fieldValue?has_content><#if .node["@encode"]! == "false">${fieldValue}<#else>${fieldValue?html?replace("\n", "<br>")}</#if><#else>&nbsp;</#if>
    <#t></span>
    <#t><#if dispHidden>
        <#-- use getFieldValuePlainString() and not getFieldValueString() so we don't do timezone conversions, etc -->
        <#-- don't default to fieldValue for the hidden input value, will only be different from the entry value if @text is used, and we don't want that in the hidden value -->
        <input type="hidden" id="${dispFieldId}" name="<@fieldName .node/>" value="${sri.getFieldValuePlainString(dispFieldNode, "")?html}">
    </#if>
    <#if .node["@dynamic-transition"]?has_content>
        <#assign defUrlInfo = sri.makeUrlByType(.node["@dynamic-transition"], "transition", .node, "false")>
        <#assign defUrlParameterMap = defUrlInfo.getParameterMap()>
        <#assign depNodeList = .node["depends-on"]>
        <script>
            function populate_${dispFieldId}() {
                var hasAllParms = true;
                <#list depNodeList as depNode>if (!$('#<@fieldIdByName depNode["@field"]/>').val()) { hasAllParms = false; } </#list>
                if (!hasAllParms) { <#-- alert("not has all parms"); --> return; }
                $.ajax({ type:"POST", url:"${defUrlInfo.url}", data:{ moquiSessionToken: "${(ec.getWeb().sessionToken)!}"<#rt>
                    <#t><#list depNodeList as depNode><#local depNodeField = depNode["@field"]><#local _void = defUrlParameterMap.remove(depNodeField)!>, "${depNode["@parameter"]!depNodeField}": $("#<@fieldIdByName depNodeField/>").val()</#list>
                    <#t><#list defUrlParameterMap?keys as parameterKey><#if defUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${defUrlParameterMap.get(parameterKey)}"</#if></#list>
                    <#t>}, dataType:"text" }).done( function(defaultText) { if (defaultText) { $('#${dispFieldId}_display').html(defaultText); <#if dispHidden>$('#${dispFieldId}').val(defaultText);</#if> } } );
            }
            <#list depNodeList as depNode>
            $("#<@fieldIdByName depNode["@field"]/>").on('change', function() { populate_${dispFieldId}(); });
            </#list>
            populate_${dispFieldId}();
        </script>
    </#if>
</#macro>