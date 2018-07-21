(function (undefined) {
	var _global;
	function extend (def,opt,override) {
		for(var k in opt){
			if(opt.hasOwnProperty(k) && (!def.hasOwnProperty(k) || override)){
				def[k] = opt[k]
			}
		}
		return def;
	}
	function formartDate (y,m,d,symbol) {
		symbol = symbol || '-';
		m = (m.toString())[1] ? m : '0'+m;
		d = (d.toString())[1] ? d : '0'+d;
		return y+symbol+m+symbol+d
	}

	function Schedule (opt) {
		var def = {},
			opt = extend(def,opt,true),
			curDate = opt.date ? new Date(opt.date) : new Date(),
			year = curDate.getFullYear(),
			month = curDate.getMonth(),
			day = curDate.getDate(),
			currentYear = curDate.getFullYear(),
			currentMonth = curDate.getMonth(),
			currentDay = curDate.getDate(),
			selectedDate = '',
			el = document.querySelector(opt.el) || document.querySelector('body'),
			_this = this;
		var bindEvent = function (){
			el.addEventListener('click',function(e){
				switch (e.target.id) {
					case 'nextMonth':
						_this.nextMonthFun();
						break;
					case 'nextYear':
						_this.nextYearFun();
						break;
					case 'prevMonth':
						_this.prevMonthFun();
						break;
					case 'prevYear':
						_this.prevYearFun();
						break;
					default:
						break;
				};
				if(e.target.className.indexOf('currentDate') > -1){
					opt.clickCb && opt.clickCb(year, month+1, e.target.innerHTML);
					selectedDate = e.target.title;
					day = e.target.innerHTML;
					render();
				}
			},false)
		}
		var init = function () {
			var scheduleHd = '<div class="schedule-hd">'+
								'<div>'+
									//'<span class="arrow icon iconfont icon-116leftarrowheads" id="prevYear" ></span>'+
									'<span class="arrow icon_arrow_left" id="prevMonth"></span>'+
								'</div>'+
								'<div class="today">'+formartDate(year,month+1,day,'-')+'</div>'+
								'<div>'+
									'<span class="arrow icon_arrow_right" id="nextMonth"></span>'+
									//'<span class="arrow icon iconfont icon-115rightarrowheads" id="nextYear"></span>'+
								'</div>'+
							'</div>'
			if (tem_lang == 'zh') {
				var scheduleWeek = '<ul class="week-ul ul-box">'+
										'<li>星期日</li>'+
										'<li>星期一</li>'+
										'<li>星期二</li>'+
										'<li>星期三</li>'+
										'<li>星期四</li>'+
										'<li>星期五</li>'+
										'<li>星期六</li>'+
									'</ul>'
			}else if (tem_lang == 'en') {
				var scheduleWeek = '<ul class="week-ul ul-box">'+
										'<li>Sun</li>'+
										'<li>Mon</li>'+
										'<li>Tue</li>'+
										'<li>Wed</li>'+
										'<li>Thu</li>'+
										'<li>Fri</li>'+
										'<li>Sat</li>'+
									'</ul>'
			}else if (tem_lang == 'hk') {
				var scheduleWeek = '<ul class="week-ul ul-box">'+
										'<li>星期日</li>'+
										'<li>星期壹</li>'+
										'<li>星期二</li>'+
										'<li>星期三</li>'+
										'<li>星期四</li>'+
										'<li>星期五</li>'+
										'<li>星期六</li>'+
									'</ul>'
			}

			var scheduleBd = '<ul class="schedule-bd ul-box" ></ul>';
			el.innerHTML = scheduleHd + scheduleWeek + scheduleBd;
			bindEvent();
			render();
		}
		var render = function () {
			var fullDay = new Date(year,month+1,0).getDate(),
				startWeek = new Date(year,month,1).getDay(),
				total = (fullDay+startWeek)%7 == 0 ? (fullDay+startWeek) : fullDay+startWeek+(7-(fullDay+startWeek)%7),
				lastMonthDay = new Date(year,month,0).getDate(),
				eleTemp = [];
			for(var i = 0; i < total; i++){
				if(i<startWeek){
					eleTemp.push('<li class="other-month"><span class="dayStyle">'+(lastMonthDay-startWeek+1+i)+'</span></li>')
				}else if(i<(startWeek+fullDay)){
					var nowDate = formartDate(year,month+1,(i+1-startWeek),'-');
					var addClass = '';
					selectedDate == nowDate && (addClass = 'selected-style');
					formartDate(currentYear,currentMonth+1,currentDay,'-') == nowDate && (addClass = 'today-flag');
					eleTemp.push('<li class="current-month" ><span title='+nowDate+' class="currentDate dayStyle '+addClass+'">'+(i+1-startWeek)+'</span></li>')
				}else{
					eleTemp.push('<li class="other-month"><span class="dayStyle">'+(i+1-(startWeek+fullDay))+'</span></li>')
				}
			}
			if (eleTemp.length <= 35) {
				for (var i = 0; i < 7; i++) {
					eleTemp.push('<li class="other-month"></li>')
				}
			}
			el.querySelector('.schedule-bd').innerHTML = eleTemp.join('');
			el.querySelector('.today').innerHTML = formartDate(year,month+1,day,'-');
			checkNewDay()
			$('.c-calendar__eventBox textarea').val('')
		};
		this.nextMonthFun = function () {
			if(month+1 > 11){
				year += 1;
				month = 0;
			}else{
				month += 1;
			}
			render();
			opt.nextMonthCb && opt.nextMonthCb(year,month+1,day);
			$('.current-month span').eq(0).click()
		},
		this.nextYearFun = function () {
			year += 1;
			render();
			opt.nextYeayCb && opt.nextYeayCb(year,month+1,day);
		},
		this.prevMonthFun = function () {
			if(month-1 < 0){
				year -= 1;
				month = 11;
			}else{
				month -= 1;
			}
			render();
			opt.prevMonthCb && opt.prevMonthCb(year,month+1,day);
			$('.current-month span').eq(0).click()
		},
		this.prevYearFun = function () {
			year -= 1;
			render();
			opt.prevYearCb && opt.prevYearCb(year,month+1,day);
		}
		init();
	}
	_global = (function(){return this || (0,eval)('this')}());
	if(typeof module !== 'undefined' && module.exports){
		module.exports = Schedule;
	}else if (typeof define === "function" && define.amd){
		define(function () {
			return Schedule;
		})
	}else {
		!('Schedule' in _global) && (_global.Schedule = Schedule);
	}

}());
