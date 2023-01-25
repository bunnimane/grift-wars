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

<!--
var pageLoc = top.location.href;
var stickyBig = '/styles/homepage/medium/topnav_mario.gif';
    
var imageOff;
var imageOn;
var bigOn;

function initRollovers() {
  if (document.images) {
    imageOff = new Array();
    imageOn = new Array();
    bigOn = new Array();

    // Start configurable variables
    var imageDirectory = '/images/';
    var imageOffFiles = new Array('topnav_games.gif','topnav_systems.gif','topnav_news.gif','topnav_nsider.gif','topnav_downloads.gif','topnav_spacer.gif','../styles/homepage/medium/home_ninlogo.gif');
    var imageOnFiles = new Array('topnav_games_on.gif','topnav_systems_on.gif','topnav_news_on.gif','topnav_nsider_on.gif','topnav_downloads_on.gif','topnav_spacer.gif','../styles/homepage/medium/home_ninlogo.gif');
    var bigOnFiles = new Array('../styles/homepage/medium/topnav_mario1.gif','../styles/homepage/medium/topnav_mario2.gif','../styles/homepage/medium/topnav_mario3.gif','../styles/homepage/medium/topnav_mario4.gif','../styles/homepage/medium/topnav_mario5.gif','../styles/homepage/medium/topnav_blank.gif','../styles/homepage/medium/topnav_mario.gif');
    var imageTagNames = new Array('games','systems','news','nsider','downloads','spacer','home');
    // End configurable variables
		
    for (var i = 0; i < imageOnFiles.length; i++) {
      currentName = imageTagNames[i];
      imageOff[currentName] = new Image();
      imageOn[currentName] = new Image();
      bigOn[currentName] = new Image();
      imageOff[currentName].src = imageDirectory + imageOffFiles[i];
      imageOn[currentName].src = imageDirectory + imageOnFiles[i];
      bigOn[currentName].src = imageDirectory + bigOnFiles[i];
    }
  }
}



function rollon(img) {
  if (document.images && typeof imageOn == "object" && imageOn[img]) {
    if(pageLoc.indexOf('games') != -1){
      document.images['games'].src = imageOff['games'].src;
    }else if(pageLoc.indexOf('systems') != -1){
      document.images['systems'].src = imageOff['systems'].src;
    }else if(pageLoc.indexOf('news') != -1){
      document.images['news'].src = imageOff['news'].src;
    }else if(pageLoc.indexOf('nsider') != -1){
      document.images['nsider'].src = imageOff['nsider'].src;
    }else if(pageLoc.indexOf('downloads') != -1){
      document.images['downloads'].src = imageOff['downloads'].src;
    }
    document.images[img].src = imageOn[img].src;
    document.images.big.src = bigOn[img].src;
 
  }
}

function rolloff(img) {
  if (document.images && typeof imageOff == "object" && imageOff[img]) {
    document.images[img].src = imageOff[img].src;
    if(pageLoc.indexOf('games') != -1){
      stickyBig = bigOn['games'].src;
      document.images['games'].src = imageOn['games'].src;
    }else if(pageLoc.indexOf('systems') != -1){
      stickyBig = bigOn['systems'].src;
      document.images['systems'].src = imageOn['systems'].src;
    }else if(pageLoc.indexOf('news') != -1){
      stickyBig = bigOn['news'].src;
      document.images['news'].src = imageOn['news'].src;
    }else if(pageLoc.indexOf('nsider') != -1){
      stickyBig = bigOn['nsider'].src;
      document.images['nsider'].src = imageOn['nsider'].src;
    }else if(pageLoc.indexOf('downloads') != -1){
      stickyBig = bigOn['downloads'].src;
      document.images['downloads'].src = imageOn['downloads'].src;
    }
    document.images.big.src = stickyBig;
  }
}

function adjustNav(){
  
if(pageLoc.indexOf('games') != -1){
      document.images.big.src = '/styles/homepage/medium/topnav_mario1.gif';
      document.images['games'].src = '/images/topnav_games_on.gif';
    }else if(pageLoc.indexOf('systems') != -1){
      document.images.big.src = '/styles/homepage/medium/topnav_mario2.gif';
      document.images['systems'].src = '/images/topnav_systems_on.gif';
    }else if(pageLoc.indexOf('news') != -1){
      document.images.big.src = '/styles/homepage/medium/topnav_mario3.gif';
      document.images['news'].src = '/images/topnav_news_on.gif';
    }else if(pageLoc.indexOf('nsider') != -1){
      document.images.big.src = '/styles/homepage/medium/topnav_mario4.gif';
      document.images['nsider'].src = '/images/topnav_nsider_on.gif';
    }else if(pageLoc.indexOf('downloads') != -1){
      document.images.big.src = '/styles/homepage/medium/topnav_mario5.gif';
      document.images['downloads'].src = '/images/topnav_downloads_on.gif';
    }else{
      document.images.big.src = '/styles/homepage/medium/topnav_mario.gif';
    }

}
//-->	

}
/*
     FILE ARCHIVED ON 23:09:48 Aug 02, 2002 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 05:12:13 Jan 25, 2023.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
*/
/*
playback timings (ms):
  captures_list: 125.863
  exclusion.robots: 0.082
  exclusion.robots.policy: 0.074
  cdx.remote: 0.067
  esindex: 0.009
  LoadShardBlock: 89.944 (3)
  PetaboxLoader3.datanode: 104.791 (4)
  CDXLines.iter: 21.05 (3)
  load_resource: 123.792
  PetaboxLoader3.resolve: 37.078
*/