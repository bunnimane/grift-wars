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

function writeInput(name,size,maxlength,value,clas){

if (is.win32) {
		if (is.ns6) size = size*0.5;
        else if (is.ns4) size = size*0.6 ;
}
else if (is.mac) {
		if (is.ns6up) size = size*.7;
        else if (is.ie4 && is.versionMinor <= 4.5) size = size * 0.4 ;
        else if (is.ns4) size = size*0.9 ; 
		else if (is.ie5up) size = size*.8;
}
size = Math.round (size);
 if (size < 1) size = 1


var props = ' name="'+name+'" size="'+size+'" maxlength="'+maxlength+'"'+ ((value)?' value="'+value+'"':'') +  ((clas)?' class="'+clas+'"':'');
document.writeln('<input type="text" '+props+'>');


}


function writePass(name,size,maxlength,value,clas){

if (is.win32) {
		if (is.ns6up) size = size*0.5;
        else if (is.ns4) size = size*0.6 ;
}
else if (is.mac) {
		if (is.ns6up) size = size*.7;
        else if (is.ie4 && is.versionMinor <= 4.5) size = size * 0.4 ;
        else if (is.ns4) size = size*0.9 ; 
		else if (is.ie5up) size = size*.8;
}
size = Math.round (size);
 if (size < 1) size = 1


var props = ' name="'+name+'" size="'+size+'" maxlength="'+maxlength+'"'+ ((value)?' value="'+value+'"':'') +  ((clas)?' class="'+clas+'"':'');
document.writeln('<input type="password" '+props+'>');


}


function writeNews(name,size,maxlength,value,clas){

if (is.win32) {
		if (is.ns6up) size = size*1.7 ;
        else if (is.ns4) size = size*0.2 ;
}
else if (is.mac) {
		if (is.ns6up) size = size*.9 ;
        else if (is.ie4 && is.versionMinor <= 4.5) size = size * 1.7 ;
        else if (is.ns4) size = size*1.7 ; 
		else if (is.ie5up) size = size*1.7;
}
size = Math.round (size);
 if (size < 1) size = 1


var props = ' name="'+name+'" size="'+size+'" maxlength="'+maxlength+'"'+ ((value)?' value="'+value+'"':'') +  ((clas)?' class="'+clas+'"':'');
document.writeln('<input type="text" '+props+'>');


}


}
/*
     FILE ARCHIVED ON 10:01:48 Sep 14, 2002 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 05:12:14 Jan 25, 2023.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
*/
/*
playback timings (ms):
  captures_list: 73.735
  exclusion.robots: 0.124
  exclusion.robots.policy: 0.113
  cdx.remote: 0.091
  esindex: 0.012
  LoadShardBlock: 45.311 (3)
  PetaboxLoader3.datanode: 46.47 (4)
  CDXLines.iter: 19.587 (3)
  load_resource: 61.489
  PetaboxLoader3.resolve: 38.857
*/