/*String*/
if(typeof String.prototype.trim !== 'function') {
        String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, ''); 
    }
}

String.prototype.textLimit = function(maxLength) {
    var text = this;
    if (text.length > maxLength) 
      text = text.substring(0,maxLength) + '...';
    return text;
}

String.prototype.splice = function( idx, rem, s ) {
    return (this.slice(0,idx) + s + this.slice(idx + Math.abs(rem)));
};

String.prototype.captureURL = function() {
    var text = this;
    var startIndex, endIndex, url, array; 
    startIndex = text.indexOf('http://');
    if (startIndex < 0) return text;
    endIndex = text.indexOf(' ', startIndex);
    if (endIndex < 0) endIndex = text.length - 1;
    url = text.substring(startIndex, endIndex + 1);
    text = text.splice(endIndex + 1, 0 , '</a>');
    text = text.splice(startIndex, 0 , '<a href="$" target="_blank">'.replace('$', url));
    return text;
}

/*Date*/
Date.prototype.format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1,
            //月份
            "d+": this.getDate(),
            //日
            "h+": this.getHours() % 12 == 0 ? 12 : this.getHours() % 12,
            //小时
            "H+": this.getHours(),
            //小时
            "m+": this.getMinutes(),
            //分
            "s+": this.getSeconds(),
            //秒
            "q+": Math.floor((this.getMonth() + 3) / 3),
            //季度
            "S": this.getMilliseconds() //毫秒
      };

        var week = {
            "0": "\u65e5",
            "1": "\u4e00",
            "2": "\u4e8c",
            "3": "\u4e09",
            "4": "\u56db",
            "5": "\u4e94",
            "6": "\u516d"
        };

        if (/(y+)/.test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        }

        if (/(E+)/.test(fmt)) {
            fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468") : "") + week[this.getDay() + ""]);
      }

        for (var k in o) {
            if (new RegExp("(" + k + ")").test(fmt)) {
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            }
        }
        return fmt;
}


//2011-02-03 03:05 ToFullDateTime
Date.prototype.toFullDateTime = function () {
    return this.format("yyyy-MM-dd HH:mm");
}

//02-03 03:05 ToShortDateTime
Date.prototype.toShortDateTime = function () {
    return this.format("MM-dd HH:mm");
}

//02-03 ToShortDate
Date.prototype.toShortDate = function () {
    return this.format("MM-dd");
}

//2011-02-03 ToFullDate
Date.prototype.toFullDate = function () {
    return this.format("yyyy-MM-dd");
}

//03:05:33 ToFullTime
Date.prototype.toFullTime = function () {
    return this.format("HH:mm:ss");
}

//03:05 ToShortTime
Date.prototype.toShortTime = function () {
    return this.format("HH:mm");
}

//刚刚,x天前 之类                  ToNiceTime
Date.prototype.toNiceTime = function () {
    var now = new Date();
    var nowTimes = now.getTime();
    var startTimes = this.getTime();
    if (startTimes > nowTimes)
        return this.toFullDateTime();

    var totalSecond = Math.floor((now - this) / 1000);
    if (totalSecond < 60) 
        return "刚刚";
    
    var totalMinute = Math.floor(totalSecond / 60);
    if (totalMinute < 60) 
        return totalMinute + " 分钟前";

    var dayDiff = Math.floor(totalMinute / 60 / 24);
    var yearDiff = Math.floor(dayDiff / 365);
    if (dayDiff == 0) {
        var totalHour = Math.floor(totalMinute / 60);
        return totalHour + " 小时前";
    }
    if (dayDiff == 1) {
        return "昨天 " + this.format("hh:mm");
    }
    if (dayDiff == 2) {
        return "前天 " + this.format("hh:mm");
    }
    if (yearDiff == 0) {
        return this.toShortDateTime();
    }
    return this.toFullDateTime();
}



/*Plug-ins*/
$.fn.displayInfo = function(settings) {
    settings = $.extend({
        autoHide: true
        , status: 1
        , info: ''
        , callback: function() {}
    }, settings);

    return this.each(function() {
        var el = $(this);
        var left = el.offset().left;
        var top = el.offset().top;
        var width = el[0].offsetWidth;
        
        var dom = $('<div class="mini_pop_layer"/>')
            .html(settings.info)
            .css({left: left + width + 10, top: top})
            .appendTo('body');

        if (settings.status == 1) 
            dom.addClass('succ');
        else if (settings.status == 0)
            dom.addClass('erorr');

        if (settings.autoHide) 
            setTimeout(function() {
                dom.remove();
                settings.callback();
            }, 1000);
    });
};
    




