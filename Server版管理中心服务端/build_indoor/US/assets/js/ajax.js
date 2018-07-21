_ajaxLink = '../../../index.php';

var addressName
if (window.location.href.indexOf("?address=") > 0) {
  var arr = []
  var addressName = window.location.href.split("?address=").pop();
  arr = addressName.split('-')
  addressName = arr.join('')
  setSessionStorage('user', addressName)
}

user = getSessionStorage('user')

//get page
if (window.location.href.indexOf("#") > 0) {
  page = window.location.href.split("#").pop();
} else {
  page = 1;
}

function removeHashReload(){
  window.location.hash = ''
  location.reload()
}

function getnowTime(){
  var nowTime
  $.ajax({
    url: _ajaxLink + "?c=message&m=getServerTimeByFormat",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        nowTime = data.ret
      }
    }
  })
  return nowTime
}

//*************************************index page more list*************************************//
function eventMoreList(){
  var date = $('.schedule-hd .today').html()
  $.ajax({
    url: _ajaxLink + "?c=Message&m=getEvents&date="+ date,
    type: "GET",
    dataType: "json",
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        var pArr = []
        $.each(data.ret, function (k, n) {
          if (k < 3) {
            str += "<p>"+ n.title + "</p>"
            pArr.push(n.title)
          }
        })
        pArr = pArr.join('')
        if (pArr == '') {
          str = "<div style='width: 100%; height:100%;text-align: center;margin-top: 35px;' data-lang='string_12'></div>"
        }
      }else{
        str = "<div style='width: 100%; height:100%;text-align: center;margin-top: 35px;' data-lang='string_12'></div>"
      }
      $('.c-homepage__list--event .c-homepage__list--item').html(str)
      allLanguageRender()
    }
  })
}

function venuesMoreList(){
  var location = user
  var date = $('.schedule-hd .today').html()
  $.ajax({
    url: _ajaxLink + "?c=booking&m=getBookingRes",
    type: "POST",
    data:{
      location: location,
      date: date
    },
    dataType: "json",
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          if (k < 3) {
            var date = getDateTime(n.booking_date)
            str += "<p>"
            str += "<span data-value='name'>"+ n.name +"</span>"
            str += "<span data-value='time'>"+ n.time_from +"-"+ n.time_to +" </span>"
            str +="</p>"
          }
        })
      }else{
        str += "<div style='width: 100%; height:100%;text-align: center;margin-top: 35px;' data-lang='string_12'></div>"
      }
      $('.c-homepage__list--venues .c-homepage__list--item').html(str)
      allLanguageRender()
    }
  })
}

function activityMoreList(){
  var location = user
  var date = $('.schedule-hd .today').html()
  $.ajax({
    url: _ajaxLink + "?c=booking&m=getBookingAct",
    type: "POST",
    data:{
      location: location,
      date: date
    },
    dataType: "json",
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          if (k < 3) {
            var date = getDateTime(n.booking_date)
            str += "<p>"
            str += "<span data-value='name'>"+ n.name +"</span>"
            str += "<span data-value='time'>"+ n.time_from +"-"+ n.time_to +" </span>"
            str +="</p>"
          }
        })
      }else{
        str += "<div style='width: 100%; height:100%;text-align: center;margin-top: 35px;' data-lang='string_12'></div>"
      }
      $('.c-homepage__list--activity .c-homepage__list--item').html(str)
      allLanguageRender()
    }
  })
}

function checkNewDay(){
  eventMoreList()
  venuesMoreList()
  activityMoreList()
  findTag()
}

function findTag(state){
  var date = $('.schedule-hd .today').html()
  dateArr = date.split('-')
  month = dateArr[0] +'-'+ dateArr[1]
  var location = user
  $.ajax({
    url: _ajaxLink + "?c=Booking&m=getBookingInfoByMonth",
    type: "POST",
    data:{
      month: month,
      location: user
    },
    dataType: "json",
    success: function(data){
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          day =n.day
          $("span[title="+ day +"]").addClass('redTag')
        })
      }
    }
  })
  if (state != '1') {
    $.ajax({
      url: _ajaxLink + "?c=Message&m=getEventDayByMonth&month="+ month,
      type: "GET",
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $.each(data.ret, function (k, n) {
            day = n
            $("span[title="+ day +"]").addClass('greenTag')
          })
        }
      }
    })
  }
}

//*************************************Venues page activity list*************************************//
function getVenuesList(){
  $.ajax({
    url: _ajaxLink + "?c=Booking&m=getResourceInfo",
    type: "GET",
    dataType: "json",
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          str += "<div class='c-venues__item' data-id='"+ n.res_info_id +"' data-min='"+n.min_time+"'onclick='openVenuesBlock(this)'>"
          str += "<p>"+ n.name +"</p>"
          str += "</div>"
        })
      }else{
        str += "<div data-lang='string_24' style='padding: 20px; text-align: center;'></div>"
      }
      $('.c-venues__menu .c-venues__list').html(str)
      allLanguageRender()
    }
  })
}

function openVenuesBlock(obj){
  var that = $(obj)
  if (!$('#booking-venues').hasClass('is-active')) {
    var time = $('.schedule-hd .today').html()
    date = new Date(time + ' 00:00:00');
    date = Math.round(date.getTime()/1000);
    date = date.toString()
    var weekDate = time.split('-')
    var dt = new Date(weekDate[0], weekDate[1] - 1, weekDate[2]);
    if (tem_lang == 'zh' || tem_lang == 'hk') {
      var weekDay = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
    }else if (tem_lang == 'en') {
      var weekDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    }
    day = weekDay[dt.getDay()]
    time = getDateTime(date)
    $('#booking-venues').addClass('is-active')
    that.addClass('is-active')
    $('.c-venues__booking--date').html("<span>"+ time +"</span><span style='font-size: 20px; margin-left: 10px'>"+ day +"</span>")
    $('.c-venues__booking--date').attr('data-time',date)
    getBookingTimeList()
  }else{
    $('.c-venues__item').removeClass('is-active')
    that.addClass('is-active')
    getBookingTimeList()
  }
}

function getBookingTimeList(){
  var location = user
  var id = $('.c-venues__item.is-active').attr('data-id')
  var date = $('.c-venues__booking--date').attr('data-time')
  $('.box-gray').removeClass('box-gray')
  $('.box-green').removeClass('box-green')
  $('.box-orange').removeClass('box-orange')
  $('.box').unbind()
  $.ajax({
    url: _ajaxLink + "?c=Booking&m=getResInfoStatusById",
    type: "POST",
    data:{
      location: location,
      date: date,
      res_info_id: id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          var time_from = n.time_from
          var from_min  = n.time_from_minutes
          var time_to   = n.time_to
          var to_min    = n.time_to_minutes
          var id        = n.res_record_id
          var status    = n.status
          if (status == 1) {
            while (from_min < to_min) {
              from_min += 5
              $(".box[data-value='"+ from_min +"']").addClass('box-gray')
            }
          }else if (status == 2) {
            while (from_min < to_min) {
              from_min += 5
              $(".box[data-value='"+ from_min +"']").addClass('box-green')
              $(".box[data-value='"+ from_min +"']").attr('data-id', id)
            }
          }else if (status == 3) {
            while (from_min < to_min) {
              from_min += 5
              var orangeBlock = $(".box[data-value='"+ from_min +"']")
              if (!orangeBlock.hasClass('box-green')) {
                orangeBlock.addClass('box-orange')
              }
            }
          }
        })
        $('.tips').remove()
        $('.box').on('click',function(){
          $('.tips').remove()
        })
        $('.box-gray').on('click',function(){
          showDonotVenues(this)
        })
        $('.box-green').on('click',function(){
          showThisVenues(this)
        })
        $('.box-orange').on('click',function(){
          showDisVenues(this)
        })
      }
    }
  })
}

function bookingVenues(){
  var location = user
  var beginTime  = $("#beginHour li.is-active").html() + ':' + $("#beginMin li.is-active").html()
  var finishTime = $("#finishHour p").html() + ':' + $("#finishMin p").html()
  var id = $('.c-venues__item.is-active').attr('data-id')
  var dateStr = $('.c-venues__booking--date span').html().replace(/\//g,'-')
  $('.c-loading').show()
  $.ajax({
    url: _ajaxLink + "?c=Booking&m=acceptRes",
    type: "POST",
    data:{
      location: location,
      date: dateStr,
      id: id,
      time_from: beginTime,
      time_to: finishTime
    },
    dataType: "json",
    success: function(data){
      var min_time = $('.c-venues__item.is-active').attr('data-min');
      switch (data.state) {
        case 0: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_29'); break;
        case 1: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_27'); break;
        case 2: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_30'); break;
        case 3: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_31'); break;
        case 4: $('.c-popup__bookingStatus .c-popup__status').html("<span data-lang='string_39'></span><span>" + min_time + "</span><span data-lang='string_40'></span>");$('.c-popup__bookingStatus .c-popup__status').attr('data-lang',''); break;
        case 5: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_32'); break;
        case 6: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_33'); break;
        case 7: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_34'); break;
        case 8: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_46'); break;
        case 10: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_35'); break;
        default: $('.c-popup__bookingStatus .c-popup__status').attr('data-lang','string_28'); break;
      }
      $('.c-loading').hide()
      $('.c-popup__venuesBooking').removeClass('is-active')
      $('.c-popup__bookingStatus').addClass('is-active')
      allLanguageRender()
    }
  })
}

//*************************************Activity page activity list*************************************//

function allActivityList(){
  var location = user
  $.ajax({
    url: _ajaxLink + "?c=booking&m=getBookingActByLoaction",
    type: "POST",
    data:{
      location: location
    },
    dataType: "json",
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          str += "<div class='c-activity__item' data-id='"+ n.act_info_id +"'>"
          str += "<div class='c-activity__item--name'>"+ n.name +"</div>"
          str += "<div class='c-activity__item--date'>"+ n.datetime +"</div>"
          str += "<div class='c-activity__item--details' data-remark='"+ n.remark +"'><div class='c-activity__img' onclick='openAllActivityPopup(this)'></div></div>"
          str += "<div class='c-activity__item--number'><span data-lang='string_25'></span><span> "+ n.remain +"</span></div>"
          if (n.remain != 0) {
            if (n.status == 1) {
              str += "<div class='c-activity__item--booking'><p class='c-activity__item--booked' style='padding-right:10px' data-lang='string_7'></p></div>"
            }else if (n.status == 0){
              str += "<div class='c-activity__item--booking'><div class='button button--blue' onclick='bookingActivity(this)' data-lang='string_15'></div></div>"
            }
          }else if (n.remain == 0) {
            if (n.status == 1) {
              str += "<div class='c-activity__item--booking'><p class='c-activity__item--booked' style='padding-right:10px' data-lang='string_7'></p></div>"
            }
          }
          str += "</div>"
        })
      }else{
        str += "<div style='width:100%;text-align:center;line-height:80px' data-lang='string_41'></div>"
      }
      $('.c-activity .c-activity__list').html(str)
      allLanguageRender()
    }
  })
}

function bookingActivity(obj){
  var location = user
  var that = $(obj).parent()
  var id = that.parent().attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=Booking&m=acceptAct",
    type: "POST",
    data:{
      location: location,
      actId: id
    },
    dataType: "json",
    error: function(data){
      $('.c-popup__activityStatus .c-popup__status').attr('data-lang','string_28')
      allLanguageRender()
    },
    success: function(data){
      if(data.state==1 && data.ret != ''){
        $('.c-popup__activityStatus .c-popup__status').attr('data-lang','string_27')
        that.html("<p style='padding-right: 10px' class='c-activity__item--booked' data-lang='string_7'></p>")
        var num = that.siblings('.c-activity__item--number').find('span:last-child').html()
        num = parseInt(num) - 1
        that.siblings('.c-activity__item--number').html("<span data-lang='string_25'></span><span> " + num +"</span>")
      }else{
        $('.c-popup__activityStatus .c-popup__status').attr('data-lang','string_28')
      }
      $('.c-popup__activityStatus').addClass('is-active')
      allLanguageRender()
    }
  })
}

//*************************************Booking page activity list*************************************//
function venuesList(){
  $('.venues-block').html('')
  var location = user
  $.ajax({
    url: _ajaxLink + "?c=booking&m=getBookingRes",
    type: "POST",
    data:{
      location: location
    },
    dataType: "json",
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          var date = getDateTime(n.booking_date)
          str += "<div class='c-booking__item' data-id='"+ n.res_record_id +"' data-remark='"+ n.remark +"'>"
          str += "<div class='c-booking__item--name'>"+ n.name +"</div>"
          str += "<div class='c-booking__item--date'>"+ date +"  "+ n.time_from +" - "+ n.time_to +"</div>"
          str += "<div class='c-booking__item--cancel'><div class='button button--blue' onclick='cancelResBooking(this)' data-lang='string_17'></div></div>"
          str +="</div>"
        })
        $('.venues-block').html(str)
      }else{
        $('.venues-block').html("<div style='width:100%;text-align:center;line-height:80px' data-lang='string_26'></div>")
      }
      allLanguageRender()
    }
  })
}
function activityList(){
  $('.activity-block').html('')
  var location = user
  $.ajax({
    url: _ajaxLink + "?c=booking&m=getBookingAct",
    type: "POST",
    data:{
      location: location
    },
    dataType: "json",
    success: function(data){
      var str = ''
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          str += "<div class='c-booking__item' data-id='"+ n.act_record_id +"'>"
          str += "<div class='c-booking__item--name'>"+ n.name +"</div>"
          str += "<div class='c-booking__item--date'>"+ n.datetime +"</div>"
          str += "<div class='c-booking__item--details' data-remark='"+ n.remark +"'><div class='c-booking__img' onclick='openBookingActivityPopup(this)'></div></div>"
          // str += "<div class='c-booking__item--number'>剩余 "+ n.remain +"</div>"
          str += "<div class='c-booking__item--cancel'><div class='button button--blue' onclick='cancelActBooking(this)' data-lang='string_17'></div></div>"
          str +="</div>"
        })
        $('.activity-block').html(str)
      }else{
        $('.activity-block').html("<div style='width:100%;text-align:center;line-height:80px' data-lang='string_41'></div>")
      }
      allLanguageRender()
    }
  })
}

function cancelResBooking(obj){
  var that = $(obj).parent().parent()
  var id = that.attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=Booking&m=cancelRes",
    type: "POST",
    data:{
      res_record_id: id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('.c-popup__mybookingStatus .c-popup__status').attr('data-lang','string_42')
        venuesList()
      }else if(data.state == 2){
        $('.c-popup__mybookingStatus .c-popup__status').attr('data-lang','string_47')
      }else{
        $('.c-popup__mybookingStatus .c-popup__status').attr('data-lang','string_43')
      }
      $('.c-popup__mybookingStatus').addClass('is-active')
      allLanguageRender()
    }
  })
}

function cancelActBooking(obj){
  var that = $(obj).parent().parent()
  var id = that.attr('data-id')
  var location = user
  $.ajax({
    url: _ajaxLink + "?c=Booking&m=cancelAct",
    type: "POST",
    data:{
      act_record_id: id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('.c-popup__mybookingStatus .c-popup__status').attr('data-lang','string_42')
        activityList()
      }else{
        $('.c-popup__mybookingStatus .c-popup__status').attr('data-lang','string_43')
      }
      $('.c-popup__mybookingStatus').addClass('is-active')
      allLanguageRender()
    }
  })
}
