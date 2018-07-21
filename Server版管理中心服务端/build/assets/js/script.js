//LOGIN
function loginValidation(){
  var username = $('.c-login #username').find('input')
  var password = $('.c-login #password').find('input')
  $('#result').html('')
  $('#result').attr('data-lang','')
  $('tr:nth-child(1), tr:nth-child(2)').find('td').css('border-bottom-color', '#61619e')
  if (username.val() == '') {
    if (tem_lang == 'zh') {
      username.attr('placeholder', '请输入您的用户名!')
    }else if (tem_lang == 'en') {
      username.attr('placeholder', 'Please enter your Username!')
    }else if (tem_lang == 'hk') {
      username.attr('placeholder', '請輸入您的用戶名!')
    }
    $('.c-login #username').parent().find('td').css('border-bottom-color', '#ff9800')
  }else if (password.val() == '') {
    if (tem_lang == 'zh') {
      password.attr('placeholder', '请输入您的密码!')
    }else if (tem_lang == 'en') {
      password.attr('placeholder', 'Please enter your Password!')
    }else if (tem_lang == 'hk') {
      password.attr('placeholder', '請輸入您的密碼!')
    }
    $('.c-login #password').parent().find('td').css('border-bottom-color', '#ff9800')
  }else{
    loginAjax()
  }
}

//istouch()
//return WYSIWYGModernizr.touch && void 0 !== window.Touch

//menu function
$('li.c-menu__hasChild').click(function(){
  if ($('body').hasClass('folding-active')) {
    if ($(this).hasClass('is-active-folding')) {
      $('li.c-menu__hasChild').removeClass('is-active-folding')
    }else{
      $('li.c-menu__hasChild').removeClass('is-active-folding')
      $(this).addClass('is-active-folding')
    }
  }else{
    if ($(this).hasClass('is-active')) {
      $('li.c-menu__hasChild').removeClass('is-active')
    }else{
      $('li.c-menu__hasChild').removeClass('is-active')
      $(this).addClass('is-active')
    }
  }
})

function checkReset(){
  var checkLi = $('.c-menu').attr('data-state')
  if (checkLi != '') {
    $('.c-menu p[data-lang='+ checkLi +']').parent().parent().addClass('is-active')
    $('.c-menu p[data-lang='+ checkLi +']').parent().parent().parent().parent().addClass('is-active highlight')
  }
}
checkReset()

$('.c-content__right').click(function(){
  if ($('.folding-active .is-active-folding .c-menu__content--child').css('display') == 'block') {
    $('.folding-active .is-active-folding').removeClass('is-active-folding')
  }
})

$('.c-folding').click(function(){
  $('body').toggleClass('folding-active')
  $('.c-menu__hasChild').removeClass('is-active')
  $('.c-menu__hasChild').removeClass('is-active-folding')
  checkReset()
  if ($('body').hasClass('folding-active')) {
    setCookie('folding','right')
  }else{
    setCookie('folding','error')
  }
})

var folding = getCookie('folding')
if (folding == 'right') {
  $('body').addClass('folding-active')
}

//add CSS
$('.c-menu__content--child').css('transition','max-height .4s')
$('.c-menu').css('transition','width .5s')
$('.c-folding').css('transition','width .5s')
$('.c-content__right').css('transition','width .5s')

//language check
if ($.cookie('lang') == "zh_CN" || $.cookie('lang') == null || $.cookie('lang') == '') {
  tem_lang = "zh"
  $('.c-login__select .c-select').val('zh_CN')
}
if ($.cookie('lang') == "en") {
  tem_lang = "en"
  $('.c-login__select .c-select').val('en')
}
if ($.cookie('lang') == "zh_HK") {
  tem_lang = "hk"
  $('.c-login__select .c-select').val('zh_HK')
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
  // $("#logout").click(function () {
  //   $.cookie('username', null, {path: '/'});
  //   window.location.href = _ajaxLink + "frontend/index.html";
  // })
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

//checkbox toggle
$('.c-message__important').click(function(){
  $('.c-message__important .c-checked').toggleClass('is-active')
})
$('#info_user .c-checked').click(function(){
  $(this).toggleClass('is-active')
})

//close popup
$('.c-popup__content').click(function(e){
  return stopPropagation(e)
})
$('.c-message__addressee').click(function(){
  $('#popup__message').addClass('is-active')
})
$('.c-message__addressee--button').click(function(){
  $('#popup__message').addClass('is-active')
  var building_id = $('#building--list .c-message__table--list a.is-active').attr('value')
  var unit_id = $('#block--list .c-message__table--list a.is-active').attr('value')
  $('#room--list .c-message__table--list a').removeClass('is-active')
  $('.c-message__addressee div').each(function(){
    var dataValue = $(this).attr('data-value')
    dataValue = getStrId(dataValue)
    if (dataValue[0] == building_id && dataValue[1] == unit_id) {
      $('#room--list .c-message__table--list a').each(function(){
        if ($(this).attr('value') == dataValue[2]) {
          $(this).addClass('is-active')
        }
      })
    }
  })
})
$('.c-message__formwork').click(function(){
  $('#popup__formwork').addClass('is-active')
  getFormwork(1)
})
//add popup function
$('.f-add').click(function(){
  if ($(this).hasClass('disabled')) {
    return false
  }else{
    $('#popup__add').addClass('is-active')
  }

})
//edit popup function
function editThis(obj) {
  $('#popup__edit').addClass('is-active');
  $('#popup__edit input').css('border-color','#ccc')
  $('#popup__edit .result').html('')
  $('#popup__edit .result').attr('data-lang','')
  var parent = $(obj).parent().parent()
  var data_name = parent.find('td[data-name]')
  var editData = $('#popup__edit .c-table__popup').find('td input[name]')
  var msg = parent.attr('data-msg')
  editData.each(function(i, e){
    var mark = $(this).attr('name')
    var result = parent.find('td[data-name='+ mark +']').attr('data-val')
    $(this).val(result)
  })
  if (msg == '1') {
    $('#msg_edit .c-checked').addClass('is-active')
  }else if(msg == '0' || msg == ''){
    $('#msg_edit .c-checked').removeClass('is-active')
  }
  var oldDataSrc = parent.find("td[data-name='avatar']").attr('data-val')
  $('#info_user #popup__edit .c-uploadImage').attr('old-data-src', oldDataSrc)
  $('#info_user #popup__edit .c-uploadImage').attr('data-src', oldDataSrc)
  $('#info_user #popup__edit .c-uploadImage').css('background-image','url("'+ oldDataSrc +'")')
  if (oldDataSrc == 'null') {
    $('#info_user #popup__edit .c-uploadImage p').show()
  }else{
    $('#info_user #popup__edit .c-uploadImage p').hide()
  }
  //角色用户 dd dt 选择
  if ($(obj).hasClass('noRole')) {
    var userPosition = parent.find("td[data-name='position']").html()
    $('#select--position__edit').html(userPosition)
  }else{
    var userPosition = parent.find("td[data-name='position']").attr('data-val')
    var userPositionId = parent.find("td[data-name='position']").attr('data-id')
    $('#select--position__edit').html(userPosition)
    $('#select--position__edit').attr('value', userPositionId)
  }
  $('#popup__edit .button--orange').attr('data-id', $(obj).attr('data-id'))
}

function deviceEditThis(obj) {
  $('#popup__edit').addClass('is-active')
  $('#popup__edit .result').html('')
  $('#popup__edit .result').attr('data-lang','')
  $('#popup__edit input').css('border-color','#ccc')
  var parent = $(obj).parent().parent()
  var data_name = parent.find('td[data-name]')
  var editData = $('#popup__edit .c-table__popup').find('td input[name]')
  editData.each(function(i, e){
    var mark = $(this).attr('name')
    var result = parent.find('td[data-name='+ mark +']').attr('data-val')
    $(this).val(result)
  })
  var typeHtml
  var device_ip = parent.find("td[data-name='ip_address']").attr('data-val')
  var device_type = parent.find("td[data-name='device_type']").attr('data-val')
  var ip = getStrAddress(device_ip)
  $('#ipAddress__edit input').each(function(i){
    $(this).val(ip[i])
  })
  $('#modelNumber__edit a').each(function(){
    if ($(this).attr('value') == device_type) {
      typeHtml = $(this).html()
    }
  })
  $('#modelNumber__edit').val(device_type)
  $('#popup__edit .button--orange').attr('data-id', $(obj).attr('data-id'))
}
//delete popup function
function deleteThis(obj) {
  $('#popup__delete').addClass('is-active')
  $('.result').html('')
  $('.result').attr('data-lang','')
  var id = $(obj).attr('data-id')
  $('#popup__delete .f-confirm').attr('data-id', id)
}

//device management page function
function editThisDevice(obj){
  var that = $(obj)
  $('#popup__edit').addClass('is-active');
  $('#popup__edit input').css('border-color','#ccc')
  $('#popup__edit .result').html('')
  $('#popup__edit .result').attr('data-lang','')
  var id = that.attr('data-id')
  var device_type = that.parents('tr').attr('data-id')
  var device_name = that.parents('tr').find(".deviceName p[data-id='"+ id +"']").html()
  var device_remark = that.parents('tr').find(".deviceRemark p[data-id='"+ id +"']").html()
  $('#popup__edit').find('.c-select').val(device_type)
  $('#popup__edit').find("input[name='modelName']").val(device_name)
  $('#popup__edit').find("input[name='remark']").val(device_remark)
  $('#popup__edit .button--orange').attr('data-id', id)
}

//sip group page function
function editThisSip(obj){
  var that = $(obj)
  $('#popup__edit').addClass('is-active');
  $('#popup__edit input').css('border-color','#ccc')
  $('#popup__edit .result').html('')
  $('#popup__edit .result').attr('data-lang','')
  var id = that.attr('data-id')
  var members = that.parents('tr').find("td[data-name='members']").attr('data-val')
  var name = that.parents('tr').find("td[data-name='name']").attr('data-val')
  $('#popup__edit').find("input[name='remark']").val(name)
  members = members.split(',')
  $('#popup__edit .button--orange').attr('data-id', id)
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getGuardAndUserSipList",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var guardL = "";
        var guardR = "";
        var userL = "";
        var userR = "";
        var rightStr = "";
        var deviceLocation = "";
        $.each(data.ret, function (k, n) {
          if (n.username == '') {
            if (tem_lang == 'zh') {
              n.building += '栋'
              n.unit += '单元'
              n.deviceNo += '号'
              deviceLocation = '卫: ' + n.building + n.unit + n.deviceNo
            }else if (tem_lang == 'en') {
              n.building = ' Bld' + n.building
              n.unit = ' Blk' + n.unit
              n.deviceNo = 'NO.' + n.deviceNo
              deviceLocation = 'Guard: ' + n.deviceNo + n.unit + n.building
            }else if (tem_lang == 'hk') {
              n.building += '棟'
              n.unit += '單元'
              n.deviceNo += '號'
              deviceLocation = '衛: ' + n.building + n.unit + n.deviceNo
            }
            if (members.indexOf(n.sipNo) == -1) {
              guardL += "<p data-type='07' data-value='"+ n.sipNo +"' onclick='changeColor(this)'>"+ deviceLocation +"</p>";
            }else{
              guardR += "<p data-type='07' data-value='"+ n.sipNo +"'><span>"+ deviceLocation +"</span><span class='removeIcon' onclick='chooseGoBack(this)'><i class='fa fa-times'></i></span></p>"
            }
          }else{
            if (tem_lang == 'zh') {
              var userText = '用户: ' + n.username
            }else if (tem_lang == 'en') {
              var userText = 'User: ' + n.username
            }else if (tem_lang == 'hk') {
              var userText = '用戶: ' + n.username
            }
            if (members.indexOf(n.sipNo) == -1) {
              userL += "<p data-type='00' data-value='"+ n.sipNo +"' onclick='changeColor(this)'>"+ userText +"</p>";
            }else{
              userR += "<p data-type='00' data-value='"+ n.sipNo +"'><span>"+ userText +"</span><span class='removeIcon' onclick='chooseGoBack(this)'><i class='fa fa-times'></i></span></p>"
            }
          }
        })
        $("#popup__edit .c-sip__list--left--list").html(guardL + userL)
        $("#popup__edit .c-sip__list--right--list").html(guardR + userR)
      }
    }
  })
  allLanguageRender()
}

//sip transfer page function
function editThisTransfer(obj){
  var that = $(obj)
  $('#popup__edit').addClass('is-active');
  $('#popup__edit input').css('border-color','#ccc')
  $('#popup__edit .result').html('')
  $('#popup__edit .result').attr('data-lang','')
  var id = that.attr('data-id')
  var remark = that.parent().siblings("td[data-name='remark']").html()
  var sourceVal = that.parent().siblings("td[data-name='name']").attr('data-val')
  var sourceHtml = that.parent().siblings("td[data-name='name']").html()
  var transferVal = that.parent().siblings("td[data-name='transfer']").attr('data-val')
  var transferType = transferVal[0] + transferVal[1]
  $('#sourceTransfer').html(sourceHtml)
  $('#sourceTransfer').attr('data-val', sourceVal)
  $('#popup__edit input[name="remark"]').val(remark)
  $('#popup__edit .button--orange').attr('data-id', id)
  editTransferList(transferType, transferVal)
}

$('#popup__add, #popup__edit, #popup__delete, #popup__message, #popup__formwork, #popup__saveFormwork,#popup__sendInfo,#popup__noticeImageEdit, #popup__noticeVideoEdit, #popup__noticeTextEdit, #popup__image, .f-close').click(function(){
  $('.c-popup').removeClass('is-active');
})

//ip address small input
$('.onlyNumberInput').keyup(function(){
  this.value = this.value.replace(/\D/g,'');
})
$('.onlyNumberInput').blur(function(){
  this.value = this.value.replace(/\D/g,'');
})
//phone number
$('.onlyPhoneNumber').keyup(function(){
  this.value = this.value.replace(/([^0-9+()-])/g,'');
})
$('.onlyPhoneNumber').blur(function(){
  this.value = this.value.replace(/([^0-9+()-])/g,'');
})
$('.addressInput .c-input-small').keyup(function () {
  this.value = this.value.replace(/\D/g,'');
  if ($(this).val() >255) {
    $(this).val('255')
  }
})

//user management input
$('.noChineseNumber').keyup(function(){
  this.value = this.value.replace(/([^0-9])/g,'');
})

$('.addressInput .c-input-small').blur(function(){
  $(this).val($(this).val().replace(/([^0-9])/g,''))
  if ($(this).val().length > 1 && $(this).val()[0] == '0' ) {
    if($(this).val()[2]){
      var value = $(this).val()[1] + $(this).val()[2]
    }else{
      var value = $(this).val()[1]
    }
    $(this).val(value)
  }
})
//only allow number and a-z
$('.allowNumAndEnglish').keyup(function () {
  this.value = this.value.replace(/[^a-zA-Z0-9]/g,"");
})

$('.allowNumAndEnglish').blur(function () {
  this.value = this.value.replace(/[^a-zA-Z0-9]/g,"");
})

//select function
$('.c-select dt').click(function(){
  if ($(this).parent().hasClass('disabled')) {
    return
  }else{
    $(this).parent().toggleClass('is-active')
  }
})
$('.c-select').blur(function(){
  $(this).removeClass('is-active')
})

// stopPropagation funtion
function stopPropagation(e) {
  if (e.stopPropagation) {
    e.stopPropagation();
  } else {
    e.cancelBubble = true;
  }
};

//notice editer background function
$(document).on('click', '.fr-dropdown-menu > div:nth-child(3) button', function() {
  var backColor = $(this).attr('data-val')
  $('.froala-element').css('background-color', backColor)
});

//notice video function
// var videoInput = $('#uploadVideoAdd')
// videoInput.change(function(){
//   var name = videoInput.val()
//   var files = !!this.files ? this.files : [];
//   if (!files.length || !window.FileReader) {
//     return;
//   }
//   var fileSize = this.files[0].size;
//   var size = fileSize / 1024;
//   if (size > 10000) {
//     alert('请上传小于10M的文件');
//     videoInput.val('');
//     return;
//   }
//   var fileName = name.substring(name.lastIndexOf(".") + 1).toLowerCase();
//   if (fileName !== "png" && fileName !== "jpg" && fileName !== "jpeg" && fileName !== "gif" && fileName !== "bmp") {
//     alert('请上传正确格式的视频文件(flv,rvmb,mp4,avi,wmv)');
//     videoInput.val()('');
//     return;
//   }
//   if (/^image/.test(files[0].type)) {
//     var reader = new FileReader;
//     reader.readAsDataURL(files[0]);
//     reader.onloadend = function() {
//       // $('#upload_file_1').parent().css('background-image', 'url(' + this.result + ')');
//       // $('#upload_file_1').siblings('p').css('display', 'none');
//       // $('#upload_file_1').parent('.form-field').removeClass('n-invalid');
//     };
//   }
// })

//split device ip
function splitDeviceIp (deviceip){
  var n = deviceip
  var device = n[0] + n[1]
  var building = n[2] + n[3] + n[4]
  var unit = n[5] + n[6]
  if (tem_lang == 'zh') {
    if (device == '00') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '管理中心' + num + '号'
    }else if (device == '01') {
      var room = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '室内机' + building + '栋' + unit + '单元' + room + '室'
    }else if (device == '02') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '门口机' + building + '栋' + unit + '单元' + num + '号'
    }else if (device == '07') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '门卫机' + building + '栋' + unit + '单元' + num + '号'
    }
  }else if (tem_lang == 'en') {
    if (device == '00') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = 'No.' + num
    }else if (device == '01') {
      var room = n[7] + n[8] + n[9] + n[10]
      var splitDevice = 'Indoor: Room' + room + ' Blk' + unit + ' Bld' + building
    }else if (device == '02') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = 'Outdoor: NO.' + num + ' Blk' + unit + ' Bld' + building
    }else if (device == '07') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = 'Guard: NO.' + num + ' Blk' + unit + ' Bld' + building
    }
  }else if (tem_lang == 'hk') {
    if (device == '00') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '管理中心' + num + '號'
    }else if (device == '01') {
      var room = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '室內機' + building + '棟' + unit + '單元' + room + '室'
    }else if (device == '02') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '門口機' + building + '棟' + unit + '單元' + num + '號'
    }else if (device == '07') {
      var num = n[7] + n[8] + n[9] + n[10]
      var splitDevice = '門衛機' + building + '棟' + unit + '單元' + num + '號'
    }
  }
  return splitDevice
}

//limit time function
function selectDay(){
  var year = $('#selectYear').val()
  var month = $('#selectMonth').val()
  var day = $('#selectDay').val()
  var days
  var str = ''
  var monthStr = ''
  if (month == '4' || month == '6' || month == '9' || month == '11') {
    days = 30
  }else if (year % 4 == 0 && month == '2'){
    days = 29
  }else if(year % 4 != 0 && month == '2'){
    days = 28
  }else {
    days = 31
  }
  for (var x = 0; x < 12; x++) {
    if (x + 1 == month) {
      monthStr += "<option value='" + (x + 1) +"' selected='selected'>"+ (x + 1) +"</option>"
    }else{
      monthStr += "<option value='"+ (x + 1) +"'>"+ (x + 1) +"</option>"
    }
  }
  for (var i = 0; i < days; i++) {
    if (i + 1 == day) {
      str += "<option value='"+ (i + 1) +"' selected='selected'>"+ (i + 1) +"</option>"
    }else{
      str += "<option value='"+ (i + 1) +"'>"+ (i + 1) +"</option>"
    }
  }
  $('#selectMonth').html(monthStr)
  $('#selectDay').html(str)
  var nowDate =  new Date();
  var nowYear = nowDate.getFullYear()
  var nowMonth = nowDate.getMonth()+1
  var nowDay = nowDate.getDate()
  if (year == nowYear) {
    if (month <= nowMonth) {
      for (var i = 0; i < nowMonth-1; i++) {
        $("#selectMonth option[value='"+ (i + 1) +"']").remove()
      }
      for (var i = 0; i < nowDay-1; i++) {
        $("#selectDay option[value='"+ (i + 1) +"']").remove()
      }
    }
    // else{
    //   for (var i = 0; i < nowMonth-1; i++) {
    //     $("#selectMonth option[value='"+ (i + 1) +"']").remove()
    //   }
    // }
  }
}

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
//getStrAddress
function getStrAddress(str) {
  var strs= new Array();
  strs=str.split(".");
  return strs;
}
//getStrClass
function getStrClass(str) {
  var strs= new Array();
  strs=str.split(",");
  return strs;
}
//getStrSwitchCode
function getStrSwitchCode(str) {
  var strs= new Array();
  strs=str.split("#");
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

//set/get sessionStorage
function setSessionStorage(name, value){
  sessionStorage.setItem(name, value)
}
function getSessionStorage(name){
  return sessionStorage.getItem(name)
}

//datetime format
function getLocalTime(nS) {
  return new Date(parseInt(nS) * 1000).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ").replace(/下午/g,"PM ").replace(/上午/g,"AM ");
}

function getDateTime(nS) {
  var date = new Date(parseInt(nS) * 1000).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ").replace(/下午/g,"PM ").replace(/上午/g,"AM ");
  date = date.split(' ')
  date = date[0]
  return date
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

//lange rander
function singleRender(i){
  $('[data-lang="' + i + '"]').text($.i18n.map[i]);
}

function allLanguageRender(){
  for (var i in $.i18n.map) {
    $('[data-lang="' + i + '"]').text($.i18n.map[i]);
  }
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

function timestamp(time){
  var that = time.split('-')
  var date = new Date(that[0], that[1] - 1, that[2]);
  return date.getTime()/1000
}
