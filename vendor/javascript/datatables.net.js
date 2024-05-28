import e from"jquery";var t=e;var DataTable=function(e,n){if(DataTable.factory(e,n))return DataTable;if(this instanceof DataTable)return t(e).DataTable(n);n=e;var i=this;var o=n===void 0;var l=this.length;o&&(n={});this.api=function(){return new r(this)};this.each((function(){var e={};var s=l>1?_fnExtend(e,n,true):n;var u,f=0;var c=this.getAttribute("id");var d=false;var p=DataTable.defaults;var h=t(this);if(this.nodeName.toLowerCase()=="table"){t(this).trigger("options.dt",s);_fnCompatOpts(p);_fnCompatCols(p.column);_fnCamelToHungarian(p,p,true);_fnCamelToHungarian(p.column,p.column,true);_fnCamelToHungarian(p,t.extend(s,h.data()),true);var v=DataTable.settings;for(f=0,u=v.length;f<u;f++){var m=v[f];if(m.nTable==this||m.nTHead&&m.nTHead.parentNode==this||m.nTFoot&&m.nTFoot.parentNode==this){var _=s.bRetrieve!==void 0?s.bRetrieve:p.bRetrieve;var b=s.bDestroy!==void 0?s.bDestroy:p.bDestroy;if(o||_)return m.oInstance;if(b){new DataTable.Api(m).destroy();break}_fnLog(m,0,"Cannot reinitialise DataTable",3);return}if(m.sTableId==this.id){v.splice(f,1);break}}if(c===null||c===""){c="DataTables_Table_"+DataTable.ext._unique++;this.id=c}var y=t.extend(true,{},DataTable.models.oSettings,{sDestroyWidth:h[0].style.width,sInstance:c,sTableId:c,colgroup:t("<colgroup>").prependTo(this),fastData:function(e,t,n){return _fnGetCellData(y,e,t,n)}});y.nTable=this;y.oInit=s;v.push(y);y.api=new r(y);y.oInstance=i.length===1?i:h.dataTable();_fnCompatOpts(s);s.aLengthMenu&&!s.iDisplayLength&&(s.iDisplayLength=Array.isArray(s.aLengthMenu[0])?s.aLengthMenu[0][0]:t.isPlainObject(s.aLengthMenu[0])?s.aLengthMenu[0].value:s.aLengthMenu[0]);s=_fnExtend(t.extend(true,{},p),s);_fnMap(y.oFeatures,s,["bPaginate","bLengthChange","bFilter","bSort","bSortMulti","bInfo","bProcessing","bAutoWidth","bSortClasses","bServerSide","bDeferRender"]);_fnMap(y,s,["ajax","fnFormatNumber","sServerMethod","aaSorting","aaSortingFixed","aLengthMenu","sPaginationType","iStateDuration","bSortCellsTop","iTabIndex","sDom","fnStateLoadCallback","fnStateSaveCallback","renderer","searchDelay","rowId","caption","layout",["iCookieDuration","iStateDuration"],["oSearch","oPreviousSearch"],["aoSearchCols","aoPreSearchCols"],["iDisplayLength","_iDisplayLength"]]);_fnMap(y.oScroll,s,[["sScrollX","sX"],["sScrollXInner","sXInner"],["sScrollY","sY"],["bScrollCollapse","bCollapse"]]);_fnMap(y.oLanguage,s,"fnInfoCallback");_fnCallbackReg(y,"aoDrawCallback",s.fnDrawCallback);_fnCallbackReg(y,"aoStateSaveParams",s.fnStateSaveParams);_fnCallbackReg(y,"aoStateLoadParams",s.fnStateLoadParams);_fnCallbackReg(y,"aoStateLoaded",s.fnStateLoaded);_fnCallbackReg(y,"aoRowCallback",s.fnRowCallback);_fnCallbackReg(y,"aoRowCreatedCallback",s.fnCreatedRow);_fnCallbackReg(y,"aoHeaderCallback",s.fnHeaderCallback);_fnCallbackReg(y,"aoFooterCallback",s.fnFooterCallback);_fnCallbackReg(y,"aoInitComplete",s.fnInitComplete);_fnCallbackReg(y,"aoPreDrawCallback",s.fnPreDrawCallback);y.rowIdFn=g(s.rowId);_fnBrowserDetect(y);var D=y.oClasses;t.extend(D,DataTable.ext.classes,s.oClasses);h.addClass(D.table);y.oFeatures.bPaginate||(s.iDisplayStart=0);if(y.iInitDisplayStart===void 0){y.iInitDisplayStart=s.iDisplayStart;y._iDisplayStart=s.iDisplayStart}var C=y.oLanguage;t.extend(true,C,s.oLanguage);if(C.sUrl){t.ajax({dataType:"json",url:C.sUrl,success:function(e){_fnCamelToHungarian(p.oLanguage,e);t.extend(true,C,e,y.oInit.oLanguage);_fnCallbackFire(y,null,"i18n",[y],true);_fnInitialise(y)},error:function(){_fnLog(y,0,"i18n file loading error",21);_fnInitialise(y)}});d=true}else _fnCallbackFire(y,null,"i18n",[y]);var S=[];var x=this.getElementsByTagName("thead");var w=_fnDetectHeader(y,x[0]);if(s.aoColumns)S=s.aoColumns;else if(w.length)for(f=0,u=w[0].length;f<u;f++)S.push(null);for(f=0,u=S.length;f<u;f++)_fnAddColumn(y);_fnApplyColumnDefs(y,s.aoColumnDefs,S,w,(function(e,t){_fnColumnOptions(y,e,t)}));var T=h.children("tbody").find("tr").eq(0);if(T.length){var a=function(e,t){return e.getAttribute("data-"+t)!==null?t:null};t(T[0]).children("th, td").each((function(e,t){var n=y.aoColumns[e];n||_fnLog(y,0,"Incorrect column count",18);if(n.mData===e){var r=a(t,"sort")||a(t,"order");var i=a(t,"filter")||a(t,"search");if(r!==null||i!==null){n.mData={_:e+".display",sort:r!==null?e+".@data-"+r:void 0,type:r!==null?e+".@data-"+r:void 0,filter:i!==null?e+".@data-"+i:void 0};n._isArrayHost=true;_fnColumnOptions(y,e)}}}))}var A=y.oFeatures;var loadedInit=function(){if(s.aaSorting===void 0){var e=y.aaSorting;for(f=0,u=e.length;f<u;f++)e[f][1]=y.aoColumns[f].asSorting[0]}_fnSortingClasses(y);_fnCallbackReg(y,"aoDrawCallback",(function(){(y.bSorted||_fnDataSource(y)==="ssp"||A.bDeferRender)&&_fnSortingClasses(y)}));var n=h.children("caption");if(y.caption){n.length===0&&(n=t("<caption/>").appendTo(h));n.html(y.caption)}if(n.length){n[0]._captionSide=n.css("caption-side");y.captionNode=n[0]}x.length===0&&(x=t("<thead/>").appendTo(h));y.nTHead=x[0];t("tr",x).addClass(D.thead.row);var r=h.children("tbody");r.length===0&&(r=t("<tbody/>").insertAfter(x));y.nTBody=r[0];var i=h.children("tfoot");i.length===0&&(i=t("<tfoot/>").appendTo(h));y.nTFoot=i[0];t("tr",i).addClass(D.tfoot.row);if(s.aaData)for(f=0;f<s.aaData.length;f++)_fnAddData(y,s.aaData[f]);else _fnDataSource(y)=="dom"&&_fnAddTr(y,t(y.nTBody).children("tr"));y.aiDisplay=y.aiDisplayMaster.slice();y.bInitialised=true;d===false&&_fnInitialise(y)};_fnCallbackReg(y,"aoDrawCallback",_fnSaveState);if(s.bStateSave){A.bStateSave=true;_fnLoadState(y,s,loadedInit)}else loadedInit()}else _fnLog(null,0,"Non-table node initialisation ("+this.nodeName+")",2)}));i=null;return this};DataTable.ext=n={
/**
	 * Buttons. For use with the Buttons extension for DataTables. This is
	 * defined here so other extensions can define buttons regardless of load
	 * order. It is _not_ used by DataTables core.
	 *
	 *  @type object
	 *  @default {}
	 */
buttons:{},
/**
	 * Element class names
	 *
	 *  @type object
	 *  @default {}
	 */
classes:{},
/**
	 * DataTables build type (expanded by the download builder)
	 *
	 *  @type string
	 */
builder:"-source-",
/**
	 * Error reporting.
	 * 
	 * How should DataTables report an error. Can take the value 'alert',
	 * 'throw', 'none' or a function.
	 *
	 *  @type string|function
	 *  @default alert
	 */
errMode:"alert",feature:[],features:{},
/**
	 * Row searching.
	 * 
	 * This method of searching is complimentary to the default type based
	 * searching, and a lot more comprehensive as it allows you complete control
	 * over the searching logic. Each element in this array is a function
	 * (parameters described below) that is called for every row in the table,
	 * and your logic decides if it should be included in the searching data set
	 * or not.
	 *
	 * Searching functions have the following input parameters:
	 *
	 * 1. `{object}` DataTables settings object: see
	 *    {@link DataTable.models.oSettings}
	 * 2. `{array|object}` Data for the row to be processed (same as the
	 *    original format that was passed in as the data source, or an array
	 *    from a DOM data source
	 * 3. `{int}` Row index ({@link DataTable.models.oSettings.aoData}), which
	 *    can be useful to retrieve the `TR` element if you need DOM interaction.
	 *
	 * And the following return is expected:
	 *
	 * * {boolean} Include the row in the searched result set (true) or not
	 *   (false)
	 *
	 * Note that as with the main search ability in DataTables, technically this
	 * is "filtering", since it is subtractive. However, for consistency in
	 * naming we call it searching here.
	 *
	 *  @type array
	 *  @default []
	 *
	 *  @example
	 *    // The following example shows custom search being applied to the
	 *    // fourth column (i.e. the data[3] index) based on two input values
	 *    // from the end-user, matching the data in a certain range.
	 *    $.fn.dataTable.ext.search.push(
	 *      function( settings, data, dataIndex ) {
	 *        var min = document.getElementById('min').value * 1;
	 *        var max = document.getElementById('max').value * 1;
	 *        var version = data[3] == "-" ? 0 : data[3]*1;
	 *
	 *        if ( min == "" && max == "" ) {
	 *          return true;
	 *        }
	 *        else if ( min == "" && version < max ) {
	 *          return true;
	 *        }
	 *        else if ( min < version && "" == max ) {
	 *          return true;
	 *        }
	 *        else if ( min < version && version < max ) {
	 *          return true;
	 *        }
	 *        return false;
	 *      }
	 *    );
	 */
search:[],
/**
	 * Selector extensions
	 *
	 * The `selector` option can be used to extend the options available for the
	 * selector modifier options (`selector-modifier` object data type) that
	 * each of the three built in selector types offer (row, column and cell +
	 * their plural counterparts). For example the Select extension uses this
	 * mechanism to provide an option to select only rows, columns and cells
	 * that have been marked as selected by the end user (`{selected: true}`),
	 * which can be used in conjunction with the existing built in selector
	 * options.
	 *
	 * Each property is an array to which functions can be pushed. The functions
	 * take three attributes:
	 *
	 * * Settings object for the host table
	 * * Options object (`selector-modifier` object type)
	 * * Array of selected item indexes
	 *
	 * The return is an array of the resulting item indexes after the custom
	 * selector has been applied.
	 *
	 *  @type object
	 */
selector:{cell:[],column:[],row:[]},
/**
	 * Legacy configuration options. Enable and disable legacy options that
	 * are available in DataTables.
	 *
	 *  @type object
	 */
legacy:{
/**
		 * Enable / disable DataTables 1.9 compatible server-side processing
		 * requests
		 *
		 *  @type boolean
		 *  @default null
		 */
ajax:null},
/**
	 * Pagination plug-in methods.
	 * 
	 * Each entry in this object is a function and defines which buttons should
	 * be shown by the pagination rendering method that is used for the table:
	 * {@link DataTable.ext.renderer.pageButton}. The renderer addresses how the
	 * buttons are displayed in the document, while the functions here tell it
	 * what buttons to display. This is done by returning an array of button
	 * descriptions (what each button will do).
	 *
	 * Pagination types (the four built in options and any additional plug-in
	 * options defined here) can be used through the `paginationType`
	 * initialisation parameter.
	 *
	 * The functions defined take two parameters:
	 *
	 * 1. `{int} page` The current page index
	 * 2. `{int} pages` The number of pages in the table
	 *
	 * Each function is expected to return an array where each element of the
	 * array can be one of:
	 *
	 * * `first` - Jump to first page when activated
	 * * `last` - Jump to last page when activated
	 * * `previous` - Show previous page when activated
	 * * `next` - Show next page when activated
	 * * `{int}` - Show page of the index given
	 * * `{array}` - A nested array containing the above elements to add a
	 *   containing 'DIV' element (might be useful for styling).
	 *
	 * Note that DataTables v1.9- used this object slightly differently whereby
	 * an object with two functions would be defined for each plug-in. That
	 * ability is still supported by DataTables 1.10+ to provide backwards
	 * compatibility, but this option of use is now decremented and no longer
	 * documented in DataTables 1.10+.
	 *
	 *  @type object
	 *  @default {}
	 *
	 *  @example
	 *    // Show previous, next and current page buttons only
	 *    $.fn.dataTableExt.oPagination.current = function ( page, pages ) {
	 *      return [ 'previous', page, 'next' ];
	 *    };
	 */
pager:{},renderer:{pageButton:{},header:{}},
/**
	 * Ordering plug-ins - custom data source
	 * 
	 * The extension options for ordering of data available here is complimentary
	 * to the default type based ordering that DataTables typically uses. It
	 * allows much greater control over the the data that is being used to
	 * order a column, but is necessarily therefore more complex.
	 * 
	 * This type of ordering is useful if you want to do ordering based on data
	 * live from the DOM (for example the contents of an 'input' element) rather
	 * than just the static string that DataTables knows of.
	 * 
	 * The way these plug-ins work is that you create an array of the values you
	 * wish to be ordering for the column in question and then return that
	 * array. The data in the array much be in the index order of the rows in
	 * the table (not the currently ordering order!). Which order data gathering
	 * function is run here depends on the `dt-init columns.orderDataType`
	 * parameter that is used for the column (if any).
	 *
	 * The functions defined take two parameters:
	 *
	 * 1. `{object}` DataTables settings object: see
	 *    {@link DataTable.models.oSettings}
	 * 2. `{int}` Target column index
	 *
	 * Each function is expected to return an array:
	 *
	 * * `{array}` Data for the column to be ordering upon
	 *
	 *  @type array
	 *
	 *  @example
	 *    // Ordering using `input` node values
	 *    $.fn.dataTable.ext.order['dom-text'] = function  ( settings, col )
	 *    {
	 *      return this.api().column( col, {order:'index'} ).nodes().map( function ( td, i ) {
	 *        return $('input', td).val();
	 *      } );
	 *    }
	 */
order:{},type:{className:{},
/**
		 * Type detection functions.
		 *
		 * The functions defined in this object are used to automatically detect
		 * a column's type, making initialisation of DataTables super easy, even
		 * when complex data is in the table.
		 *
		 * The functions defined take two parameters:
		 *
	     *  1. `{*}` Data from the column cell to be analysed
	     *  2. `{settings}` DataTables settings object. This can be used to
	     *     perform context specific type detection - for example detection
	     *     based on language settings such as using a comma for a decimal
	     *     place. Generally speaking the options from the settings will not
	     *     be required
		 *
		 * Each function is expected to return:
		 *
		 * * `{string|null}` Data type detected, or null if unknown (and thus
		 *   pass it on to the other type detection functions.
		 *
		 *  @type array
		 *
		 *  @example
		 *    // Currency type detection plug-in:
		 *    $.fn.dataTable.ext.type.detect.push(
		 *      function ( data, settings ) {
		 *        // Check the numeric part
		 *        if ( ! data.substring(1).match(/[0-9]/) ) {
		 *          return null;
		 *        }
		 *
		 *        // Check prefixed by currency
		 *        if ( data.charAt(0) == '$' || data.charAt(0) == '&pound;' ) {
		 *          return 'currency';
		 *        }
		 *        return null;
		 *      }
		 *    );
		 */
detect:[],render:{},
/**
		 * Type based search formatting.
		 *
		 * The type based searching functions can be used to pre-format the
		 * data to be search on. For example, it can be used to strip HTML
		 * tags or to de-format telephone numbers for numeric only searching.
		 *
		 * Note that is a search is not defined for a column of a given type,
		 * no search formatting will be performed.
		 * 
		 * Pre-processing of searching data plug-ins - When you assign the sType
		 * for a column (or have it automatically detected for you by DataTables
		 * or a type detection plug-in), you will typically be using this for
		 * custom sorting, but it can also be used to provide custom searching
		 * by allowing you to pre-processing the data and returning the data in
		 * the format that should be searched upon. This is done by adding
		 * functions this object with a parameter name which matches the sType
		 * for that target column. This is the corollary of <i>afnSortData</i>
		 * for searching data.
		 *
		 * The functions defined take a single parameter:
		 *
	     *  1. `{*}` Data from the column cell to be prepared for searching
		 *
		 * Each function is expected to return:
		 *
		 * * `{string|null}` Formatted string that will be used for the searching.
		 *
		 *  @type object
		 *  @default {}
		 *
		 *  @example
		 *    $.fn.dataTable.ext.type.search['title-numeric'] = function ( d ) {
		 *      return d.replace(/\n/g," ").replace( /<.*?>/g, "" );
		 *    }
		 */
search:{},
/**
		 * Type based ordering.
		 *
		 * The column type tells DataTables what ordering to apply to the table
		 * when a column is sorted upon. The order for each type that is defined,
		 * is defined by the functions available in this object.
		 *
		 * Each ordering option can be described by three properties added to
		 * this object:
		 *
		 * * `{type}-pre` - Pre-formatting function
		 * * `{type}-asc` - Ascending order function
		 * * `{type}-desc` - Descending order function
		 *
		 * All three can be used together, only `{type}-pre` or only
		 * `{type}-asc` and `{type}-desc` together. It is generally recommended
		 * that only `{type}-pre` is used, as this provides the optimal
		 * implementation in terms of speed, although the others are provided
		 * for compatibility with existing Javascript sort functions.
		 *
		 * `{type}-pre`: Functions defined take a single parameter:
		 *
	     *  1. `{*}` Data from the column cell to be prepared for ordering
		 *
		 * And return:
		 *
		 * * `{*}` Data to be sorted upon
		 *
		 * `{type}-asc` and `{type}-desc`: Functions are typical Javascript sort
		 * functions, taking two parameters:
		 *
	     *  1. `{*}` Data to compare to the second parameter
	     *  2. `{*}` Data to compare to the first parameter
		 *
		 * And returning:
		 *
		 * * `{*}` Ordering match: <0 if first parameter should be sorted lower
		 *   than the second parameter, ===0 if the two parameters are equal and
		 *   >0 if the first parameter should be sorted height than the second
		 *   parameter.
		 * 
		 *  @type object
		 *  @default {}
		 *
		 *  @example
		 *    // Numeric ordering of formatted numbers with a pre-formatter
		 *    $.extend( $.fn.dataTable.ext.type.order, {
		 *      "string-pre": function(x) {
		 *        a = (a === "-" || a === "") ? 0 : a.replace( /[^\d\-\.]/g, "" );
		 *        return parseFloat( a );
		 *      }
		 *    } );
		 *
		 *  @example
		 *    // Case-sensitive string ordering, with no pre-formatting method
		 *    $.extend( $.fn.dataTable.ext.order, {
		 *      "string-case-asc": function(x,y) {
		 *        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		 *      },
		 *      "string-case-desc": function(x,y) {
		 *        return ((x < y) ? 1 : ((x > y) ? -1 : 0));
		 *      }
		 *    } );
		 */
order:{}},
/**
	 * Unique DataTables instance counter
	 *
	 * @type int
	 * @private
	 */
_unique:0,
/**
	 * Version check function.
	 *  @type function
	 *  @depreciated Since 1.10
	 */
fnVersionCheck:DataTable.fnVersionCheck,
/**
	 * Index for what 'this' index API functions should use
	 *  @type int
	 *  @deprecated Since v1.10
	 */
iApiIndex:0,
/**
	 * Software version
	 *  @type string
	 *  @deprecated Since v1.10
	 */
sVersion:DataTable.version};t.extend(n,{afnFiltering:n.search,aTypes:n.type.detect,ofnSearch:n.type.search,oSort:n.type.order,afnSortData:n.order,aoFeatures:n.feature,oStdClasses:n.classes,oPagination:n.pager});t.extend(DataTable.ext.classes,{container:"dt-container",empty:{row:"dt-empty"},info:{container:"dt-info"},length:{container:"dt-length",select:"dt-input"},order:{canAsc:"dt-orderable-asc",canDesc:"dt-orderable-desc",isAsc:"dt-ordering-asc",isDesc:"dt-ordering-desc",none:"dt-orderable-none",position:"sorting_"},processing:{container:"dt-processing"},scrolling:{body:"dt-scroll-body",container:"dt-scroll",footer:{self:"dt-scroll-foot",inner:"dt-scroll-footInner"},header:{self:"dt-scroll-head",inner:"dt-scroll-headInner"}},search:{container:"dt-search",input:"dt-input"},table:"dataTable",tbody:{cell:"",row:""},thead:{cell:"",row:""},tfoot:{cell:"",row:""},paging:{active:"current",button:"dt-paging-button",container:"dt-paging",disabled:"disabled"}});var n;var r;var i;var o;var l={};var s=/[\r\n\u2028]/g;var u=/<([^>]*>)/g;var f=Math.pow(2,28);var c=/^\d{2,4}[./-]\d{1,2}[./-]\d{1,2}([T ]{1}\d{1,2}[:.]\d{2}([.:]\d{2})?)?$/;var d=new RegExp("(\\"+["/",".","*","+","?","|","(",")","[","]","{","}","\\","$","^","-"].join("|\\")+")","g");var p=/['\u00A0,$£€¥%\u2009\u202F\u20BD\u20a9\u20BArfkɃΞ]/gi;var _empty=function(e){return!e||e===true||e==="-"};var _intVal=function(e){var t=parseInt(e,10);return!isNaN(t)&&isFinite(e)?t:null};var _numToDecimal=function(e,t){l[t]||(l[t]=new RegExp(_(t),"g"));return typeof e==="string"&&t!=="."?e.replace(/\./g,"").replace(l[t],"."):e};var _isNumber=function(e,t,n){var r=typeof e;var i=r==="string";if(r==="number"||r==="bigint")return true;if(_empty(e))return true;t&&i&&(e=_numToDecimal(e,t));n&&i&&(e=e.replace(p,""));return!isNaN(parseFloat(e))&&isFinite(e)};var _isHtml=function(e){return _empty(e)||typeof e==="string"};var _htmlNumeric=function(e,t,n){if(_empty(e))return true;if(typeof e==="string"&&e.match(/<(input|select)/i))return null;var r=_isHtml(e);return r&&!!_isNumber(_stripHtml(e),t,n)||null};var _pluck=function(e,t,n){var r=[];var i=0,o=e.length;if(n!==void 0)for(;i<o;i++)e[i]&&e[i][t]&&r.push(e[i][t][n]);else for(;i<o;i++)e[i]&&r.push(e[i][t]);return r};var _pluck_order=function(e,t,n,r){var i=[];var o=0,l=t.length;if(r!==void 0)for(;o<l;o++)e[t[o]][n]&&i.push(e[t[o]][n][r]);else for(;o<l;o++)e[t[o]]&&i.push(e[t[o]][n]);return i};var _range=function(e,t){var n=[];var r;if(t===void 0){t=0;r=e}else{r=t;t=e}for(var i=t;i<r;i++)n.push(i);return n};var _removeEmpty=function(e){var t=[];for(var n=0,r=e.length;n<r;n++)e[n]&&t.push(e[n]);return t};var _stripHtml=function(e){if(e.length>f)throw new Error("Exceeded max str len");var t;e=e.replace(u,"");do{t=e;e=e.replace(/<script/i,"")}while(e!==t);return t};var _escapeHtml=function(e){Array.isArray(e)&&(e=e.join(","));return typeof e==="string"?e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;"):e};var _normalize=function(e,t){if(typeof e!=="string")return e;var n=e.normalize("NFD");return n.length!==e.length?(t===true?e+" ":"")+n.replace(/[\u0300-\u036f]/g,""):n};
/**
 * Determine if all values in the array are unique. This means we can short
 * cut the _unique method at the cost of a single loop. A sorted array is used
 * to easily check the values.
 *
 * @param  {array} src Source array
 * @return {boolean} true if all unique, false otherwise
 * @ignore
 */var _areAllUnique=function(e){if(e.length<2)return true;var t=e.slice().sort();var n=t[0];for(var r=1,i=t.length;r<i;r++){if(t[r]===n)return false;n=t[r]}return true};
/**
 * Find the unique elements in a source array.
 *
 * @param  {array} src Source array
 * @return {array} Array of unique items
 * @ignore
 */var _unique=function(e){if(Array.from&&Set)return Array.from(new Set(e));if(_areAllUnique(e))return e.slice();var t,n,r,i=[],o=e.length,l=0;e:for(n=0;n<o;n++){t=e[n];for(r=0;r<l;r++)if(i[r]===t)continue e;i.push(t);l++}return i};var _flatten=function(e,t){if(Array.isArray(t))for(var n=0;n<t.length;n++)_flatten(e,t[n]);else e.push(t);return e};function _addClass(e,t){t&&t.split(" ").forEach((function(t){t&&e.classList.add(t)}))}DataTable.util={
/**
	 * Return a string with diacritic characters decomposed
	 * @param {*} mixed Function or string to normalize
	 * @param {*} both Return original string and the normalized string
	 * @returns String or undefined
	 */
diacritics:function(e,t){var n=typeof e;if(n!=="function")return _normalize(e,t);_normalize=e},
/**
	 * Debounce a function
	 *
	 * @param {function} fn Function to be called
	 * @param {integer} freq Call frequency in mS
	 * @return {function} Wrapped function
	 */
debounce:function(e,t){var n;return function(){var r=this;var i=arguments;clearTimeout(n);n=setTimeout((function(){e.apply(r,i)}),t||250)}},
/**
	 * Throttle the calls to a function. Arguments and context are maintained
	 * for the throttled function.
	 *
	 * @param {function} fn Function to be called
	 * @param {integer} freq Call frequency in mS
	 * @return {function} Wrapped function
	 */
throttle:function(e,t){var n,r,i=t!==void 0?t:200;return function(){var t=this,o=+new Date,l=arguments;if(n&&o<n+i){clearTimeout(r);r=setTimeout((function(){n=void 0;e.apply(t,l)}),i)}else{n=o;e.apply(t,l)}}},
/**
	 * Escape a string such that it can be used in a regular expression
	 *
	 *  @param {string} val string to escape
	 *  @returns {string} escaped string
	 */
escapeRegex:function(e){return e.replace(d,"\\$1")},
/**
	 * Create a function that will write to a nested object or array
	 * @param {*} source JSON notation string
	 * @returns Write function
	 */
set:function(e){if(t.isPlainObject(e))return DataTable.util.set(e._);if(e===null)return function(){};if(typeof e==="function")return function(t,n,r){e(t,"set",n,r)};if(typeof e!=="string"||e.indexOf(".")===-1&&e.indexOf("[")===-1&&e.indexOf("(")===-1)return function(t,n){t[e]=n};var setData=function(e,t,n){var r,i=_fnSplitObjNotation(n);var o=i[i.length-1];var l,s,u,f;for(var c=0,d=i.length-1;c<d;c++){if(i[c]==="__proto__"||i[c]==="constructor")throw new Error("Cannot set prototype values");l=i[c].match(h);s=i[c].match(v);if(l){i[c]=i[c].replace(h,"");e[i[c]]=[];r=i.slice();r.splice(0,c+1);f=r.join(".");if(Array.isArray(t))for(var p=0,g=t.length;p<g;p++){u={};setData(u,t[p],f);e[i[c]].push(u)}else e[i[c]]=t;return}if(s){i[c]=i[c].replace(v,"");e=e[i[c]](t)}e[i[c]]!==null&&e[i[c]]!==void 0||(e[i[c]]={});e=e[i[c]]}o.match(v)?e=e[o.replace(v,"")](t):e[o.replace(h,"")]=t};return function(t,n){return setData(t,n,e)}},
/**
	 * Create a function that will read nested objects from arrays, based on JSON notation
	 * @param {*} source JSON notation string
	 * @returns Value read
	 */
get:function(e){if(t.isPlainObject(e)){var n={};t.each(e,(function(e,t){t&&(n[e]=DataTable.util.get(t))}));return function(e,t,r,i){var o=n[t]||n._;return o!==void 0?o(e,t,r,i):e}}if(e===null)return function(e){return e};if(typeof e==="function")return function(t,n,r,i){return e(t,n,r,i)};if(typeof e!=="string"||e.indexOf(".")===-1&&e.indexOf("[")===-1&&e.indexOf("(")===-1)return function(t){return t[e]};var fetchData=function(e,t,n){var r,i,o,l;if(n!==""){var s=_fnSplitObjNotation(n);for(var u=0,f=s.length;u<f;u++){r=s[u].match(h);i=s[u].match(v);if(r){s[u]=s[u].replace(h,"");s[u]!==""&&(e=e[s[u]]);o=[];s.splice(0,u+1);l=s.join(".");if(Array.isArray(e))for(var c=0,d=e.length;c<d;c++)o.push(fetchData(e[c],t,l));var p=r[0].substring(1,r[0].length-1);e=p===""?o:o.join(p);break}if(i){s[u]=s[u].replace(v,"");e=e[s[u]]()}else{if(e===null||e[s[u]]===null)return null;if(e===void 0||e[s[u]]===void 0)return;e=e[s[u]]}}}return e};return function(t,n){return fetchData(t,n,e)}},stripHtml:function(e){var t=typeof e;if(t!=="function")return t==="string"?_stripHtml(e):e;_stripHtml=e},escapeHtml:function(e){var t=typeof e;if(t!=="function")return t==="string"||Array.isArray(e)?_escapeHtml(e):e;_escapeHtml=e},unique:_unique};
/**
 * Create a mapping object that allows camel case parameters to be looked up
 * for their Hungarian counterparts. The mapping is stored in a private
 * parameter called `_hungarianMap` which can be accessed on the source object.
 *  @param {object} o
 *  @memberof DataTable#oApi
 */function _fnHungarianMap(e){var n,r,i="a aa ai ao as b fn i m o s ",o={};t.each(e,(function(t){n=t.match(/^([^A-Z]+?)([A-Z])/);if(n&&i.indexOf(n[1]+" ")!==-1){r=t.replace(n[0],n[2].toLowerCase());o[r]=t;n[1]==="o"&&_fnHungarianMap(e[t])}}));e._hungarianMap=o}
/**
 * Convert from camel case parameters to Hungarian, based on a Hungarian map
 * created by _fnHungarianMap.
 *  @param {object} src The model object which holds all parameters that can be
 *    mapped.
 *  @param {object} user The object to convert from camel case to Hungarian.
 *  @param {boolean} force When set to `true`, properties which already have a
 *    Hungarian value in the `user` object will be overwritten. Otherwise they
 *    won't be.
 *  @memberof DataTable#oApi
 */function _fnCamelToHungarian(e,n,r){e._hungarianMap||_fnHungarianMap(e);var i;t.each(n,(function(o){i=e._hungarianMap[o];if(i!==void 0&&(r||n[i]===void 0))if(i.charAt(0)==="o"){n[i]||(n[i]={});t.extend(true,n[i],n[o]);_fnCamelToHungarian(e[i],n[i],r)}else n[i]=n[o]}))}
/**
 * Map one parameter onto another
 *  @param {object} o Object to map
 *  @param {*} knew The new parameter name
 *  @param {*} old The old parameter name
 */var _fnCompatMap=function(e,t,n){e[t]!==void 0&&(e[n]=e[t])};
/**
 * Provide backwards compatibility for the main DT options. Note that the new
 * options are mapped onto the old parameters, so this is an external interface
 * change only.
 *  @param {object} init Object to map
 */function _fnCompatOpts(e){_fnCompatMap(e,"ordering","bSort");_fnCompatMap(e,"orderMulti","bSortMulti");_fnCompatMap(e,"orderClasses","bSortClasses");_fnCompatMap(e,"orderCellsTop","bSortCellsTop");_fnCompatMap(e,"order","aaSorting");_fnCompatMap(e,"orderFixed","aaSortingFixed");_fnCompatMap(e,"paging","bPaginate");_fnCompatMap(e,"pagingType","sPaginationType");_fnCompatMap(e,"pageLength","iDisplayLength");_fnCompatMap(e,"searching","bFilter");typeof e.sScrollX==="boolean"&&(e.sScrollX=e.sScrollX?"100%":"");typeof e.scrollX==="boolean"&&(e.scrollX=e.scrollX?"100%":"");var t=e.aoSearchCols;if(t)for(var n=0,r=t.length;n<r;n++)t[n]&&_fnCamelToHungarian(DataTable.models.oSearch,t[n]);e.serverSide&&!e.searchDelay&&(e.searchDelay=400)}
/**
 * Provide backwards compatibility for column options. Note that the new options
 * are mapped onto the old parameters, so this is an external interface change
 * only.
 *  @param {object} init Object to map
 */function _fnCompatCols(e){_fnCompatMap(e,"orderable","bSortable");_fnCompatMap(e,"orderData","aDataSort");_fnCompatMap(e,"orderSequence","asSorting");_fnCompatMap(e,"orderDataType","sortDataType");var t=e.aDataSort;typeof t!=="number"||Array.isArray(t)||(e.aDataSort=[t])}
/**
 * Browser feature detection for capabilities, quirks
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnBrowserDetect(e){if(!DataTable.__browser){var n={};DataTable.__browser=n;var r=t("<div/>").css({position:"fixed",top:0,left:-1*window.pageXOffset,height:1,width:1,overflow:"hidden"}).append(t("<div/>").css({position:"absolute",top:1,left:1,width:100,overflow:"scroll"}).append(t("<div/>").css({width:"100%",height:10}))).appendTo("body");var i=r.children();var o=i.children();n.barWidth=i[0].offsetWidth-i[0].clientWidth;n.bScrollbarLeft=Math.round(o.offset().left)!==1;r.remove()}t.extend(e.oBrowser,DataTable.__browser);e.oScroll.iBarWidth=DataTable.__browser.barWidth}
/**
 * Add a column to the list used for the table with default values
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnAddColumn(e){var n=DataTable.defaults.column;var r=e.aoColumns.length;var i=t.extend({},DataTable.models.oColumn,n,{aDataSort:n.aDataSort?n.aDataSort:[r],mData:n.mData?n.mData:r,idx:r,searchFixed:{},colEl:t("<col>").attr("data-dt-column",r)});e.aoColumns.push(i);var o=e.aoPreSearchCols;o[r]=t.extend({},DataTable.models.oSearch,o[r])}
/**
 * Apply options for a column
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iCol column index to consider
 *  @param {object} oOptions object with sType, bVisible and bSearchable etc
 *  @memberof DataTable#oApi
 */function _fnColumnOptions(e,n,r){var i=e.aoColumns[n];if(r!==void 0&&r!==null){_fnCompatCols(r);_fnCamelToHungarian(DataTable.defaults.column,r,true);r.mDataProp===void 0||r.mData||(r.mData=r.mDataProp);r.sType&&(i._sManualType=r.sType);r.className&&!r.sClass&&(r.sClass=r.className);var o=i.sClass;t.extend(i,r);_fnMap(i,r,"sWidth","sWidthOrig");o!==i.sClass&&(i.sClass=o+" "+i.sClass);r.iDataSort!==void 0&&(i.aDataSort=[r.iDataSort]);_fnMap(i,r,"aDataSort")}var l=i.mData;var s=g(l);if(i.mRender&&Array.isArray(i.mRender)){var u=i.mRender.slice();var f=u.shift();i.mRender=DataTable.render[f].apply(window,u)}i._render=i.mRender?g(i.mRender):null;var attrTest=function(e){return typeof e==="string"&&e.indexOf("@")!==-1};i._bAttrSrc=t.isPlainObject(l)&&(attrTest(l.sort)||attrTest(l.type)||attrTest(l.filter));i._setter=null;i.fnGetData=function(e,t,n){var r=s(e,t,void 0,n);return i._render&&t?i._render(r,t,e,n):r};i.fnSetData=function(e,t,n){return m(l)(e,t,n)};typeof l==="number"||i._isArrayHost||(e._rowReadObject=true);e.oFeatures.bSort||(i.bSortable=false)}
/**
 * Adjust the table column widths for new data. Note: you would probably want to
 * do a redraw after calling this function!
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnAdjustColumnSizing(e){_fnCalculateColumnWidths(e);_fnColumnSizes(e);var t=e.oScroll;t.sY===""&&t.sX===""||_fnScrollDraw(e);_fnCallbackFire(e,null,"column-sizing",[e])}
/**
 * Apply column sizes
 *
 * @param {*} settings DataTables settings object
 */function _fnColumnSizes(e){var t=e.aoColumns;for(var n=0;n<t.length;n++){var r=_fnColumnsSumWidth(e,[n],false,false);t[n].colEl.css("width",r)}}
/**
 * Convert the index of a visible column to the index in the data array (take account
 * of hidden columns)
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iMatch Visible column index to lookup
 *  @returns {int} i the data index
 *  @memberof DataTable#oApi
 */function _fnVisibleToColumnIndex(e,t){var n=_fnGetColumns(e,"bVisible");return typeof n[t]==="number"?n[t]:null}
/**
 * Convert the index of an index in the data array and convert it to the visible
 *   column index (take account of hidden columns)
 *  @param {int} iMatch Column index to lookup
 *  @param {object} oSettings dataTables settings object
 *  @returns {int} i the data index
 *  @memberof DataTable#oApi
 */function _fnColumnIndexToVisible(e,t){var n=_fnGetColumns(e,"bVisible");var r=n.indexOf(t);return r!==-1?r:null}
/**
 * Get the number of visible columns
 *  @param {object} oSettings dataTables settings object
 *  @returns {int} i the number of visible columns
 *  @memberof DataTable#oApi
 */function _fnVisbleColumns(e){var n=e.aoHeader;var r=e.aoColumns;var i=0;if(n.length)for(var o=0,l=n[0].length;o<l;o++)r[o].bVisible&&t(n[0][o].cell).css("display")!=="none"&&i++;return i}
/**
 * Get an array of column indexes that match a given property
 *  @param {object} oSettings dataTables settings object
 *  @param {string} sParam Parameter in aoColumns to look for - typically
 *    bVisible or bSearchable
 *  @returns {array} Array of indexes with matched properties
 *  @memberof DataTable#oApi
 */function _fnGetColumns(e,t){var n=[];e.aoColumns.map((function(e,r){e[t]&&n.push(r)}));return n}
/**
 * Calculate the 'type' of a column
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnColumnTypes(e){var t=e.aoColumns;var r=e.aoData;var i=DataTable.ext.type.detect;var o,l,s,u,f,c;var d,p,h;for(o=0,l=t.length;o<l;o++){d=t[o];h=[];if(!d.sType&&d._sManualType)d.sType=d._sManualType;else if(!d.sType){for(s=0,u=i.length;s<u;s++){for(f=0,c=r.length;f<c;f++)if(r[f]){h[f]===void 0&&(h[f]=_fnGetCellData(e,f,o,"type"));p=i[s](h[f],e);if(!p&&s!==i.length-2)break;if(p==="html"&&!_empty(h[f]))break}if(p){d.sType=p;break}}d.sType||(d.sType="string")}var v=n.type.className[d.sType];if(v){_columnAutoClass(e.aoHeader,o,v);_columnAutoClass(e.aoFooter,o,v)}var g=n.type.render[d.sType];if(g&&!d._render){d._render=DataTable.util.get(g);_columnAutoRender(e,o)}}}function _columnAutoRender(e,t){var n=e.aoData;for(var r=0;r<n.length;r++)if(n[r].nTr){var i=_fnGetCellData(e,r,t,"display");n[r].displayData[t]=i;_fnWriteCell(n[r].anCells[t],i)}}function _columnAutoClass(e,t,n){e.forEach((function(e){e[t]&&e[t].unique&&_addClass(e[t].cell,n)}))}
/**
 * Take the column definitions and static columns arrays and calculate how
 * they relate to column indexes. The callback function will then apply the
 * definition found for a column to a suitable configuration object.
 *  @param {object} oSettings dataTables settings object
 *  @param {array} aoColDefs The aoColumnDefs array that is to be applied
 *  @param {array} aoCols The aoColumns array that defines columns individually
 *  @param {array} headerLayout Layout for header as it was loaded
 *  @param {function} fn Callback function - takes two parameters, the calculated
 *    column index and the definition for that column.
 *  @memberof DataTable#oApi
 */function _fnApplyColumnDefs(e,n,r,i,o){var l,s,u,f,c,d,p;var h=e.aoColumns;if(r)for(l=0,s=r.length;l<s;l++)r[l]&&r[l].name&&(h[l].sName=r[l].name);if(n)for(l=n.length-1;l>=0;l--){p=n[l];var v=p.target!==void 0?p.target:p.targets!==void 0?p.targets:p.aTargets;Array.isArray(v)||(v=[v]);for(u=0,f=v.length;u<f;u++){var g=v[u];if(typeof g==="number"&&g>=0){while(h.length<=g)_fnAddColumn(e);o(g,p)}else if(typeof g==="number"&&g<0)o(h.length+g,p);else if(typeof g==="string")for(c=0,d=h.length;c<d;c++)g==="_all"?o(c,p):g.indexOf(":name")!==-1?h[c].sName===g.replace(":name","")&&o(c,p):i.forEach((function(e){if(e[c]){var n=t(e[c].cell);g.match(/^[a-z][\w-]*$/i)&&(g="."+g);n.is(g)&&o(c,p)}}))}}if(r)for(l=0,s=r.length;l<s;l++)o(l,r[l])}
/**
 * Get the width for a given set of columns
 *
 * @param {*} settings DataTables settings object
 * @param {*} targets Columns - comma separated string or array of numbers
 * @param {*} original Use the original width (true) or calculated (false)
 * @param {*} incVisible Include visible columns (true) or not (false)
 * @returns Combined CSS value
 */function _fnColumnsSumWidth(e,t,n,r){Array.isArray(t)||(t=_fnColumnsFromHeader(t));var i=0;var o;var l=e.aoColumns;for(var s=0,u=t.length;s<u;s++){var f=l[t[s]];var c=n?f.sWidthOrig:f.sWidth;if(r||f.bVisible!==false){if(c===null||c===void 0)return null;if(typeof c==="number"){o="px";i+=c}else{var d=c.match(/([\d\.]+)([^\d]*)/);if(d){i+=d[1]*1;o=d.length===3?d[2]:"px"}}}}return i+o}function _fnColumnsFromHeader(e){var n=t(e).closest("[data-dt-column]").attr("data-dt-column");return n?n.split(",").map((function(e){return e*1})):[]}
/**
 * Add a data array to the table, creating DOM node etc. This is the parallel to
 * _fnGatherData, but for adding rows from a Javascript source, rather than a
 * DOM source.
 *  @param {object} settings dataTables settings object
 *  @param {array} data data array to be added
 *  @param {node} [tr] TR element to add to the table - optional. If not given,
 *    DataTables will create a row automatically
 *  @param {array} [tds] Array of TD|TH elements for the row - must be given
 *    if nTr is.
 *  @returns {int} >=0 if successful (index of new aoData entry), -1 if failed
 *  @memberof DataTable#oApi
 */function _fnAddData(e,n,r,i){var o=e.aoData.length;var l=t.extend(true,{},DataTable.models.oRow,{src:r?"dom":"data",idx:o});l._aData=n;e.aoData.push(l);var s=e.aoColumns;for(var u=0,f=s.length;u<f;u++)s[u].sType=null;e.aiDisplayMaster.push(o);var c=e.rowIdFn(n);c!==void 0&&(e.aIds[c]=l);!r&&e.oFeatures.bDeferRender||_fnCreateTr(e,o,r,i);return o}
/**
 * Add one or more TR elements to the table. Generally we'd expect to
 * use this for reading data from a DOM sourced table, but it could be
 * used for an TR element. Note that if a TR is given, it is used (i.e.
 * it is not cloned).
 *  @param {object} settings dataTables settings object
 *  @param {array|node|jQuery} trs The TR element(s) to add to the table
 *  @returns {array} Array of indexes for the added rows
 *  @memberof DataTable#oApi
 */function _fnAddTr(e,n){var r;n instanceof t||(n=t(n));return n.map((function(t,n){r=_fnGetRowElements(e,n);return _fnAddData(e,r.data,n,r.cells)}))}
/**
 * Get the data for a given cell from the internal cache, taking into account data mapping
 *  @param {object} settings dataTables settings object
 *  @param {int} rowIdx aoData row id
 *  @param {int} colIdx Column index
 *  @param {string} type data get type ('display', 'type' 'filter|search' 'sort|order')
 *  @returns {*} Cell data
 *  @memberof DataTable#oApi
 */function _fnGetCellData(e,t,n,r){r==="search"?r="filter":r==="order"&&(r="sort");var i=e.aoData[t];if(i){var o=e.iDraw;var l=e.aoColumns[n];var s=i._aData;var u=l.sDefaultContent;var f=l.fnGetData(s,r,{settings:e,row:t,col:n});r!=="display"&&f&&typeof f==="object"&&f.nodeName&&(f=f.innerHTML);if(f===void 0){if(e.iDrawError!=o&&u===null){_fnLog(e,0,"Requested unknown parameter "+(typeof l.mData=="function"?"{function}":"'"+l.mData+"'")+" for row "+t+", column "+n,4);e.iDrawError=o}return u}if(f!==s&&f!==null||u===null||r===void 0){if(typeof f==="function")return f.call(s)}else f=u;if(f===null&&r==="display")return"";if(r==="filter"){var c=DataTable.ext.type.search;c[l.sType]&&(f=c[l.sType](f))}return f}}
/**
 * Set the value for a specific cell, into the internal data cache
 *  @param {object} settings dataTables settings object
 *  @param {int} rowIdx aoData row id
 *  @param {int} colIdx Column index
 *  @param {*} val Value to set
 *  @memberof DataTable#oApi
 */function _fnSetCellData(e,t,n,r){var i=e.aoColumns[n];var o=e.aoData[t]._aData;i.fnSetData(o,r,{settings:e,row:t,col:n})}
/**
 * Write a value to a cell
 * @param {*} td Cell
 * @param {*} val Value
 */function _fnWriteCell(e,n){n&&typeof n==="object"&&n.nodeName?t(e).empty().append(n):e.innerHTML=n}var h=/\[.*?\]$/;var v=/\(\)$/;
/**
 * Split string on periods, taking into account escaped periods
 * @param  {string} str String to split
 * @return {array} Split string
 */function _fnSplitObjNotation(e){var t=e.match(/(\\.|[^.])+/g)||[""];return t.map((function(e){return e.replace(/\\\./g,".")}))}
/**
 * Return a function that can be used to get data from a source object, taking
 * into account the ability to use nested objects as a source
 *  @param {string|int|function} mSource The data source for the object
 *  @returns {function} Data get function
 *  @memberof DataTable#oApi
 */var g=DataTable.util.get;
/**
 * Return a function that can be used to set data from a source object, taking
 * into account the ability to use nested objects as a source
 *  @param {string|int|function} mSource The data source for the object
 *  @returns {function} Data set function
 *  @memberof DataTable#oApi
 */var m=DataTable.util.set;
/**
 * Return an array with the full table data
 *  @param {object} oSettings dataTables settings object
 *  @returns array {array} aData Master data array
 *  @memberof DataTable#oApi
 */function _fnGetDataMaster(e){return _pluck(e.aoData,"_aData")}
/**
 * Nuke the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnClearTable(e){e.aoData.length=0;e.aiDisplayMaster.length=0;e.aiDisplay.length=0;e.aIds={}}
/**
 * Mark cached data as invalid such that a re-read of the data will occur when
 * the cached data is next requested. Also update from the data source object.
 *
 * @param {object} settings DataTables settings object
 * @param {int}    rowIdx   Row index to invalidate
 * @param {string} [src]    Source to invalidate from: undefined, 'auto', 'dom'
 *     or 'data'
 * @param {int}    [colIdx] Column index to invalidate. If undefined the whole
 *     row will be invalidated
 * @memberof DataTable#oApi
 *
 * @todo For the modularisation of v1.11 this will need to become a callback, so
 *   the sort and filter methods can subscribe to it. That will required
 *   initialisation options for sorting, which is why it is not already baked in
 */function _fnInvalidate(e,t,n,r){var i=e.aoData[t];var o,l;i._aSortData=null;i._aFilterData=null;i.displayData=null;if(n!=="dom"&&(n&&n!=="auto"||i.src!=="dom")){var s=i.anCells;var u=_fnGetRowDisplay(e,t);if(s)if(r!==void 0)_fnWriteCell(s[r],u[r]);else for(o=0,l=s.length;o<l;o++)_fnWriteCell(s[o],u[o])}else i._aData=_fnGetRowElements(e,i,r,r===void 0?void 0:i._aData).data;var f=e.aoColumns;if(r!==void 0){f[r].sType=null;f[r].maxLenString=null}else{for(o=0,l=f.length;o<l;o++){f[o].sType=null;f[o].maxLenString=null}_fnRowAttributes(e,i)}}
/**
 * Build a data source object from an HTML row, reading the contents of the
 * cells that are in the row.
 *
 * @param {object} settings DataTables settings object
 * @param {node|object} TR element from which to read data or existing row
 *   object from which to re-read the data from the cells
 * @param {int} [colIdx] Optional column index
 * @param {array|object} [d] Data source object. If `colIdx` is given then this
 *   parameter should also be given and will be used to write the data into.
 *   Only the column in question will be written
 * @returns {object} Object with two parameters: `data` the data read, in
 *   document order, and `cells` and array of nodes (they can be useful to the
 *   caller, so rather than needing a second traversal to get them, just return
 *   them from here).
 * @memberof DataTable#oApi
 */function _fnGetRowElements(e,t,n,r){var i,o,l,s=[],u=t.firstChild,f=0,c=e.aoColumns,d=e._rowReadObject;r=r!==void 0?r:d?{}:[];var attr=function(e,t){if(typeof e==="string"){var n=e.indexOf("@");if(n!==-1){var i=e.substring(n+1);var o=m(e);o(r,t.getAttribute(i))}}};var cellProcess=function(e){if(n===void 0||n===f){o=c[f];l=e.innerHTML.trim();if(o&&o._bAttrSrc){var t=m(o.mData._);t(r,l);attr(o.mData.sort,e);attr(o.mData.type,e);attr(o.mData.filter,e)}else if(d){o._setter||(o._setter=m(o.mData));o._setter(r,l)}else r[f]=l}f++};if(u)while(u){i=u.nodeName.toUpperCase();if(i=="TD"||i=="TH"){cellProcess(u);s.push(u)}u=u.nextSibling}else{s=t.anCells;for(var p=0,h=s.length;p<h;p++)cellProcess(s[p])}var v=t.firstChild?t:t.nTr;if(v){var g=v.getAttribute("id");g&&m(e.rowId)(r,g)}return{data:r,cells:s}}
/**
 * Render and cache a row's display data for the columns, if required
 * @returns 
 */function _fnGetRowDisplay(e,t){let n=e.aoData[t];let r=e.aoColumns;if(!n.displayData){n.displayData=[];for(var i=0,o=r.length;i<o;i++)n.displayData.push(_fnGetCellData(e,t,i,"display"))}return n.displayData}
/**
 * Create a new TR element (and it's TD children) for a row
 *  @param {object} oSettings dataTables settings object
 *  @param {int} iRow Row to consider
 *  @param {node} [nTrIn] TR element to add to the table - optional. If not given,
 *    DataTables will create a row automatically
 *  @param {array} [anTds] Array of TD|TH elements for the row - must be given
 *    if nTr is.
 *  @memberof DataTable#oApi
 */function _fnCreateTr(e,n,r,i){var o,l,s,u,f,c,d=e.aoData[n],p=d._aData,h=[],v=e.oClasses.tbody.row;if(d.nTr===null){o=r||document.createElement("tr");d.nTr=o;d.anCells=h;_addClass(o,v);o._DT_RowIndex=n;_fnRowAttributes(e,d);for(u=0,f=e.aoColumns.length;u<f;u++){s=e.aoColumns[u];c=!r||!i[u];l=c?document.createElement(s.sCellType):i[u];l||_fnLog(e,0,"Incorrect column count",18);l._DT_CellIndex={row:n,column:u};h.push(l);var g=_fnGetRowDisplay(e,n);!c&&(!s.mRender&&s.mData===u||t.isPlainObject(s.mData)&&s.mData._===u+".display")||_fnWriteCell(l,g[u]);s.bVisible&&c?o.appendChild(l):s.bVisible||c||l.parentNode.removeChild(l);s.fnCreatedCell&&s.fnCreatedCell.call(e.oInstance,l,_fnGetCellData(e,n,u),p,n,u)}_fnCallbackFire(e,"aoRowCreatedCallback","row-created",[o,p,n,h])}else _addClass(d.nTr,v)}
/**
 * Add attributes to a row based on the special `DT_*` parameters in a data
 * source object.
 *  @param {object} settings DataTables settings object
 *  @param {object} DataTables row object for the row to be modified
 *  @memberof DataTable#oApi
 */function _fnRowAttributes(e,n){var r=n.nTr;var i=n._aData;if(r){var o=e.rowIdFn(i);o&&(r.id=o);if(i.DT_RowClass){var l=i.DT_RowClass.split(" ");n.__rowc=n.__rowc?_unique(n.__rowc.concat(l)):l;t(r).removeClass(n.__rowc.join(" ")).addClass(i.DT_RowClass)}i.DT_RowAttr&&t(r).attr(i.DT_RowAttr);i.DT_RowData&&t(r).data(i.DT_RowData)}}
/**
 * Create the HTML header for the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnBuildHead(e,n){var r=e.oClasses;var i=e.aoColumns;var o,l,s;var u=n==="header"?e.nTHead:e.nTFoot;var f=n==="header"?"sTitle":n;if(u){if(n==="header"||_pluck(e.aoColumns,f).join("")){s=t("tr",u);s.length||(s=t("<tr/>").appendTo(u));if(s.length===1){var c=t("td, th",s);for(o=c.length,l=i.length;o<l;o++)t("<th/>").html(i[o][f]||"").appendTo(s)}}var d=_fnDetectHeader(e,u,true);n==="header"?e.aoHeader=d:e.aoFooter=d;t(u).children("tr").attr("role","row");t(u).children("tr").children("th, td").each((function(){_fnRenderer(e,n)(e,t(this),r)}))}}
/**
 * Build a layout structure for a header or footer
 *
 * @param {*} settings DataTables settings
 * @param {*} source Source layout array
 * @param {*} incColumns What columns should be included
 * @returns Layout array
 */function _fnHeaderLayout(e,n,r){var i,o,l;var s=[];var u=[];var f=e.aoColumns;var c=f.length;var d,p;if(n){r||(r=_range(c).filter((function(e){return f[e].bVisible})));for(i=0;i<n.length;i++){s[i]=n[i].slice().filter((function(e,t){return r.includes(t)}));u.push([])}for(i=0;i<s.length;i++)for(o=0;o<s[i].length;o++){d=1;p=1;if(u[i][o]===void 0){l=s[i][o].cell;while(s[i+d]!==void 0&&s[i][o].cell==s[i+d][o].cell){u[i+d][o]=null;d++}while(s[i][o+p]!==void 0&&s[i][o].cell==s[i][o+p].cell){for(var h=0;h<d;h++)u[i+h][o+p]=null;p++}var v=t("span.dt-column-title",l);u[i][o]={cell:l,colspan:p,rowspan:d,title:v.length?v.html():t(l).html()}}}return u}}
/**
 * Draw the header (or footer) element based on the column visibility states.
 *
 *  @param object oSettings dataTables settings object
 *  @param array aoSource Layout array from _fnDetectHeader
 *  @memberof DataTable#oApi
 */function _fnDrawHead(e,n){var r=_fnHeaderLayout(e,n);var i,o;for(var l=0;l<n.length;l++){i=n[l].row;if(i)while(o=i.firstChild)i.removeChild(o);for(var s=0;s<r[l].length;s++){var u=r[l][s];u&&t(u.cell).appendTo(i).attr("rowspan",u.rowspan).attr("colspan",u.colspan)}}}
/**
 * Insert the required TR nodes into the table for display
 *  @param {object} oSettings dataTables settings object
 *  @param ajaxComplete true after ajax call to complete rendering
 *  @memberof DataTable#oApi
 */function _fnDraw(e,r){_fnStart(e);var i=_fnCallbackFire(e,"aoPreDrawCallback","preDraw",[e]);if(i.indexOf(false)===-1){var o=[];var l=0;var s=_fnDataSource(e)=="ssp";var u=e.aiDisplay;var f=e._iDisplayStart;var c=e.fnDisplayEnd();var d=e.aoColumns;var p=t(e.nTBody);e.bDrawing=true;if(s){if(!e.bDestroying&&!r){e.iDraw===0&&p.empty().append(_emptyRow(e));_fnAjaxUpdate(e);return}}else e.iDraw++;if(u.length!==0){var h=s?0:f;var v=s?e.aoData.length:c;for(var g=h;g<v;g++){var m=u[g];var _=e.aoData[m];_.nTr===null&&_fnCreateTr(e,m);var b=_.nTr;for(var y=0;y<d.length;y++){var D=d[y];var C=_.anCells[y];_addClass(C,n.type.className[D.sType]);_addClass(C,D.sClass);_addClass(C,e.oClasses.tbody.cell)}_fnCallbackFire(e,"aoRowCallback",null,[b,_._aData,l,g,m]);o.push(b);l++}}else o[0]=_emptyRow(e);_fnCallbackFire(e,"aoHeaderCallback","header",[t(e.nTHead).children("tr")[0],_fnGetDataMaster(e),f,c,u]);_fnCallbackFire(e,"aoFooterCallback","footer",[t(e.nTFoot).children("tr")[0],_fnGetDataMaster(e),f,c,u]);if(p[0].replaceChildren)p[0].replaceChildren.apply(p[0],o);else{p.children().detach();p.append(t(o))}t(e.nTableWrapper).toggleClass("dt-empty-footer",t("tr",e.nTFoot).length===0);_fnCallbackFire(e,"aoDrawCallback","draw",[e],true);e.bSorted=false;e.bFiltered=false;e.bDrawing=false}else _fnProcessingDisplay(e,false)}
/**
 * Redraw the table - taking account of the various features which are enabled
 *  @param {object} oSettings dataTables settings object
 *  @param {boolean} [holdPosition] Keep the current paging position. By default
 *    the paging is reset to the first page
 *  @memberof DataTable#oApi
 */function _fnReDraw(e,t,n){var r=e.oFeatures,i=r.bSort,o=r.bFilter;if(n===void 0||n===true){i&&_fnSort(e);o?_fnFilterComplete(e,e.oPreviousSearch):e.aiDisplay=e.aiDisplayMaster.slice()}t!==true&&(e._iDisplayStart=0);e._drawHold=t;_fnDraw(e);e._drawHold=false}function _emptyRow(e){var n=e.oLanguage;var r=n.sZeroRecords;var i=_fnDataSource(e);e.iDraw<1&&i==="ssp"||e.iDraw<=1&&i==="ajax"?r=n.sLoadingRecords:n.sEmptyTable&&e.fnRecordsTotal()===0&&(r=n.sEmptyTable);return t("<tr/>").append(t("<td />",{colSpan:_fnVisbleColumns(e),class:e.oClasses.empty.row}).html(r))[0]}
/**
 * Convert a `layout` object given by a user to the object structure needed
 * for the renderer. This is done twice, once for above and once for below
 * the table. Ordering must also be considered.
 *
 * @param {*} settings DataTables settings object
 * @param {*} layout Layout object to convert
 * @param {string} side `top` or `bottom`
 * @returns Converted array structure - one item for each row.
 */function _layoutArray(e,n,r){var i={};t.each(n,(function(e,n){if(n!==null){var r=e.replace(/([A-Z])/g," $1").split(" ");i[r[0]]||(i[r[0]]={});var o=r.length===1?"full":r[1].toLowerCase();var l=i[r[0]];var groupRun=function(e,n){t.isPlainObject(n)?Object.keys(n).map((function(t){e.push({feature:t,opts:n[t]})})):e.push(n)};l[o]&&l[o].contents||(l[o]={contents:[]});if(Array.isArray(n))for(var s=0;s<n.length;s++)groupRun(l[o].contents,n[s]);else groupRun(l[o].contents,n);Array.isArray(l[o].contents)||(l[o].contents=[l[o].contents])}}));var o=Object.keys(i).map((function(e){return e.indexOf(r)!==0?null:{name:e,val:i[e]}})).filter((function(e){return e!==null}));o.sort((function(e,t){var n=e.name.replace(/[^0-9]/g,"")*1;var r=t.name.replace(/[^0-9]/g,"")*1;return r-n}));r==="bottom"&&o.reverse();var l=[];for(var s=0,u=o.length;s<u;s++){if(o[s].val.full){l.push({full:o[s].val.full});_layoutResolve(e,l[l.length-1]);delete o[s].val.full}if(Object.keys(o[s].val).length){l.push(o[s].val);_layoutResolve(e,l[l.length-1])}}return l}
/**
 * Convert the contents of a row's layout object to nodes that can be inserted
 * into the document by a renderer. Execute functions, look up plug-ins, etc.
 *
 * @param {*} settings DataTables settings object
 * @param {*} row Layout object for this row
 */function _layoutResolve(e,r){var getFeature=function(t,r){n.features[t]||_fnLog(e,0,"Unknown feature: "+t);return n.features[t].apply(this,[e,r])};var resolve=function(n){var i=r[n].contents;for(var o=0,l=i.length;o<l;o++)if(i[o])if(typeof i[o]==="string")i[o]=getFeature(i[o],null);else if(t.isPlainObject(i[o]))i[o]=getFeature(i[o].feature,i[o].opts);else if(typeof i[o].node==="function")i[o]=i[o].node(e);else if(typeof i[o]==="function"){var s=i[o](e);i[o]=typeof s.node==="function"?s.node():s}};t.each(r,(function(e){resolve(e)}))}
/**
 * Add the options to the page HTML for the table
 *  @param {object} settings DataTables settings object
 *  @memberof DataTable#oApi
 */function _fnAddOptionsHtml(e){var n=e.oClasses;var r=t(e.nTable);var i=t("<div/>").attr({id:e.sTableId+"_wrapper",class:n.container}).insertBefore(r);e.nTableWrapper=i[0];if(e.sDom)_fnLayoutDom(e,e.sDom,i);else{var o=_layoutArray(e,e.layout,"top");var l=_layoutArray(e,e.layout,"bottom");var s=_fnRenderer(e,"layout");o.forEach((function(t){s(e,i,t)}));s(e,i,{full:{table:true,contents:[_fnFeatureHtmlTable(e)]}});l.forEach((function(t){s(e,i,t)}))}_processingHtml(e)}
/**
 * Draw the table with the legacy DOM property
 * @param {*} settings DT settings object
 * @param {*} dom DOM string
 * @param {*} insert Insert point
 */function _fnLayoutDom(e,n,r){var i=n.match(/(".*?")|('.*?')|./g);var o,l,s,u,f;for(var c=0;c<i.length;c++){o=null;l=i[c];if(l=="<"){s=t("<div/>");u=i[c+1];if(u[0]=="'"||u[0]=='"'){f=u.replace(/['"]/g,"");var d,p="";if(f.indexOf(".")!=-1){var h=f.split(".");p=h[0];d=h[1]}else f[0]=="#"?p=f:d=f;s.attr("id",p.substring(1)).addClass(d);c++}r.append(s);r=s}else l==">"?r=r.parent():l=="t"?o=_fnFeatureHtmlTable(e):DataTable.ext.feature.forEach((function(t){l==t.cFeature&&(o=t.fnInit(e))}));o&&r.append(o)}}
/**
 * Use the DOM source to create up an array of header cells. The idea here is to
 * create a layout grid (array) of rows x columns, which contains a reference
 * to the cell that that point in the grid (regardless of col/rowspan), such that
 * any column / row could be removed and the new grid constructed
 *  @param {node} thead The header/footer element for the table
 *  @returns {array} Calculated layout array
 *  @memberof DataTable#oApi
 */function _fnDetectHeader(e,n,r){var i=e.aoColumns;var o=t(n).children("tr");var l,s;var u,f,c,d,p,h,v,g;var m=n&&n.nodeName.toLowerCase()==="thead";var _=[];var b;var shift=function(e,t,n){var r=e[t];while(r[n])n++;return n};for(u=0,d=o.length;u<d;u++)_.push([]);for(u=0,d=o.length;u<d;u++){l=o[u];h=0;s=l.firstChild;while(s){if(s.nodeName.toUpperCase()=="TD"||s.nodeName.toUpperCase()=="TH"){var y=[];v=s.getAttribute("colspan")*1;g=s.getAttribute("rowspan")*1;v=v&&v!==0&&v!==1?v:1;g=g&&g!==0&&g!==1?g:1;p=shift(_,u,h);b=v===1;if(r){if(b){_fnColumnOptions(e,p,t(s).data());var D=i[p];var C=s.getAttribute("width")||null;var S=s.style.width.match(/width:\s*(\d+[pxem%]+)/);S&&(C=S[1]);D.sWidthOrig=D.sWidth||C;if(m){D.sTitle===null||D.autoTitle||(s.innerHTML=D.sTitle);if(!D.sTitle&&b){D.sTitle=_stripHtml(s.innerHTML);D.autoTitle=true}}else D.footer&&(s.innerHTML=D.footer);D.ariaTitle||(D.ariaTitle=t(s).attr("aria-label")||D.sTitle);D.className&&t(s).addClass(D.className)}t("span.dt-column-title",s).length===0&&t("<span>").addClass("dt-column-title").append(s.childNodes).appendTo(s);m&&t("span.dt-column-order",s).length===0&&t("<span>").addClass("dt-column-order").appendTo(s)}for(c=0;c<v;c++){for(f=0;f<g;f++){_[u+f][p+c]={cell:s,unique:b};_[u+f].row=l}y.push(p+c)}s.setAttribute("data-dt-column",_unique(y).join(","))}s=s.nextSibling}}return _}
/**
 * Set the start position for draw
 *  @param {object} oSettings dataTables settings object
 */function _fnStart(e){var t=_fnDataSource(e)=="ssp";var n=e.iInitDisplayStart;if(n!==void 0&&n!==-1){e._iDisplayStart=t?n:n>=e.fnRecordsDisplay()?0:n;e.iInitDisplayStart=-1}}
/**
 * Create an Ajax call based on the table's settings, taking into account that
 * parameters can have multiple forms, and backwards compatibility.
 *
 * @param {object} oSettings dataTables settings object
 * @param {array} data Data to send to the server, required by
 *     DataTables - may be augmented by developer callbacks
 * @param {function} fn Callback function to run when data is obtained
 */function _fnBuildAjax(e,n,r){var i;var o=e.ajax;var l=e.oInstance;var callback=function(t){var n=e.jqXHR?e.jqXHR.status:null;if(t===null||typeof n==="number"&&n==204){t={};_fnAjaxDataSrc(e,t,[])}var i=t.error||t.sError;i&&_fnLog(e,0,i);e.json=t;_fnCallbackFire(e,null,"xhr",[e,t,e.jqXHR],true);r(t)};if(t.isPlainObject(o)&&o.data){i=o.data;var s=typeof i==="function"?i(n,e):i;n=typeof i==="function"&&s?s:t.extend(true,n,s);delete o.data}var u={url:typeof o==="string"?o:"",data:n,success:callback,dataType:"json",cache:false,type:e.sServerMethod,error:function(t,n){var r=_fnCallbackFire(e,null,"xhr",[e,null,e.jqXHR],true);r.indexOf(true)===-1&&(n=="parsererror"?_fnLog(e,0,"Invalid JSON response",1):t.readyState===4&&_fnLog(e,0,"Ajax error",7));_fnProcessingDisplay(e,false)}};t.isPlainObject(o)&&t.extend(u,o);e.oAjaxData=n;_fnCallbackFire(e,null,"preXhr",[e,n,u],true);if(typeof o==="function")e.jqXHR=o.call(l,n,callback,e);else if(o.url===""){var f={};DataTable.util.set(o.dataSrc)(f,[]);callback(f)}else{e.jqXHR=t.ajax(u);i&&(o.data=i)}}
/**
 * Update the table using an Ajax call
 *  @param {object} settings dataTables settings object
 *  @returns {boolean} Block the table drawing or not
 *  @memberof DataTable#oApi
 */function _fnAjaxUpdate(e){e.iDraw++;_fnProcessingDisplay(e,true);_fnBuildAjax(e,_fnAjaxParameters(e),(function(t){_fnAjaxUpdateDraw(e,t)}))}
/**
 * Build up the parameters in an object needed for a server-side processing
 * request.
 *  @param {object} oSettings dataTables settings object
 *  @returns {bool} block the table drawing or not
 *  @memberof DataTable#oApi
 */function _fnAjaxParameters(e){var t=e.aoColumns,n=e.oFeatures,r=e.oPreviousSearch,i=e.aoPreSearchCols,colData=function(e,n){return typeof t[e][n]==="function"?"function":t[e][n]};return{draw:e.iDraw,columns:t.map((function(e,t){return{data:colData(t,"mData"),name:e.sName,searchable:e.bSearchable,orderable:e.bSortable,search:{value:i[t].search,regex:i[t].regex,fixed:Object.keys(e.searchFixed).map((function(t){return{name:t,term:e.searchFixed[t].toString()}}))}}})),order:_fnSortFlatten(e).map((function(e){return{column:e.col,dir:e.dir,name:colData(e.col,"sName")}})),start:e._iDisplayStart,length:n.bPaginate?e._iDisplayLength:-1,search:{value:r.search,regex:r.regex,fixed:Object.keys(e.searchFixed).map((function(t){return{name:t,term:e.searchFixed[t].toString()}}))}}}
/**
 * Data the data from the server (nuking the old) and redraw the table
 *  @param {object} oSettings dataTables settings object
 *  @param {object} json json data return from the server.
 *  @param {string} json.sEcho Tracking flag for DataTables to match requests
 *  @param {int} json.iTotalRecords Number of records in the data set, not accounting for filtering
 *  @param {int} json.iTotalDisplayRecords Number of records in the data set, accounting for filtering
 *  @param {array} json.aaData The data to display on this page
 *  @param {string} [json.sColumns] Column ordering (sName, comma separated)
 *  @memberof DataTable#oApi
 */function _fnAjaxUpdateDraw(e,t){var n=_fnAjaxDataSrc(e,t);var r=_fnAjaxDataSrcParam(e,"draw",t);var i=_fnAjaxDataSrcParam(e,"recordsTotal",t);var o=_fnAjaxDataSrcParam(e,"recordsFiltered",t);if(r!==void 0){if(r*1<e.iDraw)return;e.iDraw=r*1}n||(n=[]);_fnClearTable(e);e._iRecordsTotal=parseInt(i,10);e._iRecordsDisplay=parseInt(o,10);for(var l=0,s=n.length;l<s;l++)_fnAddData(e,n[l]);e.aiDisplay=e.aiDisplayMaster.slice();_fnDraw(e,true);_fnInitComplete(e);_fnProcessingDisplay(e,false)}
/**
 * Get the data from the JSON data source to use for drawing a table. Using
 * `_fnGetObjectDataFn` allows the data to be sourced from a property of the
 * source object, or from a processing function.
 *  @param {object} settings dataTables settings object
 *  @param  {object} json Data source object / array from the server
 *  @return {array} Array of data to use
 */function _fnAjaxDataSrc(e,n,r){var i="data";if(t.isPlainObject(e.ajax)&&e.ajax.dataSrc!==void 0){var o=e.ajax.dataSrc;typeof o==="string"||typeof o==="function"?i=o:o.data!==void 0&&(i=o.data)}if(!r)return i==="data"?n.aaData||n[i]:i!==""?g(i)(n):n;m(i)(n,r)}
/**
 * Very similar to _fnAjaxDataSrc, but for the other SSP properties
 * @param {*} settings DataTables settings object
 * @param {*} param Target parameter
 * @param {*} json JSON data
 * @returns Resolved value
 */function _fnAjaxDataSrcParam(e,n,r){var i=t.isPlainObject(e.ajax)?e.ajax.dataSrc:null;if(i&&i[n])return g(i[n])(r);var o="";n==="draw"?o="sEcho":n==="recordsTotal"?o="iTotalRecords":n==="recordsFiltered"&&(o="iTotalDisplayRecords");return r[o]!==void 0?r[o]:r[n]}
/**
 * Filter the table using both the global filter and column based filtering
 *  @param {object} settings dataTables settings object
 *  @param {object} input search information
 *  @memberof DataTable#oApi
 */function _fnFilterComplete(e,n){var r=e.aoPreSearchCols;_fnColumnTypes(e);if(_fnDataSource(e)!="ssp"){_fnFilterData(e);e.aiDisplay=e.aiDisplayMaster.slice();_fnFilter(e.aiDisplay,e,n.search,n);t.each(e.searchFixed,(function(t,n){_fnFilter(e.aiDisplay,e,n,{})}));for(var i=0;i<r.length;i++){var o=r[i];_fnFilter(e.aiDisplay,e,o.search,o,i);t.each(e.aoColumns[i].searchFixed,(function(t,n){_fnFilter(e.aiDisplay,e,n,{},i)}))}_fnFilterCustom(e)}e.bFiltered=true;_fnCallbackFire(e,null,"search",[e])}
/**
 * Apply custom filtering functions
 * 
 * This is legacy now that we have named functions, but it is widely used
 * from 1.x, so it is not yet deprecated.
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnFilterCustom(e){var t=DataTable.ext.search;var n=e.aiDisplay;var r,i;for(var o=0,l=t.length;o<l;o++){var s=[];for(var u=0,f=n.length;u<f;u++){i=n[u];r=e.aoData[i];t[o](e,r._aFilterData,i,r._aData,u)&&s.push(i)}n.length=0;n.push.apply(n,s)}}function _fnFilter(e,t,n,r,i){if(n!==""){var o=0;var l=[];var s=typeof n==="function"?n:null;var u=n instanceof RegExp?n:s?null:_fnFilterCreateSearch(n,r);for(o=0;o<e.length;o++){var f=t.aoData[e[o]];var c=i===void 0?f._sFilterRow:f._aFilterData[i];(s&&s(c,f._aData,e[o],i)||u&&u.test(c))&&l.push(e[o])}e.length=l.length;for(o=0;o<l.length;o++)e[o]=l[o]}}
/**
 * Build a regular expression object suitable for searching a table
 *  @param {string} sSearch string to search for
 *  @param {bool} bRegex treat as a regular expression or not
 *  @param {bool} bSmart perform smart filtering or not
 *  @param {bool} bCaseInsensitive Do case insensitive matching or not
 *  @returns {RegExp} constructed object
 *  @memberof DataTable#oApi
 */function _fnFilterCreateSearch(e,n){var r=[];var i=t.extend({},{boundary:false,caseInsensitive:true,exact:false,regex:false,smart:true},n);typeof e!=="string"&&(e=e.toString());e=_normalize(e);if(i.exact)return new RegExp("^"+_(e)+"$",i.caseInsensitive?"i":"");e=i.regex?e:_(e);if(i.smart){var o=e.match(/!?["\u201C][^"\u201D]+["\u201D]|[^ ]+/g)||[""];var l=o.map((function(e){var t=false;var n;if(e.charAt(0)==="!"){t=true;e=e.substring(1)}if(e.charAt(0)==='"'){n=e.match(/^"(.*)"$/);e=n?n[1]:e}else if(e.charAt(0)==="“"){n=e.match(/^\u201C(.*)\u201D$/);e=n?n[1]:e}if(t){e.length>1&&r.push("(?!"+e+")");e=""}return e.replace(/"/g,"")}));var s=r.length?r.join(""):"";var u=i.boundary?"\\b":"";e="^(?=.*?"+u+l.join(")(?=.*?"+u)+")("+s+".)*$"}return new RegExp(e,i.caseInsensitive?"i":"")}
/**
 * Escape a string such that it can be used in a regular expression
 *  @param {string} sVal string to escape
 *  @returns {string} escaped string
 *  @memberof DataTable#oApi
 */var _=DataTable.util.escapeRegex;var b=t("<div>")[0];var y=b.textContent!==void 0;function _fnFilterData(e){var t=e.aoColumns;var n=e.aoData;var r;var i,o,l,s,u;var f=false;for(var c=0;c<n.length;c++)if(n[c]){u=n[c];if(!u._aFilterData){l=[];for(i=0,o=t.length;i<o;i++){r=t[i];if(r.bSearchable){s=_fnGetCellData(e,c,i,"filter");s===null&&(s="");typeof s!=="string"&&s.toString&&(s=s.toString())}else s="";if(s.indexOf&&s.indexOf("&")!==-1){b.innerHTML=s;s=y?b.textContent:b.innerText}s.replace&&(s=s.replace(/[\r\n\u2028]/g,""));l.push(s)}u._aFilterData=l;u._sFilterRow=l.join("  ");f=true}}return f}
/**
 * Draw the table for the first time, adding all required features
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnInitialise(e){var t,n=e.iInitDisplayStart;if(e.bInitialised){_fnBuildHead(e,"header");_fnBuildHead(e,"footer");_fnDrawHead(e,e.aoHeader);_fnDrawHead(e,e.aoFooter);_fnAddOptionsHtml(e);_fnSortInit(e);_colGroup(e);_fnProcessingDisplay(e,true);_fnCallbackFire(e,null,"preInit",[e],true);_fnReDraw(e);var r=_fnDataSource(e);if(r!="ssp")if(r=="ajax")_fnBuildAjax(e,{},(function(r){var i=_fnAjaxDataSrc(e,r);for(t=0;t<i.length;t++)_fnAddData(e,i[t]);e.iInitDisplayStart=n;_fnReDraw(e);_fnProcessingDisplay(e,false);_fnInitComplete(e)}),e);else{_fnInitComplete(e);_fnProcessingDisplay(e,false)}}else setTimeout((function(){_fnInitialise(e)}),200)}
/**
 * Draw the table for the first time, adding all required features
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnInitComplete(e){if(!e._bInitComplete){var t=[e,e.json];e._bInitComplete=true;_fnAdjustColumnSizing(e);_fnCallbackFire(e,null,"plugin-init",t,true);_fnCallbackFire(e,"aoInitComplete","init",t,true)}}function _fnLengthChange(e,t){var n=parseInt(t,10);e._iDisplayLength=n;_fnLengthOverflow(e);_fnCallbackFire(e,null,"length",[e,n])}
/**
 * Alter the display settings to change the page
 *  @param {object} settings DataTables settings object
 *  @param {string|int} action Paging action to take: "first", "previous",
 *    "next" or "last" or page number to jump to (integer)
 *  @param [bool] redraw Automatically draw the update or not
 *  @returns {bool} true page has changed, false - no change
 *  @memberof DataTable#oApi
 */function _fnPageChange(e,t,n){var r=e._iDisplayStart,i=e._iDisplayLength,o=e.fnRecordsDisplay();if(o===0||i===-1)r=0;else if(typeof t==="number"){r=t*i;r>o&&(r=0)}else if(t=="first")r=0;else if(t=="previous"){r=i>=0?r-i:0;r<0&&(r=0)}else if(t=="next")r+i<o&&(r+=i);else if(t=="last")r=Math.floor((o-1)/i)*i;else{if(t==="ellipsis")return;_fnLog(e,0,"Unknown paging action: "+t,5)}var l=e._iDisplayStart!==r;e._iDisplayStart=r;_fnCallbackFire(e,null,l?"page":"page-nc",[e]);l&&n&&_fnDraw(e);return l}
/**
 * Generate the node required for the processing node
 *  @param {object} settings DataTables settings object
 */function _processingHtml(e){var n=e.nTable;var r=e.oScroll.sX!==""||e.oScroll.sY!=="";if(e.oFeatures.bProcessing){var i=t("<div/>",{id:e.sTableId+"_processing",class:e.oClasses.processing.container,role:"status"}).html(e.oLanguage.sProcessing).append("<div><div></div><div></div><div></div><div></div></div>");r?i.prependTo(t("div.dt-scroll",e.nTableWrapper)):i.insertBefore(n);t(n).on("processing.dt.DT",(function(e,t,n){i.css("display",n?"block":"none")}))}}
/**
 * Display or hide the processing indicator
 *  @param {object} settings DataTables settings object
 *  @param {bool} show Show the processing indicator (true) or not (false)
 */function _fnProcessingDisplay(e,t){_fnCallbackFire(e,null,"processing",[e,t])}
/**
 * Add any control elements for the table - specifically scrolling
 *  @param {object} settings dataTables settings object
 *  @returns {node} Node to add to the DOM
 *  @memberof DataTable#oApi
 */function _fnFeatureHtmlTable(e){var n=t(e.nTable);var r=e.oScroll;if(r.sX===""&&r.sY==="")return e.nTable;var i=r.sX;var o=r.sY;var l=e.oClasses.scrolling;var s=e.captionNode;var u=s?s._captionSide:null;var f=t(n[0].cloneNode(false));var c=t(n[0].cloneNode(false));var d=n.children("tfoot");var p="<div/>";var size=function(e){return e?_fnStringToCss(e):null};d.length||(d=null);var h=t(p,{class:l.container}).append(t(p,{class:l.header.self}).css({overflow:"hidden",position:"relative",border:0,width:i?size(i):"100%"}).append(t(p,{class:l.header.inner}).css({"box-sizing":"content-box",width:r.sXInner||"100%"}).append(f.removeAttr("id").css("margin-left",0).append(u==="top"?s:null).append(n.children("thead"))))).append(t(p,{class:l.body}).css({position:"relative",overflow:"auto",width:size(i)}).append(n));d&&h.append(t(p,{class:l.footer.self}).css({overflow:"hidden",border:0,width:i?size(i):"100%"}).append(t(p,{class:l.footer.inner}).append(c.removeAttr("id").css("margin-left",0).append(u==="bottom"?s:null).append(n.children("tfoot")))));var v=h.children();var g=v[0];var m=v[1];var _=d?v[2]:null;t(m).on("scroll.DT",(function(){var e=this.scrollLeft;g.scrollLeft=e;d&&(_.scrollLeft=e)}));t("th, td",g).on("focus",(function(){var e=g.scrollLeft;m.scrollLeft=e;d&&(m.scrollLeft=e)}));t(m).css("max-height",o);r.bCollapse||t(m).css("height",o);e.nScrollHead=g;e.nScrollBody=m;e.nScrollFoot=_;e.aoDrawCallback.push(_fnScrollDraw);return h[0]}
/**
 * Update the header, footer and body tables for resizing - i.e. column
 * alignment.
 *
 * Welcome to the most horrible function DataTables. The process that this
 * function follows is basically:
 *   1. Re-create the table inside the scrolling div
 *   2. Correct colgroup > col values if needed
 *   3. Copy colgroup > col over to header and footer
 *   4. Clean up
 *
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnScrollDraw(e){var n,r,i=e.oScroll,o=i.iBarWidth,l=t(e.nScrollHead),s=l.children("div"),u=s.children("table"),f=e.nScrollBody,c=t(f),d=t(e.nScrollFoot),p=d.children("div"),h=p.children("table"),v=t(e.nTHead),g=t(e.nTable),m=e.nTFoot&&t("th, td",e.nTFoot).length?t(e.nTFoot):null,_=e.oBrowser;var b=f.scrollHeight>f.clientHeight;if(e.scrollBarVis===b||e.scrollBarVis===void 0){e.scrollBarVis=b;g.children("thead, tfoot").remove();n=v.clone().prependTo(g);n.find("th, td").removeAttr("tabindex");n.find("[id]").removeAttr("id");if(m){r=m.clone().prependTo(g);r.find("[id]").removeAttr("id")}if(e.aiDisplay.length){var y=g.children("tbody").eq(0).children("tr").eq(0).children("th, td").map((function(n){return{idx:_fnVisibleToColumnIndex(e,n),width:t(this).outerWidth()}}));for(var D=0;D<y.length;D++){var C=e.aoColumns[y[D].idx].colEl[0];var S=C.style.width.replace("px","");S!==y[D].width&&(C.style.width=y[D].width+"px")}}u.find("colgroup").remove();u.append(e.colgroup.clone());if(m){h.find("colgroup").remove();h.append(e.colgroup.clone())}t("th, td",n).each((function(){t(this.childNodes).wrapAll('<div class="dt-scroll-sizing">')}));m&&t("th, td",r).each((function(){t(this.childNodes).wrapAll('<div class="dt-scroll-sizing">')}));var x=Math.floor(g.height())>f.clientHeight||c.css("overflow-y")=="scroll";var w="padding"+(_.bScrollbarLeft?"Left":"Right");var T=g.outerWidth();u.css("width",_fnStringToCss(T));s.css("width",_fnStringToCss(T)).css(w,x?o+"px":"0px");if(m){h.css("width",_fnStringToCss(T));p.css("width",_fnStringToCss(T)).css(w,x?o+"px":"0px")}g.children("colgroup").prependTo(g);c.trigger("scroll");!e.bSorted&&!e.bFiltered||e._drawHold||(f.scrollTop=0)}else{e.scrollBarVis=b;_fnAdjustColumnSizing(e)}}
/**
 * Calculate the width of columns for the table
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnCalculateColumnWidths(e){if(e.oFeatures.bAutoWidth){var r,i,o,l=e.nTable,s=e.aoColumns,u=e.oScroll,f=u.sY,c=u.sX,d=u.sXInner,p=_fnGetColumns(e,"bVisible"),h=l.getAttribute("width"),v=l.parentNode;var g=l.style.width;g&&g.indexOf("%")!==-1&&(h=g);_fnCallbackFire(e,null,"column-calc",{visible:p},false);var m=t(l.cloneNode()).css("visibility","hidden").removeAttr("id");m.append("<tbody>");var _=t("<tr/>").appendTo(m.find("tbody"));m.append(t(e.nTHead).clone()).append(t(e.nTFoot).clone());m.find("tfoot th, tfoot td").css("width","");m.find("thead th, thead td").each((function(){var n=_fnColumnsSumWidth(e,this,true,false);if(n){this.style.width=n;c&&t(this).append(t("<div/>").css({width:n,margin:0,padding:0,border:0,height:1}))}else this.style.width=""}));for(r=0;r<p.length;r++){o=p[r];i=s[o];var b=_fnGetMaxLenString(e,o);var y=n.type.className[i.sType];var D=b+i.sContentPadding;var C=b.indexOf("<")===-1?document.createTextNode(D):D;t("<td/>").addClass(y).addClass(i.sClass).append(C).appendTo(_)}t("[name]",m).removeAttr("name");var S=t("<div/>").css(c||f?{position:"absolute",top:0,left:0,height:1,right:0,overflow:"hidden"}:{}).append(m).appendTo(v);if(c&&d)m.width(d);else if(c){m.css("width","auto");m.removeAttr("width");m.width()<v.clientWidth&&h&&m.width(v.clientWidth)}else f?m.width(v.clientWidth):h&&m.width(h);var x=0;var w=m.find("tbody tr").eq(0).children();for(r=0;r<p.length;r++){var T=w[r].getBoundingClientRect().width;x+=T;s[p[r]].sWidth=_fnStringToCss(T)}l.style.width=_fnStringToCss(x);S.remove();h&&(l.style.width=_fnStringToCss(h));if((h||c)&&!e._reszEvt){var bindResize=function(){t(window).on("resize.DT-"+e.sInstance,DataTable.util.throttle((function(){e.bDestroying||_fnAdjustColumnSizing(e)})))};bindResize();e._reszEvt=true}}}
/**
 * Get the maximum strlen for each data column
 *  @param {object} settings dataTables settings object
 *  @param {int} colIdx column of interest
 *  @returns {string} string of the max length
 *  @memberof DataTable#oApi
 */function _fnGetMaxLenString(e,t){var n=e.aoColumns[t];if(!n.maxLenString){var r,i="",o=-1;for(var l=0,s=e.aiDisplayMaster.length;l<s;l++){var u=e.aiDisplayMaster[l];var f=_fnGetRowDisplay(e,u)[t];var c=f&&typeof f==="object"&&f.nodeType?f.innerHTML:f+"";c=c.replace(/id=".*?"/g,"").replace(/name=".*?"/g,"");r=_stripHtml(c).replace(/&nbsp;/g," ");if(r.length>o){i=c;o=r.length}}n.maxLenString=i}return n.maxLenString}
/**
 * Append a CSS unit (only if required) to a string
 *  @param {string} value to css-ify
 *  @returns {string} value with css unit
 *  @memberof DataTable#oApi
 */function _fnStringToCss(e){return e===null?"0px":typeof e=="number"?e<0?"0px":e+"px":e.match(/\d$/)?e+"px":e}
/**
 * Re-insert the `col` elements for current visibility
 *
 * @param {*} settings DT settings
 */function _colGroup(e){var t=e.aoColumns;e.colgroup.empty();for(P=0;P<t.length;P++)t[P].bVisible&&e.colgroup.append(t[P].colEl)}function _fnSortInit(e){var t=e.nTHead;var n=t.querySelectorAll("tr");var r=e.bSortCellsTop;var i=':not([data-dt-order="disable"]):not([data-dt-order="icon-only"])';r===true?t=n[0]:r===false&&(t=n[n.length-1]);_fnSortAttachListener(e,t,t===e.nTHead?"tr"+i+" th"+i+", tr"+i+" td"+i:"th"+i+", td"+i);var o=[];_fnSortResolve(e,o,e.aaSorting);e.aaSorting=o}function _fnSortAttachListener(e,t,n,r,i){_fnBindAction(t,n,(function(t){var n=false;var o=r===void 0?_fnColumnsFromHeader(t.target):[r];if(o.length){for(var l=0,s=o.length;l<s;l++){var u=_fnSortAdd(e,o[l],l,t.shiftKey);u!==false&&(n=true);if(e.aaSorting.length===1&&e.aaSorting[0][1]==="")break}if(n){_fnProcessingDisplay(e,true);setTimeout((function(){_fnSort(e);_fnSortDisplay(e,e.aiDisplay);_fnProcessingDisplay(e,false);_fnReDraw(e,false,false);i&&i()}),0)}}}))}
/**
 * Sort the display array to match the master's order
 * @param {*} settings
 */function _fnSortDisplay(e,t){if(!(t.length<2)){var n=e.aiDisplayMaster;var r={};var i={};var o;for(o=0;o<n.length;o++)r[n[o]]=o;for(o=0;o<t.length;o++)i[t[o]]=r[t[o]];t.sort((function(e,t){return i[e]-i[t]}))}}function _fnSortResolve(e,n,r){var push=function(r){if(t.isPlainObject(r)){if(r.idx!==void 0)n.push([r.idx,r.dir]);else if(r.name){var i=_pluck(e.aoColumns,"sName");var o=i.indexOf(r.name);o!==-1&&n.push([o,r.dir])}}else n.push(r)};if(t.isPlainObject(r))push(r);else if(r.length&&typeof r[0]==="number")push(r);else if(r.length)for(var i=0;i<r.length;i++)push(r[i])}function _fnSortFlatten(e){var n,r,i,o,l,s,u,f=[],c=DataTable.ext.type.order,d=e.aoColumns,p=e.aaSortingFixed,h=t.isPlainObject(p),v=[];if(!e.oFeatures.bSort)return f;Array.isArray(p)&&_fnSortResolve(e,v,p);h&&p.pre&&_fnSortResolve(e,v,p.pre);_fnSortResolve(e,v,e.aaSorting);h&&p.post&&_fnSortResolve(e,v,p.post);for(n=0;n<v.length;n++){u=v[n][0];if(d[u]){o=d[u].aDataSort;for(r=0,i=o.length;r<i;r++){l=o[r];s=d[l].sType||"string";v[n]._idx===void 0&&(v[n]._idx=d[l].asSorting.indexOf(v[n][1]));v[n][1]&&f.push({src:u,col:l,dir:v[n][1],index:v[n]._idx,type:s,formatter:c[s+"-pre"],sorter:c[s+"-"+v[n][1]]})}}}return f}
/**
 * Change the order of the table
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnSort(e,t,n){var r,i,o,l,s,u=[],f=DataTable.ext.type.order,c=e.aoData,d=e.aiDisplayMaster;_fnColumnTypes(e);if(t!==void 0){var p=e.aoColumns[t];s=[{src:t,col:t,dir:n,index:0,type:p.sType,formatter:f[p.sType+"-pre"],sorter:f[p.sType+"-"+n]}];d=d.slice()}else s=_fnSortFlatten(e);for(r=0,i=s.length;r<i;r++){l=s[r];_fnSortData(e,l.col)}if(_fnDataSource(e)!="ssp"&&s.length!==0){for(r=0,o=d.length;r<o;r++)u[r]=r;s.length&&s[0].dir==="desc"&&u.reverse();d.sort((function(e,t){var n,r,i,o,l,f=s.length,d=c[e]._aSortData,p=c[t]._aSortData;for(i=0;i<f;i++){l=s[i];n=d[l.col];r=p[l.col];if(l.sorter){o=l.sorter(n,r);if(o!==0)return o}else{o=n<r?-1:n>r?1:0;if(o!==0)return l.dir==="asc"?o:-o}}n=u[e];r=u[t];return n<r?-1:n>r?1:0}))}else s.length===0&&d.sort((function(e,t){return e<t?-1:e>t?1:0}));if(t===void 0){e.bSorted=true;_fnCallbackFire(e,null,"order",[e,s])}return d}
/**
 * Function to run on user sort request
 *  @param {object} settings dataTables settings object
 *  @param {node} attachTo node to attach the handler to
 *  @param {int} colIdx column sorting index
 *  @param {int} addIndex Counter
 *  @param {boolean} [shift=false] Shift click add
 *  @param {function} [callback] callback function
 *  @memberof DataTable#oApi
 */function _fnSortAdd(e,t,n,r){var i=e.aoColumns[t];var o=e.aaSorting;var l=i.asSorting;var s;var next=function(e,t){var n=e._idx;n===void 0&&(n=l.indexOf(e[1]));return n+1<l.length?n+1:t?null:0};if(!i.bSortable)return false;typeof o[0]==="number"&&(o=e.aaSorting=[o]);if((r||n)&&e.oFeatures.bSortMulti){var u=_pluck(o,"0").indexOf(t);if(u!==-1){s=next(o[u],true);s===null&&o.length===1&&(s=0);if(s===null)o.splice(u,1);else{o[u][1]=l[s];o[u]._idx=s}}else if(r){o.push([t,l[0],0]);o[o.length-1]._idx=0}else{o.push([t,o[0][1],0]);o[o.length-1]._idx=0}}else if(o.length&&o[0][0]==t){s=next(o[0]);o.length=1;o[0][1]=l[s];o[0]._idx=s}else{o.length=0;o.push([t,l[0]]);o[0]._idx=0}}
/**
 * Set the sorting classes on table's body, Note: it is safe to call this function
 * when bSort and bSortClasses are false
 *  @param {object} oSettings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnSortingClasses(e){var n=e.aLastSort;var r=e.oClasses.order.position;var i=_fnSortFlatten(e);var o=e.oFeatures;var l,s,u;if(o.bSort&&o.bSortClasses){for(l=0,s=n.length;l<s;l++){u=n[l].src;t(_pluck(e.aoData,"anCells",u)).removeClass(r+(l<2?l+1:3))}for(l=0,s=i.length;l<s;l++){u=i[l].src;t(_pluck(e.aoData,"anCells",u)).addClass(r+(l<2?l+1:3))}}e.aLastSort=i}function _fnSortData(e,t){var n=e.aoColumns[t];var r=DataTable.ext.order[n.sSortDataType];var i;r&&(i=r.call(e.oInstance,e,t,_fnColumnIndexToVisible(e,t)));var o,l;var s=DataTable.ext.type.order[n.sType+"-pre"];var u=e.aoData;for(var f=0;f<u.length;f++)if(u[f]){o=u[f];o._aSortData||(o._aSortData=[]);if(!o._aSortData[t]||r){l=r?i[f]:_fnGetCellData(e,f,t,"sort");o._aSortData[t]=s?s(l,e):l}}}
/**
 * State information for a table
 *
 * @param {*} settings
 * @returns State object
 */function _fnSaveState(e){if(!e._bLoadingState){var n={time:+new Date,start:e._iDisplayStart,length:e._iDisplayLength,order:t.extend(true,[],e.aaSorting),search:t.extend({},e.oPreviousSearch),columns:e.aoColumns.map((function(n,r){return{visible:n.bVisible,search:t.extend({},e.aoPreSearchCols[r])}}))};e.oSavedState=n;_fnCallbackFire(e,"aoStateSaveParams","stateSaveParams",[e,n]);e.oFeatures.bStateSave&&!e.bDestroying&&e.fnStateSaveCallback.call(e.oInstance,e,n)}}
/**
 * Attempt to load a saved table state
 *  @param {object} oSettings dataTables settings object
 *  @param {object} oInit DataTables init object so we can override settings
 *  @param {function} callback Callback to execute when the state has been loaded
 *  @memberof DataTable#oApi
 */function _fnLoadState(e,t,n){if(e.oFeatures.bStateSave){var loaded=function(t){_fnImplementState(e,t,n)};var r=e.fnStateLoadCallback.call(e.oInstance,e,loaded);r!==void 0&&_fnImplementState(e,r,n);return true}n()}function _fnImplementState(e,n,r){var i,o;var l=e.aoColumns;e._bLoadingState=true;var s=e._bInitComplete?new DataTable.Api(e):null;if(n&&n.time){var u=e.iStateDuration;if(u>0&&n.time<+new Date-u*1e3){e._bLoadingState=false;r()}else{var f=_fnCallbackFire(e,"aoStateLoadParams","stateLoadParams",[e,n]);if(f.indexOf(false)===-1)if(n.columns&&l.length!==n.columns.length){e._bLoadingState=false;r()}else{e.oLoadedState=t.extend(true,{},n);_fnCallbackFire(e,null,"stateLoadInit",[e,n],true);n.length!==void 0&&(s?s.page.len(n.length):e._iDisplayLength=n.length);if(n.start!==void 0)if(s===null){e._iDisplayStart=n.start;e.iInitDisplayStart=n.start}else _fnPageChange(e,n.start/e._iDisplayLength);if(n.order!==void 0){e.aaSorting=[];t.each(n.order,(function(t,n){e.aaSorting.push(n[0]>=l.length?[0,n[1]]:n)}))}n.search!==void 0&&t.extend(e.oPreviousSearch,n.search);if(n.columns){for(i=0,o=n.columns.length;i<o;i++){var c=n.columns[i];c.visible!==void 0&&(s?s.column(i).visible(c.visible,false):l[i].bVisible=c.visible);c.search!==void 0&&t.extend(e.aoPreSearchCols[i],c.search)}s&&s.columns.adjust()}e._bLoadingState=false;_fnCallbackFire(e,"aoStateLoaded","stateLoaded",[e,n]);r()}else{e._bLoadingState=false;r()}}}else{e._bLoadingState=false;r()}}
/**
 * Log an error message
 *  @param {object} settings dataTables settings object
 *  @param {int} level log error messages, or display them to the user
 *  @param {string} msg error message
 *  @param {int} tn Technical note id to get more information about the error.
 *  @memberof DataTable#oApi
 */function _fnLog(e,t,n,r){n="DataTables warning: "+(e?"table id="+e.sTableId+" - ":"")+n;r&&(n+=". For more information about this error, please see https://datatables.net/tn/"+r);if(t)window.console&&console.log&&console.log(n);else{var i=DataTable.ext;var o=i.sErrMode||i.errMode;e&&_fnCallbackFire(e,null,"dt-error",[e,r,n],true);if(o=="alert")alert(n);else{if(o=="throw")throw new Error(n);typeof o=="function"&&o(e,r,n)}}}
/**
 * See if a property is defined on one object, if so assign it to the other object
 *  @param {object} ret target object
 *  @param {object} src source object
 *  @param {string} name property
 *  @param {string} [mappedName] name to map too - optional, name used if not given
 *  @memberof DataTable#oApi
 */function _fnMap(e,n,r,i){if(Array.isArray(r))t.each(r,(function(t,r){Array.isArray(r)?_fnMap(e,n,r[0],r[1]):_fnMap(e,n,r)}));else{i===void 0&&(i=r);n[r]!==void 0&&(e[i]=n[r])}}
/**
 * Extend objects - very similar to jQuery.extend, but deep copy objects, and
 * shallow copy arrays. The reason we need to do this, is that we don't want to
 * deep copy array init values (such as aaSorting) since the dev wouldn't be
 * able to override them, but we do want to deep copy arrays.
 *  @param {object} out Object to extend
 *  @param {object} extender Object from which the properties will be applied to
 *      out
 *  @param {boolean} breakRefs If true, then arrays will be sliced to take an
 *      independent copy with the exception of the `data` or `aaData` parameters
 *      if they are present. This is so you can pass in a collection to
 *      DataTables and have that used as your data source without breaking the
 *      references
 *  @returns {object} out Reference, just for convenience - out === the return.
 *  @memberof DataTable#oApi
 *  @todo This doesn't take account of arrays inside the deep copied objects.
 */function _fnExtend(e,n,r){var i;for(var o in n)if(Object.prototype.hasOwnProperty.call(n,o)){i=n[o];if(t.isPlainObject(i)){t.isPlainObject(e[o])||(e[o]={});t.extend(true,e[o],i)}else r&&o!=="data"&&o!=="aaData"&&Array.isArray(i)?e[o]=i.slice():e[o]=i}return e}
/**
 * Bind an event handers to allow a click or return key to activate the callback.
 * This is good for accessibility since a return on the keyboard will have the
 * same effect as a click, if the element has focus.
 *  @param {element} n Element to bind the action to
 *  @param {object|string} selector Selector (for delegated events) or data object
 *   to pass to the triggered function
 *  @param {function} fn Callback function for when the event is triggered
 *  @memberof DataTable#oApi
 */function _fnBindAction(e,n,r){t(e).on("click.DT",n,(function(e){r(e)})).on("keypress.DT",n,(function(e){if(e.which===13){e.preventDefault();r(e)}})).on("selectstart.DT",n,(function(){return false}))}
/**
 * Register a callback function. Easily allows a callback function to be added to
 * an array store of callback functions that can then all be called together.
 *  @param {object} settings dataTables settings object
 *  @param {string} store Name of the array storage for the callbacks in oSettings
 *  @param {function} fn Function to be called back
 *  @memberof DataTable#oApi
 */function _fnCallbackReg(e,t,n){n&&e[t].push(n)}
/**
 * Fire callback functions and trigger events. Note that the loop over the
 * callback array store is done backwards! Further note that you do not want to
 * fire off triggers in time sensitive applications (for example cell creation)
 * as its slow.
 *  @param {object} settings dataTables settings object
 *  @param {string} callbackArr Name of the array storage for the callbacks in
 *      oSettings
 *  @param {string} eventName Name of the jQuery custom event to trigger. If
 *      null no trigger is fired
 *  @param {array} args Array of arguments to pass to the callback function /
 *      trigger
 *  @param {boolean} [bubbles] True if the event should bubble
 *  @memberof DataTable#oApi
 */function _fnCallbackFire(e,n,r,i,o){var l=[];n&&(l=e[n].slice().reverse().map((function(t){return t.apply(e.oInstance,i)})));if(r!==null){var s=t.Event(r+".dt");var u=t(e.nTable);s.dt=e.api;u[o?"trigger":"triggerHandler"](s,i);o&&u.parents("body").length===0&&t("body").trigger(s,i);l.push(s.result)}return l}function _fnLengthOverflow(e){var t=e._iDisplayStart,n=e.fnDisplayEnd(),r=e._iDisplayLength;t>=n&&(t=n-r);t-=t%r;(r===-1||t<0)&&(t=0);e._iDisplayStart=t}function _fnRenderer(e,n){var r=e.renderer;var i=DataTable.ext.renderer[n];return t.isPlainObject(r)&&r[n]?i[r[n]]||i._:typeof r==="string"&&i[r]||i._}
/**
 * Detect the data source being used for the table. Used to simplify the code
 * a little (ajax) and to make it compress a little smaller.
 *
 *  @param {object} settings dataTables settings object
 *  @returns {string} Data source
 *  @memberof DataTable#oApi
 */function _fnDataSource(e){return e.oFeatures.bServerSide?"ssp":e.ajax?"ajax":"dom"}
/**
 * Common replacement for language strings
 *
 * @param {*} settings DT settings object
 * @param {*} str String with values to replace
 * @param {*} entries Plural number for _ENTRIES_ - can be undefined
 * @returns String
 */function _fnMacros(e,t,n){var r=e.fnFormatNumber,i=e._iDisplayStart+1,o=e._iDisplayLength,l=e.fnRecordsDisplay(),s=e.fnRecordsTotal(),u=o===-1;return t.replace(/_START_/g,r.call(e,i)).replace(/_END_/g,r.call(e,e.fnDisplayEnd())).replace(/_MAX_/g,r.call(e,s)).replace(/_TOTAL_/g,r.call(e,l)).replace(/_PAGE_/g,r.call(e,u?1:Math.ceil(i/o))).replace(/_PAGES_/g,r.call(e,u?1:Math.ceil(l/o))).replace(/_ENTRIES_/g,e.api.i18n("entries","",n)).replace(/_ENTRIES-MAX_/g,e.api.i18n("entries","",s)).replace(/_ENTRIES-TOTAL_/g,e.api.i18n("entries","",l))}
/**
 * Computed structure of the DataTables API, defined by the options passed to
 * `DataTable.Api.register()` when building the API.
 *
 * The structure is built in order to speed creation and extension of the Api
 * objects since the extensions are effectively pre-parsed.
 *
 * The array is an array of objects with the following structure, where this
 * base array represents the Api prototype base:
 *
 *     [
 *       {
 *         name:      'data'                -- string   - Property name
 *         val:       function () {},       -- function - Api method (or undefined if just an object
 *         methodExt: [ ... ],              -- array    - Array of Api object definitions to extend the method result
 *         propExt:   [ ... ]               -- array    - Array of Api object definitions to extend the property
 *       },
 *       {
 *         name:     'row'
 *         val:       {},
 *         methodExt: [ ... ],
 *         propExt:   [
 *           {
 *             name:      'data'
 *             val:       function () {},
 *             methodExt: [ ... ],
 *             propExt:   [ ... ]
 *           },
 *           ...
 *         ]
 *       }
 *     ]
 *
 * @type {Array}
 * @ignore
 */var D=[];
/**
 * `Array.prototype` reference.
 *
 * @type object
 * @ignore
 */var C=Array.prototype;
/**
 * Abstraction for `context` parameter of the `Api` constructor to allow it to
 * take several different forms for ease of use.
 *
 * Each of the input parameter types will be converted to a DataTables settings
 * object where possible.
 *
 * @param  {string|node|jQuery|object} mixed DataTable identifier. Can be one
 *   of:
 *
 *   * `string` - jQuery selector. Any DataTables' matching the given selector
 *     with be found and used.
 *   * `node` - `TABLE` node which has already been formed into a DataTable.
 *   * `jQuery` - A jQuery object of `TABLE` nodes.
 *   * `object` - DataTables settings object
 *   * `DataTables.Api` - API instance
 * @return {array|null} Matching DataTables settings objects. `null` or
 *   `undefined` is returned if no matching DataTable is found.
 * @ignore
 */var _toSettings=function(e){var n,r;var i=DataTable.settings;var o=_pluck(i,"nTable");if(!e)return[];if(e.nTable&&e.oFeatures)return[e];if(e.nodeName&&e.nodeName.toLowerCase()==="table"){n=o.indexOf(e);return n!==-1?[i[n]]:null}if(e&&typeof e.settings==="function")return e.settings().toArray();typeof e==="string"?r=t(e).get():e instanceof t&&(r=e.get());return r?i.filter((function(e,t){return r.includes(o[t])})):void 0};
/**
 * DataTables API class - used to control and interface with  one or more
 * DataTables enhanced tables.
 *
 * The API class is heavily based on jQuery, presenting a chainable interface
 * that you can use to interact with tables. Each instance of the API class has
 * a "context" - i.e. the tables that it will operate on. This could be a single
 * table, all tables on a page or a sub-set thereof.
 *
 * Additionally the API is designed to allow you to easily work with the data in
 * the tables, retrieving and manipulating it as required. This is done by
 * presenting the API class as an array like interface. The contents of the
 * array depend upon the actions requested by each method (for example
 * `rows().nodes()` will return an array of nodes, while `rows().data()` will
 * return an array of objects or arrays depending upon your table's
 * configuration). The API object has a number of array like methods (`push`,
 * `pop`, `reverse` etc) as well as additional helper methods (`each`, `pluck`,
 * `unique` etc) to assist your working with the data held in a table.
 *
 * Most methods (those which return an Api instance) are chainable, which means
 * the return from a method call also has all of the methods available that the
 * top level object had. For example, these two calls are equivalent:
 *
 *     // Not chained
 *     api.row.add( {...} );
 *     api.draw();
 *
 *     // Chained
 *     api.row.add( {...} ).draw();
 *
 * @class DataTable.Api
 * @param {array|object|string|jQuery} context DataTable identifier. This is
 *   used to define which DataTables enhanced tables this API will operate on.
 *   Can be one of:
 *
 *   * `string` - jQuery selector. Any DataTables' matching the given selector
 *     with be found and used.
 *   * `node` - `TABLE` node which has already been formed into a DataTable.
 *   * `jQuery` - A jQuery object of `TABLE` nodes.
 *   * `object` - DataTables settings object
 * @param {array} [data] Data to initialise the Api instance with.
 *
 * @example
 *   // Direct initialisation during DataTables construction
 *   var api = $('#example').DataTable();
 *
 * @example
 *   // Initialisation using a DataTables jQuery object
 *   var api = $('#example').dataTable().api();
 *
 * @example
 *   // Initialisation as a constructor
 *   var api = new DataTable.Api( 'table.dataTable' );
 */r=function(e,t){if(!(this instanceof r))return new r(e,t);var n=[];var ctxSettings=function(e){var t=_toSettings(e);t&&n.push.apply(n,t)};if(Array.isArray(e))for(var i=0,o=e.length;i<o;i++)ctxSettings(e[i]);else ctxSettings(e);this.context=n.length>1?_unique(n):n;t&&this.push.apply(this,t);this.selector={rows:null,cols:null,opts:null};r.extend(this,this,D)};DataTable.Api=r;t.extend(r.prototype,{any:function(){return this.count()!==0},context:[],count:function(){return this.flatten().length},each:function(e){for(var t=0,n=this.length;t<n;t++)e.call(this,this[t],t,this);return this},eq:function(e){var t=this.context;return t.length>e?new r(t[e],this[e]):null},filter:function(e){var t=C.filter.call(this,e,this);return new r(this.context,t)},flatten:function(){var e=[];return new r(this.context,e.concat.apply(e,this.toArray()))},get:function(e){return this[e]},join:C.join,includes:function(e){return this.indexOf(e)!==-1},indexOf:C.indexOf,iterator:function(e,t,n,i){var o,l,s,u,f,c,d,p,h=[],v=this.context,g=this.selector;if(typeof e==="string"){i=n;n=t;t=e;e=false}for(l=0,s=v.length;l<s;l++){var m=new r(v[l]);if(t==="table"){o=n.call(m,v[l],l);o!==void 0&&h.push(o)}else if(t==="columns"||t==="rows"){o=n.call(m,v[l],this[l],l);o!==void 0&&h.push(o)}else if(t==="every"||t==="column"||t==="column-rows"||t==="row"||t==="cell"){d=this[l];t==="column-rows"&&(c=_selector_row_indexes(v[l],g.opts));for(u=0,f=d.length;u<f;u++){p=d[u];o=t==="cell"?n.call(m,v[l],p.row,p.column,l,u):n.call(m,v[l],p,l,u,c);o!==void 0&&h.push(o)}}}if(h.length||i){var _=new r(v,e?h.concat.apply([],h):h);var b=_.selector;b.rows=g.rows;b.cols=g.cols;b.opts=g.opts;return _}return this},lastIndexOf:C.lastIndexOf,length:0,map:function(e){var t=C.map.call(this,e,this);return new r(this.context,t)},pluck:function(e){var t=DataTable.util.get(e);return this.map((function(e){return t(e)}))},pop:C.pop,push:C.push,reduce:C.reduce,reduceRight:C.reduceRight,reverse:C.reverse,selector:null,shift:C.shift,slice:function(){return new r(this.context,this)},sort:C.sort,splice:C.splice,toArray:function(){return C.slice.call(this)},to$:function(){return t(this)},toJQuery:function(){return t(this)},unique:function(){return new r(this.context,_unique(this.toArray()))},unshift:C.unshift});function _api_scope(e,t,n){return function(){var i=t.apply(e||this,arguments);r.extend(i,i,n.methodExt);return i}}function _api_find(e,t){for(var n=0,r=e.length;n<r;n++)if(e[n].name===t)return e[n];return null}window.__apiStruct=D;r.extend=function(e,t,n){if(n.length&&t&&(t instanceof r||t.__dt_wrapper)){var i,o,l;for(i=0,o=n.length;i<o;i++){l=n[i];if(l.name!=="__proto__"){t[l.name]=l.type==="function"?_api_scope(e,l.val,l):l.type==="object"?{}:l.val;t[l.name].__dt_wrapper=true;r.extend(e,t[l.name],l.propExt)}}}};r.register=i=function(e,n){if(Array.isArray(e))for(var i=0,o=e.length;i<o;i++)r.register(e[i],n);else{var l,s,u,f,c=e.split("."),d=D;for(l=0,s=c.length;l<s;l++){f=c[l].indexOf("()")!==-1;u=f?c[l].replace("()",""):c[l];var p=_api_find(d,u);if(!p){p={name:u,val:{},methodExt:[],propExt:[],type:"object"};d.push(p)}if(l===s-1){p.val=n;p.type=typeof n==="function"?"function":t.isPlainObject(n)?"object":"other"}else d=f?p.methodExt:p.propExt}}};r.registerPlural=o=function(e,t,n){r.register(e,n);r.register(t,(function(){var e=n.apply(this,arguments);return e===this?this:e instanceof r?e.length?Array.isArray(e[0])?new r(e.context,e[0]):e[0]:void 0:e}))};
/**
 * Selector for HTML tables. Apply the given selector to the give array of
 * DataTables settings objects.
 *
 * @param {string|integer} [selector] jQuery selector string or integer
 * @param  {array} Array of DataTables settings objects to be filtered
 * @return {array}
 * @ignore
 */var __table_selector=function(e,n){if(Array.isArray(e)){var r=[];e.forEach((function(e){var t=__table_selector(e,n);r.push.apply(r,t)}));return r.filter((function(e){return e}))}if(typeof e==="number")return[n[e]];var i=n.map((function(e){return e.nTable}));return t(i).filter(e).map((function(){var e=i.indexOf(this);return n[e]})).toArray()};
/**
 * Context selector for the API's context (i.e. the tables the API instance
 * refers to.
 *
 * @name    DataTable.Api#tables
 * @param {string|integer} [selector] Selector to pick which tables the iterator
 *   should operate on. If not given, all tables in the current context are
 *   used. This can be given as a jQuery selector (for example `':gt(0)'`) to
 *   select multiple tables or as an integer to select a single table.
 * @returns {DataTable.Api} Returns a new API instance if a selector is given.
 */i("tables()",(function(e){return e!==void 0&&e!==null?new r(__table_selector(e,this.context)):this}));i("table()",(function(e){var t=this.tables(e);var n=t.context;return n.length?new r(n[0]):t}));[["nodes","node","nTable"],["body","body","nTBody"],["header","header","nTHead"],["footer","footer","nTFoot"]].forEach((function(e){o("tables()."+e[0]+"()","table()."+e[1]+"()",(function(){return this.iterator("table",(function(t){return t[e[2]]}),1)}))}));[["header","aoHeader"],["footer","aoFooter"]].forEach((function(e){i("table()."+e[0]+".structure()",(function(t){var n=this.columns(t).indexes().flatten();var r=this.context[0];return _fnHeaderLayout(r,r[e[1]],n)}))}));o("tables().containers()","table().container()",(function(){return this.iterator("table",(function(e){return e.nTableWrapper}),1)}));i("tables().every()",(function(e){var t=this;return this.iterator("table",(function(n,r){e.call(t.table(r),r)}))}));i("caption()",(function(e,n){var r=this.context;if(e===void 0){var i=r[0].captionNode;return i&&r.length?i.innerHTML:null}return this.iterator("table",(function(r){var i=t(r.nTable);var o=t(r.captionNode);var l=t(r.nTableWrapper);if(!o.length){o=t("<caption/>").html(e);r.captionNode=o[0];if(!n){i.prepend(o);n=o.css("caption-side")}}o.html(e);if(n){o.css("caption-side",n);o[0]._captionSide=n}if(l.find("div.dataTables_scroll").length){var s=n==="top"?"Head":"Foot";l.find("div.dataTables_scroll"+s+" table").prepend(o)}else i.prepend(o)}),1)}));i("caption.node()",(function(){var e=this.context;return e.length?e[0].captionNode:null}));i("draw()",(function(e){return this.iterator("table",(function(t){if(e==="page")_fnDraw(t);else{typeof e==="string"&&(e=e!=="full-hold");_fnReDraw(t,e===false)}}))}));
/**
 * Set the current page.
 *
 * Note that if you attempt to show a page which does not exist, DataTables will
 * not throw an error, but rather reset the paging.
 *
 * @param {integer|string} action The paging action to take. This can be one of:
 *  * `integer` - The page index to jump to
 *  * `string` - An action to take:
 *    * `first` - Jump to first page.
 *    * `next` - Jump to the next page
 *    * `previous` - Jump to previous page
 *    * `last` - Jump to the last page.
 * @returns {DataTables.Api} this
 */i("page()",(function(e){return e===void 0?this.page.info().page:this.iterator("table",(function(t){_fnPageChange(t,e)}))}));i("page.info()",(function(){if(this.context.length!==0){var e=this.context[0],t=e._iDisplayStart,n=e.oFeatures.bPaginate?e._iDisplayLength:-1,r=e.fnRecordsDisplay(),i=n===-1;return{page:i?0:Math.floor(t/n),pages:i?1:Math.ceil(r/n),start:t,end:e.fnDisplayEnd(),length:n,recordsTotal:e.fnRecordsTotal(),recordsDisplay:r,serverSide:_fnDataSource(e)==="ssp"}}}));
/**
 * Set the current page length.
 *
 * @param {integer} Page length to set. Use `-1` to show all records.
 * @returns {DataTables.Api} this
 */i("page.len()",(function(e){return e===void 0?this.context.length!==0?this.context[0]._iDisplayLength:void 0:this.iterator("table",(function(t){_fnLengthChange(t,e)}))}));var __reload=function(e,t,n){if(n){var i=new r(e);i.one("draw",(function(){n(i.ajax.json())}))}if(_fnDataSource(e)=="ssp")_fnReDraw(e,t);else{_fnProcessingDisplay(e,true);var o=e.jqXHR;o&&o.readyState!==4&&o.abort();_fnBuildAjax(e,{},(function(n){_fnClearTable(e);var r=_fnAjaxDataSrc(e,n);for(var i=0,o=r.length;i<o;i++)_fnAddData(e,r[i]);_fnReDraw(e,t);_fnInitComplete(e);_fnProcessingDisplay(e,false)}))}};i("ajax.json()",(function(){var e=this.context;if(e.length>0)return e[0].json}));i("ajax.params()",(function(){var e=this.context;if(e.length>0)return e[0].oAjaxData}));
/**
 * Reload tables from the Ajax data source. Note that this function will
 * automatically re-draw the table when the remote data has been loaded.
 *
 * @param {boolean} [reset=true] Reset (default) or hold the current paging
 *   position. A full re-sort and re-filter is performed when this method is
 *   called, which is why the pagination reset is the default action.
 * @returns {DataTables.Api} this
 */i("ajax.reload()",(function(e,t){return this.iterator("table",(function(n){__reload(n,t===false,e)}))}));
/**
 * Set the Ajax URL. Note that this will set the URL for all tables in the
 * current context.
 *
 * @param {string} url URL to set.
 * @returns {DataTables.Api} this
 */i("ajax.url()",(function(e){var n=this.context;if(e===void 0){if(n.length===0)return;n=n[0];return t.isPlainObject(n.ajax)?n.ajax.url:n.ajax}return this.iterator("table",(function(n){t.isPlainObject(n.ajax)?n.ajax.url=e:n.ajax=e}))}));
/**
 * Load data from the newly set Ajax URL. Note that this method is only
 * available when `ajax.url()` is used to set a URL. Additionally, this method
 * has the same effect as calling `ajax.reload()` but is provided for
 * convenience when setting a new URL. Like `ajax.reload()` it will
 * automatically redraw the table once the remote data has been loaded.
 *
 * @returns {DataTables.Api} this
 */i("ajax.url().load()",(function(e,t){return this.iterator("table",(function(n){__reload(n,t===false,e)}))}));var _selector_run=function(e,t,r,i,o){var l,s,u,f,c,d,p=[],h=typeof t;t&&h!=="string"&&h!=="function"&&t.length!==void 0||(t=[t]);for(u=0,f=t.length;u<f;u++){s=t[u]&&t[u].split&&!t[u].match(/[[(:]/)?t[u].split(","):[t[u]];for(c=0,d=s.length;c<d;c++){l=r(typeof s[c]==="string"?s[c].trim():s[c]);l=l.filter((function(e){return e!==null&&e!==void 0}));l&&l.length&&(p=p.concat(l))}}var v=n.selector[e];if(v.length)for(u=0,f=v.length;u<f;u++)p=v[u](i,o,p);return _unique(p)};var _selector_opts=function(e){e||(e={});e.filter&&e.search===void 0&&(e.search=e.filter);return t.extend({search:"none",order:"current",page:"all"},e)};var _selector_first=function(e){let t=new r(e.context[0]);e.length&&t.push(e[0]);t.selector=e.selector;t.length&&t[0].length>1&&t[0].splice(1);return t};var _selector_row_indexes=function(e,t){var n,r,i,o=[],l=e.aiDisplay,s=e.aiDisplayMaster;var u=t.search,f=t.order,c=t.page;if(c=="current")for(n=e._iDisplayStart,r=e.fnDisplayEnd();n<r;n++)o.push(l[n]);else if(f=="current"||f=="applied"){if(u=="none")o=s.slice();else if(u=="applied")o=l.slice();else if(u=="removed"){var d={};for(n=0,r=l.length;n<r;n++)d[l[n]]=null;s.forEach((function(e){Object.prototype.hasOwnProperty.call(d,e)||o.push(e)}))}}else if(f=="index"||f=="original"){for(n=0,r=e.aoData.length;n<r;n++)if(e.aoData[n])if(u=="none")o.push(n);else{i=l.indexOf(n);(i===-1&&u=="removed"||i>=0&&u=="applied")&&o.push(n)}}else if(typeof f==="number"){var p=_fnSort(e,f,"asc");if(u==="none")o=p;else for(n=0;n<p.length;n++){i=l.indexOf(p[n]);(i===-1&&u=="removed"||i>=0&&u=="applied")&&o.push(p[n])}}return o};var __row_selector=function(e,n,r){var i;var run=function(n){var o=_intVal(n);var l=e.aoData;if(o!==null&&!r)return[o];i||(i=_selector_row_indexes(e,r));if(o!==null&&i.indexOf(o)!==-1)return[o];if(n===null||n===void 0||n==="")return i;if(typeof n==="function")return i.map((function(e){var t=l[e];return n(e,t._aData,t.nTr)?e:null}));if(n.nodeName){var s=n._DT_RowIndex;var u=n._DT_CellIndex;if(s!==void 0)return l[s]&&l[s].nTr===n?[s]:[];if(u)return l[u.row]&&l[u.row].nTr===n.parentNode?[u.row]:[];var f=t(n).closest("*[data-dt-row]");return f.length?[f.data("dt-row")]:[]}if(typeof n==="string"&&n.charAt(0)==="#"){var c=e.aIds[n.replace(/^#/,"")];if(c!==void 0)return[c.idx]}var d=_removeEmpty(_pluck_order(e.aoData,i,"nTr"));return t(d).filter(n).map((function(){return this._DT_RowIndex})).toArray()};var o=_selector_run("row",n,run,e,r);r.order!=="current"&&r.order!=="applied"||_fnSortDisplay(e,o);return o};i("rows()",(function(e,n){if(e===void 0)e="";else if(t.isPlainObject(e)){n=e;e=""}n=_selector_opts(n);var r=this.iterator("table",(function(t){return __row_selector(t,e,n)}),1);r.selector.rows=e;r.selector.opts=n;return r}));i("rows().nodes()",(function(){return this.iterator("row",(function(e,t){return e.aoData[t].nTr||void 0}),1)}));i("rows().data()",(function(){return this.iterator(true,"rows",(function(e,t){return _pluck_order(e.aoData,t,"_aData")}),1)}));o("rows().cache()","row().cache()",(function(e){return this.iterator("row",(function(t,n){var r=t.aoData[n];return e==="search"?r._aFilterData:r._aSortData}),1)}));o("rows().invalidate()","row().invalidate()",(function(e){return this.iterator("row",(function(t,n){_fnInvalidate(t,n,e)}))}));o("rows().indexes()","row().index()",(function(){return this.iterator("row",(function(e,t){return t}),1)}));o("rows().ids()","row().id()",(function(e){var t=[];var n=this.context;for(var i=0,o=n.length;i<o;i++)for(var l=0,s=this[i].length;l<s;l++){var u=n[i].rowIdFn(n[i].aoData[this[i][l]]._aData);t.push((e===true?"#":"")+u)}return new r(n,t)}));o("rows().remove()","row().remove()",(function(){this.iterator("row",(function(e,t){var n=e.aoData;var r=n[t];var i=e.aiDisplayMaster.indexOf(t);i!==-1&&e.aiDisplayMaster.splice(i,1);e._iRecordsDisplay>0&&e._iRecordsDisplay--;_fnLengthOverflow(e);var o=e.rowIdFn(r._aData);o!==void 0&&delete e.aIds[o];n[t]=null}));return this}));i("rows.add()",(function(e){var t=this.iterator("table",(function(t){var n,r,i;var o=[];for(r=0,i=e.length;r<i;r++){n=e[r];n.nodeName&&n.nodeName.toUpperCase()==="TR"?o.push(_fnAddTr(t,n)[0]):o.push(_fnAddData(t,n))}return o}),1);var n=this.rows(-1);n.pop();n.push.apply(n,t);return n}));i("row()",(function(e,t){return _selector_first(this.rows(e,t))}));i("row().data()",(function(e){var t=this.context;if(e===void 0)return t.length&&this.length&&this[0].length?t[0].aoData[this[0]]._aData:void 0;var n=t[0].aoData[this[0]];n._aData=e;Array.isArray(e)&&n.nTr&&n.nTr.id&&m(t[0].rowId)(e,n.nTr.id);_fnInvalidate(t[0],this[0],"data");return this}));i("row().node()",(function(){var e=this.context;if(e.length&&this.length&&this[0].length){var t=e[0].aoData[this[0]];if(t&&t.nTr)return t.nTr}return null}));i("row.add()",(function(e){e instanceof t&&e.length&&(e=e[0]);var n=this.iterator("table",(function(t){return e.nodeName&&e.nodeName.toUpperCase()==="TR"?_fnAddTr(t,e)[0]:_fnAddData(t,e)}));return this.row(n[0])}));t(document).on("plugin-init.dt",(function(e,t){var n=new r(t);n.on("stateSaveParams.DT",(function(e,t,n){var r=t.rowIdFn;var i=t.aiDisplayMaster;var o=[];for(var l=0;l<i.length;l++){var s=i[l];var u=t.aoData[s];u._detailsShow&&o.push("#"+r(u._aData))}n.childRows=o}));n.on("stateLoaded.DT",(function(e,t,r){__details_state_load(n,r)}));__details_state_load(n,n.state.loaded())}));var __details_state_load=function(e,t){t&&t.childRows&&e.rows(t.childRows.map((function(e){return e.replace(/([^:\\]*(?:\\.[^:\\]*)*):/g,"$1\\:")}))).every((function(){_fnCallbackFire(e.settings()[0],null,"requestChild",[this])}))};var __details_add=function(e,n,r,i){var o=[];var addRow=function(r,i){if(Array.isArray(r)||r instanceof t)for(var l=0,s=r.length;l<s;l++)addRow(r[l],i);else if(r.nodeName&&r.nodeName.toLowerCase()==="tr"){r.setAttribute("data-dt-row",n.idx);o.push(r)}else{var u=t("<tr><td></td></tr>").attr("data-dt-row",n.idx).addClass(i);t("td",u).addClass(i).html(r)[0].colSpan=_fnVisbleColumns(e);o.push(u[0])}};addRow(r,i);n._details&&n._details.detach();n._details=t(o);n._detailsShow&&n._details.insertAfter(n.nTr)};var S=DataTable.util.throttle((function(e){_fnSaveState(e[0])}),500);var __details_remove=function(e,n){var r=e.context;if(r.length){var i=r[0].aoData[n!==void 0?n:e[0]];if(i&&i._details){i._details.remove();i._detailsShow=void 0;i._details=void 0;t(i.nTr).removeClass("dt-hasChild");S(r)}}};var __details_display=function(e,n){var r=e.context;if(r.length&&e.length){var i=r[0].aoData[e[0]];if(i._details){i._detailsShow=n;if(n){i._details.insertAfter(i.nTr);t(i.nTr).addClass("dt-hasChild")}else{i._details.detach();t(i.nTr).removeClass("dt-hasChild")}_fnCallbackFire(r[0],null,"childRow",[n,e.row(e[0])]);__details_events(r[0]);S(r)}}};var __details_events=function(e){var n=new r(e);var i=".dt.DT_details";var o="draw"+i;var l="column-sizing"+i;var s="destroy"+i;var u=e.aoData;n.off(o+" "+l+" "+s);if(_pluck(u,"_details").length>0){n.on(o,(function(t,r){e===r&&n.rows({page:"current"}).eq(0).each((function(e){var t=u[e];t._detailsShow&&t._details.insertAfter(t.nTr)}))}));n.on(l,(function(n,r){if(e===r){var i,o=_fnVisbleColumns(r);for(var l=0,s=u.length;l<s;l++){i=u[l];i&&i._details&&i._details.each((function(){var e=t(this).children("td");e.length==1&&e.attr("colspan",o)}))}}}));n.on(s,(function(t,r){if(e===r)for(var i=0,o=u.length;i<o;i++)u[i]&&u[i]._details&&__details_remove(n,i)}))}};var x="";var w=x+"row().child";var T=w+"()";i(T,(function(e,t){var n=this.context;if(e===void 0)return n.length&&this.length&&n[0].aoData[this[0]]?n[0].aoData[this[0]]._details:void 0;e===true?this.child.show():e===false?__details_remove(this):n.length&&this.length&&__details_add(n[0],n[0].aoData[this[0]],e,t);return this}));i([w+".show()",T+".show()"],(function(){__details_display(this,true);return this}));i([w+".hide()",T+".hide()"],(function(){__details_display(this,false);return this}));i([w+".remove()",T+".remove()"],(function(){__details_remove(this);return this}));i(w+".isShown()",(function(){var e=this.context;return e.length&&this.length&&e[0].aoData[this[0]]._detailsShow||false}));var A=/^([^:]+):(name|title|visIdx|visible)$/;var __columnData=function(e,t,n,r,i,o){var l=[];for(var s=0,u=i.length;s<u;s++)l.push(_fnGetCellData(e,i[s],t,o));return l};var __column_header=function(e,t,n){var r=e.aoHeader;var i=n!==void 0?n:e.bSortCellsTop?0:r.length-1;return r[i][t].cell};var __column_selector=function(e,n,r){var i=e.aoColumns,o=_pluck(i,"sName"),l=_pluck(i,"sTitle"),s=DataTable.util.get("[].[].cell")(e.aoHeader),u=_unique(_flatten([],s));var run=function(n){var s=_intVal(n);if(n==="")return _range(i.length);if(s!==null)return[s>=0?s:i.length+s];if(typeof n==="function"){var f=_selector_row_indexes(e,r);return i.map((function(t,r){return n(r,__columnData(e,r,0,0,f),__column_header(e,r))?r:null}))}var c=typeof n==="string"?n.match(A):"";if(c)switch(c[2]){case"visIdx":case"visible":var d=parseInt(c[1],10);if(d<0){var p=i.map((function(e,t){return e.bVisible?t:null}));return[p[p.length+d]]}return[_fnVisibleToColumnIndex(e,d)];case"name":return o.map((function(e,t){return e===c[1]?t:null}));case"title":return l.map((function(e,t){return e===c[1]?t:null}));default:return[]}if(n.nodeName&&n._DT_CellIndex)return[n._DT_CellIndex.column];var h=t(u).filter(n).map((function(){return _fnColumnsFromHeader(this)})).toArray();if(h.length||!n.nodeName)return h;var v=t(n).closest("*[data-dt-column]");return v.length?[v.data("dt-column")]:[]};return _selector_run("column",n,run,e,r)};var __setColumnVis=function(e,n,r){var i,o,l,s,u=e.aoColumns,f=u[n],c=e.aoData;if(r===void 0)return f.bVisible;if(f.bVisible===r)return false;if(r){var d=_pluck(u,"bVisible").indexOf(true,n+1);for(o=0,l=c.length;o<l;o++)if(c[o]){s=c[o].nTr;i=c[o].anCells;s&&s.insertBefore(i[n],i[d]||null)}}else t(_pluck(e.aoData,"anCells",n)).detach();f.bVisible=r;_colGroup(e);return true};i("columns()",(function(e,n){if(e===void 0)e="";else if(t.isPlainObject(e)){n=e;e=""}n=_selector_opts(n);var r=this.iterator("table",(function(t){return __column_selector(t,e,n)}),1);r.selector.cols=e;r.selector.opts=n;return r}));o("columns().header()","column().header()",(function(e){return this.iterator("column",(function(t,n){return __column_header(t,n,e)}),1)}));o("columns().footer()","column().footer()",(function(e){return this.iterator("column",(function(t,n){var r=t.aoFooter;return r.length?t.aoFooter[e!==void 0?e:0][n].cell:null}),1)}));o("columns().data()","column().data()",(function(){return this.iterator("column-rows",__columnData,1)}));o("columns().render()","column().render()",(function(e){return this.iterator("column-rows",(function(t,n,r,i,o){return __columnData(t,n,r,i,o,e)}),1)}));o("columns().dataSrc()","column().dataSrc()",(function(){return this.iterator("column",(function(e,t){return e.aoColumns[t].mData}),1)}));o("columns().cache()","column().cache()",(function(e){return this.iterator("column-rows",(function(t,n,r,i,o){return _pluck_order(t.aoData,o,e==="search"?"_aFilterData":"_aSortData",n)}),1)}));o("columns().init()","column().init()",(function(){return this.iterator("column",(function(e,t){return e.aoColumns[t]}),1)}));o("columns().nodes()","column().nodes()",(function(){return this.iterator("column-rows",(function(e,t,n,r,i){return _pluck_order(e.aoData,i,"anCells",t)}),1)}));o("columns().titles()","column().title()",(function(e,n){return this.iterator("column",(function(r,i){if(typeof e==="number"){n=e;e=void 0}var o=t("span.dt-column-title",this.column(i).header(n));if(e!==void 0){o.html(e);return this}return o.html()}),1)}));o("columns().types()","column().type()",(function(){return this.iterator("column",(function(e,t){var n=e.aoColumns[t].sType;n||_fnColumnTypes(e);return n}),1)}));o("columns().visible()","column().visible()",(function(e,n){var r=this;var i=[];var o=this.iterator("column",(function(t,n){if(e===void 0)return t.aoColumns[n].bVisible;__setColumnVis(t,n,e)&&i.push(n)}));e!==void 0&&this.iterator("table",(function(o){_fnDrawHead(o,o.aoHeader);_fnDrawHead(o,o.aoFooter);o.aiDisplay.length||t(o.nTBody).find("td[colspan]").attr("colspan",_fnVisbleColumns(o));_fnSaveState(o);r.iterator("column",(function(t,r){i.includes(r)&&_fnCallbackFire(t,null,"column-visibility",[t,r,e,n])}));i.length&&(n===void 0||n)&&r.columns.adjust()}));return o}));o("columns().widths()","column().width()",(function(){var e=this.columns(":visible").count();var n=t("<tr>").html("<td>"+Array(e).join("</td><td>")+"</td>");t(this.table().body()).append(n);var r=n.children().map((function(){return t(this).outerWidth()}));n.remove();return this.iterator("column",(function(e,t){var n=_fnColumnIndexToVisible(e,t);return n!==null?r[n]:0}),1)}));o("columns().indexes()","column().index()",(function(e){return this.iterator("column",(function(t,n){return e==="visible"?_fnColumnIndexToVisible(t,n):n}),1)}));i("columns.adjust()",(function(){return this.iterator("table",(function(e){_fnAdjustColumnSizing(e)}),1)}));i("column.index()",(function(e,t){if(this.context.length!==0){var n=this.context[0];if(e==="fromVisible"||e==="toData")return _fnVisibleToColumnIndex(n,t);if(e==="fromData"||e==="toVisible")return _fnColumnIndexToVisible(n,t)}}));i("column()",(function(e,t){return _selector_first(this.columns(e,t))}));var __cell_selector=function(e,n,r){var i=e.aoData;var o=_selector_row_indexes(e,r);var l=_removeEmpty(_pluck_order(i,o,"anCells"));var s=t(_flatten([],l));var u;var f=e.aoColumns.length;var c,d,p,h,v,g;var run=function(n){var r=typeof n==="function";if(n===null||n===void 0||r){c=[];for(d=0,p=o.length;d<p;d++){u=o[d];for(h=0;h<f;h++){v={row:u,column:h};if(r){g=i[u];n(v,_fnGetCellData(e,u,h),g.anCells?g.anCells[h]:null)&&c.push(v)}else c.push(v)}}return c}if(t.isPlainObject(n))return n.column!==void 0&&n.row!==void 0&&o.indexOf(n.row)!==-1?[n]:[];var l=s.filter(n).map((function(e,t){return{row:t._DT_CellIndex.row,column:t._DT_CellIndex.column}})).toArray();if(l.length||!n.nodeName)return l;g=t(n).closest("*[data-dt-row]");return g.length?[{row:g.data("dt-row"),column:g.data("dt-column")}]:[]};return _selector_run("cell",n,run,e,r)};i("cells()",(function(e,n,r){if(t.isPlainObject(e))if(e.row===void 0){r=e;e=null}else{r=n;n=null}if(t.isPlainObject(n)){r=n;n=null}if(n===null||n===void 0)return this.iterator("table",(function(t){return __cell_selector(t,e,_selector_opts(r))}));var i=r?{page:r.page,order:r.order,search:r.search}:{};var o=this.columns(n,i);var l=this.rows(e,i);var s,u,f,c;var d=this.iterator("table",(function(e,t){var n=[];for(s=0,u=l[t].length;s<u;s++)for(f=0,c=o[t].length;f<c;f++)n.push({row:l[t][s],column:o[t][f]});return n}),1);var p=r&&r.selected?this.cells(d,r):d;t.extend(p.selector,{cols:n,rows:e,opts:r});return p}));o("cells().nodes()","cell().node()",(function(){return this.iterator("cell",(function(e,t,n){var r=e.aoData[t];return r&&r.anCells?r.anCells[n]:void 0}),1)}));i("cells().data()",(function(){return this.iterator("cell",(function(e,t,n){return _fnGetCellData(e,t,n)}),1)}));o("cells().cache()","cell().cache()",(function(e){e=e==="search"?"_aFilterData":"_aSortData";return this.iterator("cell",(function(t,n,r){return t.aoData[n][e][r]}),1)}));o("cells().render()","cell().render()",(function(e){return this.iterator("cell",(function(t,n,r){return _fnGetCellData(t,n,r,e)}),1)}));o("cells().indexes()","cell().index()",(function(){return this.iterator("cell",(function(e,t,n){return{row:t,column:n,columnVisible:_fnColumnIndexToVisible(e,n)}}),1)}));o("cells().invalidate()","cell().invalidate()",(function(e){return this.iterator("cell",(function(t,n,r){_fnInvalidate(t,n,e,r)}))}));i("cell()",(function(e,t,n){return _selector_first(this.cells(e,t,n))}));i("cell().data()",(function(e){var t=this.context;var n=this[0];if(e===void 0)return t.length&&n.length?_fnGetCellData(t[0],n[0].row,n[0].column):void 0;_fnSetCellData(t[0],n[0].row,n[0].column,e);_fnInvalidate(t[0],n[0].row,"data",n[0].column);return this}));
/**
 * Get current ordering (sorting) that has been applied to the table.
 *
 * @returns {array} 2D array containing the sorting information for the first
 *   table in the current context. Each element in the parent array represents
 *   a column being sorted upon (i.e. multi-sorting with two columns would have
 *   2 inner arrays). The inner arrays may have 2 or 3 elements. The first is
 *   the column index that the sorting condition applies to, the second is the
 *   direction of the sort (`desc` or `asc`) and, optionally, the third is the
 *   index of the sorting order from the `column.sorting` initialisation array.
 */
/**
 * Set the ordering for the table.
 *
 * @param {integer} order Column index to sort upon.
 * @param {string} direction Direction of the sort to be applied (`asc` or `desc`)
 * @returns {DataTables.Api} this
 */
/**
 * Set the ordering for the table.
 *
 * @param {array} order 1D array of sorting information to be applied.
 * @param {array} [...] Optional additional sorting conditions
 * @returns {DataTables.Api} this
 */
/**
 * Set the ordering for the table.
 *
 * @param {array} order 2D array of sorting information to be applied.
 * @returns {DataTables.Api} this
 */i("order()",(function(e,t){var n=this.context;var r=Array.prototype.slice.call(arguments);if(e===void 0)return n.length!==0?n[0].aaSorting:void 0;typeof e==="number"?e=[[e,t]]:r.length>1&&(e=r);return this.iterator("table",(function(t){t.aaSorting=Array.isArray(e)?e.slice():e}))}));
/**
 * Attach a sort listener to an element for a given column
 *
 * @param {node|jQuery|string} node Identifier for the element(s) to attach the
 *   listener to. This can take the form of a single DOM node, a jQuery
 *   collection of nodes or a jQuery selector which will identify the node(s).
 * @param {integer} column the column that a click on this node will sort on
 * @param {function} [callback] callback function when sort is run
 * @returns {DataTables.Api} this
 */i("order.listener()",(function(e,t,n){return this.iterator("table",(function(r){_fnSortAttachListener(r,e,{},t,n)}))}));i("order.fixed()",(function(e){if(!e){var n=this.context;var r=n.length?n[0].aaSortingFixed:void 0;return Array.isArray(r)?{pre:r}:r}return this.iterator("table",(function(n){n.aaSortingFixed=t.extend(true,{},e)}))}));i(["columns().order()","column().order()"],(function(e){var t=this;return e?this.iterator("table",(function(n,r){n.aaSorting=t[r].map((function(t){return[t,e]}))})):this.iterator("column",(function(e,t){var n=_fnSortFlatten(e);for(var r=0,i=n.length;r<i;r++)if(n[r].col===t)return n[r].dir;return null}),1)}));o("columns().orderable()","column().orderable()",(function(e){return this.iterator("column",(function(t,n){var r=t.aoColumns[n];return e?r.asSorting:r.bSortable}),1)}));i("processing()",(function(e){return this.iterator("table",(function(t){_fnProcessingDisplay(t,e)}))}));i("search()",(function(e,n,r,i){var o=this.context;return e===void 0?o.length!==0?o[0].oPreviousSearch.search:void 0:this.iterator("table",(function(o){o.oFeatures.bFilter&&_fnFilterComplete(o,typeof n==="object"?t.extend(o.oPreviousSearch,n,{search:e}):t.extend(o.oPreviousSearch,{search:e,regex:n!==null&&n,smart:r===null||r,caseInsensitive:i===null||i}))}))}));i("search.fixed()",(function(e,t){var n=this.iterator(true,"table",(function(n){var r=n.searchFixed;if(!e)return Object.keys(r);if(t===void 0)return r[e];t===null?delete r[e]:r[e]=t;return this}));return e!==void 0&&t===void 0?n[0]:n}));o("columns().search()","column().search()",(function(e,n,r,i){return this.iterator("column",(function(o,l){var s=o.aoPreSearchCols;if(e===void 0)return s[l].search;if(o.oFeatures.bFilter){typeof n==="object"?t.extend(s[l],n,{search:e}):t.extend(s[l],{search:e,regex:n!==null&&n,smart:r===null||r,caseInsensitive:i===null||i});_fnFilterComplete(o,o.oPreviousSearch)}}))}));i(["columns().search.fixed()","column().search.fixed()"],(function(e,t){var n=this.iterator(true,"column",(function(n,r){var i=n.aoColumns[r].searchFixed;if(!e)return Object.keys(i);if(t===void 0)return i[e];t===null?delete i[e]:i[e]=t;return this}));return e!==void 0&&t===void 0?n[0]:n}));i("state()",(function(e,n){if(!e)return this.context.length?this.context[0].oSavedState:null;var r=t.extend(true,{},e);return this.iterator("table",(function(e){n!==false&&(r.time=+new Date+100);_fnImplementState(e,r,(function(){}))}))}));i("state.clear()",(function(){return this.iterator("table",(function(e){e.fnStateSaveCallback.call(e.oInstance,e,{})}))}));i("state.loaded()",(function(){return this.context.length?this.context[0].oLoadedState:null}));i("state.save()",(function(){return this.iterator("table",(function(e){_fnSaveState(e)}))}));
/**
 * Set the jQuery or window object to be used by DataTables
 *
 * @param {*} module Library / container object
 * @param {string} [type] Library or container type `lib`, `win` or `datetime`.
 *   If not provided, automatic detection is attempted.
 */DataTable.use=function(e,n){if(n==="lib"||e.fn)t=e;else if(n=="win"||e.document){window=e;document=e.document}else n!=="datetime"&&e.type!=="DateTime"||(DataTable.DateTime=e)};
/**
 * CommonJS factory function pass through. This will check if the arguments
 * given are a window object or a jQuery object. If so they are set
 * accordingly.
 * @param {*} root Window
 * @param {*} jq jQUery
 * @returns {boolean} Indicator
 */DataTable.factory=function(e,n){var r=false;if(e&&e.document){window=e;document=e.document}if(n&&n.fn&&n.fn.jquery){t=n;r=true}return r};
/**
 * Provide a common method for plug-ins to check the version of DataTables being
 * used, in order to ensure compatibility.
 *
 *  @param {string} version Version string to check for, in the format "X.Y.Z".
 *    Note that the formats "X" and "X.Y" are also acceptable.
 *  @param {string} [version2=current DataTables version] As above, but optional.
 *   If not given the current DataTables version will be used.
 *  @returns {boolean} true if this version of DataTables is greater or equal to
 *    the required version, or false if this version of DataTales is not
 *    suitable
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    alert( $.fn.dataTable.versionCheck( '1.9.0' ) );
 */DataTable.versionCheck=function(e,t){var n=t?t.split("."):DataTable.version.split(".");var r=e.split(".");var i,o;for(var l=0,s=r.length;l<s;l++){i=parseInt(n[l],10)||0;o=parseInt(r[l],10)||0;if(i!==o)return i>o}return true};
/**
 * Check if a `<table>` node is a DataTable table already or not.
 *
 *  @param {node|jquery|string} table Table node, jQuery object or jQuery
 *      selector for the table to test. Note that if more than more than one
 *      table is passed on, only the first will be checked
 *  @returns {boolean} true the table given is a DataTable, or false otherwise
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    if ( ! $.fn.DataTable.isDataTable( '#example' ) ) {
 *      $('#example').dataTable();
 *    }
 */DataTable.isDataTable=function(e){var n=t(e).get(0);var r=false;if(e instanceof DataTable.Api)return true;t.each(DataTable.settings,(function(e,i){var o=i.nScrollHead?t("table",i.nScrollHead)[0]:null;var l=i.nScrollFoot?t("table",i.nScrollFoot)[0]:null;i.nTable!==n&&o!==n&&l!==n||(r=true)}));return r};
/**
 * Get all DataTable tables that have been initialised - optionally you can
 * select to get only currently visible tables.
 *
 *  @param {boolean} [visible=false] Flag to indicate if you want all (default)
 *    or visible tables only.
 *  @returns {array} Array of `table` nodes (not DataTable instances) which are
 *    DataTables
 *  @static
 *  @dtopt API-Static
 *
 *  @example
 *    $.each( $.fn.dataTable.tables(true), function () {
 *      $(table).DataTable().columns.adjust();
 *    } );
 */DataTable.tables=function(e){var n=false;if(t.isPlainObject(e)){n=e.api;e=e.visible}var i=DataTable.settings.filter((function(n){return!!(!e||e&&t(n.nTable).is(":visible"))})).map((function(e){return e.nTable}));return n?new r(i):i};
/**
 * Convert from camel case parameters to Hungarian notation. This is made public
 * for the extensions to provide the same ability as DataTables core to accept
 * either the 1.9 style Hungarian notation, or the 1.10+ style camelCase
 * parameters.
 *
 *  @param {object} src The model object which holds all parameters that can be
 *    mapped.
 *  @param {object} user The object to convert from camel case to Hungarian.
 *  @param {boolean} force When set to `true`, properties which already have a
 *    Hungarian value in the `user` object will be overwritten. Otherwise they
 *    won't be.
 */DataTable.camelToHungarian=_fnCamelToHungarian;i("$()",(function(e,n){var r=this.rows(n).nodes(),i=t(r);return t([].concat(i.filter(e).toArray(),i.find(e).toArray()))}));t.each(["on","one","off"],(function(e,n){i(n+"()",(function(){var e=Array.prototype.slice.call(arguments);e[0]=e[0].split(/\s/).map((function(e){return e.match(/\.dt\b/)?e:e+".dt"})).join(" ");var r=t(this.tables().nodes());r[n].apply(r,e);return this}))}));i("clear()",(function(){return this.iterator("table",(function(e){_fnClearTable(e)}))}));i("error()",(function(e){return this.iterator("table",(function(t){_fnLog(t,0,e)}))}));i("settings()",(function(){return new r(this.context,this.context)}));i("init()",(function(){var e=this.context;return e.length?e[0].oInit:null}));i("data()",(function(){return this.iterator("table",(function(e){return _pluck(e.aoData,"_aData")})).flatten()}));i("trigger()",(function(e,t,n){return this.iterator("table",(function(r){return _fnCallbackFire(r,null,e,t,n)})).flatten()}));i("ready()",(function(e){var t=this.context;return e?this.tables().every((function(){this.context[0]._bInitComplete?e.call(this):this.on("init",(function(){e.call(this)}))})):t.length?t[0]._bInitComplete||false:null}));i("destroy()",(function(e){e=e||false;return this.iterator("table",(function(n){var i=n.oClasses;var o=n.nTable;var l=n.nTBody;var s=n.nTHead;var u=n.nTFoot;var f=t(o);var c=t(l);var d=t(n.nTableWrapper);var p=n.aoData.map((function(e){return e?e.nTr:null}));var h=i.order;n.bDestroying=true;_fnCallbackFire(n,"aoDestroyCallback","destroy",[n],true);e||new r(n).columns().visible(true);d.off(".DT").find(":not(tbody *)").off(".DT");t(window).off(".DT-"+n.sInstance);if(o!=s.parentNode){f.children("thead").detach();f.append(s)}if(u&&o!=u.parentNode){f.children("tfoot").detach();f.append(u)}n.colgroup.remove();n.aaSorting=[];n.aaSortingFixed=[];_fnSortingClasses(n);t("th, td",s).removeClass(h.canAsc+" "+h.canDesc+" "+h.isAsc+" "+h.isDesc).css("width","");c.children().detach();c.append(p);var v=n.nTableWrapper.parentNode;var g=n.nTableWrapper.nextSibling;var m=e?"remove":"detach";f[m]();d[m]();if(!e&&v){v.insertBefore(o,g);f.css("width",n.sDestroyWidth).removeClass(i.table)}var _=DataTable.settings.indexOf(n);_!==-1&&DataTable.settings.splice(_,1)}))}));t.each(["column","row","cell"],(function(e,t){i(t+"s().every()",(function(e){var n=this.selector.opts;var r=this;var i;var o=0;return this.iterator("every",(function(l,s,u){i=r[t](s,n);t==="cell"?e.call(i,i[0][0].row,i[0][0].column,u,o):e.call(i,s,u,o);o++}))}))}));i("i18n()",(function(e,n,r){var i=this.context[0];var o=g(e)(i.oLanguage);o===void 0&&(o=n);t.isPlainObject(o)&&(o=r!==void 0&&o[r]!==void 0?o[r]:o._);return typeof o==="string"?o.replace("%d",r):o}));
/**
 * Version string for plug-ins to check compatibility. Allowed format is
 * `a.b.c-d` where: a:int, b:int, c:int, d:string(dev|beta|alpha). `d` is used
 * only for non-release builds. See https://semver.org/ for more information.
 *  @member
 *  @type string
 *  @default Version number
 */DataTable.version="2.0.7";
/**
 * Private data store, containing all of the settings objects that are
 * created for the tables on a given page.
 *
 * Note that the `DataTable.settings` object is aliased to
 * `jQuery.fn.dataTableExt` through which it may be accessed and
 * manipulated, or `jQuery.fn.dataTable.settings`.
 *  @member
 *  @type array
 *  @default []
 *  @private
 */DataTable.settings=[];DataTable.models={};DataTable.models.oSearch={caseInsensitive:true,search:"",regex:false,smart:true,return:false};DataTable.models.oRow={nTr:null,anCells:null,_aData:[],_aSortData:null,_aFilterData:null,_sFilterRow:null,src:null,idx:-1,displayData:null};DataTable.models.oColumn={idx:null,aDataSort:null,asSorting:null,bSearchable:null,bSortable:null,bVisible:null,_sManualType:null,_bAttrSrc:false,fnCreatedCell:null,fnGetData:null,fnSetData:null,mData:null,mRender:null,sClass:null,sContentPadding:null,sDefaultContent:null,sName:null,sSortDataType:"std",sSortingClass:null,sTitle:null,sType:null,sWidth:null,sWidthOrig:null,maxLenString:null,searchFixed:null};DataTable.defaults={aaData:null,aaSorting:[[0,"asc"]],aaSortingFixed:[],ajax:null,aLengthMenu:[10,25,50,100],aoColumns:null,aoColumnDefs:null,aoSearchCols:[],bAutoWidth:true,bDeferRender:true,bDestroy:false,bFilter:true,
/**
	 * Used only for compatiblity with DT1
	 * @deprecated
	 */
bInfo:true,
/**
	 * Used only for compatiblity with DT1
	 * @deprecated
	 */
bLengthChange:true,bPaginate:true,bProcessing:false,bRetrieve:false,bScrollCollapse:false,bServerSide:false,bSort:true,bSortMulti:true,bSortCellsTop:null,bSortClasses:true,bStateSave:false,fnCreatedRow:null,fnDrawCallback:null,fnFooterCallback:null,fnFormatNumber:function(e){return e.toString().replace(/\B(?=(\d{3})+(?!\d))/g,this.oLanguage.sThousands)},fnHeaderCallback:null,fnInfoCallback:null,fnInitComplete:null,fnPreDrawCallback:null,fnRowCallback:null,fnStateLoadCallback:function(e){try{return JSON.parse((e.iStateDuration===-1?sessionStorage:localStorage).getItem("DataTables_"+e.sInstance+"_"+location.pathname))}catch(e){return{}}},fnStateLoadParams:null,fnStateLoaded:null,fnStateSaveCallback:function(e,t){try{(e.iStateDuration===-1?sessionStorage:localStorage).setItem("DataTables_"+e.sInstance+"_"+location.pathname,JSON.stringify(t))}catch(e){}},fnStateSaveParams:null,iStateDuration:7200,iDisplayLength:10,iDisplayStart:0,iTabIndex:0,oClasses:{},oLanguage:{oAria:{orderable:": Activate to sort",orderableReverse:": Activate to invert sorting",orderableRemove:": Activate to remove sorting",paginate:{first:"First",last:"Last",next:"Next",previous:"Previous"}},oPaginate:{sFirst:"«",sLast:"»",sNext:"›",sPrevious:"‹"},entries:{_:"entries",1:"entry"},sEmptyTable:"No data available in table",sInfo:"Showing _START_ to _END_ of _TOTAL_ _ENTRIES-TOTAL_",sInfoEmpty:"Showing 0 to 0 of 0 _ENTRIES-TOTAL_",sInfoFiltered:"(filtered from _MAX_ total _ENTRIES-MAX_)",sInfoPostFix:"",sDecimal:"",sThousands:",",sLengthMenu:"_MENU_ _ENTRIES_ per page",sLoadingRecords:"Loading...",sProcessing:"",sSearch:"Search:",
/**
		 * Assign a `placeholder` attribute to the search `input` element
		 *  @type string
		 *  @default 
		 *
		 *  @dtopt Language
		 *  @name DataTable.defaults.language.searchPlaceholder
		 */
sSearchPlaceholder:"",sUrl:"",sZeroRecords:"No matching records found"},oSearch:t.extend({},DataTable.models.oSearch),layout:{topStart:"pageLength",topEnd:"search",bottomStart:"info",bottomEnd:"paging"},sDom:null,searchDelay:null,sPaginationType:"full_numbers",sScrollX:"",sScrollXInner:"",sScrollY:"",sServerMethod:"GET",renderer:null,rowId:"DT_RowId",caption:null};_fnHungarianMap(DataTable.defaults);DataTable.defaults.column={aDataSort:null,iDataSort:-1,ariaTitle:"",asSorting:["asc","desc",""],bSearchable:true,bSortable:true,bVisible:true,fnCreatedCell:null,mData:null,mRender:null,sCellType:"td",sClass:"",sContentPadding:"",sDefaultContent:null,sName:"",sSortDataType:"std",sTitle:null,sType:null,sWidth:null};_fnHungarianMap(DataTable.defaults.column);DataTable.models.oSettings={oFeatures:{bAutoWidth:null,bDeferRender:null,bFilter:null,
/**
		 * Used only for compatiblity with DT1
		 * @deprecated
		 */
bInfo:true,
/**
		 * Used only for compatiblity with DT1
		 * @deprecated
		 */
bLengthChange:true,bPaginate:null,bProcessing:null,bServerSide:null,bSort:null,bSortMulti:null,bSortClasses:null,bStateSave:null},oScroll:{bCollapse:null,iBarWidth:0,sX:null,
/**
		 * Width to expand the table to when using x-scrolling. Typically you
		 * should not need to use this.
		 * Note that this parameter will be set by the initialisation routine. To
		 * set a default use {@link DataTable.defaults}.
		 *  @deprecated
		 */
sXInner:null,sY:null},oLanguage:{fnInfoCallback:null},oBrowser:{bScrollbarLeft:false,barWidth:0},ajax:null,aanFeatures:[],aoData:[],aiDisplay:[],aiDisplayMaster:[],aIds:{},aoColumns:[],aoHeader:[],aoFooter:[],oPreviousSearch:{},searchFixed:{},aoPreSearchCols:[],aaSorting:null,aaSortingFixed:[],sDestroyWidth:0,aoRowCallback:[],aoHeaderCallback:[],aoFooterCallback:[],aoDrawCallback:[],aoRowCreatedCallback:[],aoPreDrawCallback:[],aoInitComplete:[],aoStateSaveParams:[],aoStateLoadParams:[],aoStateLoaded:[],sTableId:"",nTable:null,nTHead:null,nTFoot:null,nTBody:null,nTableWrapper:null,bInitialised:false,aoOpenRows:[],sDom:null,searchDelay:null,sPaginationType:"two_button",pagingControls:0,iStateDuration:0,aoStateSave:[],aoStateLoad:[],oSavedState:null,oLoadedState:null,bAjaxDataGet:true,jqXHR:null,json:void 0,oAjaxData:void 0,sServerMethod:null,fnFormatNumber:null,aLengthMenu:null,iDraw:0,bDrawing:false,iDrawError:-1,_iDisplayLength:10,_iDisplayStart:0,_iRecordsTotal:0,_iRecordsDisplay:0,oClasses:{},
/**
	 * Flag attached to the settings object so you can check in the draw
	 * callback if filtering has been done in the draw. Deprecated in favour of
	 * events.
	 *  @deprecated
	 */
bFiltered:false,
/**
	 * Flag attached to the settings object so you can check in the draw
	 * callback if sorting has been done in the draw. Deprecated in favour of
	 * events.
	 *  @deprecated
	 */
bSorted:false,bSortCellsTop:null,oInit:null,aoDestroyCallback:[],fnRecordsTotal:function(){return _fnDataSource(this)=="ssp"?this._iRecordsTotal*1:this.aiDisplayMaster.length},fnRecordsDisplay:function(){return _fnDataSource(this)=="ssp"?this._iRecordsDisplay*1:this.aiDisplay.length},fnDisplayEnd:function(){var e=this._iDisplayLength,t=this._iDisplayStart,n=t+e,r=this.aiDisplay.length,i=this.oFeatures,o=i.bPaginate;return i.bServerSide?o===false||e===-1?t+r:Math.min(t+e,this._iRecordsDisplay):!o||n>r||e===-1?r:n},oInstance:null,sInstance:null,iTabIndex:0,nScrollHead:null,nScrollFoot:null,aLastSort:[],oPlugins:{},rowIdFn:null,rowId:null,caption:"",captionNode:null,colgroup:null};var F=DataTable.ext.pager;t.extend(F,{simple:function(){return["previous","next"]},full:function(){return["first","previous","next","last"]},numbers:function(){return["numbers"]},simple_numbers:function(){return["previous","numbers","next"]},full_numbers:function(){return["first","previous","numbers","next","last"]},first_last:function(){return["first","last"]},first_last_numbers:function(){return["first","numbers","last"]},_numbers:_pagingNumbers,numbers_length:7});t.extend(true,DataTable.ext.renderer,{pagingButton:{_:function(e,n,r,i,o){var l=e.oClasses.paging;var s=[l.button];var u;i&&s.push(l.active);o&&s.push(l.disabled);u=n==="ellipsis"?t('<span class="ellipsis"></span>').html(r)[0]:t("<button>",{class:s.join(" "),role:"link",type:"button"}).html(r);return{display:u,clicker:u}}},pagingContainer:{_:function(e,t){return t}}});var _filterString=function(e,t){return function(n){if(_empty(n)||typeof n!=="string")return n;n=n.replace(s," ");e&&(n=_stripHtml(n));t&&(n=_normalize(n,false));return n}};function __mldFnName(e){return e.replace(/[\W]/g,"_")}function __mld(e,t,n,r,i){return window.moment?e[t](i):window.luxon?e[n](i):r?e[r](i):e}var I=false;function __mldObj(e,t,n){var r;if(window.moment){r=window.moment.utc(e,t,n,true);if(!r.isValid())return null}else if(window.luxon){r=t&&typeof e==="string"?window.luxon.DateTime.fromFormat(e,t):window.luxon.DateTime.fromISO(e);if(!r.isValid)return null;r.setLocale(n)}else if(t){I||alert("DataTables warning: Formatted date without Moment.js or Luxon - https://datatables.net/tn/17");I=true}else r=new Date(e);return r}function __mlHelper(e){return function(t,n,r,i){if(arguments.length===0){r="en";n=null;t=null}else if(arguments.length===1){r="en";n=t;t=null}else if(arguments.length===2){r=n;n=t;t=null}var o="datetime"+(n?"-"+__mldFnName(n):"");DataTable.ext.type.order[o]||DataTable.type(o,{detect:function(e){return e===o&&o},order:{pre:function(e){return e.valueOf()}},className:"dt-right"});return function(l,s){if(l===null||l===void 0)if(i==="--now"){var u=new Date;l=new Date(Date.UTC(u.getFullYear(),u.getMonth(),u.getDate(),u.getHours(),u.getMinutes(),u.getSeconds()))}else l="";if(s==="type")return o;if(l==="")return s!=="sort"?"":__mldObj("0000-01-01 00:00:00",null,r);if(n!==null&&t===n&&s!=="sort"&&s!=="type"&&!(l instanceof Date))return l;var f=__mldObj(l,t,r);if(f===null)return l;if(s==="sort")return f;var c=n===null?__mld(f,"toDate","toJSDate","")[e]():__mld(f,"format","toFormat","toISOString",n);return s==="display"?_escapeHtml(c):c}}}var L=",";var R=".";if(window.Intl!==void 0)try{var j=(new Intl.NumberFormat).formatToParts(100000.1);for(var P=0;P<j.length;P++)j[P].type==="group"?L=j[P].value:j[P].type==="decimal"&&(R=j[P].value)}catch(e){}DataTable.datetime=function(e,t){var n="datetime-detect-"+__mldFnName(e);t||(t="en");DataTable.ext.type.order[n]||DataTable.type(n,{detect:function(r){var i=__mldObj(r,e,t);return!(r!==""&&!i)&&n},order:{pre:function(n){return __mldObj(n,e,t)||0}},className:"dt-right"})};DataTable.render={date:__mlHelper("toLocaleDateString"),datetime:__mlHelper("toLocaleString"),time:__mlHelper("toLocaleTimeString"),number:function(e,t,n,r,i){e!==null&&e!==void 0||(e=L);t!==null&&t!==void 0||(t=R);return{display:function(o){if(typeof o!=="number"&&typeof o!=="string")return o;if(o===""||o===null)return o;var l=o<0?"-":"";var s=parseFloat(o);var u=Math.abs(s);if(u>=1e11||u<1e-4&&u!==0){var f=s.toExponential(n).split(/e\+?/);return f[0]+" x 10<sup>"+f[1]+"</sup>"}if(isNaN(s))return _escapeHtml(o);s=s.toFixed(n);o=Math.abs(s);var c=parseInt(o,10);var d=n?t+(o-c).toFixed(n).substring(2):"";c===0&&parseFloat(d)===0&&(l="");return l+(r||"")+c.toString().replace(/\B(?=(\d{3})+(?!\d))/g,e)+d+(i||"")}}},text:function(){return{display:_escapeHtml,filter:_escapeHtml}}};var N=DataTable.ext.type;DataTable.type=function(e,t,n){if(!t)return{className:N.className[e],detect:N.detect.find((function(t){return t.name===e})),order:{pre:N.order[e+"-pre"],asc:N.order[e+"-asc"],desc:N.order[e+"-desc"]},render:N.render[e],search:N.search[e]};var setProp=function(t,n){N[t][e]=n};var setDetect=function(t){var cb=function(n,r){var i=t(n,r);return i===true?e:i};Object.defineProperty(cb,"name",{value:e});var n=N.detect.findIndex((function(t){return t.name===e}));n===-1?N.detect.unshift(cb):N.detect.splice(n,1,cb)};var setOrder=function(t){N.order[e+"-pre"]=t.pre;N.order[e+"-asc"]=t.asc;N.order[e+"-desc"]=t.desc};if(n===void 0){n=t;t=null}if(t==="className")setProp("className",n);else if(t==="detect")setDetect(n);else if(t==="order")setOrder(n);else if(t==="render")setProp("render",n);else if(t==="search")setProp("search",n);else if(!t){n.className&&setProp("className",n.className);n.detect!==void 0&&setDetect(n.detect);n.order&&setOrder(n.order);n.render!==void 0&&setProp("render",n.render);n.search!==void 0&&setProp("search",n.search)}};DataTable.types=function(){return N.detect.map((function(e){return e.name}))};DataTable.type("string",{detect:function(){return"string"},order:{pre:function(e){return _empty(e)?"":typeof e==="string"?e.toLowerCase():e.toString?e.toString():""}},search:_filterString(false,true)});DataTable.type("html",{detect:function(e){return _empty(e)||typeof e==="string"&&e.indexOf("<")!==-1?"html":null},order:{pre:function(e){return _empty(e)?"":e.replace?_stripHtml(e).trim().toLowerCase():e+""}},search:_filterString(true,true)});DataTable.type("date",{className:"dt-type-date",detect:function(e){if(e&&!(e instanceof Date)&&!c.test(e))return null;var t=Date.parse(e);return t!==null&&!isNaN(t)||_empty(e)?"date":null},order:{pre:function(e){var t=Date.parse(e);return isNaN(t)?-Infinity:t}}});DataTable.type("html-num-fmt",{className:"dt-type-numeric",detect:function(e,t){var n=t.oLanguage.sDecimal;return _htmlNumeric(e,n,true)?"html-num-fmt":null},order:{pre:function(e,t){var n=t.oLanguage.sDecimal;return __numericReplace(e,n,u,p)}},search:_filterString(true,true)});DataTable.type("html-num",{className:"dt-type-numeric",detect:function(e,t){var n=t.oLanguage.sDecimal;return _htmlNumeric(e,n)?"html-num":null},order:{pre:function(e,t){var n=t.oLanguage.sDecimal;return __numericReplace(e,n,u)}},search:_filterString(true,true)});DataTable.type("num-fmt",{className:"dt-type-numeric",detect:function(e,t){var n=t.oLanguage.sDecimal;return _isNumber(e,n,true)?"num-fmt":null},order:{pre:function(e,t){var n=t.oLanguage.sDecimal;return __numericReplace(e,n,p)}}});DataTable.type("num",{className:"dt-type-numeric",detect:function(e,t){var n=t.oLanguage.sDecimal;return _isNumber(e,n)?"num":null},order:{pre:function(e,t){var n=t.oLanguage.sDecimal;return __numericReplace(e,n)}}});var __numericReplace=function(e,t,n,r){if(e!==0&&(!e||e==="-"))return-Infinity;var i=typeof e;if(i==="number"||i==="bigint")return e;t&&(e=_numToDecimal(e,t));if(e.replace){n&&(e=e.replace(n,""));r&&(e=e.replace(r,""))}return e*1};t.extend(true,DataTable.ext.renderer,{footer:{_:function(e,t,n){t.addClass(n.tfoot.cell)}},header:{_:function(e,n,r){n.addClass(r.thead.cell);e.oFeatures.bSort||n.addClass(r.order.none);var i=e.bSortCellsTop;var o=n.closest("thead").find("tr");var l=n.parent().index();n.attr("data-dt-order")==="disable"||n.parent().attr("data-dt-order")==="disable"||i===true&&l!==0||i===false&&l!==o.length-1||t(e.nTable).on("order.dt.DT",(function(t,i,o){if(e===i){var l=r.order;var s=i.api.columns(n);var u=e.aoColumns[s.flatten()[0]];var f=s.orderable().includes(true);var c="";var d=s.indexes();var p=s.orderable(true).flatten();var h=","+o.map((function(e){return e.col})).join(",")+",";n.removeClass(l.isAsc+" "+l.isDesc).toggleClass(l.none,!f).toggleClass(l.canAsc,f&&p.includes("asc")).toggleClass(l.canDesc,f&&p.includes("desc"));var v=h.indexOf(","+d.toArray().join(",")+",");if(v!==-1){var g=s.order();n.addClass(g.includes("asc")?l.isAsc:""+g.includes("desc")?l.isDesc:"")}if(v===0){var m=o[0];var _=u.asSorting;n.attr("aria-sort",m.dir==="asc"?"ascending":"descending");c=_[m.index+1]?"Reverse":"Remove"}else n.removeAttr("aria-sort");n.attr("aria-label",f?u.ariaTitle+i.api.i18n("oAria.orderable"+c):u.ariaTitle);if(f){n.find(".dt-column-title").attr("role","button");n.attr("tabindex",0)}}}))}},layout:{_:function(e,n,r){var i=t("<div/>").addClass("dt-layout-row").appendTo(n);t.each(r,(function(e,n){var r=n.table?"":"dt-"+e+" ";n.table&&i.addClass("dt-layout-table");t("<div/>").attr({id:n.id||null,class:"dt-layout-cell "+r+(n.className||"")}).append(n.contents).appendTo(i)}))}}});DataTable.feature={};DataTable.feature.register=function(e,t,r){DataTable.ext.features[e]=t;r&&n.feature.push({cFeature:r,fnInit:t})};DataTable.feature.register("info",(function(e,n){if(!e.oFeatures.bInfo)return null;var r=e.oLanguage,i=e.sTableId,o=t("<div/>",{class:e.oClasses.info.container});n=t.extend({callback:r.fnInfoCallback,empty:r.sInfoEmpty,postfix:r.sInfoPostFix,search:r.sInfoFiltered,text:r.sInfo},n);e.aoDrawCallback.push((function(e){_fnUpdateInfo(e,n,o)}));if(!e._infoEl){o.attr({"aria-live":"polite",id:i+"_info",role:"status"});t(e.nTable).attr("aria-describedby",i+"_info");e._infoEl=o}return o}),"i");
/**
 * Update the information elements in the display
 *  @param {object} settings dataTables settings object
 *  @memberof DataTable#oApi
 */function _fnUpdateInfo(e,t,n){var r=e._iDisplayStart+1,i=e.fnDisplayEnd(),o=e.fnRecordsTotal(),l=e.fnRecordsDisplay(),s=l?t.text:t.empty;l!==o&&(s+=" "+t.search);s+=t.postfix;s=_fnMacros(e,s);t.callback&&(s=t.callback.call(e.oInstance,e,r,i,o,l,s));n.html(s);_fnCallbackFire(e,null,"info",[e,n[0],s])}var k=0;DataTable.feature.register("search",(function(e,n){if(!e.oFeatures.bFilter)return null;var r=e.oClasses.search;var i=e.sTableId;var o=e.oLanguage;var l=e.oPreviousSearch;var s='<input type="search" class="'+r.input+'"/>';n=t.extend({placeholder:o.sSearchPlaceholder,text:o.sSearch},n);n.text.indexOf("_INPUT_")===-1&&(n.text+="_INPUT_");n.text=_fnMacros(e,n.text);var u=n.text.match(/_INPUT_$/);var f=n.text.match(/^_INPUT_/);var c=n.text.replace(/_INPUT_/,"");var d="<label>"+n.text+"</label>";f?d="_INPUT_<label>"+c+"</label>":u&&(d="<label>"+c+"</label>_INPUT_");var p=t("<div>").addClass(r.container).append(d.replace(/_INPUT_/,s));p.find("label").attr("for","dt-search-"+k);p.find("input").attr("id","dt-search-"+k);k++;var searchFn=function(t){var n=this.value;if((!l.return||t.key==="Enter")&&n!=l.search){l.search=n;_fnFilterComplete(e,l);e._iDisplayStart=0;_fnDraw(e)}};var h=e.searchDelay!==null?e.searchDelay:0;var v=t("input",p).val(l.search).attr("placeholder",n.placeholder).on("keyup.DT search.DT input.DT paste.DT cut.DT",h?DataTable.util.debounce(searchFn,h):searchFn).on("mouseup.DT",(function(e){setTimeout((function(){searchFn.call(v[0],e)}),10)})).on("keypress.DT",(function(e){if(e.keyCode==13)return false})).attr("aria-controls",i);t(e.nTable).on("search.dt.DT",(function(t,n){e===n&&v[0]!==document.activeElement&&v.val(typeof l.search!=="function"?l.search:"")}));return p}),"f");DataTable.feature.register("paging",(function(e,n){if(!e.oFeatures.bPaginate)return null;n=t.extend({buttons:DataTable.ext.pager.numbers_length,type:e.sPaginationType,boundaryNumbers:true},n);n.numbers&&(n.buttons=n.numbers);var r=t("<div/>").addClass(e.oClasses.paging.container+" paging_"+n.type);var draw=function(){_pagingDraw(e,r,n)};e.aoDrawCallback.push(draw);t(e.nTable).on("column-sizing.dt.DT",draw);return r}),"p");function _pagingDraw(e,n,r){if(e._bInitComplete){var i=DataTable.ext.pager[r.type],o=e.oLanguage.oAria.paginate||{},l=e._iDisplayStart,s=e._iDisplayLength,u=e.fnRecordsDisplay(),f=s===-1,c=f?0:Math.ceil(l/s),d=f?1:Math.ceil(u/s),p=i().map((function(e){return e==="numbers"?_pagingNumbers(c,d,r.buttons,r.boundaryNumbers):e})).flat();var h=[];for(var v=0;v<p.length;v++){var g=p[v];var m=_pagingButtonInfo(e,g,c,d);var _=_fnRenderer(e,"pagingButton")(e,g,m.display,m.active,m.disabled);t(_.clicker).attr({"aria-controls":e.sTableId,"aria-disabled":m.disabled?"true":null,"aria-current":m.active?"page":null,"aria-label":o[g],"data-dt-idx":g,tabIndex:m.disabled?-1:e.iTabIndex});typeof g!=="number"&&t(_.clicker).addClass(g);_fnBindAction(_.clicker,{action:g},(function(t){t.preventDefault();_fnPageChange(e,t.data.action,true)}));h.push(_.display)}var b=_fnRenderer(e,"pagingContainer")(e,h);var y=n.find(document.activeElement).data("dt-idx");n.empty().append(b);y!==void 0&&n.find("[data-dt-idx="+y+"]").trigger("focus");h.length&&r.numbers>1&&t(n).height()>=t(h[0]).outerHeight()*2-10&&_pagingDraw(e,n,t.extend({},r,{numbers:r.numbers-2}))}}
/**
 * Get properties for a button based on the current paging state of the table
 *
 * @param {*} settings DT settings object
 * @param {*} button The button type in question
 * @param {*} page Table's current page
 * @param {*} pages Number of pages
 * @returns Info object
 */function _pagingButtonInfo(e,t,n,r){var i=e.oLanguage.oPaginate;var o={display:"",active:false,disabled:false};switch(t){case"ellipsis":o.display="&#x2026;";o.disabled=true;break;case"first":o.display=i.sFirst;n===0&&(o.disabled=true);break;case"previous":o.display=i.sPrevious;n===0&&(o.disabled=true);break;case"next":o.display=i.sNext;r!==0&&n!==r-1||(o.disabled=true);break;case"last":o.display=i.sLast;r!==0&&n!==r-1||(o.disabled=true);break;default:if(typeof t==="number"){o.display=e.fnFormatNumber(t+1);n===t&&(o.active=true)}break}return o}
/**
 * Compute what number buttons to show in the paging control
 *
 * @param {*} page Current page
 * @param {*} pages Total number of pages
 * @param {*} buttons Target number of number buttons
 * @param {boolean} addFirstLast Indicate if page 1 and end should be included
 * @returns Buttons to show
 */function _pagingNumbers(e,t,n,r){var i=[],o=Math.floor(n/2),l=r?2:1,s=r?1:0;if(t<=n)i=_range(0,t);else if(n===1)i=[e];else if(n===3)if(e<=1)i=[0,1,"ellipsis"];else if(e>=t-2){i=_range(t-2,t);i.unshift("ellipsis")}else i=["ellipsis",e,"ellipsis"];else if(e<=o){i=_range(0,n-l);i.push("ellipsis");r&&i.push(t-1)}else if(e>=t-1-o){i=_range(t-(n-l),t);i.unshift("ellipsis");r&&i.unshift(0)}else{i=_range(e-o+l,e+o-s);i.push("ellipsis");i.unshift("ellipsis");if(r){i.push(t-1);i.unshift(0)}}return i}var O=0;DataTable.feature.register("pageLength",(function(e,n){var r=e.oFeatures;if(!r.bPaginate||!r.bLengthChange)return null;n=t.extend({menu:e.aLengthMenu,text:e.oLanguage.sLengthMenu},n);var i,o=e.oClasses.length,l=e.sTableId,s=n.menu,u=[],f=[];if(Array.isArray(s[0])){u=s[0];f=s[1]}else for(i=0;i<s.length;i++)if(t.isPlainObject(s[i])){u.push(s[i].value);f.push(s[i].label)}else{u.push(s[i]);f.push(s[i])}var c=n.text.match(/_MENU_$/);var d=n.text.match(/^_MENU_/);var p=n.text.replace(/_MENU_/,"");var h="<label>"+n.text+"</label>";d?h="_MENU_<label>"+p+"</label>":c&&(h="<label>"+p+"</label>_MENU_");var v=t("<div/>").addClass(o.container).append(h.replace("_MENU_","<span></span>"));var g=[];v.find("label")[0].childNodes.forEach((function(e){e.nodeType===Node.TEXT_NODE&&g.push({el:e,text:e.textContent})}));var updateEntries=function(t){g.forEach((function(n){n.el.textContent=_fnMacros(e,n.text,t)}))};var m=t("<select/>",{name:l+"_length","aria-controls":l,class:o.select});for(i=0;i<u.length;i++)m[0][i]=new Option(typeof f[i]==="number"?e.fnFormatNumber(f[i]):f[i],u[i]);v.find("label").attr("for","dt-length-"+O);m.attr("id","dt-length-"+O);O++;v.find("span").replaceWith(m);t("select",v).val(e._iDisplayLength).on("change.DT",(function(){_fnLengthChange(e,t(this).val());_fnDraw(e)}));t(e.nTable).on("length.dt.DT",(function(n,r,i){if(e===r){t("select",v).val(i);updateEntries(i)}}));updateEntries(e._iDisplayLength);return v}),"l");t.fn.dataTable=DataTable;DataTable.$=t;t.fn.dataTableSettings=DataTable.settings;t.fn.dataTableExt=DataTable.ext;t.fn.DataTable=function(e){return t(this).dataTable(e).api()};t.each(DataTable,(function(e,n){t.fn.DataTable[e]=n}));export{DataTable as default};

