<#include "DefaultScreenMacros.vuet.ftl"/>

<#--single customized macro-->
<#macro "text-line">
    <#assign tlSubFieldNode = .node?parent>
    <#assign tlFieldNode = tlSubFieldNode?parent>
    <#assign tlId><@fieldId .node/></#assign>
    <#assign name><@fieldName .node/></#assign>
    <#assign fieldValue = sri.getFieldValueStringUS(.node)>
    <#assign validationClasses = formInstance.getFieldValidationClasses(tlSubFieldNode)>
    <#assign regexpInfo = formInstance.getFieldValidationRegexpInfo(tlSubFieldNode)!>
    <#assign forceNumberClass = .node["@force-number-class"]! == "true">
    <#if validationClasses?contains("number") || forceNumberClass><#assign fieldValue = fieldValue?replace(",", "")></#if>
<#-- NOTE: removed number type (<#elseif validationClasses?contains("number")>number) because on Safari, maybe others, ignores size and behaves funny for decimal values -->
    <#if .node["@ac-transition"]?has_content>
        <#assign acUrlInfo = sri.makeUrlByType(.node["@ac-transition"], "transition", .node, "false")>
        <#assign acUrlParameterMap = acUrlInfo.getParameterMap()>
        <#assign acShowValue = .node["@ac-show-value"]! == "true">
        <#assign acUseActual = .node["@ac-use-actual"]! == "true">
        <#if .node["@ac-initial-text"]?has_content><#assign valueText = ec.getResource().expand(.node["@ac-initial-text"]!, "")>
        <#else><#assign valueText = fieldValue></#if>
        <#assign depNodeList = .node["depends-on"]>
        <text-autocomplete id="${tlId}" name="${name}" url="${acUrlInfo.url}" value="${fieldValue?html}" value-text="${valueText?html}"<#rt>
                <#t> type="<#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#else>text</#if>" size="${.node.@size!"30"}"
                <#t><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
                <#t><#if ec.getResource().condition(.node.@disabled!"false", "")> :disabled="true"</#if>
                <#t><#if validationClasses?has_content> validation-classes="${validationClasses}"</#if>
                <#t><#if validationClasses?contains("required")> :required="true"</#if>
                <#t><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}" data-msg-pattern="${regexpInfo.message!"Invalid format"}"</#if>
                <#t><#if .node?parent["@tooltip"]?has_content> tooltip="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if>
                <#t><#if ownerForm?has_content> form="${ownerForm}"</#if>
                <#t><#if .node["@ac-min-length"]?has_content> :min-length="${.node["@ac-min-length"]}"</#if>
                <#t> :depends-on="{<#list depNodeList as depNode><#local depNodeField = depNode["@field"]>'${depNode["@parameter"]!depNodeField}':'<@fieldIdByName depNodeField/>'<#sep>, </#list>}"
                <#t> :ac-parameters="{<#list acUrlParameterMap.keySet() as parameterKey><#if acUrlParameterMap.get(parameterKey)?has_content>'${parameterKey}':'${acUrlParameterMap.get(parameterKey)}', </#if></#list>}"
                <#t><#if .node["@ac-delay"]?has_content> :delay="${.node["@ac-delay"]}"</#if>
                <#t><#if .node["@ac-initial-text"]?has_content> :skip-initial="true"</#if>/>
    <#else>
        <#assign tlAlign = tlFieldNode["@align"]!"left">
        <#t><input id="${tlId}" <#--v-model="fields.${name}"--> type="<#if validationClasses?contains("email")>email<#elseif validationClasses?contains("url")>url<#elseif validationClasses?contains("number") || forceNumberClass>number<#else>text</#if>"
            <#t> name="${name}" <#if fieldValue?html == fieldValue>value="${fieldValue}"<#else>:value="'${fieldValue?html}'|decodeHtml"</#if>
            <#t> <#if .node.@size?has_content>size="${.node.@size}"<#else>style="width:100%;"</#if><#if .node.@maxlength?has_content> maxlength="${.node.@maxlength}"</#if>
            <#t><#if ec.getResource().condition(.node.@disabled!"false", "")> disabled="disabled"</#if>
            <#t> class="form-control<#if validationClasses?has_content> ${validationClasses}</#if><#if tlAlign == "center"> text-center<#elseif tlAlign == "right"> text-right</#if>"
            <#t><#if validationClasses?contains("required")> required</#if><#if regexpInfo?has_content> pattern="${regexpInfo.regexp}" data-msg-pattern="${regexpInfo.message!"Invalid format"}"</#if>
            <#t><#if .node?parent["@tooltip"]?has_content> data-toggle="tooltip" title="${ec.getResource().expand(.node?parent["@tooltip"], "")}"</#if>
            <#t><#if ownerForm?has_content> form="${ownerForm}"</#if>>
        <#assign expandedMask = ec.getResource().expand(.node["@mask"], "")!>
        <#if expandedMask?has_content><m-script>$('#${tlId}').inputmask("${expandedMask}");</m-script></#if>
        <#if .node["@default-transition"]?has_content>
            <#assign defUrlInfo = sri.makeUrlByType(.node["@default-transition"], "transition", .node, "false")>
            <#assign defUrlParameterMap = defUrlInfo.getParameterMap()>
            <#assign depNodeList = .node["depends-on"]>
            <m-script>
                function populate_${tlId}() {
                // if ($('#${tlId}').val()) return;
                var hasAllParms = true;
                    <#list depNodeList as depNode>if (!$('#<@fieldIdByName depNode["@field"]/>').val()) { hasAllParms = false; } </#list>
                if (!hasAllParms) { <#-- alert("not has all parms"); --> return; }
                $.ajax({ type:"POST", url:"${defUrlInfo.url}", data:{ moquiSessionToken: "${(ec.getWeb().sessionToken)!}"<#rt>
                            <#t><#list depNodeList as depNode><#local depNodeField = depNode["@field"]><#local _void = defUrlParameterMap.remove(depNodeField)!>, "${depNode["@parameter"]!depNodeField}": $("#<@fieldIdByName depNodeField/>").val()</#list>
                            <#t><#list defUrlParameterMap.keySet() as parameterKey><#if defUrlParameterMap.get(parameterKey)?has_content>, "${parameterKey}":"${defUrlParameterMap.get(parameterKey)}"</#if></#list>
                            <#t>}, dataType:"text", success:function(defaultText) {   $('#${tlId}').val(defaultText);  } });
                }
                <#list depNodeList as depNode>
                $("#<@fieldIdByName depNode["@field"]/>").on('change', function() { populate_${tlId}(); });
                </#list>
                populate_${tlId}();
            </m-script>
        </#if>
    </#if>
</#macro>

<#--custom macros-->
<#macro "add-product">
				<#assign targetUrl = sri.buildUrl(sri.getScreenUrlInstance().path)>
				<#assign trxGetStoreList = .node["@transition-get-store-list"]!"getStoreList">
				<#assign trxCheckUnique = .node["@transition-check-unique"]!"checkUnique">
				<#assign trxCreateProduct = .node["@transition-create-product"]!"createNewItem">
    <#assign trxGetVendors = .node["@transition-get-vendors"]!"getSuppliersListPaged">
				<div>
        <add-product
																trx-get-store-list="${targetUrl}/${trxGetStoreList}"
																trx-check-unique="${targetUrl}/${trxCheckUnique}"
																trx-create-product="${targetUrl}/${trxCreateProduct}"
                api-url-vendor-search="${targetUrl}/${trxGetVendors}"
								/>
    </div>
</#macro>
<#macro "edit-invoice">
				<#assign targetUrl = sri.buildUrl(sri.getScreenUrlInstance().path)>
				<#assign invoiceId = sri.getScreenUrlInstance().getParameterMap().get('invoiceId')!?html>
				<#assign transition = .node["@invoice-reload-url"]!"getInvoiceData">
				<#assign updateDescriptionTransition = .node["@invoice-update-description-url"]!"updateDescription">
				<#assign updateExternalReferenceTransition = .node["@invoice-update-external-reference-url"]!"updateExternalReference">
				<#assign updateStatusTransition = .node["@invoice-update-status-url"]!"updateStatus">
				<#assign updateInvoiceItemTransition = .node["@invoice-item-update-url"]!"updateInvoiceItem">
				<#assign deleteInvoiceItemTransition = .node["@invoice-item-delete-url"]!"deleteInvoiceItem">
				<#assign getInvoiceHistoryTransition = .node["@invoice-load-history-url"]!"getInvoiceHistory">
				<#assign getInvoiceAttachmentsTransition = .node["@invoice-load-attachments-url"]!"getInvoiceAttachments">
				<#assign attachmentOpenContentUrl = .node["@invoice-open-content-url"]!"openContent">
				<#assign attachmentDownloadContentUrl = .node["@invoice-download-content-url"]!"downloadContent">
				<#assign attachmentDeleteContentUrl = .node["@invoice-download-content-url"]!"deleteContent">
				<#assign attachmentUploadContentUrl = .node["@invoice-upload-content-url"]!"createContent">
				<#assign itemsColumns = sri.getVueColumns(.node)>
				<#assign itemsLoadTransition = .node["@items-load"]!"getInvoiceItems">
				<#assign paginationPath = .node["@pagination-path"]!"pagination">
				<div>
        <editinvoice
                data-reload-url="${targetUrl}/${transition}"
                :query-params="{sort: 'orderByField', page: 'pageIndex', perPage: 'pageSize'}"
                update-description-url="${targetUrl}/${updateDescriptionTransition}"
                update-external-reference-url="${targetUrl}/${updateExternalReferenceTransition}"
                update-status-url="${targetUrl}/${updateStatusTransition}"
                update-invoice-item-url="${targetUrl}/${updateInvoiceItemTransition}"
                delete-invoice-item-url="${targetUrl}/${deleteInvoiceItemTransition}"
                data-load-attachments-url="${targetUrl}/${getInvoiceAttachmentsTransition}"
                data-load-history-url="${targetUrl}/${getInvoiceHistoryTransition}"
                attachment-open-content-url="${targetUrl}/${attachmentOpenContentUrl}"
                attachment-download-content-url="${targetUrl}/${attachmentDownloadContentUrl}"
                attachment-delete-content-url="${targetUrl}/${attachmentDeleteContentUrl}"
                attachment-upload-content-url="${targetUrl}/${attachmentUploadContentUrl}"
                invoice-id="${invoiceId}"
                items-api-url="${targetUrl}/${itemsLoadTransition}"
                :items-fields="${itemsColumns}"
                items-data-path="dataLoaded"
                pagination-path="${paginationPath}"
                :css="{
                table: {
                    tableClass : 'table table-striped table-hover table-condensed',
                    loadingClass: 'loading',
                    ascendingIcon: 'glyphicon glyphicon-chevron-up',
                    descendingIcon: 'glyphicon glyphicon-chevron-down',
                    handleIcon: 'glyphicon glyphicon-menu-hamburger'
                },
                pagination: {
                    infoClass: 'pull-left',
                    wrapperClass: 'vuetable-pagination pull-right form-list-nav',
                    activeClass: 'btn-primary',
                    disabledClass: 'disabled',
                    pageClass: 'btn btn-border',
                    linkClass: 'btn btn-border',
                    icons: {
                        first: '',
                        prev: '',
                        next: '',
                        last: ''
                    }
                }
            }"
        >
        </editinvoice>
    </div>
</#macro>
<#macro "edit-product">
    <#assign productId = sri.getScreenUrlInstance().getParameterMap().get('productId')!?html>
    <#assign targetUrl = sri.buildUrl(sri.getScreenUrlInstance().path)>
    <#assign trxGetProductStores = .node["@transition-get-product-stores"]!"getProductStores">
    <#assign trxGetProductVendors = .node["@transition-get-product-vendors"]!"getProductVendors">
    <#assign trxGetProductStockDimensions = .node["@transition-get-product-stock-dimensions"]!"getProductPackage">
    <#assign trxGetProductDetails = .node["@transition-get-product-details"]!"getProductData">
    <#assign trxGetProductDimension = .node["@transition-get-product-dimensions"]!"getProductDimensions">
    <#assign trxGetVendors = .node["@transition-get-vendors"]!"getSuppliersListPaged">
    <#assign trxGetCheckReportOptions = .node["@transition-get-check-report-options"]!"getCheckReportOptions">
    <#assign trxGetStores = .node["@transition-get-stores"]!"getStoreList">
    <#assign trxGetShipmentType = .node["@transition-get-shipment-type"]!"getShipmentBoxList">
    <#assign trxGetDimensionTypes = .node["@transition-get-dimension-types"]!"getDimensionTypes">
    <#assign trxGetUnits = .node["@transition-get-units"]!"getUnitsOfMeasurment">
    <#assign trxCheckDimension = .node["@transition-check-dimension"]!"checkDimension">
    <#assign trxCreateProductVendor = .node["@transition-create-product-vendor"]!"createProductVendor">
    <#assign trxCreateProductDimension = .node["@transition-create-product-dimension"]!"createProductDimension">
    <#assign trxCreateProductStoreRelation = .node["@transition-create-product-vendor"]!"createProductStoreRelation">
    <#assign trxCreateProductPackage	 = .node["@transition-create-product-package"]!"createProductPackage">
    <#assign trxDeleteStoreRelation = .node["@transition-delete-store-relation"]!"deleteStoreRelation">
    <#assign trxDeleteProductPackage = .node["@transition-delete-product-package"]!"deleteProductPackage">
    <#assign trxDeleteProductVendor = .node["@transition-delete-product-vendor"]!"deleteProductVendor">
    <#assign trxDeleteProductDimension = .node["@transition-delete-product-dimension"]!"deleteProductDimension">
    <#assign trxUpdateProductDimension = .node["@transition-update-product-dimension"]!"updateProductDimension">
    <#assign trxUpdateProductCheckReportId = .node["@transition-update-product-check-report-id"]!"updateProductCheckReport">
    <#assign trxUpdateProductName = .node["@transition-update-product-name"]!"updateProductName">
				<edit-product
            api-url-get-stores="${targetUrl}/${trxGetProductStores}"
            api-url-get-vendors="${targetUrl}/${trxGetProductVendors}"
            api-url-get-stock-dimensions="${targetUrl}/${trxGetProductStockDimensions}"
            api-url-get-product-details="${targetUrl}/${trxGetProductDetails}"
            api-url-get-product-dimension="${targetUrl}/${trxGetProductDimension}"
            api-url-vendor-search="${targetUrl}/${trxGetVendors}"
            api-url-store-search="${targetUrl}/${trxGetStores}"
            api-url-get-shipment-types="${targetUrl}/${trxGetShipmentType}"
            api-url-get-dimension-types="${targetUrl}/${trxGetDimensionTypes}"
            api-url-get-units="${targetUrl}/${trxGetUnits}"
            api-url-check-dimension="${targetUrl}/${trxCheckDimension}"
            api-url-get-check-report-options="${targetUrl}/${trxGetCheckReportOptions}"
            trx-create-product-vendor="${targetUrl}/${trxCreateProductVendor}"
            trx-create-product-dimension="${targetUrl}/${trxCreateProductDimension}"
            trx-create-product-store-relation="${targetUrl}/${trxCreateProductStoreRelation}"
            trx-create-product-package="${targetUrl}/${trxCreateProductPackage}"
            trx-delete-store-relation="${targetUrl}/${trxDeleteStoreRelation}"
            trx-delete-product-vendor="${targetUrl}/${trxDeleteProductVendor}"
            trx-delete-product-package="${targetUrl}/${trxDeleteProductPackage}"
            trx-delete-product-dimension="${targetUrl}/${trxDeleteProductDimension}"
            trx-update-product-dimension="${targetUrl}/${trxUpdateProductDimension}"
            trx-update-product-check-report="${targetUrl}/${trxUpdateProductCheckReportId}"
            trx-update-product-name="${targetUrl}/${trxUpdateProductName}"
            :append-params="{productId: '${productId}'}"
            :fields-stores="[
                {
                    name: 'storeDataId',
                    title: 'Store Data ID'
                },
                {
                    name: 'value',
                    title: 'Store Label'
                },
                {
                    name: 'productName',
                    title: 'Product Name'
                },
                {
                    name: 'productInternalCode',
                    title: 'Product Code'
                },
                '__slot:delete'
        ]"
            :fields-vendors="[
																{
                    name: 'organizationName',
                    title: 'Party Name',
                    sortField: 'value'
                },
                {
                    name: 'roleTypeId',
                    title: 'Type',
                    visible: false
                },
                {
                    name: 'productId',
                    visible: false
                },
                {
                    name: 'fromDate',
                    visible: false
                },
                '__slot:delete']"
            :fields-stock-dimensions="[
                {
                    name:'productId',
                    visible: false
                },
                {
                    name:'shipmentBoxTypeId',
                    title: 'Shipment Box Type'
                },
                {
                    name: '__slot:editQuantity',
                    title: 'Quantity'
                },
                {
                    name: '__slot:editQuantityOnPalette',
                    title: 'Quantity On Palette'
                },
                '__slot:saveEdit',
                '__slot:delete']"
            :fields-product-dimensions="[
                {
                    name:'productId',
                    visible: false
                },
                {
                    name:'dimensionTypeId',
                    title: 'Dimension'
                },
                {
                    name:'dimensionTypeEnumId',
                    visible: false
                },
                    '__slot:editValue',
                {
                    name:'uomAbbreviation',
                    title: 'UOM'
                },
                    '__slot:saveEdit',
                    '__slot:delete'
     ]"
            :query-params="{sort: 'sort', page: 'pageIndex', perPage: 'pageSize'}"
            pagination-path-stores="pagination"
            pagination-path-vendors="pagination"
            pagination-path-stock-dimensions="pagination"
            pagination-path-dimensions="pagination"
            data-path-stores="storeRelation"
            data-path-vendors="vendorList"
            data-path-stock-dimensions="packages"
            data-path-dimensions="dimensions"
            :css="{
                        table: {
                            tableClass : 'table table-striped table-hover table-condensed',
                            loadingClass: 'loading',
                            ascendingIcon: 'glyphicon glyphicon-chevron-up',
                            descendingIcon: 'glyphicon glyphicon-chevron-down',
                            handleIcon: 'glyphicon glyphicon-menu-hamburger'
                        },
                        pagination: {
                            infoClass: 'pull-left',
                            wrapperClass: 'vuetable-pagination pull-right form-list-nav',
                            activeClass: 'btn-primary',
                            disabledClass: 'disabled',
                            pageClass: 'btn btn-border',
                            linkClass: 'btn btn-border',
                            icons: {
                                first: '',
                                prev: '',
                                next: '',
                                last: ''
                            }
                        }
                    }"
    ></edit-product>
</#macro>
<#macro "search">
    <#assign vueCols = sri.getVueColumns(.node)>
    <#assign targetUrl = sri.buildUrl(sri.getScreenUrlInstance().path)>
    <#assign transition = .node["@transition-search"]!"searchProduct_v3">
    <#assign transitionGetStoreList = .node["@transition-get-store-list"]!"getStoreList">
    <#assign transitionGetSupplierList = .node["@transition-get-suppliers-list"]!"getSuppliersListPaged">
    <#assign transitionEditProduct = .node["@transition-edit-product"]!"EditProduct">
    <#assign dataLoaded = .node["@data-path"]!"dataLoaded">
    <#assign paginationPath = .node["@pagination-path"]!"pagination">
    <div>
        <search
                api-url="${targetUrl}/${transition}"
                trx-get-store-list="${targetUrl}/${transitionGetStoreList}"
                trx-get-suppliers-list="${targetUrl}/${transitionGetSupplierList}"
                trx-edit-product="${targetUrl}/${transitionEditProduct}"
                :fields="${vueCols}"
                :query-params="{sort: 'orderByField', page: 'pageIndex', perPage: 'pageSize'}"
                data-path="${dataLoaded}"
                pagination-path="${paginationPath}"
                :css="{
                        table: {
                            tableClass : 'table table-striped table-hover table-condensed',
                            loadingClass: 'loading',
                            ascendingIcon: 'glyphicon glyphicon-chevron-up',
                            descendingIcon: 'glyphicon glyphicon-chevron-down',
                            handleIcon: 'glyphicon glyphicon-menu-hamburger'
                        },
                        pagination: {
                            infoClass: 'pull-left',
                            wrapperClass: 'vuetable-pagination pull-right form-list-nav',
                            activeClass: 'btn-primary',
                            disabledClass: 'disabled',
                            pageClass: 'btn btn-border',
                            linkClass: 'btn btn-border',
                            icons: {
                                first: '',
                                prev: '',
                                next: '',
                                last: ''
                            }
                        }
                    }"
        ></search>
    </div>
</#macro>

<#--soon to become obsolete-->
<#macro "paginated-table">
    <#assign targetUrl = sri.buildUrl(sri.getScreenUrlInstance().path)>
    <#assign transition = .node["@transition-used"]!"forgot-to-set-transition">
    <#assign searchPartiesTransition = .node["@search-parties"]!"findParty">
    <#assign updateManualCategoryTransition = .node["@manual-category-transition"]!"updateCategory">
    <#assign loadTagsTransition = .node["@load-tags-transition"]!"loadTags">
    <#assign tableType = .node["@table-type"]!"vuetable">
    <#assign perPage = .node["@per-page"]!"20">
    <#assign dataLoaded = .node["@data-path"]!"dataLoaded">
    <#assign paginationPath = .node["@pagination-path"]!"pagination">
    <#assign onEachSide = .node["@on-each-side"]!"3">
    <#assign trackBy = .node["@track-by"]!"id">
    <#assign internalCompanies = sri.listToJson(context['orgList']!"[]")>
    <#assign multiSort = .node["@multi-sort"]!"true">
    <#assign vueCols = sri.getVueColumns(.node)>
    <div id="app">
        <div id="vi-paginated-table-1">
            <${tableType}
            api-url="${targetUrl}/${transition}"
            :fields="${vueCols}"
            :per-page="${perPage}"
            data-path="${dataLoaded}"
            pagination-path="${paginationPath}"
            search-parties-api-url="${targetUrl}/${searchPartiesTransition}"
            update-manual-category-url="${targetUrl}/${updateManualCategoryTransition}"
            load-tags-url="${targetUrl}/${loadTagsTransition}"
            :query-params="{sort: 'orderByField', page: 'pageIndex', perPage: 'pageSize'}"
            track-by="${trackBy}"
            :css="{
            table: {
            tableClass : 'table table-striped table-hover table-condensed',
            loadingClass: 'loading',
            ascendingIcon: 'glyphicon glyphicon-chevron-up',
            descendingIcon: 'glyphicon glyphicon-chevron-down',
            handleIcon: 'glyphicon glyphicon-menu-hamburger'
            },
            pagination: {
            infoClass: 'pull-left',
            wrapperClass: 'vuetable-pagination pull-right form-list-nav',
            activeClass: 'btn-primary',
            disabledClass: 'disabled',
            pageClass: 'btn btn-border',
            linkClass: 'btn btn-border',
            icons: {
            first: '',
            prev: '',
            next: '',
            last: ''
            }
            }
            }"
            :on-each-side="${onEachSide}"
            :internal-companies="${internalCompanies}"
            :multi-sort="${multiSort}">
        </${tableType}>
    </div>
    </div>
</#macro>