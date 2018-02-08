<#include "rskScreenMacros.vuet.ftl"/>

<#macro "position-assignment-tags-display">
    <#assign fieldValue = sri.getFieldValueString(.node?parent?parent, .node["@default-value"]!"", .node["@format"]!)>
    <button id="AddPositionAssignment" type="button" data-toggle="modal" data-target="#AddPositionAssignment" data-partyid="${partyId}" data-candidatefullname="${candidateParty.lastName} ${candidateParty.firstName}" data-original-title="Priraď" data-placement="bottom" class="btn btn-primary btn-sm"><i class="glyphicon glyphicon-plus-sign"></i> Priraď</button>
    <#list fieldValue?split(",") as singleValue>
        <#if singleValue?counter &lt; 4>
            <span class="label label-default"><#if singleValue?length gte 12>${singleValue[0..*12]?trim?upper_case}..<#else>${singleValue?trim?upper_case}</#if></span>
            <#if singleValue?counter == 3 && !singleValue?is_last>
                <span class="label label-warning">...</span>
            </#if>
        </#if>
    </#list>

</#macro>