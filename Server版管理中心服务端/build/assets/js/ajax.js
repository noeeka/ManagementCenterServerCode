_ajaxLink = location.origin + '/index.php';
//_ajaxLink = 'http://web.tunnel.systec-pbx.net:8000/index.php';

//get page
if (window.location.href.indexOf("#") > 0) {
  page = window.location.href.split("#").pop();
} else {
  page = 1;
}

//no result str
var noResultStr = ""
noResultStr += "<tr>"
noResultStr += "<td colspan='100' style='text-align: center;height:100px;'><span data-lang='string_noRecord'></span>"
noResultStr += "<span style='margin-left:10px; color:#5477dc;text-decoration: underline;cursor: pointer;' data-lang='string_refresh' onclick='removeHashReload()'></span></td>"
noResultStr += "</tr>"

function removeHashReload(){
  window.location.hash = ''
  location.reload()
}

//*****************************************cookie check*****************************************//
var _permissionIntercom;
if (window.location.href.indexOf('login') < 0) {
  $.ajax({
    type: 'GET',
    url: _ajaxLink +"?c=Common&m=getTokenByWebClient",
    dataType: 'json',
    async: false,
    success: function(data){
      if(data.state == 0){
        window.location.href="./login.html";
      }
    }
  })
  if (getCookie('c_username') != '') {
    var perName = getCookie('c_username')
  }else if (getCookie('username') != '') {
    var perName = getCookie('username')
  }
  $.ajax({
    type: 'POST',
    url: _ajaxLink +"?c=Permission&m=getPermissionByUser",
    dataType: 'json',
    data:{
      username: perName
    },
    async: false,
    success: function(data){
      if(data.state == 1){
        if (data.ret != '') {
          var per = data.ret.permission.split(',')
          for (var i = 0; i < per.length; i++) {
            $(".c-permission__" + per[i]).attr('data-val', '0')
            $(".c-permission__page--" + per[i]).attr('data-val', '0')
          }
          if (data.ret.permission.indexOf('alarm') != -1) {
            _permissionIntercom = 1
          }
        }
        $('.c-permission').each(function(){
          if ($(this).attr('data-val') != '0') {
            $(this).remove()
          }
        })
        if ($('.c-content__right').attr('data-val')!= '0') {
          window.location.href="./index.html";
        }
        if ($('.c-homepage__link--items').html() == '') {
          $('.c-homepage__link').remove()
        }
        $('.c-menu__hasChild ul').each(function(){
          var len = $(this).find('li').length
          if (len <= 1) {
            $(this).parent().remove()
          }
        })
      }else if (data.state == 2){
        _permissionIntercom = 1
        return
      }else{
        window.location.href="./login.html";
      }
    }
  })
}

//*****************************************login**************************************************//
function loginAjax(){
  var loginData = {
    username: $('.c-login #username input').val(),
    password: $('.c-login #password input').val()
  }
  $.ajax({
    type: 'POST',
    url: _ajaxLink +"?c=User&m=login",
    data: loginData,
    dataType: 'json',
    async: false,
    // contentType: 'application/json;charset=utf-8',
    error: function(request){
      $('.c-login #result').attr('data-lang','string_text17')
      singleRender('string_text17')
    },
    success: function(data){
      if(data.state != 1){
        $('.c-login #result').attr('data-lang','string_login5')
        singleRender('string_login5')
      }else{
        $('.c-login #result').empty();
        $('.c-login #result').attr('data-lang','')
        // token = data.token
        var name = $('.c-login #username input').val();
        setCookie("username", name);
        // setCookie("token", token)
        window.location.href="./index.html";
      }
    }
  })
}
function loginQTAjax(){
  var loginData = {
    username: $('.c-login #username input').val(),
    password: $('.c-login #password input').val(),
    lang: $('.c-login__select .c-select').val()
  }
  var name = $('.c-login #username input').val();
  setCookie("name", name);
  setCookie("username", name);
  new QWebChannel(qt.webChannelTransport, function(channel) {
    var interactObj = channel.objects.interactObject;
    interactObj.hqLogin_submit(loginData.username, loginData.password, loginData.lang);
  });
}

//*************************************building page function*************************************//
//get building API
function getBuilding(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getBuildings&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr>";
          str += "<td data-name='building' data-val='"+ n.building+ "'>" + n.building + "</td><td>"
          //str += "<a class='f-edit' data-id='"+ n.building_id +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a>"
          str += "<a class='f-delete' data-id='"+n.building_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $("#table_building tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getBuilding',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_building tbody").html(noResultStr)
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
//add building API
$('#info_building #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var buildingVal = $('#popup__add').find('input[name="building"]')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (buildingVal.val() == '') {
    buildingVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt1')
    singleRender('string_prompt1')
  }else if (buildingVal.val().length > 3) {
    result.attr('data-lang','string_prompt2')
    singleRender('string_prompt2')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addBuilding&action=add",
      type: "POST",
      data:{
        building: addPreZero(buildingVal.val(),3)
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if(data.state == 2){
          buildingVal.css('border-color','rgb(255, 152, 0)')
          result.attr('data-lang','string_prompt3')
          singleRender('string_prompt3')
        }
      }
    })
  }
})
//edit building API
$('#info_building #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var buildingVal = $('#popup__edit').find('input[name="building"]')
  var building_id = $(this).attr('data-id')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (buildingVal.val() == '') {
    buildingVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt1')
    singleRender('string_prompt1')
  }else if (buildingVal.val().length > 3) {
    result.attr('data-lang','string_prompt2')
    singleRender('string_prompt2')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editBuilding&action=edit",
      type: "POST",
      data:{
        building_id: building_id,
        building: addPreZero(buildingVal.val(),3)
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if(data.state == 2){
          buildingVal.css('border-color','rgb(255, 152, 0)')
          result.attr('data-lang','string_prompt3')
          singleRender('string_prompt3')
        }
      }
    })
  }
})
//remove building API
$('#info_building #popup__delete .button--red').click(function(){
  var building_id = $(this).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeBuilding",
    type: "POST",
    data:{
      building_id: building_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        location.reload();
      }
    }
  })
})

//*************************************block page function*************************************//
//get block API
function getBlock(index, building){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  building = building ? building : buildingDefault;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getUnits&page="+ page + "&rpp=20",
    type: "POST",
    data: {
      building_id: building
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr>";
          str += "<td data-name='block' data-val='"+ n.unit+ "'>" + n.unit + "</td><td>"
          //str += "<a class='f-edit' data-id='"+ n.unit_id +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a>"
          str += "<a class='f-delete' data-id='"+n.unit_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $("#table_block tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getBlock',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_block tbody").html(noResultStr)
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
//add block API
$('#info_block #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var building_id = $('#popup__add').find('dt').attr('value')
  var blockVal = $('#popup__add').find('input[name="block"]')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (blockVal.val() == '') {
    blockVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt4')
    singleRender('string_prompt4')
  }else if (blockVal.val().length > 2) {
    result.attr('data-lang','string_prompt5')
    singleRender('string_prompt5')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addUnit&action=add",
      type: "POST",
      data:{
        building_id: parseInt(building_id),
        unit: addPreZero(blockVal.val(),2)
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          $('#popup__add').removeClass('is-active')
          blockVal.val('')
          getBlock(1, building_id)
        }else if(data.state == 2){
          blockVal.css('border-color','rgb(255, 152, 0)')
          result.attr('data-lang','string_prompt6')
          singleRender('string_prompt6')
        }
      }
    })
  }
})
//edit block API
$('#info_block #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var building_id = $('#popup__edit').find('dt').attr('value')
  var blockVal = $('#popup__edit').find('input[name="block"]')
  var unit_id = $(this).attr('data-id')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (blockVal.val() == '') {
    blockVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt4')
    singleRender('string_prompt4')
  }else if (blockVal.val().length > 2) {
    result.attr('data-lang','string_prompt5')
    singleRender('string_prompt5')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editUnit&action=edit",
      type: "POST",
      data:{
        building_id: building_id,
        unit_id: unit_id,
        unit: addPreZero(blockVal.val(),2)
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          $('#popup__edit').removeClass('is-active')
          blockVal.val('')
          getBlock(1, building_id)
        }else if(data.state == 2){
          blockVal.css('border-color','rgb(255, 152, 0)')
          result.attr('data-lang','string_prompt6')
          singleRender('string_prompt6')
        }
      }
    })
  }
})
//remove block API
$('#info_block #popup__delete .button--red').click(function(){
  var unit_id = $(this).attr('data-id')
  var building_id = $('#select--building').find('dt').attr('value')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeUnit",
    type: "POST",
    data:{
      unit_id: unit_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('#popup__delete').removeClass('is-active')
        getBlock(1, building_id)
      }
    }
  })
})

//*************************************room page function*************************************//
//get room API
function getRoom(index, building, unit){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  var unitDefault = $('#select--block dt').attr('value');
  building = building ? building : buildingDefault;
  unit = unit ? unit : unitDefault;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getRooms&page="+ page + "&rpp=20",
    type: "POST",
    data: {
      building_id: building,
      unit_id: unit
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          if (n.remark === null) {
            n.remark = ''
          }
          str += "<tr>";
          str += "<td data-name='room' data-val='"+ n.room+ "'>" + n.room + "</td>"
          //str += "<td data-name='remark' data-val='"+ n.remark +"'>"+ n.remark +"</td>"
          str += "<td>"
          //str += "<a class='f-edit' data-id='"+ n.room_id +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a>"
          str += "<a class='f-delete' data-id='"+n.room_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
          //<a class='f-info' data-id='"+ n.room_id+ "'><i class='fa fa-info-circle'></i></a>
        })
        $("#table_room tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getRoom',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_room tbody").html(noResultStr)
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
//add room API
$('#info_room #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var building_id = $('#select--building__add').find('dt').attr('value')
  var block_id = $('#select--block__add').find('dt').attr('value')
  var roomVal = $('#popup__add').find('input[name="room"]')
  //var remark = $('#popup__add').find('input[name="remark"]')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (roomVal.val() == '') {
    roomVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt7')
    singleRender('string_prompt7')
  }else if (roomVal.val().length > 4) {
    result.attr('data-lang','string_prompt8')
    singleRender('string_prompt8')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addRoom&action=add",
      type: "POST",
      data:{
        building_id: parseInt(building_id),
        unit_id: parseInt(block_id),
        room: addPreZero(roomVal.val(),4)
        //remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__add').removeClass('is-active')
          roomVal.val('')
          //remark.val('')
          getRoom(1, building_id, block_id)
        }else if(data.state == 2){
          roomVal.css('border-color','rgb(255, 152, 0)')
          result.attr('data-lang','string_prompt9')
          singleRender('string_prompt9')
        }
      }
    })
  }
})
//edit room API
$('#info_room #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var building_id = $('#select--building__edit').find('dt').attr('value')
  var block_id = $('#select--block__edit').find('dt').attr('value')
  var roomVal = $('#popup__edit').find('input[name="room"]')
  //var remark = $('#popup__edit').find('input[name="remark"]')
  var room_id = $(this).attr('data-id')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (roomVal.val() == '') {
    roomVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt7')
    singleRender('string_prompt7')
  }else if (roomVal.val().length > 4) {
    result.attr('data-lang','string_prompt8')
    singleRender('string_prompt8')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editRoom&action=edit",
      type: "POST",
      data:{
        building_id: building_id,
        unit_id: block_id,
        room_id: room_id,
        room: addPreZero(roomVal.val(),4)
        //remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__edit').removeClass('is-active')
          roomVal.val('')
          //remark.val('')
          getRoom(1, building_id, block_id)
        }else if(data.state == 2){
          roomVal.css('border-color','rgb(255, 152, 0)')
          result.attr('data-lang','string_prompt9')
          singleRender('string_prompt9')
        }
      }
    })
  }
})
//remove room API
$('#info_room #popup__delete .button--red').click(function(){
  var room_id = $(this).attr('data-id')
  var building_id = $('#select--building').find('dt').attr('value')
  var block_id = $('#select--block').find('dt').attr('value')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeRoom",
    type: "POST",
    data:{
      room_id: room_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('#popup__delete').removeClass('is-active')
        getRoom(1, building_id, block_id)
      }
    }
  })
})

//*************************************user page function*************************************//
//get user API
function getUser(index, building, unit, room){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  var unitDefault = $('#select--block dt').attr('value');
  var roomDefault = $('#select--room dt').attr('value');
  building = building ? building : buildingDefault;
  unit = unit ? unit : unitDefault;
  room = room ? room : roomDefault;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getBaseOwnerInfo&page="+ page + "&rpp=20",
    type: "POST",
    data: {
      building_id: building,
      unit_id: unit,
      room_id: room
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        if (data.ret.length >= 8) {
          $('#info_user .f-add').addClass('disabled')
        }else{
          $('#info_user .f-add').removeClass('disabled')
        }
        $.each(data.ret, function (k, n) {
          if (n.avatar == null || n.avatar == ''){
            n.avatar = './assets/img/default.png'
          }
          str += "<tr data-msg='"+ n.is_receive_msg +"'>";
          str += "<td data-name='avatar' data-val='"+ n.avatar +"'><img src='"+ n.avatar +"'></td>"
          str += "<td data-name='username' data-val='"+ n.name+ "'>" + n.name + "</td>"
          str += "<td data-name='phone_primary' data-val='"+ n.phone_primary+ "'>" + n.phone_primary + "</td>"
          str += "<td data-name='remark' data-val='"+ n.remark+ "'>" + n.remark + "</td>"
          str += "<td><a class='f-edit' data-id='"+ n.owner_id +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a><a class='f-delete' data-id='"+n.owner_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $("#table_user tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getUser',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_user tbody").html(noResultStr)
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
//input['file'] bind fileupload
$('.c-uploadImage').click(function(){
  $(this).siblings('input[type="file"]').click()
})
$('#uploadImageAdd').fileupload({
  url: _ajaxLink +'?c=Common&m=uploadFile&path=avatar',
  dataType: 'json',
  add:function(e, data){
    var fileSize = data.originalFiles[0]['size']
    var idx = data.originalFiles[0]['name'].lastIndexOf(".")
    if (idx != -1){
      var fileType = data.originalFiles[0]['name'].substr(idx + 1).toUpperCase();
      fileType = fileType.toLowerCase( );
    }
    if(fileSize > 10 * 1024 * 1024){
      var result = $('#popup__add').find('.result')
      result.attr('data-lang','string_text47')
      allLanguageRender()
      return false
    }else if (fileType != 'jpg' && fileType != 'jpeg' && fileType != 'png') {
      var result = $('#popup__add').find('.result')
      result.attr('data-lang','string_text53')
      allLanguageRender()
      return false
    }else{
      data.submit()
    }
  },
  done: function (e, data) {
    $('#popup__add .c-uploadImage').attr('data-src', data.result.link);
  }
})
$('#uploadImageEdit').fileupload({
  url: _ajaxLink +'?c=Common&m=uploadFile&path=avatar',
  dataType: 'json',
  add:function(e, data){
    var fileSize = data.originalFiles[0]['size']
    var idx = data.originalFiles[0]['name'].lastIndexOf(".")
    if (idx != -1){
      var fileType = data.originalFiles[0]['name'].substr(idx + 1).toUpperCase();
      fileType = fileType.toLowerCase( );
    }
    if(fileSize > 10 * 1024 * 1024){
      var result = $('#popup__edit').find('.result')
      result.attr('data-lang','string_text47')
      allLanguageRender()
      return false
    }else if (fileType != 'jpg' && fileType != 'jpeg' && fileType != 'png') {
      var result = $('#popup__edit').find('.result')
      result.attr('data-lang','string_text47')
      allLanguageRender()
      return false
    }else{
      data.submit()
    }
  },
  done: function (e, data) {
    $('#popup__edit .c-uploadImage').attr('data-src', data.result.link);
  }
})
$("#uploadImageAdd").change(function(){
  var files = !!this.files ? this.files : [];
  if (!files.length || !window.FileReader) return;
  if (/^image/.test( files[0].type) && files[0].size < 10 * 1024 * 1024){
    var reader = new FileReader();
    reader.readAsDataURL(files[0]);
    reader.onloadend = function(){
      $("#uploadImageAdd").siblings('.c-uploadImage').css("background-image", "url("+this.result+")");
      $("#uploadImageAdd").siblings('.c-uploadImage').find('p').hide()
    }
  }
});
$("#uploadImageEdit").change(function(){
  var files = !!this.files ? this.files : [];
  if (!files.length || !window.FileReader) return;
  if (/^image/.test( files[0].type) && files[0].size < 10 * 1024 * 1024){
    var reader = new FileReader();
    reader.readAsDataURL(files[0]);
    reader.onloadend = function(){
      $("#uploadImageEdit").siblings('.c-uploadImage').css("background-image", "url("+this.result+")");
      $("#uploadImageEdit").siblings('.c-uploadImage').find('p').hide()
    }
  }
});
//file upload function
$('#info_user #popup__add, #info_user #popup__add .f-close').click(function(){
  $('#info_user #popup__add .c-uploadImage').css('background-image', 'none')
  $.ajax({
    url: _ajaxLink + "?c=Common&m=deleteFile",
    type: "POST",
    data: {
      filePath: $('#info_user #popup__add .c-uploadImage').attr('data-src')
    },
    dataType: "json",
    async: false,
    success: function(data){
    }
  })
  $('#popup__add .c-uploadImage').attr('data-src','')
  $('#popup__add .c-uploadImage p').show()
})
$('#info_user #popup__edit, #info_user #popup__edit .f-close').click(function(){
  var editDiv = $('#info_user #popup__edit .c-uploadImage')
  editDiv.css('background-image', 'none')
  var oldSrc = editDiv.attr('old-data-src')
  var newSrc = editDiv.attr('data-src')
  if (oldSrc != newSrc) {
    $.ajax({
      url: _ajaxLink + "?c=Common&m=deleteFile",
      type: "POST",
      data: {
        filePath: newSrc
      },
      dataType: "json",
      async: false,
      success: function(data){
      }
    })
  }
})
//add user API
$('#info_user #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var building_val = $('#select--building__add').find('dt').html()
  var block_val = $('#select--block__add').find('dt').html()
  var room_val = $('#select--room__add').find('dt').html()
  var building_id = $('#select--building__add').find('dt').attr('value')
  var block_id = $('#select--block__add').find('dt').attr('value')
  var room_id = $('#select--room__add').find('dt').attr('value')
  var userVal = $('#popup__add').find('input[name="username"]')
  var phoneVal = $('#popup__add').find('input[name="phone_primary"]')
  var is_receive_msg;
  var remarkVal = $('#popup__add').find('input[name="remark"]')
  if ($('#msg_add .c-checked').hasClass('is-active')) {
    is_receive_msg = 1
  }else{
    is_receive_msg = 0
  }
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (userVal.val() == '') {
    userVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt10')
    singleRender('string_prompt10')
  }else if (phoneVal.val() !='' && (/([^0-9+()-])/g.test(phoneVal.val()) == true)) {
    phoneVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt27')
    singleRender('string_prompt27')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addBaseOwnerInfo",
      type: "POST",
      data:{
        avatar: $('#popup__add .c-uploadImage').attr('data-src'),
        building_id: parseInt(building_id),
        unit_id: parseInt(block_id),
        room_id: parseInt(room_id),
        building: building_val,
        unit: block_val,
        room: room_val,
        name: userVal.val(),
        phone_primary: phoneVal.val(),
        is_receive_msg: is_receive_msg,
        remark: remarkVal.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__add').removeClass('is-active')
          userVal.val('')
          phoneVal.val('')
          $('#msg_add .c-checked').addClass('is-active')
          remarkVal.val('')
          $('#popup__add .c-uploadImage').attr('data-src','')
          $('#popup__add .c-uploadImage').css('background-image','none')
          $('#popup__add .c-uploadImage p').show()
          getUser(1, building_id, block_id, room_id)
        }
      }
    })
  }
})
//edit user API
$('#info_user #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var building_id = $('#select--building__edit').find('dt').attr('value')
  var block_id = $('#select--block__edit').find('dt').attr('value')
  var room_id = $('#select--room__edit').find('dt').attr('value')
  var userVal = $('#popup__edit').find('input[name="username"]')
  var phoneVal = $('#popup__edit').find('input[name="phone_primary"]')
  var is_receive_msg;
  var remarkVal = $('#popup__edit').find('input[name="remark"]')
  var editDiv = $('#info_user #popup__edit .c-uploadImage')
  var oldSrc = editDiv.attr('old-data-src')
  var newSrc = editDiv.attr('data-src')
  var owner_id = $(this).attr('data-id')
  if ($('#msg_edit .c-checked').hasClass('is-active')) {
    is_receive_msg = 1
  }else{
    is_receive_msg = 0
  }
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (userVal.val() == '') {
    userVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt10')
    singleRender('string_prompt10')
  }else if (phoneVal.val() !='' && (/([^0-9+()-])/g.test(phoneVal.val()) == true)) {
    phoneVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt27')
    singleRender('string_prompt27')
  }else{
    var avatar;
    if ($('#popup__edit .c-uploadImage').attr('data-src') == "./assets/img/default.png") {
      avatar = ''
    }else{
      avatar = $('#popup__edit .c-uploadImage').attr('data-src')
    }
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editBaseOwnerInfo",
      type: "POST",
      data:{
        owner_id: owner_id,
        avatar: avatar,
        name: userVal.val(),
        phone_primary: phoneVal.val(),
        is_receive_msg: is_receive_msg,
        remark: remarkVal.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__edit').removeClass('is-active')
          userVal.val('')
          phoneVal.val('')
          remarkVal.val('')
          if(oldSrc != newSrc && oldSrc != './assets/img/default.png'){
            $.ajax({
              url: _ajaxLink + "?c=Common&m=deleteFile",
              type: "POST",
              data: {
                filePath: oldSrc
              },
              dataType: "json",
              async: false,
              success: function(data){
              }
            })
          }
          getUser(1, building_id, block_id, room_id)
        }
      }
    })
  }
})
//remove user API
$('#info_user #popup__delete .button--red').click(function(){
  var owner_id = $(this).attr('data-id')
  var building_id = $('#select--building').find('dt').attr('value')
  var block_id = $('#select--block').find('dt').attr('value')
  var room_id = $('#select--room').find('dt').attr('value')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeBaseOwnerInfo",
    type: "POST",
    data:{
      owner_id: owner_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('#popup__delete').removeClass('is-active')
        getUser(1, building_id, block_id, room_id)
      }
    }
  })
})

//*************************************indoor page function*************************************//
//get indoor API
function getIndoor(index, building, unit, room){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  var unitDefault = $('#select--block dt').attr('value');
  var roomDefault = $('#select--room dt').attr('value');
  building = building ? building : buildingDefault;
  unit = unit ? unit : unitDefault;
  room = room ? room : roomDefault;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getIndoors&page="+ page + "&rpp=20",
    type: "POST",
    data: {
      building_id: building,
      unit_id: unit,
      room_id: room
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr>";
          str += "<td data-name='indoor_no' data-val='"+ n.xh+ "'>" + n.xh + "</td>"
          str += "<td data-name='ip_address' data-val='"+ n.device_ip +"'>"+ n.device_ip +"</td>"
          str += "<td data-name='device_type' data-val='"+ n.device_type+ "'>" + n.device_type + "</td>"
          str += "<td data-name='remark' data-val='"+ n.remark+ "'>" + n.remark + "</td>"
          str += "<td><a class='f-edit' data-id='"+ n.indoor_id +"' onclick='deviceEditThis(this)'><i class='fa fa-pencil'></i></a><a class='f-delete' data-id='"+n.indoor_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $("#table_indoor tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getIndoor',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_indoor tbody").html(noResultStr)
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
//add indoor API
$('#info_indoor #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var building_id = $('#select--building__add').find('dt').attr('value')
  var block_id = $('#select--block__add').find('dt').attr('value')
  var room_id = $('#select--room__add').find('dt').attr('value')
  var building = $('#select--building__add').find('dt').html()
  var block = $('#select--block__add').find('dt').html()
  var room = $('#select--room__add').find('dt').html()
  var ipInput = $('#popup__add').find('#ipAddress__add input')
  var modelNumber = $('#popup__add').find('#modelNumber__add')
  var remark = $('#popup__add').find('input[name="remark"]')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  ipInput.each(function(){
    if ($(this).val() == '') {
      ipInput.css('border-color','#ff9800')
      result.attr('data-lang','string_prompt11')
      singleRender('string_prompt11')
      $('#ipAddress__add').attr('data-state','error')
      return false
    }else{
      $('#ipAddress__add').attr('data-state','ture')
      ipAddress = ipArr.join('.')
    }
  })

  if ($('#ipAddress__add').attr('data-state') == 'error') {
    return false
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addIndoor&action=add",
      type: "POST",
      data:{
        building: building,
        unit: block,
        room: room,
        building_id: parseInt(building_id),
        unit_id: parseInt(block_id),
        room_id: parseInt(room_id),
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__add').removeClass('is-active')
          ipInput.val('')
          remark.val('')
          getIndoor(1, building_id, block_id, room_id)
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//edit indoor API
$('#info_indoor #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var building_id = $('#select--building__edit').find('dt').attr('value')
  var block_id = $('#select--block__edit').find('dt').attr('value')
  var room_id = $('#select--room__edit').find('dt').attr('value')
  var ipInput = $('#popup__edit').find('#ipAddress__edit input')
  var modelNumber = $('#popup__edit').find('#modelNumber__edit')
  var remark = $('#popup__edit').find('input[name="remark"]')
  var indoor_id = $(this).attr('data-id')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  ipInput.each(function(){
    if ($(this).val() == '') {
      ipInput.css('border-color','#ff9800')
      result.attr('data-lang','string_prompt11')
      singleRender('string_prompt11')
      $('#ipAddress__edit').attr('data-state','error')
      return false
    }else{
      $('#ipAddress__edit').attr('data-state','ture')
      ipAddress = ipArr.join('.')
    }
  })

  if ($('#ipAddress__edit').attr('data-state') == 'error') {
    return false
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editIndoor&action=edit",
      type: "POST",
      data:{
        indoor_id: indoor_id,
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__edit').removeClass('is-active')
          ipInput.val('')
          remark.val('')
          getIndoor(1, building_id, block_id, room_id)
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//remove indoor API
$('#info_indoor #popup__delete .button--red').click(function(){
  var indoor_id = $(this).attr('data-id')
  var building_id = $('#select--building').find('dt').attr('value')
  var block_id = $('#select--block').find('dt').attr('value')
  var room_id = $('#select--room').find('dt').attr('value')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeIndoor",
    type: "POST",
    data:{
      indoor_id: indoor_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('#popup__delete').removeClass('is-active')
        getIndoor(1, building_id, block_id, room_id)
      }
    }
  })
})

//*************************************outdoor page function*************************************//
//get outdoor API
function getOutdoor(index, building, unit){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  var unitDefault = $('#select--block dt').attr('value');
  building = building ? building : buildingDefault;
  unit = unit ? unit : unitDefault;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getOutdoors&page="+ page + "&rpp=20",
    type: "POST",
    data: {
      building_id: building,
      unit_id: unit
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr>";
          str += "<td data-name='outdoor_no' data-val='"+ n.outdoor_no+ "'>" + n.outdoor_no + "</td>"
          str += "<td data-name='ip_address' data-val='"+ n.device_ip +"'>"+ n.device_ip +"</td>"
          str += "<td data-name='device_type' data-val='"+ n.device_type+ "'>" + n.device_type + "</td>"
          str += "<td data-name='remark' data-val='"+ n.remark+ "'>" + n.remark + "</td>"
          str += "<td><a class='f-edit' data-id='"+ n.outdoor_id +"' onclick='deviceEditThis(this)'><i class='fa fa-pencil'></i></a><a class='f-delete' data-id='"+n.outdoor_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $("#table_outdoor tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getOutdoor',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_outdoor tbody").html(noResultStr)
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
//add outdoor API
$('#info_outdoor #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var building = $('#select--building__add dt').html()
  var unit = $('#select--block__add dt').html()
  var building_id = $('#select--building__add').find('dt').attr('value')
  var block_id = $('#select--block__add').find('dt').attr('value')
  var ipInput = $('#popup__add').find('#ipAddress__add input')
  var outdoor_no = $('#popup__add').find('input[name="outdoor_no"]')
  var modelNumber = $('#popup__add').find('#modelNumber__add')
  var remark = $('#popup__add').find('input[name="remark"]')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  var ipAddress = ipArr.join('')
  if (ipAddress != '') {
    ipInput.each(function(){
      if ($(this).val() == '') {
        ipInput.css('border-color','#ff9800')
        result.attr('data-lang','string_prompt11')
        singleRender('string_prompt11')
        $('#ipAddress__add').attr('data-state','error')
        return false
      }else{
        $('#ipAddress__add').attr('data-state','ture')
        ipAddress = ipArr.join('.')
      }
    })
  }else{
    $('#ipAddress__add').attr('data-state','ture')
    ipAddress = ''
  }

  if ($('#ipAddress__add').attr('data-state') == 'error') {
    return false
  }else if(outdoor_no.val() == '' || outdoor_no.val().length > 4 || outdoor_no.val() == 0){
    outdoor_no.css('border-color', '#ff9800')
    result.attr('data-lang','string_prompt12')
    singleRender('string_prompt12')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addOutdoor&action=add",
      type: "POST",
      data:{
        building: building,
        unit: unit,
        building_id: parseInt(building_id),
        unit_id: parseInt(block_id),
        outdoor_no: outdoor_no.val(),
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__add').removeClass('is-active')
          outdoor_no.val('')
          ipInput.val('')
          remark.val('')
          getOutdoor(1, building_id, block_id)
        }else if(data.state == 2){
          outdoor_no.css('border-color', '#ff9800')
          result.attr('data-lang','string_prompt13')
          singleRender('string_prompt13')
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//edit outdoor API
$('#info_outdoor #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var building_id = $('#select--building__edit').find('dt').attr('value')
  var block_id = $('#select--block__edit').find('dt').attr('value')
  var ipInput = $('#popup__edit').find('#ipAddress__edit input')
  var outdoor_no = $('#popup__edit').find('input[name="outdoor_no"]')
  var modelNumber = $('#popup__edit').find('#modelNumber__edit')
  var remark = $('#popup__edit').find('input[name="remark"]')
  var outdoor_id = $(this).attr('data-id')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  var ipAddress = ipArr.join('')
  if (ipAddress != '') {
    ipInput.each(function(){
      if ($(this).val() == '') {
        ipInput.css('border-color','#ff9800')
        result.attr('data-lang','string_prompt11')
        singleRender('string_prompt11')
        $('#ipAddress__edit').attr('data-state','error')
        return false
      }else{
        $('#ipAddress__edit').attr('data-state','ture')
        ipAddress = ipArr.join('.')
      }
    })
  }else{
    $('#ipAddress__edit').attr('data-state','ture')
    ipAddress = ''
  }

  if ($('#ipAddress__edit').attr('data-state') == 'error') {
    return false
  }else if(outdoor_no.val() == '' || outdoor_no.val().length > 4 || outdoor_no.val() == 0){
    outdoor_no.css('border-color', '#ff9800')
    result.attr('data-lang','string_prompt12')
    singleRender('string_prompt12')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editOutdoor&action=edit",
      type: "POST",
      data:{
        outdoor_id: outdoor_id,
        building_id: parseInt(building_id),
        unit_id: parseInt(block_id),
        outdoor_no: outdoor_no.val(),
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__edit').removeClass('is-active')
          outdoor_no.val('')
          ipInput.val('')
          remark.val('')
          getOutdoor(1, building_id, block_id)
        }else if(data.state == 2){
          outdoor_no.css('border-color', '#ff9800')
          result.attr('data-lang','string_prompt13')
          singleRender('string_prompt13')
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//remove outdoor API
$('#info_outdoor #popup__delete .button--red').click(function(){
  var outdoor_id = $(this).attr('data-id')
  var building_id = $('#select--building').find('dt').attr('value')
  var block_id = $('#select--block').find('dt').attr('value')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeOutdoor",
    type: "POST",
    data:{
      outdoor_id: outdoor_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('#popup__delete').removeClass('is-active')
        getOutdoor(1, building_id, block_id)
      }
    }
  })
})

//*************************************wall page function*************************************//
//get wall API
function getWall(index){
  page = index ? index : page;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getWallInfo&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr>";
          str += "<td data-name='wall_no' data-val='"+ n.wall_no+ "'>" + n.wall_no + "</td>"
          str += "<td data-name='ip_address' data-val='"+ n.device_ip +"'>"+ n.device_ip +"</td>"
          str += "<td data-name='device_type' data-val='"+ n.device_type+ "'>" + n.device_type + "</td>"
          str += "<td data-name='remark' data-val='"+ n.remark+ "'>" + n.remark + "</td>"
          str += "<td><a class='f-edit' data-id='"+ n.wall_id +"' onclick='deviceEditThis(this)'><i class='fa fa-pencil'></i></a><a class='f-delete' data-id='"+n.wall_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $("#table_fence tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getWall',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_fence tbody").html(noResultStr)
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}
//add wall API
$('#info_fence #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var ipInput = $('#popup__add').find('#ipAddress__add input')
  var wall_no = $('#popup__add').find('input[name="wall_no"]')
  var modelNumber = $('#popup__add').find('#modelNumber__add')
  var remark = $('#popup__add').find('input[name="remark"]')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  var ipAddress = ipArr.join('')
  if (ipAddress != '') {
    ipInput.each(function(){
      if ($(this).val() == '') {
        ipInput.css('border-color','#ff9800')
        result.attr('data-lang','string_prompt11')
        singleRender('string_prompt11')
        $('#ipAddress__add').attr('data-state','error')
        return false
      }else{
        $('#ipAddress__add').attr('data-state','ture')
        ipAddress = ipArr.join('.')
      }
    })
  }else{
    $('#ipAddress__add').attr('data-state','ture')
    ipAddress = ''
  }

  if ($('#ipAddress__add').attr('data-state') == 'error') {
    return false
  }else if(wall_no.val() == '' || wall_no.val().length > 4 || wall_no.val() == 0){
    wall_no.css('border-color', '#ff9800')
    result.attr('data-lang','string_prompt12')
    singleRender('string_prompt12')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addWallInfo&action=add",
      type: "POST",
      data:{
        wall_no: wall_no.val(),
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__add').removeClass('is-active')
          wall_no.val('')
          ipInput.val('')
          remark.val('')
          getWall(1)
        }else if(data.state == 2){
          wall_no.css('border-color', '#ff9800')
          result.attr('data-lang','string_prompt13')
          singleRender('string_prompt13')
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//edit wall API
$('#info_fence #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var ipInput = $('#popup__edit').find('#ipAddress__edit input')
  var wall_no = $('#popup__edit').find('input[name="wall_no"]')
  var modelNumber = $('#popup__edit').find('#modelNumber__edit')
  var remark = $('#popup__edit').find('input[name="remark"]')
  var wall_id = $(this).attr('data-id')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  var ipAddress = ipArr.join('')
  if (ipAddress != '') {
    ipInput.each(function(){
      if ($(this).val() == '') {
        ipInput.css('border-color','#ff9800')
        result.attr('data-lang','string_prompt11')
        singleRender('string_prompt11')
        $('#ipAddress__edit').attr('data-state','error')
        return false
      }else{
        $('#ipAddress__edit').attr('data-state','ture')
        ipAddress = ipArr.join('.')
      }
    })
  }else{
    $('#ipAddress__edit').attr('data-state','ture')
    ipAddress = ''
  }

  if ($('#ipAddress__edit').attr('data-state') == 'error') {
    return false
  }else if(wall_no.val() == '' || wall_no.val().length > 4 || wall_no.val() == 0){
    wall_no.css('border-color', '#ff9800')
    result.attr('data-lang','string_prompt12')
    singleRender('string_prompt12')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editWallInfo&action=edit",
      type: "POST",
      data:{
        wall_id: wall_id,
        wall_no: wall_no.val(),
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__edit').removeClass('is-active')
          wall_no.val('')
          ipInput.val('')
          remark.val('')
          getWall(1)
        }else if(data.state == 2){
          wall_no.css('border-color', '#ff9800')
          result.attr('data-lang','string_prompt13')
          singleRender('string_prompt13')
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//remove wall API
$('#info_fence #popup__delete .button--red').click(function(){
  var wall_id = $(this).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeWallInfo",
    type: "POST",
    data:{
      wall_id: wall_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('#popup__delete').removeClass('is-active')
        getWall(1)
      }
    }
  })
})

//*************************************guard page function*************************************//
//get guard API
function getGuard(index, building, unit){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  var unitDefault = $('#select--block dt').attr('value');
  building = building ? building : buildingDefault;
  unit = unit ? unit : unitDefault;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getGuardInfo&page="+ page + "&rpp=20",
    type: "POST",
    data: {
      building_id: building,
      unit_id: unit
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr>";
          str += "<td data-name='guard_no' data-val='"+ n.guard_no+ "'>" + n.guard_no + "</td>"
          str += "<td data-name='ip_address' data-val='"+ n.device_ip +"'>"+ n.device_ip +"</td>"
          str += "<td data-name='device_type' data-val='"+ n.device_type+ "'>" + n.device_type + "</td>"
          str += "<td data-name='remark' data-val='"+ n.remark+ "'>" + n.remark + "</td>"
          str += "<td><a class='f-edit' data-id='"+ n.guard_id +"' onclick='deviceEditThis(this)'><i class='fa fa-pencil'></i></a><a class='f-delete' data-id='"+n.guard_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $("#table_guard tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getGuard',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_guard tbody").html(noResultStr)
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}
//add guard API
$('#info_guard #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var building = $('#select--building__add dt').html()
  var unit = $('#select--block__add dt').html()
  var building_id = $('#select--building__add').find('dt').attr('value')
  var block_id = $('#select--block__add').find('dt').attr('value')
  var ipInput = $('#popup__add').find('#ipAddress__add input')
  var guard_no = $('#popup__add').find('input[name="guard_no"]')
  var modelNumber = $('#popup__add').find('#modelNumber__add')
  var remark = $('#popup__add').find('input[name="remark"]')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  var ipAddress = ipArr.join('')
  if (ipAddress != '') {
    ipInput.each(function(){
      if ($(this).val() == '') {
        ipInput.css('border-color','#ff9800')
        result.attr('data-lang','string_prompt11')
        singleRender('string_prompt11')
        $('#ipAddress__add').attr('data-state','error')
        return false
      }else{
        $('#ipAddress__add').attr('data-state','ture')
        ipAddress = ipArr.join('.')
      }
    })
  }else{
    $('#ipAddress__add').attr('data-state','ture')
    ipAddress = ''
  }

  if ($('#ipAddress__add').attr('data-state') == 'error') {
    return false
  }else if(guard_no.val() == '' || guard_no.val().length > 4 || guard_no.val() == 0){
    guard_no.css('border-color', '#ff9800')
    result.attr('data-lang','string_prompt12')
    singleRender('string_prompt12')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addGuardInfo&action=add",
      type: "POST",
      data:{
        building: building,
        unit: unit,
        building_id: parseInt(building_id),
        unit_id: parseInt(block_id),
        guard_no: guard_no.val(),
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__add').removeClass('is-active')
          guard_no.val('')
          ipInput.val('')
          remark.val('')
          getGuard(1, building_id, block_id)
        }else if(data.state == 2){
          guard_no.css('border-color', '#ff9800')
          result.attr('data-lang','string_prompt13')
          singleRender('string_prompt13')
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//edit guard API
$('#info_guard #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var building_id = $('#select--building__edit').find('dt').attr('value')
  var block_id = $('#select--block__edit').find('dt').attr('value')
  var ipInput = $('#popup__edit').find('#ipAddress__edit input')
  var guard_no = $('#popup__edit').find('input[name="guard_no"]')
  var modelNumber = $('#popup__edit').find('#modelNumber__edit')
  var remark = $('#popup__edit').find('input[name="remark"]')
  var guard_id = $(this).attr('data-id')
  var ipArr = []
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  ipInput.each(function(){
    ipArr.push($(this).val())
  })
  var ipAddress = ipArr.join('')
  if (ipAddress != '') {
    ipInput.each(function(){
      if ($(this).val() == '') {
        ipInput.css('border-color','#ff9800')
        result.attr('data-lang','string_prompt11')
        singleRender('string_prompt11')
        $('#ipAddress__edit').attr('data-state','error')
        return false
      }else{
        $('#ipAddress__edit').attr('data-state','ture')
        ipAddress = ipArr.join('.')
      }
    })
  }else{
    $('#ipAddress__edit').attr('data-state','ture')
    ipAddress = ''
  }

  if ($('#ipAddress__edit').attr('data-state') == 'error') {
    return false
  }else if(guard_no.val() == '' || guard_no.val().length > 4 || guard_no.val() == 0){
    guard_no.css('border-color', '#ff9800')
    result.attr('data-lang','string_prompt12')
    singleRender('string_prompt12')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editGuardInfo&action=edit",
      type: "POST",
      data:{
        guard_id: guard_id,
        building_id: parseInt(building_id),
        unit_id: parseInt(block_id),
        guard_no: guard_no.val(),
        device_type: modelNumber.val(),
        device_ip: ipAddress,
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1 && data.ret != ''){
          $('#popup__edit').removeClass('is-active')
          guard_no.val('')
          ipInput.val('')
          remark.val('')
          getGuard(1, building_id, block_id)
        }else if(data.state == 2){
          guard_no.css('border-color', '#ff9800')
          result.attr('data-lang','string_prompt13')
          singleRender('string_prompt13')
        }else if(data.state == 4){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt11')
          singleRender('string_prompt11')
        }else if(data.state == 11){
          ipInput.css('border-color','#ff9800')
          result.attr('data-lang','string_prompt24')
          singleRender('string_prompt24')
        }
      }
    })
  }
})
//remove guard API
$('#info_guard #popup__delete .button--red').click(function(){
  var guard_id = $(this).attr('data-id')
  var building_id = $('#select--building').find('dt').attr('value')
  var block_id = $('#select--block').find('dt').attr('value')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeGuardInfo",
    type: "POST",
    data:{
      guard_id: guard_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('#popup__delete').removeClass('is-active')
        getGuard(1, building_id, block_id)
      }
    }
  })
})

//*************************************management page function*************************************//
//get management API
// function getManagement(){
//   $.ajax({
//     url: _ajaxLink + "?c=BasicInfo&m=getClients",
//     type: "GET",
//     dataType: "json",
//     async: false,
//     success: function(data){
//       if (data.state == 1 && data.ret != '') {
//         var str = "";
//         var localStr = "";
//         $.each(data.ret, function (k, n) {
//           if (n.deviceID == getCookie('c_deviceid')) {
//             localStr += "<tr>";
//             localStr += "<td data-name='management_no'><span>" + n.deviceID[9] + n.deviceID[10] + "</span><span data-lang='string_local'></span></td>"
//             if (n.clientName == null || n.clientName == '') {
//               var clientName = "<span data-lang='string_otherCenter'></span><span>"+ n.deviceID[9] + n.deviceID[10] +"</span>"
//               localStr += "<td data-name='clientName' data-val=''>" + clientName + "</td>"
//             }else{
//               localStr += "<td data-name='clientName' data-val='"+ n.clientName + "'>" + n.clientName + "</td>"
//             }
//             localStr += "<td><a class='f-edit' data-id='"+ n.clientID +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a></td>";
//             localStr += "</tr>";
//           }else {
//             str += "<tr>";
//             str += "<td data-name='management_no'>" + n.deviceID[9] + n.deviceID[10] + "</td>"
//             if (n.clientName == null || n.clientName == '') {
//               var clientName = "<span data-lang='string_otherCenter'></span><span>"+ n.deviceID[9] + n.deviceID[10] +"</span>"
//               str += "<td data-name='clientName' data-val=''>" + clientName + "</td>"
//             }else{
//               str += "<td data-name='clientName' data-val='"+ n.clientName + "'>" + n.clientName + "</td>"
//             }
//             str += "<td><a class='f-edit' data-id='"+ n.clientID +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a><a class='f-delete' data-id='"+n.clientID+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>";
//             str += "</tr>";
//           }
//         })
//         str = localStr + str
//         $("#table_management tbody").html(str)
//         getPagiation(data.total,$(".pagination"),'getManagement',page);
//       }else if (data.state == 1 && data.ret == ''){
//         $("#table_management tbody").html(noResultStr)
//         $(".pagination").html('')
//       }
//       allLanguageRender()
//     }
//   })
// }
//
// //edit management API
// $('#info_management #popup__edit .button--orange').click(function(){
//   var input = $('#popup__edit').find('input')
//   var result = $('#popup__edit').find('.result')
//   var nickName = $('#popup__edit').find('input[name="clientName"]')
//   var clientid = $(this).attr('data-id')
//
//   if(nickName.val() == ''){
//     nickName.css('border-color', '#ff9800')
//     result.attr('data-lang','string_prompt25')
//     singleRender('string_prompt25')
//   }else{
//     $.ajax({
//       url: _ajaxLink + "?c=BasicInfo&m=editClient",
//       type: "POST",
//       data:{
//         clientID: clientid,
//         clientName: nickName.val()
//       },
//       dataType: "json",
//       success: function(data){
//         if(data.state==1 && data.ret != ''){
//           $('#popup__edit').removeClass('is-active')
//           nickName.val('')
//           getManagement()
//         }else if(data.state == 2){
//           nickName.css('border-color', '#ff9800')
//           result.attr('data-lang','string_prompt26')
//           singleRender('string_prompt26')
//         }
//       }
//     })
//   }
// })
//
// //remove management API
// $('#info_management #popup__delete .button--red').click(function(){
//   var clientid = $(this).attr('data-id')
//   $.ajax({
//     url: _ajaxLink + "?c=BasicInfo&m=deleteClient",
//     type: "POST",
//     data:{
//       clientID: clientid
//     },
//     dataType: "json",
//     success: function(data){
//       if(data.state==1){
//         $('#popup__delete').removeClass('is-active')
//         getManagement()
//       }
//     }
//   })
// })
//*************************************setting page function*************************************//
$('.pick-area + .button--orange').click(function(){
  $('.result').html('')
  $('.result').attr('data-lang','')
  var location_id = $(this).attr('data-id')
  var location_name = $('input.pick-area').val()
  if (location_name.indexOf("/") <= 0 ) {
    $('.result').attr('data-lang','string_prompt15')
    singleRender('string_prompt15')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=Configuration&m=location",
      type: "POST",
      data:{
        citycode: location_id,
        cityname: location_name
      },
      async: false,
      dataType: "json",
      success: function(data){
        if(data.state==1){
          if (getCookie('c_username') != '') {
            new QWebChannel(qt.webChannelTransport, function(channel) {
              var interactObj = channel.objects.interactObject;
              interactObj.hqConfigure_refreshWeather(location_id);
            });
          }
          $('#popup__tips').addClass('is-active')
          $('.c-local__tips h2').attr('data-lang','string_calendarSuccess')
          singleRender('string_calendarSuccess')
          map.centerAndZoom($('input.pick-area').val(),12);
          map.addEventListener("tilesloaded",function(){
            var cp = map.getBounds()
            var pt = cp.getCenter()
            var zoom=map.getZoom()
            $("#mapInfo").val(zoom)
            $("#lng").val(pt.lng)
            $("#lat").val(pt.lat)
          });
        }else{
          $('#popup__tips').addClass('is-active')
          $('.c-local__tips h2').attr('data-lang','string_calendarError')
          singleRender('string_calendarError')
        }
      }
    })
  }
})
$('#setting_rss .button--orange').click(function(){
  if ($(this).hasClass('disabled')) {
    return false
  }else{
    var value = $(this).siblings('dl').find('dt').attr('value')
    var data_value = $(this).siblings('dl').find('dt').attr('data-value')
    var html = $(this).siblings('dl').find('dt').html()
    $('.loading-img').css('display','inline-block')
    $(this).addClass('disabled')
    var xhr = $.ajax({
      url: _ajaxLink + "?c=Configuration&m=rssNews",
      type: "POST",
      data:{
        newsid: value,
        newsname: html
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if (data.state == 0) {
          $('#popup__error').addClass('is-active')
          $('#popup__error h2').attr('data-lang', 'string_sourseProblem')
          allLanguageRender()
          $('#setting_rss .button--orange').removeClass('disabled')
          $('.loading-img').hide()
        }else if (data.state == 2) {
          $('#popup__error').addClass('is-active')
          $('#popup__error h2').attr('data-lang', 'string_lessMessage')
          allLanguageRender()
          $('#setting_rss .button--orange').removeClass('disabled')
          $('.loading-img').hide()
        }else if (data.state == 3) {
          $('#popup__error').addClass('is-active')
          $('#popup__error h2').attr('data-lang', 'string_timeout')
          allLanguageRender()
          $('#setting_rss .button--orange').removeClass('disabled')
          $('.loading-img').hide()
        }
      }
    })
  }
})

//*************************************message page function*************************************//
function searchBlock(obj){
  if (!$(obj).hasClass('is-active')) {
    $('#room--list .c-message__table--list').html('')
    var old_building_id = $('#building--list .c-message__table--list a.is-active').attr('value')
    var old_block_class = []
    $('#block--list .c-message__table--list a .c-checked').each(function(){
    	var thisClass = $(this).attr('class')
    	old_block_class.push(thisClass)
    })
    var old_name = 'block' + old_building_id
    setSessionStorage(old_name, old_block_class)

    var building_id = $(obj).attr('value')
    $(obj).siblings('a').removeClass('is-active')
    $(obj).addClass('is-active')
    getBlockList(building_id)

    var unit_id = $('#block--list .c-message__table--list a.is-active').attr('value')
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

    var sessionName = 'block' + building_id
    var blockClass = getSessionStorage(sessionName)
    if (blockClass != null) {
      blockClass = getStrClass(blockClass)
    }else{
      blockClass = ''
    }
    $('#block--list .c-message__table--list a').each(function(i){
      $(this).find('.c-checked').attr('class', blockClass[i])
    })
    setSessionStorage(sessionName,'')
    if ($(obj).find('.c-checked').hasClass('checkAll')) {
      $('#block--list .c-message__table--list a .c-checked').removeClass('checkNotAll').addClass('checkAll')
    }
  }else{
    var blockList = $('#block--list .c-message__table--list a')
    if (blockList.length > 1) {
      $('#room--list .c-message__table--list').html('')
    }
    if (!$(obj).find('.c-checked').hasClass('checkAll')) {
      for(var i = blockList.length - 1 ; i >= 0 ; i--){
        var checkBox = blockList.eq(i).find('.c-checked')
        if (!checkBox.hasClass('checkNotAll') && !checkBox.hasClass('checkAll') && !blockList.eq(i).hasClass('is-active')) {
          blockList.eq(i).click().click()
        }else if (checkBox.hasClass('checkNotAll') && blockList.eq(i).hasClass('is-active')) {
          blockList.eq(i).click()
        }else if( checkBox.hasClass('checkNotAll') && !blockList.eq(i).hasClass('is-active')){
          blockList.eq(i).click().click()
        }else if (!checkBox.hasClass('checkNotAll') && !checkBox.hasClass('checkAll') && blockList.eq(i).hasClass('is-active')){
          blockList.eq(i).click()
        }
      }
    }else{
      $(obj).find('.c-checked').removeClass('checkAll')
      for(var i = blockList.length - 1 ; i >= 0 ; i--){
        var checkBox = blockList.eq(i).find('.c-checked')
        if (!blockList.eq(i).hasClass('is-active')) {
          blockList.eq(i).click().click()
        }else{
          blockList.eq(i).click()
        }
      }
    }
  }
}
function searchRoom(obj){
  var building_id = $('#building--list .c-message__table--list a.is-active').attr('value')
  var unit_id = $(obj).attr('value')

  if (!$(obj).hasClass('is-active')) {
    $(obj).siblings('a').removeClass('is-active')
    $(obj).addClass('is-active')
    getRoomList(building_id, unit_id)
  }else{
    var checked = $(obj).find('.c-checked')
    var roomList = $('#room--list .c-message__table--list a')
    if (checked.hasClass('checkAll')) {
      checked.removeClass('checkAll')
      roomList.each(function(){
        $(this).click()
      })
    }else{
      checked.removeClass('checkNotAll')
      checked.addClass('checkAll')
      roomList.each(function(){
        if (!$(this).hasClass('is-active')) {
          $(this).click()
        }
      })
    }
  }

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
}
function addThisRoom(obj){
  var noArr = []
  var building_id = $('#building--list .c-message__table--list a.is-active').attr('value')
  var unit_id = $('#block--list .c-message__table--list a.is-active').attr('value')
  var room_id = $(obj).attr('value')

  var building = $('#building--list .c-message__table--list a.is-active p').html()
  var unit = $('#block--list .c-message__table--list a.is-active p').html()
  var room = $(obj).find('p').html()

  var blockCheckbox = $('#block--list .c-message__table--list a.is-active .c-checked')
  var buildingCheckbox = $('#building--list .c-message__table--list a.is-active .c-checked')
  noArr.push(building_id, unit_id, room_id)
  noArr = noArr.join('-')

  $(obj).toggleClass('is-active')

  if ($(obj).hasClass('is-active')) {
    if (tem_lang == 'zh') {
      $('.c-message__addressee').append("<div data-value='"+ noArr +"'><p>"+ building +"栋"+ unit +"单元"+ room +"室</p></div>")
    }else if (tem_lang == 'en') {
      $('.c-message__addressee').append("<div data-value='"+ noArr +"'><p>Room"+ room +" Blk"+ unit +" Bld"+ building +"</p></div>")
    }else if (tem_lang == 'hk') {
      $('.c-message__addressee').append("<div data-value='"+ noArr +"'><p>"+ building +"棟"+ unit +"單元"+ room +"室</p></div>")
    }
    $('#room--list .c-message__table--list a').each(function(){
      if ($(this).hasClass('is-active')) {
        blockCheckbox.addClass('checkAll')
        blockCheckbox.removeClass('checkNotAll')
      }else{
        blockCheckbox.addClass('checkNotAll')
        blockCheckbox.removeClass('checkAll')
        return false
      }
    })
    $('#block--list .c-message__table--list a').each(function(){
      if ($(this).find('.c-checked').hasClass('checkAll')) {
        buildingCheckbox.addClass('checkAll')
        buildingCheckbox.removeClass('checkNotAll')
      }else{
        buildingCheckbox.addClass('checkNotAll')
        buildingCheckbox.removeClass('checkAll')
        return false
      }
    })
  }else{
    $('.c-message__addressee div').each(function(){
      if ($(this).attr('data-value') == noArr) {
        $(this).remove()
      }
    })
    $('#room--list .c-message__table--list a').each(function(){
      if (!$(this).hasClass('is-active')) {
        blockCheckbox.removeClass('checkNotAll')
        blockCheckbox.removeClass('checkAll')
      }else{
        blockCheckbox.addClass('checkNotAll')
        blockCheckbox.removeClass('checkAll')
        return false
      }
    })
    $('#block--list .c-message__table--list a').each(function(){
      if (!$(this).find('.c-checked').hasClass('checkAll') && !$(this).find('.c-checked').hasClass('checkNotAll')) {
        buildingCheckbox.removeClass('checkNotAll')
        buildingCheckbox.removeClass('checkAll')
      }else{
        buildingCheckbox.addClass('checkNotAll')
        buildingCheckbox.removeClass('checkAll')
        return false
      }
    })
  }
}
$('#message__checkAll').click(function(){
  $('.c-message__addressee').html('')
  var building_id = 0
  var unit_id = 0
  var room_id = 0
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getRoomsByUnitAndBuilding&page=1&rpp=10000",
    type: "POST",
    data:{
      building_id: building_id,
      unit_id: unit_id,
      room_id: room_id
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          var position_id = n.building_id + '-' + n.unit_id + '-' + n.room_id
          if (tem_lang == 'zh') {
            var position = n.building + '栋' + n.unit + '单元' + n.room + '室'
          }else if (tem_lang == 'en') {
            var position = 'Room' + n.room + ' Blk' + n.unit + ' Bld' + n.building
          }else if (tem_lang == 'hk') {
            var position = n.building + '棟' + n.unit + '單元' + n.room + '室'
          }
          str += "<div data-value='"+ position_id +"'><p>"+ position +"</p></div>";
        })
        $('.c-message__addressee').html(str)
      }else if (data.state == 1 && data.ret == ''){
        $('.c-message__addressee').html('')
      }
      $('#building--list .c-checked').removeClass('checkNotAll').addClass('checkAll')
      $('#block--list .c-checked').removeClass('checkNotAll').addClass('checkAll')
      $('#room--list .waves-effect').addClass('is-active')
    }
  })
})
$('#message__checkClean').click(function(){
  $('.c-message__addressee').html('')
  $('#building--list .c-checked').removeClass('checkNotAll').removeClass('checkAll')
  $('#block--list .c-checked').removeClass('checkNotAll').removeClass('checkAll')
  $('#room--list .waves-effect').removeClass('is-active')
  sessionStorage.clear()
})
$('.c-message__sendBtn .button--orange#save').click(function(){
  $('.c-message__sendBtn .result').html('')
  $('.c-message__sendBtn .result').attr('data-lang','')
  $("input[name='title']").css('border-color', '#ccc')
  $('#textarea--content').css('border-color', '#ccc')
  $(".c-message__addressee").css('border-color', '#ccc')
  var importantVal
  var title = $("input[name='title']").val()
  var important = $('.c-message__important .c-checked')
  var mid = Guid()
  if(important.hasClass('is-active')){
    importantVal = '1'
  }else{
    importantVal = '0'
  }
  var content = $('#textarea--content').val()
  var sender = getCookie('c_username') ? getCookie('c_username') : getCookie('username')
  if ($('.c-message__addressee').html() == '') {
    $('.c-message__sendBtn .result').attr('data-lang','string_prompt16')
    singleRender('string_prompt16')
    $(".c-message__addressee").css('border-color', '#ff9800')
  }else if (title == '') {
    $('.c-message__sendBtn .result').attr('data-lang','string_prompt17')
    singleRender('string_prompt17')
    $("input[name='title']").css('border-color', '#ff9800')
  }else if (content == '') {
    $('.c-message__sendBtn .result').attr('data-lang','string_prompt18')
    singleRender('string_prompt18')
    $('#textarea--content').css('border-color', '#ff9800')
  }else{
    var sendSuccess = []
    $('.c-message__addressee div').each(function(){
      var value = {
        id: $(this).attr('data-value')
      }
      sendSuccess.push(value)
    })
    var successData = {
      title: title,
      important: importantVal,
      content: content,
      receiver: sendSuccess,
      sender: sender,
      mid: mid
    }
    $.ajax({
      url: _ajaxLink + "?c=Message&m=smsLog&status=1",
      type: "POST",
      data: {
        data: successData
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          $('.c-message__sendBtn .button--orange#save').removeClass('disabled')
          $('.c-message__sendBtn .loading-img').hide()
          location.reload()
        }
      }
    })
  }
})
$('.c-message__sendBtn .button--orange#saveFormwork').click(function(){
  $('#popup__saveFormwork').addClass('is-active')
})
$('#popup__saveFormwork .f-confirm').click(function(){
  var importantVal
  var title = $("input[name='title']").val()
  var important = $('.c-message__important .c-checked')
  if(important.hasClass('is-active')){
    importantVal = '1'
  }else{
    importantVal = '0'
  }
  var content = $('#textarea--content').val()
  if(title == '' && content == ''){
    $('#popup__saveFormwork .result').attr('data-lang','string_prompt19')
    singleRender('string_prompt19')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=Message&m=saveMessageTemplate",
      type: "POST",
      data:{
        title: title,
        content: content
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          $('#popup__saveFormwork').removeClass('is-active')
        }
      }
    })
  }
})
$('#popup__saveFormwork .f-close').click(function(){
  $('#popup__saveFormwork .result').html('')
  $('#popup__saveFormwork .result').attr('data-lang','')
})
function getFormwork(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Message&m=getMessageTemplate&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          var datetime = getLocalTime(n.datetime)
          str += "<tr>";
          str += "<td data-name='title'>" + n.title + "</td><td data-name='content'>" + n.content + "</td><td data-name='time'>" + datetime + "</td><td><a data-id='"+ n.id +"' onclick='checkThisFormwork(this)'><i class='fa fa-check'></i></a><a class='f-delete' data-id='"+n.id+"' onclick='deleteThisFormwork(this)'><i class='fa fa-trash'></i></a></td>";
          str += "</tr>";
        })
        $(".c-message__formworkTable tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getFormwork',page);
      }else if (data.state == 1 && data.ret == ''){
        $(".c-message__formworkTable tbody").html(noResultStr)
        $("#popup__formwork table").css('table-layout','auto')
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}
function checkThisFormwork(obj){
  $('#popup__formwork').removeClass('is-active')
  var title = $(obj).parent().parent().find("td[data-name='title']").html()
  var content = $(obj).parent().parent().find("td[data-name='content']").html()
  $("input[name='title']").val(title)
  $('#textarea--content').val(content)
}
function deleteThisFormwork(obj){
  var id = $(obj).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=Message&m=removeMessageTemplate",
    type: "POST",
    data:{
      id: id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        getFormwork(page)
      }
    }
  })
}
//get message sent API
function getSent(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Message&m=smsLog&page="+ page + "&rpp=20&status=1",
    type: "GET",
    dataType: "json",
    async: false,
    contentType: "application/x-www-form-urlencoded; charset=utf-8",
    success: function(data){
      if (data.state == 1 && data.ret != '' && data.ret != null) {
        var str = "";
        $.each(data.ret, function (k, n) {
          var receiver, important, datetime, sender;
          var success = n.locations.success ? n.locations.success : ''
          var failed = n.locations.fail ? n.locations.fail : ''
          var sArr = []
          var fArr = []
          for (var i = 0; i < success.length; i++) {
            var a = success[i]
            if (tem_lang == 'zh') {
              sArr.push(a[0] + a[1] + a[2] + '栋' + a[3] + a[4] + '单元' + a[5] + a[6] + a[7] + a[8] + '室')
            }else if (tem_lang == 'en') {
              sArr.push('Room' + a[5] + a[6] + a[7] + a[8] + ' Blk' + a[3] + a[4] + ' Bld' + a[0] + a[1] + a[2])
            }else if (tem_lang == 'hk') {
              sArr.push(a[0] + a[1] + a[2] + '棟' + a[3] + a[4] + '單元' + a[5] + a[6] + a[7] + a[8] + '室')
            }
          }
          for (var i = 0; i < failed.length; i++) {
            var b = failed[i]
            if (tem_lang == 'zh') {
              fArr.push(b[0] + b[1] + b[2] + '栋' + b[3] + b[4] + '单元' + b[5] + b[6] + b[7] + b[8] + '室')
            }else if (tem_lang == 'en') {
              fArr.push('Room' + b[5] + b[6] + b[7] + b[8] + ' Blk' + b[3] + b[4] + ' Bld' + b[0] + b[1] + b[2])
            }else if (tem_lang == 'hk') {
              fArr.push(b[0] + b[1] + b[2] + '棟' + b[3] + b[4] + '單元' + b[5] + b[6] + b[7] + b[8] + '室')
            }
          }
          str += "<tr data-important='"+ n.important +"' data-sender='"+ n.sender +"'>";
          str += "<td name='title'>"+ n.title +"</td>";
          str += "<td name='content'>"+ n.content +"</td>";
          str += "<td name='datetime'>"+ getLocalTime(n.datetime) +"</td>";
          str += "<td name='receiver'>";
          if (success != '') {
            sArr = sArr.join(',')
            var sTitle = success.join(',')
            str += "<p data-title='"+ sTitle +"'>"+ sArr +"</p>"
          }
          if (failed != '') {
            fArr = fArr.join(',')
            var fTitle = failed.join(',')
            str += "<p data-title='"+ fTitle +"' style='color: red'>"+ fArr +"</p>"
          }
          str += "</td>"
          if (success != '' && failed != '') {
            str += "<td><p><a onclick='popthisInfo(this)'><i class='fa fa-info-circle'></i></a></p>"
            str += "<p><a data-id='"+ n.mid +"' class='resend' onclick='popthisInfo(this)'><i class='fa fa-info-circle'></i></a></p></td>"
          }else if (success != '' && failed == '') {
            str += "<td><p><a onclick='popthisInfo(this)'><i class='fa fa-info-circle'></i></a></p></td>"
          }else if (success == '' && failed != '') {
            str += "<td><p><a data-id='"+ n.mid +"' class='resend' onclick='popthisInfo(this)'><i class='fa fa-info-circle'></i></a></p></td>"
          }
          str += "</tr>";
        })
        $("#table_sent tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getSent',page);
      }else{
        $("#table_sent tbody").html(noResultStr)
        $('#message_sent .c-table__standard').css('table-layout','auto')
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
function popthisInfo(obj){
  if ($(obj).hasClass('resend')) {
    $('.f-resend').show()
    var id = $(obj).attr('data-id')
    $('.f-resend').attr('data-id', id)
  }else{
    $('.f-resend').hide()
  }
  $('#popup_receiver').attr('style', '')
  $('#popup__sendInfo').addClass('is-active')
  var index = $(obj).parent().index()
  var receiverH  = $(obj).parents('td').siblings("td[name='receiver']").find('p').eq(index).html()
  var receiverT  = $(obj).parents('td').siblings("td[name='receiver']").find('p').eq(index).attr('data-title')
  var receiverS  = $(obj).parents('td').siblings("td[name='receiver']").find('p').eq(index).attr('style')
  var title     = $(obj).parents('td').siblings("td[name='title']").html()
  var content   = $(obj).parents('td').siblings("td[name='content']").html()
  var datetime  = $(obj).parents('td').siblings("td[name='datetime']").html()
  var important = $(obj).parents('tr').attr('data-important')
  var sender    = $(obj).parents('tr').attr('data-sender')
  $('#popup_title').html(title)
  $('#popup_content').html(content)
  $('#popup_important').attr('data-val', important)
  important = important == '0' ? 'string_prompt21' : 'string_prompt20'
  $('#popup_important').attr('data-lang', important)
  $('#popup_sender').html(sender)
  $('#popup_sendTime').html(datetime)
  $('#popup_receiver').html(receiverH)
  $('#popup_receiver').attr('data-value', receiverT)
  $('#popup_receiver').attr('style', receiverS)
  singleRender(important)
}

$('.f-resend').click(function(){
  var mid = $(this).attr('data-id')
  var receiver = $('#popup_receiver').attr('data-value')
  receiver = receiver.split(',')
  var title = $('#popup_title').html()
  var content = $('#popup_content').html()
  var important = $('#popup_important').attr('data-val')
  var sender = $('#popup_sender').html()
  var resendData = {
    mid: mid,
    title: title,
    content: content,
    important: important,
    sender: sender,
    receiver: receiver,
  }
  $.ajax({
    url: _ajaxLink + "?c=Message&m=resendSMS",
    type: "POST",
    data: {
      data: resendData
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        // $('.c-message__sendBtn .button--orange#save').removeClass('disabled')
        // $('.c-message__sendBtn .loading-img').hide()
        location.reload()
      }
    }
  })
})

//*************************************online testing function*************************************//
function getOnlineDevices(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Online&m=getOnlineDevices&page="+ page +"&rpp=20",
    type: "POST",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          var typeCode, location;
          var building = ''
          var unit = ''
          var room = ''
          for (var i = 0; i < n.location.length; i++) {
            if (i <= 2) {
              building += n.location[i]
            }else if (i > 2 && i <= 4) {
              unit += n.location[i]
            }else if (i > 4) {
              room += n.location[i]
            }
          }
          var buildingName = building
          var unitName = unit
          var roomName = room
          var deviceNo = room
          if (tem_lang == 'zh') {
            building = building + '栋'
            unit = unit + '单元'
            room = room + '室'
            deviceNo = deviceNo + '号'
            if(n.typeCode == '01' || n.typeCode == '05'){
              location = building + unit + room
            }else if (n.typeCode == '02' || n.typeCode == '07') {
              location = building + unit + deviceNo
            }else if (n.typeCode == '03') {
              location = deviceNo
            }
          }else if (tem_lang == 'en') {
            building = ' Bld' + building
            unit = ' Blk' + unit
            room = ' Room' + room
            deviceNo = 'NO.' + deviceNo
            if(n.typeCode == '01' || n.typeCode == '05'){
              location = room + unit + building
            }else if (n.typeCode == '02' || n.typeCode == '07') {
              location = deviceNo + unit + building
            }else if (n.typeCode == '03') {
              location = deviceNo
            }
          }else if (tem_lang == 'hk') {
            building = building + '棟'
            unit = unit + '單元'
            room = room + '室'
            deviceNo = deviceNo + '號'
            if(n.typeCode == '01' || n.typeCode == '05'){
              location = building + unit + room
            }else if (n.typeCode == '02' || n.typeCode == '07') {
              location = building + unit + deviceNo
            }else if (n.typeCode == '03') {
              location = deviceNo
            }
          }
          str += "<tr data-id='"+ n.id +"' data-mac='"+ n.mac +"'>"
          str += "<td data-name='type' data-lang='string_typeCode"+ n.typeCode +"' data-id='"+ n.typeCode +"'></td>"
          str += "<td data-name='location' data-deviceNo = '"+ roomName +"' data-building = '"+ buildingName +"' data-unit = '"+ unitName +"' data-room = '"+ roomName +"'>"+ location +"</td>"
          str += "<td data-name='ip'>"+ n.ip +"</td>"
          if (n.status == 1 || n.status == 2) {
            str += "<td><img src='./assets/img/success.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
            str += "<td></td>"
          }else if (n.status == 3) {
            str += "<td><img src='./assets/img/error.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
            str += "<td></td>"
          //<a onclick='repairThisOnline(this)'><i class='fa fa-wrench'></i></a>
          }else if (n.status == 4) {
            str += "<td><img src='./assets/img/abnormal.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
            str += "<td></td>"
          }else if (n.status == 5 && n.typeCode != '05' ) {
            str += "<td><img src='./assets/img/success.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
            str += "<td><a onclick='addThisOnline(this)'><i class='fa fa-plus-circle'></i></a></td>"
          }else if (n.status == 5 && n.typeCode == '05' ) {
            str += "<td><img src='./assets/img/success.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
            str += "<td></td>"
          }
          str += "</tr>"
        })
        $('#table_online_testing tbody').html(str)
        getPagiation(data.total,$(".pagination"),'getOnlineDevices',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_online_testing tbody").html(noResultStr)
        $(".pagination").html('')
      }else if (data.state == 0) {
        $("#table_online_testing tbody").html(noResultStr)
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}

$('#popup__online .f-search').click(function(){
  var popupOnlineDate = []
  var checkBox = $('.c-online__checkTable a')
  checkBox.each(function(){
    if ($(this).hasClass('is-active')) {
      popupOnlineDate.push($(this).attr('data-type'))
    }
  })
  getSpecifiedDevices(1, popupOnlineDate)
})
function getSpecifiedDevices(i, arr){
  var page = i?i:page;
  if (arr == '') {
    getOnlineDevices(1)
    $('#popup__online').removeClass('is-active')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=Online&m=getOnlineDevices&page="+ page +"&rpp=20",
      type: "POST",
      data:{
        type: arr
      },
      dataType: "json",
      async: false,
      success: function(data){
        if (data.state == 1 && data.ret != '') {
          var str = "";
          $.each(data.ret, function (k, n) {
            var typeCode, location;
            var building = ''
            var unit = ''
            var room = ''
            for (var i = 0; i < n.location.length; i++) {
              if (i <= 2) {
                building += n.location[i]
              }else if (i > 2 && i <= 4) {
                unit += n.location[i]
              }else if (i > 4) {
                room += n.location[i]
              }
            }
            var buildingName = building
            var unitName = unit
            var roomName = room
            var deviceNo = room
            if (tem_lang == 'zh') {
              building = building + '栋'
              unit = unit + '单元'
              room = room + '室'
              deviceNo = deviceNo + '号'
              if(n.typeCode == '01' || n.typeCode == '05'){
                location = building + unit + room
              }else if (n.typeCode == '02' || n.typeCode == '07') {
                location = building + unit + deviceNo
              }else if (n.typeCode == '03') {
                location = deviceNo
              }
            }else if (tem_lang == 'en') {
              building = ' Bld' + building
              unit = ' Blk' + unit
              room = ' Room' + room
              deviceNo = 'NO.' + deviceNo
              if(n.typeCode == '01' || n.typeCode == '05'){
                location = room + unit + building
              }else if (n.typeCode == '02' || n.typeCode == '07') {
                location = deviceNo + unit + building
              }else if (n.typeCode == '03') {
                location = deviceNo
              }
            }else if (tem_lang == 'hk') {
              building = building + '棟'
              unit = unit + '單元'
              room = room + '室'
              deviceNo = deviceNo + '號'
              if(n.typeCode == '01' || n.typeCode == '05'){
                location = building + unit + room
              }else if (n.typeCode == '02' || n.typeCode == '07') {
                location = building + unit + deviceNo
              }else if (n.typeCode == '03') {
                location = deviceNo
              }
            }
            str += "<tr data-id='"+ n.id +"' data-mac='"+ n.mac +"'>"
            str += "<td data-name='type' data-lang='string_typeCode"+ n.typeCode +"' data-id='"+ n.typeCode +"'></td>"
            str += "<td data-name='location' data-deviceNo= '"+ roomName +"' data-building = '"+ buildingName +"' data-unit = '"+ unitName +"' data-room = '"+ roomName +"'>"+ location +"</td>"
            str += "<td data-name='ip'>"+ n.ip +"</td>"
            if (n.status == 1) {
              str += "<td><img src='./assets/img/success.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
              str += "<td></td>"
            }else if (n.status == 3) {
              str += "<td><img src='./assets/img/error.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
              str += "<td></td>"
              //<a onclick='repairThisOnline(this)'><i class='fa fa-wrench'></i></a>
            }else if (n.status == 4) {
              str += "<td><img src='./assets/img/abnormal.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
              str += "<td></td>"
            }else if (n.status == 5 && n.typeCode != '05' ) {
              str += "<td><img src='./assets/img/success.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
              str += "<td><a onclick='addThisOnline(this)'><i class='fa fa-plus-circle'></i></a></td>"
            }else if (n.status == 5 && n.typeCode == '05' ) {
              str += "<td><img src='./assets/img/success.png'><span data-lang='stringOnlineStatus"+ n.status +"'></td>"
              str += "<td></td>"
            }
            str += "</tr>"
          })
          $('#table_online_testing tbody').html(str)
          getPagiation(data.total,$(".pagination"),'getSpecifiedDevices',page);
        }else if (data.state == 1 && data.ret == ''){
          $("#table_online_testing tbody").html(noResultStr)
          $(".pagination").html('')
        }else if (data.state == 0) {
          $("#table_online_testing tbody").html(noResultStr)
          $(".pagination").html('')
        }
        $('#popup__online').removeClass('is-active')
        allLanguageRender()
      }
    })
  }
}

function addThisOnline(obj){
  var that = $(obj)
  $('#popup__add').addClass('is-active')
  $('#popup__add input').val('')
  $('#popup__add .result').attr('data-lang', '')
  $('#popup__add .result').html()
  var deviceNo = that.parent().parent().find("td[data-name='location']").attr('data-deviceNo')
  var location = that.parent().parent().find("td[data-name='location']").html()
  var building = that.parent().parent().find("td[data-name='location']").attr('data-building')
  var unit = that.parent().parent().find("td[data-name='location']").attr('data-unit')
  var room = that.parent().parent().find("td[data-name='location']").attr('data-room')
  var type = that.parent().parent().find("td[data-name='type']").attr('data-id')
  var ip = that.parent().parent().find("td[data-name='ip']").html()
  var mac = that.parent().parent().attr('data-mac')
  var deviceID = that.parent().parent().attr('data-id')
  $('#popup__add').attr('data-type', type)
  $('#popup__add #location_add').html(location)
  $('#popup__add #location_add').attr('data-building', building)
  $('#popup__add #location_add').attr('data-unit', unit)
  $('#popup__add #location_add').attr('data-room', room)
  $('#popup__add #location_add').attr('data-mac', mac)
  $('#popup__add #location_add').attr('data-deviceID', deviceID)
  $('#popup__add #number_add').html(deviceNo)
  $('#ipAddress__add').attr('data-ip', ip)
  $('#ipAddress__add').html(ip)
  if (type == '01') {
    $('#number_add').parent().hide()
  }else{
    $('#number_add').parent().show()
  }
  getDeviceTypeName(type)
}
// function repairThisOnline(obj){
//   var that = $(obj)
//   $('#popup__edit').addClass('is-active')
//   var deviceNo = that.parent().parent().find("td[data-name='location']").attr('data-deviceNo')
//   var location = that.parent().parent().find("td[data-name='location']").html()
//   var building = that.parent().parent().find("td[data-name='location']").attr('data-building')
//   var unit = that.parent().parent().find("td[data-name='location']").attr('data-unit')
//   var room = that.parent().parent().find("td[data-name='location']").attr('data-room')
//   var type = that.parent().parent().find("td[data-name='type']").attr('data-id')
//   var ip = that.parent().parent().find("td[data-name='ip']").html()
//   var ipArr = ip.split('.')
//   $('.online__editpopup .result').html('')
//   $('#popup__edit').attr('data-type', type)
//   $('#popup__edit #location_edit').html(location)
//   $('#popup__edit #location_edit').attr('data-building', building)
//   $('#popup__edit #location_edit').attr('data-unit', unit)
//   $('#popup__edit #location_edit').attr('data-room', room)
//   $('#popup__edit #number_edit').html(deviceNo)
//   $('#ipAddress__edit').attr('data-ip', ip)
//   $('#ipAddress__edit .c-input-small').each(function(i){
//     $(this).val(ipArr[i])
//   })
//   if (type == '01') {
//     $('#number_edit').parent().hide()
//   }else{
//     $('#number_edit').parent().show()
//   }
//   getDeviceTypeName(type)
// }

$('.online__addpopup .button--orange').click(function(){
  var building = $('#location_add').attr('data-building')
  var unit = $('#location_add').attr('data-unit')
  var room = $('#location_add').attr('data-room')
  var ip = $('#ipAddress__add').attr('data-ip')
  var mac = $('#location_add').attr('data-mac')
  var deviceID = $('#location_add').attr('data-deviceID')
  var remark = $('.online__addpopup').find("input[name='remark']").val()
  var deviceType = $('#modelNumber__add').val()
  var no = $('#number_add').html()
  var type = $('.online__addpopup').attr('data-type')
  $('.online__addpopup .result').html('')

  var data ={
    deviceID: deviceID,
    ip: ip,
    remark:remark,
    type: type,
    device_type: deviceType,
    mac: mac
  }

  $.ajax({
    url: _ajaxLink + "?c=Online&m=addNewDevices",
    type: "POST",
    data:data,
    dataType: "json",
    success: function(data){
      if(data.state==1){
        $('.c-popup').removeClass('is-active')
        $('#popup__online .f-search').click()
      }else if (data.state == 2) {
        $('#popup__add .result').attr('data-lang','string_noBuildingMessage')
        singleRender('string_noBuildingMessage')
      }
    }
  })
})

//*************************************intercom call function*************************************//
//indoor
function searchIntercomBlock(obj){
  var building_id = $(obj).attr('value')
  $(obj).siblings('a').removeClass('is-active')
  $(obj).addClass('is-active')
  $('#room--list .c-intercom__table--list').html('')
  getBlockList(building_id)
}
function searchIntercomRoom(obj){
  var building_id = $('#building--list .c-intercom__table--list a.is-active').attr('value')
  var unit_id = $(obj).attr('value')
  $(obj).siblings('a').removeClass('is-active')
  $(obj).addClass('is-active')
  getRoomList(building_id, unit_id)
}
function addIntercomRoom(obj){
  var building = $('#building--list .c-intercom__table--list a.is-active').find('p').html()
  var unit = $('#block--list .c-intercom__table--list a.is-active').find('p').html()
  var room = $(obj).find('p').html()
  $(obj).siblings('a').removeClass('is-active')
  $(obj).addClass('is-active')
  // building = addPreZero(parseInt(building), 3)
  // unit = addPreZero(parseInt(unit), 2)
  // room = addPreZero(parseInt(room), 4)
  var QString_sipAccount = '01' + building + unit + room + '00'
  new QWebChannel(qt.webChannelTransport, function(channel) {
    var interactObj = channel.objects.interactObject;
    interactObj.hqCallback_makeCall(QString_sipAccount, '');
  });
}
//guard
function searchIntercomGuardBlock(obj){
  var building_id = $(obj).attr('value')
  $(obj).siblings('a').removeClass('is-active')
  $(obj).addClass('is-active')
  $('#room--list .c-intercom__table--list').html('')
  getGuardBlockList(building_id)
}
function searchIntercomGuardNumber(obj){
  var building_id = $('#building--list .c-intercom__table--list a.is-active').attr('value')
  var unit_id = $(obj).attr('value')
  $(obj).siblings('a').removeClass('is-active')
  $(obj).addClass('is-active')
  getGuardNumberList(building_id, unit_id)
}
function addIntercomGuardRoom(obj){
  var building = $('#building--list .c-intercom__table--list a.is-active').find('p').html()
  var unit = $('#block--list .c-intercom__table--list a.is-active').find('p').html()
  var num = $(obj).find('p').html()
  $(obj).siblings('a').removeClass('is-active')
  $(obj).addClass('is-active')
  var QString_sipAccount = '07' + building + unit + num +'00'
  new QWebChannel(qt.webChannelTransport, function(channel) {
    var interactObj = channel.objects.interactObject;
    interactObj.hqCallback_makeCall(QString_sipAccount, '');
  });
}
//management server
function addIntercomCenterBlock(obj){
  var num = $(obj).attr('value')
  $(obj).siblings('a').removeClass('is-active')
  $(obj).addClass('is-active')
  var QString_sipAccount = num
  var QString_nickname = $(obj).find('p').html()
  new QWebChannel(qt.webChannelTransport, function(channel) {
    var interactObj = channel.objects.interactObject;
    interactObj.hqCallback_makeCall(QString_sipAccount, QString_nickname);
  });
}

//intercom Record
function getIntercomRecord(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Intercom&m=getList&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '' && data.ret != null) {
        var str = "";
        $.each(data.ret, function (k, n) {
          if (n.caller == '' || n.caller == null) {
            var caller = ''
          }else{
            var caller = splitDeviceIp(n.caller)
          }
          if (n.receiver == '' || n.receiver == null) {
            var receiver = ''
          }else{
            var receiver = splitDeviceIp(n.receiver)
          }
          if (n.caller_name != '' && n.caller[0] + n.caller[1] == '00') {
            caller = n.caller_name
          }
          if (n.receiver_name != '' && n.receiver[0] + n.receiver[1] == '00') {
            receiver = n.receiver_name
          }

          str += "<tr data-id='"+ n.intercomID +"'>";
          str += "<td data-value ='"+ n.caller +"'>"+ caller
          if (n.path != '') {
            str += "<a class='intercomPath' onclick='openPath(this)'><img data-value ='"+ n.path +"' src='./assets/img/btn_viewpic.png'></a></td>"
          }else{
            str += "</td>"
          }
          str += "<td data-value ='"+ n.receiver +"'>"+ receiver +"</td>"
          str += "<td>"+ n.datetime +"</td>"
          str += "<td>"+ n.duration +"</td>"
          if (n.state == '0') {
            str += "<td><img src='./assets/img/icon_record_callfailed.png'></td>"
          }else if(n.state == '1'){
            str += "<td><img src='./assets/img/icon_record_received.png'></td>"
          }else if(n.state == '2'){
            str += "<td><img src='./assets/img/icon_record_missed.png'></td>"
          }
          str += "</tr>";
        })
        $("#table_intercom tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getIntercomRecord',page);
      }else{
        $("#table_intercom tbody").html(noResultStr)
        $(".pagination").html('')
      }
      // $.ajax({
      //   url: _ajaxLink + "?c=BasicInfo&m=getManagementClients",
      //   type: "GET",
      //   dataType: "json",
      //   async: false,
      //   success: function(data){
      //     if (data.state == 1 && data.ret != '') {
      //       $.each(data.ret, function (k, n) {
      //         if (n.username != null) {
      //            $("#table_intercom td[data-value='"+ n.sipNo +"']").html(n.username)
      //         }
      //       })
      //     }
      //   }
      // })
      allLanguageRender()
    }
  })
}
//*************************************search function*************************************//
function getSearchBuilding(index, building_id, unit_id, room_id){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  var unitDefault = $('#select--block dt').attr('value');
  var roomDefault = $('#select--room dt').attr('value');
  building_id = building_id ? building_id : buildingDefault;
  unit_id = unit_id ? unit_id : unitDefault;
  room_id = room_id ? room_id : roomDefault;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getRoomsByUnitAndBuilding&page="+ page + "&rpp=20",
    type: "POST",
    data:{
      building_id: building_id,
      unit_id: unit_id,
      room_id: room_id
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          if (tem_lang == 'zh') {
            var position = n.building + '栋' + n.unit + '单元' + n.room + '室'
          }else if (tem_lang == 'en') {
            var position = 'Room' + n.room + ' Blk' + n.unit + ' Bld' + n.building
          }else if (tem_lang == 'hk') {
            var position = n.building + '棟' + n.unit + '單元' + n.room + '室'
          }
          str += "<tr>";
          str += "<td>" + position + "</td>";
          if(n.remark == null){
            n.remark = ''
          }
          str += "<td>" + n.remark + "</td>";
          str += "</tr>";
        })
        $("#table_search_building tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getSearchBuilding',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_search_building tbody").html(noResultStr)
        $(".pagination").html('')
        singleRender('string_noRecord')
      }
    }
  })
}
function getSearchUser(index, name, building_id, unit_id, room_id){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').attr('value');
  var unitDefault = $('#select--block dt').attr('value');
  var roomDefault = $('#select--room dt').attr('value');
  var nameDefault = $('#searchName').val()
  building_id = building_id ? building_id : buildingDefault;
  unit_id = unit_id ? unit_id : unitDefault;
  room_id = room_id ? room_id : roomDefault;
  name = name ? name : nameDefault;

  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getBaseOwnerInfoByName&page="+ page + "&rpp=20",
    type: "POST",
    data:{
      name: name,
      building_id: building_id,
      unit_id: unit_id,
      room_id: room_id
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          var avatar;
          var position;
          if (tem_lang == 'zh') {
            position = n.building + '栋' + n.unit + '单元' + n.room + '室';
          }else if (tem_lang == 'en') {
            position = 'Room' + n.room + ' Blk' + n.unit + ' Bld' + n.building;
          }else if (tem_lang == 'hk') {
            position = n.building + '棟' + n.unit + '單元' + n.room + '室';
          }
          if (n.avatar) {
            avatar = "<div class='c-search_avatar' style='background-image:url("+ n.avatar +")'></div>"
          }else{
            avatar = "<div class='c-search_avatar' style='background-image:url(./assets/img/default.png)'></div>"
          }
          str += "<tr>";
          str += "<td>"+ avatar + n.name + "</td>"
          str += "<td>"+ position +"</td>"
          str += "<td>"+ n.phone_primary +"</td>"
          str += "<td data-lang='string_receiverMsg"+ n.is_receive_msg +"'></td>"
          str += "</tr>";
        })
        $("#table_search_user tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getSearchUser',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_search_user tbody").html(noResultStr)
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}
function getSearchDevice(index, ip, building, unit, room){
  page = index ? index : page;
  var buildingDefault = $('#select--building dt').html()
  var unitDefault = $('#select--block dt').html()
  var roomDefault = $('#select--room dt').html()
  var ipInput = $('#searchIp input').val()
  buildingDefault = (buildingDefault != '--') ? buildingDefault : '0'
  unitDefault     = (unitDefault != '--')     ? unitDefault     : '0'
  roomDefault     = (roomDefault != '--')     ? roomDefault     : '0'
  building = building ? building : buildingDefault;
  unit = unit ? unit : unitDefault;
  room = room ? room : roomDefault;
  ip = ip ? ip : ipInput;

  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getAllDeviceInfo&page="+ page + "&rpp=20",
    type: "POST",
    data:{
      device_ip: ip,
      building: building,
      unit: unit,
      room: room
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          var position = '';
          if (tem_lang == 'zh') {
            if (n.building != '') {
              position += n.building + '栋'
            }
            if (n.unit != '') {
              position += n.unit + '单元'
            }
            if (n.room != '') {
              position += n.room + '室'
            }
          }else if (tem_lang == 'en') {
            if (n.room != '') {
              position = 'Room' + n.room
            }
            if (n.unit != '') {
              position = position + ' Blk' + n.unit
            }
            if (n.building != '') {
              position = position + ' Bld' + n.building
            }
          }else if (tem_lang == 'hk') {
            if (n.building != '') {
              position += n.building + '棟'
            }
            if (n.unit != '') {
              position += n.unit + '單元'
            }
            if (n.room != '') {
              position += n.room + '室'
            }
          }
          str += "<tr>";
          str += "<td data-lang='string_typeCode"+ n.deviceTypeNo +"'></td>"
          str += "<td>"+ position +"</td>"
          str += "<td>"+ n.device_ip +"</td>"
          if(n.remark == null){
            n.remark = ''
          }
          str += "<td>"+ n.remark +"</td>"
          str += "</tr>";
        })
        $("#table_search_device tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getSearchDevice',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_search_device tbody").html(noResultStr)
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}

//*************************************defense page function*************************************//
//get defense API
function getDefense(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Defense&m=getDefenseList&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr data-id='"+ n.defenseID +"'>";
          if (tem_lang == 'zh') {
            str += "<td>"+ n.building +"栋"+ n.unit +"单元"+ n.room +"室</td>"
          }else if (tem_lang == 'en') {
            str += "<td>Room"+ n.room +" Blk"+ n.unit +" Bld"+ n.building +"</td>"
          }else if (tem_lang == 'hk') {
            str += "<td>"+ n.building +"棟"+ n.unit +"單元"+ n.room +"室</td>"
          }
          if(n.eventType == '1' || n.eventType == '2'){
            str += "<td>"+ n.zoneID +"</td>"
          }else if(n.eventType == '3' || n.eventType == '4'){
            str += "<td data-lang='string_allZone'></td>"
          }else if (n.eventType == '5' || n.eventType == '6') {
            str += "<td></td>"
          }
          str += "<td data-lang='string_eventType"+ n.eventType +"'></td>"
          str += "<td data-lang='string_sensorType"+ n.sensorType +"'></td>"
          n.description = n.description == null ? '' : n.description
          str += "<td>"+ n.description +"</td>"
          str += "<td>"+ n.datetime +"</td>"
          str += "</tr>";
        })
        $("#defense_record tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getDefense',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#defense_record tbody").html(noResultStr)
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}
//get alarm API
function getAlarm(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Defense&m=getDefenseAlarmList&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr data-id='"+ n.defenseAlarmID +"'>";
          if (tem_lang == 'zh') {
            str += "<td>"+ n.building +"栋"+ n.unit +"单元"+ n.room +"室</td>"
          }else if (tem_lang == 'en') {
            str += "<td>Room"+ n.room +" Blk"+ n.unit +" Bld"+ n.building +"</td>"
          }else if (tem_lang == 'hk') {
            str += "<td>"+ n.building +"棟"+ n.unit +"單元"+ n.room +"室</td>"
          }

          if (n.eventType == '6') {
            str += "<td></td>"
            str += "<td data-lang='string_alarmType"+ n.alarmType +"'></td>"
            str += "<td>"+ n.datetime +"</td>"
            n.description = n.description === null ? '' : n.description
            str += "<td>"+ n.description +"</td>"
            if(n.dealUser != '' && n.dealTime != ''){
              str += "<td class='clearfix'><p style='display:inline-block'>"+ n.dealUser +"</p>"
              str += "<a class='fr' onclick='openalarmPopup(this)' data-dealUser='"+ n.dealUser +"' data-dealTime='"+ n.dealTime +"' data-remark='"+ n.remark +"'>"
              str += "<i class='fa fa-list-alt'></i></a></td>"
            }else{
              str += "<td></td>"
            }
            str += "</tr>";
          }else if (n.eventType == '5') {
            str += "<td>"+ n.zoneID +"</td>"
            // if (n.alarmType == 21) {
            //   str += "<td data-lang='string_sensorType9'></td>"
            // }else{
            //   str += "<td data-lang='string_sensorType"+ n.sensorType +"'></td>"
            // }
            if (n.zoneType == '4') {
              str += "<td><span data-lang='string_sensorType"+ n.sensorType +"'></span><span data-lang='string_logic'></span></td>"
            }else{
              str += "<td data-lang='string_sensorType"+ n.sensorType +"'></td>"
            }

            str += "<td>"+ n.datetime +"</td>"
            n.description = n.description === null ? '' : n.description
            str += "<td>"+ n.description +"</td>"
            if(n.dealUser != '' && n.dealTime != ''){
              str += "<td class='clearfix'><p style='display:inline-block'>"+ n.dealUser +"</p>"
              str += "<a class='fr' onclick='openalarmPopup(this)' data-dealUser='"+ n.dealUser +"' data-dealTime='"+ n.dealTime +"' data-remark='"+ n.remark +"'>"
              str += "<i class='fa fa-list-alt'></i></a></td>"
            }else{
              str += "<td></td>"
            }
            str += "</tr>";
          }
        })
        $("#alarm_record tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getAlarm',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#alarm_record tbody").html(noResultStr)
        $(".pagination").html('')
      }
      allLanguageRender()
    }
  })
}
function openalarmPopup(obj){
  var that = $(obj)
  var dealUser = that.attr('data-dealUser')
  var dealTime = that.attr('data-dealTime')
  var remark = that.attr('data-remark')
  $('#popup__dealInfo .deal_user').html(dealUser)
  $('#popup__dealInfo .deal_time').html(dealTime)
  $('#popup__dealInfo .deal_remark').html(remark)
  $('#popup__dealInfo').addClass('is-active')
}
//*************************************User Management page function*************************************//
//get User Management API
function getUserManagement(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=User&m=getUserList&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          if (n.username == 'admin') {
            str += "<tr>"
            str += "<td data-name='username' data-val='"+ n.username + "'>" + n.username + "</td>"
            str += "<td data-name='position' data-lang='string_superadmin'></td>"
            str += "<td data-name='remark' data-val='"+ n.remark+ "'>"+ n.remark +"</td>"
            str += "<td><a class='f-edit noRole' data-id='"+ n.user_id +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a></td>"
            str += "</tr>"
          }else{
            str += "<tr>"
            str += "<td data-name='username' data-val='"+ n.username + "'>" + n.username + "</td>"
            str += "<td data-name='position' data-val='"+ n.roleName + "' data-id='"+ n.roleID +"'>" + n.roleName + "</td>"
            str += "<td data-name='remark' data-val='"+ n.remark+ "'>"+ n.remark +"</td>"
            str += "<td><a class='f-edit' data-id='"+ n.user_id +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a>"
            str += "<a class='f-delete' data-id='"+n.user_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>"
            str += "</tr>"
          }
        })
        $("#table_management tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getUserManagement',page);
        allLanguageRender()
      }else if (data.state == 1 && data.ret == ''){
        $("#table_management tbody").html(noResultStr)
        $(".pagination").html('')
        allLanguageRender()
      }
    }
  })
}
//add User Management API
$('#user_management #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var usernameVal = $('#popup__add').find('input[name="username"]')
  var passwordVal = $('#popup__add').find('input[name="pwd"]')
  var cPasswordVal = $('#popup__add').find('input[name="confirmPwd"]')
  var remarkVal = $('#popup__add').find('input[name="remark"]')
  var role_id = $('#select--position__add dt').attr('value')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if ($.trim(usernameVal.val()) == '') {
    usernameVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_userPromot1')
    singleRender('string_userPromot1')
  }else if (passwordVal.val() == '') {
    passwordVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_userPromot2')
    singleRender('string_userPromot2')
  }else if (passwordVal.val() != cPasswordVal.val()) {
    cPasswordVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_userPromot3')
    singleRender('string_userPromot3')
  }else if(role_id == ''){
    result.attr('data-lang','string_userPromot9')
    singleRender('string_userPromot9')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=User&m=add",
      type: "POST",
      data:{
        roleID: role_id,
        username: $.trim(usernameVal.val()),
        password: passwordVal.val(),
        remark: remarkVal.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if(data.state == 2){
          result.attr('data-lang','string_userPromot6')
          usernameVal.css('border-color','rgb(255, 152, 0)')
          singleRender('string_userPromot6')
        }else if(data.state == 3){
          result.attr('data-lang','string_userPromot10')
          usernameVal.css('border-color','rgb(255, 152, 0)')
          singleRender('string_userPromot10')
        }else if(data.state == 4){
          result.attr('data-lang','string_userPromot11')
          usernameVal.css('border-color','rgb(255, 152, 0)')
          singleRender('string_userPromot11')
        }
      }
    })
  }
})
//edit User Management API
$('#user_management #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var passwordVal = $('#popup__edit').find('input[name="pwd"]')
  var cPasswordVal = $('#popup__edit').find('input[name="confirmPwd"]')
  var remarkVal = $('#popup__edit').find('input[name="remark"]')
  var role_id = $('#select--position__edit').attr('value')
  var user_id = $(this).attr('data-id')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (passwordVal.val() != '' && (passwordVal.val() != cPasswordVal.val())) {
    cPasswordVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_userPromot3')
    singleRender('string_userPromot3')
  }else if(role_id == ''){
    result.attr('data-lang','string_userPromot9')
    singleRender('string_userPromot9')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=User&m=edit",
      type: "POST",
      data:{
        //roleID: role_id,
        user_id: user_id,
        password: passwordVal.val(),
        remark: remarkVal.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }
      }
    })
  }
})
//remove User Management API
$('#user_management #popup__delete .button--red').click(function(){
  var user_id = $(this).attr('data-id')
  var username = $(".f-delete[data-id='"+ user_id +"']").parent().siblings("td[data-name='username']").attr('data-val')
  if (getCookie('username') == username) {
    $('#popup__delete .result').attr('data-lang', 'string_userPromot5')
    singleRender('string_userPromot5')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=User&m=delete",
      type: "POST",
      data:{
        user_id: user_id
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }
      }
    })
  }
})

//*************************************User Position page function*************************************//
//get User Position API
function getUserPosition(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Role&m=getRoleList&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr>"
          str += "<td data-name='position' data-val='"+ n.roleName + "'>" + n.roleName + "</td>"
          str += "<td data-name='remark' data-val='"+ n.remark+ "'>"+ n.remark +"</td>"
          str += "<td><a class='f-edit' data-id='"+ n.roleID +"' onclick='editThis(this)'><i class='fa fa-pencil'></i></a>"
          str += "<a class='f-delete' data-id='"+n.roleID+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td>"
          str += "</tr>"
        })
        $("#table_poisition tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getUserPosition',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_poisition tbody").html(noResultStr)
        $(".pagination").html('')
        singleRender('string_noRecord')
      }
    }
  })
}
//add User Position API
$('#user_position #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var roleVal = $('#popup__add').find('input[name="position"]')
  var remarkVal = $('#popup__add').find('input[name="remark"]')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if ($.trim(roleVal.val()) == '') {
    roleVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_userPromot7')
    singleRender('string_userPromot7')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=Role&m=add",
      type: "POST",
      data:{
        roleName: roleVal.val(),
        remark: remarkVal.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if(data.state == 2){
          result.attr('data-lang','string_userPromot8')
          roleVal.css('border-color','rgb(255, 152, 0)')
          singleRender('string_userPromot8')
        }
      }
    })
  }
})
//edit User Position API
$('#user_position #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var roleVal = $('#popup__edit').find('input[name="position"]')
  var remarkVal = $('#popup__edit').find('input[name="remark"]')
  var rold_id = $(this).attr('data-id')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if ($.trim(roleVal.val()) == '') {
    roleVal.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_userPromot7')
    singleRender('string_userPromot7')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=Role&m=edit",
      type: "POST",
      data:{
        roleName: $.trim(roleVal.val()),
        roleID: rold_id,
        remark: remarkVal.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if(data.state == 2){
          result.attr('data-lang','string_userPromot8')
          roleVal.css('border-color','rgb(255, 152, 0)')
          singleRender('string_userPromot8')
        }
      }
    })
  }
})
//remove User Position API
$('#user_position #popup__delete .button--red').click(function(){
  var roleID = $(this).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=Role&m=delete",
    type: "POST",
    data:{
      roleID: roleID
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        location.reload();
      }else if (data.state == 2) {
        $('#popup__delete .result').attr('data-lang', 'string_deleteRole')
        singleRender('string_deleteRole')
      }
    }
  })
})

//*************************************setting calendar pagination*************************************//
function checkNewDay(){
  eventMoreList()
  findTag()
}
function findTag(){
  var date = $('.schedule-hd .today').html()
  $(".schedule-bd span").removeClass('orangeTag')
  dateArr = date.split('-')
  month = dateArr[0] +'-'+ dateArr[1]
  $.ajax({
    url: _ajaxLink + "?c=Message&m=getEventDayByMonth&month="+ month,
    type: "GET",
    dataType: "json",
    success: function(data){
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          day = n
          $("span[title="+ day +"]").addClass('orangeTag')
        })
      }
    }
  })
}
function eventMoreList(){
  var date = $('.schedule-hd .today').html()
  $.ajax({
    url: _ajaxLink + "?c=Message&m=getEvents&date="+ date,
    type: "GET",
    dataType: "json",
    success: function(data){
      if(data.state==1 && data.ret != ''){
        $.each(data.ret, function (k, n) {
          $('.c-calendar__eventBox textarea').eq(k).val(n.title)
        })
      }
    }
  })
}
$('.c-calendar__content--right .button--orange').click(function(){
  var datetime = $('#settingCalendar .today').html()
  var content = []
  $('.c-calendar__eventBox textarea').each(function(){
    var value = $(this).val()
    content.push(value)
  })
  content = content.reverse()
  $.ajax({
    url: _ajaxLink + "?c=Message&m=addEvent",
    type: "POST",
    dataType: "json",
    data:{
      title: content,
      datetime: datetime
    },
    success: function(data){
      if (data.state == 1) {
        $('#popup__tips').addClass('is-active')
        $('.c-calendar__tips h2').attr('data-lang','string_calendarSuccess')
        singleRender('string_calendarSuccess')
        findTag()
      }else{
        $('#popup__tips').addClass('is-active')
        $('.c-calendar__tips h2').attr('data-lang','string_calendarError')
        singleRender('string_calendarError')
      }
    }
  })
})

//*************************************get alarm*************************************//
var alarmData = ''
function getAlarmList(){
  $.ajax({
    url: _ajaxLink + "?c=Defense&m=getAlarmListByNoFinish",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        alarmData = data.ret
        $(".c-mapShow > div").removeClass('is-active')
        $.each(data.ret, function (k, n) {
          $(".c-mapShow > div[data-value='"+ n.building +"']").addClass('is-active')
        })
        new QWebChannel(qt.webChannelTransport, function(channel) {
          var interactObj = channel.objects.interactObject;
          var num = parseInt(data.total)
          interactObj.hqHomePage_alarmNum(num);
        });
      }else if (data.state == 1 && data.ret == '') {
        $(".c-mapShow > div").removeClass('is-active')
        new QWebChannel(qt.webChannelTransport, function(channel) {
          var interactObj = channel.objects.interactObject;
          var num = 0
          interactObj.hqHomePage_alarmNum(num);
        });
      }
    }
  })
}
function openThisAlarm(obj){
  var that = $(obj)
  var building = that.attr('data-value')
  if (that.hasClass('is-active') && alarmData != '') {
    $('#alarmLocation').html("")
    $('#alarmType').attr("data-lang","")
    $('#alarmDatetime').html("")
    $('#popup__alarm .alarmRemark input').val('')
    for (var i = 0; i < alarmData.length; i++) {
      if (alarmData[i].building == building) {
        var n = alarmData[i]
        var id = n.defenseAlarmID
        $.ajax({
          url: _ajaxLink + "?c=Defense&m=getAlarmDetailByID",
          type: "POST",
          dataType: "json",
          data:{
            defenseAlarmID: id
          },
          success: function(data){
            if (data.state == 1) {
              var ret = data.ret
              var location, building, unit, room;
              if (tem_lang == 'zh') {
                if (ret.building != '') {
                  building = ret.building + '栋'
                }
                if (ret.unit != '') {
                  unit = ret.unit + '单元'
                }
                if (ret.room != '') {
                  room = ret.room + '室'
                }
                location = building + unit + room
              }else if (tem_lang == 'en') {
                if (ret.building != '') {
                  building = ' Bld' + ret.building
                }
                if (ret.unit != '') {
                  unit = ' Blk' + ret.unit
                }
                if (ret.room != '') {
                  room = 'Room' + ret.room
                }
                location = room + unit + building
              }else if (tem_lang == 'hk') {
                if (ret.building != '') {
                  building = ret.building + '棟'
                }
                if (ret.unit != '') {
                  unit = ret.unit + '單元'
                }
                if (ret.room != '') {
                  room = ret.room + '室'
                }
                location = building + unit + room
              }
              $('.alarmLocation').html(location)

              if (ret.eventType == '6') {
                $('.alarmType').attr("data-lang","string_alarmType" + ret.alarmType)
              }else if (ret.eventType == '5') {
                $('.alarmType').attr("data-lang","string_sensorType" + ret.sensorType)
                singleRender("string_sensorType" + ret.sensorType)
                if (ret.zoneType == '4') {
                  $('.alarmType').append("<span data-lang='string_logic'></span>")
                  $('.alarmType').attr('data-lang', '')
                }
              }
              $('.alarmDatetime').html(ret.datetime)
              if (ret.isFinished == '0') {
                $('#f-deal, #f-ignore').attr('data-id', ret.defenseAlarmID)
                $('#f-callback').attr('data-id', ret.building + ret.unit + ret.room)
                allLanguageRender()
                $('#popup__alarm').addClass('is-active')
              }else if (ret.isFinished == '1') {
                $('.alarmDealState').attr('data-lang','string_alarm10')
                $('.alarmDealTime').html(ret.dealTime)
                $('.alarmDealUser').html(ret.dealUser)
                $('#popup__alarm--finish .alarmRemark').html(ret.remark)
                allLanguageRender()
                $('#popup__alarm--finish').addClass('is-active')
              }
            }
          }
        })
        return false
      }
    }
  }
}
$('#f-deal').click(function(){
  $('.result').html('')
  $('.result').attr('data-lang','')
  $('#popup__alarm .alarmRemark input').css('border-color','#ccc')
  var dealUser = getCookie('c_username')
  var id = $(this).attr('data-id')
  var remark = $('#popup__alarm .alarmRemark input').val()
  if (remark.length == 0) {
    $('#popup__alarm .alarmRemark input').css('border-color','#ff9800')
    $('.result').attr('data-lang','string_inputContent')
    allLanguageRender()
  }else{
    $.ajax({
      url: _ajaxLink + "?c=Defense&m=solveAlarm",
      type: "POST",
      data:{
        defenseAlarmID: id,
        remark: remark,
        dealUser: dealUser
      },
      dataType: "json",
      async: false,
      success: function(data){
        if (data.state == 1 && data.ret != '') {
          $('#popup__alarm').removeClass('is-active')
          getAlarmList()
        }else if (data.state == 2) {
          var n = data.result[0]
          $('#popup__alarm').removeClass('is-active')
          $('.alarmDealState').attr('data-lang','string_alarm10')
          $('.alarmDealTime').html(n.dealTime)
          $('.alarmDealUser').html(n.dealUser)
          $('#popup__alarm--finish .alarmRemark').html(n.remark)
          allLanguageRender()
          $('#popup__alarm--finish').addClass('is-active')
        }
      }
    })
  }
})
$('#f-ignore').click(function(){
  $('.result').html('')
  $('.result').attr('data-lang','')
  $('#popup__alarm .alarmRemark input').css('border-color','#ccc')
  var dealUser = getCookie('c_username')
  var id = $(this).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=Defense&m=solveAlarm",
    type: "POST",
    data:{
      defenseAlarmID: id,
      remark: '',
      dealUser: dealUser
    },
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        $('#popup__alarm').removeClass('is-active')
        getAlarmList()
      }else if (data.state == 2) {
        var n = data.result[0]
        $('#popup__alarm').removeClass('is-active')
        $('.alarmDealState').attr('data-lang','string_alarm10')
        $('.alarmDealTime').html(n.dealTime)
        $('.alarmDealUser').html(n.dealUser)
        $('#popup__alarm--finish .alarmRemark').html(n.remark)
        allLanguageRender()
        $('#popup__alarm--finish').addClass('is-active')
      }
    }
  })
})
$('#f-callback').click(function(){
  var address = $(this).attr('data-id')
  var QString_sipAccount = '01' + address + '00'
  new QWebChannel(qt.webChannelTransport, function(channel) {
    var interactObj = channel.objects.interactObject;
    interactObj.hqCallback_makeCall(QString_sipAccount,'');
  });
})
$('#popup__alarm .f-close, #popup__alarm--finish .f-close').click(function(){
  getAlarmList()
})

function hqHomePage_alarmSolve(){
  if (alarmData != '') {
    $('#alarmLocation').html("")
    $('#alarmType').attr("data-lang","")
    $('#alarmDatetime').html("")
    $('#popup__alarm .alarmRemark input').val('')
    var n = alarmData[0]
    var id = n.defenseAlarmID
    $.ajax({
      url: _ajaxLink + "?c=Defense&m=getAlarmDetailByID",
      type: "POST",
      dataType: "json",
      data:{
        defenseAlarmID: id
      },
      success: function(data){
        if (data.state == 1) {
          var ret = data.ret
          var location, building, unit, room;
          if (tem_lang == 'zh') {
            if (ret.building != '') {
              building = ret.building + '栋'
            }
            if (ret.unit != '') {
              unit = ret.unit + '单元'
            }
            if (ret.room != '') {
              room = ret.room + '室'
            }
            location = building + unit + room
          }else if (tem_lang == 'en') {
            if (ret.building != '') {
              building = ' Bld' + ret.building
            }
            if (ret.unit != '') {
              unit = ' Blk' + ret.unit
            }
            if (ret.room != '') {
              room = 'Room' + ret.room
            }
            location = room + unit + building
          }else if (tem_lang == 'hk') {
            if (ret.building != '') {
              building = ret.building + '棟'
            }
            if (ret.unit != '') {
              unit = ret.unit + '單元'
            }
            if (ret.room != '') {
              room = ret.room + '室'
            }
            location = building + unit + room
          }

          $('.alarmLocation').html(location)
          if (ret.eventType == '6') {
            $('.alarmType').attr("data-lang","string_alarmType" + ret.alarmType)
          }else if (ret.eventType == '5') {
            $('.alarmType').attr("data-lang","string_sensorType" + ret.sensorType)
            singleRender("string_sensorType" + ret.sensorType)
            if (ret.zoneType == '4') {
              $('.alarmType').append("<span data-lang='string_logic'></span>")
              $('.alarmType').attr('data-lang', '')
            }
          }
          $('.alarmDatetime').html(ret.datetime)
          if (ret.isFinished == '0') {
            $('#f-deal, #f-ignore').attr('data-id', ret.defenseAlarmID)
            $('#f-callback').attr('data-id', ret.building + ret.unit + ret.room)
            allLanguageRender()
            $('#popup__alarm').addClass('is-active')
          }else if (ret.isFinished == '1') {
            $('.alarmDealState').attr('data-lang','string_alarm10')
            $('.alarmDealTime').html(ret.dealTime)
            $('.alarmDealUser').html(ret.dealUser)
            $('#popup__alarm--finish .alarmRemark').html(ret.remark)
            allLanguageRender()
            $('#popup__alarm--finish').addClass('is-active')
          }
        }
      }
    })
  }
}

//*************************************device type function*************************************//
//get device
function getdeviceType(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getDeviceTypeList",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        $.each(data.ret, function (k, n) {
          var device
          switch (n.device_type) {
            case '01':
              device = $('#device_indoor')
              break;
            case '02':
              device = $('#device_outdoor')
              break;
            case '03':
              device = $('#device_fence')
              break;
            case '07':
              device = $('#device_guard')
              break;
          }
          var strName   = "<p data-id='"+ n.device_type_id +"'>"+ n.device_type_name +"</p>"
          if (n.remark == null) {
            n.remark = ''
          }
          var strRemark = "<p data-id='"+ n.device_type_id +"'>"+ n.remark +"</p>"
          var strOperate = "<p><a class='f-edit' data-id='"+ n.device_type_id +"' onclick='editThisDevice(this)'><i class='fa fa-pencil'></i></a>"
          strOperate += "<a class='f-delete' data-id='"+n.device_type_id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></p>"
          device.find('td.deviceName').append(strName)
          device.find('td.deviceRemark').append(strRemark)
          // device.find('td.deviceOperate').append(strOperate)
        })
      }
    }
  })
}
//get device list
function getDeviceTypeName(type){
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getDeviceTypeList",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = '';
        $.each(data.ret, function (k, n) {
          if (n.device_type == type) {
            str += "<option value='"+ n.device_type_name +"'>"+ n.device_type_name +"</option>"
          }
        })
        $('#modelNumber__edit, #modelNumber__add').html(str)
      }
    }
  })
}

//add device
$('#device_management #popup__add .button--orange').click(function(){
  var input = $('#popup__add').find('input')
  var result = $('#popup__add').find('.result')
  var deviceType = $('#popup__add').find('.c-select')
  var modelName = $('#popup__add').find('input[name="modelName"]')
  var remark = $('#popup__add').find('input[name="remark"]')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (modelName.val() == '') {
    modelName.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt22')
    singleRender('string_prompt22')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=addDeviceType",
      type: "POST",
      data:{
        device_type: deviceType.val(),
        device_type_name: modelName.val(),
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if(data.state == 2){
          result.attr('data-lang','string_prompt23')
          singleRender('string_prompt23')
        }
      }
    })
  }
})
//edit device API
$('#device_management #popup__edit .button--orange').click(function(){
  var input = $('#popup__edit').find('input')
  var result = $('#popup__edit').find('.result')
  var modelName = $('#popup__edit').find('input[name="modelName"]')
  var remark = $('#popup__edit').find('input[name="remark"]')
  var device_id = $(this).attr('data-id')
  input.css('border-color','#ccc')
  result.html('')
  result.attr('data-lang','')

  if (modelName.val() == '') {
    modelName.css('border-color','rgb(255, 152, 0)')
    result.attr('data-lang','string_prompt22')
    singleRender('string_prompt22')
  }else{
    $.ajax({
      url: _ajaxLink + "?c=BasicInfo&m=editDeviceType",
      type: "POST",
      data:{
        device_type_id: device_id,
        device_type_name: modelName.val(),
        remark: remark.val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }else if(data.state == 2){
          result.attr('data-lang','string_prompt23')
          singleRender('string_prompt23')
        }
      }
    })
  }
})
//remove device API
$('#device_management #popup__delete .button--red').click(function(){
  var device_id = $(this).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=removeDeviceType",
    type: "POST",
    data:{
      device_type_id: device_id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        location.reload();
      }
    }
  })
})

//*************************************sip group function*************************************//
function getSipGroup(){
  $.ajax({
    url: _ajaxLink + "?c=Sip&m=getSipGroup&groupType=custom",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr data-id='"+ n.id +"'>";
          str += "<td data-name='name' data-val='"+ n.remark+ "'>" + n.remark + "</td>"
          var members = n.members.replace("[", "").replace("]", "").replace(/"/g,'')
          str += "<td data-name='members' data-val='"+ members + "'>" + members + "</td>"
          str += "<td><a class='f-edit' data-id='"+ n.id +"' onclick='editThisSip(this)'><i class='fa fa-pencil'></i></a>"
          str += "<a class='f-delete' data-id='"+n.id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td></tr>";
        })
        $("#table_group tbody").html(str)
      }else if (data.state == 1 && data.ret == ''){
        $("#table_group tbody").html(noResultStr)
      }
      allLanguageRender()
    }
  })
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getGuardAndUserSipList",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        $.each(data.ret, function (k, n) {
          if (n.username == '') {
            var deviceLo = ''
            if (tem_lang == 'zh') {
              n.building += '栋'
              n.unit += '单元'
              n.deviceNo += '号'
              deviceLo = '(卫) ' + n.building + n.unit + n.deviceNo
            }else if (tem_lang == 'en') {
              n.building = ' Bld' + n.building
              n.unit = ' Blk' + n.unit
              n.deviceNo = 'NO.' + n.deviceNo
              deviceLo = '(Guard) ' + n.deviceNo + n.unit + n.building
            }else if (tem_lang == 'hk') {
              n.building += '棟'
              n.unit += '單元'
              n.deviceNo += '號'
              deviceLo = '(衛) ' + n.building + n.unit + n.deviceNo
            }
            var oldMember = $("#table_group td[data-name='members']")
            for (var i = 0; i < oldMember.length; i++) {
              oldMember.eq(i).html(oldMember.eq(i).html().replace(n.sipNo, ' ' + deviceLo))
            }
          }else{
            if (tem_lang == 'zh') {
              var userText = '(用户) ' + n.username
            }else if (tem_lang == 'en') {
              var userText = '(User) ' + n.username
            }else if (tem_lang == 'hk') {
              var userText = '(用戶) ' + n.username
            }
            var oldMember = $("#table_group td[data-name='members']")
            for (var i = 0; i < oldMember.length; i++) {
              oldMember.eq(i).html(oldMember.eq(i).html().replace(n.sipNo, ' ' + userText))
            }
          }
        })
      }
    }
  })
  $("#table_group td[data-name='members']").on('mouseover', function(){
    if ($(this).html() != '') {
      var left = $(this).offset().left + $(this).width()/2 - 100
      var top = $(this).offset().top + $(this).height()
      var str = "<p class='sipHover' style='left:"+ left +"px; top:"+ top +"px;'>"+ $(this).html() +"</p>"
      $('body').append(str)
    }
  })
  $("#table_group td[data-name='members']").on('mouseout', function(){
    $('.sipHover').remove()
  })
}
//add sip group
$('#sip_group #popup__add .button--orange').click(function(){
  if ($(this).hasClass('disabled')) {
    return false
  }else{
    var input = $('#popup__add').find('input')
    var result = $('#popup__add').find('.result')
    var remarkVal = $('#popup__add').find('input[name="remark"]')
    input.css('border-color','#ccc')
    result.html('')
    result.attr('data-lang','')

    if ($.trim(remarkVal.val()) == '') {
      remarkVal.css('border-color','rgb(255, 152, 0)')
      result.attr('data-lang','string_groupNamePrompt1')
    }else{
      var members = []
      var membersObj = $('#popup__add .c-sip__list--right--list p')
      membersObj.each(function(){
        var sipNo = '"' + $(this).attr('data-value') + '"'
        members.push(sipNo)
      })
      var members = '[' + members.join(',') + ']'
      $.ajax({
        url: _ajaxLink + "?c=Sip&m=addSipGroup",
        type: "POST",
        data:{
          members: members,
          remark: remarkVal.val()
        },
        dataType: "text",
        async: false,
        success: function(data){
          data = eval('(' + data + ')');
          if(data.state == 1){
            location.reload();
          }else if(data.state == 2){
            result.attr('data-lang','string_groupNamePrompt2')
            remarkVal.css('border-color','rgb(255, 152, 0)')
          }
        }
      })
    }
    allLanguageRender()
  }
})
//edit sip group
$('#sip_group #popup__edit .button--orange').click(function(){
  if ($(this).hasClass('disabled')) {
    return false
  }else{
    var id = $(this).attr('data-id')
    var input = $('#popup__edit').find('input')
    var result = $('#popup__edit').find('.result')
    var remarkVal = $('#popup__edit').find('input[name="remark"]')
    input.css('border-color','#ccc')
    result.html('')
    result.attr('data-lang','')

    if ($.trim(remarkVal.val()) == '') {
      remarkVal.css('border-color','rgb(255, 152, 0)')
      result.attr('data-lang','string_groupNamePrompt1')
    }else{
      var members = []
      var membersObj = $('#popup__edit .c-sip__list--right--list p')
      membersObj.each(function(){
        var sipNo = '"' + $(this).attr('data-value') + '"'
        members.push(sipNo)
      })
      members = '[' + members.join(',') + ']'
      $.ajax({
        url: _ajaxLink + "?c=Sip&m=editSipGroup",
        type: "POST",
        data:{
          id : id,
          members: members,
          remark: remarkVal.val()
        },
        dataType: "json",
        async: false,
        success: function(data){
          if(data.state==1){
            location.reload();
          }else if(data.state == 2){
            result.attr('data-lang','string_groupNamePrompt2')
            remarkVal.css('border-color','rgb(255, 152, 0)')
          }
        }
      })
    }
    allLanguageRender()
  }
})
//remove sip group
$('#sip_group #popup__delete .button--red').click(function(){
  var id = $(this).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=Sip&m=deleteSipGroup",
    type: "POST",
    data:{
      sipGroupId: id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        location.reload();
      }
    }
  })
})

//*************************************sip transfer function*************************************//
//get sip transfer
function getSipTransfer(i){
  page = i?i:page;
  $.ajax({
    url: _ajaxLink + "?c=Sip&m=getTransferList&page="+ page + "&rpp=20",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          str += "<tr data-id='"+ n.id +"'>";
          if (n.username != '') {
            str += "<td data-name='name' data-val='"+ n.name+ "'>" + n.username + "</td>"
          }else{
            str += "<td data-name='name' data-val='"+ n.name+ "'>" + n.name + "</td>"
          }
          str += "<td data-name='transfer' data-val='"+ n.transfer+ "'>" + n.transfer + "</td>"
          str += "<td data-name='remark' data-val='"+ n.remark+ "'>" + n.remark + "</td>"
          str += "<td><a class='f-edit' data-id='"+ n.id +"' onclick='editThisTransfer(this)'><i class='fa fa-pencil'></i></a>"
          str += "<a class='f-delete' data-id='"+n.id+"' onclick='deleteThis(this)'><i class='fa fa-trash'></i></a></td></tr>"
        })
        $("#table_transfer tbody").html(str)
        getPagiation(data.total,$(".pagination"),'getSipTransfer',page);
      }else if (data.state == 1 && data.ret == ''){
        $("#table_transfer tbody").html(noResultStr)
        $(".pagination").html('')
        singleRender('string_noRecord')
      }
      allLanguageRender()
    }
  })
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getGuardAndUserSipList",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        $.each(data.ret, function (k, n) {
          if (n.username == '') {
            var deviceLo = ''
            if (tem_lang == 'zh') {
              n.building += '栋'
              n.unit += '单元'
              n.deviceNo += '号'
              deviceLo = '(卫) ' + n.building + n.unit + n.deviceNo
            }else if (tem_lang == 'en') {
              n.building = ' Bld' + n.building
              n.unit = ' Blk' + n.unit
              n.deviceNo = 'NO.' + n.deviceNo
              deviceLo = '(Guard) ' + n.deviceNo + n.unit + n.building
            }else if (tem_lang == 'hk') {
              n.building += '棟'
              n.unit += '單元'
              n.deviceNo += '號'
              deviceLo = '(衛) ' + n.building + n.unit + n.deviceNo
            }
            $("#table_transfer td[data-val='"+ n.sipNo +"']").html(deviceLo)
          }else{
            if (tem_lang == 'zh') {
              var userText = '(用户) ' + n.username
            }else if (tem_lang == 'en') {
              var userText = '(User) ' + n.username
            }else if (tem_lang == 'hk') {
              var userText = '(用戶) ' + n.username
            }
            $("#table_transfer td[data-val='"+ n.sipNo +"']").html(userText)
          }
        })
      }
    }
  })
  $.ajax({
    url: _ajaxLink + "?c=Sip&m=getSipGroup&groupType=custom",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        $.each(data.ret, function (k, n) {
          if (tem_lang == 'zh') {
            var userText = '(组) ' + n.remark
          }else if (tem_lang == 'en') {
            var userText = '(Group) ' + n.remark
          }else if (tem_lang == 'hk') {
            var userText = '(組) ' + n.remark
          }
          $("#table_transfer td[data-val='"+ n.name +"']").html(userText)
        })
      }
    }
  })
}
//add sip transfer
$('#sip_transfer #popup__add .button--orange').click(function(){
  if ($(this).hasClass('disabled')) {
    return false
  }else{
    var leftSipNo = $('.c-transfer__left--list .is-active')
    var rightSipNo = $('.c-transfer__right--list .is-active')
    var result = $('#popup__add .result')
    $('.c-transfer__left--list').css('border-color','#ccc')
    result.attr('data-lang','')
    if (leftSipNo.attr('data-value') == rightSipNo.attr('data-value')) {
      result.attr('data-lang','string_sipTransferError1')
    }else{
      $.ajax({
        url: _ajaxLink + "?c=Sip&m=addTransfer",
        type: "POST",
        data:{
          isAdd: true,
          sourceSip: leftSipNo.attr('data-value'),
          transfer: rightSipNo.attr('data-value'),
          remark: $('#popup__add').find('input[name="remark"]').val()
        },
        dataType: "json",
        success: function(data){
          if(data.state==1){
            location.reload();
          }else if(data.state == 2){
            result.attr('data-lang','string_sipTransferError2')
            $('.c-transfer__left--list').css('border-color','rgb(255, 152, 0)')
            singleRender('string_sipTransferError2')
          }
        }
      })
    }
    allLanguageRender()
  }
})

//edit sip transfer
$('#sip_transfer #popup__edit .button--orange').click(function(){
  if ($(this).hasClass('disabled')) {
    return false
  }else{
    var editSipNo = $('.c-transfer__edit--list .is-active')
    var result = $('#popup__edit .result')
    $('.c-transfer__edit--list').css('border-color','#ccc')
    result.attr('data-lang','')
    $.ajax({
      url: _ajaxLink + "?c=Sip&m=addTransfer",
      type: "POST",
      data:{
        isAdd: false,
        sourceSip: $('#sourceTransfer').attr('data-val'),
        transfer: editSipNo.attr('data-value'),
        remark: $('#popup__edit').find('input[name="remark"]').val()
      },
      dataType: "json",
      success: function(data){
        if(data.state==1){
          location.reload();
        }
        // else if(data.state == 2){
        //   result.attr('data-lang','string_sipTransferError2')
        //   $('.c-transfer__edit--list').css('border-color','rgb(255, 152, 0)')
        //   singleRender('string_sipTransferError2')
        // }
      }
    })
  }
})

//remove sip transfer
$('#sip_transfer #popup__delete .button--red').click(function(){
  var id = $(this).attr('data-id')
  $.ajax({
    url: _ajaxLink + "?c=Sip&m=deleteTransfer",
    type: "POST",
    data:{
      id: id
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        location.reload();
      }
    }
  })
})

//*************************************sip fixed function*************************************//
//get sip fixed
function getSipFixedGroup(){
  $.ajax({
    url: _ajaxLink + "?c=Sip&m=getSipGroup&groupType=default",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        var str = "";
        $.each(data.ret, function (k, n) {
          if (n.members != '' && n.members != null) {
            var members = n.members.replace("[", "").replace("]", "").replace(/"/g,'')
          }else{
            var members = ''
          }
          var tableTr = $("#table_fixed tbody tr[data-value='"+ n.deviceType +"']")
          tableTr.attr('data-id', n.id)
          tableTr.find('.c-fixed__groupMembers').html(members)
          tableTr.find('.c-fixed__groupMembers').attr('data-val', members)
        })
      }
      allLanguageRender()
    }
  })
  $.ajax({
    url: _ajaxLink + "?c=BasicInfo&m=getGuardAndUserSipList",
    type: "GET",
    dataType: "json",
    async: false,
    success: function(data){
      if (data.state == 1 && data.ret != '') {
        $.each(data.ret, function (k, n) {
          if (n.username == '') {
            var deviceLo = ''
            if (tem_lang == 'zh') {
              n.building += '栋'
              n.unit += '单元'
              n.deviceNo += '号'
              deviceLo = '(卫) ' + n.building + n.unit + n.deviceNo
            }else if (tem_lang == 'en') {
              n.building = ' Bld' + n.building
              n.unit = ' Blk' + n.unit
              n.deviceNo = 'NO.' + n.deviceNo
              deviceLo = '(Guard) ' + n.deviceNo + n.unit + n.building
            }else if (tem_lang == 'hk') {
              n.building += '棟'
              n.unit += '單元'
              n.deviceNo += '號'
              deviceLo = '(衛) ' + n.building + n.unit + n.deviceNo
            }
            var oldMember = $("#table_fixed td")
            for (var i = 0; i < oldMember.length; i++) {
              oldMember.eq(i).html(oldMember.eq(i).html().replace(n.sipNo, ' ' + deviceLo))
            }
          }else{
            if (tem_lang == 'zh') {
              var userText = '(用户) ' + n.username
            }else if (tem_lang == 'en') {
              var userText = '(User) ' + n.username
            }else if (tem_lang == 'hk') {
              var userText = '(用戶) ' + n.username
            }
            var oldMember = $("#table_fixed td")
            for (var i = 0; i < oldMember.length; i++) {
              oldMember.eq(i).html(oldMember.eq(i).html().replace(n.sipNo, ' ' + userText))
            }
          }
        })
      }
    }
  })
  $("#table_fixed td[data-name='members']").on('mouseover', function(){
    if ($(this).html() != '') {
      var left = $(this).offset().left + $(this).width()/2 - 100
      var top = $(this).offset().top + $(this).height()
      var str = "<p class='sipHover' style='left:"+ left +"px; top:"+ top +"px;'>"+ $(this).html() +"</p>"
      $('body').append(str)
    }
  })
  $("#table_fixed td[data-name='members']").on('mouseout', function(){
    $('.sipHover').remove()
  })
}

//edit sip fixed
$('#sip_fixed #popup__edit .button--orange').click(function(){
  var result = $('#popup__edit .result')
  var id = $(this).attr('data-id')
  $('.c-fixed__left--list').css('border-color','#ccc')
  result.attr('data-lang','')

  var members = []
  var membersObj = $('#popup__edit .c-fixed__right--list p')
  membersObj.each(function(){
    var sipNo = '"' + $(this).attr('data-value') + '"'
    members.push(sipNo)
  })
  members = members != '' ? '[' + members.join(',') + ']' : ''
  $.ajax({
    url: _ajaxLink + "?c=Sip&m=editDefaultSipGroup",
    type: "POST",
    data:{
      id: id,
      members: members,
      transfer: ''
    },
    dataType: "json",
    success: function(data){
      if(data.state==1){
        location.reload();
      }else{
        result.attr('data-lang','string_text23')
        singleRender('string_text23')
      }
    }
  })
  allLanguageRender()
})
//*************************************get pagination*************************************//
function getPagiation(total,obj,fun,page){
  obj.html('');
  if(total>20){
    var option = '';
    var pagination = '';
    var pageIndex = page ? page : 1;
    var pageIndex = parseInt(pageIndex)
    var pageNum = Math.ceil(total / 20)

    for (var i = 1; i <= pageNum; i++) {
      if (i == pageIndex) {
        option += "<option value='"+ i +"' selected='selected'>"+ i +"</option>"
      }else{
        option += "<option value='"+ i +"'>"+ i +"</option>"
      }
    }

    if (page == 1) {
      pagination += "<li><a href='javascript:void(0);'><img src='./assets/img/icon_pagehome_1.png'></a></li>"
      pagination += "<li><a href='javascript:void(0);'><img src='./assets/img/icon_pageup_1.png'></a></li>"
    }else{
      pagination += "<li><a href='#1' onclick='"+ fun +"(1)'><img src='./assets/img/icon_pagehome.png'></a></li>"
      pagination += "<li><a href='#"+ (pageIndex - 1) +"' onclick='"+ fun +"("+ (pageIndex - 1) +")'><img src='./assets/img/icon_pageup.png'></a></li>"
    }

    pagination += "<select class='pagination__select' id='selectPage' onchange='changeGo(this)' value='"+ pageIndex +"'>"+ option +"</select><div onclick='"+ fun +"("+ pageIndex +")'>Go</div>"

    if (page == pageNum) {
      pagination += "<li><a href='javascript:void(0);'><img src='./assets/img/icon_pagedown_1.png'></a></li>"
      pagination += "<li><a href='javascript:void(0);'><img src='./assets/img/icon_pageend_1.png'></a></li>"
    }else{
      pagination += "<li><a href='#"+ (pageIndex + 1) +"' onclick='"+ fun +"("+ (pageIndex + 1) +")'><img src='./assets/img/icon_pagedown.png'></a></li>"
      pagination += "<li><a href='#"+ pageNum +"' onclick='"+ fun +"("+ pageNum +")'><img src='./assets/img/icon_pageend.png'></a></li>"
    }
    obj.html(pagination);
  }
}
function changeGo(obj){
  var page = $(obj).val()
  var fun = $('#selectPage + div').attr('onclick')
  fun = fun.replace(/\([^\)]*\)/g,"")
  var newFun = fun + '(' + page + ')'
  $('#selectPage + div').attr('onclick', newFun)
  $('#selectPage + div').click()
}

//*************************************go top this pagination*************************************//
function goTopThis(obj){
  var value = $(obj).attr('value')
  var html = $(obj).html()
  $(obj).parent().siblings('dt').attr('value', value)
  $(obj).parent().siblings('dt').html(html)
  $(obj).parents('.c-select').removeClass('is-active')
  resetSelect()
}
function resetSelect(){
  var building_id = $('#select--building dt').attr('value')
  var building_html = $('#select--building dt').html()
  var block_id = $('#select--block dt').attr('value')
  var block_html = $('#select--block dt').html()
  var room_id = $('#select--room dt').attr('value')
  var room_html = $('#select--room dt').html()
  var role = $('#select--position dt').attr('value')
  $('#select--building__edit dt, #select--building__add dt').attr('value', building_id)
  $('#select--building__edit dt, #select--building__add dt').html(building_html)
  $('#select--block__edit dt, #select--block__add dt').attr('value', block_id)
  $('#select--block__edit dt, #select--block__add dt').html(block_html)
  $('#select--room__edit dt, #select--room__add dt').attr('value', room_id)
  $('#select--room__edit dt, #select--room__add dt').html(room_html)

  var cId= $('.c-content').attr('id')
  if(cId == 'info_block'){
    getBlock(1, building_id)
  }else if(cId == 'info_room'){
    getRoom(1, building_id, block_id)
  }else if(cId == 'info_user'){
    getUser(1, building_id, block_id, room_id)
  }else if(cId == 'info_indoor'){
    getIndoor(1, building_id, block_id, room_id)
  }else if(cId == 'info_outdoor'){
    getOutdoor(1, building_id, block_id)
  }else if(cId == 'info_guard'){
    getGuard(1, building_id, block_id)
  }else if (cId == 'permission') {
    getPermission(role)
  }
}
