<#include "DefaultScreenMacros.html.ftl"/>

<#macro file><input type="file" class="form-control" name="<@fieldName .node/>"<#if .node["@allowMultiple"]! == "true"> multiple="multiple"</#if> value="${sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", null)?html}" size="${.node.@size!"30"}"<#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if>></#macro>

<#macro "bootstrap-tagsinput">
     <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
     <#assign id><@fieldId .node/></#assign>
     <input id=${id}
         type="text"
         class="form-control"
         data-role="tagsinput"
         value="${fieldValue?html}"
         name="<@fieldName .node/>"
         size="${.node.@size!"1"}"
     />
 </#macro>

<#macro "bootstrap-tagsinput-typeahead">
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <#assign id><@fieldId .node/></#assign>
    <input id=${id}
        type="text"
        class="form-control"
        data-role="tagsinput"
        value="${fieldValue?html}"
        name="<@fieldName .node/>"
        size="${.node.@size!"1"}"
    />
    <script>
        var engine = new Bloodhound({
            datumTokenizer: function (datum) {
                return Bloodhound.tokenizers.whitespace(datum.name);
            },
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            remote: {
                url: "${sri.buildUrl('${.node["@fetch-transition-name"]!"getTagsInUse"}').url}",
                filter: function (data) {
                    console.log("data", data.tags)
                    return $.map(data.tags, function (tag) {
                        return {
                            name: tag.tag
                        };
                    });
                }
            }
        });
        engine.initialize();

        $("input[id='${id}']").tagsinput({
            typeaheadjs: {
                name: 'engine',
                displayKey: 'name',
                valueKey: 'name',
                source: engine.ttAdapter(),
                limit: 8
            }
        });

        $('.bootstrap-tagsinput').focusin(function() {
            $(this).addClass('focus');
        });
        $('.bootstrap-tagsinput').focusout(function() {
            $(this).removeClass('focus');
        });
    </script>
</#macro>

<#macro "tags-display">
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <#assign limitLength = .node["@limit-length"]!"12">
    <#assign maxTags = .node["@max-tags"]!"6">
    <#assign defMoreSign = .node["@default-more-sign"]!"...">
    <#assign defLongerSign = .node["@default-longer-sign"]!"..">
    <#assign defLabelType = .node["@label-type"]!"label-info">
    <#list fieldValue?split(",") as singleValue>
        <#if singleValue?counter &lt;= maxTags?number>
            <span class="label ${defLabelType}"><#if singleValue?length gte limitLength?number>${singleValue[0..*limitLength?number]?trim}${defLongerSign}<#else>${singleValue?trim}</#if></span>
            <#if singleValue?counter == maxTags?number && !singleValue?is_last>
                <span class="label label-warning">${defMoreSign}</span>
            </#if>
        </#if>
    </#list>
</#macro>

<#macro "tags-display-for-arrays">
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <#assign limitLength = .node["@limit-length"]!"12">
    <#assign maxTags = .node["@max-tags"]!"6">
    <#assign defMoreSign = .node["@default-more-sign"]!"...">
    <#assign defLongerSign = .node["@default-longer-sign"]!"..">
    <#assign defLabelType = .node["@label-type"]!"label-info">
    <#assign listName = .node["@list-name"]!"">
    <#if ec.getContext().containsKey(listName)>
    				<#assign listObject = context[listName]>
								<#if listObject?has_content>
												<#list listObject as singleValue>
																<#if singleValue?counter &lt;= maxTags?number>
																				<span class="label ${defLabelType}" data-toggle="tooltip" title="${singleValue?html}"><#if singleValue?length gte limitLength?number>${singleValue[0..*limitLength?number]?trim}${defLongerSign}<#else>${singleValue?trim}</#if></span>
																				<#if singleValue?counter == maxTags?number && !singleValue?is_last>
																								<span class="label label-warning">${defMoreSign}</span>
																				</#if>
																</#if>
												</#list>
								</#if>
    </#if>
</#macro>

<#macro "file-tags-display">
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <#list fieldValue?split(",") as singleValue>
        <#if singleValue?counter &lt; 4>
        				<#if singleValue=='none'>
        								<span class="label label-danger"><#if singleValue?length gt 4>${singleValue[0..*4]?trim}..<#else>${singleValue?trim}</#if></span>
        				<#else>
        									<span class="label label-info"><#if singleValue?length gt 4>${singleValue[0..*4]?trim}..<#else>${singleValue?trim}</#if></span>
        				</#if>
            <#if singleValue?counter == 3 && !singleValue?is_last>
                <span class="label label-warning">...</span>
            </#if>
        </#if>
    </#list>
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

<#macro paginationHeader formListInfo formId isHeaderDialog>
    <#assign formNode = formListInfo.getFormNode()>
    <#assign mainColInfoList = formListInfo.getMainColInfo()>
    <#assign numColumns = (mainColInfoList?size)!100>
    <#if numColumns == 0><#assign numColumns = 100></#if>
    <#assign isSavedFinds = formNode["@saved-finds"]! == "true">
    <#assign isSelectColumns = formNode["@select-columns"]! == "true">
    <#assign isPaginated = !(formNode["@paginate"]! == "false") && context[listName + "Count"]?? && (context[listName + "Count"]! > 0) &&
            (!formNode["@paginate-always-show"]?has_content || formNode["@paginate-always-show"]! == "true" || (context[listName + "PageMaxIndex"] > 0))>
    <#if (isHeaderDialog || isSavedFinds || isSelectColumns || isPaginated) && hideNav! != "true">
        <tr class="form-list-nav-row"><th colspan="${numColumns}">
        <nav class="form-list-nav">
            <#if isSavedFinds>
                <#assign userFindInfoList = formListInfo.getUserFormListFinds(ec)>
                <#if userFindInfoList?has_content>
                    <#assign quickSavedFindId = formId + "_QuickSavedFind">
                    <select id="${quickSavedFindId}">
                        <option></option><#-- empty option for placeholder -->
                        <option value="_clear" data-action="${sri.getScreenUrlInstance().url}">${ec.getL10n().localize("Clear Current Find")}</option>
                        <#list userFindInfoList as userFindInfo>
                            <#assign formListFind = userFindInfo.formListFind>
                            <#assign findParameters = userFindInfo.findParameters>
                            <#assign doFindUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameters(findParameters).removeParameter("pageIndex").removeParameter("moquiFormName").removeParameter("moquiSessionToken")>
                            <option value="${formListFind.formListFindId}"<#if formListFind.formListFindId == ec.getContext().formListFindId!> selected="selected"</#if> data-action="${doFindUrl.urlWithParams}">${userFindInfo.description?html}</option>
                        </#list>
                    </select>
                    <script>
                        $("#${quickSavedFindId}").select2({ placeholder:'${ec.getL10n().localize("Saved Finds")}' });
                        $("#${quickSavedFindId}").on('select2:select', function(evt) {
                            var dataAction = $(evt.params.data.element).attr("data-action");
                            if (dataAction) window.open(dataAction, "_self");
                        } );
                    </script>
                </#if>
            </#if>
            <#if isSavedFinds || isHeaderDialog><button id="${headerFormDialogId}_button" type="button" data-toggle="modal" data-target="#${headerFormDialogId}" data-original-title="${headerFormButtonText}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${headerFormButtonText}</button></#if>
            <#if isSelectColumns><button id="${selectColumnsDialogId}_button" type="button" data-toggle="modal" data-target="#${selectColumnsDialogId}" data-original-title="${ec.getL10n().localize("Columns")}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${ec.getL10n().localize("Columns")}</button></#if>

            <#if isPaginated>
                <#assign curPageIndex = context[listName + "PageIndex"]>
                <#assign curPageMaxIndex = context[listName + "PageMaxIndex"]>
                <#assign prevPageIndexMin = curPageIndex - 3><#if (prevPageIndexMin < 0)><#assign prevPageIndexMin = 0></#if>
                <#assign prevPageIndexMax = curPageIndex - 1><#assign nextPageIndexMin = curPageIndex + 1>
                <#assign nextPageIndexMax = curPageIndex + 3><#if (nextPageIndexMax > curPageMaxIndex)><#assign nextPageIndexMax = curPageMaxIndex></#if>
                <ul class="pagination">
                <#if (curPageIndex > 0)>
                    <#assign firstUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", 0)>
                    <#assign previousUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", (curPageIndex - 1))>
                    <li><a href="${firstUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-fast-backward"></i></a></li>
                    <li><a href="${previousUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-backward"></i></a></li>
                <#else>
                    <li><span><i class="glyphicon glyphicon-fast-backward"></i></span></li>
                    <li><span><i class="glyphicon glyphicon-backward"></i></span></li>
                </#if>

                <#if (prevPageIndexMax >= 0)><#list prevPageIndexMin..prevPageIndexMax as pageLinkIndex>
                    <#assign pageLinkUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", pageLinkIndex)>
                    <li><a href="${pageLinkUrlInfo.getUrlWithParams()}">${pageLinkIndex + 1}</a></li>
                </#list></#if>
                <#assign paginationTemplate = ec.getL10n().localize("PaginationTemplate")?interpret>
                <li><a href="${sri.getScreenUrlInstance().getUrlWithParams()}"><@paginationTemplate /></a></li>

                <#if (nextPageIndexMin <= curPageMaxIndex)><#list nextPageIndexMin..nextPageIndexMax as pageLinkIndex>
                    <#assign pageLinkUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", pageLinkIndex)>
                    <li><a href="${pageLinkUrlInfo.getUrlWithParams()}">${pageLinkIndex + 1}</a></li>
                </#list></#if>

                <#if (curPageIndex < curPageMaxIndex)>
                    <#assign lastUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", curPageMaxIndex)>
                    <#assign nextUrlInfo = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageIndex", curPageIndex + 1)>
                    <li><a href="${nextUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-forward"></i></a></li>
                    <li><a href="${lastUrlInfo.getUrlWithParams()}"><i class="glyphicon glyphicon-fast-forward"></i></a></li>
                <#else>
                    <li><span><i class="glyphicon glyphicon-forward"></i></span></li>
                    <li><span><i class="glyphicon glyphicon-fast-forward"></i></span></li>
                </#if>
                </ul>
                <#if (curPageMaxIndex > 4)>
                    <#assign goPageUrl = sri.getScreenUrlInstance().cloneUrlInstance().removeParameter("pageIndex").removeParameter("moquiFormName").removeParameter("moquiSessionToken")>
                    <#assign goPageUrlParms = goPageUrl.getParameterMap()>
                    <form class="form-inline" id="${formId}_GoPage" method="post" action="${goPageUrl.getUrl()}">
                        <#list goPageUrlParms.keySet() as parmName>
                            <input type="hidden" name="${parmName}" value="${goPageUrlParms.get(parmName)!?html}"></#list>
                        <div class="form-group">
                            <label class="sr-only" for="${formId}_GoPage_pageIndex">Page Number</label>
                            <input type="text" class="form-control" size="6" name="pageIndex" id="${formId}_GoPage_pageIndex" placeholder="${ec.getL10n().localize("Page #")}">
                        </div>
                        <button type="submit" class="btn btn-default">${ec.getL10n().localize("Go##Page")}</button>
                    </form>
                    <script>
                        $("#${formId}_GoPage").validate({ errorClass: 'help-block', errorElement: 'span',
                            rules: { pageIndex: { required:true, min:1, max:${(curPageMaxIndex + 1)?c} } },
                            highlight: function(element, errorClass, validClass) { $(element).parents('.form-group').removeClass('has-success').addClass('has-error'); },
                            unhighlight: function(element, errorClass, validClass) { $(element).parents('.form-group').removeClass('has-error').addClass('has-success'); },
                            <#-- show 1-based index to user but server expects 0-based index -->
                            submitHandler: function(form) { $("#${formId}_GoPage_pageIndex").val($("#${formId}_GoPage_pageIndex").val() - 1); form.submit(); }
                        });
                    </script>
                </#if>
                <#if formNode["@show-all-button"]! == "true" && (context[listName + 'Count'] < 500)>
                    <#if context["pageNoLimit"]?has_content>
                        <#assign allLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().removeParameter("pageNoLimit")>
                        <a href="${allLinkUrl.getUrlWithParams()}" class="btn btn-default">Paginate</a>
                    <#else>
                        <#assign allLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("pageNoLimit", "true")>
                        <a href="${allLinkUrl.getUrlWithParams()}" class="btn btn-default">Show All</a>
                    </#if>
                </#if>
            </#if>

												<form class="form-inline">
																<div class="btn-group">
																				<#if formNode["@show-csv-button"]! == "true">
																								<#assign csvLinkUrl = sri.getScreenUrlInstance().cloneUrlInstance().addParameter("renderMode", "csv")
																																.addParameter("pageNoLimit", "true").addParameter("lastStandalone", "true").addParameter("saveFilename", formNode["@name"] + ".csv")>
																								<a href="${csvLinkUrl.getUrlWithParams()}" class="btn btn-default">${ec.getL10n().localize("CSV")}</a>
																				</#if>
																				<#if formNode["@show-text-button"]! == "true">
																								<#assign showTextDialogId = formId + "_TextDialog">
																								<button id="${showTextDialogId}_button" type="button" data-toggle="modal" data-target="#${showTextDialogId}" data-original-title="${ec.getL10n().localize("Text")}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${ec.getL10n().localize("Text")}</button>
																				</#if>
																				<#if formNode["@show-pdf-button"]! == "true">
																								<#assign showPdfDialogId = formId + "_PdfDialog">
																								<button id="${showPdfDialogId}_button" type="button" data-toggle="modal" data-target="#${showPdfDialogId}" data-original-title="${ec.getL10n().localize("PDF")}" data-placement="bottom" class="btn btn-default"><i class="glyphicon glyphicon-share"></i> ${ec.getL10n().localize("PDF")}</button>
																				</#if>
																				<#if .node["@button-content-to-display"]! == "true">
																								<input id="InvoiceList_TotalsDisplay_input" type="text" class="btn btn-primary disabled" name="totalsDisplay_input" value=""/>
																				</#if>
																</div>
												</form>
        </nav>
        </th></tr>
    </#if>
</#macro>
