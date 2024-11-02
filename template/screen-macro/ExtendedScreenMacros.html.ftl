<#include "DefaultScreenMacros.html.ftl"/>

<#macro "text-line">
				<#assign tlSubFieldNode = .node?parent>
				<#assign tlFieldNode = tlSubFieldNode?parent>
				<#assign id><@fieldId .node/></#assign>
				<#assign name><@fieldName .node/></#assign>
<#-- <#assign fieldValue = sri.getFieldValueString(.node)> -->
				<#assign fieldValue = sri.getFieldValueStringUS(.node)>
				<#assign validationClasses = formInstance.getFieldValidationClasses(tlFieldNode["@name"])>
				<#assign regexpInfo = formInstance.getFieldValidationRegexpInfo(tlFieldNode["@name"])!>
				<#assign forceNumberClass = .node["@force-number-class"]! == "true">
				<#if validationClasses?contains("number") || forceNumberClass><#assign fieldValue = fieldValue?replace(",", "")></#if>
				<#if .node["@ac-transition"]?has_content>
								<#assign acUrlInfo = sri.makeUrlByType(.node["@ac-transition"], "transition", .node, "false")>
								<#assign acUrlParameterMap = acUrlInfo.getParameterMap()>
								<#assign acShowValue = .node["@ac-show-value"]! == "true">
								<#assign acUseActual = .node["@ac-use-actual"]! == "true">
								<#if .node["@ac-initial-text"]?has_content><#assign valueText = ec.getResource().expand(.node["@ac-initial-text"]!, "")>
								<#else><#assign valueText = fieldValue></#if>
								<#t><input id="${id}_ac" type="<#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#else>text</#if>"
            <#t> name="${name}_ac" value="${valueText?html}" size="${.node.@size!"30"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
            <#t><#if ec.getResource().condition(.node.@disabled!"false", "")> disabled="disabled"</#if>
            <#t> class="form-control typeahead<#if validationClasses?has_content> ${validationClasses}</#if>"<#if validationClasses?contains("required")> required</#if>
            <#t><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}" data-msg-pattern="${regexpInfo.message!"Invalid format"}"</#if>
            <#t><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if> autocomplete="off"<#if ownerForm?has_content> form="${ownerForm}"</#if>>
        <input id="${id}" type="hidden" name="${name}" value="${fieldValue?html}"<#if ownerForm?has_content> form="${ownerForm}"</#if>>
								<#if acShowValue><span id="${id}_value" class="form-autocomplete-value"><#if valueText?has_content>${valueText?html}<#else>&nbsp;</#if></span></#if>
								<#assign depNodeList = .node["depends-on"]>
        <script>
            $("#${id}_ac").typeahead({ <#if .node["@ac-min-length"]?has_content>minLength: ${.node["@ac-min-length"]},</#if> highlight: true, hint: false }, { limit: 99,
                source: moqui.debounce(function(query, syncResults, asyncResults) { $.ajax({
                    url: "${acUrlInfo.url}", type: "POST", dataType: "json", data: { term: query, moquiSessionToken: "${(ec.getWeb().sessionToken)!}"<#rt>
                        <#t><#list depNodeList as depNode><#local depNodeField = depNode["@field"]><#local _void = acUrlParameterMap.remove(depNodeField)!>, '${depNode["@parameter"]!depNodeField}': $('#<@fieldIdByName depNodeField/>').val()</#list>
                        <#t><#list acUrlParameterMap.keySet() as parameterKey><#if acUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${acUrlParameterMap.get(parameterKey)}"</#if></#list> },
                    success: function(data) { var list = moqui.isArray(data) ? data : data.options; asyncResults($.map(list, function(item) { return { label: item.label, value: item.value } })); }
                }); }, <#if .node["@ac-delay"]?has_content>${.node["@ac-delay"]}<#else>300</#if>),
                display: function(item) { return item.label; }
            });
            $("#${id}_ac").bind('typeahead:select', function(event, item) {
                if (item) { this.value = item.value; $("#${id}").val(item.value); $("#${id}").trigger("change"); $("#${id}_ac").val(item.label);<#if acShowValue> if (item.label) { $("#${id}_value").html(item.label); }</#if> return false; }
            });

            $("#${id}_ac").change(function() { if (!$("#${id}_ac").val()) { $("#${id}").val(""); $("#${id}").trigger("change"); }<#if acUseActual> else { $("#${id}").val($("#${id}_ac").val()); $("#${id}").trigger("change"); }</#if> });
            <#list depNodeList as depNode>
                $("#<@fieldIdByName depNode["@field"]/>").change(function() { $("#${id}").val(""); $("#${id}_ac").val(""); });
												</#list>
            <#if !.node["@ac-initial-text"]?has_content>
            /* load the initial value if there is one */
            if ($("#${id}").val()) {
                $.ajax({ url: "${acUrlInfo.url}", type: "POST", dataType: "json", data: { term: $("#${id}").val(), moquiSessionToken: "${(ec.getWeb().sessionToken)!}"<#list acUrlParameterMap.keySet() as parameterKey><#if acUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${acUrlParameterMap.get(parameterKey)}"</#if></#list> },
                    success: function(data) {
                        var list = moqui.isArray(data) ? data : data.options;
                        var curValue = $("#${id}").val();
                        for (var i = 0; i < list.length; i++) { if (list[i].value == curValue) { $("#${id}_ac").val(list[i].label); <#if acShowValue>$("#${id}_value").html(list[i].label);</#if> break; } }
																				<#-- don't do this by default if we haven't found a valid one: if (list && list[0].label) { $("#${id}_ac").val(list[0].label); <#if acShowValue>$("#${id}_value").html(list[0].label);</#if> } -->
                    }
                });
            }
												</#if>
        </script>
				<#else>
								<#assign tlAlign = tlFieldNode["@align"]!"left">
								<#t><input id="${id}" type="<#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#elseif validationClasses?contains("number") || forceNumberClass>number<#else>text</#if>"
        <#t><#if validationClasses?contains("number") || forceNumberClass> pattern="[0-9]+([\,|\.][0-9]+)?" step="any"</#if>
        <#t> name="${name}" value="${fieldValue?html}" <#if .node.@size?has_content>size="${.node.@size}"<#else>style="width:100%;"</#if><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
        <#t><#if ec.getResource().condition(.node.@disabled!"false", "")> disabled="disabled"</#if>
        <#t> class="form-control<#if validationClasses?has_content> ${validationClasses}</#if><#if tlAlign == "center"> text-center<#elseif tlAlign == "right"> text-right</#if>"
        <#t><#if validationClasses?contains("required")> required</#if><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}" data-msg-pattern="${regexpInfo.message!"Invalid format"}"</#if>
        <#t><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if><#if ownerForm?has_content> form="${ownerForm}"</#if>>
								<#assign expandedMask = ec.getResource().expand(.node["@mask"], "")!>
								<#if expandedMask?has_content><script>$('#${id}').inputmask("${expandedMask}");</script></#if>
								<#if .node["@default-transition"]?has_content>
												<#assign defUrlInfo = sri.makeUrlByType(.node["@default-transition"], "transition", .node, "false")>
												<#assign defUrlParameterMap = defUrlInfo.getParameterMap()>
												<#assign depNodeList = .node["depends-on"]>
            <script>
                function populate_${id}() {
                    // if ($('#${id}').val()) return;
                    var hasAllParms = true;
                    <#list depNodeList as depNode>if (!$('#<@fieldIdByName depNode["@field"]/>').val()) { hasAllParms = false; } </#list>
                    if (!hasAllParms) { <#-- alert("not has all parms"); --> return; }
                    $.ajax({ type:"POST", url:"${defUrlInfo.url}", data:{ moquiSessionToken: "${(ec.getWeb().sessionToken)!}"<#rt>
                            <#t><#list depNodeList as depNode><#local depNodeField = depNode["@field"]><#local _void = defUrlParameterMap.remove(depNodeField)!>, "${depNode["@parameter"]!depNodeField}": $("#<@fieldIdByName depNodeField/>").val()</#list>
                            <#t><#list defUrlParameterMap.keySet() as parameterKey><#if defUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${defUrlParameterMap.get(parameterKey)}"</#if></#list>
                            <#t>}, dataType:"text", success:function(defaultText) {   $('#${id}').val(defaultText);  } });
                }
                <#list depNodeList as depNode>
                $("#<@fieldIdByName depNode["@field"]/>").on('change', function() { populate_${id}(); });
																</#list>
                populate_${id}();
            </script>
								</#if>
				</#if>
</#macro>