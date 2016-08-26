<#include "DefaultScreenMacros.html.ftl"/>

<#macro "text-line">
    <#assign id><@fieldId .node/></#assign>
    <#assign name><@fieldName .node/></#assign>
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <#assign formInstance = sri.getFormInstance(.node?parent?parent?parent["@name"])>
    <#assign validationClasses = formInstance.getFieldValidationClasses(.node?parent?parent["@name"])>
    <#assign regexpInfo = formInstance.getFieldValidationRegexpInfo(.node?parent?parent["@name"])!>
    <#assign isAutoComplete = .node["@ac-transition"]?has_content>
	<#assign placeholderDefault = "">
    <#-- NOTE: removed number type (<#elseif validationClasses?contains("number")>number) because on Safari, maybe others, ignores size and behaves funny for decimal values -->
    <#if isAutoComplete>
        <#assign acUrlInfo = sri.makeUrlByType(.node["@ac-transition"], "transition", .node, "false")>
        <#assign acUrlParameterMap = acUrlInfo.getParameterMap()>
        <#assign acShowValue = .node["@ac-show-value"]! == "true">
        <#assign acUseActual = .node["@ac-use-actual"]! == "true">
        <#if .node["@ac-initial-text"]?has_content><#assign valueText = ec.resource.expand(.node["@ac-initial-text"]!, "")>
            <#else><#assign valueText = fieldValue></#if>
        <input id="${id}_ac" type="<#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#else>text</#if>" name="${name}_ac" value="${valueText?html}" size="${.node.@size!"30"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if><#if ec.resource.condition(.node.@disabled!"false", "")> disabled="disabled"</#if> class="form-control<#if validationClasses?has_content> ${validationClasses}</#if>"<#if validationClasses?has_content> data-vv-validations="${validationClasses}"</#if><#if validationClasses?contains("required")> required</#if><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}"</#if><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.resource.expand(.node?parent["@tooltip"], "")}"</#if> autocomplete="off">
        <input id="${id}" type="hidden" name="${name}" value="${fieldValue?html}">
        <#if acShowValue><span id="${id}_value" class="form-autocomplete-value"><#if valueText?has_content>${valueText?html}<#else>&nbsp;</#if></span></#if>
        <#assign depNodeList = .node["depends-on"]>
        <script>
            $("#${id}_ac").autocomplete({
                source: function(request, response) { $.ajax({
                    url: "${acUrlInfo.url}", type: "POST", dataType: "json", data: { term: request.term, moquiSessionToken: "${(ec.web.sessionToken)!}"<#list depNodeList as depNode>, '${depNode["@field"]}': $('#<@fieldIdByName depNode["@field"]/>').val()</#list><#list acUrlParameterMap?keys as parameterKey><#if acUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${acUrlParameterMap.get(parameterKey)}"</#if></#list> },
                    success: function(data) { response($.map(data, function(item) { return { label: item.label, value: item.value } })); }
                }); }, <#if .node["@ac-delay"]?has_content>delay: ${.node["@ac-delay"]},</#if><#if .node["@ac-min-length"]?has_content>minLength: ${.node["@ac-min-length"]},</#if>
                focus: function(event, ui) { $("#${id}").val(ui.item.value); $("#${id}").trigger("change"); $("#${id}_ac").val(ui.item.label); return false; },
                select: function(event, ui) { if (ui.item) { this.value = ui.item.value; $("#${id}").val(ui.item.value); $("#${id}").trigger("change"); $("#${id}_ac").val(ui.item.label);<#if acShowValue> if (ui.item.label) { $("#${id}_value").html(ui.item.label); }</#if> return false; } }
            });
            $("#${id}_ac").change(function() { if (!$("#${id}_ac").val()) { $("#${id}").val(""); $("#${id}").trigger("change"); }<#if acUseActual> else { $("#${id}").val($("#${id}_ac").val()); $("#${id}").trigger("change"); }</#if> });
            <#list depNodeList as depNode>
                $("#<@fieldIdByName depNode["@field"]/>").change(function() { $("#${id}").val(""); $("#${id}_ac").val(""); });
            </#list>
            <#if !.node["@ac-initial-text"]?has_content>
            /* load the initial value if there is one */
            if ($("#${id}").val()) {
                $.ajax({ url: "${acUrlInfo.url}", type: "POST", dataType: "json", data: { term: $("#${id}").val(), moquiSessionToken: "${(ec.web.sessionToken)!}"<#list acUrlParameterMap?keys as parameterKey><#if acUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${acUrlParameterMap.get(parameterKey)}"</#if></#list> },
                    success: function(data) {
                        var curValue = $("#${id}").val();
                        for (var i = 0; i < data.length; i++) { if (data[i].value == curValue) { $("#${id}_ac").val(data[i].label); <#if acShowValue>$("#${id}_value").html(data[i].label);</#if> break; } }
                        <#-- don't do this by default if we haven't found a valid one: if (data && data[0].label) { $("#${id}_ac").val(data[0].label); <#if acShowValue>$("#${id}_value").html(data[0].label);</#if> } -->
                    }
                });
            }
            </#if>
        </script>
    <#else>
		<input id="${id}" type="<#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#else>text</#if>" name="${name}" value="${fieldValue?html}" size="${.node.@size!"30"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if><#if ec.resource.condition(.node.@disabled!"false", "")> disabled="disabled"</#if> class="form-control<#if validationClasses?has_content> ${validationClasses}</#if>"<#if validationClasses?has_content> data-vv-validations="${validationClasses}"</#if><#if validationClasses?contains("required")> required</#if><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}"</#if><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.resource.expand(.node?parent["@tooltip"], "")}"</#if> placeholder="${ec.l10n.localize(.node.@placeholder!placeholderDefault)}">
    </#if>
</#macro>

<#macro "bootstrap-tagsinput">
     <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
     <#assign id><@fieldId .node/></#assign>
         <input id=${id}
             type="text"
             class="form-control"
             data-role="tagsinput"
             value="${fieldValue?html}"
             name="<@fieldName .node/>"
         />
 </#macro>

<#macro display>
    <#assign fieldValue = ""/>
    <#if .node["@text"]?has_content>
        <#assign textMap = "">
        <#if .node["@text-map"]?has_content><#assign textMap = ec.resource.expression(.node["@text-map"], "")!></#if>
        <#if textMap?has_content>
            <#assign fieldValue = ec.resource.expand(.node["@text"], "", textMap)>
        <#else>
            <#assign fieldValue = ec.resource.expand(.node["@text"], "")>
        </#if>
        <#if .node["@currency-unit-field"]?has_content>
            <#assign fieldValue = ec.l10n.formatCurrency(fieldValue, ec.resource.expression(.node["@currency-unit-field"], ""))>
        </#if>
    <#elseif .node["@currency-unit-field"]?has_content>
        <#assign fieldValue = ec.l10n.formatCurrency(sri.getFieldValue(.node?parent?parent, ""), ec.resource.expression(.node["@currency-unit-field"], ""))>
    <#else>
        <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, "", .node["@format"]!)>
    </#if>
    <#t><p id="<@fieldId .node/>_display" class="form-control-static"><#if fieldValue?has_content><#if .node["@encode"]!"true" == "false">${fieldValue}<#else>${fieldValue?html?replace("\n", "<br>")}</#if><#else>&nbsp;</#if></p>
    <#t><#if !.node["@also-hidden"]?has_content || .node["@also-hidden"] == "true">
        <#-- use getFieldValuePlainString() and not getFieldValueString() so we don't do timezone conversions, etc -->
        <#-- don't default to fieldValue for the hidden input value, will only be different from the entry value if @text is used, and we don't want that in the hidden value -->
        <input type="hidden" id="<@fieldId .node/>" name="<@fieldName .node/>" value="${sri.getFieldValuePlainString(.node?parent?parent, "")?html}">
    </#if>
</#macro>

<#macro "display-entity">
    <#assign fieldValue = ""/><#assign fieldValue = sri.getFieldEntityValue(.node)!/>
    <#t><p id="<@fieldId .node/>_display" class="form-control-static"><#if fieldValue?has_content><#if .node["@encode"]!"true" == "false">${fieldValue}<#else>${fieldValue?html?replace("\n", "<br>")}</#if><#else>&nbsp;</#if></p>
    <#-- don't default to fieldValue for the hidden input value, will only be different from the entry value if @text is used, and we don't want that in the hidden value -->
    <#t><#if !.node["@also-hidden"]?has_content || .node["@also-hidden"] == "true"><input type="hidden" id="<@fieldId .node/>" name="<@fieldName .node/>" value="${sri.getFieldValuePlainString(.node?parent?parent, "")?html}"></#if>
</#macro>


 <#macro "form-list">
 <#if sri.doBoundaryComments()><!-- BEGIN form-list[@name=${.node["@name"]}] --></#if>
     <#-- Use the formNode assembled based on other settings instead of the straight one from the file: -->
     <#assign formInstance = sri.getFormInstance(.node["@name"])>
     <#assign formNode = formInstance.getFtlFormNode()>
     <#assign formListColumnList = formInstance.getFormListColumnInfo()>
     <#assign formId>${ec.resource.expand(formNode["@name"], "")}<#if sectionEntryIndex?has_content>_${sectionEntryIndex}</#if></#assign>
     <#assign isMulti = formNode["@multi"]! == "true">
     <#assign skipStart = (formNode["@skip-start"]! == "true")>
     <#assign skipEnd = (formNode["@skip-end"]! == "true")>
     <#assign skipForm = (formNode["@skip-form"]! == "true")>
     <#assign skipHeader = (formNode["@skip-header"]! == "true")>
     <#assign formListUrlInfo = sri.makeUrlByType(formNode["@transition"], "transition", null, "false")>
     <#assign listName = formNode["@list"]>
     <#assign listObject = ec.resource.expression(listName, "")!>

     <#if !skipStart>
         <#assign needHeaderForm = formInstance.isHeaderForm()>
         <#assign isHeaderDialog = needHeaderForm && formNode["@header-dialog"]! == "true">
         <#if !skipHeader><@paginationHeaderModals formInstance formId isHeaderDialog/></#if>
         <@paginationHeader formInstance formId isHeaderDialog/>
         <table class="table table-striped table-hover table-condensed" id="${formId}_table">
         <#if !skipHeader>
             <thead>
                 <#if needHeaderForm>
                     <#assign curUrlInstance = sri.getCurrentScreenUrl()>
                     <#assign headerFormId = formId + "_header">
                     <tr>
                     <form name="${headerFormId}" id="${headerFormId}" method="post" action="${curUrlInstance.url}">
                         <input type="hidden" name="moquiSessionToken" value="${(ec.web.sessionToken)!}">
                         <#if orderByField?has_content><input type="hidden" name="orderByField" value="${orderByField}"></#if>
                         <#assign hiddenFieldList = formInstance.getListHiddenFieldList()>
                         <#list hiddenFieldList as hiddenField><#if hiddenField["header-field"]?has_content><#recurse hiddenField["header-field"][0]/></#if></#list>
                 <#else>
                     <tr>
                 </#if>
                 <#list formListColumnList as columnFieldList>
                     <#-- TODO: how to handle column style? <th<#if fieldListColumn["@style"]?has_content> class="${fieldListColumn["@style"]}"</#if>> -->
                     <th>
                     <#list columnFieldList as fieldNode>
                         <#if !(ec.resource.condition(fieldNode["@hide"]!, "") ||
                                 ((!fieldNode["@hide"]?has_content) && fieldNode?children?size == 1 &&
                                 (fieldNode?children[0]["hidden"]?has_content || fieldNode?children[0]["ignored"]?has_content)))>
                             <div><@formListHeaderField fieldNode isHeaderDialog/></div>
                         </#if>
                     </#list>
                     </th>
                 </#list>
                 <#if needHeaderForm>
                     </form>
                     </tr>
                     <#if _dynamic_container_id?has_content>
                         <#-- if we have an _dynamic_container_id this was loaded in a dynamic-container so init ajaxForm; for examples see http://www.malsup.com/jquery/form/#ajaxForm -->
                         <script>$("#${headerFormId}").ajaxForm({ target: '#${_dynamic_container_id}', <#-- success: activateAllButtons, --> resetForm: false });</script>
                     </#if>
                 <#else>
                     </tr>
                 </#if>
             </thead>
         </#if>
         <#if isMulti && !skipForm>
             <tbody>
             <form name="${formId}" id="${formId}" method="post" action="${formListUrlInfo.url}">
                 <input type="hidden" name="moquiFormName" value="${formNode["@name"]}">
                 <input type="hidden" name="moquiSessionToken" value="${(ec.web.sessionToken)!}">
                 <input type="hidden" name="_isMulti" value="true">
         <#else>
             <tbody>
         </#if>
     </#if>
     <#list listObject! as listEntry>
         <#assign listEntryIndex = listEntry_index>
         <#-- NOTE: the form-list.@list-entry attribute is handled in the ScreenForm class through this call: -->
         ${sri.startFormListRow(formInstance, listEntry, listEntry_index, listEntry_has_next)}
         <#if isMulti || skipForm>
             <tr>
         <#else>
             <tr>
             <form name="${formId}_${listEntryIndex}" id="${formId}_${listEntryIndex}" method="post" action="${formListUrlInfo.url}">
                 <input type="hidden" name="moquiSessionToken" value="${(ec.web.sessionToken)!}">
         </#if>
         <#-- hidden fields -->
         <#assign hiddenFieldList = formInstance.getListHiddenFieldList()>
         <#list hiddenFieldList as hiddenField><@formListSubField hiddenField true false isMulti false/></#list>
         <#-- actual columns -->
         <#list formListColumnList as columnFieldList>
             <#-- TODO: how to handle column style? <td<#if fieldListColumn["@style"]?has_content> class="${fieldListColumn["@style"]}"</#if>> -->
             <td>
             <#list columnFieldList as fieldNode>
                 <@formListSubField fieldNode true false isMulti false/>
             </#list>
             </td>
         </#list>
         <#if isMulti || skipForm>
             </tr>
         <#else>
             <#assign afterFormScript>
                 $("#${formId}_${listEntryIndex}").validate();
             </#assign>
             <#t>${sri.appendToScriptWriter(afterFormScript)}
             </form>
             </tr>
         </#if>
         ${sri.endFormListRow()}
     </#list>
     <#assign listEntryIndex = "">
     ${sri.safeCloseList(listObject)}<#-- if listObject is an EntityListIterator, close it -->
     <#if !skipEnd>
         <#if isMulti && !skipForm>
             <tr><td colspan="${formListColumnList?size}">
                 <#list formNode["field"] as fieldNode><@formListSubField fieldNode false false true true/></#list>
             </td></tr>
             </form>
             </tbody>
         <#else>
             </tbody>
         </#if>
         </table>
     </#if>
     <#if isMulti && !skipStart && !skipForm>
         <#assign afterFormScript>
             $("#${formId}").validate();
             $('#${formId} [data-toggle="tooltip"]').tooltip();
         </#assign>
         <#t>${sri.appendToScriptWriter(afterFormScript)}
     </#if>
     <#if sri.doBoundaryComments()><!-- END   form-list[@name=${.node["@name"]}] --></#if>
 </#macro>

 <#macro "drop-down-onchange">
     <#assign id><@fieldId .node/></#assign>
     <#assign allowMultiple = ec.getResource().expand(.node["@allow-multiple"]!, "") == "true"/>
     <#assign isDynamicOptions = .node["dynamic-options"]?has_content>
     <#assign name><@fieldName .node/></#assign>
     <#assign options = {"":""}/><#assign options = sri.getFieldOptions(.node)/>
     <#assign currentValue = sri.getFieldValueString(.node?parent?parent, "", null)/>
     <#if !currentValue?has_content><#assign currentValue = ec.getResource().expand(.node["@no-current-selected-key"]!, "")/></#if>
     <#if currentValue?starts_with("[")><#assign currentValue = currentValue?substring(1, currentValue?length - 1)?replace(" ", "")></#if>
     <#assign currentValueList = (currentValue?split(","))!>
     <#if (allowMultiple && currentValueList?exists && currentValueList?size > 1)><#assign currentValue=""></#if>
     <#assign currentDescription = (options.get(currentValue))!>
     <#assign optionsHasCurrent = currentDescription?has_content>
     <#assign onChange = ec.getResource().expand(.node["@on-change-function"]!, "")>
     <#if !optionsHasCurrent && .node["@current-description"]?has_content>
         <#assign currentDescription = ec.getResource().expand(.node["@current-description"], "")/></#if>
     <select name="${name}" class="<#if isDynamicOptions>dynamic-options</#if><#if .node["@style"]?has_content> ${ec.getResource().expand(.node["@style"], "")}</#if>" id="${id}"<#if allowMultiple> multiple="multiple"</#if><#if .node["@size"]?has_content> size="${.node["@size"]}"</#if><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if> onchange="${onChange}">
     <#if !allowMultiple>
         <#-- don't add first-in-list or empty option if allowMultiple (can deselect all to be empty, including empty option allows selection of empty which isn't the point) -->
         <#if currentValue?has_content>
             <#if .node["@current"]! == "first-in-list">
                 <option selected="selected" value="${currentValue}"><#if currentDescription?has_content>${currentDescription}<#else>${currentValue}</#if></option><#rt/>
                 <option value="${currentValue}">---</option><#rt/>
             <#elseif !optionsHasCurrent>
                 <option selected="selected" value="${currentValue}"><#if currentDescription?has_content>${currentDescription}<#else>${currentValue}</#if></option><#rt/>
             </#if>
         </#if>
         <#assign allowEmpty = ec.getResource().expand(.node["@allow-empty"]!, "")/>
         <#if (allowEmpty! == "true") || !(options?has_content)>
             <option value="">&nbsp;</option>
         </#if>
     </#if>
     <#if !isDynamicOptions>
         <#list (options.keySet())! as key>
             <#assign isSelected = currentValue?has_content && currentValue == key>
             <#if allowMultiple && currentValueList?has_content><#assign isSelected = currentValueList?seq_contains(key)></#if>
             <option<#if isSelected> selected="selected"</#if> value="${key}">${options.get(key)}</option>
         </#list>
     </#if>
     </select>
     <#-- <span>[${currentValue}]; <#list currentValueList as curValue>[${curValue!''}], </#list></span> -->
     <#if allowMultiple><input type="hidden" id="${id}_op" name="${name}_op" value="in"></#if>
     <#if .node["@combo-box"]! == "true">
         <script>$("#${id}").select2({ tags: true, tokenSeparators:[',',' '], theme:'bootstrap' });</script>
     <#elseif .node["@search"]! != "false">
         <script>$("#${id}").select2({ ${select2DefaultOptions} }); $("#${id}").on("select2:select", function (e) { $("#${id}").select2("open").select2("close"); });</script>
     </#if>
     <#if isDynamicOptions>
         <#assign doNode = .node["dynamic-options"][0]>
         <#assign depNodeList = doNode["depends-on"]>
         <#assign doUrlInfo = sri.makeUrlByType(doNode["@transition"], "transition", .node, "false")>
         <#assign doUrlParameterMap = doUrlInfo.getParameterMap()>
         <script>
             function populate_${id}() {
                 var hasAllParms = true;
                 <#list depNodeList as depNode>if (!$('#<@fieldIdByName depNode["@field"]/>').val()) { hasAllParms = false; } </#list>
                 if (!hasAllParms) { $("#${id}").select2("destroy"); $('#${id}').html(""); $("#${id}").select2({ ${select2DefaultOptions} }); <#-- alert("not has all parms"); --> return; }
                 $.ajax({ type:'POST', url:'${doUrlInfo.url}', data:{ moquiSessionToken: "${(ec.getWeb().sessionToken)!}"<#list depNodeList as depNode>, '${depNode["@field"]}': $('#<@fieldIdByName depNode["@field"]/>').val()</#list><#list doUrlParameterMap?keys as parameterKey><#if doUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${doUrlParameterMap.get(parameterKey)}"</#if></#list> }, dataType:'json' }).done(
                     function(list) {
                         if (list) {
                             $("#${id}").select2("destroy");
                             $('#${id}').html(""); /* clear out the drop-down */
                             <#if allowEmpty! == "true">
                             $('#${id}').append('<option value="">&nbsp;</option>');
                             </#if>
                             $.each(list, function(key, value) {
                                 var optionValue = value["${doNode["@value-field"]!"value"}"];
                                 if (optionValue == "${currentValue}") {
                                     $('#${id}').append("<option selected='selected' value='" + optionValue + "'>" + value["${doNode["@label-field"]!"label"}"] + "</option>");
                                 } else {
                                     $('#${id}').append("<option value='" + optionValue + "'>" + value["${doNode["@label-field"]!"label"}"] + "</option>");
                                 }
                             });
                             $("#${id}").select2({ ${select2DefaultOptions} });
                         }
                     }
                 );
             }
             <#list depNodeList as depNode>
             $("#<@fieldIdByName depNode["@field"]/>").on('change', function() { populate_${id}(); });
             </#list>
             populate_${id}();
         </script>
     </#if>
 </#macro>