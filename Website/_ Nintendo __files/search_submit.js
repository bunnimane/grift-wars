var _____WB$wombat$assign$function_____ = function(name) {return (self._wb_wombat && self._wb_wombat.local_init && self._wb_wombat.local_init(name)) || self[name]; };
if (!self.__WB_pmw) { self.__WB_pmw = function(obj) { this.__WB_source = obj; return this; } }
{
  let window = _____WB$wombat$assign$function_____("window");
  let self = _____WB$wombat$assign$function_____("self");
  let document = _____WB$wombat$assign$function_____("document");
  let location = _____WB$wombat$assign$function_____("location");
  let top = _____WB$wombat$assign$function_____("top");
  let parent = _____WB$wombat$assign$function_____("parent");
  let frames = _____WB$wombat$assign$function_____("frames");
  let opener = _____WB$wombat$assign$function_____("opener");

function trim( myStr ) {
   var isFirst = true;
   var fIndex = 0;
   var lIndex = 0;

   for ( var i = 0; i < myStr.value.length ; i ++ ) {
      var ch = myStr.value.charAt( i );
      if ( isFirst ) {
         if ( ch == ' ' || ch == '\t' ) {
            fIndex = i + 1;
            lIndex = i + 1;
         } else {
            isFirst = false;
         }
      } else {
         if ( ch != ' ' && ch != '\t' ) {
            lIndex = i;
         }
      }
   }
   var mySubStr = myStr.value.substring( fIndex, lIndex+1 );
   return mySubStr.length;
}

function submitQuery() {
   if ( trim( document.search.query ) == 0 ) {
      alert("Please enter a search query and then press go" );
   } else {
      document.search.submit();
   }
}


}
/*
     FILE ARCHIVED ON 23:10:15 Aug 02, 2002 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 05:12:14 Jan 25, 2023.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
*/
/*
playback timings (ms):
  captures_list: 198.799
  exclusion.robots: 0.074
  exclusion.robots.policy: 0.066
  cdx.remote: 0.063
  esindex: 0.009
  LoadShardBlock: 164.145 (3)
  PetaboxLoader3.datanode: 162.018 (4)
  CDXLines.iter: 24.088 (3)
  load_resource: 83.846
  PetaboxLoader3.resolve: 60.683
*/