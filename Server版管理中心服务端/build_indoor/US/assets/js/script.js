//cookie check
// if (window.location.href.indexOf('login') < 0) {
//   if (getCookie("token") == '' || getCookie("name") == '') {
//     window.location.href = "./login.html";
//   }else{
//     $('.c-nav__right--username').html(getCookie("name"));
//   };
// }

//language check
if (window.location.href.indexOf('/CN/') != -1) {
  tem_lang = "zh"
}else if (window.location.href.indexOf('/US/') != -1) {
  tem_lang = "en"
}else if (window.location.href.indexOf('/HK/') != -1) {
  tem_lang = "hk"
}

var language_pack = {
  loadProperties: function () {
    jQuery.i18n.properties({
      name: 'string',
      path: 'language/',
      language: tem_lang,
      cache: false,
      mode: 'map',
      callback: function () {
        for (var i in $.i18n.map) {
          $('[data-lang="' + i + '"]').text($.i18n.map[i]);
        }
      }
    });
  }
}
$(document).ready(function () {
  language_pack.loadProperties(0);
});

//password <-> text, change type
$('i.pwdshow, i.pwdhide').click(function(){
  if ($(this).siblings('input').attr('type') == "password") {
    $(this).siblings('input').attr('type','text');
    $(this).removeClass('pwdshow').addClass('pwdhide')
  }else if($(this).siblings('input').attr('type') == "text"){
    $(this).siblings('input').attr('type','password');
    $(this).removeClass('pwdhide').addClass('pwdshow')
  }
})

//index page popup function
$('.c-homepage__list--event .button--blue').click(function(){
  $('.c-popup__details').addClass('is-active')
  var eventHtml = $('.c-homepage__list--event .c-homepage__list--item').html()
  var eventTime = $('.schedule-hd .today').html()
  $('.c-popup__details .c-popup__date').html(eventTime)
  $('.c-popup__details .c-popup__list').html(eventHtml)
})

$('.c-popup__details, .c-popup__details .button--blue').click(function(){
  $('.c-popup__details').removeClass('is-active')
})
$('.c-popup__block').click(function(e){
  return stopPropagation(e)
})

//venues back function
$('.c-venues__back').click(function(){
  $('#booking-venues').removeClass('is-active')
  $('.c-venues__item').removeClass('is-active')
})

//venues page datetime function
$('.c-venues__booking--leftBtn').click(function(){
  var oldDate = $('.c-venues__booking--date').attr('data-time')
  var newDate = parseInt(oldDate) - (24*60*60)
  newTime = getDateTime(newDate)
  weekDate = newTime.split('-')
  var dt = new Date(weekDate[0], weekDate[1] - 1, weekDate[2]);
  if (tem_lang == 'zh' || tem_lang == 'hk') {
    var weekDay = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
  }else if (tem_lang == 'en') {
    var weekDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  }
  day = weekDay[dt.getDay()]
  $('.c-venues__booking--date').attr('data-time', newDate)
  $('.c-venues__booking--date').html("<span>"+ newTime +"</span><span style='font-size: 20px; margin-left: 10px'>"+ day +"</span>")
  getBookingTimeList()
})
$('.c-venues__booking--rightBtn').click(function(){
  var oldDate = $('.c-venues__booking--date').attr('data-time')
  var newDate = parseInt(oldDate) + (24*60*60)
  newTime = getDateTime(newDate)
  weekDate = newTime.split('-')
  var dt = new Date(weekDate[0], weekDate[1] - 1, weekDate[2]);
  if (tem_lang == 'zh' || tem_lang == 'hk') {
    var weekDay = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
  }else if (tem_lang == 'en') {
    var weekDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  }
  day = weekDay[dt.getDay()]
  $('.c-venues__booking--date').attr('data-time', newDate)
  $('.c-venues__booking--date').html("<span>"+ newTime +"</span><span style='font-size: 20px; margin-left: 10px'>"+ day +"</span>")
  getBookingTimeList()
})


//activity list page popup function
function openAllActivityPopup(obj){
  var that = $(obj)
  $('.c-popup__activityDetails').addClass('is-active')
  var name = that.parent().siblings('.c-activity__item--name').html()
  var date = that.parent().siblings('.c-activity__item--date').html()
  var remark = that.parent().attr('data-remark')
  $('.c-popup__activityDetails .c-popup__name').html(name)
  $('.c-popup__activityDetails .c-popup__date').html(date)
  $('.c-popup__activityDetails .c-popup__remark').html(remark)
}

$('.c-popup__activityDetails, .c-popup__activityDetails .button--blue').click(function(){
  $('.c-popup__activityDetails').removeClass('is-active')
})

//booking page popup function
function openBookingActivityPopup(obj){
  var that = $(obj)
  $('.c-popup__bookingDetails').addClass('is-active')
  var name = that.parent().siblings('.c-booking__item--name').html()
  var date = that.parent().siblings('.c-booking__item--date').html()
  var remark = that.parent().attr('data-remark')
  $('.c-popup__bookingDetails .c-popup__name').html(name)
  $('.c-popup__bookingDetails .c-popup__date').html(date)
  $('.c-popup__bookingDetails .c-popup__remark').html(remark)
}

$('.c-popup__bookingDetails, .c-popup__bookingDetails .button--blue').click(function(){
  $('.c-popup__bookingDetails').removeClass('is-active')
})

//venues page booking popup
$('.c-venues__bookingBtn').click(function(){
  $('.c-popup__venuesBooking').addClass('is-active')
  var name = $('.c-venues__item.is-active').html()
  var date = $('.c-venues__booking--date span:first-child').html()
  var min_time = $('.c-venues__item.is-active').attr('data-min')
  $('.c-popup__venuesBooking .c-popup__name').html(name)
  $('.c-popup__venuesBooking .c-popup__name').find('p').css('display', 'inline-block')
  if (tem_lang == 'zh') {
    var text1 = '最短预订时间为'
    var text2 = '分钟'
  }else if (tem_lang == 'en') {
    var text1 = 'The Minimum time of booking '
    var text2 = ' mins'
  }else if (tem_lang == 'hk') {
    var text1 = '最短預訂時間為'
    var text2 = '分鐘'
  }
  $('.c-popup__venuesBooking .c-popup__name').html($('.c-popup__venuesBooking .c-popup__name').html() + "<span style='font-weight: normal;font-size:16px;padding-left: 10px'>（"+ text1 + min_time + text2 +"）</span>")
  $('.c-popup__venuesBooking .c-popup__date').html(date)
  $('.operate__btn--add p, .operate__btn--reduce p').html(min_time + text2)
  $('.operateBlock').attr('data-times','0')
  $('.operate__btn--reduce').addClass('is-active')
  var beginHour = $('#beginHour li.is-active').html()
  var beginMin  = $('#beginMin li.is-active').html()
  var timeNum = parseInt(beginHour) * 60 + parseInt(beginMin) + parseInt(min_time)
  if (timeNum > 1440) {
    $('.operate__btn--add').addClass('is-active')
  }else{
    $('.operate__btn--add').removeClass('is-active')
  }
  $('#finishHour p').html(beginHour)
  $('#finishMin p').html(beginMin)
})
$('.c-popup__venuesBooking .button--blue').click(function(){
  bookingVenues()
})
$('.c-popup__venuesBooking, .c-popup__venuesBooking .button--gray').click(function(){
  $('.c-popup__venuesBooking').removeClass('is-active')
})
$('.c-popup__bookingStatus .button--blue').click(function(){
  $('.c-popup__bookingStatus').removeClass('is-active')
  getBookingTimeList()
})
$('.c-popup__activityStatus .button--blue').click(function(){
  $('.c-popup__activityStatus').removeClass('is-active')
})
$('.c-popup__mybookingStatus .button--blue').click(function(){
  $('.c-popup__mybookingStatus').removeClass('is-active')
})
$('.operate__btn--add').click(function(){
  if ($(this).hasClass('is-active')) {
    return false
  }else{
    var min = parseInt($('.c-venues__item.is-active').attr('data-min'))
    var times = parseInt($('.operateBlock').attr('data-times')) + 1
    var beginHour = parseInt($('#beginHour li.is-active').html())
    var beginMin  = parseInt($('#beginMin li.is-active').html())
    var timeNum = beginHour * 60 + beginMin
    timeNum = timeNum + (min * times)
    var finishHour = Math.floor(timeNum/ 60)
    var finishMin = timeNum % 60
    if (finishHour < 10) {
      finishHour = '0' + finishHour
    }
    if (finishMin < 10) {
      finishMin = '0' + finishMin
    }
    $('.operateBlock').attr('data-times', times)
    $('#finishHour p').html(finishHour)
    $('#finishMin p').html(finishMin)
    $('.operate__btn--reduce').removeClass('is-active')
    if (timeNum + min > 1440) {
      $('.operate__btn--add').addClass('is-active')
    }
  }
})
$('.operate__btn--reduce').click(function(){
  if ($(this).hasClass('is-active')) {
    return false
  }else{
    var min = parseInt($('.c-venues__item.is-active').attr('data-min'))
    var times = parseInt($('.operateBlock').attr('data-times')) - 1
    var beginHour = parseInt($('#beginHour li.is-active').html())
    var beginMin  = parseInt($('#beginMin li.is-active').html())
    var timeNum = beginHour * 60 + beginMin
    timeNum = timeNum + (min * times)
    var finishHour = Math.floor(timeNum/ 60)
    var finishMin = timeNum % 60
    if (finishHour < 10) {
      finishHour = '0' + finishHour
    }
    if (finishMin < 10) {
      finishMin = '0' + finishMin
    }
    $('.operateBlock').attr('data-times', times)
    $('#finishHour p').html(finishHour)
    $('#finishMin p').html(finishMin)
    $('.operate__btn--add').removeClass('is-active')
    if (times == 0) {
      $('.operate__btn--reduce').addClass('is-active')
    }
  }
})

// stopPropagation funtion
function stopPropagation(e) {
  if (e.stopPropagation) {
    e.stopPropagation();
  } else {
    e.cancelBubble = true;
  }
};

$('.upBtn').click(function(){
  var defaultHeight = 80
  var ul = $(this).siblings('ul')
  var scroll = ul.scrollTop()
  var activeClass = ul.find('li.is-active')
  var activeIndex = activeClass.index()
  if (activeIndex > 0) {
    activeClass.removeClass('is-active')
    activeClass.prev().addClass('is-active')
  }
  ul.animate({'scrollTop': scroll - defaultHeight}, 30)
  defaultTime()
})

$('.downBtn').click(function(){
  var defaultHeight = 80
  var ul = $(this).siblings('ul')
  var scroll = ul.scrollTop()
  var activeClass = ul.find('li.is-active')
  var activeIndex = activeClass.index()
  var activeLength = ul.find('li').length
  if (activeIndex < activeLength - 1) {
    activeClass.removeClass('is-active')
    activeClass.next().addClass('is-active')
  }
  ul.animate({'scrollTop': scroll + defaultHeight}, 30)
  defaultTime()
})

function defaultTime(){
  $('.operateBlock').attr('data-times','0')
  var min_time = $('.c-venues__item.is-active').attr('data-min')
  var beginHour = $('#beginHour li.is-active').html()
  var beginMin  = $('#beginMin li.is-active').html()
  var timeNum = parseInt(beginHour) * 60 + parseInt(beginMin) + parseInt(min_time)
  if (timeNum > 1440) {
    $('.operate__btn--add').addClass('is-active')
  }else{
    $('.operate__btn--add').removeClass('is-active')
  }
  $('.operate__btn--reduce').addClass('is-active')
  $('#finishHour p').html(beginHour)
  $('#finishMin p').html(beginMin)
}

//venues status button
function showThisVenues (obj){
  var that = $(obj)
  var id = that.attr('data-id')
  var timeArr = [];
  $(".box-green[data-id='"+ id +"']").each(function(){
    timeArr.push($(this).attr('data-value'))
  })
  timeArr = timeArr.sort(function(a,b){
    return a-b;
  });
  var minTime = parseInt(timeArr[0]) - 5
  var maxTime = parseInt(timeArr[timeArr.length - 1])
  var minHour = Math.floor(minTime / 60)
  var minMins = minTime % 60
  var maxHour = Math.floor(maxTime / 60)
  var maxMins = maxTime % 60
  if (minHour < 10) {
    minHour = '0' + minHour
  }
  if (minMins < 10) {
    minMins = '0' + minMins
  }
  if (maxHour < 10) {
    maxHour = '0' + maxHour
  }
  if (maxMins < 10) {
    maxMins = '0' + maxMins
  }
  minTime = minHour + ':' + minMins
  maxTime = maxHour + ':' + maxMins
  var str = '';
  str += "<div class='tips tips--green'><span data-lang='string_36'></span><span> "+ minTime +" </span><span data-lang='string_16'></span><span> "+ maxTime +" </span></div>"
  //var showBoxValue = timeArr[Math.floor(timeArr.length/2)]
  //$(".box-green[data-value='"+ showBoxValue +"']").append(str)
  that.append(str)
  allLanguageRender()
}

function showDisVenues(obj){
  var that = $(obj)
  var value = parseInt(that.attr('data-value'))
  var timeArr = []
  timeArr.push(value)
  reduceDis(value)
  addDis(value)
  function reduceDis (value){
    var thisValue = value - 5
    if($(".box[data-value='"+ thisValue +"']").hasClass('box-orange')){
      timeArr.push(thisValue)
      reduceDis(thisValue)
    }
  }
  function addDis (value){
    var thisValue = value + 5
    if($(".box[data-value='"+ thisValue +"']").hasClass('box-orange')){
      timeArr.push(thisValue)
      addDis(thisValue)
    }
  }
  timeArr = timeArr.sort(function(a,b){
    return a-b;
  });
  var minTime = parseInt(timeArr[0]) - 5
  var maxTime = parseInt(timeArr[timeArr.length - 1])
  var minHour = Math.floor(minTime / 60)
  var minMins = minTime % 60
  var maxHour = Math.floor(maxTime / 60)
  var maxMins = maxTime % 60
  if (minHour < 10) {
    minHour = '0' + minHour
  }
  if (minMins < 10) {
    minMins = '0' + minMins
  }
  if (maxHour < 10) {
    maxHour = '0' + maxHour
  }
  if (maxMins < 10) {
    maxMins = '0' + maxMins
  }
  minTime = minHour + ':' + minMins
  maxTime = maxHour + ':' + maxMins
  var str = '';
  str += "<div class='tips tips--orange'><span> "+ minTime +" </span><span> "+ maxTime +" </span><span data-lang='string_37'></span></div>"
  //var showBoxValue = timeArr[Math.floor(timeArr.length/2)]
  //$(".box-orange[data-value='"+ showBoxValue +"']").append(str)
  that.append(str)
  allLanguageRender()
}

function showDonotVenues(obj){
  var that = $(obj)
  var value = parseInt(that.attr('data-value'))
  var timeArr = []
  timeArr.push(value)
  reduceDonot(value)
  addDonot(value)
  function reduceDonot (value){
    var thisValue = value - 5
    if($(".box[data-value='"+ thisValue +"']").hasClass('box-gray')){
      timeArr.push(thisValue)
      reduceDonot(thisValue)
    }
  }
  function addDonot (value){
    var thisValue = value + 5
    if($(".box[data-value='"+ thisValue +"']").hasClass('box-gray')){
      timeArr.push(thisValue)
      addDonot(thisValue)
    }
  }
  timeArr = timeArr.sort(function(a,b){
    return a-b;
  });
  var minTime = parseInt(timeArr[0]) - 5
  var maxTime = parseInt(timeArr[timeArr.length - 1])
  var minHour = Math.floor(minTime / 60)
  var minMins = minTime % 60
  var maxHour = Math.floor(maxTime / 60)
  var maxMins = maxTime % 60
  if (minHour < 10) {
    minHour = '0' + minHour
  }
  if (minMins < 10) {
    minMins = '0' + minMins
  }
  if (maxHour < 10) {
    maxHour = '0' + maxHour
  }
  if (maxMins < 10) {
    maxMins = '0' + maxMins
  }
  minTime = minHour + ':' + minMins
  maxTime = maxHour + ':' + maxMins
  var str = '';
  str += "<div class='tips tips--gray'><span>"+ minTime +"</span><span data-lang='string_16'></span><span>"+ maxTime +"</span><span data-lang='string_38'></span></div>"
  //var showBoxValue = timeArr[Math.floor(timeArr.length/2)]
  //$(".box-gray[data-value='"+ showBoxValue +"']").append(str)
  that.append(str)
  allLanguageRender()
}
$('.c-venues__back').click(function(){
  $('.tips').remove()
})
//getStr
function getStr(str) {
  var result = str.match(/\"\w*\"/g);
  return result.map(function(element){
    return element.replace(/\"/g, '');
  });
}
//getStrId
function getStrId(str) {
  var strs= new Array();
  strs=str.split("-");
  return strs;
}
//set/get Cookie
function setCookie(cname,cvalue,exdays) {
  var d = new Date();
  d.setTime(d.getTime()+(exdays*24*60*60*1000));
  var expires = "expires="+d.toGMTString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}
function getCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) {
    var c = ca[i].trim();
    if (c.indexOf(name)==0) return c.substring(name.length,c.length);
  }
  return "";
}

//datetime format
function getLocalTime(nS) {
  return new Date(parseInt(nS) * 1000).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ").replace(/下午/g,"PM ").replace(/上午/g,"AM ");
}

function getDateTime(timeStamp) {
  var date = new Date();
  date.setTime(timeStamp * 1000);
  var y = date.getFullYear();
  var m = date.getMonth() + 1;
  m = m < 10 ? ('0' + m) : m;
  var d = date.getDate();
  d = d < 10 ? ('0' + d) : d;
  var h = date.getHours();
  h = h < 10 ? ('0' + h) : h;
  return y + '-' + m + '-' + d
};

//set/get sessionStorage
function setSessionStorage(name, value){
  sessionStorage.setItem(name, value)
}
function getSessionStorage(name){
  return sessionStorage.getItem(name)
}

//guid function
function Guid() {
  var s = [];
  var hexDigits = "0123456789abcdef";
  for (var i = 0; i < 36; i++) {
    s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
  }
  s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
  s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
  s[8] = s[13] = s[18] = s[23] = "-";
  var guid = s.join("");
  return guid;
}
//addPreZero
function addPreZero(num, len){
  var t = (num +'').length,
  s = '';
  for(var i = 0; i < len - t; i++){
    s += '0';
  }
  return s+num;
}

//lange rander
function singleRender(i){
  $('[data-lang="' + i + '"]').text($.i18n.map[i]);
}

function allLanguageRender(){
  for (var i in $.i18n.map) {
    $('[data-lang="' + i + '"]').text($.i18n.map[i]);
  }
}
