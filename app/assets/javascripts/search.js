    $(document).ready(function() {
      $("#submit-btn").click(function(){
        $("#ajax_gif").css("display","block");
      });
      Request.QueryString("key") == null? "": $('#search_input').val(decodeURIComponent(Request.QueryString("key")));
    });

    function load(){
      load_cities($("#province_sel").find("option:selected").val());
    };
  
    function show_dialog(){
      $("#search-dialog").modal();
    };

    function show_export_dialog(shown_callback, hidden_callback){
      $('#export-dialog').modal({keyboard: false});

      $('#export-dialog').on('shown', function() {
        var backdrop = $('.modal-backdrop');
        backdrop.data('events') && backdrop.data('events')['click'] && backdrop.unbind('click');  

        shown_callback && shown_callback();
      });

      $('#export-dialog').on('hidden', function() {
        hidden_callback && hidden_callback();
      });
    };

    function result_export() {
      var progress = $('#export-dialog span');
      var progressbar = $('#progress-bar .bar');  
      var self = this;

      self.timer = null;

      self.init = function() {
        progress.text('准备生成文件...');
        progressbar.width(0);
        
        self.timer = setInterval(self.get_export_percent, 5000);
      };

      self.get_export_percent = function() {
        $.ajax({
          url: '/search/get_export_percent.json', 
          success: function(data) {
            var percentage = (parseFloat(data.export_percent) * 100).toFixed(2) + '%'
            progress.text(percentage);
            progressbar.width(percentage);

            if(parseInt(data.export_percent) === 1) 
              self.clearTimer();
          },
          error: function() {
            self.clearTimer();
            alert('数据生成失败..');
          }
        });
      };

      self.clearTimer = function() {
        self.timer && clearInterval(self.timer);
      };
    };

    
    function ajax_generate_csv(){
      var link = $('#export-dialog div#download-link').html('');

      url = "/search/generate_csv.csv"+location.search;
      $.get(url,
        {},
        function(result){
          if(result.status == 1){
            link.html("<a href='/search/export.csv'>点击此处下载文件</a>");
          }else if(result.status == -1){
            link.html("<p><font color='red'>您将导出的文件包含超过40万行的数据，请按搜索条件拆分后下载，比如年龄、性别。</font></p>");
          }
        },
        "json")
    };
  
    function load_cities(province_id){
      url = "/cities.json?province=" + province_id;
      $.get(url,
        {},
        function(result){
          $("#city_sel").empty();
          $("#city_sel").append("<option value='all'>不限</option>");
          $.each(result,function(i,city){
            $("#city_sel").append("<option value="+city.city_id+">"+city.name+"</option>");
          });
        },
        "json")
    };
    Request = {
	QueryString : function(item){
	var svalue = location.search.match(new RegExp("[\?\&]" + item + "=([^\&]*)(\&?)","i"));
	return svalue ? svalue[1] : svalue;
	}}	
