(function() {
    var Program = {};
    Program["ErrorMsg"] = function(module, exports) {
      var ErrorMsg = function(msg) {

        var title = new TextField();
        title.text = msg;

        var fmt = new TextFormat();
        fmt.color = 0x000000;
        fmt.font = "Courier";
        fmt.size = 10;
        fmt.align = "left";

        title.setTextFormat(fmt);
        title.autoSize = "left";
        title.border = true;
        title.x = 5;
        title.y = 5;

        this.addChild(title);
      };

      ErrorMsg.prototype = Object.create(Sprite.prototype);

      ErrorMsg.prototype.add_html = function(html) {

        var txt = new TextField();

        var style = new StyleSheet();

        var hover = new Object();
        hover.fontWeight = "bold";
        hover.color = "#0000FF";

        var link = new Object();
        link.fontWeight = "bold";
        link.textDecoration = "underline";
        link.color = "#0000A0";

        var active = new Object();
        active.fontWeight = "bold";
        active.color = "#0000A0";

        var visited = new Object();
        visited.fontWeight = "bold";
        visited.color = "#CC0099";
        visited.textDecoration = "underline";

        style.setStyle("a:link", link);
        style.setStyle("a:hover", hover);
        style.setStyle("a:active", active);
        style.setStyle(".visited", visited); //note Flash doesn't support a:visited

        txt.styleSheet = style;
        txt.htmlText = html;
        txt.autoSize = "left";
        txt.border = true;

        var t = (TextField) this.getChildAt(0);
        txt.y = t.y + t.height + 10;
        txt.x = 5;

        this.addChild(txt);

      }

      module.exports = ErrorMsg;
    };
    Program["ExternalInterfaceManager"] = function(module, exports) {
      var ExternalInterfaceManager, tr;
      module.inject = function() {
        ExternalInterfaceManager = module.import('', 'ExternalInterfaceManager');
        tr = module.import('', 'tr');
        ExternalInterfaceManager._instance = null;
      };

      var ExternalInterfaceManager = function ExternalInterfaceManager() {};

      ExternalInterfaceManager._instance = null;
      ExternalInterfaceManager.getInstance = function() {

        if (ExternalInterfaceManager._instance == null) {
          ExternalInterfaceManager._instance = new ExternalInterfaceManager();
        }

        return ExternalInterfaceManager._instance;
      };

      ExternalInterfaceManager.prototype.has_id = false;
      ExternalInterfaceManager.prototype.chart_id = null;
      ExternalInterfaceManager.prototype.setUp = function(chart_id) {
        this.has_id = true;
        this.chart_id = chart_id;
        tr.aces('this.chart_id', this.chart_id);
      };
      ExternalInterfaceManager.prototype.callJavascript = function(functionName, optionalArgs) {

        // the debug player does not have an external interface
        // because it is NOT embedded in a browser
        if (ExternalInterface.available) {
          if (this.has_id) {
            tr.aces(functionName, optionalArgs);
            optionalArgs.unshift(this.chart_id);
            tr.aces(functionName, optionalArgs);
          }

          return ExternalInterface.call(functionName, optionalArgs);
        }

      }

      module.exports = ExternalInterfaceManager;
    };
    Program["JsonErrorMsg"] = function(module, exports) {
      var ErrorMsg = module.import('', 'ErrorMsg');

      var JsonErrorMsg = function(json, e) {

        var tmp = "Open Flash Chart\n\n";
        tmp += "JSON Parse Error [" + e.message + "]\n";

        // find the end of line after the error location:
        var pos = json.indexOf("\n", e.errorID);
        var s = json.substr(0, pos);
        var lines = s.split("\n");

        tmp += "Error at character " + e.errorID + ", line " + lines.length + ":\n\n";

        for (var i = 3; i > 0; i--) {
          if (lines.length - i > -1)
            tmp += (lines.length - i).JsonErrorMsg.toString() + ": " + lines[lines.length - i];

        }

        ErrorMsg.call(this, tmp);
      };

      JsonErrorMsg.prototype = Object.create(ErrorMsg.prototype);

      module.exports = JsonErrorMsg;
    };
    Program["JsonInspector"] = function(module, exports) {
      var JsonInspector = function JsonInspector() {};

      JsonInspector.has_pie_chart = function(json) {

        var elements = (Array) json['elements'];

        for (var i = 0; i < elements.length; i++) {
          // tr.ace( elements[i]['type'] );

          if (elements[i]['type'] == 'pie')
            return true;
        }

        return false;
      };
      JsonInspector.is_radar = function(json) {

        if (json['radar_axis'] != null)
          return true;

        return false;
      };

      module.exports = JsonInspector;
    };
    Program["Loading"] = function(module, exports) {
      var Loading = function(text) {
        this.tf = null;

        this.tf = new TextField();
        this.tf.text = text;

        var fmt = new TextFormat();
        fmt.color = 0x000000;
        fmt.font = "Verdana";
        fmt.size = 12;
        fmt.align = "center";

        this.tf.setTextFormat(fmt);
        this.tf.autoSize = "left";
        this.tf.x = 5;
        this.tf.y = 5;

        //
        // HACK! For some reason the Stage.height is not
        // correct the very first time this object is created
        // so we wait untill the first frame before placing
        // the movie clip at the center of the Stage.
        //

        this.addEventListener(Event.ENTER_FRAME, this.onEnter);

        this.addChild(this.tf);

        this.graphics.lineStyle(2, 0x808080, 1);
        this.graphics.beginFill(0xf0f0f0);
        this.graphics.drawRoundRect(0, 0, this.tf.width + 10, this.tf.height + 10, 5, 5);

        var spin = new Sprite();
        spin.x = this.tf.width + 40;
        spin.y = (this.tf.height + 10) / 2;

        var radius = 15;
        var dots = 6;
        var colours = [0xF0F0F0, 0xD0D0D0, 0xB0B0B0, 0x909090, 0x707070, 0x505050, 0x303030];

        for (var i = 0; i < dots; i++) {
          var deg = (360 / dots) * i;
          var radians = deg * (Math.PI / 180);
          var x = radius * Math.cos(radians);
          var y = radius * Math.sin(radians);

          spin.graphics.lineStyle(0, 0, 0);
          spin.graphics.beginFill(colours[i], 1);
          spin.graphics.drawCircle(x, y, 4);
        }

        this.addChild(spin);

        var dropShadow = new DropShadowFilter();
        dropShadow.blurX = 4;
        dropShadow.blurY = 4;
        dropShadow.distance = 4;
        dropShadow.angle = 45;
        dropShadow.quality = 2;
        dropShadow.alpha = 0.5;
        // apply shadow filter
        this.filters = [dropShadow];

        /*
        
          
          
          spin.onEnterFrame = function ()
          {
            this._rotation += 5;
          }
        
          */
      };

      Loading.prototype = Object.create(Sprite.prototype);

      Loading.prototype.tf = null;
      Loading.prototype.onEnter = function(event) {

        if (this.stage) {
          this.x = (this.stage.stageWidth / 2) - ((this.tf.width + 10) / 2);
          this.y = (this.stage.stageHeight / 2) - ((this.tf.height + 10) / 2);
          // this.removeEventListener( Event.ENTER_FRAME, this.onEnter );
          // tr.ace('ppp');
        }
        this.getChildAt(1).rotation += 5;
      }

      module.exports = Loading;
    };
    Program["main"] = function(module, exports) {
      var ErrorMsg, ExternalInterfaceManager, JsonErrorMsg, JsonInspector, Loading, NumberFormat, ScreenCoords, ScreenCoordsBase, ScreenCoordsRadar, Tooltip, tr, Global, Background, RadarAxis, XAxis, YAxisLeft, YAxisRight, Keys, Title, XLegend, YLegendLeft, YLegendRight, Menu, Factory, has_tooltip, PNGEncoder;
      module.inject = function() {
        ErrorMsg = module.import('', 'ErrorMsg');
        ExternalInterfaceManager = module.import('', 'ExternalInterfaceManager');
        JsonErrorMsg = module.import('', 'JsonErrorMsg');
        JsonInspector = module.import('', 'JsonInspector');
        Loading = module.import('', 'Loading');
        NumberFormat = module.import('', 'NumberFormat');
        ScreenCoords = module.import('', 'ScreenCoords');
        ScreenCoordsBase = module.import('', 'ScreenCoordsBase');
        ScreenCoordsRadar = module.import('', 'ScreenCoordsRadar');
        Tooltip = module.import('', 'Tooltip');
        tr = module.import('', 'tr');
        Global = module.import('global', 'Global');
        Background = module.import('elements', 'Background');
        RadarAxis = module.import('elements.axis', 'RadarAxis');
        XAxis = module.import('elements.axis', 'XAxis');
        YAxisLeft = module.import('elements.axis', 'YAxisLeft');
        YAxisRight = module.import('elements.axis', 'YAxisRight');
        Keys = module.import('elements.labels', 'Keys');
        Title = module.import('elements.labels', 'Title');
        XLegend = module.import('elements.labels', 'XLegend');
        YLegendLeft = module.import('elements.labels', 'YLegendLeft');
        YLegendRight = module.import('elements.labels', 'YLegendRight');
        Menu = module.import('elements.menu', 'Menu');
        Factory = module.import('charts', 'Factory');
        has_tooltip = module.import('charts.series', 'has_tooltip');
        PNGEncoder = module.import('com.adobe.images', 'PNGEncoder');
      };

      var main = function() {
        this.title = null;
        this.x_axis = null;
        this.radar_axis = null;
        this.x_legend = null;
        this.y_axis = null;
        this.y_axis_right = null;
        this.y_legend = null;
        this.y_legend_2 = null;
        this.keys = null;
        this.obs = null;
        this.sc = null;
        this.tooltip = null;
        this.background = null;
        this.menu = null;
        this.chart_parameters = null;

        // hook into all the events
        this.set_the_stage();

        this.chart_parameters = LoaderInfo(this.loaderInfo).parameters;
        this.build_right_click_menu();

        // inform javascript that it can call our reload method
        this.addCallback("reload", this.reload); // mf 18nov08, line 110 of original 'main.as'

        // inform javascript that it can call our load method
        this.addCallback("load", this.load);

        // inform javascript that it can call our post_image method
        this.addCallback("post_image", this.post_image);

        // 
        this.addCallback("get_img_binary", this.getImgBinary);

        // more interface
        this.addCallback("get_version", this.getVersion);

        // TODO: change all external to use this:

        //
        // tell our external interface manager to pass out the chart ID
        // with every external call.
        //
        if (this.chart_parameters['id']) {
          var ex = ExternalInterfaceManager.getInstance();
          ex.setUp(this.chart_parameters['id']);
        }

        this.load_data();
      };

      main.prototype = Object.create(Sprite.prototype);

      main.prototype.VERSION = "2 Lug Wyrm Charmer";
      main.prototype.title = null;
      main.prototype.x_axis = null;
      main.prototype.radar_axis = null;
      main.prototype.x_legend = null;
      main.prototype.y_axis = null;
      main.prototype.y_axis_right = null;
      main.prototype.y_legend = null;
      main.prototype.y_legend_2 = null;
      main.prototype.keys = null;
      main.prototype.obs = null;
      main.prototype.tool_tip_wrapper = null;
      main.prototype.sc = null;
      main.prototype.tooltip = null;
      main.prototype.background = null;
      main.prototype.menu = null;
      main.prototype.ok = false;
      main.prototype.URL = null;
      main.prototype.id = null;
      main.prototype.chart_parameters = null;
      main.prototype.json = null;
      main.prototype.set_the_stage = function() {

        tr.aces('set_the_stage()');

        // tell flash to align top left, and not to scale
        // anything (we do that in the code)
        this.stage.align = StageAlign.TOP_LEFT;
        //
        // ----- RESIZE ----
        //
        // noScale: now we can pick up resize events
        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        this.stage.addEventListener(Event.ACTIVATE, this.activateHandler);
      };
      main.prototype.activateHandler = function(event) {

        tr.aces("activateHandler:", event);
        //tr.aces("stage", this.stage);
      };
      main.prototype.load_data = function() {

        this.ok = false;

        if (this.chart_parameters['loading'] == null)
          this.chart_parameters['loading'] = 'Loading data...';

        var l = new Loading(this.chart_parameters['loading']);
        this.addChild(l);

        tr.aces('find_data()');
        if (!this.find_data()) {
          // no data found -- debug mode?
          try {
            var file = "../../data-files/y-axis-auto-range-lines.txt";
            this.load_external_file(file);

            /*
            // test AJAX calls like this:
            var file = "../data-files/bar-2.txt";
            this.load_external_file( file );
            file = "../data-files/radar-area.txt";
            this.load_external_file( file );
            */
          } catch (e: Error) {
            this.show_error('Loading test data\n' + file + '\n' + e.message);
          }
        }
      };
      main.prototype.addCallback = function(functionName, closure) {

        // the debug player does not have an external interface
        // because it is NOT embedded in a browser
        if (ExternalInterface.available)
          ExternalInterface.addCallback(functionName, closure);

      };
      main.prototype.callExternalCallback = function(functionName, optionalArgs) {

        // the debug player does not have an external interface
        // because it is NOT embedded in a browser
        if (ExternalInterface.available)
          return ExternalInterface.call(functionName, optionalArgs);

      };
      main.prototype.getVersion = function() {
        return this.VERSION;
      };
      main.prototype.getImgBinary = function() {

        tr.ace('Saving image :: image_binary()');

        var bmp = new BitmapData(this.stage.stageWidth, this.stage.stageHeight);
        bmp.draw(this);

        var b64 = new Base64Encoder();

        var b = PNGEncoder.encode(bmp);

        // var encoder = new JPGEncoder(80);
        // var q = encoder.encode(bmp);
        // b64.encodeBytes(q);

        //
        //
        //
        b64.encodeBytes(b);
        return b64.toString();
        //
        // commented out by J vander? why?
        // return b64.flush();
        //
        //

        /*
        var b64 = new Base64Encoder();
        b64.encodeBytes(image_binary());
        tr.ace( (String) b64);
        return (String) b64;
        */
      };
      main.prototype.saveImage = function(e) {
        // ExternalInterface.call("save_image", this.chart_parameters['id']);// , getImgBinary());
        // ExternalInterface.call("save_image", getImgBinary());

        // this just calls the javascript function which will grab an image from use
        // an do something with it.
        this.callExternalCallback("save_image", this.chart_parameters['id']);
      };
      main.prototype.image_binary = function() {
        tr.ace('Saving image :: image_binary()');

        var pngSource = new BitmapData(this.width, this.height);
        pngSource.draw(this);
        return PNGEncoder.encode(pngSource);
      };
      main.prototype.post_image = function(url, callback, debug) {

        var header = new URLRequestHeader("Content-type", "application/octet-stream");

        //Make sure to use the correct path to jpg_encoder_download.php
        var request = new URLRequest(url);

        request.requestHeaders.push(header);
        request.method = URLRequestMethod.POST;
        //
        request.data = this.image_binary();

        var loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.VARIABLES;

        /*
         * i can't figure out how to make these work
         * 
        var urlVars = new URLVariables();
        for (var key in post_params) {
          urlVars[key] = post_params[key];
        }
        */
        // base64:
        // urlVars.b64_image_data =  getImgBinary();
        // RAW:
        // urlVars.b64_image_data = image_binary();

        // request.data = urlVars;

        var id = '';
        if (this.chart_parameters['id'])
          id = this.chart_parameters['id'];

        if (debug) {
          // debug the PHP:
          flash.net.navigateToURL(request, "_blank");
        } else {
          //we have to use the PROGRESS event instead of the COMPLETE event due to a bug in flash
          loader.addEventListener(ProgressEvent.PROGRESS, function(e) {

            tr.ace("progress:" + e.bytesLoaded + ", total: " + e.bytesTotal);
            if ((e.bytesLoaded == e.bytesTotal) && (callback != null)) {
              tr.aces('Calling: ', callback + '(' + id + ')');
              this.call(callback, id);
            }
          });

          try {
            loader.load(request);
          } catch (error: Error) {
            tr.ace("unable to load:" + error);
          }

          /*
          var loader = new URLLoader();
          loader.dataFormat = URLLoaderDataFormat.BINARY;
          loader.addEventListener(Event.COMPLETE, function(e:Event):void {
            tr.ace('Saved image to:');
            tr.ace( url );
            //
            // when the upload has finished call the user
            // defined javascript function/method
            //
            ExternalInterface.call(callback);
            });
            
          loader.load( jpgURLRequest );
          */
        }
      };
      main.prototype.onContextMenuHandler = function(event) {};
      main.prototype.find_data = function() {

        // var all = ExternalInterface.call("window.location.href.toString");
        var vars = this.callExternalCallback("window.location.search.substring", 1);

        if (vars != null) {
          var p = vars.split('&');
          for each(var v in p) {
            if (v.indexOf('ofc=') > -1) {
              var tmp = v.split('=');
              tr.ace('Found external file:' + tmp[1]);
              this.load_external_file(tmp[1]);
              //
              // LOOK:
              //
              return true;
            }
          }
        }

        if (this.chart_parameters['data-file']) {
          // tr.ace( 'Found parameter:' + parameters['data-file'] );
          this.load_external_file(this.chart_parameters['data-file']);
          //
          // LOOK:
          //
          return true;

        }

        var get_data = 'open_flash_chart_data';
        if (this.chart_parameters['get-data'])
          get_data = this.chart_parameters['get-data'];

        var json_string;

        if (this.chart_parameters['id'])
          json_string = this.callExternalCallback(get_data, this.chart_parameters['id']);
        else
          json_string = this.callExternalCallback(get_data);

        if (json_string != null) {
          if (json_string is String) {
            this.parse_json(json_string);

            //
            // We have loaded the data, so this.ok = true
            //
            this.ok = true;
            //
            // LOOK:
            //
            return true;
          }
        }

        return false;
      };
      main.prototype.reload = function(url) {

        var l = new Loading(this.chart_parameters['loading']);
        this.addChild(l);
        this.load_external_file(url);
      };
      main.prototype.load_external_file = function(file) {

        this.URL = file;
        //
        // LOAD THE DATA
        //
        var loader = new URLLoader();
        loader.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
        loader.addEventListener(Event.COMPLETE, this.xmlLoaded);

        var request = new URLRequest(file);
        loader.load(request);
      };
      main.prototype.ioError = function(e) {

        // remove the 'loading data...' msg:
        this.removeChildAt(0);
        var msg = new ErrorMsg('Open Flash Chart\nIO ERROR\nLoading test data\n' + e.text);
        msg.add_html('This is the URL that I tried to open:<br><a href="' + this.URL + '">' + this.URL + '</a>');
        this.addChild(msg);
      };
      main.prototype.show_error = function(msg) {

        // remove the 'loading data...' msg:
        this.removeChildAt(0);

        var m = new ErrorMsg(msg);
        //m.add_html( 'Click here to open your JSON file: <a href="http://a.com">asd</a>' );
        this.addChild(m);
      };
      main.prototype.get_x_legend = function() {
        return this.x_legend;
      };
      main.prototype.mouseMove = function(event) {
        // tr.ace( 'over ' + event.target );
        // tr.ace('move ' + Math.random().toString());
        // tr.ace( this.tooltip.get_tip_style() );

        if (!this.tooltip)
          return; // <- an error and the JSON was not loaded

        switch (this.tooltip.get_tip_style()) {
          case Tooltip.CLOSEST:
            this.mouse_move_closest(event);
            break;

          case Tooltip.PROXIMITY:
            this.mouse_move_proximity((MouseEvent) event);
            break;

          case Tooltip.NORMAL:
            this.mouse_move_follow((MouseEvent) event);
            break;

        }
      };
      main.prototype.mouse_move_follow = function(event) {

        // tr.ace( event.currentTarget );
        // tr.ace( event.target );

        if (event.target is has_tooltip)
          this.tooltip.draw((has_tooltip) event.target);
        else
          this.tooltip.hide();
      };
      main.prototype.mouse_move_proximity = function(event) {

        //tr.ace( event.currentTarget );
        //tr.ace( event.target );

        var elements = this.obs.mouse_move_proximity(this.mouseX, this.mouseY);
        this.tooltip.closest(elements);
      };
      main.prototype.mouse_move_closest = function(event) {

        var elements = this.obs.closest_2(this.mouseX, this.mouseY);
        this.tooltip.closest(elements);
      };
      main.prototype.resizeHandler = function(event) {
        tr.aces("resizeHandler: ", event);
        this.resize();
      };
      main.prototype.resize_pie = function() {

        // should this be here?
        this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);

        this.background.resize();
        this.title.resize();

        // this object is used in the mouseMove method
        this.sc = new ScreenCoords(
          this.title.get_height(), 0, this.stage.stageWidth, this.stage.stageHeight,
          null, null, null, 0, 0, false);
        this.obs.resize(this.sc);

        return this.sc;
      };
      main.prototype.resize_radar = function() {

        this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);

        this.background.resize();
        this.title.resize();
        this.keys.resize(0, this.title.get_height());

        var top = this.title.get_height() + this.keys.get_height();

        // this object is used in the mouseMove method
        var sc = new ScreenCoordsRadar(top, 0, this.stage.stageWidth, this.stage.stageHeight);

        sc.set_range(this.radar_axis.get_range());
        // 0-4 = 5 spokes
        sc.set_angles(this.obs.get_max_x() - this.obs.get_min_x() + 1);

        // resize the axis first because they may
        // change the radius (to fit the labels on screen)
        this.radar_axis.resize(sc);
        this.obs.resize(sc);

        return sc;
      };
      main.prototype.resize = function() {
        //
        // the chart is async, so we may get this
        // event before the chart has loaded, or has
        // partly loaded
        //
        if (!this.ok)
          return; // <-- something is wrong

        var sc;

        if (this.radar_axis != null)
          sc = this.resize_radar();
        else if (this.obs.has_pie())
          sc = this.resize_pie();
        else
          sc = this.resize_chart();

        if (this.menu)
          this.menu.resize();

        // tell the web page that we have resized our content
        if (this.chart_parameters['id'])
          this.callExternalCallback("ofc_resize", sc.left, sc.width, sc.top, sc.height, this.chart_parameters['id']);
        else
          this.callExternalCallback("ofc_resize", sc.left, sc.width, sc.top, sc.height);

        sc = null;
      };
      main.prototype.resize_chart = function() {
        //
        // we want to show the tooltip closest to
        // items near the mouse, so hook into the
        // mouse move event:
        //
        this.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);

        // FlashConnect.trace("stageWidth: " + stage.stageWidth + " stageHeight: " + stage.stageHeight);
        this.background.resize();
        this.title.resize();

        var left = this.y_legend.get_width() /*+ this.y_labels.get_width()*/ + this.y_axis.get_width();

        this.keys.resize(left, this.title.get_height());

        var top = this.title.get_height() + this.keys.get_height();

        var bottom = this.stage.stageHeight;
        bottom -= (this.x_legend.get_height() + this.x_axis.get_height());

        var right = this.stage.stageWidth;
        right -= this.y_legend_2.get_width();
        //right -= this.y_labels_right.get_width();
        right -= this.y_axis_right.get_width();

        // this object is used in the mouseMove method
        this.sc = new ScreenCoords(
          top, left, right, bottom,
          this.y_axis.get_range(),
          this.y_axis_right.get_range(),
          this.x_axis.get_range(),
          this.x_axis.first_label_width(),
          this.x_axis.last_label_width(),
          false);

        this.sc.set_bar_groups(this.obs.groups);

        this.x_axis.resize(this.sc,
          // can we remove this:
          this.stage.stageHeight - (this.x_legend.get_height() + this.x_axis.labels.get_height()) // <-- up from the bottom
        );
        this.y_axis.resize(this.y_legend.get_width(), this.sc);
        this.y_axis_right.resize(0, this.sc);
        this.x_legend.resize(this.sc);
        this.y_legend.resize();
        this.y_legend_2.resize();

        this.obs.resize(this.sc);

        // Test code:
        this.dispatchEvent(new Event("on-show"));

        return this.sc;
      };
      main.prototype.mouseOut = function(event) {

        if (this.tooltip != null)
          this.tooltip.hide();

        if (this.obs != null)
          this.obs.mouse_out();
      };
      main.prototype.load = function(s) {
        this.parse_json(s);
      };
      main.prototype.xmlLoaded = function(event) {
        var loader = URLLoader(event.target);
        this.parse_json(loader.data);
      };
      main.prototype.parse_json = function(json_string) {

        // tr.ace(json_string);

        var ok = false;

        try {
          var json = com.serialization.json.JSON.deserialize(json_string);
          ok = true;
        } catch (e: Error) {
          // remove the 'loading data...' msg:
          this.removeChildAt(0);
          this.addChild(new JsonErrorMsg((String) json_string, e));
        }

        //
        // don't catch these errors:
        //
        if (ok) {
          // remove 'loading data...' msg:
          this.removeChildAt(0);
          this.build_chart(json);

          // force this to be garbage collected
          json = null;
        }

        json_string = '';

        // we are displaying things, either a chart or an error message,
        // so now we want to watch for resizes
        this.stage.addEventListener(Event.RESIZE, this.resizeHandler);
        this.stage.addEventListener(Event.MOUSE_LEAVE, this.mouseOut);
        this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseMove);

        //
        // tell the web page that we are ready
        //
        if (this.chart_parameters['id'])
          this.callExternalCallback("ofc_ready", this.chart_parameters['id']);
        else
          this.callExternalCallback("ofc_ready");
      };
      main.prototype.build_chart = function(json) {

        tr.ace('----');
        tr.ace(com.serialization.json.JSON.serialize(json));
        tr.ace('----');

        if (this.obs != null)
          this.die();

        // init singletons:
        NumberFormat.getInstance(json);
        NumberFormat.getInstanceY2(json);

        this.tooltip = new Tooltip(json.tooltip)

        var g = Global.getInstance();
        g.set_tooltip_string(this.tooltip.tip_text);

        //
        // these are common to both X Y charts and PIE charts:
        this.background = new Background(json);
        this.title = new Title(json.title);
        //
        this.addChild(this.background);
        //

        if (JsonInspector.is_radar(json)) {

          this.obs = Factory.MakeChart(json);
          this.radar_axis = new RadarAxis(json.radar_axis);
          this.keys = new Keys(this.obs);

          this.addChild(this.radar_axis);
          this.addChild(this.keys);

        } else if (!JsonInspector.has_pie_chart(json)) {
          this.build_chart_background(json);
        } else {
          // this is a PIE chart
          this.obs = Factory.MakeChart(json);
          // PIE charts default to FOLLOW tooltips
          this.tooltip.set_tip_style(Tooltip.NORMAL);
        }

        // these are added in the Flash Z Axis order
        this.addChild(this.title);
        for each(var set in this.obs.sets)
        this.addChild(set);
        this.addChild(this.tooltip);

        if (json['menu'] != null) {
          this.menu = new Menu('99', json['menu']);
          this.addChild(this.menu);
        }

        this.ok = true;
        this.resize();

      };
      main.prototype.build_chart_background = function(json) {
        //
        // This reads all the 'elements' of the chart
        // e.g. bars and lines, then creates them as sprites
        //
        this.obs = Factory.MakeChart(json);
        //
        this.x_legend = new XLegend(json.x_legend);
        this.y_legend = new YLegendLeft(json);
        this.y_legend_2 = new YLegendRight(json);
        this.x_axis = new XAxis(json, this.obs.get_min_x(), this.obs.get_max_x());
        this.y_axis = new YAxisLeft();
        this.y_axis_right = new YAxisRight();

        // access all our globals through this:
        var g = Global.getInstance();
        // this is needed by all the elements tooltip
        g.x_labels = this.x_axis.labels;
        g.x_legend = this.x_legend;

        //
        // pick up X Axis labels for the tooltips
        // 
        this.obs.tooltip_replace_labels(this.x_axis.labels);
        //
        //
        //

        this.keys = new Keys(this.obs);

        this.addChild(this.x_legend);
        this.addChild(this.y_legend);
        this.addChild(this.y_legend_2);
        this.addChild(this.y_axis);
        this.addChild(this.y_axis_right);
        this.addChild(this.x_axis);
        this.addChild(this.keys);

        // now these children have access to the stage,
        // tell them to init
        tr.ace_json(this.obs.get_y_range());
        tr.ace_json(this.obs.get_y_range(false));

        this.y_axis.init(this.obs.get_y_range(), json);
        this.y_axis_right.init(this.obs.get_y_range(false), json);
      };
      main.prototype.die = function() {
        this.obs.die();
        this.obs = null;

        if (this.tooltip != null) this.tooltip.die();

        if (this.x_legend != null) this.x_legend.die();
        if (this.y_legend != null) this.y_legend.die();
        if (this.y_legend_2 != null) this.y_legend_2.die();
        if (this.y_axis != null) this.y_axis.die();
        if (this.y_axis_right != null) this.y_axis_right.die();
        if (this.x_axis != null) this.x_axis.die();
        if (this.keys != null) this.keys.die();
        if (this.title != null) this.title.die();
        if (this.radar_axis != null) this.radar_axis.die();
        if (this.background != null) this.background.die();

        this.tooltip = null;
        this.x_legend = null;
        this.y_legend = null;
        this.y_legend_2 = null;
        this.y_axis = null;
        this.y_axis_right = null;
        this.x_axis = null;
        this.keys = null;
        this.title = null;
        this.radar_axis = null;
        this.background = null;

        while (this.numChildren > 0)
          this.removeChildAt(0);

        if (this.hasEventListener(MouseEvent.MOUSE_MOVE))
          this.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMove);

        // do not force a garbage collection, it is not supported:
        // http://stackoverflow.com/questions/192373/force-garbage-collection-in-as3

      };
      main.prototype.build_right_click_menu = function() {

        var cm = new ContextMenu();
        cm.addEventListener(ContextMenuEvent.MENU_SELECT, this.onContextMenuHandler);
        cm.hideBuiltInItems();

        // OFC CREDITS
        var fs = new ContextMenuItem("Charts by Open Flash Chart [Version " + this.VERSION + "]");
        fs.addEventListener(
          ContextMenuEvent.MENU_ITEM_SELECT,
          function doSomething(e) {
            var url = "http://teethgrinder.co.uk/open-flash-chart-2/";
            var request = new URLRequest(url);
            flash.net.navigateToURL(request, '_blank');
          });
        cm.customItems.push(fs);

        var save_image_message = (this.chart_parameters['save_image_message']) ? this.chart_parameters['save_image_message'] : 'Save Image Locally';

        var dl = new ContextMenuItem(save_image_message);
        dl.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.saveImage);
        cm.customItems.push(dl);

        this.contextMenu = cm;
      }

      module.exports = main;
    };
    Program["NumberFormat"] = function(module, exports) {
      var NumberFormat, object_helper, Parser;
      module.inject = function() {
        NumberFormat = module.import('', 'NumberFormat');
        object_helper = module.import('', 'object_helper');
        Parser = module.import('', 'Parser');
        NumberFormat.DEFAULT_NUM_DECIMALS = 2;
        NumberFormat._instance = null;
        NumberFormat._instanceY2 = null;
      };

      var NumberFormat = function(numDecimals, isFixedNumDecimalsForced, isDecimalSeparatorComma, isThousandSeparatorDisabled) {
        this.numDecimals = Parser.getNumberValue(numDecimals, NumberFormat.DEFAULT_NUM_DECIMALS, true, false);
        this.isFixedNumDecimalsForced = Parser.getBooleanValue(isFixedNumDecimalsForced, false);
        this.isDecimalSeparatorComma = Parser.getBooleanValue(isDecimalSeparatorComma, false);
        this.isThousandSeparatorDisabled = Parser.getBooleanValue(isThousandSeparatorDisabled, false);
      };

      NumberFormat.DEFAULT_NUM_DECIMALS = 2;
      NumberFormat._instance = null;
      NumberFormat.getInstance = function(json) {
        if (NumberFormat._instance == null) {
          //        if (lv==undefined ||  lv == null){
          //          lv=_root.lv;
          //        }

          var o = {
            num_decimals: 2,
            is_fixed_num_decimals_forced: 0,
            is_decimal_separator_comma: 0,
            is_thousand_separator_disabled: 0
          };

          object_helper.merge_2(json, o);

          NumberFormat._instance = new NumberFormat(
            o.num_decimals,
            o.is_fixed_num_decimals_forced == 1,
            o.is_decimal_separator_comma == 1,
            o.is_thousand_separator_disabled == 1
          );
          //       trace ("getInstance NEW!!!!");
          //       trace (_instance.numDecimals);
          //       trace (_instance.isFixedNumDecimalsForced);
          //       trace (_instance.isDecimalSeparatorComma);
          //       trace (_instance.isThousandSeparatorDisabled);
        } else {
          //trace ("getInstance found");
        }
        return NumberFormat._instance;
      };
      NumberFormat._instanceY2 = null;
      NumberFormat.getInstanceY2 = function(json) {
        if (NumberFormat._instanceY2 == null) {
          //        if (lv==undefined ||  lv == null){
          //          lv=_root.lv;
          //        }

          var o = {
            num_decimals: 2,
            is_fixed_num_decimals_forced: 0,
            is_decimal_separator_comma: 0,
            is_thousand_separator_disabled: 0
          };

          object_helper.merge_2(json, o);

          NumberFormat._instanceY2 = new NumberFormat(
            o.num_decimals,
            o.is_fixed_num_decimals_forced == 1,
            o.is_decimal_separator_comma == 1,
            o.is_thousand_separator_disabled == 1
          );

          //trace ("getInstanceY2 NEW!!!!");
        } else {
          //trace ("getInstanceY2 found");
        }
        return NumberFormat._instanceY2;
      };

      NumberFormat.prototype.numDecimals = DEFAULT_NUM_DECIMALS;
      NumberFormat.prototype.isFixedNumDecimalsForced = false;
      NumberFormat.prototype.isDecimalSeparatorComma = false;
      NumberFormat.prototype.isThousandSeparatorDisabled = false

      module.exports = NumberFormat;
    };
    Program["NumberUtils"] = function(module, exports) {
      var NumberFormat, NumberUtils;
      module.inject = function() {
        NumberFormat = module.import('', 'NumberFormat');
        NumberUtils = module.import('', 'NumberUtils');
      };

      var NumberUtils = function NumberUtils() {};

      NumberUtils.formatNumber = function(i) {
        var format = NumberFormat.getInstance(null);
        return NumberUtils.format(i,
          format.numDecimals,
          format.isFixedNumDecimalsForced,
          format.isDecimalSeparatorComma,
          format.isThousandSeparatorDisabled
        );
      };
      NumberUtils.formatNumberY2 = function(i) {
        var format = NumberFormat.getInstanceY2(null);
        return NumberUtils.format(i,
          format.numDecimals,
          format.isFixedNumDecimalsForced,
          format.isDecimalSeparatorComma,
          format.isThousandSeparatorDisabled
        );
      };
      NumberUtils.format = function(i, numDecimals, isFixedNumDecimalsForced, isDecimalSeparatorComma, isThousandSeparatorDisabled) {
        if (isNaN(numDecimals)) {
          numDecimals = 4;
        }

        // round the number down to the number of
        // decimals we want ( fixes the -1.11022302462516e-16 bug)
        i = Math.round(i * Math.pow(10, numDecimals)) / Math.pow(10, numDecimals);

        var s = '';
        var num;
        if (i < 0)
          num = String(-i).split('.');
        else
          num = String(i).split('.');

        //trace ("a: " + num[0] + ":" + num[1]);
        var x = num[0];
        var pos = 0;
        var c = 0;
        for (c = x.length - 1; c > -1; c--) {
          if (pos % 3 == 0 && s.length > 0) {
            s = ',' + s;
            pos = 0;
          }
          pos++;

          s = x.substr(c, 1) + s;
        }
        if (num[1] != undefined) {
          if (isFixedNumDecimalsForced) {
            num[1] += "0000000000000000";
          }
          s += '.' + num[1].substr(0, numDecimals);
        } else {
          if (isFixedNumDecimalsForced && numDecimals > 0) {
            num[1] = "0000000000000000";
            s += '.' + num[1].substr(0, numDecimals);
          }

        }

        if (i < 0)
          s = '-' + s;

        if (isThousandSeparatorDisabled) {
          s = s.replace(",", "");
        }

        if (isDecimalSeparatorComma) {
          s = NumberUtils.toDecimalSeperatorComma(s);
        }
        return s;
      };
      NumberUtils.toDecimalSeperatorComma = function(value) {
        return value
          .replace(".", "|")
          .replace(",", ".")
          .replace("|", ",")
      };

      module.exports = NumberUtils;
    };
    Program["object_helper"] = function(module, exports) {
      var object_helper = function object_helper() {};

      object_helper.merge = function(o, defaults) {

        for (var prop in defaults) {
          if (o[prop] == undefined)
            o[prop] = defaults[prop];
        }
        return o;
      };
      object_helper.merge_2 = function(json, defaults) {

        for (var prop in json) {

          // tr.ace( prop +' = ' + json[prop]);
          defaults[prop] = json[prop];
        }
      };

      module.exports = object_helper;
    };
    Program["Parser"] = function(module, exports) {
      var Parser;
      module.inject = function() {
        Parser = module.import('', 'Parser');
      };

      var Parser = function Parser() {};

      Parser.isEmptyValue = function(value) {
        //      if( value == undefined || value == null ) {
        //        return true;
        //      }  else {
        return false;
        //      }
      };
      Parser.getStringValue = function(value, defaultValue, isEmptyStringValid) {

        //defaultValue if not defined - set to empty String
        if (Parser.isEmptyValue(defaultValue)) {
          defaultValue = "";
        }

        //for undefined / null - return defaultValue
        if (Parser.isEmptyValue(value)) {
          return defaultValue;
        }

        if (!isEmptyStringValid && value.length == 0) {
          return defaultValue;
        }

        return String(value);
      };
      Parser.getNumberValue = function(value, defaultValue, isZeroValueValid, isNegativeValueValid) {

        //defaultValue if not defined - set to zero
        if (Parser.isEmptyValue(defaultValue) || isNaN(defaultValue)) {
          defaultValue = 0;
        }

        //for undefined / null - return defaultValue
        if (Parser.isEmptyValue(value)) {
          return defaultValue;
        }

        var numValue = Number(value);
        if (isNaN(numValue)) {
          return defaultValue;
        }

        if (!isZeroValueValid && numValue == 0) {
          return defaultValue;
        }

        if (!isNegativeValueValid && numValue < 0) {
          return defaultValue;
        }

        return numValue;

      };
      Parser.getBooleanValue = function(value, defaultValue) {

        if (Parser.isEmptyValue(value)) {
          return defaultValue;
        }

        var numValue = Number(value);
        if (!isNaN(numValue)) {
          //for numeric value then 0 is false, everything else is true
          if (numValue == 0) {
            return false;
          } else {
            return true;
          }
        }

        //parse string falue 'true' -> true; else false
        var strValue = Parser.getStringValue(value, "false", false);
        //trace ("0------------------" + strValue);
        strValue = strValue.toLowerCase();
        //trace ("1------------------" + strValue);    
        if (strValue.indexOf('true') != -1) {
          return true;
        } else {
          return false;
        }

      };
      Parser.runTests = function() {
        var notDefinedNum;
        trace("testing Parser.getStringValue...");
        trace("1) stringOK  '" + Parser.getStringValue("stringOK", "myDefault", true) + "'");
        trace("2) ''        '" + Parser.getStringValue("", "myDefault", true) + "'");
        trace("3) myDefault '" + Parser.getStringValue("", "myDefault", false) + "'");
        //      trace("4) ''        '" + Parser.getStringValue(notDefinedNum) + "'");
        //      trace("5) 999       '" + Parser.getStringValue(999) + "'");

        trace("testing Parser.getNumberValue...");
        trace("01) 999       '" + Parser.getNumberValue(999, 22222222, true, true) + "'");
        trace("02) 999       '" + Parser.getNumberValue("999", 22222222, true, true) + "'");
        //      trace("03) 999       '" + Parser.getNumberValue("999") + "'");
        //      trace("04) 0         '" + Parser.getNumberValue("abc") + "'");
        //      trace("05) -1        '" + Parser.getNumberValue("abc",-1) + "'");
        trace("06) -1        '" + Parser.getNumberValue("abc", -1, false, false) + "'");
        trace("07) -1        '" + Parser.getNumberValue(null, -1, false, false) + "'");
        //      trace("08) 22222222  '" + Parser.getNumberValue(0,22222222) + "'");
        //      trace("09) 0         '" + Parser.getNumberValue(0,22222222,true) + "'");
        //      trace("10) 22222222  '" + Parser.getNumberValue(0,22222222,false) + "'");
        trace("11) 22222222  '" + Parser.getNumberValue(0, 22222222, false, false) + "'");
        trace("12) 22222222  '" + Parser.getNumberValue(-0.1, 22222222, false, false) + "'");
        trace("13) -0.1      '" + Parser.getNumberValue(-0.1, 22222222, false, true) + "'");
        trace("13) 22222222  '" + Parser.getNumberValue("-0.1x", 22222222, false, true) + "'");

        trace("testing Parser.getBooleanValue...");
        trace("true       '" + Parser.getBooleanValue("1", false) + "'");
        trace("true       '" + Parser.getBooleanValue("-1", false) + "'");
        trace("false      '" + Parser.getBooleanValue("0.000", false) + "'");
        trace("false      '" + Parser.getBooleanValue("", false) + "'");
        trace("true       '" + Parser.getBooleanValue("", true) + "'");
        trace("false      '" + Parser.getBooleanValue("false", false) + "'");
        trace("false      '" + Parser.getBooleanValue("xxx", false) + "'");
        trace("true      '" + Parser.getBooleanValue("true", true) + "'");
        trace("true      '" + Parser.getBooleanValue("TRUE", true) + "'");
        trace("true      '" + Parser.getBooleanValue(" TRUE ", true) + "'");
      };

      module.exports = Parser;
    };
    Program["PointCandle"] = function(module, exports) {
      var Point = module.import('charts.series.dots', 'Point');

      var PointCandle = function(x, high, open, close, low, tooltip, width) {
        Point.call(this, x, high);

        this.width = width;
        this.high = high;
        this.open = open;
        this.close = close;
        this.low = low;
      };

      PointCandle.prototype = Object.create(Point.prototype);

      PointCandle.prototype.width = 0;
      PointCandle.prototype.bar_bottom = 0;
      PointCandle.prototype.high = 0;
      PointCandle.prototype.open = 0;
      PointCandle.prototype.close = 0;
      PointCandle.prototype.low = 0;
      PointCandle.prototype.make_tooltip = function(tip, key, val, x_legend, x_axis_label, tip_set) {

        Point.prototype.make_tooltip.call(this, tip, key, val, x_legend, x_axis_label, tip_set);
        //      Point.prototype.make_tooltip.call(this,  tip, key, val.open, x_legend, x_axis_label, tip_set );
        //      
        //      var tmp = this.tooltip;
        //      tmp = tmp.replace('#high#',NumberUtils.formatNumber(val.high));
        //      tmp = tmp.replace('#open#',NumberUtils.formatNumber(val.open));
        //      tmp = tmp.replace('#close#',NumberUtils.formatNumber(val.close));
        //      tmp = tmp.replace('#low#',NumberUtils.formatNumber(val.low));

        //      this.tooltip = tmp;
      };
      PointCandle.prototype.get_tip_pos = function() {
        return {
          x: this.x + (this.width / 2),
          y: this.y
        };
      }

      module.exports = PointCandle;
    };
    Program["PointHLC"] = function(module, exports) {
      var PointHLC = function(x, high, close, low, tooltip, width) {
        //null.call(this,  x, high );

        this.width = width;
        this.high = high;
        this.close = close;
        this.low = low;
      };

      PointHLC.prototype.width = 0;
      PointHLC.prototype.bar_bottom = 0;
      PointHLC.prototype.high = 0;
      PointHLC.prototype.close = 0;
      PointHLC.prototype.low = 0;
      PointHLC.prototype.make_tooltip = function(tip, key, val, x_legend, x_axis_label, tip_set) {

        null.prototype.make_tooltip.call(this, tip, key, val, x_legend, x_axis_label, tip_set);
        //      null.prototype.make_tooltip.call(this,  tip, key, val.close, x_legend, x_axis_label, tip_set );
        //      
        //      var tmp = this.tooltip;
        //      tmp = tmp.replace('#high#',NumberUtils.formatNumber(val.high));
        //      tmp = tmp.replace('#close#',NumberUtils.formatNumber(val.close));
        //      tmp = tmp.replace('#low#',NumberUtils.formatNumber(val.low));

        //      this.tooltip = tmp;
      };
      PointHLC.prototype.get_tip_pos = function() {
        //return {x:this.x+(this.width/2), y:this.y};
        return null;
      }

      module.exports = PointHLC;
    };
    Program["Properties"] = function(module, exports) {
      var tr, Utils;
      module.inject = function() {
        tr = module.import('', 'tr');
        Utils = module.import('string', 'Utils');
      };

      var Properties = function(json, parent) {
        this._props = null;
        this._parent = null;
        parent = AS3JS.Utils.getDefaultValue(parent, null);

        // Dictionary can use an object as a key
        this._props = new Dictionary();
        this._parent = parent;

        // tr.ace(json);

        for (var prop in json) {

          // tr.ace( prop +' = ' + json[prop]);
          this._props[prop] = json[prop];
        }
      };

      Properties.prototype = Object.create(Object.prototype);

      Properties.prototype._props = null;
      Properties.prototype._parent = null;
      Properties.prototype.get = function(name) {

        // is this key in the dictionary?
        if (name in this._props)
          return this._props[name];

        // test the parent
        if (this._parent != null)
          return this._parent.get(name);

        //
        // key/property not found, report and dump the stack trace
        //
        var e = new Error();
        var str = e.getStackTrace();

        tr.aces('ERROR: property not found', name, str);
        return Number.NEGATIVE_INFINITY;
      };
      Properties.prototype.get_colour = function(name) {
        return Utils.get_colour(this.get(name));
      };
      Properties.prototype.set = function(name, value) {
        this._props[name] = value;
      };
      Properties.prototype.has = function(name) {
        if (this._props[name] == null) {
          if (this._parent != null)
            return this._parent.has(name);
          else
            return false;
        } else
          return true;
      };
      Properties.prototype.set_parent = function(p) {
        if (this._parent != null)
          p.set_parent(this._parent);

        this._parent = p;
      };
      Properties.prototype.die = function() {
        if (this._parent)
          this._parent.die();

        for (var key in this._props) {
          // iterates through each object key
          this._props[key] = null;
        }
        this._parent = null;
      }

      module.exports = Properties;
    };
    Program["Range"] = function(module, exports) {
      var Range = function(min, max, step, offset) {
        this.min = min;
        this.max = max;
        this.step = step;
        this.offset = offset;
      };

      Range.prototype.min = 0;
      Range.prototype.max = 0;
      Range.prototype.step = 0;
      Range.prototype.offset = false;
      Range.prototype.count = function() {
        //
        // range, 5 - 10 = 10 - 5 = 5
        // range -5 - 5 = 5 - -5 = 10
        //
        //
        //  x_offset:
        //
        //   False            True
        //
        //  |               |
        //  |               |
        //  |               |
        //  +--+--+--+      |-+--+--+--+-+
        //  0  1  2  3        0  1  2  3
        //
        // Don't forget this is also used in radar axis
        //
        if (this.offset)
          return (this.max - this.min) + 1;
        else
          return this.max - this.min;
      };
      Range.prototype.toString = function() {
        return 'Range : ' + this.min + ', ' + this.max;
      }

      module.exports = Range;
    };
    Program["ScreenCoords"] = function(module, exports) {
      var ScreenCoordsBase = module.import('', 'ScreenCoordsBase');
      var PointHLC;
      module.inject = function() {
        PointHLC = module.import('', 'PointHLC');
      };

      var ScreenCoords = function(top, left, right, bottom, y_axis_range, y_axis_right_range, x_axis_range, x_left_label_width, x_right_label_width, three_d) {
        this.x_range = null;
        this.y_range = null;
        this.y_right_range = null;
        ScreenCoordsBase.call(this, top, left, right, bottom);

        var tmp_left = left;

        this.x_range = x_axis_range;
        this.y_range = y_axis_range;
        this.y_right_range = y_axis_right_range;

        // tr.ace( '-----' );
        // tr.ace( this.x_range.count() );
        // tr.ace( this.y_range.count() );

        if (this.x_range) {
          right = this.jiggle(left, right, x_right_label_width, x_axis_range.count());
          tmp_left = this.shrink_left(left, right, x_left_label_width, x_axis_range.count());
        }

        this.top = top;
        this.left = Math.max(left, tmp_left);

        // round this down to the nearest int:
        this.right = Math.floor(right);
        this.bottom = bottom;
        this.width = this.right - this.left;
        this.height = bottom - top;

        if (three_d) {
          // tell the box object that the
          // X axis labels need to be offset
          this.tick_offset = 12;
        } else
          this.tick_offset = 0;

        //
        //  x_offset:
        //
        //   False            True
        //
        //  |               |
        //  |               |
        //  |               |
        //  +--+--+--+      |-+--+--+--+-+
        //  0  1  2  3        0  1  2  3
        //

        // PIE charts don't have these:
        if (x_axis_range) {
          this.x_offset = x_axis_range.offset;
        }
        if (y_axis_range) {
          // tr.aces( 'YYYY', y_axis_range.offset );
          this.y_offset = y_axis_range.offset;
        }

        this.bar_groups = 1;
      };

      ScreenCoords.prototype = Object.create(ScreenCoordsBase.prototype);

      ScreenCoords.prototype.x_range = null;
      ScreenCoords.prototype.y_range = null;
      ScreenCoords.prototype.y_right_range = null;
      ScreenCoords.prototype.tick_offset = 0;
      ScreenCoords.prototype.x_offset = false;
      ScreenCoords.prototype.y_offset = false;
      ScreenCoords.prototype.bar_groups = 0;
      ScreenCoords.prototype.jiggle_original = function(left, right, x_label_width, count) {
        var r = 0;

        if (x_label_width != 0) {
          var item_width = (right - left) / count;
          r = right - (item_width / 2);
          var new_right = right;

          // while the right most X label is off the edge of the
          // Stage, move the box.right - 1
          while (r + (x_label_width / 2) > right) {
            new_right -= 1;
            // changing the right also changes the item_width:
            item_width = (new_right - left) / count;
            r = new_right - (item_width / 2);
          }
          right = new_right;
        }
        return right;
      };
      ScreenCoords.prototype.jiggle = function(left, right, x_label_width, count) {
        return right - (x_label_width / 2);
      };
      ScreenCoords.prototype.shrink_left = function(left, right, x_label_width, count) {
        var pos = 0;

        if (x_label_width != 0) {
          var item_width = (right - left) / count;
          pos = left + (item_width / 2);
          var new_left = left;

          // while the left most label is hanging off the Stage
          // move the box.left in one pixel:
          while (pos - (x_label_width / 2) < 0) {
            new_left += 1;
            // changing the left also changes the item_width:
            item_width = (right - new_left) / count;
            pos = new_left + (item_width / 2);
          }
          left = new_left;
        }

        return left;

      };
      ScreenCoords.prototype.get_y_bottom = function(right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);
        //
        // may have min=10, max=20, or
        // min = 20, max = -20 (upside down chart)
        //
        var r = right_axis ? this.y_right_range : this.y_range;

        var min = r.min;
        var max = r.max;
        min = Math.min(min, max);

        return this.get_y_from_val(Math.max(0, min), right_axis);
      };
      ScreenCoords.prototype.getY_old = function(i, right_axis) {
        var r = right_axis ? this.y_right_range : this.y_range;

        var steps = this.height / (r.count()); // ( right_axis ));

        // find Y pos for value=zero
        var y = this.bottom - (steps * (r.min * -1));

        // move up (-Y) to our point (don't forget that y_min will shift it down)
        y -= i * steps;
        return y;
      };
      ScreenCoords.prototype.get_y_from_val = function(i, right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);

        var r = right_axis ? this.y_right_range : this.y_range;

        var steps = this.height / r.count();

        // tr.ace( 'off' );
        // tr.ace( this.y_offset.offset );
        // tr.ace( count );

        var tmp = 0;
        if (this.y_offset)
          tmp = (steps / 2);

        // move up (-Y) to our point (don't forget that y_min will shift it down)
        return this.bottom - tmp - (r.min - i) * steps * -1;
      };
      ScreenCoords.prototype.get_get_x_from_pos_and_y_from_val = function(index, y, right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);

        return new flash.geom.Point(
          this.get_x_from_pos(index),
          this.get_y_from_val(y, right_axis));
      };
      ScreenCoords.prototype.width_ = function() {
        return this.right - this.left_();
      };
      ScreenCoords.prototype.left_ = function() {
        var padding_left = this.tick_offset;
        return this.left + padding_left;
      };
      ScreenCoords.prototype.get_x_from_val = function(i) {
        // Patch from DZ:
        var rev = this.x_range.min > this.x_range.max;
        var count = this.x_range.count();
        count += (rev && this.x_range.offset) ? -2 : 0;
        var item_width = this.width_() / count;
        // end DZ

        var pos = i - this.x_range.min;

        var tmp = 0;
        if (this.x_offset)
          tmp = Math.abs(item_width / 2);

        return this.left_() + tmp + (pos * item_width);
      };
      ScreenCoords.prototype.get_x_from_pos = function(i) {
        // DZ:
        //      var item_width = Math.abs(this.width_() / this.x_range.count());
        var rev = this.x_range.min > this.x_range.max;
        var count = this.x_range.count();
        count += (rev && this.x_range.offset) ? -2 : 0;
        var item_width = Math.abs(this.width_() / count);

        var tmp = 0;
        if (this.x_offset)
          tmp = (item_width / 2);

        return this.left_() + tmp + (i * item_width);
      };
      ScreenCoords.prototype.get_x_tick_pos = function(i) {
        return this.get_x_from_pos(i) - this.tick_offset;
      };
      ScreenCoords.prototype.set_bar_groups = function(n) {
        this.bar_groups = n;
      };
      ScreenCoords.prototype.get_bar_coords = function(index, group) {
        var item_width = this.width_() / this.x_range.count();

        // the bar(s) have gaps between them:
        var bar_set_width = item_width * 0.8;

        // get the margin between sets of bars:
        var tmp = 0;
        if (this.x_offset)
          tmp = item_width;

        // 1 bar == 100% wide, 2 bars = 50% wide each
        var bar_width = bar_set_width / this.bar_groups;
        //bar_width -= 0.001;    // <-- hack so bars don't quite touch

        var bar_left = this.left_() + ((tmp - bar_set_width) / 2);
        var left = bar_left + (index * item_width);
        left += bar_width * group;

        return {
          x: left,
          width: bar_width
        };
      };
      ScreenCoords.prototype.get_horiz_bar_coords = function(index, group) {

        // split the height into equal heights for each bar
        var bar_width = this.height / this.y_range.count();

        // the bar(s) have gaps between them:
        var bar_set_width = bar_width * 0.8;

        // 1 bar == 100% wide, 2 bars = 50% wide each
        var group_width = bar_set_width / this.bar_groups;

        var bar_top = this.top + ((bar_width - bar_set_width) / 2);
        var top = bar_top + (index * bar_width);
        top += group_width * group;

        return {
          y: top,
          width: group_width
        };
      };
      ScreenCoords.prototype.makePointHLC = function(x, high, close, low, right_axis, group, group_count) {

        var item_width = this.width_() / this.x_range.count();
        // the bar(s) have gaps between them:
        var bar_set_width = item_width * 1;

        // get the margin between sets of bars:
        var bar_left = this.left_() + ((item_width - bar_set_width) / 2);
        // 1 bar == 100% wide, 2 bars = 50% wide each
        var bar_width = bar_set_width / group_count;

        var left = bar_left + (x * item_width);
        left += bar_width * group;

        return new PointHLC(
          left,
          this.get_y_from_val(high, right_axis),
          this.get_y_from_val(close, right_axis),
          this.get_y_from_val(low, right_axis),
          high,
          bar_width
          //        ,close
        );

      }

      module.exports = ScreenCoords;
    };
    Program["ScreenCoordsBase"] = function(module, exports) {
      var ScreenCoordsBase = function(top, left, right, bottom) {

        this.top = top;
        this.left = left;
        this.right = right;
        this.bottom = bottom;

        this.width = this.right - this.left;
        this.height = bottom - top;
      };

      ScreenCoordsBase.prototype.top = 0;
      ScreenCoordsBase.prototype.left = 0;
      ScreenCoordsBase.prototype.right = 0;
      ScreenCoordsBase.prototype.bottom = 0;
      ScreenCoordsBase.prototype.width = 0;
      ScreenCoordsBase.prototype.height = 0;
      ScreenCoordsBase.prototype.get_center_x = function() {
        return (this.width / 2) + this.left;
      };
      ScreenCoordsBase.prototype.get_center_y = function() {
        return (this.height / 2) + this.top;
      };
      ScreenCoordsBase.prototype.get_y_from_val = function(i, right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);
        return -1;
      };
      ScreenCoordsBase.prototype.get_x_from_val = function(i) {
        return -1;
      };
      ScreenCoordsBase.prototype.get_get_x_from_pos_and_y_from_val = function(index, y, right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);
        return null;
      };
      ScreenCoordsBase.prototype.get_y_bottom = function(right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);
        return -1;
      };
      ScreenCoordsBase.prototype.get_x_from_pos = function(i) {
        return -1;
      }

      module.exports = ScreenCoordsBase;
    };
    Program["ScreenCoordsRadar"] = function(module, exports) {
      var ScreenCoordsBase = module.import('', 'ScreenCoordsBase');

      var ScreenCoordsRadar = function(top, left, right, bottom) {
        this.range = null;

        ScreenCoordsBase.call(this, top, left, right, bottom);

        //
        // if the radar chart has labels this is going to
        // get updated so they fit onto the screen
        //
        this.radius = (Math.min(this.width, this.height) / 2.0);
      };

      ScreenCoordsRadar.prototype = Object.create(ScreenCoordsBase.prototype);

      ScreenCoordsRadar.prototype.TO_RADIANS = Math.PI / 180;
      ScreenCoordsRadar.prototype.range = null;
      ScreenCoordsRadar.prototype.angles = 0;
      ScreenCoordsRadar.prototype.angle = 0;
      ScreenCoordsRadar.prototype.radius = 0;
      ScreenCoordsRadar.prototype.set_range = function(r) {
        this.range = r;
      };
      ScreenCoordsRadar.prototype.get_max = function() {
        return this.range.max;
      };
      ScreenCoordsRadar.prototype.set_angles = function(a) {
        this.angles = a;
        this.angle = 360 / a;
      };
      ScreenCoordsRadar.prototype.get_angles = function() {
        return this.angles;
      };
      ScreenCoordsRadar.prototype.get_radius = function() {

        return this.radius;
      };
      ScreenCoordsRadar.prototype.reduce_radius = function() {
        this.radius--;
      };
      ScreenCoordsRadar.prototype.get_pos = function(angle, radius) {

        // flash assumes 0 degrees is horizontal to the right
        var a = (angle - 90) * this.TO_RADIANS;
        var r = this.get_radius() * radius;

        var p = new flash.geom.Point(
          r * Math.cos(a),
          r * Math.sin(a));

        return p;
      };
      ScreenCoordsRadar.prototype.get_get_x_from_pos_and_y_from_val = function(index, y, right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);

        // rotate
        var p = this.get_pos(this.angle * index, y / this.range.count());

        // translate
        p.x += this.get_center_x();
        p.y += this.get_center_y();

        return p;
      };
      ScreenCoordsRadar.prototype.get_y_from_val = function(y, right_axis) {
        right_axis = AS3JS.Utils.getDefaultValue(right_axis, false);

        // rotate
        var p = this.get_pos(0, y / this.range.count());

        // translate
        p.y += this.get_center_y();

        return p.y;
      }

      module.exports = ScreenCoordsRadar;
    };
    Program["ShowTipEvent"] = function(module, exports) {
      var ShowTipEvent;
      module.inject = function() {
        ShowTipEvent = module.import('', 'ShowTipEvent');
        ShowTipEvent.SHOW_TIP_TYPE = "ShowTipEvent";
      };

      var ShowTipEvent = function(pos) {
        flash.call(this, ShowTipEvent.SHOW_TIP_TYPE);
        this.pos = pos;
      };

      ShowTipEvent.prototype = Object.create(flash.prototype);

      ShowTipEvent.SHOW_TIP_TYPE = null;

      ShowTipEvent.prototype.pos = 0

      module.exports = ShowTipEvent;
    };
    Program["Tooltip"] = function(module, exports) {
      var object_helper, Tooltip, tr, Css, Utils, Equations, Tweener;
      module.inject = function() {
        object_helper = module.import('', 'object_helper');
        Tooltip = module.import('', 'Tooltip');
        tr = module.import('', 'tr');
        Css = module.import('string', 'Css');
        Utils = module.import('string', 'Utils');
        Equations = module.import('caurina.transitions', 'Equations');
        Tweener = module.import('caurina.transitions', 'Tweener');
        Tooltip.CLOSEST = 0;
        Tooltip.PROXIMITY = 1;
        Tooltip.NORMAL = 2;
      };

      var Tooltip = function(json) {
        this.style = null;
        this.cached_elements = null;
        //
        // we don't want mouseOver events for the
        // tooltip or any children (the text fields)
        //
        this.mouseEnabled = false;
        this.tip_showing = false;

        this.style = {
          shadow: true,
          rounded: 6,
          stroke: 2,
          colour: '#808080',
          background: '#f0f0f0',
          title: "color: #0000F0; font-weight: bold; font-size: 12;",
          body: "color: #000000; font-weight: normal; font-size: 12;",
          mouse: Tooltip.CLOSEST,
          text: "_default"
        };

        if (json) {
          this.style = object_helper.merge(json, this.style);
        }

        this.style.colour = Utils.get_colour(this.style.colour);
        this.style.background = Utils.get_colour(this.style.background);
        this.style.title = new Css(this.style.title);
        this.style.body = new Css(this.style.body);

        this.tip_style = this.style.mouse;
        this.tip_text = this.style.text;
        this.cached_elements = [];

        if (this.style.shadow == 1) {
          var dropShadow = new flash.filters.DropShadowFilter();
          dropShadow.blurX = 4;
          dropShadow.blurY = 4;
          dropShadow.distance = 4;
          dropShadow.angle = 45;
          dropShadow.quality = 2;
          dropShadow.alpha = 0.5;
          // apply shadow filter
          this.filters = [dropShadow];
        }
      };

      Tooltip.prototype = Object.create(Sprite.prototype);

      Tooltip.CLOSEST = 0;
      Tooltip.PROXIMITY = 1;
      Tooltip.NORMAL = 2;

      Tooltip.prototype.style = null;
      Tooltip.prototype.tip_style = 0;
      Tooltip.prototype.cached_elements = null;
      Tooltip.prototype.tip_showing = false;
      Tooltip.prototype.tip_text = null;
      Tooltip.prototype.make_tip = function(elements) {

        this.graphics.clear();

        while (this.numChildren > 0)
          this.removeChildAt(0);

        var height = 0;
        var x = 5;

        for each(var e in elements) {

          var o = this.make_one_tip(e, x);
          height = Math.max(height, o.height);
          x += o.width + 2;
        }

        this.graphics.lineStyle(this.style.stroke, this.style.colour, 1);
        this.graphics.beginFill(this.style.background, 1);

        this.graphics.drawRoundRect(
          0, 0,
          width + 10, height + 5,
          this.style.rounded, this.style.rounded);
      };
      Tooltip.prototype.make_one_tip = function(e, x) {

        var tt = e.get_tooltip();
        var lines = tt.split('<br>');

        var top = 5;
        var width = 0;

        if (lines.length > 1) {

          var title = this.make_title(lines.shift());
          title.mouseEnabled = false;
          title.x = x;
          title.y = top;
          top += title.height;
          width = title.width;

          this.addChild(title);
        }

        var text = this.make_body(lines.join('\n'));
        text.mouseEnabled = false;
        text.x = x;
        text.y = top;
        width = Math.max(width, text.width);
        this.addChild(text);

        top += text.height;
        return {
          width: width,
          height: top
        };
      };
      Tooltip.prototype.make_title = function(text) {

        var title = new TextField();
        title.mouseEnabled = false;

        title.htmlText = text;
        /*
         * 
         * Start thinking about just using html formatting 
         * instead of text format below.  We could do away
         * with the title textbox entirely and let the user
         * use:
         * <b>title stuff</b><br>Here is the value
         * 
         */
        var fmt = new TextFormat();
        fmt.color = this.style.title.color;
        fmt.font = "Verdana";
        fmt.bold = (this.style.title.font_weight == "bold");
        fmt.size = this.style.title.font_size;
        fmt.align = "right";
        title.setTextFormat(fmt);
        title.autoSize = "left";

        return title;
      };
      Tooltip.prototype.make_body = function(body) {

        var text = new TextField();
        text.mouseEnabled = false;

        text.htmlText = body;
        var fmt2 = new TextFormat();
        fmt2.color = this.style.body.color;
        fmt2.font = "Verdana";
        fmt2.bold = (this.style.body.font_weight == "bold");
        fmt2.size = this.style.body.font_size;
        fmt2.align = "left";
        text.setTextFormat(fmt2);
        text.autoSize = "left";

        return text;
      };
      Tooltip.prototype.get_pos = function(e) {

        var pos = e.get_tip_pos();

        var x = (pos.x + this.width + 16) > this.stage.stageWidth ? (this.stage.stageWidth - this.width - 16) : pos.x;

        var y = pos.y;
        y -= 4;
        y -= (this.height + 10); // 10 == border size

        if (y < 0) {
          // the tooltip has drifted off the top of the screen, move it down:
          y = 0;
        }
        return new flash.geom.Point(x, y);
      };
      Tooltip.prototype.show_tip = function(e) {

        // remove the 'hide' tween
        Tweener.removeTweens(this);
        var p = this.get_pos(e);

        if (this.style.mouse == Tooltip.CLOSEST) {
          //
          // make the tooltip appear (if invisible)
          // and shoot to the correct position
          //
          this.visible = true;
          this.alpha = 1
          this.x = p.x;
          this.y = p.y;
        } else {
          // make the tooltip fade in gently
          this.tip_showing = true;

          tr.ace('show');
          this.alpha = 0
          this.visible = true;
          this.x = p.x;
          this.y = p.y;
          Tweener.addTween(
            this, {
              alpha: 1,
              time: 0.4,
              transition: Equations.easeOutExpo
            });
        }
      };
      Tooltip.prototype.draw = function(e) {

        if (this.cached_elements[0] == e) {
          // if the tip is showing, don't make it 
          // show again because this makes it flicker
          if (!this.tip_showing)
            this.show_tip(e);
        } else {

          // this is a new tooltip, tell
          // the old highlighted item to
          // return to ground state
          this.untip();

          // get the new text and recreate it
          this.cached_elements = [e];

          this.make_tip([e]);
          this.show_tip(e);
        }
      };
      Tooltip.prototype.closest = function(elements) {

        if (elements.length == 0)
          return;

        if (this.is_cached(elements))
          return;

        this.untip();
        this.cached_elements = elements;
        this.tip();

        //
        //tr.ace( 'make new tooltip' );
        //tr.ace( Math.random() );
        //

        this.make_tip(elements);

        var p = this.get_pos(elements[0]);

        this.visible = true;

        Tweener.addTween(this, {
          x: p.x,
          time: 0.3,
          transition: Equations.easeOutExpo
        });
        Tweener.addTween(this, {
          y: p.y,
          time: 0.3,
          transition: Equations.easeOutExpo
        });
      };
      Tooltip.prototype.is_cached = function(elements) {

        if (this.cached_elements.length == 0)
          return false;

        for each(var e in elements)
        if (this.cached_elements.indexOf(e) == -1)
          return false;

        return true;
      };
      Tooltip.prototype.untip = function() {
        for each(var e in this.cached_elements)
        e.set_tip(false);
      };
      Tooltip.prototype.tip = function() {
        for each(var e in this.cached_elements)
        e.set_tip(true);
      };
      Tooltip.prototype.hideAway = function() {
        this.visible = false;
        this.untip();
        this.cached_elements = [];
        this.alpha = 1;
      };
      Tooltip.prototype.hide = function() {
        this.tip_showing = false;
        tr.ace('hide tooltip');
        Tweener.addTween(this, {
          alpha: 0,
          time: 0.6,
          transition: Equations.easeOutExpo,
          onComplete: this.hideAway
        });
      };
      Tooltip.prototype.get_tip_style = function() {
        return this.tip_style;
      };
      Tooltip.prototype.set_tip_style = function(i) {
        this.tip_style = i;
      };
      Tooltip.prototype.die = function() {

        this.filters = [];
        this.graphics.clear();

        while (this.numChildren > 0)
          this.removeChildAt(0);

        this.style = null;
        this.cached_elements = null;
      }

      module.exports = Tooltip;
    };
    Program["tr"] = function(module, exports) {
      var tr, FlashConnect;
      module.inject = function() {
        tr = module.import('', 'tr');
        FlashConnect = module.import('org.flashdevelop.utils', 'FlashConnect');
      };

      var tr = function tr() {};

      tr.ace = function(o) {
        if (o == null)
          FlashConnect.trace('null');
        else
          FlashConnect.trace(o.toString());

        // var tempError = new Error();
        // var stackTrace = tempError.getStackTrace();
        // FlashConnect.trace( 'stackTrace:' + stackTrace );

        if (false)
          tr.trace_full();
      };
      tr.aces = function(optionalArgs) {

        var tmp = [];
        for each(var o in optionalArgs) {
          // FlashConnect.trace( o.toString() );
          if (o == null)
            tmp.push('null');
          else
            tmp.push(o.toString());
        }

        FlashConnect.trace(tmp.join(', '));
      };
      tr.ace_full = function(snum) {
        snum = AS3JS.Utils.getDefaultValue(snum, 3);
        // FROM:
        // http://snippets.dzone.com/posts/show/3703
        //----------------------------------------------------------------------------------------------------------------
        // With debugging turned on, this is what we get:
        //
        // Error
        // <tab>at com.flickaway::Trace$/log_full()[D:\web\flickaway_branch\flash\lib\com\flickaway\Trace.as:83]
        // <tab>at com.flickaway::Trace$/print_r_full()[D:\web\flickaway_branch\flash\lib\com\flickaway\Trace.as:114]
        // <tab>at com.flickaway::Trace$/print_r()[D:\web\flickaway_branch\flash\lib\com\flickaway\Trace.as:46]
        // <tab>at com.flickaway::Params()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:36]                <==== this line we want
        // <tab>at com.flickaway::Params$/get_instance()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:27]
        // <tab>at HomeDefault()[D:\web\flickaway_branch\flash\homepage\HomeDefault.as:57]
        // <tab>at com.flickaway::Params()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:36])
        //
        // with debugging turned off:
        //
        // Error
        // <tab>at com.flickaway::Trace$/log_full()
        // <tab>at com.flickaway::Trace$/print_r_full()
        // <tab>at com.flickaway::Trace$/print_r()
        // <tab>at com.flickaway::Params()
        // <tab>at com.flickaway::Params$/get_instance()
        // <tab>at HomeDefault()
        //----------------------------------------------------------------------------------------------------------------
        var e = new Error();
        var str = e.getStackTrace(); // get the full text str

        if (str == null) // means we aren't on the Debug player
        {
          FlashConnect.trace("(!debug) ");
        } else {
          var stacks = str.split("\n"); // split into each line
          var caller = tr.gimme_caller(stacks[snum]); // get the caller for just one specific line in the stack trace
          FlashConnect.trace(caller);
        }
      };
      tr.gimme_caller = function(line) {
        //-------------------------------------------------------------------------------------------------
        // the line can look like any of these (so we must be able to clean up all of them):
        //
        // <tab>at com.flickaway::Params()
        // <tab>at com.flickaway::Params()[D:\web\flickaway_branch\flash\lib\com\flickaway\Params.as:36]
        // <tab>at HomeDefault()
        // <tab>at HomeDefault()[D:\web\flickaway_branch\flash\homepage\HomeDefault.as:57]
        //-------------------------------------------------------------------------------------------------
        var dom_pos = line.indexOf("::"); // find the '::' part
        var caller;

        if (dom_pos == -1) {
          caller = line.substr(4); // just remove '<tab>at ' beginning part (4 characters)
        } else {
          caller = line.substr(dom_pos + 2); // remove '<tab>at com.flickaway::' beginning part
        }
        var lb_pos = caller.indexOf("["); // get position of the left bracket (lb)

        if (lb_pos == -1) // if the lb doesn't exist (then we don't have "permit debugging" turned on)
        {
          return "[" + caller + "]";
        } else {
          var line_num = caller.substr(caller.lastIndexOf(":")); // find the line number
          caller = caller.substr(0, lb_pos); // cut it out - it'll look like ":51]"
          return "[" + caller + line_num; // line_num already has the trailing right bracket
        }
      };
      tr.ace_json = function(json) {
        tr.ace(com.serialization.json.JSON.serialize(json));
      };

      module.exports = tr;
    };
    Program["InnerBackground"] = function(module, exports) {
      var InnerBackground = function(lv) {
        if (lv.inner_background == undefined)
          return;

        var vals = lv.inner_background.split(",");

        this.colour = _root.get_colour(vals[0]);

        trace(this.colour)

        if (vals.length > 1)
          this.colour_2 = _root.get_colour(vals[1]);

        if (vals.length > 2)
          this.angle = Number(vals[2]);

        this.mc = _root.createEmptyMovieClip("inner_background", _root.getNextHighestDepth());

        // create shadow filter
        var dropShadow = new flash.filters.DropShadowFilter();
        dropShadow.blurX = 5;
        dropShadow.blurY = 5;
        dropShadow.distance = 5;
        dropShadow.angle = 45;
        dropShadow.quality = 2;
        dropShadow.alpha = 0.5;
        // apply shadow filter

        // disabled for now...
        //this.mc.filters = [dropShadow];

      };

      InnerBackground.prototype = Object.create(Sprite.prototype);

      InnerBackground.prototype.colour = 0;
      InnerBackground.prototype.colour_2 = -1;
      InnerBackground.prototype.angle = 90;
      InnerBackground.prototype.move = function(box) {
        if (this.mc == undefined)
          return;

        this.mc.clear();
        this.mc.lineStyle(1, 0xFFFFFF, 0);

        if (this.colour_2 > -1) {
          // Gradients: http://www.lukamaras.com/tutorials/actionscript/gradient-colored-movie-background-actionscript.html
          var fillType = "linear";
          var colors = [this.colour, this.colour_2];
          var alphas = [100, 100];
          var ratios = [0, 255];
          var matrix = {
            matrixType: "box",
            x: 0,
            y: 0,
            w: box.width,
            h: box.height,
            r: this.angle / 180 * Math.PI
          };
          this.mc.beginGradientFill(fillType, colors, alphas, ratios, matrix);
        } else
          this.mc.beginFill(this.colour, 100);

        this.mc.moveTo(0, 0);
        this.mc.lineTo(box.width, 0);
        this.mc.lineTo(box.width, box.height);
        this.mc.lineTo(0, box.height);
        this.mc.lineTo(0, 0);
        this.mc.endFill();

        this.mc._x = box.left;
        this.mc._y = box.top;
      }

      module.exports = InnerBackground;
    };
    Program["string.Css"] = function(module, exports) {
      var Utils;
      module.inject = function() {
        Utils = module.import('string', 'Utils');
      };

      var Css = function(txt) {
        // To lower case
        txt.toLowerCase();

        // monk.e.boy: remove the { and }
        txt = txt.replace('{', '');
        txt = txt.replace('}', '');

        // monk.e.boy: setup some default values.
        // does this confilct with 'clear()'?
        this.margin_top = 0;
        this.margin_bottom = 0;
        this.margin_left = 0;
        this.margin_right = 0;

        this.padding_top = 0;
        this.padding_bottom = 0;
        this.padding_left = 0;
        this.padding_right = 0;

        this.color = 0;
        this.background_colour_set = false;
        this.font_size = 9;

        // Splitting by the ;
        var arr = txt.split(";");

        // Checking all the types of css params we accept and writing to internal variables of the object class
        for (var i = 0; i < arr.length; i++) {
          this.getAttribute(arr[i]);
        }
      };

      Css.prototype.text_align = null;
      Css.prototype.font_size = 0;
      Css.prototype.text_decoration = null;
      Css.prototype.margin = null;
      Css.prototype.margin_top = 0;
      Css.prototype.margin_bottom = 0;
      Css.prototype.margin_left = 0;
      Css.prototype.margin_right = 0;
      Css.prototype.padding = null;
      Css.prototype.padding_top = 0;
      Css.prototype.padding_bottom = 0;
      Css.prototype.padding_left = 0;
      Css.prototype.padding_right = 0;
      Css.prototype.font_weight = null;
      Css.prototype.font_style = null;
      Css.prototype.font_family = null;
      Css.prototype.color = 0;
      Css.prototype.stop_process = 0;
      Css.prototype.background_colour = 0;
      Css.prototype.background_colour_set = false;
      Css.prototype.display = null;
      Css.prototype.trim = function(txt) {
        var l = 0;
        var r = txt.length - 1;
        while (txt.charAt(l) == ' ' || txt.charAt(l) == "\t") l++;
        while (txt.charAt(r) == ' ' || txt.charAt(r) == "\t") r--;
        return txt.substring(l, r + 1);
      };
      Css.prototype.removeDoubleSpaces = function(txt) {
        var aux;
        var auxPrev;
        aux = txt;
        do {
          auxPrev = aux;
          aux.replace('  ', ' ');
        } while (auxPrev.length != aux.length);
        return aux;
      };
      Css.prototype.ToNumber = function(cad) {

        cad = cad.replace('px', '');

        if (isNaN(Number(cad))) {
          return 0;
        } else {
          return Number(cad);
        }
      };
      Css.prototype.getAttribute = function(txt) {
        var arr = txt.split(":");
        if (arr.length == 2) {
          this.stop_process = 1;
          this.set(arr[0], this.trim(arr[1]));
        }
      };
      Css.prototype.set = function(cad, val) {
        cad = this.trim(cad);

        switch (cad) {
          case "text-align":
            this.text_align = val;
            break;
          case "font-size":
            this.set_font_size(val);
            break;
          case "text-decoration":
            this.text_decoration = val;
            break;

          case "margin":
            this.setMargin(val);
            break;
          case "margin-top":
            this.margin_top = this.ToNumber(val);
            break;
          case "margin-bottom":
            this.margin_bottom = this.ToNumber(val);
            break;
          case "margin-left":
            this.margin_left = this.ToNumber(val);
            break;
          case "margin-right":
            this.margin_right = this.ToNumber(val);
            break;

          case 'padding':
            this.setPadding(val);
            break;
          case "padding-top":
            this.padding_top = this.ToNumber(val);
            break;
          case "padding-bottom":
            this.padding_bottom = this.ToNumber(val);
            break;
          case "padding-left":
            this.padding_left = this.ToNumber(val);
            break;
          case "padding-right":
            this.padding_right = this.ToNumber(val);
            break;

          case "font-weight":
            this.font_weight = val;
            break;
          case "font-style":
            this.font_style = val;
            break;
          case "font-family":
            this.font_family = val;
            break;
          case "color":
            this.set_color(val);
            break;
          case "background-color":
            this.background_colour = Utils.get_colour(val);
            this.background_colour_set = true;
            break;
          case "display":
            this.display = val;
            break;
        }
      };
      Css.prototype.set_color = function(val) {
        this.color = Utils.get_colour(val);
      };
      Css.prototype.set_font_size = function(val) {
        this.font_size = this.ToNumber(val);
      };
      Css.prototype.setPadding = function(val) {

        val = this.trim(val);
        var arr = val.split(' ');

        switch (arr.length) {

          // margin: 30px;
          case 1:
            this.padding_top = this.ToNumber(arr[0]);
            this.padding_right = this.ToNumber(arr[0]);
            this.padding_bottom = this.ToNumber(arr[0]);
            this.padding_left = this.ToNumber(arr[0]);
            break;

            // margin: 15px 5px;
          case 2:
            this.padding_top = this.ToNumber(arr[0]);
            this.padding_right = this.ToNumber(arr[1]);
            this.padding_bottom = this.ToNumber(arr[0]);
            this.padding_left = this.ToNumber(arr[1]);
            break;

            // margin: 15px 5px 10px;
          case 3:
            this.padding_top = this.ToNumber(arr[0]);
            this.padding_right = this.ToNumber(arr[1]);
            this.padding_bottom = this.ToNumber(arr[2]);
            this.padding_left = this.ToNumber(arr[1]);
            break;

            // margin: 1px 2px 3px 4px;
          default:
            this.padding_top = this.ToNumber(arr[0]);
            this.padding_right = this.ToNumber(arr[1]);
            this.padding_bottom = this.ToNumber(arr[2]);
            this.padding_left = this.ToNumber(arr[3]);
        }
      };
      Css.prototype.setMargin = function(val) {

        val = this.trim(val);
        var arr = val.split(' ');

        switch (arr.length) {

          // margin: 30px;
          case 1:
            this.margin_top = this.ToNumber(arr[0]);
            this.margin_right = this.ToNumber(arr[0]);
            this.margin_bottom = this.ToNumber(arr[0]);
            this.margin_left = this.ToNumber(arr[0]);
            break;

            // margin: 15px 5px;
          case 2:
            this.margin_top = this.ToNumber(arr[0]);
            this.margin_right = this.ToNumber(arr[1]);
            this.margin_bottom = this.ToNumber(arr[0]);
            this.margin_left = this.ToNumber(arr[1]);
            break;

            // margin: 15px 5px 10px;
          case 3:
            this.margin_top = this.ToNumber(arr[0]);
            this.margin_right = this.ToNumber(arr[1]);
            this.margin_bottom = this.ToNumber(arr[2]);
            this.margin_left = this.ToNumber(arr[1]);
            break;

            // margin: 1px 2px 3px 4px;
          default:
            this.margin_top = this.ToNumber(arr[0]);
            this.margin_right = this.ToNumber(arr[1]);
            this.margin_bottom = this.ToNumber(arr[2]);
            this.margin_left = this.ToNumber(arr[3]);
        }
      };
      Css.prototype.clear = function() {
        this.text_align = undefined;
        this.font_size = undefined;
        this.text_decoration = undefined;
        this.margin_top = undefined;
        this.margin_bottom = undefined;
        this.margin_left = undefined;
        this.margin_right = undefined;
        this.font_weight = undefined;
        this.font_style = undefined;
        this.font_family = undefined;
        this.color = undefined;
        this.display = undefined;
      }

      module.exports = Css;
    };
    Program["string.DateUtils"] = function(module, exports) {
        module.inject = function() {
          DateUtils.dateConsts = {;
          };

          var DateUtils = function DateUtils() {};

          DateUtils.dateConsts = null;
          DateUtils.replace_magic_values = function(tip, xVal) {
            // convert from a unix timestamp to an AS3 date
            var as3Date = new Date(xVal * 1000);
            tip = tip.replace('#date#', DateUtils.formatDate(as3Date, "Y-m-d"));
            // check for user formatted dates
            var begPtr = tip.indexOf("#date:");
            while (begPtr >= 0) {
              var endPtr = tip.indexOf("#", begPtr + 1) + 1;
              var replaceStr = tip.substr(begPtr, endPtr - begPtr);
              var timeFmt = replaceStr.substr(6, replaceStr.length - 7);
              var dateStr = DateUtils.formatDate(as3Date, timeFmt);
              tip = tip.replace(replaceStr, dateStr);
              begPtr = tip.indexOf("#date:");
            }

            begPtr = tip.indexOf("#gmdate:");
            while (begPtr >= 0) {
              endPtr = tip.indexOf("#", begPtr + 1) + 1;
              replaceStr = tip.substr(begPtr, endPtr - begPtr);
              timeFmt = replaceStr.substr(8, replaceStr.length - 9);
              dateStr = DateUtils.formatUTCDate(as3Date, timeFmt);
              tip = tip.replace(replaceStr, dateStr);
              begPtr = tip.indexOf("#gmdate:");
            }

            return tip;
          };
          DateUtils.formatDate = function(aDate, fmt) {
            var returnStr = '';
            for (var i = 0; i < fmt.length; i++) {
              var curChar = fmt.charAt(i);
              switch (curChar) {
                // day
                case 'd':
                  returnStr += (aDate.getDate() < 10 ? '0' : '') + aDate.getDate();
                  break;
                case 'D':
                  returnStr += DateUtils.dateConsts.shortDays[aDate.getDate()];
                  break;
                case 'j':
                  returnStr += aDate.getDate();
                  break;
                case 'l':
                  returnStr += DateUtils.dateConsts.longDays[aDate.getDay()];
                  break;
                case 'N':
                  returnStr += aDate.getDay() + 1;
                  break;
                case 'S':
                  returnStr += (aDate.getDate() % 10 == 1 && aDate.getDate() != 11 ? 'st' : (aDate.getDate() % 10 == 2 && aDate.getDate() != 12 ? 'nd' : (aDate.getDate() % 10 == 3 && aDate.getDate() != 13 ? 'rd' : 'th')));
                  break;
                case 'w':
                  returnStr += aDate.getDay();
                  break;
                  //z: function() { return "Not Yet Supported"; },

                  // Week
                  //W: function() { return "Not Yet Supported"; },

                  // Month
                case 'F':
                  returnStr += DateUtils.dateConsts.longMonths[aDate.getMonth()];
                  break;
                case 'm':
                  returnStr += (aDate.getMonth() < 9 ? '0' : '') + (aDate.getMonth() + 1);
                  break;
                case 'M':
                  returnStr += DateUtils.dateConsts.shortMonths[aDate.getMonth()];
                  break;
                case 'n':
                  returnStr += aDate.getMonth() + 1;
                  break;
                  //t: function() { return "Not Yet Supported"; },

                  // Year
                  //L: function() { return "Not Yet Supported"; },
                  //o: function() { return "Not Supported"; },
                case 'Y':
                  returnStr += aDate.getFullYear();
                  break;
                case 'y':
                  returnStr += ('' + aDate.getFullYear()).substr(2);
                  break;

                  // Time
                case 'a':
                  returnStr += aDate.getHours() < 12 ? 'am' : 'pm';
                  break;
                case 'A':
                  returnStr += aDate.getHours() < 12 ? 'AM' : 'PM';
                  break;
                  //B: function() { return "Not Yet Supported"; },
                case 'g':
                  returnStr += aDate.getHours() == 0 ? 12 : (aDate.getHours() > 12 ? aDate.getHours() - 12 : aDate.getHours());
                  break;
                case 'G':
                  returnStr += aDate.getHours();
                  break;
                case 'h':
                  returnStr += (aDate.getHours() < 10 || (12 < aDate.getHours() < 22) ? '0' : '') + (aDate.getHours() < 10 ? aDate.getHours() + 1 : aDate.getHours() - 12);
                  break;
                case 'H':
                  returnStr += (aDate.getHours() < 10 ? '0' : '') + aDate.getHours();
                  break;
                case 'i':
                  returnStr += (aDate.getMinutes() < 10 ? '0' : '') + aDate.getMinutes();
                  break;
                case 's':
                  returnStr += (aDate.getSeconds() < 10 ? '0' : '') + aDate.getSeconds();
                  break;

                  // Timezone
                  //e: function() { return "Not Yet Supported"; },
                  //I: function() { return "Not Supported"; },
                case 'O':
                  returnStr += (aDate.getTimezoneOffset() < 0 ? '-' : '+') + (aDate.getTimezoneOffset() / 60 < 10 ? '0' : '') + (aDate.getTimezoneOffset() / 60) + '00';
                  break;
                  //T: function() { return "Not Yet Supported"; },
                case 'Z':
                  returnStr += aDate.getTimezoneOffset() * 60;
                  break;

                  // Full Date/Time
                  //c: function() { return "Not Yet Supported"; },
                case 'r':
                  returnStr += aDate.toString();
                  break;
                case 'U':
                  returnStr += aDate.getTime() / 1000;
                  break;

                default:
                  returnStr += curChar;
              }
            }
            return returnStr;
          };
          DateUtils.formatUTCDate = function(aDate, fmt) {
            var returnStr = '';
            for (var i = 0; i < fmt.length; i++) {
              var curChar = fmt.charAt(i);
              switch (curChar) {
                // day
                case 'd':
                  returnStr += (aDate.getUTCDate() < 10 ? '0' : '') + aDate.getUTCDate();
                  break;
                case 'D':
                  returnStr += DateUtils.dateConsts.shortDays[aDate.getUTCDate()];
                  break;
                case 'j':
                  returnStr += aDate.getUTCDate();
                  break;
                case 'l':
                  returnStr += DateUtils.dateConsts.longDays[aDate.getUTCDay()];
                  break;
                case 'N':
                  returnStr += aDate.getUTCDay() + 1;
                  break;
                case 'S':
                  returnStr += (aDate.getUTCDate() % 10 == 1 && aDate.getUTCDate() != 11 ? 'st' : (aDate.getUTCDate() % 10 == 2 && aDate.getUTCDate() != 12 ? 'nd' : (aDate.getUTCDate() % 10 == 3 && aDate.getUTCDate() != 13 ? 'rd' : 'th')));
                  break;
                case 'w':
                  returnStr += aDate.getUTCDay();
                  break;
                  //z: function() { return "Not Yet Supported"; },

                  // Week
                  //W: function() { return "Not Yet Supported"; },

                  // Month
                case 'F':
                  returnStr += DateUtils.dateConsts.longMonths[aDate.getUTCMonth()];
                  break;
                case 'm':
                  returnStr += (aDate.getUTCMonth() < 9 ? '0' : '') + (aDate.getUTCMonth() + 1);
                  break;
                case 'M':
                  returnStr += DateUtils.dateConsts.shortMonths[aDate.getUTCMonth()];
                  break;
                case 'n':
                  returnStr += aDate.getUTCMonth() + 1;
                  break;
                  //t: function() { return "Not Yet Supported"; },

                  // Year
                  //L: function() { return "Not Yet Supported"; },
                  //o: function() { return "Not Supported"; },
                case 'Y':
                  returnStr += aDate.getUTCFullYear();
                  break;
                case 'y':
                  returnStr += ('' + aDate.getUTCFullYear()).substr(2);
                  break;

                  // Time
                case 'a':
                  returnStr += aDate.getUTCHours() < 12 ? 'am' : 'pm';
                  break;
                case 'A':
                  returnStr += aDate.getUTCHours() < 12 ? 'AM' : 'PM';
                  break;
                  //B: function() { return "Not Yet Supported"; },
                case 'g':
                  returnStr += aDate.getUTCHours() == 0 ? 12 : (aDate.getUTCHours() > 12 ? aDate.getUTCHours() - 12 : aDate.getHours());
                  break;
                case 'G':
                  returnStr += aDate.getUTCHours();
                  break;
                case 'h':
                  returnStr += (aDate.getUTCHours() < 10 || (12 < aDate.getUTCHours() < 22) ? '0' : '') + (aDate.getUTCHours() < 10 ? aDate.getUTCHours() + 1 : aDate.getUTCHours() - 12);
                  break;
                case 'H':
                  returnStr += (aDate.getUTCHours() < 10 ? '0' : '') + aDate.getUTCHours();
                  break;
                case 'i':
                  returnStr += (aDate.getUTCMinutes() < 10 ? '0' : '') + aDate.getUTCMinutes();
                  break;
                case 's':
                  returnStr += (aDate.getUTCSeconds() < 10 ? '0' : '') + aDate.getUTCSeconds();
                  break;

                  // Timezone
                  //e: function() { return "Not Yet Supported"; },
                  //I: function() { return "Not Supported"; },
                case 'O':
                  returnStr += '+0000';
                  break;
                  //T: function() { return "Not Yet Supported"; },
                case 'Z':
                  returnStr += 0;
                  break;

                  // Full Date/Time
                  //c: function() { return "Not Yet Supported"; },
                case 'r':
                  returnStr += aDate.toUTCString();
                  break;
                case 'U':
                  returnStr += aDate.getTime() / 1000;
                  break;

                default:
                  returnStr += curChar;
              }
            }
            return returnStr;
          };

          module.exports = DateUtils;
        };
        Program["string.Utils"] = function(module, exports) {
          var Utils = function() {

          };

          Utils.get_colour = function(col) {
            if (col.substr(0, 2) == '0x')
              return Number(col);

            if (col.substr(0, 1) == '#')
              return Number('0x' + col.substr(1, col.length));

            if (col.length == 6)
              return Number('0x' + col);

            // not recognised as a valid colour, so?
            return Number(col);

          };

          module.exports = Utils;
        };
        Program["org.flashdevelop.utils.FlashConnect"] = function(module, exports) {
          var TraceLevel;
          module.inject = function() {
            TraceLevel = module.import('org.flashdevelop.utils', 'TraceLevel');
            FlashConnect.status = 0;
            FlashConnect.limit = 1000;
            FlashConnect.host = "127.0.0.1";
            FlashConnect.port = 1978;
            FlashConnect.socket = null;
            FlashConnect.messages = null;
            FlashConnect.interval = null;
            FlashConnect.counter = null;
            FlashConnect.onConnection = null;
            FlashConnect.onReturnData = null;
          };

          var FlashConnect = function FlashConnect() {};

          FlashConnect.status = 0;
          FlashConnect.limit = 1000;
          FlashConnect.host = null;
          FlashConnect.port = 1978;
          FlashConnect.socket = null;
          FlashConnect.messages = null;
          FlashConnect.interval = 0;
          FlashConnect.counter = 0;
          FlashConnect.onConnection = null;
          FlashConnect.onReturnData = null;
          FlashConnect.send = function(message) {
            if (FlashConnect.messages == null) FlashConnect.initialize();
            FlashConnect.messages.push(message);
          };
          FlashConnect.trace = function(value, level) {
            level = AS3JS.Utils.getDefaultValue(level, TraceLevel.DEBUG);
            var msgNode = FlashConnect.createMsgNode(value.toString(), level);
            FlashConnect.send(msgNode);
          };
          FlashConnect.atrace = function() {
            var rest = Array.prototype.slice.call(arguments).splice(0);
            var result = rest.join(",");
            var message = FlashConnect.createMsgNode(result, TraceLevel.DEBUG);
            FlashConnect.send(message);
          };
          FlashConnect.mtrace = function(value, method, path, line) {
            var fixed = path.split("/").join("\\");
            var formatted = fixed + ":" + line + ":" + value;
            FlashConnect.trace(formatted, TraceLevel.DEBUG);
          };
          FlashConnect.flush = function() {
            if (FlashConnect.status) {
              FlashConnect.sendStack();
              return true;
            } else return false;
          };
          FlashConnect.initialize = function() {
            if (FlashConnect.socket) return FlashConnect.status;
            FlashConnect.counter = 0;
            FlashConnect.messages = [];
            FlashConnect.socket = new XMLSocket();
            FlashConnect.socket.addEventListener(Event.CLOSE, FlashConnect.onClose);
            FlashConnect.socket.addEventListener(DataEvent.DATA, FlashConnect.onData);
            FlashConnect.socket.addEventListener(Event.CONNECT, FlashConnect.onConnect);
            FlashConnect.socket.addEventListener(IOErrorEvent.IO_ERROR, FlashConnect.onIOError);
            FlashConnect.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, FlashConnect.onSecurityError);
            FlashConnect.interval = setInterval(FlashConnect.sendStack, 50);
            FlashConnect.socket.connect(FlashConnect.host, FlashConnect.port);
            return FlashConnect.status;
          };
          FlashConnect.onData = function(event) {
            FlashConnect.status = 1;
            if (FlashConnect.onReturnData != null) {
              FlashConnect.onReturnData(event.data);
            }
          };
          FlashConnect.onClose = function(event) {
            FlashConnect.socket = null;
            FlashConnect.status = -1;
            if (FlashConnect.onConnection != null) {
              FlashConnect.onConnection();
            }
          };
          FlashConnect.onConnect = function(event) {
            FlashConnect.status = 1;
            if (FlashConnect.onConnection != null) {
              FlashConnect.onConnection();
            }
          };
          FlashConnect.onIOError = function(event) {
            FlashConnect.status = -1;
            if (FlashConnect.onConnection != null) {
              FlashConnect.onConnection();
            }
          };
          FlashConnect.onSecurityError = function(event) {
            FlashConnect.status = -1;
            if (FlashConnect.onConnection != null) {
              FlashConnect.onConnection();
            }
          };
          FlashConnect.createMsgNode = function(message, level) {
            if (isNaN(level)) level = TraceLevel.DEBUG;
            var msgNode = new XMLNode(1, null);
            var txtNode = new XMLNode(3, encodeURI(message));
            msgNode.attributes.state = level.toString();
            msgNode.attributes.cmd = "trace";
            msgNode.nodeName = "message";
            msgNode.appendChild(txtNode);
            return msgNode;
          };
          FlashConnect.sendStack = function() {
            if (FlashConnect.messages.length > 0 && FlashConnect.status == 1) {
              var message = new XMLDocument();
              var rootNode = message.createElement("flashconnect");
              while (FlashConnect.messages.length != 0) {
                FlashConnect.counter++;
                if (FlashConnect.counter > FlashConnect.limit) {
                  clearInterval(FlashConnect.interval);
                  var msg = new String("FlashConnect aborted. You have reached the limit of maximum messages.");
                  var errorNode = FlashConnect.createMsgNode(msg, TraceLevel.ERROR);
                  rootNode.appendChild(errorNode);
                  FlashConnect.messages = [];
                  break;
                } else {
                  var msgNode = XMLNode(FlashConnect.messages.shift());
                  rootNode.appendChild(msgNode);
                }
              }
              message.appendChild(rootNode);
              if (FlashConnect.socket && FlashConnect.socket.connected) FlashConnect.socket.send(message);
              FlashConnect.counter = 0;
            }
          };

          module.exports = FlashConnect;
        };
        Program["org.flashdevelop.utils.FlashViewer"] = function(module, exports) {
          var TraceLevel;
          module.inject = function() {
            TraceLevel = module.import('org.flashdevelop.utils', 'TraceLevel');
            FlashViewer.limit = 1000;
            FlashViewer.counter = 0;
            FlashViewer.aborted = false;
          };

          var FlashViewer = function FlashViewer() {};

          FlashViewer.limit = 1000;
          FlashViewer.counter = 0;
          FlashViewer.aborted = false;
          FlashViewer.trace = function(value, level) {
            level = AS3JS.Utils.getDefaultValue(level, 1);
            FlashViewer.counter++;
            if (FlashViewer.counter > FlashViewer.limit && !FlashViewer.aborted) {
              FlashViewer.aborted = true;
              var msg = "FlashViewer aborted. You have reached the limit of maximum messages.";
              fscommand("trace", "3:" + msg);
            }
            if (!FlashViewer.aborted) fscommand("trace", level + ":" + value);
          };
          FlashViewer.mtrace = function(value, method, path, line) {
            var fixed = path.split("/").join("\\");
            var formatted = fixed + ":" + line + ":" + value;
            FlashViewer.trace(formatted, TraceLevel.DEBUG);
          };
          FlashViewer.atrace = function() {
            var rest = Array.prototype.slice.call(arguments).splice(0);
            var result = rest.join(",");
            FlashViewer.trace(result, TraceLevel.DEBUG);
          };

          module.exports = FlashViewer;
        };
        Program["org.flashdevelop.utils.TraceLevel"] = function(module, exports) {
          module.inject = function() {
            TraceLevel.INFO = 0;
            TraceLevel.DEBUG = 1;
            TraceLevel.WARNING = 2;
            TraceLevel.ERROR = 3;
            TraceLevel.FATAL = 4;
          };

          var TraceLevel = function TraceLevel() {};

          TraceLevel.INFO = 0;
          TraceLevel.DEBUG = 1;
          TraceLevel.WARNING = 2;
          TraceLevel.ERROR = 3;
          TraceLevel.FATAL = 4;

          module.exports = TraceLevel;
        };
        Program["global.Global"] = function(module, exports) {
          var tr;
          module.inject = function() {
            tr = module.import('', 'tr');
            Global.instance = null;
            Global.allowInstantiation = false;
          };

          var Global = function() {
            this.x_labels = null;
            this.x_legend = null;
          };

          Global.instance = null;
          Global.allowInstantiation = false;
          Global.getInstance = function() {
            if (Global.instance == null) {
              Global.allowInstantiation = true;
              Global.instance = new Global();
              Global.allowInstantiation = false;
            }
            return Global.instance;
          };

          Global.prototype.x_labels = null;
          Global.prototype.x_legend = null;
          Global.prototype.tooltip = null;
          Global.prototype.get_x_label = function(pos) {

            // PIE charts don't have X Labels

            tr.ace('xxx');
            tr.ace(this.x_labels == null)
            tr.ace(pos);
            //      tr.ace( this.x_labels.get(pos))

            if (this.x_labels == null)
              return null;
            else
              return this.x_labels.get(pos);
          };
          Global.prototype.get_x_legend = function() {

            // PIE charts don't have X Legend
            if (this.x_legend == null)
              return null;
            else
              return this.x_legend.text;
          };
          Global.prototype.set_tooltip_string = function(s) {
            tr.ace('@@@@@@@');
            tr.ace(s);
            this.tooltip = s;
          };
          Global.prototype.get_tooltip_string = function() {
            return this.tooltip;
          }

          module.exports = Global;
        };
        Program["elements.Background"] = function(module, exports) {
          var Utils;
          module.inject = function() {
            Utils = module.import('string', 'Utils');
          };

          var Background = function(json) {
            if (json.bg_colour != undefined)
              this.colour = Utils.get_colour(json.bg_colour);
            else
              this.colour = 0xf8f8d8; // <-- default to Ivory

            if (json.bg_image != undefined)
              this.load_img(json.bg_image);

          };

          Background.prototype = Object.create(Sprite.prototype);

          Background.prototype.colour = 0;
          Background.prototype.img_x = 0;
          Background.prototype.img_y = 0;
          Background.prototype.load_img = function(json) {

            // added by NetVicious, 05 July, 2007 ++++

            if (json.bg_image_x != undefined)
              this.img_x = json.bg_image_x;

            if (json.bg_image_y != undefined)
              this.img_y = json.bg_image_y;

            //
            // LOAD THE IMAGE
            /*
          var loader;
          loader = new URLLoader();
          loader.addEventListener( Event.COMPLETE, imageLoaded );
          
          var loader = new URLRequest();
          loader.addListener({
            onLoadInit: function(mymc:MovieClip) {
              ref.positionize( mymc, ref.img_x, ref.img_y, new Square(0, 0, Stage.width, Stage.height) );
              delete loader;
            }
          });
            
          loader.loadClip(lv.bg_image, this.img_mc);
        */
          };
          Background.prototype.resize = function() {
            this.graphics.beginFill(this.colour);
            this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
          };
          Background.prototype.die = function() {

            this.graphics.clear();
          }

          module.exports = Background;
        };
        Program["elements.axis.RadarAxis"] = function(module, exports) {
          var object_helper, Range, Utils, RadarAxisLabels, RadarSpokeLabels;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Range = module.import('', 'Range');
            Utils = module.import('string', 'Utils');
            RadarAxisLabels = module.import('elements.axis', 'RadarAxisLabels');
            RadarSpokeLabels = module.import('elements.axis', 'RadarSpokeLabels');
          };

          var RadarAxis = function(json) {
            this.style = null;
            this.labels = null;
            this.spoke_labels = null;
            // default values
            this.style = {
              stroke: 2,
              this.colour: '#784016',
              'grid-colour': '#F5E1AA',
              min: 0,
              max: null,
              steps: 1
            };

            if (json != null)
              object_helper.merge_2(json, this.style);

            this.colour = Utils.get_colour(this.style.colour);
            this.grid_colour = Utils.get_colour(this.style['grid-colour']);

            this.labels = new RadarAxisLabels(json.labels);
            this.addChild(this.labels);

            this.spoke_labels = new RadarSpokeLabels(json['spoke-labels']);
            this.addChild(this.spoke_labels);
          };

          RadarAxis.prototype = Object.create(Sprite.prototype);

          RadarAxis.prototype.style = null;
          RadarAxis.prototype.TO_RADIANS = Math.PI / 180;
          RadarAxis.prototype.colour = 0;
          RadarAxis.prototype.grid_colour = 0;
          RadarAxis.prototype.labels = null;
          RadarAxis.prototype.spoke_labels = null;
          RadarAxis.prototype.get_range = function() {
            return new Range(this.style.min, this.style.max, this.style.steps, false);
          };
          RadarAxis.prototype.resize = function(sc) {
            this.x = 0;
            this.y = 0;
            this.graphics.clear();

            // this is going to change the radius
            this.spoke_labels.resize(sc);

            var count = sc.get_angles();

            // draw the grid behind the axis
            this.draw_grid(sc, count);
            this.draw_axis(sc, count);

            this.labels.resize(sc);
          };
          RadarAxis.prototype.draw_axis = function(sc, count) {

            this.graphics.lineStyle(this.style.stroke, this.colour, 1, true);

            for (var i = 0; i < count; i++) {

              //
              // assume 0 is MIN
              //
              var p = sc.get_get_x_from_pos_and_y_from_val(i, 0);
              this.graphics.moveTo(p.x, p.y);

              var q = sc.get_get_x_from_pos_and_y_from_val(i, sc.get_max());
              this.graphics.lineTo(q.x, q.y);
            }
          };
          RadarAxis.prototype.draw_grid = function(sc, count) {

            this.graphics.lineStyle(1, this.grid_colour, 1, true);

            // floating point addition error:
            var max = sc.get_max() + 0.00001;

            var r_step = this.style.steps;
            var p;

            //
            // start in the middle and move out drawing the grid,
            // don't draw at 0
            //
            for (var r_pos = r_step; r_pos <= max; r_pos += r_step) {

              p = sc.get_get_x_from_pos_and_y_from_val(0, r_pos);
              this.graphics.moveTo(p.x, p.y);

              // draw from each spoke
              for (var i = 1; i < (count + 1); i++) {

                p = sc.get_get_x_from_pos_and_y_from_val(i, r_pos);
                this.graphics.lineTo(p.x, p.y);
              }
            }
          };
          RadarAxis.prototype.die = function() {

            this.style = null;
            this.labels.die();
            this.spoke_labels.die();

            this.graphics.clear();
            while (this.numChildren > 0)
              this.removeChildAt(0);
          }

          module.exports = RadarAxis;
        };
        Program["elements.axis.RadarAxisLabels"] = function(module, exports) {
          var object_helper, Utils;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Utils = module.import('string', 'Utils');
          };

          var RadarAxisLabels = function(json) {
            this.style = null;
            this.labels = null;

            // default values
            this.style = {
              colour: '#784016',
              steps: 1
            };

            if (json != null)
              object_helper.merge_2(json, this.style);

            this.style.colour = Utils.get_colour(this.style.colour);

            // cache the text for tooltips
            this.labels = [];
            var values;
            var ok = false;

            if ((this.style.labels is Array) && (this.style.labels.length > 0)) {

              for each(var s in this.style.labels)
              this.add(s, this.style);
            }

          };

          RadarAxisLabels.prototype = Object.create(Sprite.prototype);

          RadarAxisLabels.prototype.style = null;
          RadarAxisLabels.prototype.labels = null;
          RadarAxisLabels.prototype.add = function(label, style) {
            var label_style = {
              colour: style.colour,
              text: '',
              size: style.size,
              visible: true
            };

            if (label is String)
              label_style.text = (String) label;
            else {
              object_helper.merge_2(label, label_style);
            }

            // our parent colour is a number, but
            // we may have our own colour:
            if (label_style.colour is String)
              label_style.colour = Utils.get_colour(label_style.colour);

            this.labels.push(label_style.text);

            //
            // inheriting the 'visible' attribute
            // is complext due to the 'steps' value
            // only some labels will be visible
            //
            if (label_style.visible == null) {
              //
              // some labels will be invisible due to our parents step value
              //
              if (((this.labels.length - 1) % style.steps) == 0)
                label_style.visible = true;
              else
                label_style.visible = false;
            }

            var l = this.make_label(label_style);
            this.addChild(l);
          };
          RadarAxisLabels.prototype.make_label = function(label_style) {

            // we create the text in its own movie clip

            var tf = new TextField();
            tf.x = 0;
            tf.y = 0;
            tf.text = label_style.text;

            var fmt = new TextFormat();
            fmt.color = label_style.colour;
            fmt.font = "Verdana";
            fmt.size = label_style.size;
            fmt.align = "right";
            tf.setTextFormat(fmt);

            tf.autoSize = "left";
            tf.visible = label_style.visible;
            return tf;
          };
          RadarAxisLabels.prototype.resize = function(sc) {

            var i;
            var tf;
            var center = sc.get_center_x();

            for (i = 0; i < this.numChildren; i++) {
              // right align
              tf = (TextField) this.getChildAt(i);
              tf.x = center - tf.width;
            }

            // now move it to the correct Y, vertical center align
            for (i = 0; i < this.numChildren; i++) {

              tf = (TextField) this.getChildAt(i);
              tf.y = (sc.get_y_from_val(i, false) - (tf.height / 2));
            }
          };
          RadarAxisLabels.prototype.die = function() {

            this.style = null;
            this.labels = null;

            this.graphics.clear();
            while (this.numChildren > 0)
              this.removeChildAt(0);
          }

          module.exports = RadarAxisLabels;
        };
        Program["elements.axis.RadarSpokeLabels"] = function(module, exports) {
          var object_helper, Utils;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Utils = module.import('string', 'Utils');
          };

          var RadarSpokeLabels = function(json) {
            this.style = null;
            this.labels = null;

            // default values
            this.style = {
              colour: '#784016'
            };

            if (json != null)
              object_helper.merge_2(json, this.style);

            // tr.ace_json(this.style);

            this.style.colour = Utils.get_colour(this.style.colour);

            // cache the text for tooltips
            this.labels = [];
            var values;
            var ok = false;

            if ((this.style.labels is Array) && (this.style.labels.length > 0)) {

              for each(var s in this.style.labels)
              this.add(s, this.style);
            }

          };

          RadarSpokeLabels.prototype = Object.create(Sprite.prototype);

          RadarSpokeLabels.prototype.style = null;
          RadarSpokeLabels.prototype.labels = null;
          RadarSpokeLabels.prototype.add = function(label, style) {
            var label_style = {
              colour: style.colour,
              text: '',
              size: 11
            };

            if (label is String)
              label_style.text = (String) label;
            else {
              object_helper.merge_2(label, label_style);
            }

            // our parent colour is a number, but
            // we may have our own colour:
            if (label_style.colour is String)
              label_style.colour = Utils.get_colour(label_style.colour);

            this.labels.push(label_style.text);

            var l = this.make_label(label_style);
            this.addChild(l);
          };
          RadarSpokeLabels.prototype.make_label = function(label_style) {

            // we create the text in its own movie clip

            var tf = new TextField();
            tf.x = 0;
            tf.y = 0;

            var tmp = label_style.text.split('<br>');
            var text = tmp.join('\n');

            tf.text = text;

            var fmt = new TextFormat();
            fmt.color = label_style.colour;
            fmt.font = "Verdana";
            fmt.size = label_style.size;
            fmt.align = "right";

            tf.setTextFormat(fmt);
            tf.autoSize = "left";
            tf.visible = true;

            return tf;
          };
          RadarSpokeLabels.prototype.resize = function(sc) {

            var tf;
            //
            // loop over the lables and make sure they are on the screen,
            // reduce the radius until they fit
            //
            var i = 0;
            var outside;
            do {
              outside = false;
              this.resize_2(sc);

              for (i = 0; i < this.numChildren; i++) {
                tf = (TextField) this.getChildAt(i);
                if ((tf.x < sc.left) ||
                  (tf.y < sc.top) ||
                  (tf.y + tf.height > sc.bottom) ||
                  (tf.x + tf.width > sc.right)
                )
                  outside = true;

              }
              sc.reduce_radius();
            }
            while (outside && sc.get_radius() > 10);
            //
            //
            //
          };
          RadarSpokeLabels.prototype.resize_2 = function(sc) {

            var i;
            var tf;
            var mid_x = sc.get_center_x();

            // now move it to the correct Y, vertical center align
            for (i = 0; i < this.numChildren; i++) {

              tf = (TextField) this.getChildAt(i);

              var p = sc.get_get_x_from_pos_and_y_from_val(i, sc.get_max());
              if (p.x > mid_x)
                tf.x = p.x; // <-- right align the text
              else
                tf.x = p.x - tf.width; // <-- left align the text

              if (i == 0) {
                //
                // this is the top label and will overwrite
                // the radius label -- so we right align it
                // because the radius labels are left aligned
                //
                tf.y = p.y - tf.height;
                tf.x = p.x;
              } else
                tf.y = p.y;
            }
          };
          RadarSpokeLabels.prototype.die = function() {

            this.style = null;
            this.labels = null;

            this.graphics.clear();
            while (this.numChildren > 0)
              this.removeChildAt(0);
          }

          module.exports = RadarSpokeLabels;
        };
        Program["elements.axis.AxisLabel"] = function(module, exports) {
          var AxisLabel = function() {};

          AxisLabel.prototype = Object.create(TextField.prototype);

          AxisLabel.prototype.xAdj = 0;
          AxisLabel.prototype.yAdj = 0;
          AxisLabel.prototype.leftOverhang = 0;
          AxisLabel.prototype.rightOverhang = 0;
          AxisLabel.prototype.xVal = NaN;
          AxisLabel.prototype.yVal = NaN;
          AxisLabel.prototype.rotate_and_align = function(rotation, align, parent) {
            rotation = rotation % 360;
            if (rotation < 0) rotation += 360;

            var myright = this.width * Math.cos(rotation * Math.PI / 180);
            var myleft = this.height * Math.cos((90 - rotation) * Math.PI / 180);
            var mytop = this.height * Math.sin((90 - rotation) * Math.PI / 180);
            var mybottom = this.width * Math.sin(rotation * Math.PI / 180);

            if (((rotation % 90) == 0) || (align == "center")) {
              this.xAdj = (myleft - myright) / 2;
            } else {
              this.xAdj = (rotation < 180) ? myleft / 2 : -myright + (myleft / 2);
            }

            if (rotation > 90) {
              this.yAdj = -mytop;
            }
            if (rotation > 180) {
              this.yAdj = -mytop - mybottom;
            }
            if (rotation > 270) {
              this.yAdj = -mybottom;
            }
            this.rotation = rotation;

            var titleRect = this.getBounds(parent);
            this.leftOverhang = Math.abs(titleRect.x + this.xAdj);
            this.rightOverhang = Math.abs(titleRect.x + titleRect.width + this.xAdj);
          }

          module.exports = AxisLabel;
        };
        Program["elements.axis.XAxis"] = function(module, exports) {
          var object_helper, Range, Utils, XAxisLabels, Bar3D, Bar3D;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Range = module.import('', 'Range');
            Utils = module.import('string', 'Utils');
            XAxisLabels = module.import('elements.axis', 'XAxisLabels');
            Bar3D = module.import('charts', 'Bar3D');
            Bar3D = module.import('charts.series.bars', 'Bar3D');
          };

          var XAxis = function(json, min, max) {
            this.user_labels = null;
            this.labels = null;
            this.style = null;
            // default values
            this.style = {
              this.stroke: 2,
                'tick-height': 3,
                this.colour: '#784016',
                this.offset: true,
                'grid-colour': '#F5E1AA',
                'grid-visible': true,
                '3d': 0,
                this.steps: 1,
                min: 0,
                max: null
            };

            if (json != null)
              object_helper.merge_2(json.x_axis, this.style);

            this.calcSteps();

            this.stroke = this.style.stroke;
            this.tick_height = this.style['tick-height'];
            this.colour = this.style.colour;
            // is the axis offset (see ScreenCoords)
            this.offset = this.style.offset;
            this.grid_visible = this.style['grid-visible'];

            this.colour = Utils.get_colour(this.style.colour);
            this.grid_colour = Utils.get_colour(this.style['grid-colour']);

            if (this.style['3d'] > 0) {
              this.three_d = true;
              this.three_d_height = int(this.style['3d']);
            } else
              this.three_d = false;

            // Patch from Will Henry
            if (json) {
              if (json.x_label_style != undefined) {
                if (json.x_label_style.alt_axis_step != undefined)
                  this.alt_axis_step = json.x_label_style.alt_axis_step;

                if (json.x_label_style.alt_axis_colour != undefined)
                  this.alt_axis_colour = Utils.get_colour(json.x_label_style.alt_axis_colour);
              }
            }

            this.labels = new XAxisLabels(json);
            this.addChild(this.labels);

            // the X Axis labels *may* require info from
            // this.obs
            if (!this.range_set()) {
              //
              // the user has not told us how long the X axis
              // is, so we figure it out:
              //
              if (this.labels.need_labels) {
                //
                // No X Axis labels set:
                //

                // tr.aces( 'max x', this.obs.get_min_x(), this.obs.get_max_x() );
                this.set_range(min, max);
              } else {
                //
                // X Axis labels used, even so, make the chart
                // big enough to show all values
                //
                // tr.aces('x labels', this.obs.get_min_x(), this.x_axis.labels.count(), this.obs.get_max_x());
                if (this.labels.count() > max) {

                  // Data and labesl are OK
                  this.set_range(0, this.labels.count());
                } else {

                  // There is more data than labels -- oops
                  this.set_range(min, max);
                }
              }
            } else {
              //range set, but no labels...
              this.labels.auto_label(this.get_range(), this.get_steps());
            }

            // custom ticks:
            this.make_user_ticks();
          };

          XAxis.prototype = Object.create(Sprite.prototype);

          XAxis.prototype.steps = 0;
          XAxis.prototype.alt_axis_colour = 0;
          XAxis.prototype.alt_axis_step = 0;
          XAxis.prototype.three_d = false;
          XAxis.prototype.three_d_height = 0;
          XAxis.prototype.stroke = 0;
          XAxis.prototype.tick_height = 0;
          XAxis.prototype.colour = 0;
          XAxis.prototype.offset = false;
          XAxis.prototype.grid_colour = 0;
          XAxis.prototype.grid_visible = false;
          XAxis.prototype.user_ticks = false;
          XAxis.prototype.user_labels = null;
          XAxis.prototype.labels = null;
          XAxis.prototype.style = null;
          XAxis.prototype.make_user_ticks = function() {

            if ((this.style.labels != null) &&
              (this.style.labels.labels != null) &&
              (this.style.labels.labels is Array) &&
              (this.style.labels.labels.length > 0)) {
              this.user_labels = [];
              for each(var lbl in this.style.labels.labels) {
                if (!(lbl is String)) {
                  if (lbl.x != null) {
                    var tmpObj = {
                      x: lbl.x
                    };
                    if (lbl["grid-colour"]) {
                      tmpObj["grid-colour"] = Utils.get_colour(lbl["grid-colour"]);
                    } else {
                      tmpObj["grid-colour"] = this.grid_colour;
                    }

                    this.user_ticks = true;
                    this.user_labels.push(tmpObj);
                  }
                }
              }
            }
          };
          XAxis.prototype.calcSteps = function() {
            if (this.style.max == null) {
              this.steps = 1;
            } else {
              var xRange = this.style.max - this.style.min;
              var rev = (this.style.min >= this.style.max); // min-max reversed?
              this.steps = ((this.style.steps != null) &&
                (this.style.steps != 0)) ? this.style.steps : 1;

              // force max of 250 labels and tick marks
              if ((Math.abs(xRange) / this.steps) > 250) this.steps = xRange / 250;

              // guarantee lblSteps is the proper sign
              this.steps = rev ? -Math.abs(this.steps) : Math.abs(this.steps);
            }
          };
          XAxis.prototype.range_set = function() {
            return this.style.max != null;
          };
          XAxis.prototype.set_range = function(min, max) {
            this.style.min = min;
            this.style.max = max;
            // Calc new steps
            this.calcSteps();

            this.labels.auto_label(this.get_range(), this.get_steps());
          };
          XAxis.prototype.get_range = function() {
            return new Range(this.style.min, this.style.max, this.steps, this.offset);
          };
          XAxis.prototype.get_steps = function() {
            return this.steps;
          };
          XAxis.prototype.resize = function(sc, yPos) {
            this.graphics.clear();

            //
            // Grid lines
            //
            if (this.user_ticks) {
              for each(var lbl in this.user_labels) {
                this.graphics.beginFill(lbl["grid-colour"], 1);
                var xVal = sc.get_x_from_val(lbl.x);
                this.graphics.drawRect(xVal, sc.top, 1, sc.height);
                this.graphics.endFill();
              }
            } else if (this.grid_visible) {
              var rev = (this.style.min >= this.style.max); // min-max reversed?
              var tickMax = /*(rev && this.style.offset) ? this.style.max-2 : */ this.style.max

              for (var i = this.style.min; rev ? i >= tickMax : i <= tickMax; i += this.steps) {
                if ((this.alt_axis_step > 1) && (i % this.alt_axis_step == 0))
                  this.graphics.beginFill(this.alt_axis_colour, 1);
                else
                  this.graphics.beginFill(this.grid_colour, 1);

                xVal = sc.get_x_from_val(i);
                this.graphics.drawRect(xVal, sc.top, 1, sc.height);
                this.graphics.endFill();
              }
            }

            if (this.three_d)
              this.three_d_axis(sc);
            else
              this.two_d_axis(sc);

            this.labels.resize(sc, yPos);
          };
          XAxis.prototype.three_d_axis = function(sc) {

            // for 3D
            var h = this.three_d_height;
            var offset = 12;
            var x_axis_height = h + offset;

            //
            // ticks
            var item_width = sc.width / this.style.max;

            // turn off out lines:
            this.graphics.lineStyle(0, 0, 0);

            var w = 1;

            if (this.user_ticks) {
              for each(var lbl in this.user_labels) {
                var xVal = sc.get_x_from_val(lbl.x);
                this.graphics.beginFill(this.colour, 1);
                this.graphics.drawRect(xVal, sc.bottom + x_axis_height, w, this.tick_height);
                this.graphics.endFill();
              }
            } else {
              for (var i = 0; i < this.style.max; i += this.steps) {
                var pos = sc.get_x_tick_pos(i);

                this.graphics.beginFill(this.colour, 1);
                this.graphics.drawRect(pos, sc.bottom + x_axis_height, w, this.tick_height);
                this.graphics.endFill();
              }
            }

            var lighter = Bar3D.Lighten(this.colour);

            // TOP
            var colors = [this.colour, lighter];
            var alphas = [100, 100];
            var ratios = [0, 255];

            var matrix = new Matrix();
            matrix.createGradientBox(sc.width_(), offset, (270 / 180) * Math.PI, sc.left - offset, sc.bottom);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            this.graphics.moveTo(sc.left, sc.bottom);
            this.graphics.lineTo(sc.right, sc.bottom);
            this.graphics.lineTo(sc.right - offset, sc.bottom + offset);
            this.graphics.lineTo(sc.left - offset, sc.bottom + offset);
            this.graphics.endFill();

            // front
            colors = [this.colour, lighter];
            alphas = [100, 100];
            ratios = [0, 255];

            matrix.createGradientBox(sc.width_(), h, (270 / 180) * Math.PI, sc.left - offset, sc.bottom + offset);
            this.graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
            this.graphics.moveTo(sc.left - offset, sc.bottom + offset);
            this.graphics.lineTo(sc.right - offset, sc.bottom + offset);
            this.graphics.lineTo(sc.right - offset, sc.bottom + offset + h);
            this.graphics.lineTo(sc.left - offset, sc.bottom + offset + h);
            this.graphics.endFill();

            // right side
            colors = [this.colour, lighter];
            alphas = [100, 100];
            ratios = [0, 255];

            //  var matrix = { matrixType:"box", x:box.left - offset, y:box.bottom + offset, w:box.width_(), h:h, r:(225 / 180) * Math.PI };
            matrix.createGradientBox(sc.width_(), h, (225 / 180) * Math.PI, sc.left - offset, sc.bottom + offset);
            this.graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
            this.graphics.moveTo(sc.right, sc.bottom);
            this.graphics.lineTo(sc.right, sc.bottom + h);
            this.graphics.lineTo(sc.right - offset, sc.bottom + offset + h);
            this.graphics.lineTo(sc.right - offset, sc.bottom + offset);
            this.graphics.endFill();

          };
          XAxis.prototype.two_d_axis = function(sc) {
            //
            // ticks
            var item_width = sc.width / this.style.max;
            var left = sc.left + (item_width / 2);

            //this.graphics.clear();
            // Axis line:
            this.graphics.lineStyle(0, 0, 0);
            this.graphics.beginFill(this.colour);
            this.graphics.drawRect(sc.left, sc.bottom, sc.width, this.stroke);
            this.graphics.endFill();

            if (this.user_ticks) {
              for each(var lbl in this.user_labels) {
                var xVal = sc.get_x_from_val(lbl.x);
                this.graphics.beginFill(this.colour, 1);
                this.graphics.drawRect(xVal - (this.stroke / 2), sc.bottom + this.stroke, this.stroke, this.tick_height);
                this.graphics.endFill();
              }
            } else {
              for (var i = this.style.min; i <= this.style.max; i += this.steps) {
                xVal = sc.get_x_from_val(i);
                this.graphics.beginFill(this.colour, 1);
                this.graphics.drawRect(xVal - (this.stroke / 2), sc.bottom + this.stroke, this.stroke, this.tick_height);
                this.graphics.endFill();
              }
            }
          };
          XAxis.prototype.get_height = function() {
            if (this.three_d) {
              // 12 is the size of the slanty
              // 3D part of the X axis
              return this.three_d_height + 12 + this.tick_height + this.labels.get_height();
            } else
              return this.stroke + this.tick_height + this.labels.get_height();
          };
          XAxis.prototype.first_label_width = function() {
            return this.labels.first_label_width();
          };
          XAxis.prototype.last_label_width = function() {
            return this.labels.last_label_width();
          };
          XAxis.prototype.die = function() {

            this.style = null;

            this.graphics.clear();
            while (this.numChildren > 0)
              this.removeChildAt(0);

            if (this.labels != null)
              this.labels.die();
            this.labels = null;
          }

          module.exports = XAxis;
        };
        Program["elements.axis.XAxisLabels"] = function(module, exports) {
          var NumberUtils, object_helper, DateUtils, Utils, AxisLabel;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            object_helper = module.import('', 'object_helper');
            DateUtils = module.import('string', 'DateUtils');
            Utils = module.import('string', 'Utils');
            AxisLabel = module.import('elements.axis', 'AxisLabel');
            XAxisLabels.ArialFont__ = null;
          };

          var XAxisLabels = function(json) {
            this.axis_labels = null;
            this.style = null;
            this.userSpecifiedVisible = null;

            this.need_labels = true;

            // TODO: remove this and the class
            // var style = new XLabelStyle( json.x_labels );

            this.style = {
              rotate: 0,
              visible: null,
              labels: null,
              text: '#val#', // <-- default to display the position number or x value
              steps: null, // <-- null for auto labels
              size: 10,
              align: 'auto',
              colour: '#000000',
              "visible-steps": null
            };

            // cache the text for tooltips
            this.axis_labels = [];

            if ((json.x_axis != null) && (json.x_axis.labels != null))
              object_helper.merge_2(json.x_axis.labels, this.style);

            // save the user specified visible value foe use with auto_labels
            this.userSpecifiedVisible = this.style.visible;
            // for user provided labels, default to visible if not specified
            if (this.style.visible == null) this.style.visible = true;

            // Force rotation value if "rotate" is specified
            if (this.style.rotate is String) {
              if (this.style.rotate == "vertical") {
                this.style.rotate = 270;
              } else if (this.style.rotate == "diagonal") {
                this.style.rotate = -45;
              }
            }

            this.style.colour = Utils.get_colour(this.style.colour);

            if ((this.style.labels is Array) && (this.style.labels.length > 0)) {
              //
              // we WERE passed labels
              //
              this.need_labels = false;
              if (this.style.steps == null)
                this.style.steps = 1;

              //
              // BUG: this should start counting at X MIN, not zero
              //
              var x = 0;
              var lblCount = 0;
              // Allow for only displaying some of the labels 
              var visibleSteps = (this.style["visible-steps"] == null) ? this.style.steps : this.style["visible-steps"];

              for each(var s in this.style.labels) {
                var tmpStyle = {};
                object_helper.merge_2(this.style, tmpStyle);

                tmpStyle.visible = ((lblCount % visibleSteps) == 0);
                tmpStyle.x = x;

                // we need the x position for #x_label# tooltips
                this.add(s, tmpStyle);
                x++;
                lblCount++;
              }
            }
          };

          XAxisLabels.prototype = Object.create(Sprite.prototype);

          XAxisLabels.ArialFont__ = null;

          XAxisLabels.prototype.need_labels = false;
          XAxisLabels.prototype.axis_labels = null;
          XAxisLabels.prototype.style = null;
          XAxisLabels.prototype.userSpecifiedVisible = null;
          XAxisLabels.prototype.auto_label = function(range, steps) {

            //
            // if the user has passed labels we don't do this
            //
            if (this.need_labels) {
              var rev = (range.min >= range.max); // min-max reversed?

              // Use the steps specific to labels if provided by user
              var lblSteps = 1;
              if (this.style.steps != null) lblSteps = this.style.steps;

              // force max of 250 labels 
              if (Math.abs(range.count() / lblSteps) > 250) lblSteps = range.count() / 250;

              // guarantee lblSteps is the proper sign
              lblSteps = rev ? -Math.abs(lblSteps) : Math.abs(lblSteps);

              // Allow for only displaying some of the labels 
              var visibleSteps = (this.style["visible-steps"] == null) ? steps : this.style["visible-steps"];

              var tempStyle = {};
              object_helper.merge_2(this.style, tempStyle);
              var lblCount = 0;
              for (var i = range.min; rev ? i >= range.max : i <= range.max; i += lblSteps) {
                tempStyle.x = i;
                // restore the user specified visble value
                if (this.userSpecifiedVisible == null) {
                  tempStyle.visible = ((lblCount % visibleSteps) == 0);
                  lblCount++;
                } else {
                  tempStyle.visible = this.userSpecifiedVisible;
                }
                this.add(null, tempStyle);
              }
            }
          };
          XAxisLabels.prototype.add = function(label, style) {

            var label_style = {
              colour: style.colour,
              text: style.text,
              rotate: style.rotate,
              size: style.size,
              align: style.align,
              visible: style.visible,
              x: style.x
            };

            //
            // inherit some properties from
            // our parents 'globals'
            //
            if (label is String)
              label_style.text = (String) label;
            else
              object_helper.merge_2(label, label_style);

            // Replace magic date variables in x label text
            if (label_style.x != null) {
              label_style.text = this.replace_magic_values(label_style.text, label_style.x);
            }

            var lines = label_style.text.split('<br>');
            label_style.text = lines.join('\n');

            // Map X location to label string
            this.axis_labels[label_style.x] = label_style.text;

            // only create the label if necessary
            if (label_style.visible) {
              // our parent colour is a number, but
              // we may have our own colour:
              if (label_style.colour is String)
                label_style.colour = Utils.get_colour(label_style.colour);

              var l = this.make_label(label_style);

              this.addChild(l);
            }
          };
          XAxisLabels.prototype.get = function(i) {
            if (i < this.axis_labels.length)
              return this.axis_labels[i];
            else
              return '';
          };
          XAxisLabels.prototype.make_label = function(label_style) {
            // we create the text in its own movie clip, so when
            // we rotate it, we can move the regestration point

            var title = new AxisLabel();
            title.x = 0;
            title.y = 0;

            //this.css.parseCSS(this.style);
            //title.styleSheet = this.css;
            title.text = label_style.text;

            var fmt = new TextFormat();
            fmt.color = label_style.colour;

            // TODO: != null
            if (label_style.rotate != 0) {
              // so we can rotate the text
              fmt.font = "spArial";
              title.embedFonts = true;
            } else {
              fmt.font = "Verdana";
            }

            fmt.size = label_style.size;
            fmt.align = "left";
            title.setTextFormat(fmt);
            title.autoSize = "left";
            title.rotate_and_align(label_style.rotate, label_style.align, this);

            // we don't know the x & y locations yet...

            title.visible = label_style.visible;
            if (label_style.x != null) {
              // store the x value for use in resize
              title.xVal = label_style.x;
            }

            return title;
          };
          XAxisLabels.prototype.count = function() {
            return this.axis_labels.length - 1;
          };
          XAxisLabels.prototype.get_height = function() {
            var height = 0;
            for (var pos = 0; pos < this.numChildren; pos++) {
              var child = this.getChildAt(pos);
              height = Math.max(height, child.height);
            }

            return height;
          };
          XAxisLabels.prototype.resize = function(sc, yPos) {

            this.graphics.clear();
            var i = 0;

            for (var pos = 0; pos < this.numChildren; pos++) {
              var child = (AxisLabel) this.getChildAt(pos);
              if (isNaN(child.xVal)) {
                child.x = sc.get_x_tick_pos(pos) + child.xAdj;
              } else {
                child.x = sc.get_x_from_val(child.xVal) + child.xAdj;
              }
              child.y = yPos + child.yAdj;
            }
          };
          XAxisLabels.prototype.last_label_width = function() {
            // is the last label shown?
            //      if( ( (this.labels.length-1) % style.step ) != 0 )
            //        return 0;

            // get the width of the right most label
            // because it may stick out past the end of the graph
            // and we don't want to truncate it.
            //      return this.mcs[(this.mcs.length-1)]._width;
            if (this.numChildren > 0)
            // this is a kludge compensating for ScreenCoords dividing the width by 2
              return AxisLabel(this.getChildAt(this.numChildren - 1)).rightOverhang * 2;
            else
              return 0;
          };
          XAxisLabels.prototype.first_label_width = function() {
            if (this.numChildren > 0)
            // this is a kludge compensating for ScreenCoords dividing the width by 2
              return AxisLabel(this.getChildAt(0)).leftOverhang * 2;
            else
              return 0;
          };
          XAxisLabels.prototype.die = function() {

            this.axis_labels = null;
            this.style = null;
            this.graphics.clear();

            while (this.numChildren > 0)
              this.removeChildAt(0);
          };
          XAxisLabels.prototype.replace_magic_values = function(labelText, xVal) {
            labelText = labelText.replace('#val#', NumberUtils.formatNumber(xVal));
            labelText = DateUtils.replace_magic_values(labelText, xVal);
            return labelText;
          }

          module.exports = XAxisLabels;
        };
        Program["elements.axis.XLabelStyle"] = function(module, exports) {
          var XLabelStyle = function(json) {
            if (!json)
              return;

            if (json.x_label_style == undefined)
              return;

            if (json.x_label_style.visible == undefined || json.x_label_style.visible) {
              this.show_labels = true;

              if (json.x_label_style.size != undefined)
                this.size = json.x_label_style.size;

              if (json.x_label_style.colour != undefined)
                this.colour = string.Utils.get_colour(json.x_label_style.colour);

              if (json.x_label_style.rotation != undefined) {
                this.vertical = (json.x_label_style.rotation == 1);
                this.diag = (json.x_label_style.rotation == 2);
              }

              if (json.x_label_style.step != undefined)
                this.step = json.x_label_style.step;
            } else
              this.show_labels = true;
          };

          XLabelStyle.prototype.size = 10;
          XLabelStyle.prototype.colour = 0x000000;
          XLabelStyle.prototype.vertical = false;
          XLabelStyle.prototype.diag = false;
          XLabelStyle.prototype.step = 1;
          XLabelStyle.prototype.show_labels = false

          module.exports = XLabelStyle;
        };
        Program["elements.axis.YAxisBase"] = function(module, exports) {
          var object_helper, Range, tr, Utils;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Range = module.import('', 'Range');
            tr = module.import('', 'tr');
            Utils = module.import('string', 'Utils');
          };

          var YAxisBase = function() {
            this.style = null;
            this.labels = null;
            this.user_labels = null;
          };

          YAxisBase.prototype = Object.create(Sprite.prototype);

          YAxisBase.prototype.stroke = 0;
          YAxisBase.prototype.tick_length = 0;
          YAxisBase.prototype.colour = 0;
          YAxisBase.prototype.grid_colour = 0;
          YAxisBase.prototype.style = null;
          YAxisBase.prototype.labels = null;
          YAxisBase.prototype.user_labels = null;
          YAxisBase.prototype.user_ticks = false;
          YAxisBase.prototype.init = function(range, json) {};
          YAxisBase.prototype._init = function(range, json, name, style) {

            this.style = style;

            if (json[name])
              object_helper.merge_2(json[name], this.style);

            this.colour = Utils.get_colour(style.colour);
            this.grid_colour = Utils.get_colour(style['grid-colour']);
            this.stroke = style.stroke;
            this.tick_length = style['tick-length'];

            tr.aces('YAxisBase auto', this.round_dn(range.min), this.round_up(range.max));
            tr.aces('YAxisBase min, max', this.style.min, this.style.max);

            if (this.labels.i_need_labels) {
              if (this.style.max == null && this.style.min == null) {
                // No labels and not min, max set:
                this.style.min = this.round_dn(range.min);
                this.style.max = this.round_up(range.max);
              }

            } else {
              if (this.style.max == null) {
                // we have labels, so use the number of labels as Y MAX
                this.style.max = this.labels.y_max;
              }
            }

            // make sure we don't have 1,000,000 steps
            var min = Math.min(this.style.min, this.style.max);
            var max = Math.max(this.style.min, this.style.max);
            this.style.steps = this.get_steps(min, max, this.stage.stageHeight);

            if (this.labels.i_need_labels)
              this.labels.make_labels(min, max, this.style.steps);

            //
            // colour the grid lines
            //
            // TODO: remove this and
            //       this.user_ticks
            //       this.user_labels
            //
            if ((this.style.labels != null) &&
              (this.style.labels.labels != null) &&
              (this.style.labels.labels is Array) &&
              (this.style.labels.labels.length > 0)) {
              this.user_labels = [];
              for each(var lbl in this.style.labels.labels) {
                if (!(lbl is String)) {
                  if (lbl.y != null) {
                    var tmpObj = {
                      y: lbl.y
                    };
                    if (lbl["grid-colour"]) {
                      tmpObj["grid-colour"] = Utils.get_colour(lbl["grid-colour"]);
                    } else {
                      tmpObj["grid-colour"] = this.grid_colour;
                    }

                    this.user_ticks = true;
                    this.user_labels.push(tmpObj);
                  }
                }
              }
            }
          };
          YAxisBase.prototype.round_dn = function(max) {

            var factor = 50;

            return Math.floor(max / factor) * factor;
          };
          YAxisBase.prototype.round_up = function(max) {

            var factor = 50;

            return Math.round(max / factor) * factor;

            /*
            var minus = false;
          
            if (max < 0 ) {
              max *= -1;
              minus = true;
            }
              
            var maxValue = max * 1.07;
            var l = Math.round(Math.log(maxValue)/Math.log(10));
            var p = Math.pow(10, l) / 2;
            maxValue = Math.round((maxValue * 1.1) / p) * p;
            if (minus)
              maxValue *= -1;
              
            return maxValue;
            */
            /**/

            /*
            var maxValue = Math.max($bar_1->data) * 1.07;
            $l = round(log($maxValue)/log(10));
            $p = pow(10, $l) / 2;
            $maxValue = round($maxValue * 1.1 / $p) * $p;
            */

            /*
           * http://forums.openflashchart.com/viewtopic.php?f=5&t=617&start=0
           * cdcarson
              // y axis data...
        $counts = array_values($data);
        $ymax = max($counts);
        // add a bit of padding to the top, not strictly necessary...
        $ymax += ceil(.1 * $ymax);
        //$max_steps could be anything,depending on the height of the chart, font-size, etc..
        $max_steps = 10;
        /**
        * The step sizes to test are created using an
        * array of multipliers and a power of 10, starting at 0.
        * $step_size = $multiplier * pow(10, $exponent);
        * Assuming $multipliers = array(1, 2, 5) this would give us...
        * 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000,...
        * /
        $n = 0;
        $multipliers = array(1, 2, 5);
        $num_multipliers = count($multipliers);
        $exponent = floor($n / $num_multipliers);
        $multiplier = $multipliers[$n % $num_multipliers];
        $step_size = $multiplier * pow(10, $exponent);
        $num_steps = ceil($ymax/$step_size);
        //keep testing until we have the right step_size...
        while ($num_steps >= $max_steps){
           $n ++;
           $exponent = floor($n / $num_multipliers);
           $multiplier = $multipliers[$n % $num_multipliers];
           $step_size = $multiplier * pow(10, $exponent);
           $num_steps = ceil($ymax/$step_size);
        }
        $yaxis = new y_axis();
        $yaxis->set_range(0, $ymax, $step_size);
    
           */

          };
          YAxisBase.prototype.doMultiplier = function(steps) {
            // TODO: This starting value will not work on decimal values: 0.001, 0.00001...
            var multiplier = 0.1;
            // Multiply "multiplier" by the digits in "multiplierStep" to get a sequence of: 1, 2, 5, 10, 20, 50...
            var multiplierStep = [2, 2.5, 2];
            var i = 0;
            do {
              multiplier *= multiplierStep[i];
              //tr.ace("MULTIPLIER: " + multiplier + " index: " + i + " step: " + multiplierStep[i] + " steps: " + steps);
              if ((steps / multiplier) < multiplierStep[i])
                break;
              i++;
              if (i >= multiplierStep.length)
                i = 0;
            } while (true);
            return multiplier;
          };
          YAxisBase.prototype.get_style = function() {
            return null;
          };
          YAxisBase.prototype.set_y_max = function(m) {
            this.style.max = m;
          };
          YAxisBase.prototype.get_range = function() {
            return new Range(this.style.min, this.style.max, this.style.steps, this.style.offset);
          };
          YAxisBase.prototype.get_width = function() {
            return this.stroke + this.tick_length + this.labels.width;
          };
          YAxisBase.prototype.die = function() {

            //this.offset = null;
            this.style = null;
            if (this.labels != null) this.labels.die();
            this.labels = null;

            this.graphics.clear();
            while (this.numChildren > 0)
              this.removeChildAt(0);
          };
          YAxisBase.prototype.get_steps = function(min, max, height) {
            // try to avoid infinite loops...
            if (this.style.steps == 0)
            //this.style.steps = 1;
              this.style.steps = this.doMultiplier(Math.round((max - min) / (height / 40)));

            if (this.style.steps < 0)
              this.style.steps *= -1;

            // how many steps (grid lines) do we have?
            var s = (max - min) / this.style.steps;

            if (s > (height / 2)) {
              // either no steps are set, or they are wrong and
              // we have more grid lines than pixels to show them.
              // E.g: 
              //      max = 1,001,000
              //      min =     1,000
              //      s   =   200,000
              return (max - min) / 5;
            }

            return this.style.steps;
          };
          YAxisBase.prototype.resize = function(label_pos, sc) {};
          YAxisBase.prototype.resize_helper = function(label_pos, sc, right) {

            // Set opacity for the first line to 0 (otherwise it overlaps the x-axel line)
            //
            // Bug? Does this work on graphs with minus values?
            //
            var i2 = 0;
            var i;
            var y;
            var lbl;

            var min = Math.min(this.style.min, this.style.max);
            var max = Math.max(this.style.min, this.style.max);

            if (!right)
              this.labels.resize(label_pos, sc);
            else
              this.labels.resize(sc.right + this.stroke + this.tick_length, sc);

            if (!this.style.visible)
              return;

            this.graphics.clear();
            this.graphics.lineStyle(0, 0, 0);

            if (this.style['grid-visible'])
              this.draw_grid_lines(this.style.steps, min, max, right, sc);

            var pos;

            if (!right)
              pos = sc.left - this.stroke;
            else
              pos = sc.right;

            // Axis line:
            this.graphics.beginFill(this.colour, 1);
            this.graphics.drawRect(
              int(pos), // <-- pixel align
              sc.top,
              this.stroke,
              sc.height);
            this.graphics.endFill();

            // ticks..
            var width;
            if (this.user_ticks) {
              for each(lbl in this.user_labels) {
                y = sc.get_y_from_val(lbl.y, right);

                if (!right)
                  tick_pos = sc.left - this.stroke - this.tick_length;
                else
                  tick_pos = sc.right + this.stroke;

                this.graphics.beginFill(this.colour, 1);
                this.graphics.drawRect(tick_pos, y - (this.stroke / 2), this.tick_length, this.stroke);
                this.graphics.endFill();
              }
            } else {
              for (i = min; i <= max; i += this.style.steps) {

                // start at the bottom and work up:
                y = sc.get_y_from_val(i, right);

                var tick_pos;
                if (!right)
                  tick_pos = sc.left - this.stroke - this.tick_length;
                else
                  tick_pos = sc.right + this.stroke;

                this.graphics.beginFill(this.colour, 1);
                this.graphics.drawRect(tick_pos, y - (this.stroke / 2), this.tick_length, this.stroke);
                this.graphics.endFill();
              }
            }
          };
          YAxisBase.prototype.draw_grid_lines = function(steps, min, max, right, sc) {

            var y;
            var lbl;
            //
            // draw GRID lines
            //
            if (this.user_ticks) {
              for each(lbl in this.user_labels) {
                y = sc.get_y_from_val(lbl.y, right);
                this.graphics.beginFill(lbl["grid-colour"], 1);
                this.graphics.drawRect(sc.left, y, sc.width, 1);
                this.graphics.endFill();
              }
            } else {
              //
              // hack: http://kb.adobe.com/selfservice/viewContent.do?externalId=tn_13989&sliceId=1
              //
              max += 0.000004;

              for (var i = min; i <= max; i += steps) {

                y = sc.get_y_from_val(i, right);
                this.graphics.beginFill(this.grid_colour, 1);
                this.graphics.drawRect(
                  int(sc.left),
                  int(y), // <-- make sure they are pixel aligned (2.5 - 3.5 == fuzzy lines)
                  sc.width,
                  1);
                this.graphics.endFill();
              }
            }
          }

          module.exports = YAxisBase;
        };
        Program["elements.axis.YAxisLabelsBase"] = function(module, exports) {
          var NumberUtils, object_helper, tr, YLabelStyle, YTextField;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            object_helper = module.import('', 'object_helper');
            tr = module.import('', 'tr');
            YLabelStyle = module.import('elements.axis', 'YLabelStyle');
            YTextField = module.import('elements.axis', 'YTextField');
          };

          var YAxisLabelsBase = function(json, axis_name) {
            this.style = null;
            var i;
            var s;
            var values;
            var steps;

            // TODO: calculate Y max from the data
            this.y_max = 10;

            if (json[axis_name]) {
              //
              // Old crufty JSON, refactor out at some point,
              // 
              //
              if (json[axis_name].labels is Array) {
                values = [];

                // use passed in min if provided else zero
                i = (json[axis_name] && json[axis_name].min) ? json[axis_name].min : 0;
                for each(s in json[axis_name].labels) {
                    values.push({
                      val: s,
                      pos: i
                    });
                    i++;
                  }
                  //
                  // alter the MinMax object:
                  //
                  // use passed in max if provided else the number of values less 1
                this.y_max = (json[axis_name] && json[axis_name].max) ? json[axis_name].max : values.length - 1;
                this.i_need_labels = false;
              }
            }

            //
            // an object, that contains an array of objects:
            //
            if (json[axis_name]) {
              if (json[axis_name].labels is Object) {
                if (json[axis_name].labels.text is String)
                  this.lblText = json[axis_name].labels.text;

                var visibleSteps = 1;
                if (json[axis_name].steps is Number)
                  visibleSteps = json[axis_name].steps;

                if (json[axis_name].labels.steps is Number)
                  visibleSteps = json[axis_name].labels.steps;

                if (json[axis_name].labels.labels is Array) {
                  values = [];
                  // use passed in min if provided else zero
                  var label_pos = (json[axis_name] && json[axis_name].min) ? json[axis_name].min : 0;

                  for each(var obj in json[axis_name].labels.labels) {
                    if (obj is Number) {
                      values.push({
                        val: this.lblText,
                        pos: obj
                      });
                      //i = (obj > i) ? obj as Number : i;
                    } else if (obj is String) {
                      values.push({
                        val: obj,
                        pos: label_pos,
                        visible: ((label_pos % visibleSteps) == 0)
                      });
                      //i = (obj > i) ? obj as Number : i;
                    } else if (obj.y is Number) {
                      s = (obj.text is String) ? obj.text : this.lblText;
                      var style = {
                        val: s,
                        pos: obj.y
                      }
                      if (obj.colour != null)
                        style.colour = obj.colour;

                      if (obj.size != null)
                        style.size = obj.size;

                      if (obj.rotate != null)
                        style.rotate = obj.rotate;

                      values.push(style);
                      //i = (obj.y > i) ? obj.y : i;
                    }

                    label_pos++;
                  }
                  this.i_need_labels = false;
                }
              }
            }

            this.steps = steps;

            var lblStyle = new YLabelStyle(json, name);
            this.style = lblStyle.style;

            //
            // TODO: hack, if the user has not defined either left or right
            //       by default set left axis to show and right to hide.
            //
            if (!json[axis_name] && axis_name != 'y_axis')
              this.style.show_labels = false;
            //
            //

            // Default to using "rotate" from the y_axis level
            if (json[axis_name] && json[axis_name].rotate) {
              this.style.rotate = json[axis_name].rotate;
            }

            // Next override with any values at the y_axis.labels level
            if ((json[axis_name] != null) &&
              (json[axis_name].labels != null)) {
              object_helper.merge_2(json[axis_name].labels, this.style);
            }

            this.add_labels(values);
          };

          YAxisLabelsBase.prototype = Object.create(Sprite.prototype);

          YAxisLabelsBase.prototype.steps = 0;
          YAxisLabelsBase.prototype.right = false;
          YAxisLabelsBase.prototype.style = null;
          YAxisLabelsBase.prototype.i_need_labels = false;
          YAxisLabelsBase.prototype.lblText = null;
          YAxisLabelsBase.prototype.y_max = 0;
          YAxisLabelsBase.prototype.add_labels = function(values) {

            // are the Y Labels visible?
            if (!this.style.show_labels)
              return;

            // labels
            var pos = 0;

            for each(var v in values) {
              var lblStyle = {};
              object_helper.merge_2(this.style, lblStyle);
              object_helper.merge_2(v, lblStyle);

              if (lblStyle.visible) {
                var tmp = this.make_label(lblStyle);
                tmp.y_val = v.pos;
                this.addChild(tmp);

                pos++;
              }
            }
          };
          YAxisLabelsBase.prototype.make_labels = function(min, max, steps) {

            tr.aces('make_labels', this.i_need_labels, min, max, false, steps, this.lblText);
            tr.aces(this.style.show_labels);

            if (!this.i_need_labels)
              return;

            this.i_need_labels = false;
            this.make_labels_(min, max, false, steps, this.lblText);
          };
          YAxisLabelsBase.prototype.make_labels_ = function(min, max, right, steps, lblText) {
            var values = [];

            var min_ = Math.min(min, max);
            var max_ = Math.max(min, max);

            // hack: hack: http://kb.adobe.com/selfservice/viewContent.do?externalId=tn_13989&sliceId=1
            max_ += 0.000004;

            var eek = 0;
            for (var i = min_; i <= max_; i += steps) {
              values.push({
                val: lblText,
                pos: i
              });

              // make sure we don't generate too many labels:
              if (eek++ > 250) break;
            }

            this.add_labels(values);
          };
          YAxisLabelsBase.prototype.make_label = function(lblStyle) {

            lblStyle.colour = string.Utils.get_colour(lblStyle.colour);

            var tf = new YTextField();
            //tf.border = true;
            tf.text = this.replace_magic_values(lblStyle.val, lblStyle.pos);
            var fmt = new TextFormat();
            fmt.color = lblStyle.colour;
            fmt.font = lblStyle.rotate == "vertical" ? "spArial" : "Verdana";
            fmt.size = lblStyle.size;
            fmt.align = "right";
            tf.setTextFormat(fmt);
            tf.autoSize = "right";
            if (lblStyle.rotate == "vertical") {
              tf.rotation = 270;
              tf.embedFonts = true;
              tf.antiAliasType = flash.text.AntiAliasType.ADVANCED;
            }
            return tf;
          };
          YAxisLabelsBase.prototype.resize = function(left, sc) {};
          YAxisLabelsBase.prototype.get_width = function() {
            var max = 0;
            for (var i = 0; i < this.numChildren; i++) {
              var tf = (YTextField) this.getChildAt(i);
              max = Math.max(max, tf.width);
            }
            return max;
          };
          YAxisLabelsBase.prototype.die = function() {

            while (this.numChildren > 0)
              this.removeChildAt(0);
          };
          YAxisLabelsBase.prototype.replace_magic_values = function(labelText, yVal) {
            labelText = labelText.replace('#val#', NumberUtils.formatNumber(yVal));
            return labelText;
          }

          module.exports = YAxisLabelsBase;
        };
        Program["elements.axis.YAxisLabelsLeft"] = function(module, exports) {
          var YAxisLabelsBase = module.import('elements.axis', 'YAxisLabelsBase');
          var YTextField;
          module.inject = function() {
            YTextField = module.import('elements.axis', 'YTextField');
          };

          var YAxisLabelsLeft = function(json) {

            this.lblText = "#val#";
            this.i_need_labels = true;

            YAxisLabelsBase.call(this, json, 'y_axis');
          };

          YAxisLabelsLeft.prototype = Object.create(YAxisLabelsBase.prototype);

          YAxisLabelsLeft.prototype.resize = function(left, sc) {

            var maxWidth = this.get_width();
            var i;
            var tf;

            for (i = 0; i < this.numChildren; i++) {
              // right align
              tf = (YTextField) this.getChildAt(i);
              tf.x = left - tf.width + maxWidth;
            }

            // now move it to the correct Y, vertical center align
            for (i = 0; i < this.numChildren; i++) {
              tf = (YTextField) this.getChildAt(i);
              if (tf.rotation != 0) {
                tf.y = sc.get_y_from_val(tf.y_val, false) + (tf.height / 2);
              } else {
                tf.y = sc.get_y_from_val(tf.y_val, false) - (tf.height / 2);
              }

              //
              // this is a hack so if the top
              // label is off the screen (no chart title or key set)
              // then move it down a little.
              //
              if (tf.y < 0 && sc.top == 0) // Tried setting tf.height but that didnt work 
                tf.y = (tf.rotation != 0) ? tf.height : tf.textHeight - tf.height;
            }
          }

          module.exports = YAxisLabelsLeft;
        };
        Program["elements.axis.YAxisLabelsRight"] = function(module, exports) {
          var YAxisLabelsBase = module.import('elements.axis', 'YAxisLabelsBase');
          var YTextField;
          module.inject = function() {
            YTextField = module.import('elements.axis', 'YTextField');
          };

          var YAxisLabelsRight = function(json) {

            this.lblText = "#val#";
            this.i_need_labels = true;

            YAxisLabelsBase.call(this, json, 'y_axis_right');
          };

          YAxisLabelsRight.prototype = Object.create(YAxisLabelsBase.prototype);

          YAxisLabelsRight.prototype.resize = function(left, box) {
            var maxWidth = this.get_width();
            var i;
            var tf;

            for (i = 0; i < this.numChildren; i++) {
              // left align
              tf = (YTextField) this.getChildAt(i);
              tf.x = left; // - tf.width + maxWidth;
            }

            // now move it to the correct Y, vertical center align
            for (i = 0; i < this.numChildren; i++) {
              tf = (YTextField) this.getChildAt(i);
              if (tf.rotation != 0) {
                tf.y = box.get_y_from_val(tf.y_val, true) + (tf.height / 2);
              } else {
                tf.y = box.get_y_from_val(tf.y_val, true) - (tf.height / 2);
              }
              if (tf.y < 0 && box.top == 0) // Tried setting tf.height but that didnt work 
                tf.y = (tf.rotation != 0) ? tf.height : tf.textHeight - tf.height;
            }
          }

          module.exports = YAxisLabelsRight;
        };
        Program["elements.axis.YAxisLeft"] = function(module, exports) {
          var YAxisBase = module.import('elements.axis', 'YAxisBase');
          var YAxisLabelsLeft;
          module.inject = function() {
            YAxisLabelsLeft = module.import('elements.axis', 'YAxisLabelsLeft');
          };

          var YAxisLeft = function() {};

          YAxisLeft.prototype = Object.create(YAxisBase.prototype);

          YAxisLeft.prototype.init = function(range, json) {

            this.labels = new YAxisLabelsLeft(json);
            this.addChild(this.labels);

            //
            // default values for a left axis
            //
            var style = {
              this.stroke: 2,
                'tick-length': 3,
                this.colour: '#784016',
                offset: false,
                'grid-colour': '#F5E1AA',
                'grid-visible': true,
                '3d': 0,
                steps: 1,
                visible: true,
                min: null,
                max: null
            };

            YAxisBase.prototype._init.call(this, range, json, 'y_axis', style);
          };
          YAxisLeft.prototype.resize = function(label_pos, sc) {

            YAxisBase.prototype.resize_helper.call(this, label_pos, sc, false);
          }

          module.exports = YAxisLeft;
        };
        Program["elements.axis.YAxisRight"] = function(module, exports) {
          var YAxisBase = module.import('elements.axis', 'YAxisBase');
          var YAxisLabelsRight;
          module.inject = function() {
            YAxisLabelsRight = module.import('elements.axis', 'YAxisLabelsRight');
          };

          var YAxisRight = function() {};

          YAxisRight.prototype = Object.create(YAxisBase.prototype);

          YAxisRight.prototype.init = function(range, json) {

            this.labels = new YAxisLabelsRight(json);
            this.addChild(this.labels);

            //
            // default values for a right axis (turned off)
            //
            var style = {
              this.stroke: 2,
                'tick-length': 3,
                this.colour: '#784016',
                offset: false,
                'grid-colour': '#F5E1AA',
                'grid-visible': false, // <-- this is off by default for RIGHT axis
                '3d': 0,
                steps: 1,
                visible: false, // <-- by default this is invisible
                min: null,
                max: null
            };

            //
            // OK, the user has set the right Y axis,
            // but forgot to specifically set visible to
            // true, I think we can forgive them:
            //
            if (json.y_axis_right)
              style.visible = true;

            YAxisBase.prototype._init.call(this, range, json, 'y_axis_right', style);
          };
          YAxisRight.prototype.resize = function(label_pos, sc) {

            YAxisBase.prototype.resize_helper.call(this, label_pos, sc, true);
          }

          module.exports = YAxisRight;
        };
        Program["elements.axis.YLabelStyle"] = function(module, exports) {
          var Utils;
          module.inject = function() {
            Utils = module.import('string', 'Utils');
          };

          var YLabelStyle = function(json, name) {
            this.style = null;

            this.style = {
              size: 10,
              colour: 0x000000,
              show_labels: true,
              visible: true
            };

            var comma;
            var none;
            var tmp;

            if (json[name + '_label_style'] == undefined)
              return;

            // is it CSV?
            comma = json[name + '_label_style'].lastIndexOf(',');

            if (comma < 0) {
              none = json[name + '_label_style'].lastIndexOf('none', 0);
              if (none > -1) {
                this.style.show_labels = false;
              }
            } else {
              tmp = json[name + '_label_style'].split(',');
              if (tmp.length > 0)
                this.style.size = tmp[0];

              if (tmp.length > 1)
                this.style.colour = Utils.get_colour(tmp[1]);
            }
          };

          YLabelStyle.prototype.style = null

          module.exports = YLabelStyle;
        };
        Program["elements.axis.YTextField"] = function(module, exports) {
          var YTextField = function() {
            TextField.call(this);
            this.y_val = 0;
          };

          YTextField.prototype = Object.create(TextField.prototype);

          YTextField.prototype.y_val = 0

          module.exports = YTextField;
        };
        Program["elements.labels.BaseLabel"] = function(module, exports) {
          var BaseLabel = function() {
            this.css = null;
          };

          BaseLabel.prototype = Object.create(Sprite.prototype);

          BaseLabel.prototype.text = null;
          BaseLabel.prototype.css = null;
          BaseLabel.prototype.style = null;
          BaseLabel.prototype._height = 0;
          BaseLabel.prototype.build = function(text) {

            var title = new TextField();
            title.x = 0;
            title.y = 0;

            this.text = text;

            title.htmlText = this.text;

            var fmt = new TextFormat();
            fmt.color = this.css.color;
            //fmt.font = "Verdana";
            fmt.font = this.css.font_family ? this.css.font_family : 'Verdana';
            fmt.bold = this.css.font_weight == 'bold' ? true : false;
            fmt.size = this.css.font_size;
            fmt.align = "center";

            title.setTextFormat(fmt);
            title.autoSize = "left";

            title.y = this.css.padding_top + this.css.margin_top;
            title.x = this.css.padding_left + this.css.margin_left;

            //      title.border = true;

            if (this.css.background_colour_set) {
              this.graphics.beginFill(this.css.background_colour, 1);
              this.graphics.drawRect(0, 0, this.css.padding_left + title.width + this.css.padding_right, this.css.padding_top + title.height + this.css.padding_bottom);
              this.graphics.endFill();
            }

            this.addChild(title);
          };
          BaseLabel.prototype.get_width = function() {
            return this.getChildAt(0).width;
          };
          BaseLabel.prototype.die = function() {

            this.graphics.clear();
            while (this.numChildren > 0)
              this.removeChildAt(0);
          }

          module.exports = BaseLabel;
        };
        Program["elements.labels.Keys"] = function(module, exports) {
          var Keys = function(stuff) {
            this.colours = null;
            this.colours = [];

            var key = 0;
            for each(var b in stuff.sets) {
              for each(var o in b.get_keys()) {

                this.make_key(o.text, o['font-size'], o.colour);
                this.colours.push(o.colour);
                key++;

              }
            }

            this.count = key;
          };

          Keys.prototype = Object.create(Sprite.prototype);

          Keys.prototype._height = 0;
          Keys.prototype.count = 0;
          Keys.prototype.colours = null;
          Keys.prototype.make_key = function(text, font_size, colour) {

            var tf = new TextField();

            tf.text = text;
            var fmt = new TextFormat();
            fmt.color = colour;
            fmt.font = "Verdana";
            fmt.size = font_size;
            fmt.align = "left";

            tf.setTextFormat(fmt);
            tf.autoSize = "left";

            this.addChild(tf);
          };
          Keys.prototype.draw_line = function(x, y, height, colour) {
            y += (height / 2);
            this.graphics.beginFill(colour, 100);
            this.graphics.drawRect(x, y - 1, 10, 2);
            this.graphics.endFill();
            return x + 12;
          };
          Keys.prototype.resize = function(x, y) {
            if (this.count == 0)
              return;

            this.x = x;
            this.y = y;

            var height = 0;
            var x = 0;
            var y = 0;

            this.graphics.clear();

            for (var i = 0; i < this.numChildren; i++) {
              var width = this.getChildAt(i).width;

              if ((this.x + x + width + 12) > this.stage.stageWidth) {
                // it is past the edge of the stage, so move it down a line
                x = 0;
                y += this.getChildAt(i).height;
                height += this.getChildAt(i).height;
              }

              this.draw_line(x, y, this.getChildAt(i).height, this.colours[i]);
              x += 12;

              this.getChildAt(i).x = x;
              this.getChildAt(i).y = y;

              // move next key to the left + some padding between keys
              x += width + 10;
            }

            // Ugly code:
            height += this.getChildAt(0).height;
            this._height = height;
          };
          Keys.prototype.get_height = function() {
            return this._height;
          };
          Keys.prototype.die = function() {

            this.colours = null;

            this.graphics.clear();
            while (this.numChildren > 0)
              this.removeChildAt(0);
          }

          module.exports = Keys;
        };
        Program["elements.labels.Title"] = function(module, exports) {
          var BaseLabel = module.import('elements.labels', 'BaseLabel');
          var object_helper, Css;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Css = module.import('string', 'Css');
          };

          var Title = function(json) {
            BaseLabel.call(this);

            if (!json)
              return;

            // defaults:
            this.style = "font-size: 12px";

            object_helper.merge_2(json, this);

            this.css = new Css(this.style);
            this.build(this.text);
          };

          Title.prototype = Object.create(BaseLabel.prototype);

          Title.prototype.colour = 0;
          Title.prototype.size = 0;
          Title.prototype.top_padding = 0;
          Title.prototype.resize = function() {
            if (this.text == null)
              return;

            this.getChildAt(0).width = this.stage.stageWidth;

            //
            // is the title aligned (text-align: xxx)?
            //
            var tmp = this.css.text_align;
            switch (tmp) {
              case 'left':
                this.x = this.css.margin_left;
                break;

              case 'right':
                this.x = this.stage.stageWidth - (this.get_width() + this.css.margin_right);
                break;

              case 'center':
              default:
                this.x = (this.stage.stageWidth / 2) - (this.get_width() / 2);
                break;
            }

            this.y = this.css.margin_top;
          };
          Title.prototype.get_height = function() {

            if (this.text == null)
              return 0;
            else
              return this.css.padding_top +
                this.css.margin_top +
                this.getChildAt(0).height +
                this.css.padding_bottom +
                this.css.margin_bottom;
          }

          module.exports = Title;
        };
        Program["elements.labels.XLegend"] = function(module, exports) {
          var BaseLabel = module.import('elements.labels', 'BaseLabel');
          var object_helper, Css;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Css = module.import('string', 'Css');
          };

          var XLegend = function(json) {
            BaseLabel.call(this);

            if (!json)
              return;

            object_helper.merge_2(json, this);

            this.css = new Css(this.style);

            // call our parent constructor:
            this.build(this.text);
          };

          XLegend.prototype = Object.create(BaseLabel.prototype);

          XLegend.prototype.resize = function(sc) {
            if (this.text == null)
              return;

            // this will center it in the X
            // this will align bottom:
            this.x = sc.left + ((sc.width / 2) - (this.get_width() / 2));
            //this.getChildAt(0).width = this.stage.stageWidth;
            this.getChildAt(0).y = this.stage.stageHeight - this.getChildAt(0).height;
          };
          XLegend.prototype.get_height = function() {
            // the title may be turned off:
            return this.height;
          }

          module.exports = XLegend;
        };
        Program["elements.labels.YLegendBase"] = function(module, exports) {
          var object_helper, Css;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Css = module.import('string', 'Css');
            YLegendBase.ArialFont = null;
          };

          var YLegendBase = function(json, name) {
            this.tf = null;
            this.css = null;

            if (json[name + '_legend'] == undefined)
              return;

            if (json[name + '_legend']) {
              object_helper.merge_2(json[name + '_legend'], this);
            }

            this.css = new Css(this.style);

            this.build(this.text);
          };

          YLegendBase.prototype = Object.create(Sprite.prototype);

          YLegendBase.ArialFont = null;

          YLegendBase.prototype.tf = null;
          YLegendBase.prototype.text = null;
          YLegendBase.prototype.style = null;
          YLegendBase.prototype.css = null;
          YLegendBase.prototype.build = function(text) {
            var title = new TextField();

            title.x = 0;
            title.y = 0;

            var fmt = new TextFormat();
            fmt.color = this.css.color;
            fmt.font = "spArial";
            fmt.size = this.css.font_size;
            fmt.align = "center";

            title.htmlText = text;
            title.setTextFormat(fmt);
            title.autoSize = "left";
            title.embedFonts = true;
            title.rotation = 270;
            title.height = title.textHeight;
            title.antiAliasType = AntiAliasType.ADVANCED;
            title.autoSize = TextFieldAutoSize.LEFT;

            this.addChild(title);
          };
          YLegendBase.prototype.resize = function() {
            if (this.text == null)
              return;
          };
          YLegendBase.prototype.get_width = function() {
            if (this.numChildren == 0)
              return 0;
            else
              return this.getChildAt(0).width;
          };
          YLegendBase.prototype.die = function() {

            while (this.numChildren > 0)
              this.removeChildAt(0);
          }

          module.exports = YLegendBase;
        };
        Program["elements.labels.YLegendLeft"] = function(module, exports) {
          var YLegendBase = module.import('elements.labels', 'YLegendBase');

          var YLegendLeft = function(json) {
            YLegendBase.call(this, json, 'y');
          };

          YLegendLeft.prototype = Object.create(YLegendBase.prototype);

          YLegendLeft.prototype.resize = function() {
            if (this.numChildren == 0)
              return;

            this.y = (this.stage.stageHeight / 2) + (this.getChildAt(0).height / 2);
            this.x = 0;
          }

          module.exports = YLegendLeft;
        };
        Program["elements.labels.YLegendRight"] = function(module, exports) {
          var YLegendBase = module.import('elements.labels', 'YLegendBase');

          var YLegendRight = function(json) {
            YLegendBase.call(this, json, 'y2');
          };

          YLegendRight.prototype = Object.create(YLegendBase.prototype);

          YLegendRight.prototype.resize = function() {
            if (this.numChildren == 0)
              return;

            this.y = (this.stage.stageHeight / 2) + (this.getChildAt(0).height / 2);
            this.x = this.stage.stageWidth - this.getChildAt(0).width;
          }

          module.exports = YLegendRight;
        };
        Program["elements.menu.CameraIcon"] = function(module, exports) {
          var menuItem = module.import('elements.menu', 'menuItem');

          var CameraIcon = function(chartId, props) {
            menuItem.call(this, chartId, props);
          };

          CameraIcon.prototype = Object.create(menuItem.prototype);

          CameraIcon.prototype.add_elements = function() {

            this.draw_camera();
            var width = this.add_text(this.props.get('text'), 35);

            return width + 30; // 30 is the icon width
          };
          CameraIcon.prototype.draw_camera = function() {

            var s = new Sprite();

            s.graphics.beginFill(0x505050);
            s.graphics.drawRoundRect(2, 4, 26, 14, 2, 2);
            s.graphics.drawRect(20, 1, 5, 3);
            s.graphics.endFill();

            s.graphics.beginFill(0x202020);
            s.graphics.drawCircle(9, 11, 4.5);
            s.graphics.endFill();

            this.addChild(s);

          }

          module.exports = CameraIcon;
        };
        Program["elements.menu.DefaultCameraIconProperties"] = function(module, exports) {
          var Properties = module.import('', 'Properties');

          var DefaultCameraIconProperties = function(json) {

            // the user JSON can override any of these:
            var parent = new Properties({
              'colour': '#0000E0',
              'text': "Save chart",
              'javascript-function': "save_image",
              'background-colour': "#ffffff",
              'glow-colour': "#148DCF",
              'text-colour': "#0000ff"
            });

            Properties.call(this, json, parent);

          };

          DefaultCameraIconProperties.prototype = Object.create(Properties.prototype);

          module.exports = DefaultCameraIconProperties;
        };
        Program["elements.menu.DefaultMenuProperties"] = function(module, exports) {
          var Properties = module.import('', 'Properties');

          var DefaultMenuProperties = function(json) {

            // the user JSON can override any of these:
            var parent = new Properties({
              'colour': '#E0E0E0',
              "outline-colour": "#707070",
              'camera-text': "Save chart"
            });

            Properties.call(this, json, parent);

          };

          DefaultMenuProperties.prototype = Object.create(Properties.prototype);

          module.exports = DefaultMenuProperties;
        };
        Program["elements.menu.Menu"] = function(module, exports) {
          var DefaultCameraIconProperties, DefaultMenuProperties, menu_item_factory, Equations, Tweener;
          module.inject = function() {
            DefaultCameraIconProperties = module.import('elements.menu', 'DefaultCameraIconProperties');
            DefaultMenuProperties = module.import('elements.menu', 'DefaultMenuProperties');
            menu_item_factory = module.import('elements.menu', 'menu_item_factory');
            Equations = module.import('caurina.transitions', 'Equations');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var Menu = function(chartID, json) {
            this.props = null;

            this.props = new DefaultMenuProperties(json);

            this.original_alpha = 0.4;
            this.alpha = 1;

            var pos = 5;
            var height = 0;
            this.first_showing = true;

            for each(var val in json.values) {
              var tmp = new DefaultCameraIconProperties(val);
              var menu_item = menu_item_factory.make(chartID, tmp);
              menu_item.x = 5;
              menu_item.y = pos;
              this.addChild(menu_item);
              height = menu_item.y + menu_item.height + 5;
              pos += menu_item.height + 5;
            }

            var width = 0;

            for (var i = 0; i < this.numChildren; i++)
              width = Math.max(width, this.getChildAt(i).width);

            this.draw(width + 10, height);
            this.hidden_pos = height;

            /*
            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 4;
            dropShadow.blurY = 4;
            dropShadow.distance = 4;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.5;
            // apply shadow filter
            this.filters = [dropShadow];
            */

            this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
          };

          Menu.prototype = Object.create(Sprite.prototype);

          Menu.prototype.original_alpha = 0;
          Menu.prototype.props = null;
          Menu.prototype.first_showing = false;
          Menu.prototype.hidden_pos = 0;
          Menu.prototype.draw = function(width, height) {

            this.graphics.clear();

            var colour = string.Utils.get_colour(this.props.get('colour'));
            var o_colour = string.Utils.get_colour(this.props.get('outline-colour'));

            this.graphics.lineStyle(1, o_colour);
            this.graphics.beginFill(colour, 1);
            this.graphics.moveTo(0, -2);
            this.graphics.lineTo(0, height);
            this.graphics.lineTo(width - 25, height);
            this.graphics.lineTo(width - 20, height + 10);
            this.graphics.lineTo(width, height + 10);
            this.graphics.lineTo(width, -2);
            this.graphics.endFill();

            // arrows
            this.graphics.lineStyle(1, o_colour);
            this.graphics.moveTo(width - 15, height + 3);
            this.graphics.lineTo(width - 10, height + 8);
            this.graphics.lineTo(width - 5, height + 3);

            this.graphics.moveTo(width - 15, height);
            this.graphics.lineTo(width - 10, height + 5);
            this.graphics.lineTo(width - 5, height);

          };
          Menu.prototype.mouseOverHandler = function(event) {
            Tweener.removeTweens(this);
            Tweener.addTween(this, {
              y: 0,
              time: 0.4,
              transition: Equations.easeOutBounce
            });
            Tweener.addTween(this, {
              alpha: 1,
              time: 0.4,
              transition: Equations.easeOutBounce
            });
          };
          Menu.prototype.mouseOutHandler = function(event) {
            this.hide_menu();
          };
          Menu.prototype.hide_menu = function() {
            Tweener.removeTweens(this);
            Tweener.addTween(this, {
              y: -this.hidden_pos,
              time: 0.4,
              transition: Equations.easeOutBounce
            });
            Tweener.addTween(this, {
              alpha: this.original_alpha,
              time: 0.4,
              transition: Equations.easeOutBounce
            });
          };
          Menu.prototype.resize = function() {

            if (this.first_showing) {
              this.y = 0;
              this.first_showing = false;
              Tweener.removeTweens(this);
              Tweener.addTween(this, {
                time: 3,
                onComplete: this.hide_menu
              });
            } else {
              this.y = -(this.height) + 10;
            }
            this.x = this.stage.stageWidth - this.width - 5;

          }

          module.exports = Menu;
        };
        Program["elements.menu.menuItem"] = function(module, exports) {
          var tr;
          module.inject = function() {
            tr = module.import('', 'tr');
          };

          var menuItem = function(chartId, props) {
            this.props = null;

            this.props = props;

            this.buttonMode = true;
            this.useHandCursor = true;
            this.chartId = chartId;

            this.alpha = 0.5;

            var width = this.add_elements();

            this.draw_bg(
              width +
              10 // 5px padding on either side
            );

            this.addEventListener(MouseEvent.CLICK, this.mouseClickHandler);
            this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverHandler);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutHandler);
          };

          menuItem.prototype = Object.create(Sprite.prototype);

          menuItem.prototype.chartId = null;
          menuItem.prototype.props = null;
          menuItem.prototype.add_elements = function() {
            var width = this.add_text(this.props.get('text'), 5);
            return width;
          };
          menuItem.prototype.draw_bg = function(width) {
            this.graphics.beginFill(string.Utils.get_colour(this.props.get('background-colour')));
            this.graphics.drawRoundRect(0, 0, width, 20, 5, 5);
            this.graphics.endFill();
          };
          menuItem.prototype.add_text = function(text, left) {
            var title = new TextField();
            title.x = left;
            title.y = 0;

            //this.text = 'Save chart';

            title.htmlText = text;

            var fmt = new TextFormat();
            fmt.color = string.Utils.get_colour(this.props.get('text-colour'));
            fmt.font = 'Verdana';
            //      fmt.bold = this.css.font_weight == 'bold'?true:false;
            fmt.size = 10; // this.css.font_size;
            fmt.underline = true;
            //      fmt.align = "center";

            title.setTextFormat(fmt);
            title.autoSize = "left";

            // so we don't get an I-beam cursor when we mouse
            // over the text - pass mouse messages onto the button
            title.mouseEnabled = false;

            //      title.border = true;

            this.addChild(title);

            return title.width;
          };
          menuItem.prototype.mouseClickHandler = function(event) {
            this.alpha = 0.0;
            tr.aces('Menu item clicked:', this.props.get('javascript-function') + '(' + this.chartId + ')');
            ExternalInterface.call(this.props.get('javascript-function'), this.chartId);
            this.alpha = 1.0;
          };
          menuItem.prototype.mouseOverHandler = function(event) {
            this.alpha = 1;

            ///Glow Filter
            var glow = new GlowFilter();
            glow.color = string.Utils.get_colour(this.props.get('glow-colour'));
            glow.alpha = 0.8;
            glow.blurX = 4;
            glow.blurY = 4;
            glow.inner = false;

            this.filters = AS3JS.Utils.createArray(g, null);
          };
          menuItem.prototype.mouseDownHandler = function(event) {
            this.alpha = 1.0;
          };
          menuItem.prototype.mouseOutHandler = function(event) {
            this.alpha = 0.5;
            this.filters = [];
          }

          module.exports = menuItem;
        };
        Program["elements.menu.menu_item_factory"] = function(module, exports) {
          var CameraIcon, menuItem;
          module.inject = function() {
            CameraIcon = module.import('elements.menu', 'CameraIcon');
            menuItem = module.import('elements.menu', 'menuItem');
          };

          var menu_item_factory = function menu_item_factory() {};

          menu_item_factory.make = function(chartID, style) {

            switch (style.get('type')) {
              case 'camera-icon':
                return new CameraIcon(chartID, style);
                break;

              default:
                return new menuItem(chartID, style);
                break;
            }
          };

          module.exports = menu_item_factory;
        };
        Program["br.com.stimuli.string.Match"] = function(module, exports) {
          var Match = function Match() {};

          Match.prototype.startIndex = null;
          Match.prototype.endIndex = null;
          Match.prototype.length = null;
          Match.prototype.content = null;
          Match.prototype.replacement = null;
          Match.prototype.before = null;
          Match.prototype.toString = function() {
            return "Match [" + this.startIndex + " - " + this.endIndex + "] (" + this.length + ") " + this.content + ", replacement:" + this.replacement + ";"
          };
          Match.prototype.truncateNumber = function(raw, decimals) {
            decimals = AS3JS.Utils.getDefaultValue(decimals, 2);
            var power = Math.pow(10, decimals);
            return Math.round(raw * (power)) / power;
          }

          module.exports = Match;
        };
        Program["caurina.transitions.AuxFunctions"] = function(module, exports) {
          var AuxFunctions = function AuxFunctions() {};

          AuxFunctions.numberToR = function(p_num) {
            // The initial & is meant to crop numbers bigger than 0xffffff
            return (p_num & 0xff0000) >> 16;
          };
          AuxFunctions.numberToG = function(p_num) {
            return (p_num & 0xff00) >> 8;
          };
          AuxFunctions.numberToB = function(p_num) {
            return (p_num & 0xff);
          };
          AuxFunctions.isInArray = function(p_string, p_array) {
            var l = p_array.length;
            for (var i = 0; i < l; i++) {
              if (p_array[i] == p_string) return true;
            }
            return false;
          };
          AuxFunctions.getObjectLength = function(p_object) {
            var totalProperties = 0;
            for (var pName in p_object) totalProperties++;
            return totalProperties;
          };
          AuxFunctions.concatObjects = function() {
            var args = Array.prototype.slice.call(arguments).splice(0);
            var finalObject = {};
            var currentObject;
            for (var i = 0; i < args.length; i++) {
              currentObject = args[i];
              for (var prop in currentObject) {
                if (currentObject[prop] == null) {
                  // delete in case is null
                  delete finalObject[prop];
                } else {
                  finalObject[prop] = currentObject[prop]
                }
              }
            }
            return finalObject;
          };

          module.exports = AuxFunctions;
        };
        Program["caurina.transitions.Equations"] = function(module, exports) {
          var Tweener;
          module.inject = function() {
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var Equations = function() {
            trace("Equations is a static class and should not be instantiated.")
          };

          Equations.init = function() {
            Tweener.registerTransition("easenone", Equations.easeNone);
            Tweener.registerTransition("linear", Equations.easeNone); // mx.transitions.easing.None.easeNone

            Tweener.registerTransition("easeinquad", Equations.easeInQuad); // mx.transitions.easing.Regular.easeIn
            Tweener.registerTransition("easeoutquad", Equations.easeOutQuad); // mx.transitions.easing.Regular.easeOut
            Tweener.registerTransition("easeinoutquad", Equations.easeInOutQuad); // mx.transitions.easing.Regular.easeInOut
            Tweener.registerTransition("easeoutinquad", Equations.easeOutInQuad);

            Tweener.registerTransition("easeincubic", Equations.easeInCubic);
            Tweener.registerTransition("easeoutcubic", Equations.easeOutCubic);
            Tweener.registerTransition("easeinoutcubic", Equations.easeInOutCubic);
            Tweener.registerTransition("easeoutincubic", Equations.easeOutInCubic);

            Tweener.registerTransition("easeinquart", Equations.easeInQuart);
            Tweener.registerTransition("easeoutquart", Equations.easeOutQuart);
            Tweener.registerTransition("easeinoutquart", Equations.easeInOutQuart);
            Tweener.registerTransition("easeoutinquart", Equations.easeOutInQuart);

            Tweener.registerTransition("easeinquint", Equations.easeInQuint);
            Tweener.registerTransition("easeoutquint", Equations.easeOutQuint);
            Tweener.registerTransition("easeinoutquint", Equations.easeInOutQuint);
            Tweener.registerTransition("easeoutinquint", Equations.easeOutInQuint);

            Tweener.registerTransition("easeinsine", Equations.easeInSine);
            Tweener.registerTransition("easeoutsine", Equations.easeOutSine);
            Tweener.registerTransition("easeinoutsine", Equations.easeInOutSine);
            Tweener.registerTransition("easeoutinsine", Equations.easeOutInSine);

            Tweener.registerTransition("easeincirc", Equations.easeInCirc);
            Tweener.registerTransition("easeoutcirc", Equations.easeOutCirc);
            Tweener.registerTransition("easeinoutcirc", Equations.easeInOutCirc);
            Tweener.registerTransition("easeoutincirc", Equations.easeOutInCirc);

            Tweener.registerTransition("easeinexpo", Equations.easeInExpo); // mx.transitions.easing.Strong.easeIn
            Tweener.registerTransition("easeoutexpo", Equations.easeOutExpo); // mx.transitions.easing.Strong.easeOut
            Tweener.registerTransition("easeinoutexpo", Equations.easeInOutExpo); // mx.transitions.easing.Strong.easeInOut
            Tweener.registerTransition("easeoutinexpo", Equations.easeOutInExpo);

            Tweener.registerTransition("easeinelastic", Equations.easeInElastic); // mx.transitions.easing.Elastic.easeIn
            Tweener.registerTransition("easeoutelastic", Equations.easeOutElastic); // mx.transitions.easing.Elastic.easeOut
            Tweener.registerTransition("easeinoutelastic", Equations.easeInOutElastic); // mx.transitions.easing.Elastic.easeInOut
            Tweener.registerTransition("easeoutinelastic", Equations.easeOutInElastic);

            Tweener.registerTransition("easeinback", Equations.easeInBack); // mx.transitions.easing.Back.easeIn
            Tweener.registerTransition("easeoutback", Equations.easeOutBack); // mx.transitions.easing.Back.easeOut
            Tweener.registerTransition("easeinoutback", Equations.easeInOutBack); // mx.transitions.easing.Back.easeInOut
            Tweener.registerTransition("easeoutinback", Equations.easeOutInBack);

            Tweener.registerTransition("easeinbounce", Equations.easeInBounce); // mx.transitions.easing.Bounce.easeIn
            Tweener.registerTransition("easeoutbounce", Equations.easeOutBounce); // mx.transitions.easing.Bounce.easeOut
            Tweener.registerTransition("easeinoutbounce", Equations.easeInOutBounce); // mx.transitions.easing.Bounce.easeInOut
            Tweener.registerTransition("easeoutinbounce", Equations.easeOutInBounce);
          };
          Equations.easeNone = function(t, b, c, d) {
            return c * t / d + b;
          };
          Equations.easeInQuad = function(t, b, c, d) {
            return c * (t /= d) * t + b;
          };
          Equations.easeOutQuad = function(t, b, c, d) {
            return -c * (t /= d) * (t - 2) + b;
          };
          Equations.easeInOutQuad = function(t, b, c, d) {
            if ((t /= d / 2) < 1) return c / 2 * t * t + b;
            return -c / 2 * ((--t) * (t - 2) - 1) + b;
          };
          Equations.easeOutInQuad = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutQuad(t * 2, b, c / 2, d);
            return Equations.easeInQuad((t * 2) - d, b + c / 2, c / 2, d);
          };
          Equations.easeInCubic = function(t, b, c, d) {
            return c * (t /= d) * t * t + b;
          };
          Equations.easeOutCubic = function(t, b, c, d) {
            return c * ((t = t / d - 1) * t * t + 1) + b;
          };
          Equations.easeInOutCubic = function(t, b, c, d) {
            if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
            return c / 2 * ((t -= 2) * t * t + 2) + b;
          };
          Equations.easeOutInCubic = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutCubic(t * 2, b, c / 2, d);
            return Equations.easeInCubic((t * 2) - d, b + c / 2, c / 2, d);
          };
          Equations.easeInQuart = function(t, b, c, d) {
            return c * (t /= d) * t * t * t + b;
          };
          Equations.easeOutQuart = function(t, b, c, d) {
            return -c * ((t = t / d - 1) * t * t * t - 1) + b;
          };
          Equations.easeInOutQuart = function(t, b, c, d) {
            if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
            return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
          };
          Equations.easeOutInQuart = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutQuart(t * 2, b, c / 2, d);
            return Equations.easeInQuart((t * 2) - d, b + c / 2, c / 2, d);
          };
          Equations.easeInQuint = function(t, b, c, d) {
            return c * (t /= d) * t * t * t * t + b;
          };
          Equations.easeOutQuint = function(t, b, c, d) {
            return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
          };
          Equations.easeInOutQuint = function(t, b, c, d) {
            if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
            return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
          };
          Equations.easeOutInQuint = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutQuint(t * 2, b, c / 2, d);
            return Equations.easeInQuint((t * 2) - d, b + c / 2, c / 2, d);
          };
          Equations.easeInSine = function(t, b, c, d) {
            return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
          };
          Equations.easeOutSine = function(t, b, c, d) {
            return c * Math.sin(t / d * (Math.PI / 2)) + b;
          };
          Equations.easeInOutSine = function(t, b, c, d) {
            return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
          };
          Equations.easeOutInSine = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutSine(t * 2, b, c / 2, d);
            return Equations.easeInSine((t * 2) - d, b + c / 2, c / 2, d);
          };
          Equations.easeInExpo = function(t, b, c, d) {
            return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b - c * 0.001;
          };
          Equations.easeOutExpo = function(t, b, c, d) {
            return (t == d) ? b + c : c * 1.001 * (-Math.pow(2, -10 * t / d) + 1) + b;
          };
          Equations.easeInOutExpo = function(t, b, c, d) {
            if (t == 0) return b;
            if (t == d) return b + c;
            if ((t /= d / 2) < 1) return c / 2 * Math.pow(2, 10 * (t - 1)) + b - c * 0.0005;
            return c / 2 * 1.0005 * (-Math.pow(2, -10 * --t) + 2) + b;
          };
          Equations.easeOutInExpo = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutExpo(t * 2, b, c / 2, d);
            return Equations.easeInExpo((t * 2) - d, b + c / 2, c / 2, d);
          };
          Equations.easeInCirc = function(t, b, c, d) {
            return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
          };
          Equations.easeOutCirc = function(t, b, c, d) {
            return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
          };
          Equations.easeInOutCirc = function(t, b, c, d) {
            if ((t /= d / 2) < 1) return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
            return c / 2 * (Math.sqrt(1 - (t -= 2) * t) + 1) + b;
          };
          Equations.easeOutInCirc = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutCirc(t * 2, b, c / 2, d);
            return Equations.easeInCirc((t * 2) - d, b + c / 2, c / 2, d);
          };
          Equations.easeInElastic = function(t, b, c, d, a, p) {
            a = AS3JS.Utils.getDefaultValue(a, Number.NaN);
            p = AS3JS.Utils.getDefaultValue(p, Number.NaN);
            if (t == 0) return b;
            if ((t /= d) == 1) return b + c;
            if (!p) p = d * .3;
            var s;
            if (!a || a < Math.abs(c)) {
              a = c;
              s = p / 4;
            } else s = p / (2 * Math.PI) * Math.asin(c / a);
            return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
          };
          Equations.easeOutElastic = function(t, b, c, d, a, p) {
            a = AS3JS.Utils.getDefaultValue(a, Number.NaN);
            p = AS3JS.Utils.getDefaultValue(p, Number.NaN);
            if (t == 0) return b;
            if ((t /= d) == 1) return b + c;
            if (!p) p = d * .3;
            var s;
            if (!a || a < Math.abs(c)) {
              a = c;
              s = p / 4;
            } else s = p / (2 * Math.PI) * Math.asin(c / a);
            return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b);
          };
          Equations.easeInOutElastic = function(t, b, c, d, a, p) {
            a = AS3JS.Utils.getDefaultValue(a, Number.NaN);
            p = AS3JS.Utils.getDefaultValue(p, Number.NaN);
            if (t == 0) return b;
            if ((t /= d / 2) == 2) return b + c;
            if (!p) p = d * (.3 * 1.5);
            var s;
            if (!a || a < Math.abs(c)) {
              a = c;
              s = p / 4;
            } else s = p / (2 * Math.PI) * Math.asin(c / a);
            if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
            return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * .5 + c + b;
          };
          Equations.easeOutInElastic = function(t, b, c, d, a, p) {
            a = AS3JS.Utils.getDefaultValue(a, Number.NaN);
            p = AS3JS.Utils.getDefaultValue(p, Number.NaN);
            if (t < d / 2) return Equations.easeOutElastic(t * 2, b, c / 2, d, a, p);
            return Equations.easeInElastic((t * 2) - d, b + c / 2, c / 2, d, a, p);
          };
          Equations.easeInBack = function(t, b, c, d, s) {
            s = AS3JS.Utils.getDefaultValue(s, Number.NaN);
            if (!s) s = 1.70158;
            return c * (t /= d) * t * ((s + 1) * t - s) + b;
          };
          Equations.easeOutBack = function(t, b, c, d, s) {
            s = AS3JS.Utils.getDefaultValue(s, Number.NaN);
            if (!s) s = 1.70158;
            return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
          };
          Equations.easeInOutBack = function(t, b, c, d, s) {
            s = AS3JS.Utils.getDefaultValue(s, Number.NaN);
            if (!s) s = 1.70158;
            if ((t /= d / 2) < 1) return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
            return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
          };
          Equations.easeOutInBack = function(t, b, c, d, s) {
            s = AS3JS.Utils.getDefaultValue(s, Number.NaN);
            if (t < d / 2) return Equations.easeOutBack(t * 2, b, c / 2, d, s);
            return Equations.easeInBack((t * 2) - d, b + c / 2, c / 2, d, s);
          };
          Equations.easeInBounce = function(t, b, c, d) {
            return c - Equations.easeOutBounce(d - t, 0, c, d) + b;
          };
          Equations.easeOutBounce = function(t, b, c, d) {
            if ((t /= d) < (1 / 2.75)) {
              return c * (7.5625 * t * t) + b;
            } else if (t < (2 / 2.75)) {
              return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
            } else if (t < (2.5 / 2.75)) {
              return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
            } else {
              return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
            }
          };
          Equations.easeInOutBounce = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeInBounce(t * 2, 0, c, d) * .5 + b;
            else return Equations.easeOutBounce(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
          };
          Equations.easeOutInBounce = function(t, b, c, d) {
            if (t < d / 2) return Equations.easeOutBounce(t * 2, b, c / 2, d);
            return Equations.easeInBounce((t * 2) - d, b + c / 2, c / 2, d);
          };

          module.exports = Equations;
        };
        Program["caurina.transitions.PropertyInfoObj"] = function(module, exports) {
          var PropertyInfoObj = function(p_valueStart, p_valueComplete, p_modifierFunction, p_modifierParameters) {
            this.valueStart = null;
            this.valueComplete = null;
            this.hasModifier = null;
            this.modifierFunction = null;
            this.modifierParameters = null;
            this.valueStart = p_valueStart;
            this.valueComplete = p_valueComplete;
            this.hasModifier = Boolean(p_modifierFunction);
            this.modifierFunction = p_modifierFunction;
            this.modifierParameters = p_modifierParameters;
          };

          PropertyInfoObj.prototype.valueStart = null;
          PropertyInfoObj.prototype.valueComplete = null;
          PropertyInfoObj.prototype.hasModifier = null;
          PropertyInfoObj.prototype.modifierFunction = null;
          PropertyInfoObj.prototype.modifierParameters = null;
          PropertyInfoObj.prototype.clone = function() {
            var nProperty = new PropertyInfoObj(this.valueStart, this.valueComplete, this.modifierFunction, this.modifierParameters);
            return nProperty;
          };
          PropertyInfoObj.prototype.toString = function() {
            var returnStr = "\n[PropertyInfoObj ";
            returnStr += "valueStart:" + String(this.valueStart);
            returnStr += ", ";
            returnStr += "valueComplete:" + String(this.valueComplete);
            returnStr += ", ";
            returnStr += "modifierFunction:" + String(this.modifierFunction);
            returnStr += ", ";
            returnStr += "modifierParameters:" + String(this.modifierParameters);
            returnStr += "]\n";
            return returnStr;
          }

          module.exports = PropertyInfoObj;
        };
        Program["caurina.transitions.SpecialPropertiesDefault"] = function(module, exports) {
          var AuxFunctions, Tweener;
          module.inject = function() {
            AuxFunctions = module.import('caurina.transitions', 'AuxFunctions');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var SpecialPropertiesDefault = function() {
            trace("SpecialProperties is a static class and should not be instantiated.")
          };

          SpecialPropertiesDefault.init = function() {

            // Normal properties
            Tweener.registerSpecialProperty("_frame", SpecialPropertiesDefault.frame_get, SpecialPropertiesDefault.frame_set);
            Tweener.registerSpecialProperty("_sound_volume", SpecialPropertiesDefault._sound_volume_get, SpecialPropertiesDefault._sound_volume_set);
            Tweener.registerSpecialProperty("_sound_pan", SpecialPropertiesDefault._sound_pan_get, SpecialPropertiesDefault._sound_pan_set);
            Tweener.registerSpecialProperty("_color_ra", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["redMultiplier"]);
            Tweener.registerSpecialProperty("_color_rb", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["redOffset"]);
            Tweener.registerSpecialProperty("_color_ga", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["greenMultiplier"]);
            Tweener.registerSpecialProperty("_color_gb", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["greenOffset"]);
            Tweener.registerSpecialProperty("_color_ba", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["blueMultiplier"]);
            Tweener.registerSpecialProperty("_color_bb", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["blueOffset"]);
            Tweener.registerSpecialProperty("_color_aa", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["alphaMultiplier"]);
            Tweener.registerSpecialProperty("_color_ab", SpecialPropertiesDefault._color_property_get, SpecialPropertiesDefault._color_property_set, ["alphaOffset"]);
            Tweener.registerSpecialProperty("_autoAlpha", SpecialPropertiesDefault._autoAlpha_get, SpecialPropertiesDefault._autoAlpha_set);

            // Normal splitter properties
            Tweener.registerSpecialPropertySplitter("_color", SpecialPropertiesDefault._color_splitter);
            Tweener.registerSpecialPropertySplitter("_colorTransform", SpecialPropertiesDefault._colorTransform_splitter);

            // Scale splitter properties
            Tweener.registerSpecialPropertySplitter("_scale", SpecialPropertiesDefault._scale_splitter);

            // Filter tweening properties - BlurFilter
            Tweener.registerSpecialProperty("_blur_blurX", SpecialPropertiesDefault._filter_property_get, SpecialPropertiesDefault._filter_property_set, [BlurFilter, "blurX"]);
            Tweener.registerSpecialProperty("_blur_blurY", SpecialPropertiesDefault._filter_property_get, SpecialPropertiesDefault._filter_property_set, [BlurFilter, "blurY"]);
            Tweener.registerSpecialProperty("_blur_quality", SpecialPropertiesDefault._filter_property_get, SpecialPropertiesDefault._filter_property_set, [BlurFilter, "quality"]);

            // Filter tweening splitter properties
            Tweener.registerSpecialPropertySplitter("_filter", SpecialPropertiesDefault._filter_splitter);

            // Bezier modifiers
            Tweener.registerSpecialPropertyModifier("_bezier", SpecialPropertiesDefault._bezier_modifier, SpecialPropertiesDefault._bezier_get);

          };
          SpecialPropertiesDefault._color_splitter = function(p_value, p_parameters) {
            var nArray = [];
            if (p_value == null) {
              // No parameter passed, so just resets the color
              nArray.push({
                name: "_color_ra",
                value: 1
              });
              nArray.push({
                name: "_color_rb",
                value: 0
              });
              nArray.push({
                name: "_color_ga",
                value: 1
              });
              nArray.push({
                name: "_color_gb",
                value: 0
              });
              nArray.push({
                name: "_color_ba",
                value: 1
              });
              nArray.push({
                name: "_color_bb",
                value: 0
              });
            } else {
              // A color tinting is passed, so converts it to the object values
              nArray.push({
                name: "_color_ra",
                value: 0
              });
              nArray.push({
                name: "_color_rb",
                value: AuxFunctions.numberToR(p_value)
              });
              nArray.push({
                name: "_color_ga",
                value: 0
              });
              nArray.push({
                name: "_color_gb",
                value: AuxFunctions.numberToG(p_value)
              });
              nArray.push({
                name: "_color_ba",
                value: 0
              });
              nArray.push({
                name: "_color_bb",
                value: AuxFunctions.numberToB(p_value)
              });
            }
            return nArray;
          };
          SpecialPropertiesDefault._colorTransform_splitter = function(p_value, p_parameters) {
            var nArray = [];
            if (p_value == null) {
              // No parameter passed, so just resets the color
              nArray.push({
                name: "_color_ra",
                value: 1
              });
              nArray.push({
                name: "_color_rb",
                value: 0
              });
              nArray.push({
                name: "_color_ga",
                value: 1
              });
              nArray.push({
                name: "_color_gb",
                value: 0
              });
              nArray.push({
                name: "_color_ba",
                value: 1
              });
              nArray.push({
                name: "_color_bb",
                value: 0
              });
            } else {
              // A color tinting is passed, so converts it to the object values
              if (p_value.ra != undefined) nArray.push({
                name: "_color_ra",
                value: p_value.ra
              });
              if (p_value.rb != undefined) nArray.push({
                name: "_color_rb",
                value: p_value.rb
              });
              if (p_value.ga != undefined) nArray.push({
                name: "_color_ba",
                value: p_value.ba
              });
              if (p_value.gb != undefined) nArray.push({
                name: "_color_bb",
                value: p_value.bb
              });
              if (p_value.ba != undefined) nArray.push({
                name: "_color_ga",
                value: p_value.ga
              });
              if (p_value.bb != undefined) nArray.push({
                name: "_color_gb",
                value: p_value.gb
              });
              if (p_value.aa != undefined) nArray.push({
                name: "_color_aa",
                value: p_value.aa
              });
              if (p_value.ab != undefined) nArray.push({
                name: "_color_ab",
                value: p_value.ab
              });
            }
            return nArray;
          };
          SpecialPropertiesDefault._scale_splitter = function(p_value, p_parameters) {
            var nArray = [];
            nArray.push({
              name: "scaleX",
              value: p_value
            });
            nArray.push({
              name: "scaleY",
              value: p_value
            });
            return nArray;
          };
          SpecialPropertiesDefault._filter_splitter = function(p_value, p_parameters) {
            var nArray = [];
            if (p_value is BlurFilter) {
              nArray.push({
                name: "_blur_blurX",
                value: BlurFilter(p_value).blurX
              });
              nArray.push({
                name: "_blur_blurY",
                value: BlurFilter(p_value).blurY
              });
              nArray.push({
                name: "_blur_quality",
                value: BlurFilter(p_value).quality
              });
            } else {
              // ?
              trace("??");
            }
            return nArray;
          };
          SpecialPropertiesDefault.frame_get = function(p_obj) {
            return p_obj.currentFrame;
          };
          SpecialPropertiesDefault.frame_set = function(p_obj, p_value) {
            p_obj.gotoAndStop(Math.round(p_value));
          };
          SpecialPropertiesDefault._sound_volume_get = function(p_obj) {
            return p_obj.soundTransform.volume;
          };
          SpecialPropertiesDefault._sound_volume_set = function(p_obj, p_value) {
            var sndTransform = p_obj.soundTransform;
            sndTransform.volume = p_value;
            p_obj.soundTransform = sndTransform;
          };
          SpecialPropertiesDefault._sound_pan_get = function(p_obj) {
            return p_obj.soundTransform.pan;
          };
          SpecialPropertiesDefault._sound_pan_set = function(p_obj, p_value) {
            var sndTransform = p_obj.soundTransform;
            sndTransform.pan = p_value;
            p_obj.soundTransform = sndTransform;
          };
          SpecialPropertiesDefault._color_property_get = function(p_obj, p_parameters) {
            return p_obj.transform.colorTransform[p_parameters[0]];
          };
          SpecialPropertiesDefault._color_property_set = function(p_obj, p_value, p_parameters) {
            var tf = p_obj.transform.colorTransform;
            tf[p_parameters[0]] = p_value;
            p_obj.transform.colorTransform = tf;
          };
          SpecialPropertiesDefault._autoAlpha_get = function(p_obj) {
            return p_obj.alpha;
          };
          SpecialPropertiesDefault._autoAlpha_set = function(p_obj, p_value) {
            p_obj.alpha = p_value;
            p_obj.visible = p_value > 0;
          };
          SpecialPropertiesDefault._filter_property_get = function(p_obj, p_parameters) {
            var f = p_obj.filters;
            var i;
            var filterClass = p_parameters[0];
            var propertyName = p_parameters[1];
            for (i = 0; i < f.length; i++) {
              if (f[i] is BlurFilter && filterClass == BlurFilter) return (f[i][propertyName]);
            }

            // No value found for this property - no filter instance found using this class!
            // Must return default desired values
            var defaultValues;
            switch (filterClass) {
              case BlurFilter:
                defaultValues = {
                  blurX: 0,
                  blurY: 0,
                  quality: NaN
                };
                break;
            }
            // When returning NaN, the Tweener engine sets the starting value as being the same as the final value
            // When returning null, the Tweener engine doesn't tween it at all, just setting it to the final value
            return defaultValues[propertyName];
          };
          SpecialPropertiesDefault._filter_property_set = function(p_obj, p_value, p_parameters) {
            var f = p_obj.filters;
            var i;
            var filterClass = p_parameters[0];
            var propertyName = p_parameters[1];
            for (i = 0; i < f.length; i++) {
              if (f[i] is BlurFilter && filterClass == BlurFilter) {
                f[i][propertyName] = p_value;
                p_obj.filters = f;
                return;
              }
            }

            // The correct filter class wasn't found - create a new one
            if (f == null) f = [];
            var fi;
            switch (filterClass) {
              case BlurFilter:
                fi = new BlurFilter(0, 0);
                break;
            }
            fi[propertyName] = p_value;
            f.push(fi);
            p_obj.filters = f;
          };
          SpecialPropertiesDefault._bezier_modifier = function(p_obj) {
            var mList = []; // List of properties to be modified
            var pList; // List of parameters passed, normalized as an array
            if (p_obj is Array) {
              // Complex
              pList = p_obj;
            } else {
              pList = [p_obj];
            }

            var i;
            var istr;
            var mListObj = {}; // Object describing each property name and parameter

            for (i = 0; i < pList.length; i++) {
              for (istr in pList[i]) {
                if (mListObj[istr] == undefined) mListObj[istr] = [];
                mListObj[istr].push(pList[i][istr]);
              }
            }
            for (istr in mListObj) {
              mList.push({
                name: istr,
                parameters: mListObj[istr]
              });
            }
            return mList;
          };
          SpecialPropertiesDefault._bezier_get = function(b, e, t, p) {
            // This is based on Robert Penner's code
            if (p.length == 1) {
              // Simple curve with just one bezier control point
              return b + t * (2 * (1 - t) * (p[0] - b) + t * (e - b));
            } else {
              // Array of bezier control points, must find the point between each pair of bezier points
              var ip = Math.floor(t * p.length); // Position on the bezier list
              var it = (t - (ip * (1 / p.length))) * p.length; // t inside this ip
              var p1, p2: Number;
              if (ip == 0) {
                // First part: belongs to the first control point, find second midpoint
                p1 = b;
                p2 = (p[0] + p[1]) / 2;
              } else if (ip == p.length - 1) {
                // Last part: belongs to the last control point, find first midpoint
                p1 = (p[ip - 1] + p[ip]) / 2;
                p2 = e;
              } else {
                // Any middle part: find both midpoints
                p1 = (p[ip - 1] + p[ip]) / 2;
                p2 = (p[ip] + p[ip + 1]) / 2;
              }
              return p1 + it * (2 * (1 - it) * (p[ip] - p1) + it * (p2 - p1));
            }
          };

          module.exports = SpecialPropertiesDefault;
        };
        Program["caurina.transitions.SpecialProperty"] = function(module, exports) {
          var SpecialProperty = function(p_getFunction, p_setFunction, p_parameters) {
            this.getValue = null;
            this.setValue = null;
            this.parameters = null;
            p_parameters = AS3JS.Utils.getDefaultValue(p_parameters, null);
            this.getValue = p_getFunction;
            this.setValue = p_setFunction;
            this.parameters = p_parameters;
          };

          SpecialProperty.prototype.getValue = null;
          SpecialProperty.prototype.setValue = null;
          SpecialProperty.prototype.parameters = null;
          SpecialProperty.prototype.toString = function() {
            var value = "";
            value += "[SpecialProperty ";
            value += "getValue:" + String(this.getValue); // .toString();
            value += ", ";
            value += "setValue:" + String(this.setValue); // .toString();
            value += ", ";
            value += "parameters:" + String(this.parameters); // .toString();
            value += "]";
            return value;
          }

          module.exports = SpecialProperty;
        };
        Program["caurina.transitions.SpecialPropertyModifier"] = function(module, exports) {
          var SpecialPropertyModifier = function(p_modifyFunction, p_getFunction) {
            this.modifyValues = null;
            this.getValue = null;
            this.modifyValues = p_modifyFunction;
            this.getValue = p_getFunction;
          };

          SpecialPropertyModifier.prototype.modifyValues = null;
          SpecialPropertyModifier.prototype.getValue = null;
          SpecialPropertyModifier.prototype.toString = function() {
            var value = "";
            value += "[SpecialPropertyModifier ";
            value += "modifyValues:" + String(this.modifyValues);
            value += ", ";
            value += "getValue:" + String(this.getValue);
            value += "]";
            return value;
          }

          module.exports = SpecialPropertyModifier;
        };
        Program["caurina.transitions.SpecialPropertySplitter"] = function(module, exports) {
          var SpecialPropertySplitter = function(p_splitFunction, p_parameters) {
            this.parameters = null;
            this.splitValues = null;
            this.splitValues = p_splitFunction;
          };

          SpecialPropertySplitter.prototype.parameters = null;
          SpecialPropertySplitter.prototype.splitValues = null;
          SpecialPropertySplitter.prototype.toString = function() {
            var value = "";
            value += "[SpecialPropertySplitter ";
            value += "splitValues:" + String(this.splitValues); // .toString();
            value += ", ";
            value += "parameters:" + String(this.parameters);
            value += "]";
            return value;
          }

          module.exports = SpecialPropertySplitter;
        };
        Program["caurina.transitions.Tweener"] = function(module, exports) {
          var AuxFunctions, Equations, PropertyInfoObj, SpecialPropertiesDefault, SpecialProperty, SpecialPropertyModifier, SpecialPropertySplitter, TweenListObj;
          module.inject = function() {
            AuxFunctions = module.import('caurina.transitions', 'AuxFunctions');
            Equations = module.import('caurina.transitions', 'Equations');
            PropertyInfoObj = module.import('caurina.transitions', 'PropertyInfoObj');
            SpecialPropertiesDefault = module.import('caurina.transitions', 'SpecialPropertiesDefault');
            SpecialProperty = module.import('caurina.transitions', 'SpecialProperty');
            SpecialPropertyModifier = module.import('caurina.transitions', 'SpecialPropertyModifier');
            SpecialPropertySplitter = module.import('caurina.transitions', 'SpecialPropertySplitter');
            TweenListObj = module.import('caurina.transitions', 'TweenListObj');
            Tweener.__tweener_controller__ = null;
            Tweener._engineExists = false;
            Tweener._inited = false;
            Tweener._currentTime = null;
            Tweener._tweenList = null;
            Tweener._timeScale = 1;
            Tweener._transitionList = null;
            Tweener._specialPropertyList = null;
            Tweener._specialPropertyModifierList = null;
            Tweener._specialPropertySplitterList = null;
          };

          var Tweener = function() {
            trace("Tweener is a static class and should not be instantiated.")
          };

          Tweener.__tweener_controller__ = null;
          Tweener._engineExists = false;
          Tweener._inited = false;
          Tweener._currentTime = 0;
          Tweener._tweenList = null;
          Tweener._timeScale = 1;
          Tweener._transitionList = null;
          Tweener._specialPropertyList = null;
          Tweener._specialPropertyModifierList = null;
          Tweener._specialPropertySplitterList = null;
          Tweener.addTween = function(p_arg1, p_arg2) {
            p_arg1 = AS3JS.Utils.getDefaultValue(p_arg1, null);
            p_arg2 = AS3JS.Utils.getDefaultValue(p_arg2, null);
            if (arguments.length < 2 || arguments[0] == undefined) return false;

            var rScopes = []; // List of objects to tween
            var i, j: Number, istr: String, jstr: String;

            if (arguments[0] is Array) {
              // The first argument is an array
              for (i = 0; i < arguments[0].length; i++) rScopes.push(arguments[0][i]);
            } else {
              // The first argument(s) is(are) object(s)
              for (i = 0; i < arguments.length - 1; i++) rScopes.push(arguments[i]);
            }
            // rScopes = arguments.concat().splice(1); // Alternate (should be tested for speed later)

            // make properties chain ("inheritance")
            var p_obj = TweenListObj.makePropertiesChain(arguments[arguments.length - 1]);

            // Creates the main engine if it isn't active
            if (!Tweener._inited) Tweener.init();
            if (!Tweener._engineExists || !Boolean(Tweener.__tweener_controller__)) Tweener.startEngine(); // Quick fix for Flash not resetting the vars on double ctrl+enter...

            // Creates a "safer", more strict tweening object
            var rTime = (isNaN(p_obj.time) ? 0 : p_obj.time); // Real time
            var rDelay = (isNaN(p_obj.delay) ? 0 : p_obj.delay); // Real delay

            // Creates the property list; everything that isn't a hardcoded variable
            var rProperties = []; // array containing object { .name, .valueStart, .valueComplete }
            var restrictedWords = {
              time: true,
              delay: true,
              useFrames: true,
              skipUpdates: true,
              transition: true,
              onStart: true,
              onUpdate: true,
              onComplete: true,
              onOverwrite: true,
              rounded: true,
              onStartParams: true,
              onUpdateParams: true,
              onCompleteParams: true,
              onOverwriteParams: true
            };
            var modifiedProperties = new Object();
            for (istr in p_obj) {
              if (!restrictedWords[istr]) {
                // It's an additional pair, so adds
                if (Tweener._specialPropertySplitterList[istr]) {
                  // Special property splitter
                  var splitProperties = Tweener._specialPropertySplitterList[istr].splitValues(p_obj[istr], Tweener._specialPropertySplitterList[istr].parameters);
                  for (i = 0; i < splitProperties.length; i++) {
                    rProperties[splitProperties[i].name] = {
                      valueStart: undefined,
                      valueComplete: splitProperties[i].value
                    };
                  }
                } else if (Tweener._specialPropertyModifierList[istr] != undefined) {
                  // Special property modifier
                  var tempModifiedProperties = Tweener._specialPropertyModifierList[istr].modifyValues(p_obj[istr]);
                  for (i = 0; i < tempModifiedProperties.length; i++) {
                    modifiedProperties[tempModifiedProperties[i].name] = {
                      modifierParameters: tempModifiedProperties[i].parameters,
                      modifierFunction: Tweener._specialPropertyModifierList[istr].getValue
                    };
                  }
                } else {
                  // Regular property or special property, just add the property normally
                  rProperties[istr] = {
                    valueStart: undefined,
                    valueComplete: p_obj[istr]
                  };
                }
              }
            }

            // Adds the modifiers to the list of properties
            for (istr in modifiedProperties) {
              if (rProperties[istr] != undefined) {
                rProperties[istr].modifierParameters = modifiedProperties[istr].modifierParameters;
                rProperties[istr].modifierFunction = modifiedProperties[istr].modifierFunction;
              }

            }

            var rTransition; // Real transition

            if (typeof p_obj.transition == "string") {
              // String parameter, transition names
              var trans = p_obj.transition.toLowerCase();
              rTransition = Tweener._transitionList[trans];
            } else {
              // Proper transition function
              rTransition = p_obj.transition;
            }
            if (!Boolean(rTransition)) rTransition = Tweener._transitionList["easeoutexpo"];

            var nProperties;
            var nTween;
            var myT;

            for (i = 0; i < rScopes.length; i++) {
              // Makes a copy of the properties
              nProperties = new Object();
              for (istr in rProperties) {
                nProperties[istr] = new PropertyInfoObj(rProperties[istr].valueStart, rProperties[istr].valueComplete, rProperties[istr].modifierFunction, rProperties[istr].modifierParameters);
              }

              nTween = new TweenListObj(
                /* scope      */
                rScopes[i],
                /* timeStart    */
                Tweener._currentTime + ((rDelay * 1000) / Tweener._timeScale),
                /* timeComplete    */
                Tweener._currentTime + (((rDelay * 1000) + (rTime * 1000)) / Tweener._timeScale),
                /* useFrames    */
                (p_obj.useFrames == true),
                /* transition    */
                rTransition
              );

              nTween.properties = nProperties;
              nTween.onStart = p_obj.onStart;
              nTween.onUpdate = p_obj.onUpdate;
              nTween.onComplete = p_obj.onComplete;
              nTween.onOverwrite = p_obj.onOverwrite;
              nTween.onError = p_obj.onError;
              nTween.onStartParams = p_obj.onStartParams;
              nTween.onUpdateParams = p_obj.onUpdateParams;
              nTween.onCompleteParams = p_obj.onCompleteParams;
              nTween.onOverwriteParams = p_obj.onOverwriteParams;
              nTween.rounded = p_obj.rounded;
              nTween.skipUpdates = p_obj.skipUpdates;

              // Remove other tweenings that occur at the same time
              Tweener.removeTweensByTime(nTween.scope, nTween.properties, nTween.timeStart, nTween.timeComplete);

              // And finally adds it to the list
              Tweener._tweenList.push(nTween);

              // Immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
              if (rTime == 0 && rDelay == 0) {
                myT = Tweener._tweenList.length - 1;
                Tweener.updateTweenByIndex(myT);
                Tweener.removeTweenByIndex(myT);
              }
            }

            return true;
          };
          Tweener.addCaller = function(p_arg1, p_arg2) {
            p_arg1 = AS3JS.Utils.getDefaultValue(p_arg1, null);
            p_arg2 = AS3JS.Utils.getDefaultValue(p_arg2, null);
            if (arguments.length < 2 || arguments[0] == undefined) return false;

            var rScopes = []; // List of objects to tween
            var i, j: Number;

            if (arguments[0] is Array) {
              // The first argument is an array
              for (i = 0; i < arguments[0].length; i++) rScopes.push(arguments[0][i]);
            } else {
              // The first argument(s) is(are) object(s)
              for (i = 0; i < arguments.length - 1; i++) rScopes.push(arguments[i]);
            }
            // rScopes = arguments.concat().splice(1); // Alternate (should be tested for speed later)

            var p_obj = arguments[arguments.length - 1];

            // Creates the main engine if it isn't active
            if (!Tweener._inited) Tweener.init();
            if (!Tweener._engineExists || !Boolean(Tweener.__tweener_controller__)) Tweener.startEngine(); // Quick fix for Flash not resetting the vars on double ctrl+enter...

            // Creates a "safer", more strict tweening object
            var rTime = (isNaN(p_obj.time) ? 0 : p_obj.time); // Real time
            var rDelay = (isNaN(p_obj.delay) ? 0 : p_obj.delay); // Real delay

            var rTransition; // Real transition
            if (typeof p_obj.transition == "string") {
              // String parameter, transition names
              var trans = p_obj.transition.toLowerCase();
              rTransition = Tweener._transitionList[trans];
            } else {
              // Proper transition function
              rTransition = p_obj.transition;
            }
            if (!Boolean(rTransition)) rTransition = Tweener._transitionList["easeoutexpo"];

            var nTween;
            var myT;
            for (i = 0; i < rScopes.length; i++) {

              nTween = new TweenListObj(
                /* Scope      */
                rScopes[i],
                /* TimeStart    */
                Tweener._currentTime + ((rDelay * 1000) / Tweener._timeScale),
                /* TimeComplete    */
                Tweener._currentTime + (((rDelay * 1000) + (rTime * 1000)) / Tweener._timeScale),
                /* UseFrames    */
                (p_obj.useFrames == true),
                /* Transition    */
                rTransition
              );

              nTween.properties = null;
              nTween.onStart = p_obj.onStart;
              nTween.onUpdate = p_obj.onUpdate;
              nTween.onComplete = p_obj.onComplete;
              nTween.onOverwrite = p_obj.onOverwrite;
              nTween.onStartParams = p_obj.onStartParams;
              nTween.onUpdateParams = p_obj.onUpdateParams;
              nTween.onCompleteParams = p_obj.onCompleteParams;
              nTween.onOverwriteParams = p_obj.onOverwriteParams;
              nTween.isCaller = true;
              nTween.count = p_obj.count;
              nTween.waitFrames = p_obj.waitFrames;

              // And finally adds it to the list
              Tweener._tweenList.push(nTween);

              // Immediate update and removal if it's an immediate tween -- if not deleted, it executes at the end of this frame execution
              if (rTime == 0 && rDelay == 0) {
                myT = Tweener._tweenList.length - 1;
                Tweener.updateTweenByIndex(myT);
                Tweener.removeTweenByIndex(myT);
              }
            }

            return true;
          };
          Tweener.removeTweensByTime = function(p_scope, p_properties, p_timeStart, p_timeComplete) {
            var removed = false;
            var removedLocally;

            var i;
            var tl = Tweener._tweenList.length;
            var pName;

            for (i = 0; i < tl; i++) {
              if (Boolean(Tweener._tweenList[i]) && p_scope == Tweener._tweenList[i].scope) {
                // Same object...
                if (p_timeComplete > Tweener._tweenList[i].timeStart && p_timeStart < Tweener._tweenList[i].timeComplete) {
                  // New time should override the old one...
                  removedLocally = false;
                  for (pName in Tweener._tweenList[i].properties) {
                    if (Boolean(p_properties[pName])) {
                      // Same object, same property
                      // Finally, remove this old tweening and use the new one
                      if (Boolean(Tweener._tweenList[i].onOverwrite)) {
                        try {
                          Tweener._tweenList[i].onOverwrite.apply(Tweener._tweenList[i].scope, Tweener._tweenList[i].onOverwriteParams);
                        } catch (e: Error) {
                          Tweener.handleError(Tweener._tweenList[i], e, "onOverwrite");
                        }
                      }
                      Tweener._tweenList[i].properties[pName] = undefined;
                      delete Tweener._tweenList[i].properties[pName];
                      removedLocally = true;
                      removed = true;
                    }
                  }
                  if (removedLocally) {
                    // Verify if this can be deleted
                    if (AuxFunctions.getObjectLength(Tweener._tweenList[i].properties) == 0) Tweener.removeTweenByIndex(i);
                  }
                }
              }
            }

            return removed;
          };
          Tweener.removeTweens = function(p_scope, args) {
            // Create the property list
            var properties = [];
            var i;
            for (i = 0; i < args.length; i++) {
              if (typeof(args[i]) == "string" && !AuxFunctions.isInArray(args[i], properties)) properties.push(args[i]);
            }
            // Call the affect function on the specified properties
            return Tweener.affectTweens(Tweener.removeTweenByIndex, p_scope, properties);
          };
          Tweener.removeAllTweens = function() {
            if (!Boolean(Tweener._tweenList)) return false;
            var removed = false;
            var i;
            for (i = 0; i < Tweener._tweenList.length; i++) {
              Tweener.removeTweenByIndex(i);
              removed = true;
            }
            return removed;
          };
          Tweener.pauseTweens = function(p_scope, args) {
            // Create the property list
            var properties = [];
            var i;
            for (i = 0; i < args.length; i++) {
              if (typeof(args[i]) == "string" && !AuxFunctions.isInArray(args[i], properties)) properties.push(args[i]);
            }
            // Call the affect function on the specified properties
            return Tweener.affectTweens(Tweener.pauseTweenByIndex, p_scope, properties);
          };
          Tweener.pauseAllTweens = function() {
            if (!Boolean(Tweener._tweenList)) return false;
            var paused = false;
            var i;
            for (i = 0; i < Tweener._tweenList.length; i++) {
              Tweener.pauseTweenByIndex(i);
              paused = true;
            }
            return paused;
          };
          Tweener.resumeTweens = function(p_scope, args) {
            // Create the property list
            var properties = [];
            var i;
            for (i = 0; i < args.length; i++) {
              if (typeof(args[i]) == "string" && !AuxFunctions.isInArray(args[i], properties)) properties.push(args[i]);
            }
            // Call the affect function on the specified properties
            return Tweener.affectTweens(Tweener.resumeTweenByIndex, p_scope, properties);
          };
          Tweener.resumeAllTweens = function() {
            if (!Boolean(Tweener._tweenList)) return false;
            var resumed = false;
            var i;
            for (i = 0; i < Tweener._tweenList.length; i++) {
              Tweener.resumeTweenByIndex(i);
              resumed = true;
            }
            return resumed;
          };
          Tweener.affectTweens = function(p_affectFunction, p_scope, p_properties) {
            var affected = false;
            var i;

            if (!Boolean(Tweener._tweenList)) return false;

            for (i = 0; i < Tweener._tweenList.length; i++) {
              if (Tweener._tweenList[i] && Tweener._tweenList[i].scope == p_scope) {
                if (p_properties.length == 0) {
                  // Can affect everything
                  p_affectFunction(i);
                  affected = true;
                } else {
                  // Must check whether this tween must have specific properties affected
                  var affectedProperties = [];
                  var j;
                  for (j = 0; j < p_properties.length; j++) {
                    if (Boolean(Tweener._tweenList[i].properties[p_properties[j]])) {
                      affectedProperties.push(p_properties[j]);
                    }
                  }
                  if (affectedProperties.length > 0) {
                    // This tween has some properties that need to be affected
                    var objectProperties = AuxFunctions.getObjectLength(Tweener._tweenList[i].properties);
                    if (objectProperties == affectedProperties.length) {
                      // The list of properties is the same as all properties, so affect it all
                      p_affectFunction(i);
                      affected = true;
                    } else {
                      // The properties are mixed, so split the tween and affect only certain specific properties
                      var slicedTweenIndex = Tweener.splitTweens(i, affectedProperties);
                      p_affectFunction(slicedTweenIndex);
                      affected = true;
                    }
                  }
                }
              }
            }
            return affected;
          };
          Tweener.splitTweens = function(p_tween, p_properties) {
            // First, duplicates
            var originalTween = Tweener._tweenList[p_tween];
            var newTween = originalTween.clone(false);

            // Now, removes tweenings where needed
            var i;
            var pName;

            // Removes the specified properties from the old one
            for (i = 0; i < p_properties.length; i++) {
              pName = p_properties[i];
              if (Boolean(originalTween.properties[pName])) {
                originalTween.properties[pName] = undefined;
                delete originalTween.properties[pName];
              }
            }

            // Removes the unspecified properties from the new one
            var found;
            for (pName in newTween.properties) {
              found = false;
              for (i = 0; i < p_properties.length; i++) {
                if (p_properties[i] == pName) {
                  found = true;
                  break;
                }
              }
              if (!found) {
                newTween.properties[pName] = undefined;
                delete newTween.properties[pName];
              }
            }

            // If there are empty property lists, a cleanup is done on the next updateTweens() cycle
            Tweener._tweenList.push(newTween);
            return (Tweener._tweenList.length - 1);

          };
          Tweener.updateTweens = function() {
            if (Tweener._tweenList.length == 0) return false;
            var i;
            for (i = 0; i < Tweener._tweenList.length; i++) {
              // Looping throught each Tweening and updating the values accordingly
              if (Tweener._tweenList[i] == undefined || !Tweener._tweenList[i].isPaused) {
                if (!Tweener.updateTweenByIndex(i)) Tweener.removeTweenByIndex(i);
                if (Tweener._tweenList[i] == null) {
                  Tweener.removeTweenByIndex(i, true);
                  i--;
                }
              }
            }

            return true;
          };
          Tweener.removeTweenByIndex = function(i, p_finalRemoval) {
            p_finalRemoval = AS3JS.Utils.getDefaultValue(p_finalRemoval, false);
            Tweener._tweenList[i] = null;
            if (p_finalRemoval) Tweener._tweenList.splice(i, 1);
            return true;
          };
          Tweener.pauseTweenByIndex = function(p_tween) {
            var tTweening = Tweener._tweenList[p_tween]; // Shortcut to this tweening
            if (tTweening == null || tTweening.isPaused) return false;
            tTweening.timePaused = Tweener._currentTime;
            tTweening.isPaused = true;

            return true;
          };
          Tweener.resumeTweenByIndex = function(p_tween) {
            var tTweening = Tweener._tweenList[p_tween]; // Shortcut to this tweening
            if (tTweening == null || !tTweening.isPaused) return false;
            tTweening.timeStart += Tweener._currentTime - tTweening.timePaused;
            tTweening.timeComplete += Tweener._currentTime - tTweening.timePaused;
            tTweening.timePaused = undefined;
            tTweening.isPaused = false;

            return true;
          };
          Tweener.updateTweenByIndex = function(i) {

            var tTweening = Tweener._tweenList[i]; // Shortcut to this tweening

            if (tTweening == null || !Boolean(tTweening.scope)) return false;

            var isOver = false; // Whether or not it's over the update time
            var mustUpdate; // Whether or not it should be updated (skipped if false)

            var nv; // New value for each property

            var t; // current time (frames, seconds)
            var b; // beginning value
            var c; // change in value
            var d; // duration (frames, seconds)

            var pName; // Property name, used in loops

            // Shortcut stuff for speed
            var tScope; // Current scope
            var tProperty; // Property being checked

            if (Tweener._currentTime >= tTweening.timeStart) {
              // Can already start

              tScope = tTweening.scope;

              if (tTweening.isCaller) {
                // It's a 'caller' tween
                do {
                  t = ((tTweening.timeComplete - tTweening.timeStart) / tTweening.count) * (tTweening.timesCalled + 1);
                  b = tTweening.timeStart;
                  c = tTweening.timeComplete - tTweening.timeStart;
                  d = tTweening.timeComplete - tTweening.timeStart;
                  nv = tTweening.transition(t, b, c, d);

                  if (Tweener._currentTime >= nv) {
                    if (Boolean(tTweening.onUpdate)) {
                      try {
                        tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
                      } catch (e: Error) {
                        Tweener.handleError(tTweening, e, "onUpdate");
                      }
                    }

                    tTweening.timesCalled++;
                    if (tTweening.timesCalled >= tTweening.count) {
                      isOver = true;
                      break;
                    }
                    if (tTweening.waitFrames) break;
                  }

                } while (Tweener._currentTime >= nv);
              } else {
                // It's a normal transition tween

                mustUpdate = tTweening.skipUpdates < 1 || !tTweening.skipUpdates || tTweening.updatesSkipped >= tTweening.skipUpdates;

                if (Tweener._currentTime >= tTweening.timeComplete) {
                  isOver = true;
                  mustUpdate = true;
                }

                if (!tTweening.hasStarted) {
                  // First update, read all default values (for proper filter tweening)
                  if (Boolean(tTweening.onStart)) {
                    try {
                      tTweening.onStart.apply(tScope, tTweening.onStartParams);
                    } catch (e: Error) {
                      Tweener.handleError(tTweening, e, "onStart");
                    }
                  }
                  for (pName in tTweening.properties) {
                    var pv = Tweener.getPropertyValue(tScope, pName);
                    tTweening.properties[pName].valueStart = isNaN(pv) ? tTweening.properties[pName].valueComplete : pv;
                  }
                  mustUpdate = true;
                  tTweening.hasStarted = true;
                }

                if (mustUpdate) {
                  for (pName in tTweening.properties) {
                    tProperty = tTweening.properties[pName];

                    if (isOver) {
                      // Tweening time has finished, just set it to the final value
                      nv = tProperty.valueComplete;
                    } else {
                      if (tProperty.hasModifier) {
                        // Modified
                        t = Tweener._currentTime - tTweening.timeStart;
                        d = tTweening.timeComplete - tTweening.timeStart;
                        nv = tTweening.transition(t, 0, 1, d);
                        nv = tProperty.modifierFunction(tProperty.valueStart, tProperty.valueComplete, nv, tProperty.modifierParameters);
                      } else {
                        // Normal update
                        t = Tweener._currentTime - tTweening.timeStart;
                        b = tProperty.valueStart;
                        c = tProperty.valueComplete - tProperty.valueStart;
                        d = tTweening.timeComplete - tTweening.timeStart;
                        nv = tTweening.transition(t, b, c, d);
                      }
                    }

                    if (tTweening.rounded) nv = Math.round(nv);
                    Tweener.setPropertyValue(tScope, pName, nv);
                  }

                  tTweening.updatesSkipped = 0;

                  if (Boolean(tTweening.onUpdate)) {
                    try {
                      tTweening.onUpdate.apply(tScope, tTweening.onUpdateParams);
                    } catch (e: Error) {
                      Tweener.handleError(tTweening, e, "onUpdate");
                    }
                  }
                } else {
                  tTweening.updatesSkipped++;
                }
              }

              if (isOver && Boolean(tTweening.onComplete)) {
                try {
                  tTweening.onComplete.apply(tScope, tTweening.onCompleteParams);
                } catch (e: Error) {
                  Tweener.handleError(tTweening, e, "onComplete");
                }
              }

              return (!isOver);
            }

            // On delay, hasn't started, so returns true
            return (true);

          };
          Tweener.init = function(p_object) {
            p_object = AS3JS.Utils.getDefaultValue(p_object, null);
            Tweener._inited = true;

            // Registers all default equations
            Tweener._transitionList = new Object();
            Equations.init();

            // Registers all default special properties
            Tweener._specialPropertyList = new Object();
            Tweener._specialPropertyModifierList = new Object();
            Tweener._specialPropertySplitterList = new Object();
            SpecialPropertiesDefault.init();
          };
          Tweener.registerTransition = function(p_name, p_function) {
            if (!Tweener._inited) Tweener.init();
            Tweener._transitionList[p_name] = p_function;
          };
          Tweener.registerSpecialProperty = function(p_name, p_getFunction, p_setFunction, p_parameters) {
            p_parameters = AS3JS.Utils.getDefaultValue(p_parameters, null);
            if (!Tweener._inited) Tweener.init();
            var sp = new SpecialProperty(p_getFunction, p_setFunction, p_parameters);
            Tweener._specialPropertyList[p_name] = sp;
          };
          Tweener.registerSpecialPropertyModifier = function(p_name, p_modifyFunction, p_getFunction) {
            if (!Tweener._inited) Tweener.init();
            var spm = new SpecialPropertyModifier(p_modifyFunction, p_getFunction);
            Tweener._specialPropertyModifierList[p_name] = spm;
          };
          Tweener.registerSpecialPropertySplitter = function(p_name, p_splitFunction, p_parameters) {
            p_parameters = AS3JS.Utils.getDefaultValue(p_parameters, null);
            if (!Tweener._inited) Tweener.init();
            var sps = new SpecialPropertySplitter(p_splitFunction, p_parameters);
            Tweener._specialPropertySplitterList[p_name] = sps;
          };
          Tweener.startEngine = function() {
            Tweener._engineExists = true;
            Tweener._tweenList = [];

            Tweener.__tweener_controller__ = new MovieClip();
            Tweener.__tweener_controller__.addEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);

            Tweener.updateTime();
          };
          Tweener.stopEngine = function() {
            Tweener._engineExists = false;
            Tweener._tweenList = null;
            Tweener._currentTime = 0;
            Tweener.__tweener_controller__.removeEventListener(Event.ENTER_FRAME, Tweener.onEnterFrame);
            Tweener.__tweener_controller__ = null;
          };
          Tweener.getPropertyValue = function(p_obj, p_prop) {
            if (Tweener._specialPropertyList[p_prop] != undefined) {
              // Special property
              if (Boolean(Tweener._specialPropertyList[p_prop].parameters)) {
                // Uses additional parameters
                return Tweener._specialPropertyList[p_prop].getValue(p_obj, Tweener._specialPropertyList[p_prop].parameters);
              } else {
                // Doesn't use additional parameters
                return Tweener._specialPropertyList[p_prop].getValue(p_obj);
              }
            } else {
              // Regular property
              return p_obj[p_prop];
            }
          };
          Tweener.setPropertyValue = function(p_obj, p_prop, p_value) {
            if (Tweener._specialPropertyList[p_prop] != undefined) {
              // Special property
              if (Boolean(Tweener._specialPropertyList[p_prop].parameters)) {
                // Uses additional parameters
                Tweener._specialPropertyList[p_prop].setValue(p_obj, p_value, Tweener._specialPropertyList[p_prop].parameters);
              } else {
                // Doesn't use additional parameters
                Tweener._specialPropertyList[p_prop].setValue(p_obj, p_value);
              }
            } else {
              // Regular property
              p_obj[p_prop] = p_value;
            }
          };
          Tweener.updateTime = function() {
            Tweener._currentTime = getTimer();
          };
          Tweener.onEnterFrame = function(e) {
            Tweener.updateTime();
            var hasUpdated = false;
            hasUpdated = Tweener.updateTweens();
            if (!hasUpdated) Tweener.stopEngine(); // There's no tweening to update or wait, so it's better to stop the engine
          };
          Tweener.setTimeScale = function(p_time) {
            var i;

            if (isNaN(p_time)) p_time = 1;
            if (p_time < 0.00001) p_time = 0.00001;
            if (p_time != Tweener._timeScale) {
              if (Tweener._tweenList != null) {
                // Multiplies all existing tween times accordingly
                for (i = 0; i < Tweener._tweenList.length; i++) {
                  Tweener._tweenList[i].timeStart = Tweener._currentTime - ((Tweener._currentTime - Tweener._tweenList[i].timeStart) * Tweener._timeScale / p_time);
                  Tweener._tweenList[i].timeComplete = Tweener._currentTime - ((Tweener._currentTime - Tweener._tweenList[i].timeComplete) * Tweener._timeScale / p_time);
                  if (Tweener._tweenList[i].timePaused != undefined) Tweener._tweenList[i].timePaused = Tweener._currentTime - ((Tweener._currentTime - Tweener._tweenList[i].timePaused) * Tweener._timeScale / p_time);
                }
              }
              // Sets the new timescale value (for new tweenings)
              Tweener._timeScale = p_time;
            }
          };
          Tweener.isTweening = function(p_scope) {
            if (!Boolean(Tweener._tweenList)) return false;
            var i;

            for (i = 0; i < Tweener._tweenList.length; i++) {
              if (Tweener._tweenList[i].scope == p_scope) {
                return true;
              }
            }
            return false;
          };
          Tweener.getTweens = function(p_scope) {
            if (!Boolean(Tweener._tweenList)) return [];
            var i;
            var pName;
            var tList = [];

            for (i = 0; i < Tweener._tweenList.length; i++) {
              if (Tweener._tweenList[i].scope == p_scope) {
                for (pName in Tweener._tweenList[i].properties) tList.push(pName);
              }
            }
            return tList;
          };
          Tweener.getTweenCount = function(p_scope) {
            if (!Boolean(Tweener._tweenList)) return 0;
            var i;
            var c = 0;

            for (i = 0; i < Tweener._tweenList.length; i++) {
              if (Tweener._tweenList[i].scope == p_scope) {
                c += AuxFunctions.getObjectLength(Tweener._tweenList[i].properties);
              }
            }
            return c;
          };
          Tweener.handleError = function(pTweening, pError, pCallBackName) {
            // do we have an error handler?
            if (Boolean(pTweening.onError) && (pTweening.onError is Function)) {
              // yup, there's a handler. Wrap this in a try catch in case the onError throws an error itself.
              try {
                pTweening.onError.apply(pTweening.scope, [pTweening.scope, pError]);
              } catch (metaError: Error) {
                trace("## [Tweener] Error:", pTweening.scope, "raised an error while executing the 'onError' handler. Original error:\n", pError.getStackTrace(), "\nonError error:", metaError.getStackTrace());
              }
            } else {
              // o handler, simply trace the stack trace:
              if (!Boolean(pTweening.onError)) {
                trace("## [Tweener] Error: :", pTweening.scope, "raised an error while executing the'" + pCallBackName + "'handler. \n", pError.getStackTrace());
              }
            }
          };
          Tweener.getVersion = function() {
            return "AS3 1.26.62";
          };
          Tweener.debug_getList = function() {
            var ttl = "";
            var i, k: uint;
            for (i = 0; i < Tweener._tweenList.length; i++) {
              ttl += "[" + i + "] ::\n";
              for (k = 0; k < Tweener._tweenList[i].properties.length; k++) {
                ttl += "  " + Tweener._tweenList[i].properties[k].name + " -> " + Tweener._tweenList[i].properties[k].valueComplete + "\n";
              }
            }
            return ttl;
          };

          module.exports = Tweener;
        };
        Program["caurina.transitions.TweenListObj"] = function(module, exports) {
          var AuxFunctions;
          module.inject = function() {
            AuxFunctions = module.import('caurina.transitions', 'AuxFunctions');
          };

          var TweenListObj = function(p_scope, p_timeStart, p_timeComplete, p_useFrames, p_transition) {
            this.scope = null;
            this.properties = null;
            this.auxProperties = null;
            this.timeStart = null;
            this.timeComplete = null;
            this.useFrames = null;
            this.transition = null;
            this.onStart = null;
            this.onUpdate = null;
            this.onComplete = null;
            this.onOverwrite = null;
            this.onError = null;
            this.onStartParams = null;
            this.onUpdateParams = null;
            this.onCompleteParams = null;
            this.onOverwriteParams = null;
            this.rounded = null;
            this.isPaused = null;
            this.timePaused = null;
            this.isCaller = null;
            this.count = null;
            this.timesCalled = null;
            this.waitFrames = null;
            this.skipUpdates = null;
            this.updatesSkipped = null;
            this.hasStarted = null;
            this.scope = p_scope;
            this.timeStart = p_timeStart;
            this.timeComplete = p_timeComplete;
            this.useFrames = p_useFrames;
            this.transition = p_transition;

            // Other default information
            this.auxProperties = new Object();
            this.properties = new Object();
            this.isPaused = false;
            this.timePaused = undefined;
            this.isCaller = false;
            this.updatesSkipped = 0;
            this.timesCalled = 0;
            this.skipUpdates = 0;
            this.hasStarted = false;
          };

          TweenListObj.makePropertiesChain = function(p_obj) {
            // Is this object inheriting properties from another object?
            var baseObject = p_obj.base;
            if (baseObject) {
              // object inherits. Are we inheriting from an object or an array
              var chainedObject = {};
              var chain;
              if (baseObject is Array) {
                // Inheritance chain is the base array
                chain = [];
                // make a shallow copy
                for (var k = 0; k < baseObject.length; k++) chain.push(baseObject[k]);
              } else {
                // Only one object to be added to the array
                chain = [baseObject];
              }
              // add the final object to the array, so it's properties are added last
              chain.push(p_obj);
              var currChainObj;
              // Loops through each object adding it's property to the final object
              var len = chain.length;
              for (var i = 0; i < len; i++) {
                if (chain[i]["base"]) {
                  // deal with recursion: watch the order! "parent" base must be concatenated first!
                  currChainObj = AuxFunctions.concatObjects(TweenListObj.makePropertiesChain(chain[i]["base"]), chain[i]);
                } else {
                  currChainObj = chain[i];
                }
                chainedObject = AuxFunctions.concatObjects(chainedObject, currChainObj);
              }
              if (chainedObject["base"]) {
                delete chainedObject["base"];
              }
              return chainedObject;
            } else {
              // No inheritance, just return the object it self
              return p_obj;
            }
          };

          TweenListObj.prototype.scope = null;
          TweenListObj.prototype.properties = null;
          TweenListObj.prototype.auxProperties = null;
          TweenListObj.prototype.timeStart = null;
          TweenListObj.prototype.timeComplete = null;
          TweenListObj.prototype.useFrames = null;
          TweenListObj.prototype.transition = null;
          TweenListObj.prototype.onStart = null;
          TweenListObj.prototype.onUpdate = null;
          TweenListObj.prototype.onComplete = null;
          TweenListObj.prototype.onOverwrite = null;
          TweenListObj.prototype.onError = null;
          TweenListObj.prototype.onStartParams = null;
          TweenListObj.prototype.onUpdateParams = null;
          TweenListObj.prototype.onCompleteParams = null;
          TweenListObj.prototype.onOverwriteParams = null;
          TweenListObj.prototype.rounded = null;
          TweenListObj.prototype.isPaused = null;
          TweenListObj.prototype.timePaused = null;
          TweenListObj.prototype.isCaller = null;
          TweenListObj.prototype.count = null;
          TweenListObj.prototype.timesCalled = null;
          TweenListObj.prototype.waitFrames = null;
          TweenListObj.prototype.skipUpdates = null;
          TweenListObj.prototype.updatesSkipped = null;
          TweenListObj.prototype.hasStarted = null;
          TweenListObj.prototype.clone = function(omitEvents) {
            var nTween = new TweenListObj(this.scope, this.timeStart, this.timeComplete, this.useFrames, this.transition);
            nTween.properties = [];
            for (var pName in this.properties) {
              nTween.properties[pName] = this.properties[pName].clone();
            }
            nTween.skipUpdates = this.skipUpdates;
            nTween.updatesSkipped = this.updatesSkipped;
            if (!omitEvents) {
              nTween.onStart = this.onStart;
              nTween.onUpdate = this.onUpdate;
              nTween.onComplete = this.onComplete;
              nTween.onOverwrite = this.onOverwrite;
              nTween.onError = this.onError;
              nTween.onStartParams = this.onStartParams;
              nTween.onUpdateParams = this.onUpdateParams;
              nTween.onCompleteParams = this.onCompleteParams;
              nTween.onOverwriteParams = this.onOverwriteParams;
            }
            nTween.rounded = this.rounded;
            nTween.isPaused = this.isPaused;
            nTween.timePaused = this.timePaused;
            nTween.isCaller = this.isCaller;
            nTween.count = this.count;
            nTween.timesCalled = this.timesCalled;
            nTween.waitFrames = this.waitFrames;
            nTween.hasStarted = this.hasStarted;

            return nTween;
          };
          TweenListObj.prototype.toString = function() {
            var returnStr = "\n[TweenListObj ";
            returnStr += "scope:" + String(this.scope);
            returnStr += ", properties:";
            for (var i = 0; i < this.properties.length; i++) {
              if (i > 0) returnStr += ",";
              returnStr += "[name:" + this.properties[i].name;
              returnStr += ",valueStart:" + this.properties[i].valueStart;
              returnStr += ",valueComplete:" + this.properties[i].valueComplete;
              returnStr += "]";
            } // END FOR
            returnStr += ", timeStart:" + String(this.timeStart);
            returnStr += ", timeComplete:" + String(this.timeComplete);
            returnStr += ", useFrames:" + String(this.useFrames);
            returnStr += ", transition:" + String(this.transition);

            if (this.skipUpdates) returnStr += ", skipUpdates:" + String(this.skipUpdates);
            if (this.updatesSkipped) returnStr += ", updatesSkipped:" + String(this.updatesSkipped);

            if (Boolean(this.onStart)) returnStr += ", onStart:" + String(this.onStart);
            if (Boolean(this.onUpdate)) returnStr += ", onUpdate:" + String(this.onUpdate);
            if (Boolean(this.onComplete)) returnStr += ", onComplete:" + String(this.onComplete);
            if (Boolean(this.onOverwrite)) returnStr += ", onOverwrite:" + String(this.onOverwrite);
            if (Boolean(this.onError)) returnStr += ", onError:" + String(this.onError);

            if (this.onStartParams) returnStr += ", onStartParams:" + String(this.onStartParams);
            if (this.onUpdateParams) returnStr += ", onUpdateParams:" + String(this.onUpdateParams);
            if (this.onCompleteParams) returnStr += ", onCompleteParams:" + String(this.onCompleteParams);
            if (this.onOverwriteParams) returnStr += ", onOverwriteParams:" + String(this.onOverwriteParams);

            if (this.rounded) returnStr += ", rounded:" + String(this.rounded);
            if (this.isPaused) returnStr += ", isPaused:" + String(this.isPaused);
            if (this.timePaused) returnStr += ", timePaused:" + String(this.timePaused);
            if (this.isCaller) returnStr += ", isCaller:" + String(this.isCaller);
            if (this.count) returnStr += ", count:" + String(this.count);
            if (this.timesCalled) returnStr += ", timesCalled:" + String(this.timesCalled);
            if (this.waitFrames) returnStr += ", waitFrames:" + String(this.waitFrames);
            if (this.hasStarted) returnStr += ", hasStarted:" + String(this.hasStarted);

            returnStr += "]\n";
            return returnStr;
          }

          module.exports = TweenListObj;
        };
        Program["charts.Area"] = function(module, exports) {
          var Line = module.import('charts', 'Line');
          var Element;
          module.inject = function() {
            Element = module.import('charts.series', 'Element');
          };

          var Area = function(json) {
            Line.call(this, json);

            var fill;
            if (json.fill)
              fill = json.fill;
            else
              fill = json.colour;

            this.fill_colour = string.Utils.get_colour(fill);

          };

          Area.prototype = Object.create(Line.prototype);

          Area.prototype.fill_colour = 0;
          Area.prototype.area_base = 0;
          Area.prototype.resize = function(sc) {

            var right_axis = false;

            if (this.props.has('axis'))
              if (this.props.get('axis') == 'right')
                right_axis = true;

              // save this position
            this.area_base = sc.get_y_bottom(right_axis);

            // let line deal with the resize
            Line.prototype.resize.call(this, sc);
          };
          Area.prototype.draw = function() {
            this.graphics.clear();
            this.fill_area();
            // draw the line on top of the area (z axis)
            this.draw_line();
          };
          Area.prototype.fill_area = function() {

            var last;
            var first = true;
            var tmp;

            for (var i = 0; i < this.numChildren; i++) {

              tmp = (Sprite) this.getChildAt(i);

              // filter out the masks
              if (tmp is Element) {

                var e = (Element) tmp;

                if (first) {

                  first = false;

                  if (this.props.get('loop')) {
                    // assume we are in a radar chart
                    this.graphics.moveTo(e.x, e.y);
                  } else {
                    // draw line from Y=0 up to Y pos
                    this.graphics.moveTo(e.x, this.area_base);
                  }

                  //
                  // TO FIX BUG: you must do a graphics.moveTo before
                  //             starting a fill:
                  //
                  this.graphics.lineStyle(0, 0, 0);
                  this.graphics.beginFill(this.fill_colour, this.props.get('fill-alpha'));

                  if (!this.props.get('loop'))
                    this.graphics.lineTo(e.x, e.y);

                } else {
                  this.graphics.lineTo(e.x, e.y);
                  last = e;
                }
              }
            }

            if (last != null) {
              if (!this.props.get('loop')) {
                this.graphics.lineTo(last.x, this.area_base);
              }
            }

            this.graphics.endFill();
          }

          module.exports = Area;
        };
        Program["charts.Arrow"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var object_helper;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
          };

          var Arrow = function(json) {
            this.style = null;
            this.style = {
              start: [],
              end: [],
              this.colour: '#808080',
              alpha: 0.5,
              'barb-length': 20

            };

            object_helper.merge_2(json, this.style);

            this.style.colour = string.Utils.get_colour(this.style.colour);

            //      for each ( var val in json.values )
            //        this.style.points.push( new flash.geom.Point( val.x, val.y ) );
          };

          Arrow.prototype = Object.create(Base.prototype);

          Arrow.prototype.style = null;
          Arrow.prototype.resize = function(sc) {

            this.graphics.clear();
            this.graphics.lineStyle(1, this.style.colour, 1);

            this.graphics.moveTo(
              sc.get_x_from_val(this.style.start.x),
              sc.get_y_from_val(this.style.start.y));

            var x = sc.get_x_from_val(this.style.end.x);
            var y = sc.get_y_from_val(this.style.end.y);
            this.graphics.lineTo(x, y);

            var angle = Math.atan2(
              sc.get_y_from_val(this.style.start.y) - y,
              sc.get_x_from_val(this.style.start.x) - x
            );

            var barb_length = this.style['barb-length'];
            var barb_angle = 0.34;

            //first point is end of one barb
            var a = x + (barb_length * Math.cos(angle - barb_angle));
            var b = y + (barb_length * Math.sin(angle - barb_angle));

            //final point is end of the second barb
            var c = x + (barb_length * Math.cos(angle + barb_angle));
            var d = y + (barb_length * Math.sin(angle + barb_angle));

            this.graphics.moveTo(x, y);
            this.graphics.lineTo(a, b);

            this.graphics.moveTo(x, y);
            this.graphics.lineTo(c, d);

          }

          module.exports = Arrow;
        };
        Program["charts.Bar3D"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');

          var Bar3D = function(json, group) {
            BarBase.call(this, json, group);
          };

          Bar3D.prototype = Object.create(BarBase.prototype);

          Bar3D.prototype.get_element = function(index, value) {

            return new charts.series.bars.Bar3D(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = Bar3D;
        };
        Program["charts.Bar"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');

          var Bar = function(json, group) {

            BarBase.call(this, json, group);
          };

          Bar.prototype = Object.create(BarBase.prototype);

          Bar.prototype.get_element = function(index, value) {

            return new charts.series.bars.Bar(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = Bar;
        };
        Program["charts.BarBase"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var Properties, Element;
          module.inject = function() {
            Properties = module.import('', 'Properties');
            Element = module.import('charts.series', 'Element');
          };

          var BarBase = function(json, group) {
            this.on_show = null;

            var root = new Properties({
              this.values: [],
                this.colour: '#3030d0',
                text: '', // <-- default not display a key
                'font-size': 12,
                tip: '#val#<br>#x_label#',
                alpha: 0.6,
                'on-click': false,
                'axis': 'left'
            });

            this.props = new Properties(json, root);

            /*
              var on_show_root = new Properties( {
                type:    "none",    //"pop-up",
                cascade:  3,
                delay:    0
                });
              this.on_show = new Properties(json['on-show'], on_show_root);
            */
            this.on_show = this.get_on_show(json['on-show']);

            this.colour = this.props.get_colour('colour');
            this.key = this.props.get('text');
            this.font_size = this.props.get('font-size');

            // Minor hack, replace all #key# with this key text:
            this.props.set('tip', this.props.get('tip').replace('#key#', this.key));

            //
            // bars are grouped, so 3 bar sets on one chart
            // will arrange them selves next to each other
            // at each value of X, this.group tell the bar
            // where it is in that grouping
            //
            this.group = group;

            this.values = this.props.get('values');
            this.add_values();
          };

          BarBase.prototype = Object.create(Base.prototype);

          BarBase.prototype.group = 0;
          BarBase.prototype.on_show = null;
          BarBase.prototype.get_on_show = function(json) {

            var on_show_root = new Properties({
              type: "none", //"pop-up",
              cascade: 3,
              delay: 0
            });

            return new Properties(json, on_show_root);
          };
          BarBase.prototype.resize = function(sc) {

            for (var i = 0; i < this.numChildren; i++) {
              var e = (Element) this.getChildAt(i);
              e.resize(sc);
            }
          };
          BarBase.prototype.get_max_x = function() {

            var max_index = Number.MIN_VALUE;

            for (var i = 0; i < this.numChildren; i++) {

              var e = (Element) this.getChildAt(i);
              max_index = Math.max(max_index, e.index);
            }

            // 0 is a position, so count it:
            return max_index;
          };
          BarBase.prototype.get_min_x = function() {
            return 0;
          };
          BarBase.prototype.get_element_helper_prop = function(value) {

            var default_style = new Properties({
              this.colour: this.props.get('colour'),
                tip: this.props.get('tip'),
                alpha: this.props.get('alpha'),
                'on-click': this.props.get('on-click'),
                axis: this.props.get('axis'),
                'on-show': this.on_show
            });

            var s;
            if (value is Number)
              s = new Properties({
                'top': value
              }, default_style);
            else
              s = new Properties(value, default_style);

            return s;
          };
          BarBase.prototype.closest = function(x, y) {
            var shortest = Number.MAX_VALUE;
            var ex = null;

            for (var i = 0; i < this.numChildren; i++) {
              var e = (Element) this.getChildAt(i);

              e.is_tip = false;

              if ((x > e.x) && (x < e.x + e.width)) {
                // mouse is in position 1
                shortest = Math.min(Math.abs(x - e.x), Math.abs(x - (e.x + e.width)));
                ex = e;
                break;
              } else {
                // mouse is in position 2
                // get distance to left side and right side
                var d1 = Math.abs(x - e.x);
                var d2 = Math.abs(x - (e.x + e.width));
                var min = Math.min(d1, d2);
                if (min < shortest) {
                  shortest = min;
                  ex = e;
                }
              }
            }
            var dy = Math.abs(y - ex.y);

            return {
              element: ex,
              distance_x: shortest,
              distance_y: dy
            };
          };
          BarBase.prototype.die = function() {
            Base.prototype.die.call(this);
            this.props.die();
          }

          module.exports = BarBase;
        };
        Program["charts.BarCandle"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var Utils;
          module.inject = function() {
            Utils = module.import('string', 'Utils');
          };

          var BarCandle = function(lv, num, group) {
            BarBase.call(this, lv, num, group, 'candle');
          };

          BarCandle.prototype = Object.create(BarBase.prototype);

          BarCandle.prototype.parse_bar = function(val) {
            var vals = val.split(",");

            //this.alpha = Number( vals[0] );
            this.line_width = Number(vals[1]);
            this.colour = Utils.get_colour(vals[2]);

            if (vals.length > 3)
              this.key = vals[3].replace('#comma#', ',');

            if (vals.length > 4)
              this.font_size = Number(vals[4]);
          };
          BarCandle.prototype.parse_list = function(values) {
            var groups = [];
            var tmp = '';
            var start = false;

            for (var i = 0; i < values.length; i++) {
              switch (values.charAt(i)) {
                case '[':
                  start = true;
                  break;
                case ']':
                  start = false;
                  groups.push(tmp);
                  tmp = '';
                  break;
                default:
                  if (start)
                    tmp += values.charAt(i);
                  break;
              }
            }
            return groups;
          };
          BarCandle.prototype.get_element = function(x, value) {
            return new PointBarCandle(x, value, this.line_width, this.colour, this.group);
          }

          module.exports = BarCandle;
        };
        Program["charts.BarCylinder"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var Cylinder;
          module.inject = function() {
            Cylinder = module.import('charts.series.bars', 'Cylinder');
          };

          var BarCylinder = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarCylinder.prototype = Object.create(BarBase.prototype);

          BarCylinder.prototype.get_element = function(index, value) {

            return new Cylinder(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarCylinder;
        };
        Program["charts.BarCylinderOutline"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var CylinderOutline;
          module.inject = function() {
            CylinderOutline = module.import('charts.series.bars', 'CylinderOutline');
          };

          var BarCylinderOutline = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarCylinderOutline.prototype = Object.create(BarBase.prototype);

          BarCylinderOutline.prototype.get_element = function(index, value) {

            return new CylinderOutline(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarCylinderOutline;
        };
        Program["charts.BarDome"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var Dome;
          module.inject = function() {
            Dome = module.import('charts.series.bars', 'Dome');
          };

          var BarDome = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarDome.prototype = Object.create(BarBase.prototype);

          BarDome.prototype.get_element = function(index, value) {

            return new Dome(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarDome;
        };
        Program["charts.BarFade"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var PointBarFade;
          module.inject = function() {
            PointBarFade = module.import('charts.Elements', 'PointBarFade');
          };

          var BarFade = function(json, group) {
            BarBase.call(this, json, group);
          };

          BarFade.prototype = Object.create(BarBase.prototype);

          BarFade.prototype.get_element = function(index, value) {
            return new PointBarFade(index, value, this.colour, this.group);
          }

          module.exports = BarFade;
        };
        Program["charts.BarGlass"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var Glass;
          module.inject = function() {
            Glass = module.import('charts.series.bars', 'Glass');
          };

          var BarGlass = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarGlass.prototype = Object.create(BarBase.prototype);

          BarGlass.prototype.get_element = function(index, value) {

            return new Glass(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarGlass;
        };
        Program["charts.BarOutline"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var object_helper, Properties, Outline;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Properties = module.import('', 'Properties');
            Outline = module.import('charts.series.bars', 'Outline');
          };

          var BarOutline = function(json, group) {
            this.style = null;

            //
            // specific value for outline
            //
            this.style = {
              'outline-colour': "#000000"
            };

            object_helper.merge_2(json, this.style);

            BarBase.call(this, json, group);
          };

          BarOutline.prototype = Object.create(BarBase.prototype);

          BarOutline.prototype.outline_colour = 0;
          BarOutline.prototype.style = null;
          BarOutline.prototype.get_element = function(index, value) {

            var root = new Properties({
              'outline-colour': this.style['outline-colour']
            });

            var default_style = this.get_element_helper_prop(value);
            default_style.set_parent(root);

            /*
                if ( !default_style['outline-colour'] )
                  default_style['outline-colour'] = this.style['outline-colour'];
                
                if( default_style['outline-colour'] is String )
                  default_style['outline-colour'] = Utils.get_colour( default_style['outline-colour'] );
            */

            return new Outline(index, default_style, this.group);
          }

          module.exports = BarOutline;
        };
        Program["charts.BarPlastic"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var Plastic;
          module.inject = function() {
            Plastic = module.import('charts.series.bars', 'Plastic');
          };

          var BarPlastic = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarPlastic.prototype = Object.create(BarBase.prototype);

          BarPlastic.prototype.get_element = function(index, value) {

            return new Plastic(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarPlastic;
        };
        Program["charts.BarPlasticFlat"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var PlasticFlat;
          module.inject = function() {
            PlasticFlat = module.import('charts.series.bars', 'PlasticFlat');
          };

          var BarPlasticFlat = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarPlasticFlat.prototype = Object.create(BarBase.prototype);

          BarPlasticFlat.prototype.get_element = function(index, value) {

            return new PlasticFlat(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarPlasticFlat;
        };
        Program["charts.BarRound3D"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');

          var BarRound3D = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarRound3D.prototype = Object.create(BarBase.prototype);

          BarRound3D.prototype.get_element = function(index, value) {

            return new charts.series.bars.Round3D(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarRound3D;
        };
        Program["charts.BarRound"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var Round;
          module.inject = function() {
            Round = module.import('charts.series.bars', 'Round');
          };

          var BarRound = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarRound.prototype = Object.create(BarBase.prototype);

          BarRound.prototype.get_element = function(index, value) {

            return new Round(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarRound;
        };
        Program["charts.BarRoundGlass"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var RoundGlass;
          module.inject = function() {
            RoundGlass = module.import('charts.series.bars', 'RoundGlass');
          };

          var BarRoundGlass = function(json, group) {

            BarBase.call(this, json, group);
          };

          BarRoundGlass.prototype = Object.create(BarBase.prototype);

          BarRoundGlass.prototype.get_element = function(index, value) {

            return new RoundGlass(index, this.get_element_helper_prop(value), this.group);
          }

          module.exports = BarRoundGlass;
        };
        Program["charts.BarSketch"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var object_helper, Properties, Sketch;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Properties = module.import('', 'Properties');
            Sketch = module.import('charts.series.bars', 'Sketch');
          };

          var BarSketch = function(json, group) {
            this.style = null;

            //
            // these are specific values to the Sketch
            // and so we need to sort them out here
            //
            this.style = {
              'outline-colour': "#000000",
              this.offset: 6
            };

            object_helper.merge_2(json, this.style);

            BarBase.call(this, this.style, group);
          };

          BarSketch.prototype = Object.create(BarBase.prototype);

          BarSketch.prototype.outline_colour = 0;
          BarSketch.prototype.offset = 0;
          BarSketch.prototype.style = null;
          BarSketch.prototype.get_element = function(index, value) {

            var root = new Properties({
              'outline-colour': this.style['outline-colour'],
              this.offset: this.style.offset
            });

            var default_style = this.get_element_helper_prop(value);
            default_style.set_parent(root);

            /**
                  // our parent colour is a number, but
                  // we may have our own colour:
                  if( default_style.colour is String )
                    default_style.colour = Utils.get_colour( default_style.colour );
                    
                  if ( !default_style['outline-colour'] )
                    default_style['outline-colour'] = this.style['outline-colour'];
                    
                  if( default_style['outline-colour'] is String )
                    default_style['outline-colour'] = Utils.get_colour( default_style['outline-colour'] );
                  
                  if ( !default_style.offset )
                    default_style.offset = this.style.offset;
            **/
            return new Sketch(index, default_style, this.group);
          }

          module.exports = BarSketch;
        };
        Program["charts.BarStack"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var Properties, Element, StackCollection;
          module.inject = function() {
            Properties = module.import('', 'Properties');
            Element = module.import('charts.series', 'Element');
            StackCollection = module.import('charts.series.bars', 'StackCollection');
          };

          var BarStack = function(json, num, group) {

            // don't let the parent do anything, we just want to
            // use some of the more useful methods
            BarBase.call(this, {}, 0);

            // now do all the setup
            var root = new Properties({
              this.values: [],
                keys: [],
                colours: ['#FF0000', '#00FF00'], // <-- ugly default colours
                text: '', // <-- default not display a key
                'font-size': 12,
                tip: '#x_label# : #val#<br>Total: #total#',
                alpha: 0.6,
                'on-click': false,
                'axis': 'left'
            });

            this.props = new Properties(json, root);

            this.on_show = this.get_on_show(json['on-show']);
            //
            // bars are grouped, so 3 bar sets on one chart
            // will arrange them selves next to each other
            // at each value of X, this.group tell the bar
            // where it is in that grouping
            //
            this.group = group;

            this.values = json.values;

            this.add_values();
          };

          BarStack.prototype = Object.create(BarBase.prototype);

          BarStack.prototype.get_keys = function() {

            var tmp = [];

            for each(var o in this.props.get('keys')) {
              if (o.text && o['font-size'] && o.colour) {
                o.colour = string.Utils.get_colour(o.colour);
                tmp.push(o);
              }
            }

            return tmp;
          };
          BarStack.prototype.get_element = function(index, value) {

            //
            // this is the style for a stack:
            //
            var default_style = new Properties({
              colours: this.props.get('colours'),
              tip: this.props.get('tip'),
              alpha: this.props.get('alpha'),
              'on-click': this.props.get('on-click'),
              axis: this.props.get('axis'),
              'on-show': this.on_show,
              this.values: value
            });

            return new StackCollection(index, default_style, this.group);
          };
          BarStack.prototype.get_all_at_this_x_pos = function(x) {

            var tmp = [];
            var p;
            var e;

            for (var i = 0; i < this.numChildren; i++) {

              // some of the children will will mask
              // Sprites, so filter those out:
              //
              if (this.getChildAt(i) is Element) {

                e = (StackCollection) this.getChildAt(i);

                p = e.get_mid_point();
                if (p.x == x) {
                  var children = e.get_children();
                  for each(var child in children)
                  tmp.push(child);
                }
              }
            }

            return tmp;
          }

          module.exports = BarStack;
        };
        Program["charts.Base"] = function(module, exports) {
          var Element;
          module.inject = function() {
            Element = module.import('charts.series', 'Element');
          };

          var Base = function() {
            this.props = null;
            this.values = null;
          };

          Base.prototype = Object.create(Sprite.prototype);

          Base.prototype.key = null;
          Base.prototype.font_size = 0;
          Base.prototype.colour = 0;
          Base.prototype.props = null;
          Base.prototype.values = null;
          Base.prototype.get_colour = function() {
            return this.colour;
          };
          Base.prototype.get_keys = function() {

            var tmp = [];

            // some lines may not have a key
            if ((this.font_size > 0) && (this.key != ''))
              tmp.push({
                'text': this.key,
                'font-size': this.font_size,
                'colour': this.get_colour()
              });

            return tmp;
          };
          Base.prototype.get_max_x = function() {

            var max = Number.MIN_VALUE;
            //
            // count the non-mask items:
            //
            for (var i = 0; i < this.numChildren; i++) {
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);
                max = Math.max(max, e.get_x());
              }
            }

            return max;
          };
          Base.prototype.get_min_x = function() {

            var min = Number.MAX_VALUE;
            //
            // count the non-mask items:
            //
            for (var i = 0; i < this.numChildren; i++) {
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);
                min = Math.min(min, e.get_x());
              }
            }

            return min;
          };
          Base.prototype.get_y_range = function() {

            var max = Number.MIN_VALUE;
            var min = Number.MAX_VALUE;
            //
            // count the non-mask items:
            //
            for (var i = 0; i < this.numChildren; i++) {
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);
                var y = e.get_y();
                max = Math.max(max, y);
                min = Math.min(min, y);
              }
            }

            return {
              max: max,
              min: min
            };
          };
          Base.prototype.left_axis = function() {

            // anything that is not 'right' defaults to the left axis
            return this.props.get('axis') != 'right';
          };
          Base.prototype.resize = function(sc) {};
          Base.prototype.closest = function(x, y) {
            var shortest = Number.MAX_VALUE;
            var closest = null;
            var dx;

            for (var i = 0; i < this.numChildren; i++) {

              //
              // some of the children will will mask
              // Sprites, so filter those out:
              //
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);
                e.set_tip(false);

                dx = Math.abs(x - e.x);

                if (dx < shortest) {
                  shortest = dx;
                  closest = e;
                }
              }
            }

            var dy = 0;
            if (closest)
              dy = Math.abs(y - closest.y);

            return {
              element: closest,
              distance_x: shortest,
              distance_y: dy
            };
          };
          Base.prototype.closest_2 = function(x, y) {

            // get the closest Elements X value
            var x = this.closest_x(x);
            var tmp = this.get_all_at_this_x_pos(x);

            // tr.aces('tmp.length', tmp.length);

            var closest = this.get_closest_y(tmp, y);
            var dy = Math.abs(y - closest.y);
            // tr.aces('closest.length', closest.length);

            return closest;
          };
          Base.prototype.closest_x = function(x) {

            var closest = Number.MAX_VALUE;
            var p;
            var x_pos;
            var dx;

            for (var i = 0; i < this.numChildren; i++) {

              //
              // some of the children will will mask
              // Sprites, so filter those out:
              //
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);

                p = e.get_mid_point();
                dx = Math.abs(x - p.x);

                if (dx < closest) {
                  closest = dx;
                  x_pos = p.x;
                }
              }
            }

            return x_pos;
          };
          Base.prototype.get_all_at_this_x_pos = function(x) {

            var tmp = [];
            var p;
            var e;

            for (var i = 0; i < this.numChildren; i++) {

              // some of the children will will mask
              // Sprites, so filter those out:
              //
              if (this.getChildAt(i) is Element) {

                e = (Element) this.getChildAt(i);

                //
                // Point elements are invisible by default.
                //
                // Prevent invisible points from showing tooltips
                // For scatter line area
                //if (e.visible)
                //{
                p = e.get_mid_point();
                if (p.x == x)
                  tmp.push(e);
                //}
              }
            }

            return tmp;
          };
          Base.prototype.get_closest_y = function(elements, y) {

            var y_min = Number.MAX_VALUE;
            var dy;
            var closest = [];
            var p;
            var e;

            // get min Y distance
            for each(e in elements) {

              p = e.get_mid_point();
              dy = Math.abs(y - p.y);

              y_min = Math.min(dy, y_min);
            }

            // select all Elements at this Y pos
            for each(e in elements) {

              p = e.get_mid_point();
              dy = Math.abs(y - p.y);
              if (dy == y_min)
                closest.push(e);
            }

            return closest;
          };
          Base.prototype.mouse_proximity = function(x, y) {

            var closest = Number.MAX_VALUE;
            var p;
            var i;
            var e;
            var mouse = new flash.geom.Point(x, y);

            //
            // find the closest Elements
            //
            for (i = 0; i < this.numChildren; i++) {

              // filter mask Sprites
              if (this.getChildAt(i) is Element) {

                e = (Element) this.getChildAt(i);
                closest = Math.min(flash.geom.Point.distance(e.get_mid_point(), mouse), closest);
              }
            }

            //
            // grab all Elements at this distance
            //
            var close = [];
            for (i = 0; i < this.numChildren; i++) {

              // filter mask Sprites
              if (this.getChildAt(i) is Element) {

                e = (Element) this.getChildAt(i);
                if (flash.geom.Point.distance(e.get_mid_point(), mouse) == closest)
                  close.push(e);
              }
            }

            return close;
          };
          Base.prototype.mouse_out = function() {
            for (var i = 0; i < this.numChildren; i++) {

              // filter out the mask elements in line charts
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);
                e.set_tip(false);
              }
            }
          };
          Base.prototype.get_element = function(index, value) {
            return null;
          };
          Base.prototype.add_values = function() {

            // keep track of the X position (column)
            var index = 0;

            for each(var val in this.values) {
              var tmp;

              //
              // TODO: fix or document what is happening in link-null-bug.txt
              //

              // filter out the 'null' values
              if (val != null) {
                tmp = this.get_element(index, val);

                if (tmp.line_mask != null)
                  this.addChild(tmp.line_mask);

                this.addChild(tmp);
              }

              index++;
            }
          };
          Base.prototype.tooltip_replace_labels = function(labels) {
            for (var i = 0; i < this.numChildren; i++) {

              // filter out the mask elements in line charts
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);
                e.tooltip_replace_labels(labels);
              }
            }
          };
          Base.prototype.die = function() {

            for (var i = 0; i < this.numChildren; i++)
              if (this.getChildAt(i) is Element) {

                var e = (Element) this.getChildAt(i);
                e.die();
              }

            while (this.numChildren > 0)
              this.removeChildAt(0);
          }

          module.exports = Base;
        };
        Program["charts.Candle"] = function(module, exports) {
          var BarBase = module.import('charts', 'BarBase');
          var tr, ECandle;
          module.inject = function() {
            tr = module.import('', 'tr');
            ECandle = module.import('charts.series.bars', 'ECandle');
          };

          var Candle = function(json, group) {

            BarBase.call(this, json, group);

            tr.aces('---');
            tr.ace_json(json);
            tr.aces('neg', this.props.has('negative-colour'), this.props.get_colour('negative-colour'));

          };

          Candle.prototype = Object.create(BarBase.prototype);

          Candle.prototype.negative_colour = 0;
          Candle.prototype.get_element = function(index, value) {

            var default_style = this.get_element_helper_prop(value);
            if (this.props.has('negative-colour'))
              default_style.set('negative-colour', this.props.get('negative-colour'));

            return new ECandle(index, default_style, this.group);
          }

          module.exports = Candle;
        };
        Program["charts.Factory"] = function(module, exports) {
          var Area, Arrow, Bar3D, Bar, BarCylinder, BarCylinderOutline, BarDome, BarFade, BarGlass, BarOutline, BarPlastic, BarPlasticFlat, BarRound3D, BarRound, BarRoundGlass, BarSketch, BarStack, Candle, HBar, Line, ObjectCollection, Pie, Scatter, ScatterLine, Shape, Tags, Bar3D, Bar;
          module.inject = function() {
            Area = module.import('charts', 'Area');
            Arrow = module.import('charts', 'Arrow');
            Bar3D = module.import('charts', 'Bar3D');
            Bar = module.import('charts', 'Bar');
            BarCylinder = module.import('charts', 'BarCylinder');
            BarCylinderOutline = module.import('charts', 'BarCylinderOutline');
            BarDome = module.import('charts', 'BarDome');
            BarFade = module.import('charts', 'BarFade');
            BarGlass = module.import('charts', 'BarGlass');
            BarOutline = module.import('charts', 'BarOutline');
            BarPlastic = module.import('charts', 'BarPlastic');
            BarPlasticFlat = module.import('charts', 'BarPlasticFlat');
            BarRound3D = module.import('charts', 'BarRound3D');
            BarRound = module.import('charts', 'BarRound');
            BarRoundGlass = module.import('charts', 'BarRoundGlass');
            BarSketch = module.import('charts', 'BarSketch');
            BarStack = module.import('charts', 'BarStack');
            Candle = module.import('charts', 'Candle');
            HBar = module.import('charts', 'HBar');
            Line = module.import('charts', 'Line');
            ObjectCollection = module.import('charts', 'ObjectCollection');
            Pie = module.import('charts', 'Pie');
            Scatter = module.import('charts', 'Scatter');
            ScatterLine = module.import('charts', 'ScatterLine');
            Shape = module.import('charts', 'Shape');
            Tags = module.import('charts', 'Tags');
            Bar3D = module.import('charts.series.bars', 'Bar3D');
            Bar = module.import('charts.series.bars', 'Bar');
          };

          var Factory = function Factory() {};

          Factory.MakeChart = function(json) {
            var collection = new ObjectCollection();

            // multiple bar charts all have the same X values, so
            // they are grouped around each X value, this tells
            // ScreenCoords how to group them:
            var bar_group = 0;
            var name = '';
            var c = 1;

            var elements = (Array) json['elements'];

            for (var i = 0; i < elements.length; i++) {
              // tr.ace( elements[i]['type'] );

              switch (elements[i]['type']) {
                case 'bar':
                  collection.add(new Bar(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'line':
                  collection.add(new Line(elements[i]));
                  break;

                case 'area':
                  collection.add(new Area(elements[i]));
                  break;

                case 'pie':
                  collection.add(new Pie(elements[i]));
                  break;

                case 'hbar':
                  collection.add(new HBar(elements[i]));
                  bar_group++;
                  break;

                case 'bar_stack':
                  collection.add(new BarStack(elements[i], c, bar_group));
                  bar_group++;
                  break;

                case 'scatter':
                  collection.add(new Scatter(elements[i]));
                  break;

                case 'scatter_line':
                  collection.add(new ScatterLine(elements[i]));
                  break;

                case 'bar_sketch':
                  collection.add(new BarSketch(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_glass':
                  collection.add(new BarGlass(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_cylinder':
                  collection.add(new BarCylinder(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_cylinder_outline':
                  collection.add(new BarCylinderOutline(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_dome':
                  collection.add(new BarDome(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_round':
                  collection.add(new BarRound(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_round_glass':
                  collection.add(new BarRoundGlass(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_round3d':
                  collection.add(new BarRound3D(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_fade':
                  collection.add(new BarFade(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_3d':
                  collection.add(new Bar3D(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_filled':
                  collection.add(new BarOutline(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_plastic':
                  collection.add(new BarPlastic(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'bar_plastic_flat':
                  collection.add(new BarPlasticFlat(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'shape':
                  collection.add(new Shape(elements[i]));
                  break;

                case 'candle':
                  collection.add(new Candle(elements[i], bar_group));
                  bar_group++;
                  break;

                case 'tags':
                  collection.add(new Tags(elements[i]));
                  break;

                case 'arrow':
                  collection.add(new Arrow(elements[i]));
                  break;

              }
            }
            /*
                
          
              else if ( lv['candle' + name] != undefined )
              {
                ob = new BarCandle(lv, c, bar_group);
                bar_group++;
              }
              
            */

            var y2 = false;
            var y2lines;

            //
            // some data sets are attached to the right
            // Y axis (and min max)
            //
            //      this.attach_right = [];

            //      if( lv.show_y2 != undefined )
            //        if( lv.show_y2 != 'false' )
            //          if( lv.y2_lines != undefined )
            //          {
            //            this.attach_right = lv.y2_lines.split(",");
            //          }

            collection.groups = bar_group;
            return collection;
          };

          Factory.prototype.attach_right = null

          module.exports = Factory;
        };
        Program["charts.HBar"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var object_helper, Utils, Horizontal;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Utils = module.import('string', 'Utils');
            Horizontal = module.import('charts.series.bars', 'Horizontal');
          };

          var HBar = function(json) {
            this.style = null;

            this.style = {
              this.values: [],
                this.colour: '#3030d0',
                text: '', // <-- default not display a key
                'font-size': 12,
                tip: '#val#'
            };

            object_helper.merge_2(json, this.style);

            //this.alpha = Number( vals[0] );
            this.colour = string.Utils.get_colour(this.style.colour);
            this.key = json.text;
            this.font_size = json['font-size'];

            //
            // bars are grouped, so 3 bar sets on one chart
            // will arrange them selves next to each other
            // at each value of X, this.group tell the bar
            // where it is in that grouping
            //
            this.group = 0;

            this.values = json['values'];

            this.style['on-click'] = json['on-click'];

            this.add_values();
          };

          HBar.prototype = Object.create(Base.prototype);

          HBar.prototype.group = 0;
          HBar.prototype.style = null;
          HBar.prototype.get_element = function(index, value) {

            var default_style = {
              this.colour: this.style.colour,
                tip: this.style.tip,
                'on-click': this.style['on-click']
            };

            if (value is Number)
              default_style.top = value;
            else
              object_helper.merge_2(value, default_style);

            // our parent colour is a number, but
            // we may have our own colour:
            if (default_style.colour is String)
              default_style.colour = Utils.get_colour(default_style.colour);

            return new Horizontal(index, default_style, this.group);
          };
          HBar.prototype.resize = function(sc) {

            for (var i = 0; i < this.numChildren; i++) {
              var p = (Horizontal) this.getChildAt(i);
              p.resize(sc);
            }
          };
          HBar.prototype.get_max_x = function() {

            var x = 0;
            //
            // count the non-mask items:
            //
            for (var i = 0; i < this.numChildren; i++)
              if (this.getChildAt(i) is Horizontal) {

                var h = (Horizontal) this.getChildAt(i);
                x = Math.max(x, h.get_max_x());

              }

            return x;
          };
          HBar.prototype.get_min_x = function() {
            return 0;
          }

          module.exports = HBar;
        };
        Program["charts.Line"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var Properties, tr, LineStyle, Element, DefaultDotProperties, dot_factory, PointDotBase;
          module.inject = function() {
            Properties = module.import('', 'Properties');
            tr = module.import('', 'tr');
            LineStyle = module.import('charts', 'LineStyle');
            Element = module.import('charts.series', 'Element');
            DefaultDotProperties = module.import('charts.series.dots', 'DefaultDotProperties');
            dot_factory = module.import('charts.series.dots', 'dot_factory');
            PointDotBase = module.import('charts.series.dots', 'PointDotBase');
          };

          var Line = function(json) {
            this.dot_style = null;
            this.on_show = null;
            this.line_style = null;
            this.on_show_timer = null;

            var root = new Properties({
              this.values: [],
                width: 2,
                this.colour: '#3030d0',
                text: '', // <-- default not display a key
                'font-size': 12,
                tip: '#val#',
                loop: false,
                axis: 'left'
            });
            this.props = new Properties(json, root);

            this.line_style = new LineStyle(json['line-style']);
            this.dot_style = new DefaultDotProperties(json['dot-style'], this.props.get('colour'), this.props.get('axis'));

            //
            // see scatter base
            //
            var on_show_root = new Properties({
              type: "none", // "pop-up",
              cascade: 0.5,
              delay: 0
            });
            this.on_show = new Properties(json['on-show'], on_show_root);
            this.on_show_start = true; // this.on_show.get('type');
            //
            //

            this.key = this.props.get('text');
            this.font_size = this.props.get('font-size');

            this.values = this.props.get('values');
            this.add_values();

            //
            // this allows the dots to erase part of the line
            //
            this.blendMode = BlendMode.LAYER;
          };

          Line.prototype = Object.create(Base.prototype);

          Line.prototype.dot_style = null;
          Line.prototype.on_show = null;
          Line.prototype.line_style = null;
          Line.prototype.on_show_timer = null;
          Line.prototype.on_show_start = false;
          Line.prototype.get_element = function(index, value) {

            if (value is Number)
              value = {
                value: value
              };

            var tmp = new Properties(value, this.dot_style);

            // Minor hack, replace all #key# with this key text,
            // we do this *after* the merge.
            tmp.set('tip', tmp.get('tip').replace('#key#', this.key));

            // attach the animation bits:
            tmp.set('on-show', this.on_show);

            return dot_factory.make(index, tmp);
          };
          Line.prototype.resize = function(sc) {
            this.x = this.y = 0;

            this.move_dots(sc);

            if (this.on_show_start)
              this.start_on_show_timer();
            else
              this.draw();

          };
          Line.prototype.start_on_show_timer = function() {
            this.on_show_start = false;
            this.on_show_timer = new Timer(1000 / 60); // <-- 60 frames a second = 1000ms / 60
            this.on_show_timer.addEventListener("timer", this.animationManager);
            // Start the timer
            this.on_show_timer.start();
          };
          Line.prototype.animationManager = function(eventArgs) {

            this.draw();

            if (!this.still_animating()) {
              tr.ace('Line.as : on show animation stop');
              this.on_show_timer.stop();
            }
          };
          Line.prototype.still_animating = function() {
            var i;
            var tmp;

            for (i = 0; i < this.numChildren; i++) {

              tmp = (Sprite) this.getChildAt(i);

              // filter out the line masks
              if (tmp is PointDotBase) {
                var e = (PointDotBase) tmp;
                if (e.is_tweening())
                  return true;
              }
            }
            return false;
          };
          Line.prototype.draw = function() {
            this.graphics.clear();
            this.draw_line();
          };
          Line.prototype.draw_line = function() {

            this.graphics.lineStyle(this.props.get_colour('width'), this.props.get_colour('colour'));

            if (this.line_style.style != 'solid')
              this.dash_line();
            else
              this.solid_line();

          };
          Line.prototype.move_dots = function(sc) {

            var i;
            var tmp;

            for (i = 0; i < this.numChildren; i++) {

              tmp = (Sprite) this.getChildAt(i);

              // filter out the line masks
              if (tmp is Element) {
                var e = (Element) tmp;

                // tell the point where it is on the screen
                // we will use this info to place the tooltip
                e.resize(sc);
              }
            }
          };
          Line.prototype.solid_line = function() {

            var first = true;
            var i;
            var tmp;
            var x;
            var y;

            for (i = 0; i < this.numChildren; i++) {

              tmp = (Sprite) this.getChildAt(i);

              // filter out the line masks
              if (tmp is Element) {
                var e = (Element) tmp;

                if (first) {
                  this.graphics.moveTo(e.x, e.y);
                  x = e.x;
                  y = e.y;
                  first = false;
                } else
                  this.graphics.lineTo(e.x, e.y);
              }
            }

            if (this.props.get('loop')) {
              // close the line loop (radar charts)
              this.graphics.lineTo(x, y);
            }
          };
          Line.prototype.dash_line = function() {

            var first = true;

            var prev_x = 0;
            var prev_y = 0;
            var on_len_left = 0;
            var off_len_left = 0;
            var on_len = this.line_style.on; //Stroke Length
            var off_len = this.line_style.off; //Space Length
            var now_on = true;

            for (var i = 0; i < this.numChildren; i++) {
              var tmp = (Sprite) this.getChildAt(i);
              //
              // filter out the line masks
              //
              if (tmp is Element) {
                var e = (Element) tmp;

                if (first) {
                  this.graphics.moveTo(e.x, e.y);
                  on_len_left = on_len;
                  off_len_left = off_len;
                  now_on = true;
                  first = false;
                  prev_x = e.x;
                  prev_y = e.y;
                  var x_tmp_1 = prev_x;
                  var x_tmp_2;
                  var y_tmp_1 = prev_y;
                  var y_tmp_2;
                } else {
                  var part_len = Math.sqrt((e.x - prev_x) * (e.x - prev_x) + (e.y - prev_y) * (e.y - prev_y));
                  var sinus = ((e.y - prev_y) / part_len);
                  var cosinus = ((e.x - prev_x) / part_len);
                  var part_len_left = part_len;
                  var inside_part = true;

                  while (inside_part) {
                    //Draw Lines And spaces one by one in loop
                    if (now_on) {
                      //Draw line
                      //If whole stroke fits
                      if (on_len_left < part_len_left) {
                        //Fits - draw whole stroke
                        x_tmp_2 = x_tmp_1 + on_len_left * cosinus;
                        y_tmp_2 = y_tmp_1 + on_len_left * sinus;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        part_len_left = part_len_left - on_len_left;
                        now_on = false;
                        off_len_left = off_len;
                      } else {
                        //Does not fit - draw part of the stroke
                        x_tmp_2 = e.x;
                        y_tmp_2 = e.y;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        on_len_left = on_len_left - part_len_left;
                        inside_part = false;
                      }
                      this.graphics.lineTo(x_tmp_2, y_tmp_2);
                    } else {
                      //Draw space
                      //If whole space fits
                      if (off_len_left < part_len_left) {
                        //Fits - draw whole space
                        x_tmp_2 = x_tmp_1 + off_len_left * cosinus;
                        y_tmp_2 = y_tmp_1 + off_len_left * sinus;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        part_len_left = part_len_left - off_len_left;
                        now_on = true;
                        on_len_left = on_len;
                      } else {
                        //Does not fit - draw part of the space
                        x_tmp_2 = e.x;
                        y_tmp_2 = e.y;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        off_len_left = off_len_left - part_len_left;
                        inside_part = false;
                      }
                      this.graphics.moveTo(x_tmp_2, y_tmp_2);
                    }
                  }
                }
                prev_x = e.x;
                prev_y = e.y;
              }
            }
          };
          Line.prototype.get_colour = function() {
            return this.props.get_colour('colour');
          }

          module.exports = Line;
        };
        Program["charts.LineBase"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var object_helper, Properties, Utils, Element, dot_factory;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Properties = module.import('', 'Properties');
            Utils = module.import('string', 'Utils');
            Element = module.import('charts.series', 'Element');
            dot_factory = module.import('charts.series.dots', 'dot_factory');
          };

          var LineBase = function() {
            this.style = null;
          };

          LineBase.prototype = Object.create(Base.prototype);

          LineBase.prototype.style = null;
          LineBase.prototype.get_element = function(index, value) {

            //      var s = this.merge_us_with_value_object( value );
            //
            // the width of the hollow circle is the same as the width of the line
            //

            var tmp;
            if (value is Number)
              tmp = new Properties({
                value: value
              }, this.style['--dot-style']);
            else
              tmp = new Properties(value, this.style['--dot-style']);

            return dot_factory.make(index, tmp);
          };
          LineBase.prototype.resize = function(sc) {
            this.x = this.y = 0;

            this.graphics.clear();
            this.graphics.lineStyle(this.style.width, this.style.colour);

            if (this.style['line-style'].style != 'solid')
              this.dash_line(sc);
            else
              this.solid_line(sc);

          };
          LineBase.prototype.solid_line = function(sc) {

            var first = true;
            var i;
            var tmp;
            var x;
            var y;

            for (i = 0; i < this.numChildren; i++) {

              tmp = (Sprite) this.getChildAt(i);

              //
              // filter out the line masks
              //
              if (tmp is Element) {
                var e = (Element) tmp;

                // tell the point where it is on the screen
                // we will use this info to place the tooltip
                e.resize(sc);
                if (first) {
                  this.graphics.moveTo(e.x, e.y);
                  x = e.x;
                  y = e.y;
                  first = false;
                } else
                  this.graphics.lineTo(e.x, e.y);
              }
            }

            if (this.style.loop) {
              // close the line loop (radar charts)
              this.graphics.lineTo(x, y);
            }
          };
          LineBase.prototype.dash_line = function(sc) {

            var first = true;

            var prev_x = 0;
            var prev_y = 0;
            var on_len_left = 0;
            var off_len_left = 0;
            var on_len = this.style['line-style'].on; //Stroke Length
            var off_len = this.style['line-style'].off; //Space Length
            var now_on = true;

            for (var i = 0; i < this.numChildren; i++) {
              var tmp = (Sprite) this.getChildAt(i);
              //
              // filter out the line masks
              //
              if (tmp is Element) {
                var e = (Element) tmp;

                // tell the point where it is on the screen
                // we will use this info to place the tooltip
                e.resize(sc);
                if (first) {
                  this.graphics.moveTo(e.x, e.y);
                  on_len_left = on_len;
                  off_len_left = off_len;
                  now_on = true;
                  first = false;
                  prev_x = e.x;
                  prev_y = e.y;
                  var x_tmp_1 = prev_x;
                  var x_tmp_2;
                  var y_tmp_1 = prev_y;
                  var y_tmp_2;
                } else {
                  var part_len = Math.sqrt((e.x - prev_x) * (e.x - prev_x) + (e.y - prev_y) * (e.y - prev_y));
                  var sinus = ((e.y - prev_y) / part_len);
                  var cosinus = ((e.x - prev_x) / part_len);
                  var part_len_left = part_len;
                  var inside_part = true;

                  while (inside_part) {
                    //Draw Lines And spaces one by one in loop
                    if (now_on) {
                      //Draw line
                      //If whole stroke fits
                      if (on_len_left < part_len_left) {
                        //Fits - draw whole stroke
                        x_tmp_2 = x_tmp_1 + on_len_left * cosinus;
                        y_tmp_2 = y_tmp_1 + on_len_left * sinus;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        part_len_left = part_len_left - on_len_left;
                        now_on = false;
                        off_len_left = off_len;
                      } else {
                        //Does not fit - draw part of the stroke
                        x_tmp_2 = e.x;
                        y_tmp_2 = e.y;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        on_len_left = on_len_left - part_len_left;
                        inside_part = false;
                      }
                      this.graphics.lineTo(x_tmp_2, y_tmp_2);
                    } else {
                      //Draw space
                      //If whole space fits
                      if (off_len_left < part_len_left) {
                        //Fits - draw whole space
                        x_tmp_2 = x_tmp_1 + off_len_left * cosinus;
                        y_tmp_2 = y_tmp_1 + off_len_left * sinus;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        part_len_left = part_len_left - off_len_left;
                        now_on = true;
                        on_len_left = on_len;
                      } else {
                        //Does not fit - draw part of the space
                        x_tmp_2 = e.x;
                        y_tmp_2 = e.y;
                        x_tmp_1 = x_tmp_2;
                        y_tmp_1 = y_tmp_2;
                        off_len_left = off_len_left - part_len_left;
                        inside_part = false;
                      }
                      this.graphics.moveTo(x_tmp_2, y_tmp_2);
                    }
                  }
                }
                prev_x = e.x;
                prev_y = e.y;
              }
            }
          };
          LineBase.prototype.merge_us_with_value_object = function(value) {

            var default_style = {
              'dot-size': this.style['dot-size'],
              this.colour: this.style.colour,
              'halo-size': this.style['halo-size'],
              tip: this.style.tip,
              'on-click': this.style['on-click'],
              'axis': this.style.axis
            }

            if (value is Number)
              default_style.value = value;
            else
              object_helper.merge_2(value, default_style);

            // our parent colour is a number, but
            // we may have our own colour:
            if (default_style.colour is String)
              default_style.colour = Utils.get_colour(default_style.colour);

            // Minor hack, replace all #key# with this LINEs key text:
            default_style.tip = default_style.tip.replace('#key#', this.style.text);

            return default_style;
          };
          LineBase.prototype.get_colour = function() {
            return this.style.colour;
          }

          module.exports = LineBase;
        };
        Program["charts.LineDot"] = function(module, exports) {
          var LineBase = module.import('charts', 'LineBase');
          var object_helper, LineStyle;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            LineStyle = module.import('charts', 'LineStyle');
          };

          var LineDot = function(json) {

            this.style = {
              this.values: [],
                width: 2,
                this.colour: '#3030d0',
                text: '', // <-- default not display a key
                'dot-size': 5,
                'halo-size': 2,
                'font-size': 12,
                tip: '#val#',
                'line-style': new LineStyle(json['line-style'])
            };

            object_helper.merge_2(json, this.style);

            this.style.colour = string.Utils.get_colour(this.style.colour);

            this.key = this.style.text;
            this.font_size = this.style['font-size'];

            //      this.axis = which_axis_am_i_attached_to(data, num);
            //      tr.ace( name );
            //      tr.ace( 'axis : ' + this.axis );

            this.values = this.style['values'];
            this.add_values();

            //
            // this allows the dots to erase part of the line
            //
            this.blendMode = BlendMode.LAYER;

          };

          LineDot.prototype = Object.create(LineBase.prototype);

          module.exports = LineDot;
        };
        Program["charts.LineHollow"] = function(module, exports) {
          var LineBase = module.import('charts', 'LineBase');
          var object_helper, LineStyle;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            LineStyle = module.import('charts', 'LineStyle');
          };

          var LineHollow = function(json) {
            //
            // so the mask child can punch a hole through the line
            //
            this.blendMode = BlendMode.LAYER;

            this.style = {
              this.values: [],
                width: 2,
                this.colour: '#80a033',
                text: '',
                'font-size': 10,
                'dot-size': 6,
                'halo-size': 2,
                tip: '#val#',
                'line-style': new LineStyle(json['line-style']),
                'axis': 'left'
            };

            this.style = object_helper.merge(json, this.style);

            this.style.colour = string.Utils.get_colour(this.style.colour);
            this.values = this.style.values;

            this.key = this.style.text;
            this.font_size = this.style['font-size'];

            //      this.axis = which_axis_am_i_attached_to(data, num);
            //      tr.ace( name );
            //      tr.ace( 'axis : ' + this.axis );

            this.add_values();

          };

          LineHollow.prototype = Object.create(LineBase.prototype);

          module.exports = LineHollow;
        };
        Program["charts.LineStyle"] = function(module, exports) {
          var object_helper;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
          };

          var LineStyle = function(json) {

            // tr.ace(json);

            // default values:
            this.style = 'solid';
            this.on = 1;
            this.off = 5;

            object_helper.merge_2(json, this);
          };

          LineStyle.prototype = Object.create(Object.prototype);

          LineStyle.prototype.style = null;
          LineStyle.prototype.on = 0;
          LineStyle.prototype.off = 0

          module.exports = LineStyle;
        };
        Program["charts.ObjectCollection"] = function(module, exports) {
          var Pie;
          module.inject = function() {
            Pie = module.import('charts', 'Pie');
          };

          var ObjectCollection = function() {
            this.sets = null;
            this.sets = [];
          };

          ObjectCollection.prototype.sets = null;
          ObjectCollection.prototype.groups = 0;
          ObjectCollection.prototype.add = function(set) {
            this.sets.push(set);
          };
          ObjectCollection.prototype.get_max_x = function() {

            var max = Number.MIN_VALUE;

            for each(var o in this.sets)
            max = Math.max(max, o.get_max_x());

            return max;
          };
          ObjectCollection.prototype.get_min_x = function() {

            var min = Number.MAX_VALUE;

            for each(var o in this.sets)
            min = Math.min(min, o.get_min_x());

            return min;
          };
          ObjectCollection.prototype.get_y_range = function(left_axis) {
            left_axis = AS3JS.Utils.getDefaultValue(left_axis, true);

            var max = Number.MIN_VALUE;
            var min = Number.MAX_VALUE;

            for each(var o in this.sets) {

              if (left_axis == o.left_axis()) {
                var range = o.get_y_range();
                max = Math.max(max, range.max);
                min = Math.min(min, range.min);
              }
            }

            return {
              max: max,
              min: min
            };
          };
          ObjectCollection.prototype.resize = function(sc) {
            for each(var o in this.sets)
            o.resize(sc);
          };
          ObjectCollection.prototype.tooltip_replace_labels = function(labels) {

            for each(var o in this.sets)
            o.tooltip_replace_labels(labels);
          };
          ObjectCollection.prototype.mouse_out = function() {
            for each(var s in this.sets)
            s.mouse_out();
          };
          ObjectCollection.prototype.closest = function(x, y) {
            var o;
            var s;

            // get closest points from each data set
            var closest = [];
            for each(s in this.sets)
            closest.push(s.closest(x, y));

            // find closest point along X axis
            var min = Number.MAX_VALUE;
            for each(o in closest)
            min = Math.min(min, o.distance_x);

            //
            // now select all points that are the
            // min (see above) distance along the X axis
            //
            var xx = {
              element: null,
              distance_x: Number.MAX_VALUE,
              distance_y: Number.MAX_VALUE
            };
            for each(o in closest) {

              if (o.distance_x == min) {
                // these share the same X position, so choose
                // the closest to the mouse in the Y
                if (o.distance_y < xx.distance_y)
                  xx = o;
              }
            }

            // pie charts may not return an element
            if (xx.element)
              xx.element.set_tip(true);

            return xx.element;
          };
          ObjectCollection.prototype.mouse_move = function(x, y) {
            //
            // is the mouse over, above or below a
            // bar or point? For grouped bar charts,
            // two bars will share an X co-ordinate
            // and be the same distance from the
            // mouse. For example, if the mouse is
            // in position 1 in diagram above. This
            // filters out all items that are not
            // above or below the mouse:
            //
            var e = null; // this.inside__(x, y);

            if (!e) {
              //
              // no Elements are above or below the mouse,
              // so we select the BEST item to show (mouse
              // is in position 2)
              //
              e = this.closest(x, y);
            }

            return e;
          };
          ObjectCollection.prototype.closest_2 = function(x, y) {

            var e;
            var s;
            var p;

            //
            // get closest points from each data set
            //
            var closest = [];
            for each(s in this.sets) {

              var tmp = s.closest_2(x, y);
              for each(e in tmp)
              closest.push(e);
            }

            //
            // find closest point along X axis
            // different sets may return Elements
            // in different X locations
            //
            var min_x = Number.MAX_VALUE;
            for each(e in closest) {

              p = e.get_mid_point();
              min_x = Math.min(min_x, Math.abs(x - p.x));
            }

            //
            // filter out the Elements that
            // are too far away along the X axis
            //
            var good_x = [];
            for each(e in closest) {

              p = e.get_mid_point();
              if (Math.abs(x - p.x) == min_x)
                good_x.push(e);
            }

            //
            // now get min_y from filtered array
            //
            var min_y = Number.MAX_VALUE;
            for each(e in good_x) {

              p = e.get_mid_point();
              min_y = Math.min(min_y, Math.abs(y - p.y));
            }

            //
            // now filter out any that are not min_y
            //
            var good_x_and_y = [];
            for each(e in good_x) {

              p = e.get_mid_point();
              if (Math.abs(y - p.y) == min_y)
                good_x_and_y.push(e);
            }

            return good_x_and_y;
          };
          ObjectCollection.prototype.mouse_move_proximity = function(x, y) {
            var e;
            var s;
            var p;

            //
            // get closest points from each data set
            //
            var closest = [];
            for each(s in this.sets) {

              var tmp = s.mouse_proximity(x, y);
              for each(e in tmp)
              closest.push(e);
            }

            //
            // find the min distance to these
            //
            var min_dist = Number.MAX_VALUE;
            var mouse = new flash.geom.Point(x, y);
            for each(e in closest) {
              min_dist = Math.min(flash.geom.Point.distance(e.get_mid_point(), mouse), min_dist);
            }

            // keep these closest Elements
            var close = [];
            for each(e in closest) {
              if (flash.geom.Point.distance(e.get_mid_point(), mouse) == min_dist)
                close.push(e);
            }

            return close;
          };
          ObjectCollection.prototype.has_pie = function() {

            if (this.sets.length > 0 && (this.sets[0] is Pie))
              return true;
            else
              return false;
          };
          ObjectCollection.prototype.die = function() {

            for each(var o in this.sets)
            o.die();
          }

          module.exports = ObjectCollection;
        };
        Program["charts.Pie"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var NumberUtils, object_helper, Properties, tr, Global, Element, DefaultPieProperties, PieSliceContainer;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            object_helper = module.import('', 'object_helper');
            Properties = module.import('', 'Properties');
            tr = module.import('', 'tr');
            Global = module.import('global', 'Global');
            Element = module.import('charts.series', 'Element');
            DefaultPieProperties = module.import('charts.series.pies', 'DefaultPieProperties');
            PieSliceContainer = module.import('charts.series.pies', 'PieSliceContainer');
          };

          var Pie = function(json) {
            this.labels = null;
            this.links = null;
            this.colours = null;
            this.easing = null;
            this.style = null;
            this.labels = [];
            this.links = [];
            this.colours = [];

            this.style = {
              this.colours: ["#900000", "#009000"] // slices colours
            }

            object_helper.merge_2(json, this.style);

            for each(var colour in this.style.colours)
            this.colours.push(string.Utils.get_colour(colour));

            //
            //
            //
            this.props = new DefaultPieProperties(json);
            //
            //
            //

            this.label_line = 10;

            this.values = json.values;
            this.add_values();
          };

          Pie.prototype = Object.create(Base.prototype);

          Pie.prototype.labels = null;
          Pie.prototype.links = null;
          Pie.prototype.colours = null;
          Pie.prototype.gradientFill = 'true';
          Pie.prototype.border_width = 1;
          Pie.prototype.label_line = 0;
          Pie.prototype.easing = null;
          Pie.prototype.style = null;
          Pie.prototype.total_value = 0;
          Pie.prototype.add_values = function() {
            //      this.Elements= [];

            //
            // Warning: this is our global singleton
            //
            var g = Global.getInstance();

            var total = 0;
            var slice_start = this.props.get('start-angle');
            var i;
            var val;

            for each(val in this.values) {
              if (val is Number)
                total += val;
              else
                total += val.value;
            }
            this.total_value = total;

            i = 0;
            for each(val in this.values) {

              var value = val is Number ? (Number ) val: val.value;
              var slice_angle = value * 360 / total;

              if (slice_angle >= 0) {

                var t = this.props.get('tip').replace('#total#', NumberUtils.formatNumber(this.total_value));
                t = t.replace('#percent#', NumberUtils.formatNumber(value / this.total_value * 100) + '%');

                this.addChild(
                  this.add_slice(
                    i,
                    slice_start,
                    slice_angle,
                    val, // <-- NOTE: val (object) NOT value (a number)
                    t,
                    this.colours[(i % this.colours.length)]
                  )
                );

                // TODO: fix this and remove
                // tmp.make_tooltip( this.key );
              }
              i++;
              slice_start += slice_angle;
            }
          };
          Pie.prototype.add_slice = function(index, start, angle, value, tip, colour) {

            // Properties chain:
            //   pie-slice -> calculated-stuff -> pie
            //
            // calculated-stuff:
            var calculated_stuff = new Properties({
                colour: colour, // <-- from the colour cycle array
                tip: tip, // <-- replaced the #total# & #percent# for this slice
                start: start, // <-- calculated
                angle: angle // <-- calculated
              },
              this.props);

            var tmp = {};
            if (value is Number)
              tmp.value = value;
            else
              tmp = value;

            var p = new Properties(tmp, calculated_stuff);

            // no user defined label?
            if (!p.has('label'))
              p.set('label', p.get('value').Pie.toString());

            // tr.aces( 'value', p.get('value'), p.get('label'), p.get('colour') );
            return new PieSliceContainer(index, p);
          };
          Pie.prototype.closest = function(x, y) {
            // PIE charts don't do closest to mouse tooltips
            return {
              Element: null,
              distance_x: 0,
              distance_y: 0
            };
          };
          Pie.prototype.resize = function(sc) {
            var radius = this.style.radius;
            if (isNaN(radius)) {
              radius = (Math.min(sc.width, sc.height) / 2.0);
              var offsets = {
                top: 0,
                right: 0,
                bottom: 0,
                left: 0
              };
              trace("sc.width, sc.height, radius", sc.width, sc.height, radius);

              var i;
              var sliceContainer;

              // loop to gather and merge offsets
              for (i = 0; i < this.numChildren; i++) {
                sliceContainer = (PieSliceContainer) this.getChildAt(i);
                var pie_offsets = sliceContainer.get_radius_offsets();
                for (var key in offsets) {
                  if (pie_offsets[key] > offsets[key]) {
                    offsets[key] = pie_offsets[key];
                  }
                }
              }
              var vRadius = radius;
              // Calculate minimum radius assuming the contraint is vertical
              // Shrink radius by the largest top/bottom offset
              vRadius -= Math.max(offsets.top, offsets.bottom);
              // check to see if the left/right labels will fit
              if ((vRadius + offsets.left) > (sc.width / 2)) {
                //radius -= radius + offsets.left - (sc.width / 2);
                vRadius = (sc.width / 2) - offsets.left;
              }
              if ((vRadius + offsets.right) > (sc.width / 2)) {
                //radius -= radius + offsets.right - (sc.width / 2);
                vRadius = (sc.width / 2) - offsets.right;
              }

              // Make sure the radius is at least 10
              radius = Math.max(vRadius, 10);
            }

            var rightTopTicAngle = 720;
            var rightTopTicIdx = -1;
            var rightBottomTicAngle = -720;
            var rightBottomTicIdx = -1;

            var leftTopTicAngle = 720;
            var leftTopTicIdx = -1;
            var leftBottomTicAngle = -720;
            var leftBottomTicIdx = -1;

            // loop and resize
            for (i = 0; i < this.numChildren; i++) {
              sliceContainer = (PieSliceContainer) this.getChildAt(i);
              sliceContainer.pie_resize(sc, radius);

              // While we are looping through the children, we determine which
              // labels are the starting points in each quadrant so that we
              // move the labels around to prevent overlaps
              var ticAngle = sliceContainer.getTicAngle();
              if (ticAngle >= 270) {
                // Right side - Top
                if ((ticAngle < rightTopTicAngle) || (rightTopTicAngle <= 90)) {
                  rightTopTicAngle = ticAngle;
                  rightTopTicIdx = i;
                }
                // Just in case no tics in Right-Bottom
                if ((rightBottomTicAngle < 0) ||
                  ((rightBottomTicAngle > 90) && (rightBottomTicAngle < ticAngle))) {
                  rightBottomTicAngle = ticAngle;
                  rightBottomTicIdx = i;
                }
              } else if (ticAngle <= 90) {
                // Right side - Bottom
                if ((ticAngle > rightBottomTicAngle) || (rightBottomTicAngle > 90)) {
                  rightBottomTicAngle = ticAngle;
                  rightBottomTicIdx = i;
                }
                // Just in case no tics in Right-Top
                if ((rightTopTicAngle > 360) ||
                  ((rightTopTicAngle <= 90) && (ticAngle < rightBottomTicAngle))) {
                  rightTopTicAngle = ticAngle;
                  rightTopTicIdx = i;
                }
              } else if (ticAngle <= 180) {
                // Left side - Bottom
                if ((leftBottomTicAngle < 0) || (ticAngle < leftBottomTicAngle)) {
                  leftBottomTicAngle = ticAngle;
                  leftBottomTicIdx = i;
                }
                // Just in case no tics in Left-Top
                if ((leftTopTicAngle > 360) || (leftTopTicAngle < ticAngle)) {
                  leftTopTicAngle = ticAngle;
                  leftTopTicIdx = i;
                }
              } else {
                // Left side - Top
                if ((leftTopTicAngle > 360) || (ticAngle > leftTopTicAngle)) {
                  leftTopTicAngle = ticAngle;
                  leftTopTicIdx = i;
                }
                // Just in case no tics in Left-Bottom
                if ((leftBottomTicAngle < 0) || (leftBottomTicAngle > ticAngle)) {
                  leftBottomTicAngle = ticAngle;
                  leftBottomTicIdx = i;
                }
              }
            }

            // Make a clockwise pass on right side of pie trying to move
            // the labels so that they do not overlap
            var childIdx = rightTopTicIdx;
            var yVal = sc.top;
            var bDone = false;
            while ((childIdx >= 0) && (!bDone)) {
              sliceContainer = (PieSliceContainer) this.getChildAt(childIdx);
              ticAngle = sliceContainer.getTicAngle();
              if ((ticAngle >= 270) || (ticAngle <= 90)) {
                yVal = sliceContainer.moveLabelDown(sc, yVal);

                childIdx++;
                if (childIdx >= this.numChildren) childIdx = 0;

                bDone = (childIdx == rightTopTicIdx);
              } else {
                bDone = true;
              }
            }

            // Make a counter-clockwise pass on right side of pie trying to move
            // the labels so that they do not overlap
            childIdx = rightBottomTicIdx;
            yVal = sc.bottom;
            bDone = false;
            while ((childIdx >= 0) && (!bDone)) {
              sliceContainer = (PieSliceContainer) this.getChildAt(childIdx);
              ticAngle = sliceContainer.getTicAngle();
              if ((ticAngle >= 270) || (ticAngle <= 90)) {
                yVal = sliceContainer.moveLabelUp(sc, yVal);

                childIdx--;
                if (childIdx < 0) childIdx = this.numChildren - 1;

                bDone = (childIdx == rightBottomTicIdx);
              } else {
                bDone = true;
              }
            }

            // Make a clockwise pass on left side of pie trying to move
            // the labels so that they do not overlap
            childIdx = leftBottomTicIdx;
            yVal = sc.bottom;
            bDone = false;
            while ((childIdx >= 0) && (!bDone)) {
              sliceContainer = (PieSliceContainer) this.getChildAt(childIdx);
              ticAngle = sliceContainer.getTicAngle();
              if ((ticAngle > 90) && (ticAngle < 270)) {
                yVal = sliceContainer.moveLabelUp(sc, yVal);

                childIdx++;
                if (childIdx >= this.numChildren) childIdx = 0;

                bDone = (childIdx == leftBottomTicIdx);
              } else {
                bDone = true;
              }
            }

            // Make a counter-clockwise pass on left side of pie trying to move
            // the labels so that they do not overlap
            childIdx = leftTopTicIdx;
            yVal = sc.top;
            bDone = false;
            while ((childIdx >= 0) && (!bDone)) {
              sliceContainer = (PieSliceContainer) this.getChildAt(childIdx);
              ticAngle = sliceContainer.getTicAngle();
              if ((ticAngle > 90) && (ticAngle < 270)) {
                yVal = sliceContainer.moveLabelDown(sc, yVal);

                childIdx--;
                if (childIdx < 0) childIdx = this.numChildren - 1;

                bDone = (childIdx == leftTopTicIdx);
              } else {
                bDone = true;
              }
            }
          };
          Pie.prototype.toString = function() {
            return "Pie with " + this.numChildren + " children";
          }

          module.exports = Pie;
        };
        Program["charts.Scatter"] = function(module, exports) {
          var ScatterBase = module.import('charts', 'ScatterBase');
          var object_helper, DefaultDotProperties;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            DefaultDotProperties = module.import('charts.series.dots', 'DefaultDotProperties');
          };

          var Scatter = function(json) {
            ScatterBase.call(this, json);

            this.style = {
              this.values: [],
                width: 2,
                this.colour: '#3030d0',
                text: '', // <-- default not display a key
                'font-size': 12,
                tip: '[#x#,#y#] #size#',
                axis: 'left'
            };

            // hack: keep this incase the merge kills it, we'll
            // remove the merge later (and this hack)
            var tmp = json['dot-style'];

            object_helper.merge_2(json, this.style);

            this.default_style = new DefaultDotProperties(
              json['dot-style'], this.style.colour, this.style.axis);

            //      this.line_width = style.width;
            this.colour = string.Utils.get_colour(this.style.colour);
            this.key = this.style.text;
            this.font_size = this.style['font-size'];
            //      this.circle_size = style['dot-size'];

            this.values = this.style.values;

            this.add_values();
          };

          Scatter.prototype = Object.create(ScatterBase.prototype);

          module.exports = Scatter;
        };
        Program["charts.ScatterBase"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var object_helper, Properties, Utils, Element, DefaultDotProperties, dot_factory;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Properties = module.import('', 'Properties');
            Utils = module.import('string', 'Utils');
            Element = module.import('charts.series', 'Element');
            DefaultDotProperties = module.import('charts.series.dots', 'DefaultDotProperties');
            dot_factory = module.import('charts.series.dots', 'dot_factory');
          };

          var ScatterBase = function(json) {
            this.style = null;
            this.on_show = null;
            this.dot_style = null;
            this.default_style = null;

            //
            // merge into Line.as and Base.as
            //
            var root = new Properties({
              this.colour: '#3030d0',
                text: '', // <-- default not display a key
                'font-size': 12,
                tip: '#val#',
                axis: 'left'
            });
            //
            this.props = new Properties(json, root);
            //
            this.dot_style = new DefaultDotProperties(json['dot-style'], this.props.get('colour'), this.props.get('axis'));
            //
            // LOOK for a scatter chart the default dot is NOT invisible!!
            //
            //  this.dot_style.set('type', 'solid-dot');
            //
            // LOOK default animation for scatter is explode, no cascade
            //
            var on_show_root = new Properties({
              type: "explode",
              cascade: 0,
              delay: 0.3
            });
            this.on_show = new Properties(json['on-show'], on_show_root);
            //this.on_show_start = true;
            //
            //
          };

          ScatterBase.prototype = Object.create(Base.prototype);

          ScatterBase.prototype.style = null;
          ScatterBase.prototype.on_show = null;
          ScatterBase.prototype.dot_style = null;
          ScatterBase.prototype.default_style = null;
          ScatterBase.prototype.get_element = function(index, value) {
            // we ignore the X value (index) passed to us,
            // the user has provided their own x value

            var default_style = {
              width: this.style.width, // stroke
              this.colour: this.style.colour,
              tip: this.style.tip,
              'dot-size': 10
            };

            // Apply dot style defined at the plot level
            object_helper.merge_2(this.style['dot-style'], default_style);
            // Apply attributes defined at the value level
            object_helper.merge_2(value, default_style);

            // our parent colour is a number, but
            // we may have our own colour:
            if (default_style.colour is String)
              default_style.colour = Utils.get_colour(default_style.colour);

            //var tmp = new Properties( value, this.default_style);
            var tmp = new Properties(value, this.dot_style);

            // attach the animation bits:
            tmp.set('on-show', this.on_show);

            return dot_factory.make(index, tmp);
          };
          ScatterBase.prototype.resize = function(sc) {

            var tmp;
            for (var i = 0; i < this.numChildren; i++) {
              tmp = (Sprite) this.getChildAt(i);

              //
              // filter out the line masks
              //
              if (tmp is Element) {
                var e = (Element) tmp;
                e.resize(sc);
              }
            }
          }

          module.exports = ScatterBase;
        };
        Program["charts.ScatterLine"] = function(module, exports) {
          var ScatterBase = module.import('charts', 'ScatterBase');
          var object_helper, Element, DefaultDotProperties;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Element = module.import('charts.series', 'Element');
            DefaultDotProperties = module.import('charts.series.dots', 'DefaultDotProperties');
            ScatterLine.STEP_HORIZONTAL = 1;
            ScatterLine.STEP_VERTICAL = 2;
          };

          var ScatterLine = function(json) {
            ScatterBase.call(this, json);
            //
            // so the mask child can punch a hole through the line
            //
            this.blendMode = BlendMode.LAYER;
            //

            this.style = {
              this.values: [],
                width: 2,
                this.colour: '#3030d0',
                text: '', // <-- default not display a key
                'font-size': 12,
                this.stepgraph: 0,
                axis: 'left'
            };

            // hack: keep this incase the merge kills it, we'll
            // remove the merge later (and this hack)
            var tmp = json['dot-style'];

            object_helper.merge_2(json, this.style);

            this.default_style = new DefaultDotProperties(
              json['dot-style'], this.style.colour, this.style.axis);

            this.style.colour = string.Utils.get_colour(this.style.colour);

            //  TODO: do we use this?
            //      this.line_width = style.width;
            this.colour = this.style.colour;
            this.key = this.style.text;
            this.font_size = this.style['font-size'];
            //this.circle_size = style['dot-size'];

            switch (this.style['stepgraph']) {
              case 'horizontal':
                this.stepgraph = ScatterLine.STEP_HORIZONTAL;
                break;
              case 'vertical':
                this.stepgraph = ScatterLine.STEP_VERTICAL;
                break;
            }

            this.values = this.style.values;
            this.add_values();
          };

          ScatterLine.prototype = Object.create(ScatterBase.prototype);

          ScatterLine.STEP_HORIZONTAL = 1;
          ScatterLine.STEP_VERTICAL = 2;

          ScatterLine.prototype.stepgraph = 0;
          ScatterLine.prototype.resize = function(sc) {

            // move the dots:
            ScatterBase.prototype.resize.call(this, sc);

            this.graphics.clear();
            this.graphics.lineStyle(this.style.width, this.style.colour);

            //if( this.style['line-style'].style != 'solid' )
            //  this.dash_line(sc);
            //else
            this.solid_line(sc);

          };
          ScatterLine.prototype.solid_line = function(sc) {

            var first = true;
            var last_x = 0;
            var last_y = 0;

            var areaClosed = true;
            var isArea = false;
            var areaBaseX = NaN;
            var areaBaseY = NaN;
            var areaColour = this.colour;
            var areaAlpha = 0.4;
            var areaStyle = this.style['area-style'];
            if (areaStyle != null) {
              isArea = true;
              if (areaStyle.x != null) {
                areaBaseX = areaStyle.x;
              }
              if (areaStyle.y != null) {
                areaBaseY = areaStyle.y;
              }
              if (areaStyle.colour != null) {
                areaColour = string.Utils.get_colour(areaStyle.colour);
              }
              if (areaStyle.alpha != null) {
                areaAlpha = areaStyle.alpha;
              }
              if (!isNaN(areaBaseX)) {
                // Convert X Value to screen position
                areaBaseX = sc.get_x_from_val(areaBaseX);
              }
              if (!isNaN(areaBaseY)) {
                // Convert Y Value to screen position
                areaBaseY = sc.get_y_from_val(areaBaseY); // TODO: Allow for right Y-Axis??
              }
            }

            for (var i = 0; i < this.numChildren; i++) {

              var tmp = (Sprite) this.getChildAt(i);

              //
              // filter out the line masks
              //
              if (tmp is Element) {
                var e = (Element) tmp;

                // tell the point where it is on the screen
                // we will use this info to place the tooltip
                e.resize(sc);
                if (!e.visible) {
                  // Creates a gap in the plot and closes out the current area if defined
                  if ((isArea) && (i > 0)) {
                    // draw an invisible line back to the base and close the fill
                    areaX = isNaN(areaBaseX) ? last_x : areaBaseX;
                    areaY = isNaN(areaBaseY) ? last_y : areaBaseY;
                    this.graphics.lineStyle(0, areaColour, 0);
                    this.graphics.lineTo(areaX, areaY);
                    this.graphics.endFill();
                    areaClosed = true;
                  }
                  first = true;
                } else if (first) {
                  if (isArea) {
                    // draw an invisible line from the base to the point
                    var areaX = isNaN(areaBaseX) ? e.x : areaBaseX;
                    var areaY = isNaN(areaBaseY) ? e.y : areaBaseY;
                    // Begin the fill for the area
                    this.graphics.beginFill(areaColour, areaAlpha);
                    this.graphics.lineStyle(0, areaColour, 0);
                    this.graphics.moveTo(areaX, areaY);
                    this.graphics.lineTo(e.x, e.y);
                    areaClosed = false;
                    // change the line style back to normal
                    this.graphics.lineStyle(this.style.width, this.style.colour, 1.0);
                  } else {
                    // just move to the point
                    this.graphics.moveTo(e.x, e.y);
                  }
                  first = false;
                } else {
                  if (this.stepgraph == ScatterLine.STEP_HORIZONTAL)
                    this.graphics.lineTo(e.x, last_y);
                  else if (this.stepgraph == ScatterLine.STEP_VERTICAL)
                    this.graphics.lineTo(last_x, e.y);

                  this.graphics.lineTo(e.x, e.y);
                }
                last_x = e.x;
                last_y = e.y;
              }
            }

            // Close out the area if defined
            if (isArea && !areaClosed) {
              // draw an invisible line back to the base and close the fill
              areaX = isNaN(areaBaseX) ? last_x : areaBaseX;
              areaY = isNaN(areaBaseY) ? last_y : areaBaseY;
              this.graphics.lineStyle(0, areaColour, 0);
              this.graphics.lineTo(areaX, areaY);
              this.graphics.endFill();
            }
          }

          module.exports = ScatterLine;
        };
        Program["charts.Shape"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var object_helper;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
          };

          var Shape = function(json) {
            this.style = null;
            this.style = {
              points: [],
              this.colour: '#808080',
              alpha: 0.5
            };

            object_helper.merge_2(json, this.style);

            this.style.colour = string.Utils.get_colour(this.style.colour);

            for each(var val in json.values)
            this.style.points.push(new flash.geom.Point(val.x, val.y));
          };

          Shape.prototype = Object.create(Base.prototype);

          Shape.prototype.style = null;
          Shape.prototype.resize = function(sc) {

            this.graphics.clear();
            //this.graphics.lineStyle( this.style.width, this.style.colour );
            this.graphics.lineStyle(0, 0, 0);
            this.graphics.beginFill(this.style.colour, this.style.alpha);

            var moved = false;

            for each(var p in this.style.points) {
              if (!moved)
                this.graphics.moveTo(sc.get_x_from_val(p.x), sc.get_y_from_val(p.y));
              else
                this.graphics.lineTo(sc.get_x_from_val(p.x), sc.get_y_from_val(p.y));

              moved = true;
            }

            this.graphics.endFill();
          }

          module.exports = Shape;
        };
        Program["charts.Tags"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var object_helper, Tag;
          module.inject = function() {
            object_helper = module.import('', 'object_helper');
            Tag = module.import('charts.series.tags', 'Tag');
          };

          var Tags = function(json) {
            this.style = null;
            this.style = {
              this.values: [],
                this.colour: '#000000',
                text: '[#x#, #y#]',
                'align-x': 'center', // center, left, right
                'align-y': 'above', // above, below, center
                'pad-x': 4,
                'pad-y': 4,
                font: 'Verdana',
                bold: false,
                'on-click': null,
                rotate: 0,
                'font-size': 12,
                border: false,
                underline: false,
                alpha: 1
            };

            object_helper.merge_2(json, this.style);

            for each(var v in this.style.values) {
              var tmp = this.make_tag(v);
              this.addChild(tmp);
            }
          };

          Tags.prototype = Object.create(Base.prototype);

          Tags.prototype.style = null;
          Tags.prototype.make_tag = function(json) {
            var tagStyle = {};
            object_helper.merge_2(this.style, tagStyle);
            object_helper.merge_2(json, tagStyle);
            tagStyle.colour = string.Utils.get_colour(tagStyle.colour);

            return new Tag(tagStyle);
          };
          Tags.prototype.resize = function(sc) {
            for (var i = 0; i < this.numChildren; i++) {
              var tag = (Tag) this.getChildAt(i);
              tag.resize(sc);
            }
          }

          module.exports = Tags;
        };
        Program["charts.Elements.PointBarFade"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var Properties, ScreenCoords;
          module.inject = function() {
            Properties = module.import('', 'Properties');
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var PointBarFade = function(index, value, colour, group) {
            var p = new Properties(value);
            Base.call(this, index, p, group);
            //Base.call(this, index,value,colour,'',0.6,group);
          };

          PointBarFade.prototype = Object.create(Base.prototype);

          PointBarFade.prototype.resize = function(sc) {
            /*
            var tmp = sc.get_bar_coords(this._x,this.group);
            this.screen_x = tmp.x;
            this.screen_y = sc.get_y_from_val(this._y,axis==2);
          
            var bar_bottom = sc.getYbottom( false );
          
            var top;
            var height;
          
            if( bar_bottom < this.screen_y ) {
              top = bar_bottom;
              height = this.screen_y-bar_bottom;
            }
            else
            {
              top = this.screen_y
              height = bar_bottom-this.screen_y;
            }
            */
            var h = this.resize_helper((ScreenCoords) sc);

            this.graphics.clear();
            this.graphics.beginFill(this.colour, 1.0);
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(h.width, 0);
            this.graphics.lineTo(h.width, h.height);
            this.graphics.lineTo(0, h.height);
            this.graphics.lineTo(0, 0);
            this.graphics.endFill();
          }

          module.exports = PointBarFade;
        };
        Program["charts.Elements.Star"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');

          var Star = function(index, style) {

            PointDotBase.call(this, index, style);

            this.visible = true;

            this.graphics.clear();
            this.graphics.lineStyle(style.width, style.colour, 1); // style.alpha );
            var rotation = isNaN(style['rotation']) ? 0 : style['rotation'];

            this.drawStar(this.graphics, style['dot-size'], rotation);

            var haloSize = style['halo-size'] + style['dot-size'];
            var s = new Sprite();
            s.graphics.lineStyle(0, 0, 0);
            s.graphics.beginFill(0, 1);
            this.drawStar(s.graphics, haloSize, rotation);
            s.blendMode = BlendMode.ERASE;
            s.graphics.endFill();
            this.line_mask = s;

            this.attach_events();

          };

          Star.prototype = Object.create(PointDotBase.prototype);

          Star.prototype.calcXOnCircle = function(radius, degrees) {
            return radius * Math.cos(degrees / 180 * Math.PI);
          };
          Star.prototype.calcYOnCircle = function(radius, degrees) {
            return radius * Math.sin(degrees / 180 * Math.PI);
          };
          Star.prototype.drawStar = function(graphics, radius, rotation) {
            var angle = 360 / 5;

            // Start at top point (unrotated)
            var degrees = -90 + rotation;
            for (var i = 0; i <= 5; i++) {
              var x = this.calcXOnCircle(radius, degrees);
              var y = this.calcYOnCircle(radius, degrees);

              if (i == 0)
                graphics.moveTo(x, y);
              else
                graphics.lineTo(x, y);

              // Move 2 points clockwise
              degrees += (2 * angle);
            }
          }

          module.exports = Star;
        };
        Program["charts.series.Element"] = function(module, exports) {
          var tr, Equations, Tweener;
          module.inject = function() {
            tr = module.import('', 'tr');
            Equations = module.import('caurina.transitions', 'Equations');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var Element = function() {
            this.line_mask = null;
            // elements don't change shape much, so lets
            // cache it
            this.cacheAsBitmap = true;
            this.right_axis = false;
          };

          Element.prototype = Object.create(Sprite.prototype);

          Element.prototype._x = 0;
          Element.prototype._y = 0;
          Element.prototype.index = 0;
          Element.prototype.tooltip = null;
          Element.prototype.link = null;
          Element.prototype.is_tip = false;
          Element.prototype.line_mask = null;
          Element.prototype.right_axis = false;
          Element.prototype.resize = function(sc) {

            var p = sc.get_get_x_from_pos_and_y_from_val(this._x, this._y, this.right_axis);
            this.x = p.x;
            this.y = p.y;
          };
          Element.prototype.get_mid_point = function() {

            //
            // dots have x, y in the center of the dot
            //
            return new flash.geom.Point(this.x, this.y);
          };
          Element.prototype.get_x = function() {
            return this._x;
          };
          Element.prototype.get_y = function() {
            return this._y;
          };
          Element.prototype.set_tip = function(b) {};
          Element.prototype.attach_events = function() {

            // weak references so the garbage collector will kill them:
            this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut, false, 0, true);
          };
          Element.prototype.mouseOver = function(event) {
            this.pulse();
          };
          Element.prototype.pulse = function() {
            // pulse:
            Tweener.addTween(this, {
              alpha: .5,
              time: 0.4,
              transition: "linear"
            });
            Tweener.addTween(this, {
              alpha: 1,
              time: 0.4,
              delay: 0.4,
              onComplete: this.pulse,
              transition: "linear"
            });
          };
          Element.prototype.mouseOut = function(event) {
            // stop the pulse, then fade in
            Tweener.removeTweens(this);
            Tweener.addTween(this, {
              alpha: 1,
              time: 0.4,
              transition: Equations.easeOutElastic
            });
          };
          Element.prototype.set_on_click = function(s) {
            this.link = s;
            this.buttonMode = true;
            this.useHandCursor = true;
            // weak references so the garbage collector will kill it:
            this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp, false, 0, true);
          };
          Element.prototype.mouseUp = function(event) {

            if (this.link.substring(0, 6) == 'trace:') {
              // for the test JSON files:
              tr.ace(this.link);
            } else if (this.link.substring(0, 5) == 'http:')
              this.browse_url(this.link);
            else if (this.link.substring(0, 6) == 'https:')
              this.browse_url(this.link);
            else {
              //
              // TODO: fix the on click to pass out the chart id:
              //
              // var ex = ExternalInterfaceManager.getInstance();
              // ex.callJavascript(this.link, this.index);
              ExternalInterface.call(this.link, this.index);
            }
          };
          Element.prototype.browse_url = function(url) {
            var req = new URLRequest(this.link);
            try {
              navigateToURL(req);
            } catch (e: Error) {
              trace("Error opening link: " + this.link);
            }
          };
          Element.prototype.get_tip_pos = function() {
            return {
              x: this.x,
              y: this.y
            };
          };
          Element.prototype.get_tooltip = function() {
            return this.tooltip;
          };
          Element.prototype.tooltip_replace_labels = function(labels) {

            tr.aces('x label', this._x, labels.get(this._x));
            this.tooltip = this.tooltip.replace('#x_label#', labels.get(this._x));
          };
          Element.prototype.die = function() {

            if (this.line_mask != null) {

              this.line_mask.graphics.clear();
              this.line_mask = null;
            }
          }

          module.exports = Element;
        };
        Program["charts.series.has_tooltip"] = function(module, exports) {
          var has_tooltip = function has_tooltip() {};

          has_tooltip.prototype.get_tooltip = function() {};
          has_tooltip.prototype.get_tip_pos = function() {};
          has_tooltip.prototype.set_tip = function(b) {}

          module.exports = has_tooltip;
        };
        Program["charts.series.bars.Bar3D"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords, Bar3D;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
            Bar3D = module.import('charts', 'Bar3D');
          };

          var Bar3D = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, style, style.colour, style.tip, style.alpha, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          Bar3D.prototype = Object.create(Base.prototype);

          Bar3D.Lighten = function(col) {
            var rgb = col; //decimal value for a purple color
            var red = (rgb & 16711680) >> 16; //extacts the red channel
            var green = (rgb & 65280) >> 8; //extacts the green channel
            var blue = rgb & 255; //extacts the blue channel
            var p = 2;
            red += red / p;
            if (red > 255)
              red = 255;

            green += green / p;
            if (green > 255)
              green = 255;

            blue += blue / p;
            if (blue > 255)
              blue = 255;

            return red << 16 | green << 8 | blue;
          };

          Bar3D.prototype.resize = function(sc) {

            var h = this.resize_helper((ScreenCoords) sc);

            this.graphics.clear();

            this.draw_top(h.width, h.height);
            this.draw_front(h.width, h.height);
            this.draw_side(h.width, h.height);
          };
          Bar3D.prototype.draw_top = function(w, h) {

            this.graphics.lineStyle(0, 0, 0);
            //set gradient fill

            var lighter = Bar3D.Lighten(this.colour);

            var colors = [this.colour, lighter];
            var alphas = [1, 1];
            var ratios = [0, 255];
            var matrix = new Matrix();
            matrix.createGradientBox(w + 12, 12, (270 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );

            var y = 0;
            if (h < 0)
              y = h;

            this.graphics.moveTo(0, y);
            this.graphics.lineTo(w, y);
            this.graphics.lineTo(w - 12, y + 12);
            this.graphics.lineTo(-12, y + 12);
            this.graphics.endFill();
          };
          Bar3D.prototype.draw_front = function(w, h) {
            //
            var rad = 7;

            var lighter = Bar3D.Lighten(this.colour);

            // Darken a light color
            //var darker = this.colour;
            //darker &= 0x7F7F7F;

            var colors = [lighter, this.colour];
            var alphas = [1, 1];
            var ratios = [0, 127];

            var matrix = new Matrix();
            matrix.createGradientBox(w - 12, h + 12, (90 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );

            this.graphics.moveTo(-12, 12);
            this.graphics.lineTo(-12, h + 12);
            this.graphics.lineTo(w - 12, h + 12);
            this.graphics.lineTo(w - 12, 12);
            this.graphics.endFill();
          };
          Bar3D.prototype.draw_side = function(w, h) {
            //
            var rad = 7;

            var lighter = Bar3D.Lighten(this.colour);

            var colors = [this.colour, lighter];
            var alphas = [1, 1];
            var ratios = [0, 255];
            var matrix = new Matrix();
            matrix.createGradientBox(w, h + 12, (270 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );

            this.graphics.lineStyle(0, 0, 0);
            this.graphics.moveTo(w, 0);
            this.graphics.lineTo(w, h);
            this.graphics.lineTo(w - 12, h + 12);
            this.graphics.lineTo(w - 12, 12);
            this.graphics.endFill();
          }

          module.exports = Bar3D;
        };
        Program["charts.series.bars.Bar"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Bar = function(index, props, group) {

            Base.call(this, index, props, group);
          };

          Bar.prototype = Object.create(Base.prototype);

          Bar.prototype.resize = function(sc) {

            var h = this.resize_helper((ScreenCoords) sc);

            this.graphics.clear();
            this.graphics.beginFill(this.colour, 1.0);
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(h.width, 0);
            this.graphics.lineTo(h.width, h.height);
            this.graphics.lineTo(0, h.height);
            this.graphics.lineTo(0, 0);
            this.graphics.endFill();
          }

          module.exports = Bar;
        };
        Program["charts.series.bars.Base"] = function(module, exports) {
          var Element = module.import('charts.series', 'Element');
          var NumberUtils, Equations, Tweener;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            Equations = module.import('caurina.transitions', 'Equations');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var Base = function(index, props, group) {
            this.tip_pos = null;
            this.on_show = null;
            Element.call(this);
            this.index = index;
            this.parse_value(props);
            this.colour = props.get_colour('colour');

            this.tooltip = this.replace_magic_values(props.get('tip'));

            this.group = group;
            this.visible = true;
            this.on_show_animate = true;
            this.on_show = props.get('on-show');

            // remember what our original alpha is:
            this.mouse_out_alpha = props.get('alpha');
            // set the sprit alpha:
            this.alpha = this.mouse_out_alpha;

            this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);

            //
            // This is UGLY!!! We need to decide if we are passing in a SINGLE style object,
            // or many parameters....
            //
            if (props.has('on-click')) // <-- may be null/not set
              if (props.get('on-click') != false) // <-- may be FALSE
                this.set_on_click(props.get('on-click'));

            if (props.has('axis'))
              if (props.get('axis') == 'right')
                this.right_axis = true;
          };

          Base.prototype = Object.create(Element.prototype);

          Base.prototype.tip_pos = null;
          Base.prototype.colour = 0;
          Base.prototype.group = 0;
          Base.prototype.top = 0;
          Base.prototype.bottom = 0;
          Base.prototype.mouse_out_alpha = 0;
          Base.prototype.on_show_animate = false;
          Base.prototype.on_show = null;
          Base.prototype.parse_value = function(props) {

            if (!props.has('bottom')) {
              // align to Y min OR zero
              props.set('bottom', Number.MIN_VALUE);
            }

            this.top = props.get('top');
            this.bottom = props.get('bottom');
          };
          Base.prototype.replace_magic_values = function(t) {

            t = t.replace('#top#', NumberUtils.formatNumber(this.top));
            t = t.replace('#bottom#', NumberUtils.formatNumber(this.bottom));
            t = t.replace('#val#', NumberUtils.formatNumber(this.top - this.bottom));

            return t;
          };
          Base.prototype.get_mid_point = function() {

            //
            // bars mid point
            //
            return new flash.geom.Point(this.x + (this.width / 2), this.y);
          };
          Base.prototype.mouseOver = function(event) {
            this.is_tip = true;
            Tweener.addTween(this, {
              alpha: 1,
              time: 0.6,
              transition: Equations.easeOutCirc
            });
          };
          Base.prototype.mouseOut = function(event) {
            this.is_tip = false;
            Tweener.addTween(this, {
              alpha: this.mouse_out_alpha,
              time: 0.8,
              transition: Equations.easeOutElastic
            });
          };
          Base.prototype.resize = function(sc) {};
          Base.prototype.get_tip_pos = function() {
            return {
              x: this.tip_pos.x,
              y: this.tip_pos.y
            };
          };
          Base.prototype.resize_helper = function(sc) {
            var tmp = sc.get_bar_coords(this.index, this.group);

            var bar_top = sc.get_y_from_val(this.top, this.right_axis);
            var bar_bottom;

            if (this.bottom == Number.MIN_VALUE)
              bar_bottom = sc.get_y_bottom(this.right_axis);
            else
              bar_bottom = sc.get_y_from_val(this.bottom, this.right_axis);

            var top;
            var height;
            var upside_down = false;

            if (bar_bottom < bar_top) {
              top = bar_bottom;
              upside_down = true;
            } else {
              top = bar_top;
            }

            height = Math.abs(bar_bottom - bar_top);

            //
            // tell the tooltip where to show its self
            //
            this.tip_pos = new flash.geom.Point(tmp.x + (tmp.width / 2), top);

            if (this.on_show_animate)
              this.first_show(tmp.x, top, tmp.width, height);
            else {
              //
              // move the Sprite to the correct screen location:
              //
              this.y = top;
              this.x = tmp.x;
            }

            //
            // return the bounds to draw the item:
            //
            return {
              width: tmp.width,
              top: top,
              height: height,
              upside_down: upside_down
            };
          };
          Base.prototype.first_show = function(x, y, width, height) {

            this.on_show_animate = false;
            Tweener.removeTweens(this);

            // tr.aces('base.as', this.on_show.get('type') );
            var d = x / this.stage.stageWidth;
            d *= this.on_show.get('cascade');
            d += this.on_show.get('delay');

            switch (this.on_show.get('type')) {

              case 'pop-up':
                this.x = x;
                this.y = this.stage.stageHeight + this.height + 3;
                Tweener.addTween(this, {
                  y: y,
                  time: 1,
                  delay: d,
                  transition: Equations.easeOutBounce
                });
                break;

              case 'drop':
                this.x = x;
                this.y = -height - 10;
                Tweener.addTween(this, {
                  y: y,
                  time: 1,
                  delay: d,
                  transition: Equations.easeOutBounce
                });
                break;

              case 'fade-in':
                this.x = x;
                this.y = y;
                this.alpha = 0;
                Tweener.addTween(this, {
                  alpha: this.mouse_out_alpha,
                  time: 1.2,
                  delay: d,
                  transition: Equations.easeOutQuad
                });
                break;

              case 'grow-down':
                this.x = x;
                this.y = y;
                this.scaleY = 0.01;
                Tweener.addTween(this, {
                  scaleY: 1,
                  time: 1.2,
                  delay: d,
                  transition: Equations.easeOutQuad
                });
                break;

              case 'grow-up':
                this.x = x;
                this.y = y + height;
                this.scaleY = 0.01;
                Tweener.addTween(this, {
                  scaleY: 1,
                  time: 1.2,
                  delay: d,
                  transition: Equations.easeOutQuad
                });
                Tweener.addTween(this, {
                  y: y,
                  time: 1.2,
                  delay: d,
                  transition: Equations.easeOutQuad
                });
                break;

              case 'pop':
                this.y = this.top;
                this.alpha = 0.2;
                Tweener.addTween(this, {
                  alpha: this.mouse_out_alpha,
                  time: 0.7,
                  delay: d,
                  transition: Equations.easeOutQuad
                });

                // shrink the bar to 3x3 px
                this.x = x + (width / 2);
                this.y = y + (height / 2);
                this.width = 3;
                this.height = 3;

                Tweener.addTween(this, {
                  x: x,
                  y: y,
                  width: width,
                  height: height,
                  time: 1.2,
                  delay: d,
                  transition: Equations.easeOutElastic
                });
                break;

              default:
                this.y = y;
                this.x = x;

            }
          }

          module.exports = Base;
        };
        Program["charts.series.bars.Cylinder"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Cylinder = function(index, props, group) {

            Base.call(this, index, props, group);
            // MASSIVE HACK:
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

            //Base.call(this, index, style, style.colour, style.tip, style.alpha, group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          Cylinder.prototype = Object.create(Base.prototype);

          Cylinder.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 2; /* shift factor */
            var basecolor = col; /* base color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter */
            if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255) {
              bgred = red - red / shift;
              bggreen = green - green / shift;
              bgblue = blue - blue / shift;
            }

            /* set highlight components based on base colors */
            hired = bgred + red / shift;
            hiblue = bgblue + blue / shift;
            higreen = bggreen + green / shift;

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;

            /* return base and highlight */
            return [highlight, basecolor];
          };
          Cylinder.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          Cylinder.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          Cylinder.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          Cylinder.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var bgcolors = Cylinder.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            /* draw bottom half ellipse */
            x = w / 2;
            y = h;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.halfEllipse(x, y, xRadius, yRadius, 100);

            /* draw connecting rectangle */
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(0, h);
            this.graphics.lineTo(w, h);
            this.graphics.lineTo(w, 0);

            /* draw top ellipse */
            this.graphics.beginFill(this.colour, 1);
            x = w / 2;
            y = 0;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.Ellipse(x, y, xRadius, yRadius, 100);

            this.graphics.endFill();
          };
          Cylinder.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            //set gradient fill
            var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.5];
            var ratios = [150, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            /* draw bottom half ellipse shine */
            x = w / 2;
            y = h;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.halfEllipse(x, y, xRadius, yRadius, 100);

            /*draw connecting rectangle shine */
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(0, h);
            this.graphics.lineTo(w, h);
            this.graphics.lineTo(w, 0);

            /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
            this.graphics.beginFill(this.colour, 1);
            x = w / 2;
            y = 0;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.Ellipse(x, y, xRadius, yRadius, 100);

            /* draw top ellipse shine */
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, [25, 255], matrix, 'pad' /*SpreadMethod.PAD*/ );
            x = w / 2;
            y = 0;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.Ellipse(x, y, xRadius, yRadius, 100);

            this.graphics.endFill();
          };
          Cylinder.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = Cylinder.magicTrigFunctionX(pointRatio);
              var ySteps = Cylinder.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          };
          Cylinder.prototype.halfEllipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides / 2; i++) {
              var pointRatio = i / sides;
              var xSteps = Cylinder.magicTrigFunctionX(pointRatio);
              var ySteps = Cylinder.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = Cylinder;
        };
        Program["charts.series.bars.CylinderOutline"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var CylinderOutline = function(index, props, group) {

            Base.call(this, index, props, group);
            //// MASSIVE HACK:
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

            //             Base.call(this, index, style, style.colour, style.tip, style.alpha, group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          CylinderOutline.prototype = Object.create(Base.prototype);

          CylinderOutline.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 2; /* shift factor */
            var basecolor = col; /* base color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter */
            if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255) {
              bgred = red - red / shift;
              bggreen = green - green / shift;
              bgblue = blue - blue / shift;
            }

            /* set highlight components based on base colors */
            hired = bgred + red / shift;
            hiblue = bgblue + blue / shift;
            higreen = bggreen + green / shift;

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;

            /* return base and highlight */
            return [highlight, basecolor];
          };
          CylinderOutline.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          CylinderOutline.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          CylinderOutline.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          CylinderOutline.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var bgcolors = CylinderOutline.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            /* draw bottom half ellipse */
            x = w / 2;
            y = h;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.halfEllipse(x, y, xRadius, yRadius, 100, false);

            /* draw connecting rectangle */
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(0, h);
            this.graphics.lineTo(w, h);
            this.graphics.lineTo(w, 0);

            /* draw top ellipse */
            //this.graphics.beginFill(this.colour, 1);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
            x = w / 2;
            y = 0;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.Ellipse(x, y, xRadius, yRadius, 100);

            this.graphics.endFill();
          };
          CylinderOutline.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            //set gradient fill
            var bgcolors = CylinderOutline.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.5];
            var ratios = [150, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            /* draw bottom half ellipse shine */
            x = w / 2;
            y = h;
            xRadius = w / 2 - (0.025 * w);
            yRadius = rad / 2 - (0.025 * w);
            this.halfEllipse(x, y, xRadius, yRadius, 100, false);

            /*draw connecting rectangle shine */
            this.graphics.moveTo(0 + (0.025 * w), 0 + (0.025 * w));
            this.graphics.lineTo(0 + (0.025 * w), h);
            this.graphics.lineTo(w - (0.025 * w), h);
            this.graphics.lineTo(w - (0.025 * w), 0 + (0.025 * w));

            /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
            //this.graphics.beginFill(this.colour, 1);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
            x = w / 2;
            y = 0;
            xRadius = w / 2;
            yRadius = rad / 2;
            this.Ellipse(x, y, xRadius, yRadius, 100);

            /* draw top ellipse shine */
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, [25, 255], matrix, 'pad' /*SpreadMethod.PAD*/ );
            x = w / 2;
            y = 0;
            xRadius = w / 2 - (0.025 * w);
            yRadius = rad / 2 - (0.025 * w);
            this.Ellipse(x, y, xRadius, yRadius, 100);

            this.graphics.endFill();
          };
          CylinderOutline.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = CylinderOutline.magicTrigFunctionX(pointRatio);
              var ySteps = CylinderOutline.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          };
          CylinderOutline.prototype.halfEllipse = function(centerX, centerY, xRadius, yRadius, sides, top) {

            var loopStart;
            var loopEnd;

            if (top == true) {
              loopStart = sides / 2;
              loopEnd = sides;
            } else {
              loopStart = 0;
              loopEnd = sides / 2;
            }

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = loopStart; i <= loopEnd; i++) {
              var pointRatio = i / sides;
              var xSteps = CylinderOutline.magicTrigFunctionX(pointRatio);
              var ySteps = CylinderOutline.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = CylinderOutline;
        };
        Program["charts.series.bars.Dome"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Dome = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
            //Base.call(this, index, style, style.colour, style.tip, style.alpha, group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          Dome.prototype = Object.create(Base.prototype);

          Dome.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 2; /* shift factor */
            var basecolor = col; /* base color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter */
            if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255) {
              bgred = red - red / shift;
              bggreen = green - green / shift;
              bgblue = blue - blue / shift;
            }

            /* set highlight components based on base colors */
            hired = bgred + red / shift;
            hiblue = bgblue + blue / shift;
            higreen = bggreen + green / shift;

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;

            /* return base and highlight */
            return [highlight, basecolor];
          };
          Dome.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          Dome.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          Dome.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          Dome.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var bgcolors = Dome.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            if (!upside_down && h > 0) { /* draw bar upward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw bottom half ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = rad / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, w / 2);
                this.graphics.lineTo(0, h);
                this.graphics.lineTo(w, h);
                this.graphics.lineTo(w, w / 2);

                /* draw top ellipse */
                //this.graphics.beginFill(this.colour, 1);
                x = w / 2;
                y = w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is too short for normal draw */

                /* draw bottom half ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = rad / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw top ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = h;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              }
            } else

            { /*draw bar downward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw top half ellipse */
                x = w / 2;
                y = 0;
                xRadius = w / 2;
                yRadius = rad / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, 0);
                this.graphics.lineTo(0, h - w / 2);
                this.graphics.lineTo(w, h - w / 2);
                this.graphics.lineTo(w, 0);

                /* draw bottom ellipse */
                //this.graphics.beginFill(this.colour, 1);
                x = w / 2;
                y = h - w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

              } else

              { /* bar is too short for normal draw */

                if (h > 0)

                { /* bar greater than zero */

                  /* draw top half ellipse */
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2;
                  yRadius = rad / 2;
                  this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                  /* draw bottom ellipse */
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2;
                  yRadius = h;
                  this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                } else

                { /* bar is zero */

                  /* draw top ellipse */
                  x = w / 2;
                  y = h;
                  xRadius = w / 2;
                  yRadius = rad / 4;
                  this.Ellipse(x, y, xRadius, yRadius, 100);

                }

              }

            }

            this.graphics.endFill();
          };
          Dome.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            var bgcolors = Dome.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);

            /* set gradient fill */
            var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.75];
            var ratios = [100, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            if (!upside_down && h > 0) { /* draw shine upward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw bottom half ellipse shine */
                x = w / 2;
                y = h;
                xRadius = w / 2 - (0.05 * w);
                yRadius = rad / 2 - (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.05 * w), w / 2);
                this.graphics.lineTo(0 + (0.05 * w), h);
                this.graphics.lineTo(w - (0.05 * w), h);
                this.graphics.lineTo(w - (0.05 * w), w / 2);

                /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is not tall enough for normal draw */

                /* draw bottom half ellipse shine */
                x = w / 2;
                y = h;
                xRadius = w / 2 - (0.05 * w);
                yRadius = rad / 2 - (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h;
                xRadius = w / 3 - (0.05 * w);
                yRadius = h - 2.5 * (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              }

            } else

            { /* draw shine downward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw top half ellipse shine */
                x = w / 2;
                y = 0;
                xRadius = w / 2 - (0.05 * w);
                yRadius = rad / 2 - (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.05 * w), 0);
                this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), 0);

                /* redraw bottom ellipse (to overwrite connecting rectangle shine overlap)*/
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = h - w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw bottom ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h - w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

              } else

              { /* bar is not tall enough for normal draw */

                if (h > 0) { /* bar is greater than zero */

                  /* draw top half ellipse shine */
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2 - (0.05 * w);
                  yRadius = rad / 2 - (0.05 * w);
                  this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                  /* draw bottom ellipse shine */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                  x = w / 3;
                  y = 0;
                  xRadius = w / 3 - (0.05 * w);
                  yRadius = h - 2.5 * (0.05 * w);
                  this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                } else

                { /* bar is zero */

                  /* draw top ellipse shine */
                  x = w / 2;
                  y = h;
                  xRadius = w / 2 - (0.05 * w);
                  yRadius = rad / 4 - (0.05 * w);
                  this.Ellipse(x, y, xRadius, yRadius, 100);

                }

              }

            }

            this.graphics.endFill();
          };
          Dome.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = Dome.magicTrigFunctionX(pointRatio);
              var ySteps = Dome.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          };
          Dome.prototype.halfEllipse = function(centerX, centerY, xRadius, yRadius, sides, top) {

            var loopStart;
            var loopEnd;

            if (top == true) {
              loopStart = sides / 2;
              loopEnd = sides;
            } else {
              loopStart = 0;
              loopEnd = sides / 2;
            }

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = loopStart; i <= loopEnd; i++) {
              var pointRatio = i / sides;
              var xSteps = Dome.magicTrigFunctionX(pointRatio);
              var ySteps = Dome.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = Dome;
        };
        Program["charts.series.bars.ECandle"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var NumberUtils, ScreenCoords, tr;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            ScreenCoords = module.import('', 'ScreenCoords');
            tr = module.import('', 'tr');
          };

          var ECandle = function(index, props, group) {

            Base.call(this, index, props, group);

            tr.aces(props.has('negative-colour'), props.get_colour('negative-colour'));

            if (props.has('negative-colour'))
              this.negative_colour = props.get_colour('negative-colour');
            else
              this.negative_colour = this.colour;
          };

          ECandle.prototype = Object.create(Base.prototype);

          ECandle.prototype.high = 0;
          ECandle.prototype.low = 0;
          ECandle.prototype.negative_colour = 0;
          ECandle.prototype.parse_value = function(props) {

            // set top (open) and bottom (close)
            Base.prototype.parse_value.call(this, props);
            this.high = props.get('high');
            this.low = props.get('low');
          };
          ECandle.prototype.replace_magic_values = function(t) {

            t = Base.prototype.replace_magic_values.call(this, t);
            t = t.replace('#high#', NumberUtils.formatNumber(this.high));
            t = t.replace('#open#', NumberUtils.formatNumber(this.top));
            t = t.replace('#close#', NumberUtils.formatNumber(this.bottom));
            t = t.replace('#low#', NumberUtils.formatNumber(this.low));

            return t;
          };
          ECandle.prototype.resize = function(sc) {

            // this moves everyting relative to the box (NOT the whiskers)
            var h = this.resize_helper((ScreenCoords) sc);

            // 
            //var bar_high = 0;
            //var bar_low = height;

            // calculate the box position:
            var tmp = sc.get_y_from_val(Math.max(this.top, this.bottom), this.right_axis);
            var bar_high = sc.get_y_from_val(this.high, this.right_axis) - tmp;
            var bar_top = 0;
            var bar_bottom = sc.get_y_from_val(this.bottom, this.right_axis) - tmp;
            var bar_low = sc.get_y_from_val(this.low, this.right_axis) - tmp;

            //var height = Math.abs( bar_bottom - bar_top );

            //
            // move the Sprite to the correct screen location:
            //
            //this.y = bar_high;
            //this.x = tmp.x;

            //
            // tell the tooltip where to show its self
            //
            this.tip_pos = new flash.geom.Point(this.x + (h.width / 2), this.y);

            var mid = h.width / 2;
            this.graphics.clear();
            var c = this.colour;
            if (h.upside_down)
              c = this.negative_colour;

            this.top_line(c, mid, bar_high);

            if (this.top == this.bottom)
              this.draw_doji(c, h.width, bar_top);
            else
              this.draw_box(c, bar_top, h.height, h.width, h.upside_down);

            this.bottom_line(c, mid, h.height, bar_low);
            // top line

            //
            // tell the tooltip where to show its self
            //
            this.tip_pos = new flash.geom.Point(
              this.x + (h.width / 2),
              this.y + bar_high);
          };
          ECandle.prototype.top_line = function(colour, mid, height) {
            // top line
            this.graphics.beginFill(colour, 1.0);
            this.graphics.moveTo(mid - 1, 0);
            this.graphics.lineTo(mid + 1, 0);
            this.graphics.lineTo(mid + 1, height);
            this.graphics.lineTo(mid - 1, height);
            this.graphics.endFill();
          };
          ECandle.prototype.bottom_line = function(colour, mid, top, bottom) {
            this.graphics.beginFill(colour, 1.0);
            this.graphics.moveTo(mid - 1, top);
            this.graphics.lineTo(mid + 1, top);
            this.graphics.lineTo(mid + 1, bottom);
            this.graphics.lineTo(mid - 1, bottom);
            this.graphics.endFill();
          };
          ECandle.prototype.draw_doji = function(colour, width, pos) {
            // box
            this.graphics.beginFill(colour, 1.0);
            this.graphics.moveTo(0, pos - 1);
            this.graphics.lineTo(width, pos - 1);
            this.graphics.lineTo(width, pos + 1);
            this.graphics.lineTo(0, pos + 1);
            this.graphics.endFill();
          };
          ECandle.prototype.draw_box = function(colour, top, bottom, width, upside_down) {

            // box
            this.graphics.beginFill(colour, 1.0);
            this.graphics.moveTo(0, top);
            this.graphics.lineTo(width, top);
            this.graphics.lineTo(width, bottom);
            this.graphics.lineTo(0, bottom);
            this.graphics.lineTo(0, top);

            if (upside_down) {
              // snip out the middle of the box:
              this.graphics.moveTo(2, top + 2);
              this.graphics.lineTo(width - 2, top + 2);
              this.graphics.lineTo(width - 2, bottom - 2);
              this.graphics.lineTo(2, bottom - 2);
              this.graphics.lineTo(2, top + 2);
            }
            this.graphics.endFill();

            if (upside_down) {

              //
              // HACK: we fill an invisible rect over
              //       the hollow rect so the mouse over
              //       event fires correctly (even when the
              //       mouse is in the hollow part)
              //
              this.graphics.lineStyle(0, 0, 0);
              this.graphics.beginFill(0, 0);
              this.graphics.moveTo(2, top - 2);
              this.graphics.lineTo(width - 2, top - 2);
              this.graphics.lineTo(width - 2, bottom - 2);
              this.graphics.lineTo(2, bottom - 2);
              this.graphics.endFill();
            }
          }

          module.exports = ECandle;
        };
        Program["charts.series.bars.Glass"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Glass = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
            //Base.call(this, index, style, style.colour, style.tip, style.alpha, group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          Glass.prototype = Object.create(Base.prototype);

          Glass.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);
            if (h.height == 0)
              return;

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          Glass.prototype.bg = function(w, h, upside_down) {
            //
            var rad = 7;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);
            this.graphics.beginFill(this.colour, 1);

            if (!upside_down) {
              // bar goes up
              this.graphics.moveTo(0 + rad, 0);
              this.graphics.lineTo(w - rad, 0);
              this.graphics.curveTo(w, 0, w, rad);
              this.graphics.lineTo(w, h);
              this.graphics.lineTo(0, h);
              this.graphics.lineTo(0, 0 + rad);
              this.graphics.curveTo(0, 0, 0 + rad, 0);
            } else {
              // bar goes down
              this.graphics.moveTo(0, 0);
              this.graphics.lineTo(w, 0);
              this.graphics.lineTo(w, h - rad);
              this.graphics.curveTo(w, h, w - rad, h);
              this.graphics.lineTo(rad, h);
              this.graphics.curveTo(0, h, 0, h - rad);
              this.graphics.lineTo(0, 0);
            }
            this.graphics.endFill();
          };
          Glass.prototype.glass = function(w, h, upside_down) {
            var x = 2;
            var y = x;
            var width = (w / 2) - x;

            if (upside_down)
              y -= x;

            h -= x;

            this.graphics.lineStyle(0, 0, 0);
            //set gradient fill
            var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0.3, 0.7];
            var ratios = [0, 255];
            //var matrix = { matrixType:"box", x:x, y:y, w:width, h:height, r:(180/180)*Math.PI };
            //mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
            var matrix = new Matrix();
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );

            var rad = 4;
            var w = width;

            if (!upside_down) {
              this.graphics.moveTo(x + rad, y); // <-- top
              this.graphics.lineTo(x + w, y);
              this.graphics.lineTo(x + w, y + h);
              this.graphics.lineTo(x, y + h);
              this.graphics.lineTo(x, y + rad);
              this.graphics.curveTo(x, y, x + rad, y);
            } else {
              this.graphics.moveTo(x, y);
              this.graphics.lineTo(x + w, y);
              this.graphics.lineTo(x + w, y + h);
              this.graphics.lineTo(x + rad, y + h);
              this.graphics.curveTo(x, y + h, x, y + h - rad);
            }
            this.graphics.endFill();
          }

          module.exports = Glass;
        };
        Program["charts.series.bars.Horizontal"] = function(module, exports) {
          var Element = module.import('charts.series', 'Element');
          var NumberUtils, ScreenCoords, Equations, Tweener;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            ScreenCoords = module.import('', 'ScreenCoords');
            Equations = module.import('caurina.transitions', 'Equations');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var Horizontal = function(index, style, group) {
            Element.call(this);
            //
            // we use the index of this bar to find its Y position
            //
            this.index = index;
            //
            // horizontal bar: value = X Axis position
            // we'll use the ScreenCoords object to go [value -> x location]
            //

            this.left = style.left ? style.left : 0;
            this.right = style.right ? style.right : 0;

            this.colour = style.colour;
            this.group = group;
            this.visible = true;

            this.alpha = 0.5;

            this.tooltip = this.replace_magic_values(style.tip);

            this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut);

          };

          Horizontal.prototype = Object.create(Element.prototype);

          Horizontal.prototype.right = 0;
          Horizontal.prototype.left = 0;
          Horizontal.prototype.colour = 0;
          Horizontal.prototype.group = 0;
          Horizontal.prototype.replace_magic_values = function(t) {

            t = t.replace('#right#', NumberUtils.formatNumber(this.right));
            t = t.replace('#left#', NumberUtils.formatNumber(this.left));
            t = t.replace('#val#', NumberUtils.formatNumber(this.right - this.left));

            return t;
          };
          Horizontal.prototype.mouseOver = function(event) {
            Tweener.addTween(this, {
              alpha: 1,
              time: 0.6,
              transition: Equations.easeOutCirc
            });
          };
          Horizontal.prototype.mouseOut = function(event) {
            Tweener.addTween(this, {
              alpha: 0.5,
              time: 0.8,
              transition: Equations.easeOutElastic
            });
          };
          Horizontal.prototype.resize = function(sc) {

            // is it OK to cast up like this?
            var sc2 = (ScreenCoords) sc;

            var tmp = sc2.get_horiz_bar_coords(this.index, this.group);

            var left = sc.get_x_from_val(this.left);
            var right = sc.get_x_from_val(this.right);
            var width = right - left;

            this.graphics.clear();
            this.graphics.beginFill(this.colour, 1.0);
            this.graphics.drawRect(0, 0, width, tmp.width);
            this.graphics.endFill();

            this.x = left;
            this.y = tmp.y;
          };
          Horizontal.prototype.get_mid_point = function() {

            //
            // bars mid point
            //
            return new flash.geom.Point(this.x + (this.width / 2), this.y);
          };
          Horizontal.prototype.get_tip_pos = function() {
            //
            // Hover the tip over the right of the bar
            //
            return {
              x: this.x + this.width - 20,
              y: this.y
            };
          };
          Horizontal.prototype.get_max_x = function() {
            return this.right;
          }

          module.exports = Horizontal;
        };
        Program["charts.series.bars.Outline"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Outline = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
            this.outline = props.get_colour('outline-colour');
          };

          Outline.prototype = Object.create(Base.prototype);

          Outline.prototype.outline = 0;
          Outline.prototype.resize = function(sc) {

            var h = this.resize_helper((ScreenCoords) sc);

            this.graphics.clear();
            this.graphics.lineStyle(1, this.outline, 1);
            this.graphics.beginFill(this.colour, 1.0);
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(h.width, 0);
            this.graphics.lineTo(h.width, h.height);
            this.graphics.lineTo(0, h.height);
            this.graphics.lineTo(0, 0);
            this.graphics.endFill();

          }

          module.exports = Outline;
        };
        Program["charts.series.bars.Plastic"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Plastic = function(index, props, group) {

            Base.call(this, index, props, group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          Plastic.prototype = Object.create(Base.prototype);

          Plastic.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 0.15; /* shift factor */
            var loshift = 1.75; /* lowlight shift factor */
            var basecolor = col; /* base color to be returned */
            var lowlight = col; /* lowlight color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var lored = (rgb & 16711680) >> 16; /* red channel for lowlight */
            var logreen = (rgb & 65280) >> 8; /* green channel for lowlight */
            var loblue = rgb & 255; /* blue channel for lowlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter and darker */
            if (red + red * shift < 255 && red - loshift * red * shift > 0) { /* red can be shifted both lighter and darker */
              bgred = red;
            } else { /* red can be shifter either lighter or darker */
              if (red + red * shift < 255) { /* red can be shifter lighter */
                bgred = red + red / shift;
              } else { /* red can be shifted darker */
                bgred = red - loshift * red * shift;
              }
            }

            if (blue + blue * shift < 255 && blue - loshift * blue * shift > 0) { /* blue can be shifted both lighter and darker */
              bgblue = blue;
            } else { /* blue can be shifter either lighter or darker */
              if (blue + blue * shift < 255) { /* blue can be shifter lighter */
                bgblue = blue + blue * shift;
              } else { /* blue can be shifted darker */
                bgblue = blue - loshift * blue * shift;
              }
            }

            if (green + green * shift < 255 && green - loshift * green * shift > 0) { /* green can be shifted both lighter and darker */
              bggreen = green;
            } else { /* green can be shifted either lighter or darker */
              if (green + green * shift < 255) { /* green can be shifter lighter */
                bggreen = green + green * shift;
              } else { /* green can be shifted darker */
                bggreen = green - loshift * green * shift;
              }
            }

            /* set highlight and lowlight components based on base colors */
            hired = bgred + red * shift;
            lored = bgred - loshift * (red * shift);
            hiblue = bgblue + blue * shift;
            loblue = bgblue - loshift * (blue * shift);
            higreen = bggreen + green * shift;
            logreen = bggreen - loshift * (green * shift);

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;
            lowlight = lored << 16 | logreen << 8 | loblue;

            /* return base, lowlight, and highlight */
            return [highlight, basecolor, lowlight];
          };
          Plastic.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          Plastic.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          Plastic.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          Plastic.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var allcolors = Plastic.GetColours(this.colour);
            var lowlight = allcolors[2];
            var highlight = allcolors[0];
            var bgcolors = [allcolors[1], allcolors[2], allcolors[2]];
            var bgalphas = [1, 1, 1];
            var bgratios = [0, 115, 255];
            //var bgcolors = [allcolors[1], allcolors[2]];
            //var bgalphas = [1, 1];
            //var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;
            var bevel = 0.02 * w;
            var div = 3;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            if (h > 0 || h < 0) { /* height is not zero */

              /* draw outline darker rounded rectangle */
              this.graphics.beginFill(0x000000, 1);
              this.graphics.drawRoundRect(0, 0, w, h, w / div, w / div);

              /* draw inner highlight rounded rectangle */
              this.graphics.beginFill(highlight, 1);
              this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

              /* draw inner gradient rounded rectangle */
              bevel = bevel * 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

            } else {

              /* draw outline darker rounded rectangle */
              this.graphics.beginFill(0x000000, 1);
              this.graphics.drawRoundRect(0, 0 - 2 * bevel, w, h + 4 * bevel, w / div, w / div);

              /* draw inner highlight rounded rectangle */
              this.graphics.beginFill(highlight, 1);
              this.graphics.drawRoundRect(0 + bevel, 0 - 2 * bevel + bevel, w - 2 * bevel, h + 4 * bevel - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

              /* draw inner gradient rounded rectangle */
              bevel = bevel * 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRoundRect(0 + bevel, 0 - 2 * bevel + bevel, w - 2 * bevel, h + 4 * bevel - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

            }

            this.graphics.endFill();
          };
          Plastic.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            var bgcolors = Plastic.GetColours(this.colour);
            var bgmatrix = new Matrix();
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            /*var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.75];
            var ratios = [127,255];   */
            var colors = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.05, 0.75];
            var ratios = [0, 123, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            var bevel = 0.02 * w;
            var div = 3;

            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            if (h > 0 || h < 0) {
              /* draw shine rounded rectangle */
              this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);
            } else {
              /* draw shine rounded rectangle */
              this.graphics.drawRoundRect(0 + bevel, 0 - 2 * bevel + bevel, w - 2 * bevel, h + 4 * bevel - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);
            }
            this.graphics.endFill();

          };
          Plastic.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = Plastic.magicTrigFunctionX(pointRatio);
              var ySteps = Plastic.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = Plastic;
        };
        Program["charts.series.bars.PlasticFlat"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var PlasticFlat = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          PlasticFlat.prototype = Object.create(Base.prototype);

          PlasticFlat.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 0.15; /* shift factor */
            var loshift = 1.75; /* lowlight shift factor */
            var basecolor = col; /* base color to be returned */
            var lowlight = col; /* lowlight color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var lored = (rgb & 16711680) >> 16; /* red channel for lowlight */
            var logreen = (rgb & 65280) >> 8; /* green channel for lowlight */
            var loblue = rgb & 255; /* blue channel for lowlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter and darker */
            if (red + red * shift < 255 && red - loshift * red * shift > 0) { /* red can be shifted both lighter and darker */
              bgred = red;
            } else { /* red can be shifter either lighter or darker */
              if (red + red * shift < 255) { /* red can be shifter lighter */
                bgred = red + red / shift;
              } else { /* red can be shifted darker */
                bgred = red - loshift * red * shift;
              }
            }

            if (blue + blue * shift < 255 && blue - loshift * blue * shift > 0) { /* blue can be shifted both lighter and darker */
              bgblue = blue;
            } else { /* blue can be shifter either lighter or darker */
              if (blue + blue * shift < 255) { /* blue can be shifter lighter */
                bgblue = blue + blue * shift;
              } else { /* blue can be shifted darker */
                bgblue = blue - loshift * blue * shift;
              }
            }

            if (green + green * shift < 255 && green - loshift * green * shift > 0) { /* green can be shifted both lighter and darker */
              bggreen = green;
            } else { /* green can be shifted either lighter or darker */
              if (green + green * shift < 255) { /* green can be shifter lighter */
                bggreen = green + green * shift;
              } else { /* green can be shifted darker */
                bggreen = green - loshift * green * shift;
              }
            }

            /* set highlight and lowlight components based on base colors */
            hired = bgred + red * shift;
            lored = bgred - loshift * (red * shift);
            hiblue = bgblue + blue * shift;
            loblue = bgblue - loshift * (blue * shift);
            higreen = bggreen + green * shift;
            logreen = bggreen - loshift * (green * shift);

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;
            lowlight = lored << 16 | logreen << 8 | loblue;

            /* return base, lowlight, and highlight */
            return [highlight, basecolor, lowlight];
          };
          PlasticFlat.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          PlasticFlat.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          PlasticFlat.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          PlasticFlat.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var allcolors = PlasticFlat.GetColours(this.colour);
            var lowlight = allcolors[2];
            var highlight = allcolors[0];
            var bgcolors = [allcolors[1], allcolors[2], allcolors[2]];
            var bgalphas = [1, 1, 1];
            var bgratios = [0, 115, 255];
            //var bgcolors = [allcolors[1], allcolors[2]];
            //var bgalphas = [1, 1];
            //var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;
            var bevel = 0.02 * w;
            var div = 3;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            if (h > 0 || h < 0) { /* height is not zero */

              /* draw outline darker rounded rectangle */
              this.graphics.beginFill(0x000000, 1);
              this.graphics.drawRoundRect(0, 0, w, h, w / div, w / div);

              /* draw inner highlight rounded rectangle */
              this.graphics.beginFill(highlight, 1);
              this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

              /* draw inner gradient rounded rectangle */
              bevel = bevel * 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

            } else {

              /* draw outline darker rounded rectangle */
              this.graphics.beginFill(0x000000, 1);
              this.graphics.drawRoundRect(0, 0 - 2 * bevel, w, h + 4 * bevel, w / div, w / div);

              /* draw inner highlight rounded rectangle */
              this.graphics.beginFill(highlight, 1);
              this.graphics.drawRoundRect(0 + bevel, 0 - 2 * bevel + bevel, w - 2 * bevel, h + 4 * bevel - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

              /* draw inner gradient rounded rectangle */
              bevel = bevel * 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRoundRect(0 + bevel, 0 - 2 * bevel + bevel, w - 2 * bevel, h + 4 * bevel - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

            }

            this.graphics.endFill();
          };
          PlasticFlat.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            var allcolors = PlasticFlat.GetColours(this.colour);
            var lowlight = allcolors[2];
            var highlight = allcolors[0];
            var bgcolors = [allcolors[1], allcolors[2], allcolors[2]];
            var bgalphas = [1, 1, 1];
            var bgratios = [0, 115, 255];
            var bgmatrix = new Matrix();
            /*var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.75];
            var ratios = [127,255];   */
            var colors = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.05, 0.75];
            var ratios = [0, 123, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            var bevel = 0.02 * w;
            var div = 3;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            if (h > 0 && !upside_down) { /* draw bar upwards */

              /* draw shine rounded rectangle */
              this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

              /* draw outline darker rectangle */
              this.graphics.beginFill(0x000000, 1);
              this.graphics.drawRect(0, h - h / 2, w, h / 2);

              /* draw inner highlight rectangle */
              this.graphics.beginFill(highlight, 1);
              this.graphics.drawRect(0 + bevel, h - h / 2, w - 2 * bevel, h / 2 - bevel);

              /* draw inner gradient rectangle */
              bevel = bevel * 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRect(0 + bevel, h - h / 2, w - 2 * bevel, h / 2 - bevel);

              /* draw shine rounded rectangle */
              bevel = bevel / 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRect(0 + bevel, h - h / 2, w - 2 * bevel, h / 2 - bevel);

            } else if (h > 0) { /* draw bar downwards */

              /* draw shine rounded rectangle */
              this.graphics.drawRoundRect(0 + bevel, 0 + bevel, w - 2 * bevel, h - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

              /* draw outline darker rectangle */
              this.graphics.beginFill(0x000000, 1);
              this.graphics.drawRect(0, 0, w, h / 2);

              /* draw inner highlight rectangle */
              this.graphics.beginFill(highlight, 1);
              this.graphics.drawRect(0 + bevel, 0 + bevel, w - 2 * bevel, h / 2 - bevel);

              /* draw inner gradient rectangle */
              bevel = bevel * 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRect(0 + bevel, 0 + bevel, w - 2 * bevel, h / 2 - bevel);

              /* draw shine rounded rectangle */
              bevel = bevel / 3;
              this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
              this.graphics.drawRect(0 + bevel, 0 + bevel, w - 2 * bevel, h / 2 - bevel);

            } else {

              /* draw shine rounded rectangle */
              this.graphics.drawRoundRect(0 + bevel, 0 - 2 * bevel + bevel, w - 2 * bevel, h + 4 * bevel - 2 * bevel, w / div - 2 * bevel, w / div - 2 * bevel);

            }
            this.graphics.endFill();

          };
          PlasticFlat.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = PlasticFlat.magicTrigFunctionX(pointRatio);
              var ySteps = PlasticFlat.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = PlasticFlat;
        };
        Program["charts.series.bars.Round3D"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Round3D = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          Round3D.prototype = Object.create(Base.prototype);

          Round3D.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 2; /* shift factor */
            var basecolor = col; /* base color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter */
            if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255) {
              bgred = red - red / shift;
              bggreen = green - green / shift;
              bgblue = blue - blue / shift;
            }

            /* set highlight components based on base colors */
            hired = bgred + red / shift;
            hiblue = bgblue + blue / shift;
            higreen = bggreen + green / shift;

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;

            /* return base and highlight */
            return [highlight, basecolor];
          };
          Round3D.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          Round3D.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          Round3D.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          Round3D.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var bgcolors = Round3D.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            if (!upside_down && h > 0) { /* draw bar upward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw bottom half ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = rad / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, w / 2);
                this.graphics.lineTo(0, h);
                this.graphics.lineTo(w, h);
                this.graphics.lineTo(w, w / 2);

                /* draw top ellipse */
                //this.graphics.beginFill(this.colour, 1);
                x = w / 2;
                y = w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is too short for normal draw */

                /* draw bottom half ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = rad / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw top ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = h;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              }
            } else

            { /*draw bar downward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw top half ellipse */
                x = w / 2;
                y = 0;
                xRadius = w / 2;
                yRadius = rad / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, 0);
                this.graphics.lineTo(0, h - w / 2);
                this.graphics.lineTo(w, h - w / 2);
                this.graphics.lineTo(w, 0);

                /* draw bottom ellipse */
                //this.graphics.beginFill(this.colour, 1);
                x = w / 2;
                y = h - w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

              } else

              { /* bar is too short for normal draw */

                if (h > 0)

                { /* bar greater than zero */

                  /* draw top half ellipse */
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2;
                  yRadius = rad / 2;
                  this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                  /* draw bottom ellipse */
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2;
                  yRadius = h;
                  this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                } else

                { /* bar is zero */

                  /* draw top ellipse */
                  x = w / 2;
                  y = h;
                  xRadius = w / 2;
                  yRadius = rad / 4;
                  this.Ellipse(x, y, xRadius, yRadius, 100);

                }

              }

            }

            this.graphics.endFill();
          };
          Round3D.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            var bgcolors = Round3D.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);

            /* set gradient fill */
            var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.75];
            var ratios = [100, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            if (!upside_down && h > 0) { /* draw shine upward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw bottom half ellipse shine */
                x = w / 2;
                y = h;
                xRadius = w / 2 - (0.05 * w);
                yRadius = rad / 2 - (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.05 * w), w / 2);
                this.graphics.lineTo(0 + (0.05 * w), h);
                this.graphics.lineTo(w - (0.05 * w), h);
                this.graphics.lineTo(w - (0.05 * w), w / 2);

                /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is not tall enough for normal draw */

                /* draw bottom half ellipse shine */
                x = w / 2;
                y = h;
                xRadius = w / 2 - (0.05 * w);
                yRadius = rad / 2 - (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h;
                xRadius = w / 3 - (0.05 * w);
                yRadius = h - 2.5 * (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              }

            } else

            { /* draw shine downward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.05 * w), 0);
                this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), 0);

                /* redraw bottom ellipse (to overwrite connecting rectangle shine overlap)*/
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = h - w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw bottom ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h - w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = 0;
                xRadius = w / 2;
                yRadius = rad / 2;
                this.Ellipse(x, y, xRadius, yRadius, 100);

                /* draw top half ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, [0.1, 0.7], [0, 255], matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = 0;
                xRadius = w / 2 - (0.05 * w);
                yRadius = rad / 2 - (0.05 * w);
                this.Ellipse(x, y, xRadius, yRadius, 100);

              } else

              { /* bar is not tall enough for normal draw */

                if (h > 0) { /* bar is greater than zero */

                  /* draw bottom ellipse shine */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                  x = w / 3;
                  y = 0;
                  xRadius = w / 3 - (0.05 * w);
                  yRadius = h - 2.5 * (0.05 * w);
                  this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                  /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2;
                  yRadius = rad / 2;
                  this.Ellipse(x, y, xRadius, yRadius, 100);

                  /* draw top half ellipse shine */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, [0.1, 0.67], [0, 255], matrix, 'pad' /*SpreadMethod.PAD*/ );
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2 - (0.05 * w);
                  yRadius = rad / 2 - (0.05 * w);
                  this.Ellipse(x, y, xRadius, yRadius, 100);

                } else

                { /* bar is zero */

                  /* redraw top half ellipse (to overwrite connecting rectangle shine overlap */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2;
                  yRadius = rad / 2;
                  this.Ellipse(x, y, xRadius, yRadius, 100);

                  /* draw top half ellipse shine */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, [0.1, 0.7], [0, 255], matrix, 'pad' /*SpreadMethod.PAD*/ );
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2 - (0.05 * w);
                  yRadius = rad / 2 - (0.05 * w);
                  this.Ellipse(x, y, xRadius, yRadius, 100);

                }

              }

            }

            this.graphics.endFill();
          };
          Round3D.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = Round3D.magicTrigFunctionX(pointRatio);
              var ySteps = Round3D.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          };
          Round3D.prototype.halfEllipse = function(centerX, centerY, xRadius, yRadius, sides, top) {

            var loopStart;
            var loopEnd;

            if (top == true) {
              loopStart = sides / 2;
              loopEnd = sides;
            } else {
              loopStart = 0;
              loopEnd = sides / 2;
            }

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = loopStart; i <= loopEnd; i++) {
              var pointRatio = i / sides;
              var xSteps = Round3D.magicTrigFunctionX(pointRatio);
              var ySteps = Round3D.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = Round3D;
        };
        Program["charts.series.bars.Round"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Round = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          Round.prototype = Object.create(Base.prototype);

          Round.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 2; /* shift factor */
            var basecolor = col; /* base color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter */
            if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255) {
              bgred = red - red / shift;
              bggreen = green - green / shift;
              bgblue = blue - blue / shift;
            }

            /* set highlight components based on base colors */
            hired = bgred + red / shift;
            hiblue = bgblue + blue / shift;
            higreen = bggreen + green / shift;

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;

            /* return base and highlight */
            return [highlight, basecolor];
          };
          Round.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          Round.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          Round.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          Round.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var bgcolors = Round.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            if (h > 0) {

              if (h >= w) { /* bar is tall enough for normal draw */

                /* draw bottom half ellipse */
                x = w / 2;
                y = h - w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, w / 2);
                this.graphics.lineTo(0, h - w / 2);
                this.graphics.lineTo(w, h - w / 2);
                this.graphics.lineTo(w, w / 2);

                /* draw top ellipse */
                //this.graphics.beginFill(this.colour, 1);
                x = w / 2;
                y = w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is too short for normal draw */

                /* draw bottom half ellipse */
                x = w / 2;
                y = h / 2;
                xRadius = w / 2;
                yRadius = h / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw top ellipse */
                x = w / 2;
                y = h / 2;
                xRadius = w / 2;
                yRadius = h / 2;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              }
            } else

            {

              { /* bar is zero */

                /* draw top ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = rad / 4;
                this.Ellipse(x, y, xRadius, yRadius, 100);

              }

            }

            this.graphics.endFill();
          };
          Round.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            var bgcolors = Round.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);

            /* set gradient fill */
            var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.75];
            var ratios = [100, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            if (h > 0) { /* draw shine upward */

              if (h >= w) { /* bar is tall enough for normal draw */

                /* draw bottom half ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h - w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.05 * w), w / 2);
                this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), w / 2);

                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is not tall enough for normal draw */

                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = h / 2 - 3 * (0.05 * w);
                this.Ellipse(x, y, xRadius, yRadius, 100);

              }

            } else

            { /* bar is zero */

              /* draw top ellipse shine*/
              x = w / 2;
              y = h;
              xRadius = w / 2 - (0.05 * w);
              yRadius = rad / 4 - (0.05 * w);
              this.Ellipse(x, y, xRadius, yRadius, 100);

            }

            this.graphics.endFill();
          };
          Round.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = Round.magicTrigFunctionX(pointRatio);
              var ySteps = Round.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          };
          Round.prototype.halfEllipse = function(centerX, centerY, xRadius, yRadius, sides, top) {

            var loopStart;
            var loopEnd;

            if (top == true) {
              loopStart = sides / 2;
              loopEnd = sides;
            } else {
              loopStart = 0;
              loopEnd = sides / 2;
            }

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = loopStart; i <= loopEnd; i++) {
              var pointRatio = i / sides;
              var xSteps = Round.magicTrigFunctionX(pointRatio);
              var ySteps = Round.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = Round;
        };
        Program["charts.series.bars.RoundGlass"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var RoundGlass = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);

            var dropShadow = new flash.filters.DropShadowFilter();
            dropShadow.blurX = 5;
            dropShadow.blurY = 5;
            dropShadow.distance = 3;
            dropShadow.angle = 45;
            dropShadow.quality = 2;
            dropShadow.alpha = 0.4;
            // apply shadow filter
            this.filters = [dropShadow];
          };

          RoundGlass.prototype = Object.create(Base.prototype);

          RoundGlass.GetColours = function(col) {
            var rgb = col; /* decimal value for color */
            var red = (rgb & 16711680) >> 16; /* extacts the red channel */
            var green = (rgb & 65280) >> 8; /* extacts the green channel */
            var blue = rgb & 255; /* extacts the blue channel */
            var shift = 2; /* shift factor */
            var basecolor = col; /* base color to be returned */
            var highlight = col; /* highlight color to be returned */
            var bgred = (rgb & 16711680) >> 16; /* red channel for highlight */
            var bggreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var bgblue = rgb & 255; /* blue channel for highlight */
            var hired = (rgb & 16711680) >> 16; /* red channel for highlight */
            var higreen = (rgb & 65280) >> 8; /* green channel for highlight */
            var hiblue = rgb & 255; /* blue channel for highlight */

            /* set base color components based on ability to shift lighter */
            if (red + red / shift > 255 || green + green / shift > 255 || blue + blue / shift > 255) {
              bgred = red - red / shift;
              bggreen = green - green / shift;
              bgblue = blue - blue / shift;
            }

            /* set highlight components based on base colors */
            hired = bgred + red / shift;
            hiblue = bgblue + blue / shift;
            higreen = bggreen + green / shift;

            /* reconstruct base and highlight */
            basecolor = bgred << 16 | bggreen << 8 | bgblue;
            highlight = hired << 16 | higreen << 8 | hiblue;

            /* return base and highlight */
            return [highlight, basecolor];
          };
          RoundGlass.magicTrigFunctionX = function(pointRatio) {
            return Math.cos(pointRatio * 2 * Math.PI);
          };
          RoundGlass.magicTrigFunctionY = function(pointRatio) {
            return Math.sin(pointRatio * 2 * Math.PI);
          };

          RoundGlass.prototype.resize = function(sc) {

            this.graphics.clear();
            var h = this.resize_helper((ScreenCoords) sc);

            this.bg(h.width, h.height, h.upside_down);
            this.glass(h.width, h.height, h.upside_down);
          };
          RoundGlass.prototype.bg = function(w, h, upside_down) {

            var rad = w / 3;
            if (rad > (w / 2))
              rad = w / 2;

            this.graphics.lineStyle(0, 0, 0); // this.outline_colour, 100);

            var bgcolors = RoundGlass.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();
            var xRadius;
            var yRadius;
            var x;
            var y;

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );

            if (!upside_down && h > 0) { /* draw bar upward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, w / 2);
                this.graphics.lineTo(0, h);
                this.graphics.lineTo(w, h);
                this.graphics.lineTo(w, w / 2);

                /* draw top ellipse */
                //this.graphics.beginFill(this.colour, 1);
                x = w / 2;
                y = w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is too short for normal draw */

                /* draw top ellipse */
                x = w / 2;
                y = h;
                xRadius = w / 2;
                yRadius = h;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              }
            } else

            { /*draw bar downward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /* draw connecting rectangle */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                this.graphics.moveTo(0, 0);
                this.graphics.lineTo(0, h - w / 2);
                this.graphics.lineTo(w, h - w / 2);
                this.graphics.lineTo(w, 0);

                /* draw bottom ellipse */
                //this.graphics.beginFill(this.colour, 1);
                x = w / 2;
                y = h - w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

              } else

              { /* bar is too short for normal draw */

                if (h > 0)

                { /* bar greater than zero */

                  /* draw bottom ellipse */
                  x = w / 2;
                  y = 0;
                  xRadius = w / 2;
                  yRadius = h;
                  this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                } else

                { /* bar is zero */

                  /* draw line */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                  this.graphics.moveTo(0, -0.05 * w);
                  this.graphics.lineTo(0, h + 0.05 * w);
                  this.graphics.lineTo(w, h + 0.05 * w);
                  this.graphics.lineTo(w, -0.05 * w);

                }

              }

            }

            this.graphics.endFill();
          };
          RoundGlass.prototype.glass = function(w, h, upside_down) {

            /* if this section is commented out, the white shine overlay will not be drawn */

            this.graphics.lineStyle(0, 0, 0);
            var bgcolors = RoundGlass.GetColours(this.colour);
            var bgalphas = [1, 1];
            var bgratios = [0, 255];
            var bgmatrix = new Matrix();

            bgmatrix.createGradientBox(w, h, (180 / 180) * Math.PI);

            /* set gradient fill */
            var colors = [0xFFFFFF, 0xFFFFFF];
            var alphas = [0, 0.75];
            var ratios = [100, 255];
            var xRadius;
            var yRadius;
            var x;
            var y;
            var matrix = new Matrix();
            matrix.createGradientBox(width, height, (180 / 180) * Math.PI);
            this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
            var rad = w / 3;

            if (!upside_down && h > 0) { /* draw shine upward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.05 * w), w / 2);
                this.graphics.lineTo(0 + (0.05 * w), h - (0.05 * w));
                this.graphics.lineTo(w - (0.05 * w), h - (0.05 * w));
                this.graphics.lineTo(w - (0.05 * w), w / 2);

                /* redraw top ellipse (to overwrite connecting rectangle shine overlap)*/
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              } else

              { /* bar is not tall enough for normal draw */

                /* draw top ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h - (0.05 * w);
                xRadius = w / 3 - (0.05 * w);
                yRadius = h - 2.5 * (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, true);

              }

            } else

            { /* draw shine downward */

              if (h >= w / 2) { /* bar is tall enough for normal draw */

                /*draw connecting rectangle shine */
                this.graphics.moveTo(0 + (0.05 * w), 0 + (0.05 * w));
                this.graphics.lineTo(0 + (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), h - w / 2);
                this.graphics.lineTo(w - (0.05 * w), 0 + (0.05 * w));

                /* redraw bottom ellipse (to overwrite connecting rectangle shine overlap)*/
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , bgcolors, bgalphas, bgratios, bgmatrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 2;
                y = h - w / 2;
                xRadius = w / 2;
                yRadius = xRadius;
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                /* draw bottom ellipse shine */
                this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                x = w / 3;
                y = h - w / 2;
                xRadius = w / 3 - (0.05 * w);
                yRadius = xRadius + (0.05 * w);
                this.halfEllipse(x, y, xRadius, yRadius, 100, false);

              } else

              { /* bar is not tall enough for normal draw */

                if (h > 0) { /* bar is greater than zero */

                  /* draw bottom ellipse shine */
                  this.graphics.beginGradientFill('linear' /*GradientType.Linear*/ , colors, alphas, ratios, matrix, 'pad' /*SpreadMethod.PAD*/ );
                  x = w / 3;
                  y = 0 + (0.05 * w);
                  xRadius = w / 3 - (0.05 * w);
                  yRadius = h - 2.5 * (0.05 * w);
                  this.halfEllipse(x, y, xRadius, yRadius, 100, false);

                } else

                { /* bar is zero */

                  /* draw line */
                  this.graphics.moveTo(0 + 0.025 * w, -0.025 * w);
                  this.graphics.lineTo(0 + 0.025 * w, h + 0.025 * w);
                  this.graphics.lineTo(w, h + 0.025 * w);
                  this.graphics.lineTo(w, -0.025 * w);

                }

              }

            }

            this.graphics.endFill();
          };
          RoundGlass.prototype.Ellipse = function(centerX, centerY, xRadius, yRadius, sides) {

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = 0; i <= sides; i++) {
              var pointRatio = i / sides;
              var xSteps = RoundGlass.magicTrigFunctionX(pointRatio);
              var ySteps = RoundGlass.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          };
          RoundGlass.prototype.halfEllipse = function(centerX, centerY, xRadius, yRadius, sides, top) {

            var loopStart;
            var loopEnd;

            if (top == true) { /* drawing top half of ellipse */

              loopStart = sides / 2;
              loopEnd = sides;

            } else { /* drawing bottom half of ellipse */

              loopStart = 0;
              loopEnd = sides / 2;

            }

            /* move to first point on ellipse */
            this.graphics.moveTo(centerX + xRadius, centerY);

            /* loop through sides and draw curves */
            for (var i = loopStart; i <= loopEnd; i++) {
              var pointRatio = i / sides;
              var xSteps = RoundGlass.magicTrigFunctionX(pointRatio);
              var ySteps = RoundGlass.magicTrigFunctionY(pointRatio);
              var pointX = centerX + xSteps * xRadius;
              var pointY = centerY + ySteps * yRadius;
              this.graphics.lineTo(pointX, pointY);
            }

            /* return 1 */
            return 1;
          }

          module.exports = RoundGlass;
        };
        Program["charts.series.bars.Sketch"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var ScreenCoords;
          module.inject = function() {
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Sketch = function(index, props, group) {

            Base.call(this, index, props, group);
            //Base.call(this, index, {'top':props.get('top')}, props.get_colour('colour'), props.get('tip'), props.get('alpha'), group);
            this.outline = props.get_colour('outline-colour');
            this.offset = props.get('offset');
          };

          Sketch.prototype = Object.create(Base.prototype);

          Sketch.prototype.outline = 0;
          Sketch.prototype.offset = 0;
          Sketch.prototype.resize = function(sc) {

            var h = this.resize_helper((ScreenCoords) sc);

            // how sketchy the bar is:
            var offset = this.offset;
            var o2 = offset / 2;

            // fill the bar
            // number of pen strokes:
            var strokes = 6;
            // how wide each pen will need to be:
            var l_width = h.width / strokes;

            this.graphics.clear();
            this.graphics.lineStyle(l_width + 1, this.colour, 0.85, true, "none", "round", "miter", 0.8);
            for (var i = 0; i < strokes; i++) {
              this.graphics.moveTo(((l_width * i) + (l_width / 2)) + (Math.random() * offset - o2), 2 + (Math.random() * offset - o2));
              this.graphics.lineTo(((l_width * i) + (l_width / 2)) + (Math.random() * offset - o2), h.height - 2 + (Math.random() * offset - o2));
            }

            // outlines:
            this.graphics.lineStyle(2, this.outline, 1);
            // left upright
            this.graphics.moveTo(Math.random() * offset - o2, Math.random() * offset - o2);
            this.graphics.lineTo(Math.random() * offset - o2, h.height + Math.random() * offset - o2);

            // top
            this.graphics.moveTo(Math.random() * offset - o2, Math.random() * offset - o2);
            this.graphics.lineTo(h.width + (Math.random() * offset - o2), Math.random() * offset - o2);

            // right upright
            this.graphics.moveTo(h.width + (Math.random() * offset - o2), Math.random() * offset - o2);
            this.graphics.lineTo(h.width + (Math.random() * offset - o2), h.height + (Math.random() * offset - o2));

            // bottom
            this.graphics.moveTo(Math.random() * offset - o2, h.height + (Math.random() * offset - o2));
            this.graphics.lineTo(h.width + (Math.random() * offset - o2), h.height + (Math.random() * offset - o2));

          }

          module.exports = Sketch;
        };
        Program["charts.series.bars.Stack"] = function(module, exports) {
          var Base = module.import('charts', 'Base');
          var NumberUtils, ScreenCoords;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            ScreenCoords = module.import('', 'ScreenCoords');
          };

          var Stack = function(index, props, group) {

            // we are not passed a string value, the value
            // is set by the parent collection later
            this.total = props.get('total');

            Base.call(this, index, props, group);
          };

          Stack.prototype = Object.create(Base.prototype);

          Stack.prototype.total = 0;
          Stack.prototype.replace_magic_values = function(t) {

            t = Base.prototype.replace_magic_values.call(this, t);
            t = t.replace('#total#', NumberUtils.formatNumber(this.total));

            return t;
          };
          Stack.prototype.replace_x_axis_label = function(t) {

            this.tooltip = this.tooltip.replace('#x_label#', t);
          };
          Stack.prototype.resize = function(sc) {

            var h = this.resize_helper((ScreenCoords) sc);

            this.graphics.clear();
            this.graphics.beginFill(this.colour, 1.0);
            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(h.width, 0);
            this.graphics.lineTo(h.width, h.height);
            this.graphics.lineTo(0, h.height);
            this.graphics.lineTo(0, 0);
            this.graphics.endFill();
          }

          module.exports = Stack;
        };
        Program["charts.series.bars.StackCollection"] = function(module, exports) {
          var Element = module.import('charts.series', 'Element');
          var Properties, Stack;
          module.inject = function() {
            Properties = module.import('', 'Properties');
            Stack = module.import('charts.series.bars', 'Stack');
          };

          var StackCollection = function(index, props, group) {
            this.tip_pos = null;
            this.vals = null;
            this.colours = null;

            //this.tooltip = this.replace_magic_values( props.get('tip') );
            this.tooltip = props.get('tip');

            // this is very similar to a normal
            // PointBarBase but without the mouse
            // over and mouse out events
            this.index = index;

            var item;

            // a stacked bar has n Y values
            // so this is an array of objects
            this.vals = (Array) props.get('values');

            this.total = 0;
            for each(item in this.vals) {
              if (item != null) {
                if (item is Number)
                  this.total += item;
                else
                  this.total += item.val;
              }
            }

            //
            // parse our HEX colour strings
            //
            this.colours = [];
            for each(var colour in props.get('colours'))
            this.colours.push(string.Utils.get_colour(colour));

            this.group = group;
            this.visible = true;

            var prop;

            var n; // <-- ugh, leaky variables.
            var bottom = 0;
            var top = 0;
            var colr;
            var count = 0;

            for each(item in this.vals) {
              // is this a null stacked bar group?
              if (item != null) {
                colr = this.colours[(count % this.colours.length)]

                // override bottom, colour and total, leave tooltip, on-click, on-show etc..
                var defaul_stack_props = new Properties({
                  bottom: bottom,
                  colour: colr, // <-- colour from list (may be overriden later)
                  this.total: this.total
                }, props);

                //
                // a valid item is one of [ Number, Object, null ]
                //
                if (item is Number) {
                  item = {
                    val: item
                  };
                }

                if (item == null) {
                  item = {
                    val: null
                  };
                }

                // MERGE:
                top += item.val;
                item.top = top;
                // now override on-click, on-show, colour etc...
                var stack_props = new Properties(item, defaul_stack_props);

                var p = new Stack(index, stack_props, group);
                this.addChild(p);

                bottom = top;
                count++;
              }
            }
          };

          StackCollection.prototype = Object.create(Element.prototype);

          StackCollection.prototype.tip_pos = null;
          StackCollection.prototype.vals = null;
          StackCollection.prototype.colours = null;
          StackCollection.prototype.group = 0;
          StackCollection.prototype.total = 0;
          StackCollection.prototype.resize = function(sc) {

            for (var i = 0; i < this.numChildren; i++) {
              var e = (Element) this.getChildAt(i);
              e.resize(sc);
            }
          };
          StackCollection.prototype.get_mid_point = function() {

            // get the first bar in the stack
            var e = (Element) this.getChildAt(0);

            return e.get_mid_point();
          };
          StackCollection.prototype.get_children = function() {

            var tmp = [];
            for (var i = 0; i < this.numChildren; i++) {
              tmp.push(this.getChildAt(i));
            }
            return tmp;
          };
          StackCollection.prototype.get_tip_pos = function() {
            //
            // get top item in stack
            //
            var e = (Element) this.getChildAt(this.numChildren - 1);
            return e.get_tip_pos();
          };
          StackCollection.prototype.get_tooltip = function() {
            //
            // is the mouse over one of the bars in this stack?
            //

            // tr.ace( this.numChildren );
            for (var i = 0; i < this.numChildren; i++) {
              var e = (Element) this.getChildAt(i);
              if (e.is_tip) {
                //tr.ace( 'TIP' );
                return e.get_tooltip();
              }
            }
            //
            // the mouse is *near* our stack, so show the 'total' tooltip
            //
            return this.tooltip;
          };
          StackCollection.prototype.tooltip_replace_labels = function(labels) {

            for (var i = 0; i < this.numChildren; i++) {
              var e = (Stack) this.getChildAt(i);
              e.replace_x_axis_label(labels.get(this.index));
            }
          }

          module.exports = StackCollection;
        };
        Program["charts.series.dots.anchor"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');
          var Tweener;
          module.inject = function() {
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var anchor = function(index, value) {

            var colour = string.Utils.get_colour(value.get('colour'));

            PointDotBase.call(this, index, value);

            this.tooltip = this.replace_magic_values(value.get('tip'));
            this.attach_events();

            // if style.x is null then user wants a gap in the line
            //
            // I don't understand what this is doing...
            //
            //      if (style.x == null)
            //      {
            //        this.visible = false;
            //      }
            //      else
            //      {

            if (value.get('hollow')) {
              // Hollow - set the fill to the background color/alpha
              if (value.has('background-colour')) {
                var bgColor = string.Utils.get_colour(value.get('background-colour'));
              } else {
                bgColor = colour;
              }

              this.graphics.beginFill(bgColor, value.get('background-alpha'));
            } else {
              // set the fill to be the same color and alpha as the line
              this.graphics.beginFill(colour, value.get('alpha'));
            }

            this.graphics.lineStyle(value.get('width'), colour, value.get('alpha'));

            this.drawAnchor(this.graphics, this.radius, value.get('sides'), rotation);
            // Check to see if part of the line needs to be erased
            //trace("haloSize = ", haloSize);
            if (value.get('halo-size') > 0) {
              var size = value.get('halo-size') + this.radius;
              var s = new Sprite();
              s.graphics.lineStyle(0, 0, 0);
              s.graphics.beginFill(0, 1);
              this.drawAnchor(s.graphics, size, value.get('sides'), rotation);
              s.blendMode = BlendMode.ERASE;
              s.graphics.endFill();
              this.line_mask = s;
            }
            //      }

          };

          anchor.prototype = Object.create(PointDotBase.prototype);

          anchor.prototype.set_tip = function(b) {
            if (b) {
              if (!this.is_tip) {
                Tweener.addTween(this, {
                  scaleX: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                Tweener.addTween(this, {
                  scaleY: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                if (this.line_mask != null) {
                  Tweener.addTween(this.line_mask, {
                    scaleX: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                  Tweener.addTween(this.line_mask, {
                    scaleY: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                }
              }
              this.is_tip = true;
            } else {
              Tweener.removeTweens(this);
              Tweener.removeTweens(this.line_mask);
              this.scaleX = 1;
              this.scaleY = 1;
              if (this.line_mask != null) {
                this.line_mask.scaleX = 1;
                this.line_mask.scaleY = 1;
              }
              this.is_tip = false;
            }
          };
          anchor.prototype.drawAnchor = function(aGraphics, aRadius, aSides, aRotation) {
            if (aSides < 3) aSides = 3;
            if (aSides > 360) aSides = 360;
            var angle = 360 / aSides;
            for (var ix = 0; ix <= aSides; ix++) {
              // Move start point to vertical axis (-90 degrees)
              var degrees = -90 + aRotation + (ix % aSides) * angle;
              var xVal = this.calcXOnCircle(aRadius, degrees);
              var yVal = this.calcYOnCircle(aRadius, degrees);

              if (ix == 0) {
                aGraphics.moveTo(xVal, yVal);
              } else {
                aGraphics.lineTo(xVal, yVal);
              }
            }
          }

          module.exports = anchor;
        };
        Program["charts.series.dots.bow"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');
          var Tweener;
          module.inject = function() {
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var bow = function(index, value) {

            var colour = string.Utils.get_colour(value.get('colour'));

            PointDotBase.call(this, index, value);

            this.tooltip = this.replace_magic_values(value.get('tip'));
            this.attach_events();

            // if style.x is null then user wants a gap in the line
            //
            // I don't understand what this is doing...
            //
            //      if (style.x == null)
            //      {
            //        this.visible = false;
            //      }
            //      else
            //      {

            if (value.get('hollow')) {
              // Hollow - set the fill to the background color/alpha
              if (value.get('background-colour') != null) {
                var bgColor = string.Utils.get_colour(value.get('background-colour'));
              } else {
                bgColor = colour;
              }

              this.graphics.beginFill(bgColor, value.get('background-alpha'));
            } else {
              // set the fill to be the same color and alpha as the line
              this.graphics.beginFill(colour, value.get('alpha'));
            }

            this.graphics.lineStyle(value.get('width'), colour, value.get('alpha'));

            this.draw(this.graphics, this.radius, value.get('rotation'));
            // Check to see if part of the line needs to be erased
            if (value.get('halo-size') > 0) {
              var s = new Sprite();
              s.graphics.lineStyle(0, 0, 0);
              s.graphics.beginFill(0, 1);
              this.draw(s.graphics, value.get('halo-size') + this.radius, value.get('rotation'));
              s.blendMode = BlendMode.ERASE;
              s.graphics.endFill();
              this.line_mask = s;
            }
            //      }

          };

          bow.prototype = Object.create(PointDotBase.prototype);

          bow.prototype.set_tip = function(b) {
            if (b) {
              if (!this.is_tip) {
                Tweener.addTween(this, {
                  scaleX: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                Tweener.addTween(this, {
                  scaleY: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                if (this.line_mask != null) {
                  Tweener.addTween(this.line_mask, {
                    scaleX: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                  Tweener.addTween(this.line_mask, {
                    scaleY: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                }
              }
              this.is_tip = true;
            } else {
              Tweener.removeTweens(this);
              Tweener.removeTweens(this.line_mask);
              this.scaleX = 1;
              this.scaleY = 1;
              if (this.line_mask != null) {
                this.line_mask.scaleX = 1;
                this.line_mask.scaleY = 1;
              }
              this.is_tip = false;
            }
          };
          bow.prototype.draw = function(aGraphics, aRadius, aRotation) {
            var angle = 60;

            // Start at center point
            aGraphics.moveTo(0, 0);

            // Upper right side point (unrotated)
            var degrees = -90 + aRotation + angle;
            var xVal = this.calcXOnCircle(aRadius, degrees);
            var yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Lower right side point (unrotated)
            degrees += angle;
            xVal = this.calcXOnCircle(aRadius, degrees);
            yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Back to the center
            aGraphics.lineTo(xVal, yVal);

            // Upper left side point (unrotated)
            degrees = -90 + aRotation - angle;
            xVal = this.calcXOnCircle(aRadius, degrees);
            yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Lower Left side point (unrotated)
            degrees -= angle;
            xVal = this.calcXOnCircle(aRadius, degrees);
            yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Back to the center
            aGraphics.lineTo(xVal, yVal);
          }

          module.exports = bow;
        };
        Program["charts.series.dots.DefaultDotProperties"] = function(module, exports) {
          var Properties = module.import('', 'Properties');
          var tr;
          module.inject = function() {
            tr = module.import('', 'tr');
          };

          var DefaultDotProperties = function(json, colour, axis) {
            // tr.ace_json(json);

            // the user JSON can override any of these:
            var parent = new Properties({
              axis: axis,
              'type': 'dot',
              'dot-size': 5,
              'halo-size': 2,
              'colour': colour,
              'tip': '#val#',
              alpha: 1,
              // this is for anchors:
              rotation: 0,
              sides: 3,
              // this is for hollow dot:
              width: 1
            });

            Properties.call(this, json, parent);

            tr.aces('4', this.get('axis'));
            // tr.aces('4', this.get('colour'));
            // tr.aces('4', this.get('type'));
          };

          DefaultDotProperties.prototype = Object.create(Properties.prototype);

          module.exports = DefaultDotProperties;
        };
        Program["charts.series.dots.dot_factory"] = function(module, exports) {
          var anchor, bow, Hollow, Point, PointDot, star;
          module.inject = function() {
            anchor = module.import('charts.series.dots', 'anchor');
            bow = module.import('charts.series.dots', 'bow');
            Hollow = module.import('charts.series.dots', 'Hollow');
            Point = module.import('charts.series.dots', 'Point');
            PointDot = module.import('charts.series.dots', 'PointDot');
            star = module.import('charts.series.dots', 'star');
          };

          var dot_factory = function dot_factory() {};

          dot_factory.make = function(index, style) {

            // tr.aces( 'dot factory type', style.get('type'));

            switch (style.get('type')) {
              case 'star':
                return new star(index, style);
                break;

              case 'bow':
                return new bow(index, style);
                break;

              case 'anchor':
                return new anchor(index, style);
                break;

              case 'dot':
                return new Point(index, style);
                break;

              case 'solid-dot':
                return new PointDot(index, style);
                break;

              case 'hollow-dot':
                return new Hollow(index, style);
                break;

              default:
                //
                // copy out the bow tie and then remove
                //
                return new Point(index, style);
                // return new scat(style);
                break;
            }
          };

          module.exports = dot_factory;
        };
        Program["charts.series.dots.Hollow"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');

          var Hollow = function(index, style) {
            // tr.aces('h i', index);
            PointDotBase.call(this, index, style);

            var colour = string.Utils.get_colour(style.get('colour'));

            this.graphics.clear();
            //
            // fill a big circle
            //
            this.graphics.lineStyle(0, 0, 0);
            this.graphics.beginFill(colour, 1);
            this.graphics.drawCircle(0, 0, style.get('dot-size'));
            //
            // punch out the hollow circle:
            //
            this.graphics.drawCircle(0, 0, style.get('dot-size') - style.get('width'));
            this.graphics.endFill(); // <-- LOOK
            //
            // HACK: we fill an invisible circle over
            //       the hollow circle so the mouse over
            //       event fires correctly (even when the
            //       mouse is in the hollow part)
            //
            this.graphics.lineStyle(0, 0, 0);
            this.graphics.beginFill(0, 0);
            this.graphics.drawCircle(0, 0, style.get('dot-size'));
            this.graphics.endFill();
            //
            // MASK
            //
            var s = new Sprite();
            s.graphics.lineStyle(0, 0, 0);
            s.graphics.beginFill(0, 1);
            s.graphics.drawCircle(0, 0, style.get('dot-size') + style.get('halo-size'));
            s.blendMode = BlendMode.ERASE;

            this.line_mask = s;
            this.attach_events();

          };

          Hollow.prototype = Object.create(PointDotBase.prototype);

          module.exports = Hollow;
        };
        Program["charts.series.dots.Point"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');

          var Point = function(index, style) {
            PointDotBase.call(this, index, style);

            var colour = string.Utils.get_colour(style.get('colour'));

            this.graphics.lineStyle(0, 0, 0);
            this.graphics.beginFill(colour, 1);
            this.graphics.drawCircle(0, 0, style.get('dot-size'));
            this.visible = false;
            this.attach_events();

            var s = new Sprite();
            s.graphics.lineStyle(0, 0, 0);
            s.graphics.beginFill(0, 1);
            s.graphics.drawCircle(0, 0, style.get('dot-size') + style.get('halo-size'));
            s.blendMode = BlendMode.ERASE;
            s.visible = false;

            this.line_mask = s;
          };

          Point.prototype = Object.create(PointDotBase.prototype);

          Point.prototype.set_tip = function(b) {

            this.visible = b;
            this.line_mask.visible = b;
          }

          module.exports = Point;
        };
        Program["charts.series.dots.PointDot"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');

          var PointDot = function(index, style) {

            PointDotBase.call(this, index, style);

            var colour = string.Utils.get_colour(style.get('colour'));

            this.graphics.lineStyle(0, 0, 0);
            this.graphics.beginFill(colour, 1);
            this.graphics.drawCircle(0, 0, style.get('dot-size'));
            this.graphics.endFill();

            var s = new Sprite();
            s.graphics.lineStyle(0, 0, 0);
            s.graphics.beginFill(0, 1);
            s.graphics.drawCircle(0, 0, style.get('dot-size') + style.get('halo-size'));
            s.blendMode = BlendMode.ERASE;

            this.line_mask = s;

            this.attach_events();
          };

          PointDot.prototype = Object.create(PointDotBase.prototype);

          module.exports = PointDot;
        };
        Program["charts.series.dots.PointDotBase"] = function(module, exports) {
          var Element = module.import('charts.series', 'Element');
          var NumberUtils, tr, DateUtils, Equations, Tweener;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            tr = module.import('', 'tr');
            DateUtils = module.import('string', 'DateUtils');
            Equations = module.import('caurina.transitions', 'Equations');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var PointDotBase = function(index, props) {
            this.on_show = null;

            Element.call(this);
            this.is_tip = false;
            this.visible = true;
            this.on_show_animate = true;
            this.on_show = props.get('on-show');

            /*
            this.on_show = new Properties( {
              type:    "",
              cascade:  3,
              delay:    0
              });
            */

            // line charts have a value and no X, scatter charts have
            // x, y (not value): radar charts have value, Y does not 
            // make sense.
            if (!props.has('y'))
              props.set('y', props.get('value'));

            this._y = props.get('y');

            // no X passed in so calculate it from the index
            if (!props.has('x')) {
              this.index = this._x = index;
            } else {
              // tr.aces( 'x', props.get('x') );
              this._x = props.get('x');
              this.index = Number.MIN_VALUE;
            }

            this.radius = props.get('dot-size');
            this.tooltip = this.replace_magic_values(props.get('tip'));

            if (props.has('on-click'))
              this.set_on_click(props.get('on-click'));

            //
            // TODO: fix this hack
            //
            if (props.has('axis'))
              if (props.get('axis') == 'right')
                this.right_axis = true;

          };

          PointDotBase.prototype = Object.create(Element.prototype);

          PointDotBase.prototype.radius = 0;
          PointDotBase.prototype.colour = 0;
          PointDotBase.prototype.on_show_animate = false;
          PointDotBase.prototype.on_show = null;
          PointDotBase.prototype.resize = function(sc) {

            var x;
            var y;

            if (this.index != Number.MIN_VALUE) {

              var p = sc.get_get_x_from_pos_and_y_from_val(this.index, this._y, this.right_axis);
              x = p.x;
              y = p.y;
            } else {

              //
              // Look: we have a real X value, so get its screen location:
              //
              x = sc.get_x_from_val(this._x);
              y = sc.get_y_from_val(this._y, this.right_axis);
            }

            // Move the mask so it is in the proper place also
            // this all needs to be moved into the base class
            if (this.line_mask != null) {
              this.line_mask.x = x;
              this.line_mask.y = y;
            }

            if (this.on_show_animate)
              this.first_show(x, y, sc);
            else {
              //
              // move the Sprite to the correct screen location:
              //
              this.y = y;
              this.x = x;
            }
          };
          PointDotBase.prototype.is_tweening = function() {
            return Tweener.isTweening(this);
          };
          PointDotBase.prototype.first_show = function(x, y, sc) {

            this.on_show_animate = false;
            Tweener.removeTweens(this);

            // tr.aces('base.as', this.on_show.get('type') );
            var d = x / this.stage.stageWidth;
            d *= this.on_show.get('cascade');
            d += this.on_show.get('delay');

            switch (this.on_show.get('type')) {

              case 'pop-up':
                this.x = x;
                this.y = sc.get_y_bottom(this.right_axis);
                Tweener.addTween(this, {
                  y: y,
                  time: 1.4,
                  delay: d,
                  transition: Equations.easeOutQuad
                });

                if (this.line_mask != null) {
                  this.line_mask.x = x;
                  this.line_mask.y = sc.get_y_bottom(this.right_axis);
                  Tweener.addTween(this.line_mask, {
                    y: y,
                    time: 1.4,
                    delay: d,
                    transition: Equations.easeOutQuad
                  });
                }

                break;

              case 'explode':
                this.x = this.stage.stageWidth / 2;
                this.y = this.stage.stageHeight / 2;
                Tweener.addTween(this, {
                  y: y,
                  x: x,
                  time: 1.4,
                  delay: d,
                  transition: Equations.easeOutQuad
                });

                if (this.line_mask != null) {
                  this.line_mask.x = this.stage.stageWidth / 2;
                  this.line_mask.y = this.stage.stageHeight / 2;
                  Tweener.addTween(this.line_mask, {
                    y: y,
                    x: x,
                    time: 1.4,
                    delay: d,
                    transition: Equations.easeOutQuad
                  });
                }

                break;

              case 'mid-slide':
                this.x = x;
                this.y = this.stage.stageHeight / 2;
                this.alpha = 0.2;
                Tweener.addTween(this, {
                  alpha: 1,
                  y: y,
                  time: 1.4,
                  delay: d,
                  transition: Equations.easeOutQuad
                });

                if (this.line_mask != null) {
                  this.line_mask.x = x;
                  this.line_mask.y = this.stage.stageHeight / 2;
                  Tweener.addTween(this.line_mask, {
                    y: y,
                    time: 1.4,
                    delay: d,
                    transition: Equations.easeOutQuad
                  });
                }

                break;

                /*
                 * the tooltips go a bit funny with this one
                 * TODO: investigate if this will work with area charts - need to move the bottom anchors
                case 'slide-in-up':
                  this.x = 20;  // <-- left
                  this.y = this.stage.stageHeight / 2;
                  Tweener.addTween(
                    this, 
                    { x:x, time:1.4, delay:d, transition:Equations.easeOutQuad, 
                    onComplete:function():void {
                      Tweener.addTween(this, 
                      { y:y, time:1.4, transition:Equations.easeOutQuad } ) }
                    } );
                  break;
                */

              case 'drop':
                this.x = x;
                this.y = -height - 10;
                Tweener.addTween(this, {
                  y: y,
                  time: 1.4,
                  delay: d,
                  transition: Equations.easeOutBounce
                });

                if (this.line_mask != null) {
                  this.line_mask.x = x;
                  this.line_mask.y = -height - 10;
                  Tweener.addTween(this.line_mask, {
                    y: y,
                    time: 1.4,
                    delay: d,
                    transition: Equations.easeOutQuad
                  });
                }

                break;

              case 'fade-in':
                this.x = x;
                this.y = y;
                this.alpha = 0;
                Tweener.addTween(this, {
                  alpha: 1,
                  time: 1.2,
                  delay: d,
                  transition: Equations.easeOutQuad
                });
                break;

              case 'shrink-in':
                this.x = x;
                this.y = y;
                this.scaleX = this.scaleY = 5;
                this.alpha = 0;
                Tweener.addTween(
                  this, {
                    scaleX: 1,
                    scaleY: 1,
                    alpha: 1,
                    time: 1.2,
                    delay: d,
                    transition: Equations.easeOutQuad,
                    onComplete: function() {
                      tr.ace('Fin');
                    }
                  });

                break;

              default:
                this.y = y;
                this.x = x;
            }
          };
          PointDotBase.prototype.set_tip = function(b) {
            //this.visible = b;
            if (b) {
              this.scaleY = this.scaleX = 1.3;
              this.line_mask.scaleY = this.line_mask.scaleX = 1.3;
            } else {
              this.scaleY = this.scaleX = 1;
              this.line_mask.scaleY = this.line_mask.scaleX = 1;
            }
          };
          PointDotBase.prototype.replace_magic_values = function(t) {

            t = t.replace('#val#', NumberUtils.formatNumber(this._y));

            // for scatter charts
            t = t.replace('#x#', NumberUtils.formatNumber(this._x));
            t = t.replace('#y#', NumberUtils.formatNumber(this._y));

            // debug the dots sizes
            t = t.replace('#size#', NumberUtils.formatNumber(this.radius));

            t = DateUtils.replace_magic_values(t, this._x);
            return t;
          };
          PointDotBase.prototype.calcXOnCircle = function(aRadius, aDegrees) {
            return aRadius * Math.cos(aDegrees / 180 * Math.PI);
          };
          PointDotBase.prototype.calcYOnCircle = function(aRadius, aDegrees) {
            return aRadius * Math.sin(aDegrees / 180 * Math.PI);
          }

          module.exports = PointDotBase;
        };
        Program["charts.series.dots.scat"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');
          var Properties, Tweener;
          module.inject = function() {
            Properties = module.import('', 'Properties');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var scat = function(style) {

            // scatter charts have x, y (not value):
            style.value = style.y;

            PointDotBase.call(this, -99, new Properties({})); // style );

            // override the basics in PointDotBase:
            this._x = style.x;
            this._y = style.y;
            this.visible = true;

            if (style.alpha == null)
              style.alpha = 1;

            this.tooltip = this.replace_magic_values(style.tip);
            this.attach_events();

            // if style.x is null then user wants a gap in the line
            if (style.x == null) {
              this.visible = false;
            } else {
              var haloSize = isNaN(style['halo-size']) ? 0 : style['halo-size'];
              var isHollow = style['hollow'];

              if (isHollow) {
                // Hollow - set the fill to the background color/alpha
                if (style['background-colour'] != null) {
                  var bgColor = string.Utils.get_colour(style['background-colour']);
                } else {
                  bgColor = style.colour;
                }
                var bgAlpha = isNaN(style['background-alpha']) ? 0 : style['background-alpha'];

                this.graphics.beginFill(bgColor, bgAlpha);
              } else {
                // set the fill to be the same color and alpha as the line
                this.graphics.beginFill(style.colour, style.alpha);
              }

              switch (style['type']) {
                case 'dot':
                  this.graphics.lineStyle(0, 0, 0);
                  this.graphics.beginFill(style.colour, style.alpha);
                  this.graphics.drawCircle(0, 0, style['dot-size']);
                  this.graphics.endFill();

                  var s = new Sprite();
                  s.graphics.lineStyle(0, 0, 0);
                  s.graphics.beginFill(0, 1);
                  s.graphics.drawCircle(0, 0, style['dot-size'] + haloSize);
                  s.blendMode = BlendMode.ERASE;

                  this.line_mask = s;
                  break;

                case 'anchor':
                  this.graphics.lineStyle(style.width, style.colour, style.alpha);
                  var rotation = isNaN(style['rotation']) ? 0 : style['rotation'];
                  var sides = Math.max(3, isNaN(style['sides']) ? 3 : style['sides']);
                  this.drawAnchor(this.graphics, this.radius, sides, rotation);
                  // Check to see if part of the line needs to be erased
                  //trace("haloSize = ", haloSize);
                  if (haloSize > 0) {
                    haloSize += this.radius;
                    s = new Sprite();
                    s.graphics.lineStyle(0, 0, 0);
                    s.graphics.beginFill(0, 1);
                    this.drawAnchor(s.graphics, haloSize, sides, rotation);
                    s.blendMode = BlendMode.ERASE;
                    s.graphics.endFill();
                    this.line_mask = s;
                  }
                  break;

                case 'bow':
                  this.graphics.lineStyle(style.width, style.colour, style.alpha);
                  rotation = isNaN(style['rotation']) ? 0 : style['rotation'];

                  this.drawBow(this.graphics, this.radius, rotation);
                  // Check to see if part of the line needs to be erased
                  if (haloSize > 0) {
                    haloSize += this.radius;
                    s = new Sprite();
                    s.graphics.lineStyle(0, 0, 0);
                    s.graphics.beginFill(0, 1);
                    this.drawBow(s.graphics, haloSize, rotation);
                    s.blendMode = BlendMode.ERASE;
                    s.graphics.endFill();
                    this.line_mask = s;
                  }
                  break;

                case 'star':
                  this.graphics.lineStyle(style.width, style.colour, style.alpha);
                  rotation = isNaN(style['rotation']) ? 0 : style['rotation'];

                  this.drawStar_2(this.graphics, this.radius, rotation);
                  // Check to see if part of the line needs to be erased
                  if (haloSize > 0) {
                    haloSize += this.radius;
                    s = new Sprite();
                    s.graphics.lineStyle(0, 0, 0);
                    s.graphics.beginFill(0, 1);
                    this.drawStar_2(s.graphics, haloSize, rotation);
                    s.blendMode = BlendMode.ERASE;
                    s.graphics.endFill();
                    this.line_mask = s;
                  }
                  break;

                default:
                  this.graphics.drawCircle(0, 0, this.radius);
                  this.graphics.drawCircle(0, 0, this.radius - 1);
                  this.graphics.endFill();
              }
            }

          };

          scat.prototype = Object.create(PointDotBase.prototype);

          scat.prototype.set_tip = function(b) {
            if (b) {
              if (!this.is_tip) {
                Tweener.addTween(this, {
                  scaleX: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                Tweener.addTween(this, {
                  scaleY: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                if (this.line_mask != null) {
                  Tweener.addTween(this.line_mask, {
                    scaleX: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                  Tweener.addTween(this.line_mask, {
                    scaleY: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                }
              }
              this.is_tip = true;
            } else {
              Tweener.removeTweens(this);
              Tweener.removeTweens(this.line_mask);
              this.scaleX = 1;
              this.scaleY = 1;
              if (this.line_mask != null) {
                this.line_mask.scaleX = 1;
                this.line_mask.scaleY = 1;
              }
              this.is_tip = false;
            }
          };
          scat.prototype.resize = function(sc) {

            //
            // Look: we have a real X value, so get its screen location:
            //
            this.x = sc.get_x_from_val(this._x);
            this.y = sc.get_y_from_val(this._y, this.right_axis);

            // Move the mask so it is in the proper place also
            // this all needs to be moved into the base class
            if (this.line_mask != null) {
              this.line_mask.x = this.x;
              this.line_mask.y = this.y;
            }
          };
          scat.prototype.drawAnchor = function(aGraphics, aRadius, aSides, aRotation) {
            if (aSides < 3) aSides = 3;
            if (aSides > 360) aSides = 360;
            var angle = 360 / aSides;
            for (var ix = 0; ix <= aSides; ix++) {
              // Move start point to vertical axis (-90 degrees)
              var degrees = -90 + aRotation + (ix % aSides) * angle;
              var xVal = this.calcXOnCircle(aRadius, degrees);
              var yVal = this.calcYOnCircle(aRadius, degrees);

              if (ix == 0) {
                aGraphics.moveTo(xVal, yVal);
              } else {
                aGraphics.lineTo(xVal, yVal);
              }
            }
          };
          scat.prototype.drawBow = function(aGraphics, aRadius, aRotation) {
            var angle = 60;

            // Start at center point
            aGraphics.moveTo(0, 0);

            // Upper right side point (unrotated)
            var degrees = -90 + aRotation + angle;
            var xVal = this.calcXOnCircle(aRadius, degrees);
            var yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Lower right side point (unrotated)
            degrees += angle;
            xVal = this.calcXOnCircle(aRadius, degrees);
            yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Back to the center
            aGraphics.lineTo(xVal, yVal);

            // Upper left side point (unrotated)
            degrees = -90 + aRotation - angle;
            xVal = this.calcXOnCircle(aRadius, degrees);
            yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Lower Left side point (unrotated)
            degrees -= angle;
            xVal = this.calcXOnCircle(aRadius, degrees);
            yVal = this.calcYOnCircle(aRadius, degrees);
            aGraphics.lineTo(xVal, yVal);

            // Back to the center
            aGraphics.lineTo(xVal, yVal);
          };
          scat.prototype.drawStar_2 = function(aGraphics, aRadius, aRotation) {
            var angle = 360 / 10;

            // Start at top point (unrotated)
            var degrees = -90 + aRotation;
            for (var ix = 0; ix < 11; ix++) {
              var rad;
              rad = (ix % 2 == 0) ? aRadius : aRadius / 2;
              var xVal = this.calcXOnCircle(rad, degrees);
              var yVal = this.calcYOnCircle(rad, degrees);
              if (ix == 0) {
                aGraphics.moveTo(xVal, yVal);
              } else {
                aGraphics.lineTo(xVal, yVal);
              }
              degrees += angle;
            }
          };
          scat.prototype.drawStar = function(aGraphics, aRadius, aRotation) {
            var angle = 360 / 5;

            // Start at top point (unrotated)
            var degrees = -90 + aRotation;
            for (var ix = 0; ix <= 5; ix++) {
              var xVal = this.calcXOnCircle(aRadius, degrees);
              var yVal = this.calcYOnCircle(aRadius, degrees);
              if (ix == 0) {
                aGraphics.moveTo(xVal, yVal);
              } else {
                aGraphics.lineTo(xVal, yVal);
              }
              // Move 2 points clockwise
              degrees += (2 * angle);
            }
          }

          module.exports = scat;
        };
        Program["charts.series.dots.star"] = function(module, exports) {
          var PointDotBase = module.import('charts.series.dots', 'PointDotBase');
          var Tweener;
          module.inject = function() {
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var star = function(index, value) {

            var colour = string.Utils.get_colour(value.get('colour'));

            PointDotBase.call(this, index, value);

            this.tooltip = this.replace_magic_values(value.get('tip'));
            this.attach_events();

            // if style.x is null then user wants a gap in the line
            //
            // I don't understand what this is doing...
            //
            //      if (style.x == null)
            //      {
            //        this.visible = false;
            //      }
            //      else
            //      {

            if (value.get('hollow')) {
              // Hollow - set the fill to the background color/alpha
              if (value.get('background-colour') != null) {
                var bgColor = string.Utils.get_colour(value.get('background-colour'));
              } else {
                bgColor = colour;
              }

              this.graphics.beginFill(bgColor, value.get('background-alpha'));
            } else {
              // set the fill to be the same color and alpha as the line
              this.graphics.beginFill(colour, value.get('alpha'));
            }

            this.graphics.lineStyle(value.get('width'), colour, value.get('alpha'));

            this.drawStar_2(this.graphics, this.radius, value.get('rotation'));
            // Check to see if part of the line needs to be erased
            if (value.get('halo-size') > 0) {
              var s = new Sprite();
              s.graphics.lineStyle(0, 0, 0);
              s.graphics.beginFill(0, 1);
              this.drawStar_2(s.graphics, value.get('halo-size') + this.radius, value.get('rotation'));
              s.blendMode = BlendMode.ERASE;
              s.graphics.endFill();
              this.line_mask = s;
            }
            //      }

          };

          star.prototype = Object.create(PointDotBase.prototype);

          star.prototype.set_tip = function(b) {
            if (b) {
              if (!this.is_tip) {
                Tweener.addTween(this, {
                  scaleX: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                Tweener.addTween(this, {
                  scaleY: 1.3,
                  time: 0.4,
                  transition: "easeoutbounce"
                });
                if (this.line_mask != null) {
                  Tweener.addTween(this.line_mask, {
                    scaleX: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                  Tweener.addTween(this.line_mask, {
                    scaleY: 1.3,
                    time: 0.4,
                    transition: "easeoutbounce"
                  });
                }
              }
              this.is_tip = true;
            } else {
              Tweener.removeTweens(this);
              Tweener.removeTweens(this.line_mask);
              this.scaleX = 1;
              this.scaleY = 1;
              if (this.line_mask != null) {
                this.line_mask.scaleX = 1;
                this.line_mask.scaleY = 1;
              }
              this.is_tip = false;
            }
          };
          star.prototype.drawStar_2 = function(aGraphics, aRadius, aRotation) {
            var angle = 360 / 10;

            // Start at top point (unrotated)
            var degrees = -90 + aRotation;
            for (var ix = 0; ix < 11; ix++) {
              var rad;
              rad = (ix % 2 == 0) ? aRadius : aRadius / 2;
              var xVal = this.calcXOnCircle(rad, degrees);
              var yVal = this.calcYOnCircle(rad, degrees);
              if (ix == 0) {
                aGraphics.moveTo(xVal, yVal);
              } else {
                aGraphics.lineTo(xVal, yVal);
              }
              degrees += angle;
            }
          }

          module.exports = star;
        };
        Program["charts.series.pies.DefaultPieProperties"] = function(module, exports) {
          var Properties = module.import('', 'Properties');
          var tr;
          module.inject = function() {
            tr = module.import('', 'tr');
          };

          var DefaultPieProperties = function(json) {
            // tr.ace_json(json);

            // the user JSON can override any of these:
            var parent = new Properties({
              alpha: 0.5,
              'start-angle': 90,
              'label-colour': null, // null means use colour of the slice
              'font-size': 10,
              'gradient-fill': false,
              stroke: 1,
              colours: ["#900000", "#009000"], // slices colours
              animate: [{
                "type": "fade-in"
              }],
              tip: '#val# of #total#', // #percent#, #label#
              'no-labels': false,
              'on-click': null
            });

            Properties.call(this, json, parent);

            tr.aces('4', this.get('start-angle'));
            // tr.aces('4', this.get('colour'));
            // tr.aces('4', this.get('type'));
          };

          DefaultPieProperties.prototype = Object.create(Properties.prototype);

          module.exports = DefaultPieProperties;
        };
        Program["charts.series.pies.PieLabel"] = function(module, exports) {
          var tr, has_tooltip;
          module.inject = function() {
            tr = module.import('', 'tr');
            has_tooltip = module.import('charts.series', 'has_tooltip');
            PieLabel.TO_RADIANS = Math.PI / 180;
          };

          var PieLabel = function(style) {

            this.text = style.label;
            // legend_tf._rotation = 3.6*value.bar_bottom;

            var fmt = new TextFormat();
            fmt.color = string.Utils.get_colour(style.colour);
            fmt.font = "Verdana";
            fmt.size = style['font-size'];
            fmt.align = "center";
            this.setTextFormat(fmt);
            this.autoSize = "left";

            this.mouseEnabled = false;
          };

          PieLabel.prototype = Object.create(TextField.prototype);

          PieLabel.TO_RADIANS = 0;

          PieLabel.prototype.is_over = false;
          PieLabel.prototype.move_label = function(rad, x, y, ang) {

            //text field position
            var legend_x = x + rad * Math.cos((ang) * PieLabel.TO_RADIANS);
            var legend_y = y + rad * Math.sin((ang) * PieLabel.TO_RADIANS);

            //if legend stands to the right side of the pie
            if (legend_x < x)
              legend_x -= this.width;

            //if legend stands on upper half of the pie
            if (legend_y < y)
              legend_y -= this.height;

            this.x = legend_x;
            this.y = legend_y;

            // does the label fit onto the stage?
            if ((this.x > 0) &&
              (this.y > 0) &&
              (this.y + this.height < this.stage.stageHeight) &&
              (this.x + this.width < this.stage.stageWidth))
              return true;
            else
              return false;
          };
          PieLabel.prototype.get_tooltip = function() {
            tr.ace(((has_tooltip) this.parent).this.get_tooltip());
            return ((has_tooltip) this.parent).this.get_tooltip();
          };
          PieLabel.prototype.get_tip_pos = function() {
            return ((has_tooltip) this.parent).this.get_tip_pos();
          };
          PieLabel.prototype.set_tip = function(b) {
            return ((has_tooltip) this.parent).this.set_tip(b);
          };
          PieLabel.prototype.resize = function(sc) {

          }

          module.exports = PieLabel;
        };
        Program["charts.series.pies.PieSlice"] = function(module, exports) {
          var Element = module.import('charts.series', 'Element');
          var NumberUtils, Equations, Tweener;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            Equations = module.import('caurina.transitions', 'Equations');
            Tweener = module.import('caurina.transitions', 'Tweener');
          };

          var PieSlice = function(index, value) {
            this.position_original = null;
            this.position_animate_to = null;

            this.colour = value.get_colour('colour');
            this.slice_angle = value.get('angle');
            this.border_width = 1;
            this.angle = value.get('start');
            this.animate = value.get('animate');
            this.nolabels = value.get('no-labels');
            this.value = value.get('value');
            this.gradientFill = value.get('gradient-fill');

            this.index = index;
            this.rawToolTip = value.get('tip');

            this.label = this.replace_magic_values(value.get('label'));
            this.tooltip = this.replace_magic_values(value.get('tip'));

            // TODO: why is this commented out in the patch file?
            // this.attach_events();

            if (value.has('on-click'))
              this.set_on_click(value.get('on-click'));

            this.finished_animating = false;
          };

          PieSlice.prototype = Object.create(Element.prototype);

          PieSlice.prototype.TO_RADIANS = Math.PI / 180;
          PieSlice.prototype.colour = 0;
          PieSlice.prototype.slice_angle = 0;
          PieSlice.prototype.border_width = 0;
          PieSlice.prototype.angle = 0;
          PieSlice.prototype.is_over = false;
          PieSlice.prototype.nolabels = false;
          PieSlice.prototype.animate = false;
          PieSlice.prototype.finished_animating = false;
          PieSlice.prototype.value = 0;
          PieSlice.prototype.gradientFill = false;
          PieSlice.prototype.label = null;
          PieSlice.prototype.pieRadius = 0;
          PieSlice.prototype.rawToolTip = null;
          PieSlice.prototype.position_original = null;
          PieSlice.prototype.position_animate_to = null;
          PieSlice.prototype.set_tip = function(b) {};
          PieSlice.prototype.get_tip_pos = function() {
            var p = this.localToGlobal(new flash.geom.Point(this.mouseX, this.mouseY));
            return {
              x: p.x,
              y: p.y
            };
          };
          PieSlice.prototype.replace_magic_values = function(t) {

            t = t.replace('#label#', this.label);
            t = t.replace('#val#', NumberUtils.formatNumber(this.value));
            t = t.replace('#radius#', NumberUtils.formatNumber(this.pieRadius));
            return t;
          };
          PieSlice.prototype.get_tooltip = function() {
            this.tooltip = this.replace_magic_values(this.rawToolTip);
            return this.tooltip;
          };
          PieSlice.prototype.resize = function(sc) {};
          PieSlice.prototype.pie_resize = function(sc, radius) {

            this.pieRadius = radius;
            this.x = sc.get_center_x();
            this.y = sc.get_center_y();

            var label_line_length = 10;

            this.graphics.clear();

            //line from center to edge
            this.graphics.lineStyle(this.border_width, this.colour, 1);
            //this.graphics.lineStyle( 0, 0, 0 );

            //if the user selected the charts to be gradient filled do gradients
            if (this.gradientFill) {
              //set gradient fill
              var colors = [this.colour, this.colour]; // this.colour];
              var alphas = [1, 0.5];
              var ratios = [100, 255];
              var matrix = new Matrix();
              matrix.createGradientBox(radius * 2, radius * 2, 0, -radius, -radius);

              //matrix.createGradientBox(this.stage.stageWidth, this.stage.stageHeight, (3 * Math.PI / 2), -150, 10);

              this.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
            } else
              this.graphics.beginFill(this.colour, 1);

            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(radius, 0);

            var angle = 4;
            var a = Math.tan((angle / 2) * this.TO_RADIANS);

            var i = 0;
            var endx;
            var endy;
            var ax;
            var ay;

            //draw curve segments spaced by angle
            for (i = 0; i + angle < this.slice_angle; i += angle) {
              endx = radius * Math.cos((i + angle) * this.TO_RADIANS);
              endy = radius * Math.sin((i + angle) * this.TO_RADIANS);
              ax = endx + radius * a * Math.cos(((i + angle) - 90) * this.TO_RADIANS);
              ay = endy + radius * a * Math.sin(((i + angle) - 90) * this.TO_RADIANS);
              this.graphics.curveTo(ax, ay, endx, endy);
            }

            //when aproaching end of slice, refine angle interval
            angle = 0.08;
            a = Math.tan((angle / 2) * this.TO_RADIANS);

            for (; i + angle < this.slice_angle; i += angle) {
              endx = radius * Math.cos((i + angle) * this.TO_RADIANS);
              endy = radius * Math.sin((i + angle) * this.TO_RADIANS);
              ax = endx + radius * a * Math.cos(((i + angle) - 90) * this.TO_RADIANS);
              ay = endy + radius * a * Math.sin(((i + angle) - 90) * this.TO_RADIANS);
              this.graphics.curveTo(ax, ay, endx, endy);
            }

            //close slice
            this.graphics.endFill();
            this.graphics.lineTo(0, 0);

            if (!this.nolabels) this.draw_label_line(radius, label_line_length, this.slice_angle);
            // return;

            if (this.animate) {
              if (!this.finished_animating) {
                this.finished_animating = true;
                // have we already rotated this slice?
                Tweener.addTween(this, {
                  rotation: this.angle,
                  time: 1.4,
                  transition: Equations.easeOutCirc,
                  onComplete: this.done_animating
                });
              }
            } else {
              this.done_animating();
            }
          };
          PieSlice.prototype.done_animating = function() {
            this.rotation = this.angle;
            this.finished_animating = true;
          };
          PieSlice.prototype.draw_label_line = function(rad, tick_size, slice_angle) {
            //draw line

            // TODO: why is this commented out?
            //this.graphics.lineStyle( 1, this.colour, 100 );
            //move to center of arc

            // TODO: need this?
            //this.graphics.moveTo(rad*Math.cos(slice_angle/2*TO_RADIANS), rad*Math.sin(slice_angle/2*TO_RADIANS));
            //
            //final line positions
            //var lineEnd_x = (rad+tick_size)*Math.cos(slice_angle/2*TO_RADIANS);
            //var lineEnd_y = (rad+tick_size)*Math.sin(slice_angle/2*TO_RADIANS);
            //this.graphics.lineTo(lineEnd_x, lineEnd_y);
          };
          PieSlice.prototype.toString = function() {
            return "PieSlice: " + this.get_tooltip();
          };
          PieSlice.prototype.getTicAngle = function() {
            return this.angle + (this.slice_angle / 2);
          };
          PieSlice.prototype.isRightSide = function() {
            return (this.getTicAngle() >= 270) || (this.getTicAngle() <= 90);
          };
          PieSlice.prototype.get_colour = function() {
            return this.colour;
          }

          module.exports = PieSlice;
        };
        Program["charts.series.pies.PieSliceContainer"] = function(module, exports) {
          var Element = module.import('charts.series', 'Element');
          var tr, Equations, Tweener, PieLabel, PieSlice;
          module.inject = function() {
            tr = module.import('', 'tr');
            Equations = module.import('caurina.transitions', 'Equations');
            Tweener = module.import('caurina.transitions', 'Tweener');
            PieLabel = module.import('charts.series.pies', 'PieLabel');
            PieSlice = module.import('charts.series.pies', 'PieSlice');
          };

          var PieSliceContainer = function(index, value) {
            this.pieSlice = null;
            this.pieLabel = null;
            //
            // replace magic in the label:
            //
            // value.set('label', this.replace_magic_values( value.get('label') ) );

            tr.aces('pie', value.get('animate'));

            this.pieSlice = new PieSlice(index, value);
            this.addChild(this.pieSlice);
            var textlabel = value.get('label');

            //
            // we set the alpha of the parent container
            //
            this.alpha = this.original_alpha = value.get('alpha');
            //
            if (!value.has('label-colour'))
              value.set('label-colour', value.get('colour'));

            var l = value.get('no-labels') ? '' : value.get('label');

            this.pieLabel = new PieLabel({
              label: l,
              colour: value.get('label-colour'),
              'font-size': value.get('font-size'),
              'on-click': value.get('on-click')
            })
            this.addChild(this.pieLabel);

            this.attach_events__(value);
            this.animating = false;
          };

          PieSliceContainer.prototype = Object.create(Element.prototype);

          PieSliceContainer.prototype.TO_RADIANS = Math.PI / 180;
          PieSliceContainer.prototype.animating = false;
          PieSliceContainer.prototype.pieSlice = null;
          PieSliceContainer.prototype.pieLabel = null;
          PieSliceContainer.prototype.pieRadius = 0;
          PieSliceContainer.prototype.tick_size = 10;
          PieSliceContainer.prototype.tick_extension_size = 4;
          PieSliceContainer.prototype.label_margin = 2;
          PieSliceContainer.prototype.animationOffset = 30;
          PieSliceContainer.prototype.saveX = 0;
          PieSliceContainer.prototype.saveY = 0;
          PieSliceContainer.prototype.moveToX = 0;
          PieSliceContainer.prototype.moveToY = 0;
          PieSliceContainer.prototype.original_alpha = 0;
          PieSliceContainer.prototype.is_over = function() {
            return this.pieSlice.is_over;
          };
          PieSliceContainer.prototype.get_slice = function() {
            return this.pieSlice;
          };
          PieSliceContainer.prototype.get_label = function() {
            return this.pieLabel;
          };
          PieSliceContainer.prototype.resize = function(sc) {};
          PieSliceContainer.prototype.is_label_on_screen = function(sc, slice_radius) {

            return this.pieLabel.move_label(
              slice_radius + 10,
              sc.get_center_x(),
              sc.get_center_y(),
              this.pieSlice.angle + (this.pieSlice.slice_angle / 2));
          };
          PieSliceContainer.prototype.pie_resize = function(sc, slice_radius) {

            this.pieRadius = slice_radius; // save off value for later use
            this.pieSlice.pie_resize(sc, slice_radius);

            var ticAngle = this.getTicAngle();

            this.saveX = this.x;
            this.saveY = this.y;
            this.moveToX = this.x + (this.animationOffset * Math.cos(ticAngle * this.TO_RADIANS));
            this.moveToY = this.y + (this.animationOffset * Math.sin(ticAngle * this.TO_RADIANS));

            if (this.pieLabel.visible) {
              var lblRadius = slice_radius + this.tick_size;
              var lblAngle = ticAngle * this.TO_RADIANS;

              this.pieLabel.x = this.pieSlice.x + lblRadius * Math.cos(lblAngle);
              this.pieLabel.y = this.pieSlice.y + lblRadius * Math.sin(lblAngle);

              if (this.isRightSide()) {
                this.pieLabel.x += this.tick_extension_size + this.label_margin;
              } else {
                //if legend stands to the left side of the pie
                this.pieLabel.x =
                  this.pieLabel.x -
                  this.pieLabel.width -
                  this.tick_extension_size -
                  this.label_margin -
                  4;
              }
              this.pieLabel.y -= this.pieLabel.height / 2;

              this.drawTicLines();
            }
          };
          PieSliceContainer.prototype.get_tooltip = function() {
            return this.pieSlice.get_tooltip();
          };
          PieSliceContainer.prototype.get_tip_pos = function() {
            var p = this.localToGlobal(new flash.geom.Point(this.mouseX, this.mouseY));
            return {
              x: p.x,
              y: p.y
            };
          };
          PieSliceContainer.prototype.attach_events__ = function(value) {

            //
            // TODO: either move this into properties
            //       props.as(Array).get('moo');
            //       or get rid of type checking
            //

            var animate = value.get('animate');
            if (!(animate is Array)) {
              if ((animate == null) || (animate)) {
                animate = [{
                  "type": "bounce",
                  "distance": 5
                }];
              } else {
                animate = [];
              }
            }

            var anims = (Array) animate;
            //
            // end to do
            //

            this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver_first, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut_first, false, 0, true);

            for each(var a in anims) {
              switch (a.type) {

                case "bounce":
                  // weak references so the garbage collector will kill them:
                  this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver_bounce_out, false, 0, true);
                  this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut_bounce_out, false, 0, true);
                  this.animationOffset = a.distance;
                  break;

                default:
                  // weak references so the garbage collector will kill them:
                  this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOver_alpha, false, 0, true);
                  this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOut_alpha, false, 0, true);
                  break;
              }
            }
          };
          PieSliceContainer.prototype.mouseOver_first = function(event) {

            if (this.animating) return;

            this.animating = true;
            Tweener.removeTweens(this);
          };
          PieSliceContainer.prototype.mouseOut_first = function(event) {
            Tweener.removeTweens(this);
            this.animating = false;
          };
          PieSliceContainer.prototype.mouseOver_bounce_out = function(event) {
            Tweener.addTween(this, {
              x: this.moveToX,
              y: this.moveToY,
              time: 0.4,
              transition: "easeOutBounce"
            });
          };
          PieSliceContainer.prototype.mouseOut_bounce_out = function(event) {
            Tweener.addTween(this, {
              x: this.saveX,
              y: this.saveY,
              time: 0.4,
              transition: "easeOutBounce"
            });
          };
          PieSliceContainer.prototype.mouseOver_alpha = function(event) {
            Tweener.addTween(this, {
              alpha: 1,
              time: 0.6,
              transition: Equations.easeOutCirc
            });
          };
          PieSliceContainer.prototype.mouseOut_alpha = function(event) {
            Tweener.addTween(this, {
              alpha: this.original_alpha,
              time: 0.8,
              transition: Equations.easeOutElastic
            });
          };
          PieSliceContainer.prototype.getLabelTopY = function() {
            return this.pieLabel.y;
          };
          PieSliceContainer.prototype.getLabelBottomY = function() {
            return this.pieLabel.y + this.pieLabel.height;
          };
          PieSliceContainer.prototype.moveLabelDown = function(sc, minY) {
            if (this.pieLabel.visible) {
              var bAdjustToBottom = false;
              var lblTop = this.getLabelTopY();

              if (lblTop < minY) {
                // adjustment is positive
                var adjust = minY - lblTop;
                if ((this.pieLabel.height + minY) > (sc.bottom - 1)) {
                  // calc adjust so label bottom is at bottom of screen
                  adjust = sc.bottom - this.pieLabel.height - lblTop;
                  bAdjustToBottom = true;
                }
                // Adjust the Y value
                this.pieLabel.y += adjust;

                if (!bAdjustToBottom) {
                  var lblRadius = this.pieRadius + this.tick_size;
                  var calcSin = ((this.pieLabel.y + this.pieLabel.height / 2) - this.pieSlice.y) / lblRadius;
                  calcSin = Math.max(-1, Math.min(1, calcSin));
                  var newAngle = Math.asin(calcSin) / this.TO_RADIANS;

                  if ((this.getTicAngle() > 90) && (this.getTicAngle() < 270)) {
                    newAngle = 180 - newAngle;
                  } else if (this.getTicAngle() >= 270) {
                    newAngle = 360 + newAngle;
                  }

                  var newX = this.pieSlice.x + lblRadius * Math.cos(newAngle * this.TO_RADIANS);
                  if (this.isRightSide()) {
                    this.pieLabel.x = newX + this.tick_extension_size + this.label_margin;
                  } else {
                    //if legend stands to the left side of the pie
                    this.pieLabel.x = newX - this.pieLabel.width -
                      this.tick_extension_size - this.label_margin - 4;
                  }
                }
              }
              this.drawTicLines();

              return this.pieLabel.y + this.pieLabel.height;
            } else {
              return minY;
            }
          };
          PieSliceContainer.prototype.moveLabelUp = function(sc, maxY) {
            if (this.pieLabel.visible) {
              var sign = 1;
              var bAdjustToTop = false;
              var lblBottom = this.getLabelBottomY();
              if (lblBottom > maxY) {
                // adjustment is negative here
                var adjust = maxY - lblBottom;
                if ((maxY - this.pieLabel.height) < (sc.top + 1)) {
                  // calc adjust so label top is at top of screen
                  adjust = sc.top - this.getLabelTopY();
                  bAdjustToTop = true;
                }
                // Adjust the Y value
                this.pieLabel.y += adjust;

                if (!bAdjustToTop) {
                  var lblRadius = this.pieRadius + this.tick_size;
                  var calcSin = ((this.pieLabel.y + this.pieLabel.height / 2) - this.pieSlice.y) / lblRadius;
                  calcSin = Math.max(-1, Math.min(1, calcSin));
                  var newAngle = Math.asin(calcSin) / this.TO_RADIANS;

                  if ((this.getTicAngle() > 90) && (this.getTicAngle() < 270)) {
                    newAngle = 180 - newAngle;
                    sign = -1;
                  } else if (this.getTicAngle() >= 270) {
                    newAngle = 360 + newAngle;
                  }

                  var newX = this.pieSlice.x + lblRadius * Math.cos(newAngle * this.TO_RADIANS);
                  if (this.isRightSide()) {
                    this.pieLabel.x = newX + this.tick_extension_size + this.label_margin;
                  } else {
                    //if legend stands to the left side of the pie
                    this.pieLabel.x = newX - this.pieLabel.width -
                      this.tick_extension_size - this.label_margin - 4;
                  }
                }
              }
              this.drawTicLines();

              return this.pieLabel.y;
            } else {
              return maxY;
            }
          };
          PieSliceContainer.prototype.get_radius_offsets = function() {
            // Update the label text here in case pie slices change dynamically
            //var lblText = this.getText();
            //this.myPieLabel.setText(lblText);

            var offset = {
              top: this.animationOffset,
              right: this.animationOffset,
              bottom: this.animationOffset,
              left: this.animationOffset
            };
            if (this.pieLabel.visible) {
              var ticAngle = this.getTicAngle();
              var offset_threshold = 20;
              var ticLength = this.tick_size;

              if ((ticAngle >= 0) && (ticAngle <= 90)) {
                offset.bottom = (ticAngle / 90) * ticLength + this.pieLabel.height / 2 + 1;
                offset.right = ((90 - ticAngle) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width;
              } else if ((ticAngle > 90) && (ticAngle <= 180)) {
                offset.bottom = ((180 - ticAngle) / 90) * ticLength + this.pieLabel.height / 2 + 1;
                offset.left = ((ticAngle - 90) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width + 4;
              } else if ((ticAngle > 180) && (ticAngle < 270)) {
                offset.top = ((ticAngle - 180) / 90) * ticLength + this.pieLabel.height / 2 + 1;
                offset.left = ((270 - ticAngle) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width + 4;
              } else // if ((ticAngle >= 270) && (ticAngle <= 360)) 
              {
                offset.top = ((360 - ticAngle) / 90) * ticLength + this.pieLabel.height / 2 + 1;
                offset.right = ((ticAngle - 270) / 90) * ticLength + this.tick_extension_size + this.label_margin + this.pieLabel.width;
              }
            }
            return offset;
          };
          PieSliceContainer.prototype.drawTicLines = function() {
            if ((this.pieLabel.text != '') && (this.pieLabel.visible)) {
              var ticAngle = this.getTicAngle();

              var lblRadius = this.pieRadius + this.tick_size;
              var lblAngle = ticAngle * this.TO_RADIANS;

              var ticLblX;
              var ticLblY;
              if (this.pieSlice.isRightSide()) {
                ticLblX = this.pieLabel.x - this.label_margin;
              } else {
                //if legend stands to the left side of the pie
                ticLblX = this.pieLabel.x + this.pieLabel.width + this.label_margin + 4;
              }
              ticLblY = this.pieLabel.y + this.pieLabel.height / 2;

              var ticArcX = this.pieSlice.x + this.pieRadius * Math.cos(lblAngle);
              var ticArcY = this.pieSlice.y + this.pieRadius * Math.sin(lblAngle);

              // Draw the line from the slice to the label
              this.graphics.clear();
              this.graphics.lineStyle(1, this.pieSlice.get_colour(), 1);

              // move to the end of the tic closest to the label
              this.graphics.moveTo(ticLblX, ticLblY);
              // draw a line the length of the tic extender
              if (this.pieSlice.isRightSide()) {
                this.graphics.lineTo(ticLblX - this.tick_extension_size, ticLblY);
              } else {
                this.graphics.lineTo(ticLblX + this.tick_extension_size, ticLblY);
              }
              // Draw a line from the end of the tic extender to the arc
              this.graphics.lineTo(ticArcX, ticArcY);
            }
          };
          PieSliceContainer.prototype.getTicAngle = function() {
            return this.pieSlice.getTicAngle();
          };
          PieSliceContainer.prototype.isRightSide = function() {
            return this.pieSlice.isRightSide();
          }

          module.exports = PieSliceContainer;
        };
        Program["charts.series.tags.Tag"] = function(module, exports) {
          var NumberUtils, tr, Utils;
          module.inject = function() {
            NumberUtils = module.import('', 'NumberUtils');
            tr = module.import('', 'tr');
            Utils = module.import('string', 'Utils');
          };

          var Tag = function(style) {

            this._x = style.x;
            this._y = style.y;
            this.right_axis = (style.axis == 'right');

            if (style['on-click'])
              this.set_on_click(style['on-click']);

            //this.text = this.replace_magic_values(style.text);
            this.htmlText = this.replace_magic_values(style.text);
            this.autoSize = "left";
            this.alpha = style.alpha;
            this.border = style.border;

            if (style.background != null) {
              this.background = true;
              this.backgroundColor = Utils.get_colour(style.background);
            }

            var fmt = new TextFormat();
            if (style.rotate != 0) {
              fmt.font = "spArial";
              this.embedFonts = true;
            } else {
              fmt.font = style.font;
            }
            fmt.color = style.colour;
            fmt.size = style['font-size'];
            fmt.bold = style.bold;
            fmt.underline = style.underline;
            fmt.align = "center";
            this.setTextFormat(fmt);

            //CursorManager.setCursor(HandCursor);

            // prevents bar cursor but still clickable 
            // Hoping to figure out how to change the cursor
            this.selectable = false;
            this.rotate_and_align(style.rotate, style['align-x'], style['align-y'], style['pad-x'], style['pad-y']);

          };

          Tag.prototype = Object.create(TextField.prototype);

          Tag.prototype._x = 0;
          Tag.prototype._y = 0;
          Tag.prototype.xAdj = 0;
          Tag.prototype.yAdj = 0;
          Tag.prototype.link = null;
          Tag.prototype.index = 0;
          Tag.prototype.right_axis = false;
          Tag.prototype.rotate_and_align = function(rotation, xAlign, yAlign, xPad, yPad) {
            rotation = rotation % 360;
            if (rotation < 0) rotation += 360;
            this.rotation = rotation;

            // NOTE: Calculations only work for 0, 90, 180, 270 and 360 at the moment
            //       Hopefully I can figure out the calculations for the other angles :(

            var myright = this.width * Math.cos(rotation * Math.PI / 180);
            var myleft = this.height * Math.cos((90 - rotation) * Math.PI / 180);
            var mytop = this.height * Math.sin((90 - rotation) * Math.PI / 180);
            var mybottom = this.width * Math.sin(rotation * Math.PI / 180);

            trace("rotation=", rotation, "width=", this.width, "left=", myleft, "right=", myright);
            trace("rotation=", rotation, "height=", this.height, "top=", mytop, "bottom=", mybottom);

            if (xAlign == "right") {
              switch (rotation) {
                case 0:
                  this.xAdj = 0;
                  break;
                case 90:
                  this.xAdj = this.width;
                  break;
                case 180:
                  this.xAdj = this.width;
                  break;
                case 270:
                  this.xAdj = 0;
                  break;
              }
              this.xAdj = this.xAdj + xPad;
            } else if (xAlign == "left") {
              switch (rotation) {
                case 0:
                  this.xAdj = -this.width;
                  break;
                case 90:
                  this.xAdj = 0;
                  break;
                case 180:
                  this.xAdj = 0;
                  break;
                case 270:
                  this.xAdj = -this.width;
                  break;
              }
              this.xAdj = this.xAdj - xPad;
            } else {
              // default to align center
              switch (rotation) {
                case 0:
                  this.xAdj = -this.width / 2;
                  break;
                case 90:
                  this.xAdj = this.width / 2;
                  break;
                case 180:
                  this.xAdj = this.width / 2;
                  break;
                case 270:
                  this.xAdj = -this.width / 2;
                  break;
              }
            }

            if (yAlign == "center") {
              switch (rotation) {
                case 0:
                  this.yAdj = -this.height / 2;
                  break;
                case 90:
                  this.yAdj = -this.height / 2;
                  break;
                case 180:
                  this.yAdj = this.height / 2;
                  break;
                case 270:
                  this.yAdj = this.height / 2;
                  break;
              }
            } else if (yAlign == "below") {
              switch (rotation) {
                case 0:
                  this.yAdj = 0;
                  break;
                case 90:
                  this.yAdj = 0;
                  break;
                case 180:
                  this.yAdj = this.height;
                  break;
                case 270:
                  this.yAdj = this.height;
                  break;
              }
              this.yAdj = this.yAdj + yPad;
            } else {
              // default to align above
              switch (rotation) {
                case 0:
                  this.yAdj = -this.height;
                  break;
                case 90:
                  this.yAdj = -this.height;
                  break;
                case 180:
                  this.yAdj = 0;
                  break;
                case 270:
                  this.yAdj = 0;
                  break;
              }
              this.yAdj = this.yAdj - yPad;
            }
          };
          Tag.prototype.replace_magic_values = function(t) {
            var regex = /#x#/g;
            t = t.replace(regex, NumberUtils.formatNumber(this._x));
            regex = /#y#/g;
            t = t.replace('#y#', NumberUtils.formatNumber(this._y));
            t = string.DateUtils.replace_magic_values(t, this._x);
            regex = /#ygmdate/g;
            t = t.replace(regex, '#gmdate');
            regex = /#ydate/g;
            t = t.replace('#ydate', '#date');
            t = string.DateUtils.replace_magic_values(t, this._y);
            return t;
          };
          Tag.prototype.set_on_click = function(s) {
            this.link = s;
            // this.buttonMode = true;
            // this.useHandCursor = true;

            // weak references so the garbage collector will kill it:
            this.addEventListener(MouseEvent.MOUSE_UP, this.mouseUp, false, 0, true);
          };
          Tag.prototype.mouseUp = function(event) {

            if (this.link.substring(0, 6) == 'trace:') {
              // for the test JSON files:
              tr.ace(this.link);
            } else if (this.link.substring(0, 5) == 'http:')
              this.browse_url(this.link);
            else
              ExternalInterface.call(this.link, this._x);
          };
          Tag.prototype.browse_url = function(url) {
            var req = new URLRequest(this.link);
            try {
              navigateToURL(req);
            } catch (e: Error) {
              trace("Error opening link: " + this.link);
            }
          };
          Tag.prototype.resize = function(sc) {
            // adjust by 2 for the offset between the textfield border and 
            // where text actually is
            this.x = sc.get_x_from_val(this._x) + this.xAdj;
            this.y = sc.get_y_from_val(this._y, this.right_axis) + this.yAdj;
          }

          module.exports = Tag;
        };
        Program["com.adobe.crypto.MD5"] = function(module, exports) {
          var IntUtil;
          module.inject = function() {
            IntUtil = module.import('com.adobe.utils', 'IntUtil');
          };

          var MD5 = function MD5() {};

          MD5.hash = function(s) {
            // initialize the md buffers
            var a = 1732584193;
            var b = -271733879;
            var c = -1732584194;
            var d = 271733878;

            // variables to store previous values
            var aa;
            var bb;
            var cc;
            var dd;

            // create the blocks from the string and
            // save the length as a local var to reduce
            // lookup in the loop below
            var x = MD5.createBlocks(s);
            var len = x.length;

            // loop over all of the blocks
            for (var i = 0; i < len; i += 16) {
              // save previous values
              aa = a;
              bb = b;
              cc = c;
              dd = d;

              // Round 1
              a = MD5.ff(a, b, c, d, x[i + 0], 7, -680876936); // 1
              d = MD5.ff(d, a, b, c, x[i + 1], 12, -389564586); // 2
              c = MD5.ff(c, d, a, b, x[i + 2], 17, 606105819); // 3
              b = MD5.ff(b, c, d, a, x[i + 3], 22, -1044525330); // 4
              a = MD5.ff(a, b, c, d, x[i + 4], 7, -176418897); // 5
              d = MD5.ff(d, a, b, c, x[i + 5], 12, 1200080426); // 6
              c = MD5.ff(c, d, a, b, x[i + 6], 17, -1473231341); // 7
              b = MD5.ff(b, c, d, a, x[i + 7], 22, -45705983); // 8
              a = MD5.ff(a, b, c, d, x[i + 8], 7, 1770035416); // 9
              d = MD5.ff(d, a, b, c, x[i + 9], 12, -1958414417); // 10
              c = MD5.ff(c, d, a, b, x[i + 10], 17, -42063); // 11
              b = MD5.ff(b, c, d, a, x[i + 11], 22, -1990404162); // 12
              a = MD5.ff(a, b, c, d, x[i + 12], 7, 1804603682); // 13
              d = MD5.ff(d, a, b, c, x[i + 13], 12, -40341101); // 14
              c = MD5.ff(c, d, a, b, x[i + 14], 17, -1502002290); // 15
              b = MD5.ff(b, c, d, a, x[i + 15], 22, 1236535329); // 16

              // Round 2
              a = MD5.gg(a, b, c, d, x[i + 1], 5, -165796510); // 17
              d = MD5.gg(d, a, b, c, x[i + 6], 9, -1069501632); // 18
              c = MD5.gg(c, d, a, b, x[i + 11], 14, 643717713); // 19
              b = MD5.gg(b, c, d, a, x[i + 0], 20, -373897302); // 20
              a = MD5.gg(a, b, c, d, x[i + 5], 5, -701558691); // 21
              d = MD5.gg(d, a, b, c, x[i + 10], 9, 38016083); // 22
              c = MD5.gg(c, d, a, b, x[i + 15], 14, -660478335); // 23
              b = MD5.gg(b, c, d, a, x[i + 4], 20, -405537848); // 24
              a = MD5.gg(a, b, c, d, x[i + 9], 5, 568446438); // 25
              d = MD5.gg(d, a, b, c, x[i + 14], 9, -1019803690); // 26
              c = MD5.gg(c, d, a, b, x[i + 3], 14, -187363961); // 27
              b = MD5.gg(b, c, d, a, x[i + 8], 20, 1163531501); // 28
              a = MD5.gg(a, b, c, d, x[i + 13], 5, -1444681467); // 29
              d = MD5.gg(d, a, b, c, x[i + 2], 9, -51403784); // 30
              c = MD5.gg(c, d, a, b, x[i + 7], 14, 1735328473); // 31
              b = MD5.gg(b, c, d, a, x[i + 12], 20, -1926607734); // 32

              // Round 3
              a = MD5.hh(a, b, c, d, x[i + 5], 4, -378558); // 33
              d = MD5.hh(d, a, b, c, x[i + 8], 11, -2022574463); // 34
              c = MD5.hh(c, d, a, b, x[i + 11], 16, 1839030562); // 35
              b = MD5.hh(b, c, d, a, x[i + 14], 23, -35309556); // 36
              a = MD5.hh(a, b, c, d, x[i + 1], 4, -1530992060); // 37
              d = MD5.hh(d, a, b, c, x[i + 4], 11, 1272893353); // 38
              c = MD5.hh(c, d, a, b, x[i + 7], 16, -155497632); // 39
              b = MD5.hh(b, c, d, a, x[i + 10], 23, -1094730640); // 40
              a = MD5.hh(a, b, c, d, x[i + 13], 4, 681279174); // 41
              d = MD5.hh(d, a, b, c, x[i + 0], 11, -358537222); // 42
              c = MD5.hh(c, d, a, b, x[i + 3], 16, -722521979); // 43
              b = MD5.hh(b, c, d, a, x[i + 6], 23, 76029189); // 44
              a = MD5.hh(a, b, c, d, x[i + 9], 4, -640364487); // 45
              d = MD5.hh(d, a, b, c, x[i + 12], 11, -421815835); // 46
              c = MD5.hh(c, d, a, b, x[i + 15], 16, 530742520); // 47
              b = MD5.hh(b, c, d, a, x[i + 2], 23, -995338651); // 48

              // Round 4
              a = MD5.ii(a, b, c, d, x[i + 0], 6, -198630844); // 49
              d = MD5.ii(d, a, b, c, x[i + 7], 10, 1126891415); // 50
              c = MD5.ii(c, d, a, b, x[i + 14], 15, -1416354905); // 51
              b = MD5.ii(b, c, d, a, x[i + 5], 21, -57434055); // 52
              a = MD5.ii(a, b, c, d, x[i + 12], 6, 1700485571); // 53
              d = MD5.ii(d, a, b, c, x[i + 3], 10, -1894986606); // 54
              c = MD5.ii(c, d, a, b, x[i + 10], 15, -1051523); // 55
              b = MD5.ii(b, c, d, a, x[i + 1], 21, -2054922799); // 56
              a = MD5.ii(a, b, c, d, x[i + 8], 6, 1873313359); // 57
              d = MD5.ii(d, a, b, c, x[i + 15], 10, -30611744); // 58
              c = MD5.ii(c, d, a, b, x[i + 6], 15, -1560198380); // 59
              b = MD5.ii(b, c, d, a, x[i + 13], 21, 1309151649); // 60
              a = MD5.ii(a, b, c, d, x[i + 4], 6, -145523070); // 61
              d = MD5.ii(d, a, b, c, x[i + 11], 10, -1120210379); // 62
              c = MD5.ii(c, d, a, b, x[i + 2], 15, 718787259); // 63
              b = MD5.ii(b, c, d, a, x[i + 9], 21, -343485551); // 64

              a += aa;
              b += bb;
              c += cc;
              d += dd;
            }

            // Finish up by concatening the buffers with their hex output
            return IntUtil.toHex(a) + IntUtil.toHex(b) + IntUtil.toHex(c) + IntUtil.toHex(d);
          };
          MD5.f = function(x, y, z) {
            return (x & y) | ((~x) & z);
          };
          MD5.g = function(x, y, z) {
            return (x & z) | (y & (~z));
          };
          MD5.h = function(x, y, z) {
            return x ^ y ^ z;
          };
          MD5.i = function(x, y, z) {
            return y ^ (x | (~z));
          };
          MD5.transform = function(func, a, b, c, d, x, s, t) {
            var tmp = a + int(func(b, c, d)) + x + t;
            return IntUtil.rol(tmp, s) + b;
          };
          MD5.ff = function(a, b, c, d, x, s, t) {
            return MD5.transform(MD5.f, a, b, c, d, x, s, t);
          };
          MD5.gg = function(a, b, c, d, x, s, t) {
            return MD5.transform(MD5.g, a, b, c, d, x, s, t);
          };
          MD5.hh = function(a, b, c, d, x, s, t) {
            return MD5.transform(MD5.h, a, b, c, d, x, s, t);
          };
          MD5.ii = function(a, b, c, d, x, s, t) {
            return MD5.transform(MD5.i, a, b, c, d, x, s, t);
          };
          MD5.createBlocks = function(s) {
            var blocks = [];
            var len = s.length * 8;
            var mask = 0xFF; // ignore hi byte of characters > 0xFF
            for (var i = 0; i < len; i += 8) {
              blocks[i >> 5] |= (s.charCodeAt(i / 8) & mask) << (i % 32);
            }

            // append padding and length
            blocks[len >> 5] |= 0x80 << (len % 32);
            blocks[(((len + 64) >>> 9) << 4) + 14] = len;
            return blocks;
          };

          module.exports = MD5;
        };
        Program["com.adobe.crypto.SHA1"] = function(module, exports) {
          var IntUtil;
          module.inject = function() {
            IntUtil = module.import('com.adobe.utils', 'IntUtil');
          };

          var SHA1 = function SHA1() {};

          SHA1.hash = function(s) {
            var blocks = SHA1.createBlocksFromString(s);
            var byteArray = SHA1.hashBlocks(blocks);

            return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true);
          };
          SHA1.hashBytes = function(data) {
            var blocks = SHA1.createBlocksFromByteArray(data);
            var byteArray = SHA1.hashBlocks(blocks);

            return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true);
          };
          SHA1.hashToBase64 = function(s) {
            var blocks = SHA1.createBlocksFromString(s);
            var byteArray = SHA1.hashBlocks(blocks);

            // ByteArray.toString() returns the contents as a UTF-8 string,
            // which we can't use because certain byte sequences might trigger
            // a UTF-8 conversion.  Instead, we convert the bytes to characters
            // one by one.
            var charsInByteArray = "";
            byteArray.position = 0;
            for (var j = 0; j < byteArray.length; j++) {
              var byte = byteArray.readUnsignedByte();
              charsInByteArray += String.fromCharCode(byte);
            }

            var encoder = new Base64Encoder();
            encoder.encode(charsInByteArray);
            return encoder.flush();
          };
          SHA1.hashBlocks = function(blocks) {
            // initialize the h's
            var h0 = 0x67452301;
            var h1 = 0xefcdab89;
            var h2 = 0x98badcfe;
            var h3 = 0x10325476;
            var h4 = 0xc3d2e1f0;

            var len = blocks.length;
            var w = AS3JS.Utils.createArray(8, null);

            // loop over all of the blocks
            for (var i = 0; i < len; i += 16) {

              // 6.1.c
              var a = h0;
              var b = h1;
              var c = h2;
              var d = h3;
              var e = h4;

              // 80 steps to process each block
              // TODO: unroll for faster execution, or 4 loops of
              // 20 each to avoid the k and f function calls
              for (var t = 0; t < 80; t++) {

                if (t < 16) {
                  // 6.1.a
                  w[t] = blocks[i + t];
                } else {
                  // 6.1.b
                  w[t] = IntUtil.rol(w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16], 1);
                }

                // 6.1.d
                var temp = IntUtil.rol(a, 5) + SHA1.f(t, b, c, d) + e + int(w[t]) + SHA1.k(t);

                e = d;
                d = c;
                c = IntUtil.rol(b, 30);
                b = a;
                a = temp;
              }

              // 6.1.e
              h0 += a;
              h1 += b;
              h2 += c;
              h3 += d;
              h4 += e;
            }

            var byteArray = new ByteArray();
            byteArray.writeInt(h0);
            byteArray.writeInt(h1);
            byteArray.writeInt(h2);
            byteArray.writeInt(h3);
            byteArray.writeInt(h4);
            byteArray.position = 0;
            return byteArray;
          };
          SHA1.f = function(t, b, c, d) {
            if (t < 20) {
              return (b & c) | (~b & d);
            } else if (t < 40) {
              return b ^ c ^ d;
            } else if (t < 60) {
              return (b & c) | (b & d) | (c & d);
            }
            return b ^ c ^ d;
          };
          SHA1.k = function(t) {
            if (t < 20) {
              return 0x5a827999;
            } else if (t < 40) {
              return 0x6ed9eba1;
            } else if (t < 60) {
              return 0x8f1bbcdc;
            }
            return 0xca62c1d6;
          };
          SHA1.createBlocksFromByteArray = function(data) {
            var oldPosition = data.position;
            data.position = 0;

            var blocks = [];
            var len = data.length * 8;
            var mask = 0xFF; // ignore hi byte of characters > 0xFF
            for (var i = 0; i < len; i += 8) {
              blocks[i >> 5] |= (data.readByte() & mask) << (24 - i % 32);
            }

            // append padding and length
            blocks[len >> 5] |= 0x80 << (24 - len % 32);
            blocks[(((len + 64) >> 9) << 4) + 15] = len;

            data.position = oldPosition;

            return blocks;
          };
          SHA1.createBlocksFromString = function(s) {
            var blocks = [];
            var len = s.length * 8;
            var mask = 0xFF; // ignore hi byte of characters > 0xFF
            for (var i = 0; i < len; i += 8) {
              blocks[i >> 5] |= (s.charCodeAt(i / 8) & mask) << (24 - i % 32);
            }

            // append padding and length
            blocks[len >> 5] |= 0x80 << (24 - len % 32);
            blocks[(((len + 64) >> 9) << 4) + 15] = len;
            return blocks;
          };

          module.exports = SHA1;
        };
        Program["com.adobe.crypto.SHA224"] = function(module, exports) {
          var IntUtil;
          module.inject = function() {
            IntUtil = module.import('com.adobe.utils', 'IntUtil');
          };

          var SHA224 = function SHA224() {};

          SHA224.hash = function(s) {
            var blocks = SHA224.createBlocksFromString(s);
            var byteArray = SHA224.hashBlocks(blocks);
            return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true);
          };
          SHA224.hashBytes = function(data) {
            var blocks = SHA224.createBlocksFromByteArray(data);
            var byteArray = SHA224.hashBlocks(blocks);
            return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true);
          };
          SHA224.hashToBase64 = function(s) {
            var blocks = SHA224.createBlocksFromString(s);
            var byteArray = SHA224.hashBlocks(blocks);

            // ByteArray.toString() returns the contents as a UTF-8 string,
            // which we can't use because certain byte sequences might trigger
            // a UTF-8 conversion.  Instead, we convert the bytes to characters
            // one by one.
            var charsInByteArray = "";
            byteArray.position = 0;
            for (var j = 0; j < byteArray.length; j++) {
              var byte = byteArray.readUnsignedByte();
              charsInByteArray += String.fromCharCode(byte);
            }

            var encoder = new Base64Encoder();
            encoder.encode(charsInByteArray);
            return encoder.flush();
          };
          SHA224.hashBlocks = function(blocks) {
            var h0 = 0xc1059ed8;
            var h1 = 0x367cd507;
            var h2 = 0x3070dd17;
            var h3 = 0xf70e5939;
            var h4 = 0xffc00b31;
            var h5 = 0x68581511;
            var h6 = 0x64f98fa7;
            var h7 = 0xbefa4fa4;

            var k = AS3JS.Utils.createArray(0, null);

            var len = blocks.length;
            var w = [];

            // loop over all of the blocks
            for (var i = 0; i < len; i += 16) {

              var a = h0;
              var b = h1;
              var c = h2;
              var d = h3;
              var e = h4;
              var f = h5;
              var g = h6;
              var h = h7;

              for (var t = 0; t < 64; t++) {

                if (t < 16) {
                  w[t] = blocks[i + t];
                  if (isNaN(w[t])) {
                    w[t] = 0;
                  }
                } else {
                  var ws0 = IntUtil.ror(w[t - 15], 7) ^ IntUtil.ror(w[t - 15], 18) ^ (w[t - 15] >>> 3);
                  var ws1 = IntUtil.ror(w[t - 2], 17) ^ IntUtil.ror(w[t - 2], 19) ^ (w[t - 2] >>> 10);
                  w[t] = w[t - 16] + ws0 + w[t - 7] + ws1;
                }

                var s0 = IntUtil.ror(a, 2) ^ IntUtil.ror(a, 13) ^ IntUtil.ror(a, 22);
                var maj = (a & b) ^ (a & c) ^ (b & c);
                var t2 = s0 + maj;
                var s1 = IntUtil.ror(e, 6) ^ IntUtil.ror(e, 11) ^ IntUtil.ror(e, 25);
                var ch = (e & f) ^ ((~e) & g);
                var t1 = h + s1 + ch + k[t] + w[t];

                h = g;
                g = f;
                f = e;
                e = d + t1;
                d = c;
                c = b;
                b = a;
                a = t1 + t2;
              }

              //Add this chunk's hash to result so far:
              h0 += a;
              h1 += b;
              h2 += c;
              h3 += d;
              h4 += e;
              h5 += f;
              h6 += g;
              h7 += h;
            }

            var byteArray = new ByteArray();
            byteArray.writeInt(h0);
            byteArray.writeInt(h1);
            byteArray.writeInt(h2);
            byteArray.writeInt(h3);
            byteArray.writeInt(h4);
            byteArray.writeInt(h5);
            byteArray.writeInt(h6);
            byteArray.position = 0;
            return byteArray;
          };
          SHA224.createBlocksFromByteArray = function(data) {
            var oldPosition = data.position;
            data.position = 0;

            var blocks = [];
            var len = data.length * 8;
            var mask = 0xFF; // ignore hi byte of characters > 0xFF
            for (var i = 0; i < len; i += 8) {
              blocks[i >> 5] |= (data.readByte() & mask) << (24 - i % 32);
            }

            // append padding and length
            blocks[len >> 5] |= 0x80 << (24 - len % 32);
            blocks[(((len + 64) >> 9) << 4) + 15] = len;

            data.position = oldPosition;

            return blocks;
          };
          SHA224.createBlocksFromString = function(s) {
            var blocks = [];
            var len = s.length * 8;
            var mask = 0xFF; // ignore hi byte of characters > 0xFF
            for (var i = 0; i < len; i += 8) {
              blocks[i >> 5] |= (s.charCodeAt(i / 8) & mask) << (24 - i % 32);
            }

            // append padding and length
            blocks[len >> 5] |= 0x80 << (24 - len % 32);
            blocks[(((len + 64) >> 9) << 4) + 15] = len;
            return blocks;
          };

          module.exports = SHA224;
        };
        Program["com.adobe.crypto.SHA256"] = function(module, exports) {
          var IntUtil;
          module.inject = function() {
            IntUtil = module.import('com.adobe.utils', 'IntUtil');
          };

          var SHA256 = function SHA256() {};

          SHA256.hash = function(s) {
            var blocks = SHA256.createBlocksFromString(s);
            var byteArray = SHA256.hashBlocks(blocks);

            return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true);
          };
          SHA256.hashBytes = function(data) {
            var blocks = SHA256.createBlocksFromByteArray(data);
            var byteArray = SHA256.hashBlocks(blocks);

            return IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true) + IntUtil.toHex(byteArray.readInt(), true);
          };
          SHA256.hashToBase64 = function(s) {
            var blocks = SHA256.createBlocksFromString(s);
            var byteArray = SHA256.hashBlocks(blocks);

            // ByteArray.toString() returns the contents as a UTF-8 string,
            // which we can't use because certain byte sequences might trigger
            // a UTF-8 conversion.  Instead, we convert the bytes to characters
            // one by one.
            var charsInByteArray = "";
            byteArray.position = 0;
            for (var j = 0; j < byteArray.length; j++) {
              var byte = byteArray.readUnsignedByte();
              charsInByteArray += String.fromCharCode(byte);
            }

            var encoder = new Base64Encoder();
            encoder.encode(charsInByteArray);
            return encoder.flush();
          };
          SHA256.hashBlocks = function(blocks) {
            var h0 = 0x6a09e667;
            var h1 = 0xbb67ae85;
            var h2 = 0x3c6ef372;
            var h3 = 0xa54ff53a;
            var h4 = 0x510e527f;
            var h5 = 0x9b05688c;
            var h6 = 0x1f83d9ab;
            var h7 = 0x5be0cd19;

            var k = AS3JS.Utils.createArray(0, null);

            var len = blocks.length;
            var w = AS3JS.Utils.createArray(6, null);

            // loop over all of the blocks
            for (var i = 0; i < len; i += 16) {

              var a = h0;
              var b = h1;
              var c = h2;
              var d = h3;
              var e = h4;
              var f = h5;
              var g = h6;
              var h = h7;

              for (var t = 0; t < 64; t++) {

                if (t < 16) {
                  w[t] = blocks[i + t];
                  if (isNaN(w[t])) {
                    w[t] = 0;
                  }
                } else {
                  var ws0 = IntUtil.ror(w[t - 15], 7) ^ IntUtil.ror(w[t - 15], 18) ^ (w[t - 15] >>> 3);
                  var ws1 = IntUtil.ror(w[t - 2], 17) ^ IntUtil.ror(w[t - 2], 19) ^ (w[t - 2] >>> 10);
                  w[t] = w[t - 16] + ws0 + w[t - 7] + ws1;
                }

                var s0 = IntUtil.ror(a, 2) ^ IntUtil.ror(a, 13) ^ IntUtil.ror(a, 22);
                var maj = (a & b) ^ (a & c) ^ (b & c);
                var t2 = s0 + maj;
                var s1 = IntUtil.ror(e, 6) ^ IntUtil.ror(e, 11) ^ IntUtil.ror(e, 25);
                var ch = (e & f) ^ ((~e) & g);
                var t1 = h + s1 + ch + k[t] + w[t];

                h = g;
                g = f;
                f = e;
                e = d + t1;
                d = c;
                c = b;
                b = a;
                a = t1 + t2;
              }

              //Add this chunk's hash to result so far:
              h0 += a;
              h1 += b;
              h2 += c;
              h3 += d;
              h4 += e;
              h5 += f;
              h6 += g;
              h7 += h;
            }

            var byteArray = new ByteArray();
            byteArray.writeInt(h0);
            byteArray.writeInt(h1);
            byteArray.writeInt(h2);
            byteArray.writeInt(h3);
            byteArray.writeInt(h4);
            byteArray.writeInt(h5);
            byteArray.writeInt(h6);
            byteArray.writeInt(h7);
            byteArray.position = 0;
            return byteArray;
          };
          SHA256.createBlocksFromByteArray = function(data) {
            var oldPosition = data.position;
            data.position = 0;

            var blocks = [];
            var len = data.length * 8;
            var mask = 0xFF; // ignore hi byte of characters > 0xFF
            for (var i = 0; i < len; i += 8) {
              blocks[i >> 5] |= (data.readByte() & mask) << (24 - i % 32);
            }

            // append padding and length
            blocks[len >> 5] |= 0x80 << (24 - len % 32);
            blocks[(((len + 64) >> 9) << 4) + 15] = len;

            data.position = oldPosition;

            return blocks;
          };
          SHA256.createBlocksFromString = function(s) {
            var blocks = [];
            var len = s.length * 8;
            var mask = 0xFF; // ignore hi byte of characters > 0xFF
            for (var i = 0; i < len; i += 8) {
              blocks[i >> 5] |= (s.charCodeAt(i / 8) & mask) << (24 - i % 32);
            }

            // append padding and length
            blocks[len >> 5] |= 0x80 << (24 - len % 32);
            blocks[(((len + 64) >> 9) << 4) + 15] = len;
            return blocks;
          };

          module.exports = SHA256;
        };
        Program["com.adobe.crypto.WSSEUsernameToken"] = function(module, exports) {
          var SHA1;
          module.inject = function() {
            SHA1 = module.import('com.adobe.crypto', 'SHA1');
          };

          var WSSEUsernameToken = function WSSEUsernameToken() {};

          WSSEUsernameToken.getUsernameToken = function(username, password, nonce, timestamp) {
            nonce = AS3JS.Utils.getDefaultValue(nonce, null);
            timestamp = AS3JS.Utils.getDefaultValue(timestamp, null);
            if (nonce == null) {
              nonce = WSSEUsernameToken.generateNonce();
            }
            nonce = WSSEUsernameToken.base64Encode(nonce);

            var created = WSSEUsernameToken.generateTimestamp(timestamp);

            var password64 = WSSEUsernameToken.getBase64Digest(nonce,
              created,
              password);

            var token = new String("UsernameToken Username=\"");
            token += username + "\", " +
              "PasswordDigest=\"" + password64 + "\", " +
              "Nonce=\"" + nonce + "\", " +
              "Created=\"" + created + "\"";
            return token;
          };
          WSSEUsernameToken.generateNonce = function() {
            // Math.random returns a Number between 0 and 1.  We don't want our
            // nonce to contain invalid characters (e.g. the period) so we
            // strip them out before returning the result.
            var s = Math.random().WSSEUsernameToken.toString();
            return s.replace(".", "");
          };
          WSSEUsernameToken.base64Encode = function(s) {
            var encoder = new Base64Encoder();
            encoder.encode(s);
            return encoder.flush();
          };
          WSSEUsernameToken.generateTimestamp = function(timestamp) {
            if (timestamp == null) {
              timestamp = new Date();
            }
            var dateFormatter = new DateFormatter();
            dateFormatter.formatString = "YYYY-MM-DDTJJ:NN:SS"
            return dateFormatter.format(timestamp) + "Z";
          };
          WSSEUsernameToken.getBase64Digest = function(nonce, created, password) {
            return SHA1.hashToBase64(nonce + created + password);
          };

          module.exports = WSSEUsernameToken;
        };
        Program["com.adobe.errors.IllegalStateError"] = function(module, exports) {
          var IllegalStateError = function(message) {
            Error.call(this, message);
          };

          IllegalStateError.prototype = Object.create(Error.prototype);

          module.exports = IllegalStateError;
        };
        Program["com.adobe.images.BitString"] = function(module, exports) {
          var BitString = function BitString() {};

          BitString.prototype.len = 0;
          BitString.prototype.val = 0

          module.exports = BitString;
        };
        Program["com.adobe.images.JPGEncoder"] = function(module, exports) {
            var BitString;
            module.inject = function() {
              BitString = module.import('com.adobe.images', 'BitString');
            };

            var JPGEncoder = function(quality) {
                this.ZigZag = [;
                  this.YTable = AS3JS.Utils.createArray(6, null);
                  this.UVTable = AS3JS.Utils.createArray(6, null);
                  this.fdtbl_Y = AS3JS.Utils.createArray(6, null);
                  this.fdtbl_UV = AS3JS.Utils.createArray(6, null);
                  this.YDC_HT = null;
                  this.UVDC_HT = null;
                  this.YAC_HT = null;
                  this.UVAC_HT = null;
                  this.std_dc_luminance_nrcodes = [0, 0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0];
                  this.std_dc_luminance_values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
                  this.std_ac_luminance_nrcodes = [0, 0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d];
                  this.std_ac_luminance_values = [;
                    this.std_dc_chrominance_nrcodes = [0, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0];
                    this.std_dc_chrominance_values = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
                    this.std_ac_chrominance_nrcodes = [0, 0, 2, 1, 2, 4, 4, 3, 4, 7, 5, 4, 4, 0, 1, 2, 0x77];
                    this.std_ac_chrominance_values = [;
                      this.bitcode = AS3JS.Utils.createArray(6, null);
                      this.category = AS3JS.Utils.createArray(6, null);
                      this.byteout = null;
                      this.DU = AS3JS.Utils.createArray(6, null);
                      this.YDU = AS3JS.Utils.createArray(6, null);
                      this.UDU = AS3JS.Utils.createArray(6, null);
                      this.VDU = AS3JS.Utils.createArray(6, null);
                      quality = AS3JS.Utils.getDefaultValue(quality, 50);
                      if (quality <= 0) {
                        quality = 1;
                      }
                      if (quality > 100) {
                        quality = 100;
                      }
                      var sf = 0;
                      if (quality < 50) {
                        sf = int(5000 / quality);
                      } else {
                        sf = int(200 - quality * 2);
                      }
                      // Create tables
                      this.initHuffmanTbl();
                      this.initCategoryNumber();
                      this.initQuantTables(sf);
                    };

                    JPGEncoder.prototype.ZigZag = null;
                    JPGEncoder.prototype.YTable = null;
                    JPGEncoder.prototype.UVTable = null;
                    JPGEncoder.prototype.fdtbl_Y = null;
                    JPGEncoder.prototype.fdtbl_UV = null;
                    JPGEncoder.prototype.initQuantTables = function(sf) {
                      var i;
                      var t;
                      var YQT = [
                        16, 11, 10, 16, 24, 40, 51, 61,
                        12, 12, 14, 19, 26, 58, 60, 55,
                        14, 13, 16, 24, 40, 57, 69, 56,
                        14, 17, 22, 29, 51, 87, 80, 62,
                        18, 22, 37, 56, 68, 109, 103, 77,
                        24, 35, 55, 64, 81, 104, 113, 92,
                        49, 64, 78, 87, 103, 121, 120, 101,
                        72, 92, 95, 98, 112, 100, 103, 99
                      ];
                      for (i = 0; i < 64; i++) {
                        t = Math.floor((YQT[i] * sf + 50) / 100);
                        if (t < 1) {
                          t = 1;
                        } else if (t > 255) {
                          t = 255;
                        }
                        this.YTable[this.ZigZag[i]] = t;
                      }
                      var UVQT = [
                        17, 18, 24, 47, 99, 99, 99, 99,
                        18, 21, 26, 66, 99, 99, 99, 99,
                        24, 26, 56, 99, 99, 99, 99, 99,
                        47, 66, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99,
                        99, 99, 99, 99, 99, 99, 99, 99
                      ];
                      for (i = 0; i < 64; i++) {
                        t = Math.floor((UVQT[i] * sf + 50) / 100);
                        if (t < 1) {
                          t = 1;
                        } else if (t > 255) {
                          t = 255;
                        }
                        this.UVTable[this.ZigZag[i]] = t;
                      }
                      var aasf = [
                        1.0, 1.387039845, 1.306562965, 1.175875602,
                        1.0, 0.785694958, 0.541196100, 0.275899379
                      ];
                      i = 0;
                      for (var row = 0; row < 8; row++) {
                        for (var col = 0; col < 8; col++) {
                          this.fdtbl_Y[i] = (1.0 / (this.YTable[this.ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
                          this.fdtbl_UV[i] = (1.0 / (this.UVTable[this.ZigZag[i]] * aasf[row] * aasf[col] * 8.0));
                          i++;
                        }
                      }
                    };
                    JPGEncoder.prototype.YDC_HT = null;
                    JPGEncoder.prototype.UVDC_HT = null;
                    JPGEncoder.prototype.YAC_HT = null;
                    JPGEncoder.prototype.UVAC_HT = null;
                    JPGEncoder.prototype.computeHuffmanTbl = function(nrcodes, std_table) {
                      var codevalue = 0;
                      var pos_in_table = 0;
                      var HT = [];
                      for (var k = 1; k <= 16; k++) {
                        for (var j = 1; j <= nrcodes[k]; j++) {
                          HT[std_table[pos_in_table]] = new BitString();
                          HT[std_table[pos_in_table]].val = codevalue;
                          HT[std_table[pos_in_table]].len = k;
                          pos_in_table++;
                          codevalue++;
                        }
                        codevalue *= 2;
                      }
                      return HT;
                    };
                    JPGEncoder.prototype.std_dc_luminance_nrcodes = null;
                    JPGEncoder.prototype.std_dc_luminance_values = null;
                    JPGEncoder.prototype.std_ac_luminance_nrcodes = null;
                    JPGEncoder.prototype.std_ac_luminance_values = null;
                    JPGEncoder.prototype.std_dc_chrominance_nrcodes = null;
                    JPGEncoder.prototype.std_dc_chrominance_values = null;
                    JPGEncoder.prototype.std_ac_chrominance_nrcodes = null;
                    JPGEncoder.prototype.std_ac_chrominance_values = null;
                    JPGEncoder.prototype.initHuffmanTbl = function() {
                      this.YDC_HT = this.computeHuffmanTbl(this.std_dc_luminance_nrcodes, this.std_dc_luminance_values);
                      this.UVDC_HT = this.computeHuffmanTbl(this.std_dc_chrominance_nrcodes, this.std_dc_chrominance_values);
                      this.YAC_HT = this.computeHuffmanTbl(this.std_ac_luminance_nrcodes, this.std_ac_luminance_values);
                      this.UVAC_HT = this.computeHuffmanTbl(this.std_ac_chrominance_nrcodes, this.std_ac_chrominance_values);
                    };
                    JPGEncoder.prototype.bitcode = null;
                    JPGEncoder.prototype.category = null;
                    JPGEncoder.prototype.initCategoryNumber = function() {
                      var nrlower = 1;
                      var nrupper = 2;
                      var nr;
                      for (var cat = 1; cat <= 15; cat++) {
                        //Positive numbers
                        for (nr = nrlower; nr < nrupper; nr++) {
                          this.category[32767 + nr] = cat;
                          this.bitcode[32767 + nr] = new BitString();
                          this.bitcode[32767 + nr].len = cat;
                          this.bitcode[32767 + nr].val = nr;
                        }
                        //Negative numbers
                        for (nr = -(nrupper - 1); nr <= -nrlower; nr++) {
                          this.category[32767 + nr] = cat;
                          this.bitcode[32767 + nr] = new BitString();
                          this.bitcode[32767 + nr].len = cat;
                          this.bitcode[32767 + nr].val = nrupper - 1 + nr;
                        }
                        nrlower <<= 1;
                        nrupper <<= 1;
                      }
                    };
                    JPGEncoder.prototype.byteout = null;
                    JPGEncoder.prototype.bytenew = 0;
                    JPGEncoder.prototype.bytepos = 7;
                    JPGEncoder.prototype.writeBits = function(bs) {
                      var value = bs.val;
                      var posval = bs.len - 1;
                      while (posval >= 0) {
                        if (value & uint(1 << posval)) {
                          this.bytenew |= uint(1 << this.bytepos);
                        }
                        posval--;
                        this.bytepos--;
                        if (this.bytepos < 0) {
                          if (this.bytenew == 0xFF) {
                            this.writeByte(0xFF);
                            this.writeByte(0);
                          } else {
                            this.writeByte(this.bytenew);
                          }
                          this.bytepos = 7;
                          this.bytenew = 0;
                        }
                      }
                    };
                    JPGEncoder.prototype.writeByte = function(value) {
                      this.byteout.writeByte(value);
                    };
                    JPGEncoder.prototype.writeWord = function(value) {
                      this.writeByte((value >> 8) & 0xFF);
                      this.writeByte((value) & 0xFF);
                    };
                    JPGEncoder.prototype.fDCTQuant = function(data, fdtbl) {
                      var tmp0, tmp1: Number, tmp2: Number, tmp3: Number, tmp4: Number, tmp5: Number, tmp6: Number, tmp7: Number;
                      var tmp10, tmp11: Number, tmp12: Number, tmp13: Number;
                      var z1, z2: Number, z3: Number, z4: Number, z5: Number, z11: Number, z13: Number;
                      var i;
                      /* Pass 1: process rows. */
                      var dataOff = 0;
                      for (i = 0; i < 8; i++) {
                        tmp0 = data[dataOff + 0] + data[dataOff + 7];
                        tmp7 = data[dataOff + 0] - data[dataOff + 7];
                        tmp1 = data[dataOff + 1] + data[dataOff + 6];
                        tmp6 = data[dataOff + 1] - data[dataOff + 6];
                        tmp2 = data[dataOff + 2] + data[dataOff + 5];
                        tmp5 = data[dataOff + 2] - data[dataOff + 5];
                        tmp3 = data[dataOff + 3] + data[dataOff + 4];
                        tmp4 = data[dataOff + 3] - data[dataOff + 4];

                        /* Even part */
                        tmp10 = tmp0 + tmp3; /* phase 2 */
                        tmp13 = tmp0 - tmp3;
                        tmp11 = tmp1 + tmp2;
                        tmp12 = tmp1 - tmp2;

                        data[dataOff + 0] = tmp10 + tmp11; /* phase 3 */
                        data[dataOff + 4] = tmp10 - tmp11;

                        z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
                        data[dataOff + 2] = tmp13 + z1; /* phase 5 */
                        data[dataOff + 6] = tmp13 - z1;

                        /* Odd part */
                        tmp10 = tmp4 + tmp5; /* phase 2 */
                        tmp11 = tmp5 + tmp6;
                        tmp12 = tmp6 + tmp7;

                        /* The rotator is modified from fig 4-8 to avoid extra negations. */
                        z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
                        z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
                        z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
                        z3 = tmp11 * 0.707106781; /* c4 */

                        z11 = tmp7 + z3; /* phase 5 */
                        z13 = tmp7 - z3;

                        data[dataOff + 5] = z13 + z2; /* phase 6 */
                        data[dataOff + 3] = z13 - z2;
                        data[dataOff + 1] = z11 + z4;
                        data[dataOff + 7] = z11 - z4;

                        dataOff += 8; /* advance pointer to next row */
                      }

                      /* Pass 2: process columns. */
                      dataOff = 0;
                      for (i = 0; i < 8; i++) {
                        tmp0 = data[dataOff + 0] + data[dataOff + 56];
                        tmp7 = data[dataOff + 0] - data[dataOff + 56];
                        tmp1 = data[dataOff + 8] + data[dataOff + 48];
                        tmp6 = data[dataOff + 8] - data[dataOff + 48];
                        tmp2 = data[dataOff + 16] + data[dataOff + 40];
                        tmp5 = data[dataOff + 16] - data[dataOff + 40];
                        tmp3 = data[dataOff + 24] + data[dataOff + 32];
                        tmp4 = data[dataOff + 24] - data[dataOff + 32];

                        /* Even part */
                        tmp10 = tmp0 + tmp3; /* phase 2 */
                        tmp13 = tmp0 - tmp3;
                        tmp11 = tmp1 + tmp2;
                        tmp12 = tmp1 - tmp2;

                        data[dataOff + 0] = tmp10 + tmp11; /* phase 3 */
                        data[dataOff + 32] = tmp10 - tmp11;

                        z1 = (tmp12 + tmp13) * 0.707106781; /* c4 */
                        data[dataOff + 16] = tmp13 + z1; /* phase 5 */
                        data[dataOff + 48] = tmp13 - z1;

                        /* Odd part */
                        tmp10 = tmp4 + tmp5; /* phase 2 */
                        tmp11 = tmp5 + tmp6;
                        tmp12 = tmp6 + tmp7;

                        /* The rotator is modified from fig 4-8 to avoid extra negations. */
                        z5 = (tmp10 - tmp12) * 0.382683433; /* c6 */
                        z2 = 0.541196100 * tmp10 + z5; /* c2-c6 */
                        z4 = 1.306562965 * tmp12 + z5; /* c2+c6 */
                        z3 = tmp11 * 0.707106781; /* c4 */

                        z11 = tmp7 + z3; /* phase 5 */
                        z13 = tmp7 - z3;

                        data[dataOff + 40] = z13 + z2; /* phase 6 */
                        data[dataOff + 24] = z13 - z2;
                        data[dataOff + 8] = z11 + z4;
                        data[dataOff + 56] = z11 - z4;

                        dataOff++; /* advance pointer to next column */
                      }

                      // Quantize/descale the coefficients
                      for (i = 0; i < 64; i++) {
                        // Apply the quantization and scaling factor & Round to nearest integer
                        data[i] = Math.round((data[i] * fdtbl[i]));
                      }
                      return data;
                    };
                    JPGEncoder.prototype.writeAPP0 = function() {
                      this.writeWord(0xFFE0); // marker
                      this.writeWord(16); // length
                      this.writeByte(0x4A); // J
                      this.writeByte(0x46); // F
                      this.writeByte(0x49); // I
                      this.writeByte(0x46); // F
                      this.writeByte(0); // = "JFIF",'\0'
                      this.writeByte(1); // versionhi
                      this.writeByte(1); // versionlo
                      this.writeByte(0); // xyunits
                      this.writeWord(1); // xdensity
                      this.writeWord(1); // ydensity
                      this.writeByte(0); // thumbnwidth
                      this.writeByte(0); // thumbnheight
                    };
                    JPGEncoder.prototype.writeSOF0 = function(width, height) {
                      this.writeWord(0xFFC0); // marker
                      this.writeWord(17); // length, truecolor YUV JPG
                      this.writeByte(8); // precision
                      this.writeWord(height);
                      this.writeWord(width);
                      this.writeByte(3); // nrofcomponents
                      this.writeByte(1); // IdY
                      this.writeByte(0x11); // HVY
                      this.writeByte(0); // QTY
                      this.writeByte(2); // IdU
                      this.writeByte(0x11); // HVU
                      this.writeByte(1); // QTU
                      this.writeByte(3); // IdV
                      this.writeByte(0x11); // HVV
                      this.writeByte(1); // QTV
                    };
                    JPGEncoder.prototype.writeDQT = function() {
                      this.writeWord(0xFFDB); // marker
                      this.writeWord(132); // length
                      this.writeByte(0);
                      var i;
                      for (i = 0; i < 64; i++) {
                        this.writeByte(this.YTable[i]);
                      }
                      this.writeByte(1);
                      for (i = 0; i < 64; i++) {
                        this.writeByte(this.UVTable[i]);
                      }
                    };
                    JPGEncoder.prototype.writeDHT = function() {
                      this.writeWord(0xFFC4); // marker
                      this.writeWord(0x01A2); // length
                      var i;

                      this.writeByte(0); // HTYDCinfo
                      for (i = 0; i < 16; i++) {
                        this.writeByte(this.std_dc_luminance_nrcodes[i + 1]);
                      }
                      for (i = 0; i <= 11; i++) {
                        this.writeByte(this.std_dc_luminance_values[i]);
                      }

                      this.writeByte(0x10); // HTYACinfo
                      for (i = 0; i < 16; i++) {
                        this.writeByte(this.std_ac_luminance_nrcodes[i + 1]);
                      }
                      for (i = 0; i <= 161; i++) {
                        this.writeByte(this.std_ac_luminance_values[i]);
                      }

                      this.writeByte(1); // HTUDCinfo
                      for (i = 0; i < 16; i++) {
                        this.writeByte(this.std_dc_chrominance_nrcodes[i + 1]);
                      }
                      for (i = 0; i <= 11; i++) {
                        this.writeByte(this.std_dc_chrominance_values[i]);
                      }

                      this.writeByte(0x11); // HTUACinfo
                      for (i = 0; i < 16; i++) {
                        this.writeByte(this.std_ac_chrominance_nrcodes[i + 1]);
                      }
                      for (i = 0; i <= 161; i++) {
                        this.writeByte(this.std_ac_chrominance_values[i]);
                      }
                    };
                    JPGEncoder.prototype.writeSOS = function() {
                      this.writeWord(0xFFDA); // marker
                      this.writeWord(12); // length
                      this.writeByte(3); // nrofcomponents
                      this.writeByte(1); // IdY
                      this.writeByte(0); // HTY
                      this.writeByte(2); // IdU
                      this.writeByte(0x11); // HTU
                      this.writeByte(3); // IdV
                      this.writeByte(0x11); // HTV
                      this.writeByte(0); // Ss
                      this.writeByte(0x3f); // Se
                      this.writeByte(0); // Bf
                    };
                    JPGEncoder.prototype.DU = null;
                    JPGEncoder.prototype.processDU = function(CDU, fdtbl, DC, HTDC, HTAC) {
                      var EOB = HTAC[0x00];
                      var M16zeroes = HTAC[0xF0];
                      var i;

                      var DU_DCT = this.fDCTQuant(CDU, fdtbl);
                      //ZigZag reorder
                      for (i = 0; i < 64; i++) {
                        this.DU[this.ZigZag[i]] = DU_DCT[i];
                      }
                      var Diff = this.DU[0] - DC;
                      DC = this.DU[0];
                      //Encode DC
                      if (Diff == 0) {
                        this.writeBits(HTDC[0]); // Diff might be 0
                      } else {
                        this.writeBits(HTDC[this.category[32767 + Diff]]);
                        this.writeBits(this.bitcode[32767 + Diff]);
                      }
                      //Encode ACs
                      var end0pos = 63;
                      for (;
                        (end0pos > 0) && (this.DU[end0pos] == 0); end0pos--) {};
                      //end0pos = first element in reverse order !=0
                      if (end0pos == 0) {
                        this.writeBits(EOB);
                        return DC;
                      }
                      i = 1;
                      while (i <= end0pos) {
                        var startpos = i;
                        for (;
                          (this.DU[i] == 0) && (i <= end0pos); i++) {}
                        var nrzeroes = i - startpos;
                        if (nrzeroes >= 16) {
                          for (var nrmarker = 1; nrmarker <= nrzeroes / 16; nrmarker++) {
                            this.writeBits(M16zeroes);
                          }
                          nrzeroes = int(nrzeroes & 0xF);
                        }
                        this.writeBits(HTAC[nrzeroes * 16 + this.category[32767 + this.DU[i]]]);
                        this.writeBits(this.bitcode[32767 + this.DU[i]]);
                        i++;
                      }
                      if (end0pos != 63) {
                        this.writeBits(EOB);
                      }
                      return DC;
                    };
                    JPGEncoder.prototype.YDU = null;
                    JPGEncoder.prototype.UDU = null;
                    JPGEncoder.prototype.VDU = null;
                    JPGEncoder.prototype.RGB2YUV = function(img, xpos, ypos) {
                      var pos = 0;
                      for (var y = 0; y < 8; y++) {
                        for (var x = 0; x < 8; x++) {
                          var P = img.getPixel32(xpos + x, ypos + y);
                          var R = Number((P >> 16) & 0xFF);
                          var G = Number((P >> 8) & 0xFF);
                          var B = Number((P) & 0xFF);
                          this.YDU[pos] = (((0.29900) * R + (0.58700) * G + (0.11400) * B)) - 128;
                          this.UDU[pos] = (((-0.16874) * R + (-0.33126) * G + (0.50000) * B));
                          this.VDU[pos] = (((0.50000) * R + (-0.41869) * G + (-0.08131) * B));
                          pos++;
                        }
                      }
                    };
                    JPGEncoder.prototype.encode = function(image) {
                      // Initialize bit writer
                      this.byteout = new ByteArray();
                      this.bytenew = 0;
                      this.bytepos = 7;

                      // Add JPEG headers
                      this.writeWord(0xFFD8); // SOI
                      this.writeAPP0();
                      this.writeDQT();
                      this.writeSOF0(image.width, image.height);
                      this.writeDHT();
                      this.writeSOS();

                      // Encode 8x8 macroblocks
                      var DCY = 0;
                      var DCU = 0;
                      var DCV = 0;
                      this.bytenew = 0;
                      this.bytepos = 7;
                      for (var ypos = 0; ypos < image.height; ypos += 8) {
                        for (var xpos = 0; xpos < image.width; xpos += 8) {
                          this.RGB2YUV(image, xpos, ypos);
                          DCY = this.processDU(this.YDU, this.fdtbl_Y, DCY, this.YDC_HT, this.YAC_HT);
                          DCU = this.processDU(this.UDU, this.fdtbl_UV, DCU, this.UVDC_HT, this.UVAC_HT);
                          DCV = this.processDU(this.VDU, this.fdtbl_UV, DCV, this.UVDC_HT, this.UVAC_HT);
                        }
                      }

                      // Do the bit alignment of the EOI marker
                      if (this.bytepos >= 0) {
                        var fillbits = new BitString();
                        fillbits.len = this.bytepos + 1;
                        fillbits.val = (1 << (this.bytepos + 1)) - 1;
                        this.writeBits(fillbits);
                      }

                      this.writeWord(0xFFD9); //EOI
                      return this.byteout;
                    }

                    module.exports = JPGEncoder;
                  };Program["com.adobe.images.PNGEncoder"] = function(module, exports) {
                    module.inject = function() {
                      PNGEncoder.crcTable = null;
                      PNGEncoder.crcTableComputed = false;
                    };

                    var PNGEncoder = function PNGEncoder() {};

                    PNGEncoder.encode = function(img) {
                      // Create output byte array
                      var png = new ByteArray();
                      // Write PNG signature
                      png.writeUnsignedInt(0x89504e47);
                      png.writeUnsignedInt(0x0D0A1A0A);
                      // Build IHDR chunk
                      var IHDR = new ByteArray();
                      IHDR.writeInt(img.width);
                      IHDR.writeInt(img.height);
                      IHDR.writeUnsignedInt(0x08060000); // 32bit RGBA
                      IHDR.writeByte(0);
                      PNGEncoder.writeChunk(png, 0x49484452, IHDR);
                      // Build IDAT chunk
                      var IDAT = new ByteArray();
                      for (var i = 0; i < img.height; i++) {
                        // no filter
                        IDAT.writeByte(0);
                        var p;
                        var j;
                        if (!img.transparent) {
                          for (j = 0; j < img.width; j++) {
                            p = img.getPixel(j, i);
                            IDAT.writeUnsignedInt(
                              uint(((p & 0xFFFFFF) << 8) | 0xFF));
                          }
                        } else {
                          for (j = 0; j < img.width; j++) {
                            p = img.getPixel32(j, i);
                            IDAT.writeUnsignedInt(
                              uint(((p & 0xFFFFFF) << 8) |
                                (p >>> 24)));
                          }
                        }
                      }
                      IDAT.compress();
                      PNGEncoder.writeChunk(png, 0x49444154, IDAT);
                      // Build IEND chunk
                      PNGEncoder.writeChunk(png, 0x49454E44, null);
                      // return PNG
                      return png;
                    };
                    PNGEncoder.crcTable = null;
                    PNGEncoder.crcTableComputed = false;
                    PNGEncoder.writeChunk = function(png, type, data) {
                      if (!PNGEncoder.crcTableComputed) {
                        PNGEncoder.crcTableComputed = true;
                        PNGEncoder.crcTable = [];
                        var c;
                        for (var n = 0; n < 256; n++) {
                          c = n;
                          for (var k = 0; k < 8; k++) {
                            if (c & 1) {
                              c = uint(uint(0xedb88320) ^
                                uint(c >>> 1));
                            } else {
                              c = uint(c >>> 1);
                            }
                          }
                          PNGEncoder.crcTable[n] = c;
                        }
                      }
                      var len = 0;
                      if (data != null) {
                        len = data.length;
                      }
                      png.writeUnsignedInt(len);
                      var p = png.position;
                      png.writeUnsignedInt(type);
                      if (data != null) {
                        png.writeBytes(data);
                      }
                      var e = png.position;
                      png.position = p;
                      c = 0xffffffff;
                      for (var i = 0; i < (e - p); i++) {
                        c = uint(PNGEncoder.crcTable[
                          (c ^ png.readUnsignedByte()) &
                          uint(0xff)] ^ uint(c >>> 8));
                      }
                      c = uint(c ^ uint(0xffffffff));
                      png.position = e;
                      png.writeUnsignedInt(c);
                    };

                    module.exports = PNGEncoder;
                  };Program["com.adobe.net.DynamicURLLoader"] = function(module, exports) {
                    var DynamicURLLoader = function() {
                      URLLoader.call(this);
                    };

                    DynamicURLLoader.prototype = Object.create(URLLoader.prototype);

                    module.exports = DynamicURLLoader;
                  };Program["com.adobe.net.IURIResolver"] = function(module, exports) {
                    var IURIResolver = function IURIResolver() {};

                    IURIResolver.prototype.resolve = function(uri) {}

                    module.exports = IURIResolver;
                  };Program["com.adobe.net.URI"] = function(module, exports) {
                    module.inject = function() {
                      URI.URImustEscape = " %";
                      URI.URIbaselineEscape = URImustEscape + ":?#/@";
                      URI.URIpathEscape = URImustEscape + "?#";
                      URI.URIqueryEscape = URImustEscape + "#";
                      URI.URIqueryPartEscape = URImustEscape + "#&=";
                      URI.URInonHierEscape = URImustEscape + "?#/";
                      URI.UNKNOWN_SCHEME = "unknown";
                      URI.URIbaselineExcludedBitmap = null;
                      URI.URIschemeExcludedBitmap = ;
                      URI.URIuserpassExcludedBitmap = null;
                      URI.URIauthorityExcludedBitmap = null;
                      URI.URIportExludedBitmap = ;
                      URI.URIpathExcludedBitmap = null;
                      URI.URIqueryExcludedBitmap = null;
                      URI.URIqueryPartExcludedBitmap = null;
                      URI.URIfragmentExcludedBitmap = null;
                      URI.URInonHierexcludedBitmap = null;
                      URI.NOT_RELATED = 0;
                      URI.CHILD = 1;
                      URI.EQUAL = 2;
                      URI.PARENT = 3;
                      URI._resolver = null;
                    };

                    var URI = function(uri) {
                      uri = AS3JS.Utils.getDefaultValue(uri, null);
                      if (uri == null)
                        this.initialize();
                      else
                        this.constructURI(uri);
                    };

                    URI.URImustEscape = null;
                    URI.URIbaselineEscape = null;
                    URI.URIpathEscape = null;
                    URI.URIqueryEscape = null;
                    URI.URIqueryPartEscape = null;
                    URI.URInonHierEscape = null;
                    URI.UNKNOWN_SCHEME = null;
                    URI.URIbaselineExcludedBitmap = null;
                    URI.URIschemeExcludedBitmap = null;
                    URI.URIuserpassExcludedBitmap = null;
                    URI.URIauthorityExcludedBitmap = null;
                    URI.URIportExludedBitmap = null;
                    URI.URIpathExcludedBitmap = null;
                    URI.URIqueryExcludedBitmap = null;
                    URI.URIqueryPartExcludedBitmap = null;
                    URI.URIfragmentExcludedBitmap = null;
                    URI.URInonHierexcludedBitmap = null;
                    URI.NOT_RELATED = 0;
                    URI.CHILD = 1;
                    URI.EQUAL = 2;
                    URI.PARENT = 3;
                    URI._resolver = null;
                    URI.escapeChars = function(unescaped) {
                      // This uses the excluded set by default.
                      return URI.fastEscapeChars(unescaped, URI.URIbaselineExcludedBitmap);
                    };
                    URI.unescapeChars = function(escaped, onlyHighASCII) {
                      onlyHighASCII = AS3JS.Utils.getDefaultValue(onlyHighASCII, false * /);
                        // We can just use the default AS function.  It seems to
                        // decode everything correctly
                        var unescaped; unescaped = decodeURIComponent(escaped);
                        return unescaped;
                      };
                      URI.fastEscapeChars = function(unescaped, bitmap) {
                        var escaped = "";
                        var c;
                        var x, i: int;

                        for (i = 0; i < unescaped.length; i++) {
                          c = unescaped.charAt(i);

                          x = bitmap.ShouldEscape(c);
                          if (x) {
                            c = x.toString(16);
                            if (c.length == 1)
                              c = "0" + c;

                            c = "%" + c;
                            c = c.toUpperCase();
                          }

                          escaped += c;
                        }

                        return escaped;
                      };
                      URI.queryPartEscape = function(unescaped) {
                        var escaped = unescaped;
                        escaped = URI.fastEscapeChars(unescaped, URI.URIqueryPartExcludedBitmap);
                        return escaped;
                      };
                      URI.queryPartUnescape = function(escaped) {
                        var unescaped = escaped;
                        unescaped = URI.unescapeChars(unescaped);
                        return unescaped;
                      };
                      URI.compareStr = function(str1, str2, sensitive) {
                        sensitive = AS3JS.Utils.getDefaultValue(sensitive, true);
                        if (sensitive == false) {
                          str1 = str1.toLowerCase();
                          str2 = str2.toLowerCase();
                        }

                        return (str1 == str2)
                      };
                      URI.resolve = function(uri) {
                        var copy = new URI();
                        copy.copyURI(uri);

                        if (URI._resolver != null) {
                          // A resolver class has been registered.  Call it.
                          return URI._resolver.resolve(copy);
                        } else {
                          // No resolver.  Nothing to do, but we don't
                          // want to reuse the one passed in.
                          return copy;
                        }
                      };
                      URI.get_resolver = function() {
                        return URI._resolver;
                      };
                      URI.set_resolver = function(resolver) {
                        URI._resolver = resolver;
                      };

                      URI.prototype.get_hierState = function() {
                        return (this._nonHierarchical.length == 0);
                      };
                      URI.prototype.get_scheme = function() {
                        return URI.unescapeChars(this._scheme);
                      };
                      URI.prototype.get_authority = function() {
                        return URI.unescapeChars(this._authority);
                      };
                      URI.prototype.get_username = function() {
                        return URI.unescapeChars(this._username);
                      };
                      URI.prototype.get_password = function() {
                        return URI.unescapeChars(this._password);
                      };
                      URI.prototype.get_port = function() {
                        return URI.unescapeChars(this._port);
                      };
                      URI.prototype.get_path = function() {
                        return URI.unescapeChars(this._path);
                      };
                      URI.prototype.get_query = function() {
                        return URI.unescapeChars(this._query);
                      };
                      URI.prototype.get_queryRaw = function() {
                        return this._query;
                      };
                      URI.prototype.get_fragment = function() {
                        return URI.unescapeChars(this._fragment);
                      };
                      URI.prototype.get_nonHierarchical = function() {
                        return URI.unescapeChars(this._nonHierarchical);
                      };
                      URI.prototype.set_hierState = function(state) {
                        if (state) {
                          // Clear the non-hierarchical data
                          this._nonHierarchical = "";

                          // Also set the state vars while we are at it
                          if (this._scheme == "" || this._scheme == URI.UNKNOWN_SCHEME)
                            this._relative = true;
                          else
                            this._relative = false;

                          if (this._authority.length == 0 && this._path.length == 0)
                            this._valid = false;
                          else
                            this._valid = true;
                        } else {
                          // Clear the hierarchical data
                          this._authority = "";
                          this._username = "";
                          this._password = "";
                          this._port = "";
                          this._path = "";

                          this._relative = false;

                          if (this._scheme == "" || this._scheme == URI.UNKNOWN_SCHEME)
                            this._valid = false;
                          else
                            this._valid = true;
                        }
                      };
                      URI.prototype.set_scheme = function(schemeStr) {
                        // Normalize the scheme
                        var normalized = schemeStr.toLowerCase();
                        this._scheme = URI.fastEscapeChars(normalized, URI.URIschemeExcludedBitmap);
                      };
                      URI.prototype.set_authority = function(authorityStr) {
                        // Normalize the authority
                        authorityStr = authorityStr.toLowerCase();

                        this._authority = URI.fastEscapeChars(authorityStr,
                          URI.URIauthorityExcludedBitmap);

                        // Only hierarchical URI's can have an authority, make
                        // sure this URI is of the proper format.
                        this.set_hierState(true);
                      };
                      URI.prototype.set_username = function(usernameStr) {
                        this._username = URI.fastEscapeChars(usernameStr, URI.URIuserpassExcludedBitmap);

                        // Only hierarchical URI's can have a username.
                        this.set_hierState(true);
                      };
                      URI.prototype.set_password = function(passwordStr) {
                        this._password = URI.fastEscapeChars(passwordStr,
                          URI.URIuserpassExcludedBitmap);

                        // Only hierarchical URI's can have a password.
                        this.set_hierState(true);
                      };
                      URI.prototype.set_port = function(portStr) {
                        this._port = URI.escapeChars(portStr);

                        // Only hierarchical URI's can have a port.
                        this.set_hierState(true);
                      };
                      URI.prototype.set_path = function(pathStr) {
                        this._path = URI.fastEscapeChars(pathStr, URI.URIpathExcludedBitmap);

                        if (this._scheme == URI.UNKNOWN_SCHEME) {
                          // We set the path.  This is a valid URI now.
                          this._scheme = "";
                        }

                        // Only hierarchical URI's can have a path.
                        this.set_hierState(true);
                      };
                      URI.prototype.set_query = function(queryStr) {
                        this._query = URI.fastEscapeChars(queryStr, URI.URIqueryExcludedBitmap);

                        // both hierarchical and non-hierarchical URI's can
                        // have a query.  Do not set the hierState.
                      };
                      URI.prototype.set_queryRaw = function(queryStr) {
                        this._query = queryStr;
                      };
                      URI.prototype.set_fragment = function(fragmentStr) {
                        this._fragment = URI.fastEscapeChars(fragmentStr, URI.URIfragmentExcludedBitmap);

                        // both hierarchical and non-hierarchical URI's can
                        // have a fragment.  Do not set the hierState.
                      };
                      URI.prototype.set_nonHierarchical = function(nonHier) {
                        this._nonHierarchical = URI.fastEscapeChars(nonHier, URI.URInonHierexcludedBitmap);

                        // This is a non-hierarchical URI.
                        this.set_hierState(false);
                      };
                      URI.prototype._valid = false;
                      URI.prototype._relative = false;
                      URI.prototype._scheme = "";
                      URI.prototype._authority = "";
                      URI.prototype._username = "";
                      URI.prototype._password = "";
                      URI.prototype._port = "";
                      URI.prototype._path = "";
                      URI.prototype._query = "";
                      URI.prototype._fragment = "";
                      URI.prototype._nonHierarchical = "";
                      URI.prototype.constructURI = function(uri) {
                        if (!this.parseURI(uri))
                          this._valid = false;

                        return this.isValid();
                      };
                      URI.prototype.initialize = function() {
                        this._valid = false;
                        this._relative = false;

                        this._scheme = URI.UNKNOWN_SCHEME;
                        this._authority = "";
                        this._username = "";
                        this._password = "";
                        this._port = "";
                        this._path = "";
                        this._query = "";
                        this._fragment = "";

                        this._nonHierarchical = "";
                      };
                      URI.prototype.validateURI = function() {
                        // Check the scheme
                        if (this.isAbsolute()) {
                          if (this._scheme.length <= 1 || this._scheme == URI.UNKNOWN_SCHEME) {
                            // we probably parsed a C:\ type path or no scheme
                            return false;
                          } else if (this.verifyAlpha(this._scheme) == false)
                            return false; // Scheme contains bad characters
                        }

                        if (this.get_hierState()) {
                          if (this._path.search('\\') != -1)
                            return false; // local path
                          else if (this.isRelative() == false && this._scheme == URI.UNKNOWN_SCHEME)
                            return false; // It's an absolute URI, but it has a bad scheme
                        } else {
                          if (this._nonHierarchical.search('\\') != -1)
                            return false; // some kind of local path
                        }

                        // Looks like it's ok.
                        return true;
                      };
                      URI.prototype.parseURI = function(uri) {
                        var baseURI = uri;
                        var index, index2: int;

                        // Make sure this object is clean before we start.  If it was used
                        // before and we are now parsing a new URI, we don't want any stale
                        // info lying around.
                        this.initialize();

                        // Remove any fragments (anchors) from the URI
                        index = baseURI.indexOf("#");
                        if (index != -1) {
                          // Store the fragment piece if any
                          if (baseURI.length > (index + 1)) // +1 is to skip the '#'
                            this._fragment = baseURI.substr(index + 1, baseURI.length - (index + 1));

                          // Trim off the fragment
                          baseURI = baseURI.substr(0, index);
                        }

                        // We need to strip off any CGI parameters (eg '?param=bob')
                        index = baseURI.indexOf("?");
                        if (index != -1) {
                          if (baseURI.length > (index + 1))
                            this._query = baseURI.substr(index + 1, baseURI.length - (index + 1)); // +1 is to skip the '?'

                          // Trim off the query
                          baseURI = baseURI.substr(0, index);
                        }

                        // Now try to find the scheme part
                        index = baseURI.search(':');
                        index2 = baseURI.search('/');

                        var containsColon = (index != -1);
                        var containsSlash = (index2 != -1);

                        // This value is indeterminate if "containsColon" is false.
                        // (if there is no colon, does the slash come before or
                        // after said non-existing colon?)
                        var colonBeforeSlash = (!containsSlash || index < index2);

                        // If it has a colon and it's before the first slash, we will treat
                        // it as a scheme.  If a slash is before a colon, there must be a
                        // stray colon in a path or something.  In which case, the colon is
                        // not the separator for the scheme.  Technically, we could consider
                        // this an error, but since this is not an ambiguous state (we know
                        // 100% that this has no scheme), we will keep going.
                        if (containsColon && colonBeforeSlash) {
                          // We found a scheme
                          this._scheme = baseURI.substr(0, index);

                          // Normalize the scheme
                          this._scheme = this._scheme.toLowerCase();

                          baseURI = baseURI.substr(index + 1);

                          if (baseURI.substr(0, 2) == "//") {
                            // This is a hierarchical URI
                            this._nonHierarchical = "";

                            // Trim off the "//"
                            baseURI = baseURI.substr(2, baseURI.length - 2);
                          } else {
                            // This is a non-hierarchical URI like "mailto:bob@mail.com"
                            this._nonHierarchical = baseURI;

                            if ((this._valid = this.validateURI()) == false)
                              this.initialize(); // Bad URI.  Clear it.

                            // No more parsing to do for this case
                            return this.isValid();
                          }
                        } else {
                          // No scheme.  We will consider this a relative URI
                          this._scheme = "";
                          this._relative = true;
                          this._nonHierarchical = "";
                        }

                        // Ok, what we have left is everything after the <scheme>://

                        // Now that we have stripped off any query and fragment parts, we
                        // need to split the authority from the path

                        if (this.isRelative()) {
                          // Don't bother looking for the authority.  It's a relative URI
                          this._authority = "";
                          this._port = "";
                          this._path = baseURI;
                        } else {
                          // Check for malformed UNC style file://///server/type/path/
                          // By the time we get here, we have already trimmed the "file://"
                          // so baseURI will be ///server/type/path.  If baseURI only
                          // has one slash, we leave it alone because that is valid (that
                          // is the case of "file:///path/to/file.txt" where there is no
                          // server - implicit "localhost").
                          if (baseURI.substr(0, 2) == "//") {
                            // Trim all leading slashes
                            while (baseURI.charAt(0) == "/")
                              baseURI = baseURI.substr(1, baseURI.length - 1);
                          }

                          index = baseURI.search('/');
                          if (index == -1) {
                            // No path.  We must have passed something like "http://something.com"
                            this._authority = baseURI;
                            this._path = "";
                          } else {
                            this._authority = baseURI.substr(0, index);
                            this._path = baseURI.substr(index, baseURI.length - index);
                          }

                          // Check to see if the URI has any username or password information.
                          // For example:  ftp://username:password@server.com
                          index = this._authority.search('@');
                          if (index != -1) {
                            // We have a username and possibly a password
                            this._username = this._authority.substr(0, index);

                            // Remove the username/password from the authority
                            this._authority = this._authority.substr(index + 1); // Skip the '@'

                            // Now check to see if the username also has a password
                            index = this._username.search(':');
                            if (index != -1) {
                              this._password = this._username.substring(index + 1, this._username.length);
                              this._username = this._username.substr(0, index);
                            } else
                              this._password = "";
                          } else {
                            this._username = "";
                            this._password = "";
                          }

                          // Lastly, check to see if the authorty has a port number.
                          // This is parsed after the username/password to avoid conflicting
                          // with the ':' in the 'username:password' if one exists.
                          index = this._authority.search(':');
                          if (index != -1) {
                            this._port = this._authority.substring(index + 1, this._authority.length); // skip the ':'
                            this._authority = this._authority.substr(0, index);
                          } else {
                            this._port = "";
                          }

                          // Lastly, normalize the authority.  Domain names
                          // are case insensitive.
                          this._authority = this._authority.toLowerCase();
                        }

                        if ((this._valid = this.validateURI()) == false)
                          this.initialize(); // Bad URI.  Clear it

                        return this.isValid();
                      };
                      URI.prototype.copyURI = function(uri) {
                        this._scheme = uri._scheme;
                        this._authority = uri._authority;
                        this._username = uri._username;
                        this._password = uri._password;
                        this._port = uri._port;
                        this._path = uri._path;
                        this._query = uri._query;
                        this._fragment = uri._fragment;
                        this._nonHierarchical = uri._nonHierarchical;

                        this._valid = uri._valid;
                        this._relative = uri._relative;
                      };
                      URI.prototype.verifyAlpha = function(str) {
                        var pattern = /[^a-z]/;
                        var index;

                        str = str.toLowerCase();
                        index = str.search(pattern);

                        if (index == -1)
                          return true;
                        else
                          return false;
                      };
                      URI.prototype.isValid = function() {
                        return this._valid;
                      };
                      URI.prototype.isAbsolute = function() {
                        return !this._relative;
                      };
                      URI.prototype.isRelative = function() {
                        return this._relative;
                      };
                      URI.prototype.isDirectory = function() {
                        if (this._path.length == 0)
                          return false;

                        return (this._path.charAt(this.get_path().length - 1) == '/');
                      };
                      URI.prototype.isHierarchical = function() {
                        return this.get_hierState();
                      };
                      URI.prototype.setParts = function(schemeStr, authorityStr, portStr, pathStr, queryStr, fragmentStr) {
                        this.set_scheme(schemeStr);
                        this.set_authority(authorityStr);
                        this.set_port(portStr);
                        this.set_path(pathStr);
                        this.set_query(queryStr);
                        this.set_fragment(fragmentStr);

                        this.set_hierState(true);
                      };
                      URI.prototype.isOfType = function(scheme) {
                        // Schemes are never case sensitive.  Ignore case.
                        scheme = scheme.toLowerCase();
                        return (this._scheme == scheme);
                      };
                      URI.prototype.getQueryValue = function(name) {
                        var map;
                        var item;
                        var value;

                        map = this.getQueryByMap();

                        for (item in map) {
                          if (item == name) {
                            value = map[item];
                            return value;
                          }
                        }

                        // Didn't find the specified key
                        return new String("");
                      };
                      URI.prototype.setQueryValue = function(name, value) {
                        var map;

                        map = this.getQueryByMap();

                        // If the key doesn't exist yet, this will create a new pair in
                        // the map.  If it does exist, this will overwrite the previous
                        // value, which is what we want.
                        map[name] = value;

                        this.setQueryByMap(map);
                      };
                      URI.prototype.getQueryByMap = function() {
                        var queryStr;
                        var pair;
                        var pairs;
                        var item;
                        var name, value: String;
                        var index;
                        var map = new Object();

                        // We need the raw query string, no unescaping.
                        queryStr = this._query;

                        pairs = queryStr.split('&');
                        for each(pair in pairs) {
                          if (pair.length == 0)
                            continue;

                          item = pair.split('=');

                          if (item.length > 0)
                            name = item[0];
                          else
                            continue; // empty array

                          if (item.length > 1)
                            value = item[1];
                          else
                            value = "";

                          name = URI.queryPartUnescape(name);
                          value = URI.queryPartUnescape(value);

                          map[name] = value;
                        }

                        return map;
                      };
                      URI.prototype.setQueryByMap = function(map) {
                        var item;
                        var name, value: String;
                        var queryStr = "";
                        var tmpPair;
                        var foo;

                        for (item in map) {
                          name = item;
                          value = map[item];

                          if (value == null)
                            value = "";

                          // Need to escape the name/value pair so that they
                          // don't conflict with the query syntax (specifically
                          // '=', '&', and <whitespace>).
                          name = URI.queryPartEscape(name);
                          value = URI.queryPartEscape(value);

                          tmpPair = name;

                          if (value.length > 0) {
                            tmpPair += "=";
                            tmpPair += value;
                          }

                          if (queryStr.length != 0)
                            queryStr += '&'; // Add the separator

                          queryStr += tmpPair;
                        }

                        // We don't want to escape.  We already escaped the
                        // individual name/value pairs.  If we escaped the
                        // query string again by assigning it to "query",
                        // we would have double escaping.
                        this._query = queryStr;
                      };
                      URI.prototype.toString = function() {
                        if (this == null)
                          return "";
                        else
                          return this.toStringInternal(false);
                      };
                      URI.prototype.toDisplayString = function() {
                        return this.toStringInternal(true);
                      };
                      URI.prototype.toStringInternal = function(forDisplay) {
                        var uri = "";
                        var part = "";

                        if (this.isHierarchical() == false) {
                          // non-hierarchical URI

                          uri += (forDisplay ? this.get_scheme() : this._scheme);
                          uri += ":";
                          uri += (forDisplay ? this.get_nonHierarchical() : this._nonHierarchical);
                        } else {
                          // Hierarchical URI

                          if (this.isRelative() == false) {
                            // If it is not a relative URI, then we want the scheme and
                            // authority parts in the string.  If it is relative, we
                            // do NOT want this stuff.

                            if (this._scheme.length != 0) {
                              part = (forDisplay ? this.get_scheme() : this._scheme);
                              uri += part + ":";
                            }

                            if (this._authority.length != 0 || this.isOfType("file")) {
                              uri += "//";

                              // Add on any username/password associated with this
                              // authority
                              if (this._username.length != 0) {
                                part = (forDisplay ? this.get_username() : this._username);
                                uri += part;

                                if (this._password.length != 0) {
                                  part = (forDisplay ? this.get_password() : this._password);
                                  uri += ":" + part;
                                }

                                uri += "@";
                              }

                              // add the authority
                              part = (forDisplay ? this.get_authority() : this._authority);
                              uri += part;

                              // Tack on the port number, if any
                              if (this.get_port().length != 0)
                                uri += ":" + this.get_port();
                            }
                          }

                          // Tack on the path
                          part = (forDisplay ? this.get_path() : this._path);
                          uri += part;

                        } // end hierarchical part

                        // Both non-hier and hierarchical have query and fragment parts

                        // Add on the query and fragment parts
                        if (this._query.length != 0) {
                          part = (forDisplay ? this.get_query() : this._query);
                          uri += "?" + part;
                        }

                        if (this.get_fragment().length != 0) {
                          part = (forDisplay ? this.get_fragment() : this._fragment);
                          uri += "#" + part;
                        }

                        return uri;
                      };
                      URI.prototype.forceEscape = function() {
                        // The accessors for each of the members will unescape
                        // and then re-escape as we get and assign them.

                        // Handle the parts that are common for both hierarchical
                        // and non-hierarchical URI's
                        this.set_scheme(this.get_scheme());
                        this.setQueryByMap(this.getQueryByMap());
                        this.set_fragment(this.get_fragment());

                        if (this.isHierarchical()) {
                          this.set_authority(this.get_authority());
                          this.set_path(this.get_path());
                          this.set_port(this.get_port());
                          this.set_username(this.get_username());
                          this.set_password(this.get_password());
                        } else {
                          this.set_nonHierarchical(this.get_nonHierarchical());
                        }
                      };
                      URI.prototype.isOfFileType = function(extension) {
                        var thisExtension;
                        var index;

                        index = extension.lastIndexOf(".");
                        if (index != -1) {
                          // Strip the extension
                          extension = extension.substr(index + 1);
                        } else {
                          // The caller passed something without a dot in it.  We
                          // will assume that it is just a plain extension (e.g. "html").
                          // What they passed is exactly what we want
                        }

                        thisExtension = this.getExtension(true);

                        if (thisExtension == "")
                          return false;

                        // Compare the extensions ignoring case
                        if (URI.compareStr(thisExtension, extension, false) == 0)
                          return true;
                        else
                          return false;
                      };
                      URI.prototype.getExtension = function(minusDot) {
                        minusDot = AS3JS.Utils.getDefaultValue(minusDot, false);
                        var filename = this.getFilename();
                        var extension;
                        var index;

                        if (filename == "")
                          return String("");

                        index = filename.lastIndexOf(".");

                        // If it doesn't have an extension, or if it is a "hidden" file,
                        // it doesn't have an extension.  Hidden files on unix start with
                        // a dot (e.g. ".login").
                        if (index == -1 || index == 0)
                          return String("");

                        extension = filename.substr(index);

                        // If the caller does not want the dot, remove it.
                        if (minusDot && extension.charAt(0) == ".")
                          extension = extension.substr(1);

                        return extension;
                      };
                      URI.prototype.getFilename = function(minusExtension) {
                        minusExtension = AS3JS.Utils.getDefaultValue(minusExtension, false);
                        if (this.isDirectory())
                          return String("");

                        var pathStr = this.get_path();
                        var filename;
                        var index;

                        // Find the last path separator.
                        index = pathStr.lastIndexOf("/");

                        if (index != -1)
                          filename = pathStr.substr(index + 1);
                        else
                          filename = pathStr;

                        if (minusExtension) {
                          // The caller has requested that the extension be removed
                          index = filename.lastIndexOf(".");

                          if (index != -1)
                            filename = filename.substr(0, index);
                        }

                        return filename;
                      };
                      URI.prototype.getDefaultPort = function() {
                        if (this._scheme == "http")
                          return String("80");
                        else if (this._scheme == "ftp")
                          return String("21");
                        else if (this._scheme == "file")
                          return String("");
                        else if (this._scheme == "sftp")
                          return String("22"); // ssh standard port
                        else {
                          // Don't know the port for this URI type
                          return String("");
                        }
                      };
                      URI.prototype.getRelation = function(uri, caseSensitive) {
                        caseSensitive = AS3JS.Utils.getDefaultValue(caseSensitive, true);
                        // Give the app a chance to resolve these URI's before we compare them.
                        var thisURI = URI.resolve(this);
                        var thatURI = URI.resolve(uri);

                        if (thisURI.isRelative() || thatURI.isRelative()) {
                          // You cannot compare relative URI's due to their lack of context.
                          // You could have two relative URI's that look like:
                          //    ../../images/
                          //    ../../images/marketing/logo.gif
                          // These may appear related, but you have no overall context
                          // from which to make the comparison.  The first URI could be
                          // from one site and the other URI could be from another site.
                          return URI.NOT_RELATED;
                        } else if (thisURI.isHierarchical() == false || thatURI.isHierarchical() == false) {
                          // One or both of the URI's are non-hierarchical.
                          if (((thisURI.isHierarchical() == false) && (thatURI.isHierarchical() == true)) ||
                            ((thisURI.isHierarchical() == true) && (thatURI.isHierarchical() == false))) {
                            // XOR.  One is hierarchical and the other is
                            // non-hierarchical.  They cannot be compared.
                            return URI.NOT_RELATED;
                          } else {
                            // They are both non-hierarchical
                            if (thisURI.get_scheme() != thatURI.get_scheme())
                              return URI.NOT_RELATED;

                            if (thisURI.get_nonHierarchical() != thatURI.get_nonHierarchical())
                              return URI.NOT_RELATED;

                            // The two non-hierarcical URI's are equal.
                            return URI.EQUAL;
                          }
                        }

                        // Ok, this URI and the one we are being compared to are both
                        // absolute hierarchical URI's.

                        if (thisURI.get_scheme() != thatURI.get_scheme())
                          return URI.NOT_RELATED;

                        if (thisURI.get_authority() != thatURI.get_authority())
                          return URI.NOT_RELATED;

                        var thisPort = thisURI.get_port();
                        var thatPort = thatURI.get_port();

                        // Different ports are considered completely different servers.
                        if (thisPort == "")
                          thisPort = thisURI.getDefaultPort();
                        if (thatPort == "")
                          thatPort = thatURI.getDefaultPort();

                        // Check to see if the port is the default port.
                        if (thisPort != thatPort)
                          return URI.NOT_RELATED;

                        if (URI.compareStr(thisURI.get_path(), thatURI.get_path(), caseSensitive))
                          return URI.EQUAL;

                        // Special case check.  If we are here, the scheme, authority,
                        // and port match, and it is not a relative path, but the
                        // paths did not match.  There is a special case where we
                        // could have:
                        //    http://something.com/
                        //    http://something.com
                        // Technically, these are equal.  So lets, check for this case.
                        var thisPath = thisURI.get_path();
                        var thatPath = thatURI.get_path();

                        if ((thisPath == "/" || thatPath == "/") &&
                          (thisPath == "" || thatPath == "")) {
                          // We hit the special case.  These two are equal.
                          return URI.EQUAL;
                        }

                        // Ok, the paths do not match, but one path may be a parent/child
                        // of the other.  For example, we may have:
                        //    http://something.com/path/to/homepage/
                        //    http://something.com/path/to/homepage/images/logo.gif
                        // In this case, the first is a parent of the second (or the second
                        // is a child of the first, depending on which you compare to the
                        // other).  To make this comparison, we must split the path into
                        // its component parts (split the string on the '/' path delimiter).
                        // We then compare the 
                        var thisParts, thatParts: Array;
                        var thisPart, thatPart: String;
                        var i;

                        thisParts = thisPath.split("/");
                        thatParts = thatPath.split("/");

                        if (thisParts.length > thatParts.length) {
                          thatPart = thatParts[thatParts.length - 1];
                          if (thatPart.length > 0) {
                            // if the last part is not empty, the passed URI is
                            // not a directory.  There is no way the passed URI
                            // can be a parent.
                            return URI.NOT_RELATED;
                          } else {
                            // Remove the empty trailing part
                            thatParts.pop();
                          }

                          // This may be a child of the one passed in
                          for (i = 0; i < thatParts.length; i++) {
                            thisPart = thisParts[i];
                            thatPart = thatParts[i];

                            if (URI.compareStr(thisPart, thatPart, caseSensitive) == false)
                              return URI.NOT_RELATED;
                          }

                          return URI.CHILD;
                        } else if (thisParts.length < thatParts.length) {
                          thisPart = thisParts[thisParts.length - 1];
                          if (thisPart.length > 0) {
                            // if the last part is not empty, this URI is not a
                            // directory.  There is no way this object can be
                            // a parent.
                            return URI.NOT_RELATED;
                          } else {
                            // Remove the empty trailing part
                            thisParts.pop();
                          }

                          // This may be the parent of the one passed in
                          for (i = 0; i < thisParts.length; i++) {
                            thisPart = thisParts[i];
                            thatPart = thatParts[i];

                            if (URI.compareStr(thisPart, thatPart, caseSensitive) == false)
                              return URI.NOT_RELATED;
                          }

                          return URI.PARENT;
                        } else {
                          // Both URI's have the same number of path components, but
                          // it failed the equivelence check above.  This means that
                          // the two URI's are not related.
                          return URI.NOT_RELATED;
                        }

                        // If we got here, the scheme and authority are the same,
                        // but the paths pointed to two different locations that
                        // were in different parts of the file system tree
                        return URI.NOT_RELATED;
                      };
                      URI.prototype.getCommonParent = function(uri, caseSensitive) {
                        caseSensitive = AS3JS.Utils.getDefaultValue(caseSensitive, true);
                        var thisURI = URI.resolve(this);
                        var thatURI = URI.resolve(uri);

                        if (!thisURI.isAbsolute() || !thatURI.isAbsolute() ||
                          thisURI.isHierarchical() == false ||
                          thatURI.isHierarchical() == false) {
                          // Both URI's must be absolute hierarchical for this to
                          // make sense.
                          return null;
                        }

                        var relation = thisURI.getRelation(thatURI);
                        if (relation == URI.NOT_RELATED) {
                          // The given URI is not related to this one.  No
                          // common parent.
                          return null;
                        }

                        thisURI.chdir(".");
                        thatURI.chdir(".");

                        var strBefore, strAfter: String;
                        do {
                          relation = thisURI.getRelation(thatURI, caseSensitive);
                          if (relation == URI.EQUAL || relation == URI.PARENT)
                            break;

                          // If strBefore and strAfter end up being the same,
                          // we know we are at the root of the path because
                          // chdir("..") is doing nothing.
                          strBefore = thisURI.toString();
                          thisURI.chdir("..");
                          strAfter = thisURI.toString();
                        }
                        while (strBefore != strAfter);

                        return thisURI;
                      };
                      URI.prototype.chdir = function(reference, escape) {
                        escape = AS3JS.Utils.getDefaultValue(escape, false);
                        var uriReference;
                        var ref = reference;

                        if (escape)
                          ref = URI.escapeChars(reference);

                        if (ref == "") {
                          // NOOP
                          return true;
                        } else if (ref.substr(0, 2) == "//") {
                          // Special case.  This is an absolute URI but without the scheme.
                          // Take the scheme from this URI and tack it on.  This is
                          // intended to make working with chdir() a little more
                          // tolerant.
                          var final = this.get_scheme() + ":" + ref;

                          return this.constructURI(final);
                        } else if (ref.charAt(0) == "?") {
                          // A relative URI that is just a query part is essentially
                          // a "./?query".  We tack on the "./" here to make the rest
                          // of our logic work.
                          ref = "./" + ref;
                        }

                        // Parse the reference passed in as a URI.  This way we
                        // get any query and fragments parsed out as well.
                        uriReference = new URI(ref);

                        if (uriReference.isAbsolute() ||
                          uriReference.isHierarchical() == false) {
                          // If the URI given is a full URI, it replaces this one.
                          this.copyURI(uriReference);
                          return true;
                        }

                        var thisPath, thatPath: String;
                        var thisParts, thatParts: Array;
                        var thisIsDir = false,
                          thatIsDir: Boolean = false;
                        var thisIsAbs = false,
                          thatIsAbs: Boolean = false;
                        var lastIsDotOperation = false;
                        var curDir;
                        var i;

                        thisPath = this.get_path();
                        thatPath = uriReference.get_path();

                        if (thisPath.length > 0)
                          thisParts = thisPath.split("/");
                        else
                          thisParts = [];

                        if (thatPath.length > 0)
                          thatParts = thatPath.split("/");
                        else
                          thatParts = [];

                        if (thisParts.length > 0 && thisParts[0] == "") {
                          thisIsAbs = true;
                          thisParts.shift(); // pop the first one off the array
                        }
                        if (thisParts.length > 0 && thisParts[thisParts.length - 1] == "") {
                          thisIsDir = true;
                          thisParts.pop(); // pop the last one off the array
                        }

                        if (thatParts.length > 0 && thatParts[0] == "") {
                          thatIsAbs = true;
                          thatParts.shift(); // pop the first one off the array
                        }
                        if (thatParts.length > 0 && thatParts[thatParts.length - 1] == "") {
                          thatIsDir = true;
                          thatParts.pop(); // pop the last one off the array
                        }

                        if (thatIsAbs) {
                          // The reference is an absolute path (starts with a slash).
                          // It replaces this path wholesale.
                          this.set_path(uriReference.get_path());

                          // And it inherits the query and fragment
                          this.set_queryRaw(uriReference.get_queryRaw());
                          this.set_fragment(uriReference.get_fragment());

                          return true;
                        } else if (thatParts.length == 0 && uriReference.get_query() == "") {
                          // The reference must have only been a fragment.  Fragments just
                          // get appended to whatever the current path is.  We don't want
                          // to overwrite any query that may already exist, so this case
                          // only takes on the new fragment.
                          this.set_fragment(uriReference.get_fragment());
                          return true;
                        } else if (thisIsDir == false && thisParts.length > 0) {
                          // This path ends in a file.  It goes away no matter what.
                          thisParts.pop();
                        }

                        // By default, this assumes the query and fragment of the reference
                        this.set_queryRaw(uriReference.get_queryRaw());
                        this.set_fragment(uriReference.get_fragment());

                        // Append the parts of the path from the passed in reference
                        // to this object's path.
                        thisParts = thisParts.concat(thatParts);

                        for (i = 0; i < thisParts.length; i++) {
                          curDir = thisParts[i];
                          lastIsDotOperation = false;

                          if (curDir == ".") {
                            thisParts.splice(i, 1);
                            i = i - 1; // account for removing this item
                            lastIsDotOperation = true;
                          } else if (curDir == "..") {
                            if (i >= 1) {
                              if (thisParts[i - 1] == "..") {
                                // If the previous is a "..", we must have skipped
                                // it due to this URI being relative.  We can't
                                // collapse leading ".."s in a relative URI, so
                                // do nothing.
                              } else {
                                thisParts.splice(i - 1, 2);
                                i = i - 2; // move back to account for the 2 we removed
                              }
                            } else {
                              // This is the first thing in the path.

                              if (this.isRelative()) {
                                // We can't collapse leading ".."s in a relative
                                // path.  Do noting.
                              } else {
                                // This is an abnormal case.  We have dot-dotted up
                                // past the base of our "file system".  This is a
                                // case where we had a /path/like/this.htm and were
                                // given a path to chdir to like this:
                                // ../../../../../../mydir
                                // Obviously, it has too many ".." and will take us
                                // up beyond the top of the URI.  However, according
                                // RFC 2396 Appendix C.2, we should try to handle
                                // these abnormal cases appropriately.  In this case,
                                // we will do what UNIX command lines do if you are
                                // at the root (/) of the filesystem and execute:
                                // # cd ../../../../../bin
                                // Which will put you in /bin.  Essentially, the extra
                                // ".."'s will just get eaten.

                                thisParts.splice(i, 1);
                                i = i - 1; // account for the ".." we just removed
                              }
                            }

                            lastIsDotOperation = true;
                          }
                        }

                        var finalPath = "";

                        // If the last thing in the path was a "." or "..", then this thing is a
                        // directory.  If the last thing isn't a dot-op, then we don't want to 
                        // blow away any information about the directory (hence the "|=" binary
                        // assignment).
                        thatIsDir = thatIsDir || lastIsDotOperation;

                        // Reconstruct the path with the abs/dir info we have
                        finalPath = this.joinPath(thisParts, thisIsAbs, thatIsDir);

                        // Set the path (automatically escaping it)
                        this.set_path(finalPath);

                        return true;
                      };
                      URI.prototype.joinPath = function(parts, isAbs, isDir) {
                        var pathStr = "";
                        var i;

                        for (i = 0; i < parts.length; i++) {
                          if (pathStr.length > 0)
                            pathStr += "/";

                          pathStr += parts[i];
                        }

                        // If this path is a directory, tack on the directory delimiter,
                        // but only if the path contains something.  Adding this to an
                        // empty path would make it "/", which is an absolute path that
                        // starts at the root.
                        if (isDir && pathStr.length > 0)
                          pathStr += "/";

                        if (isAbs)
                          pathStr = "/" + pathStr;

                        return pathStr;
                      };
                      URI.prototype.makeAbsoluteURI = function(base_uri) {
                        if (this.isAbsolute() || base_uri.isRelative()) {
                          // This URI needs to be relative, and the base needs to be
                          // absolute otherwise we won't know what to do!
                          return false;
                        }

                        // Make a copy of the base URI.  We don't want to modify
                        // the passed URI.
                        var base = new URI();
                        base.copyURI(base_uri);

                        // ChDir on the base URI.  This will preserve any query
                        // and fragment we have.
                        if (base.chdir(URI.toString()) == false)
                          return false;

                        // It worked, so copy the base into this one
                        this.copyURI(base);

                        return true;
                      };
                      URI.prototype.makeRelativeURI = function(base_uri, caseSensitive) {
                        caseSensitive = AS3JS.Utils.getDefaultValue(caseSensitive, true);
                        var base = new URI();
                        base.copyURI(base_uri);

                        var thisParts, thatParts: Array;
                        var finalParts = [];
                        var thisPart, thatPart: String, finalPath: String;
                        var pathStr = this.get_path();
                        var queryStr = this.get_queryRaw();
                        var fragmentStr = this.get_fragment();
                        var i;
                        var diff = false;
                        var isDir = false;

                        if (this.isRelative()) {
                          // We're already relative.
                          return true;
                        }

                        if (base.isRelative()) {
                          // The base is relative.  A relative base doesn't make sense.
                          return false;
                        }

                        if ((this.isOfType(base_uri.get_scheme()) == false) ||
                          (this.get_authority() != base_uri.get_authority())) {
                          // The schemes and/or authorities are different.  We can't
                          // make a relative path to something that is completely
                          // unrelated.
                          return false;
                        }

                        // Record the state of this URI
                        isDir = this.isDirectory();

                        // We are based of the directory of the given URI.  We need to
                        // make sure the URI is pointing to a directory.  Changing
                        // directory to "." will remove any file name if the base is
                        // not a directory.
                        base.chdir(".");

                        thisParts = pathStr.split("/");
                        thatParts = base.get_path().split("/");

                        if (thisParts.length > 0 && thisParts[0] == "")
                          thisParts.shift();

                        if (thisParts.length > 0 && thisParts[thisParts.length - 1] == "") {
                          isDir = true;
                          thisParts.pop();
                        }

                        if (thatParts.length > 0 && thatParts[0] == "")
                          thatParts.shift();
                        if (thatParts.length > 0 && thatParts[thatParts.length - 1] == "")
                          thatParts.pop();

                        // Now that we have the paths split into an array of directories,
                        // we can compare the two paths.  We start from the left of side
                        // of the path and start comparing.  When we either run out of
                        // directories (one path is longer than the other), or we find
                        // a directory that is different, we stop.  The remaining parts
                        // of each path is then used to determine the relative path.  For
                        // example, lets say we have:
                        //    path we want to make relative: /a/b/c/d/e.txt
                        //    path to use as base for relative: /a/b/f/
                        //
                        // This loop will start at the left, and remove directories
                        // until we get a mismatch or run off the end of one of them.
                        // In this example, the result will be:
                        //    c/d/e.txt
                        //    f
                        //
                        // For every part left over in the base path, we prepend a ".."
                        // to the relative to get the final path:
                        //   ../c/d/e.txt
                        while (thatParts.length > 0) {
                          if (thisParts.length == 0) {
                            // we matched all there is to match, we are done.
                            // This is the case where "this" object is a parent
                            // path of the given URI.  eg:
                            //   this.path = /a/b/        (thisParts)
                            //   base.path = /a/b/c/d/e/    (thatParts)
                            break;
                          }

                          thisPart = thisParts[0];
                          thatPart = thatParts[0];

                          if (URI.compareStr(thisPart, thatPart, caseSensitive)) {
                            thisParts.shift();
                            thatParts.shift();
                          } else
                            break;
                        }

                        // If there are any path info left from the base URI, that means
                        // **this** object is above the given URI in the file tree.  For
                        // each part left over in the given URI, we need to move up one
                        // directory to get where we are.
                        var dotdot = "..";
                        for (i = 0; i < thatParts.length; i++) {
                          finalParts.push(dotdot);
                        }

                        // Append the parts of this URI to any dot-dot's we have
                        finalParts = finalParts.concat(thisParts);

                        // Join the parts back into a path
                        finalPath = this.joinPath(finalParts, false /* not absolute */ , isDir);

                        if (finalPath.length == 0) {
                          // The two URI's are exactly the same.  The proper relative
                          // path is:
                          finalPath = "./";
                        }

                        // Set the parts of the URI, preserving the original query and
                        // fragment parts.
                        this.setParts("", "", "", finalPath, queryStr, fragmentStr);

                        return true;
                      };
                      URI.prototype.unknownToURI = function(unknown, defaultScheme) {
                        defaultScheme = AS3JS.Utils.getDefaultValue(defaultScheme, "http");
                        var temp;

                        if (unknown.length == 0) {
                          this.initialize();
                          return false;
                        }

                        // Some users love the backslash key.  Fix it.
                        unknown = unknown.replace(/\\/g, "/");

                        // Check for any obviously missing scheme.
                        if (unknown.length >= 2) {
                          temp = unknown.substr(0, 2);
                          if (temp == "//")
                            unknown = defaultScheme + ":" + unknown;
                        }

                        if (unknown.length >= 3) {
                          temp = unknown.substr(0, 3);
                          if (temp == "://")
                            unknown = defaultScheme + unknown;
                        }

                        // Try parsing it as a normal URI
                        var uri = new URI(unknown);

                        if (uri.isHierarchical() == false) {
                          if (uri.get_scheme() == URI.UNKNOWN_SCHEME) {
                            this.initialize();
                            return false;
                          }

                          // It's a non-hierarchical URI
                          this.copyURI(uri);
                          this.forceEscape();
                          return true;
                        } else if ((uri.get_scheme() != URI.UNKNOWN_SCHEME) &&
                          (uri.get_scheme().length > 0)) {
                          if ((uri.get_authority().length > 0) ||
                            (uri.get_scheme() == "file")) {
                            // file://... URI
                            this.copyURI(uri);
                            this.forceEscape(); // ensure proper escaping
                            return true;
                          } else if (uri.get_authority().length == 0 && uri.get_path().length == 0) {
                            // It's is an incomplete URI (eg "http://")

                            this.setParts(uri.get_scheme(), "", "", "", "", "");
                            return false;
                          }
                        } else {
                          // Possible relative URI.  We can only detect relative URI's
                          // that start with "." or "..".  If it starts with something
                          // else, the parsing is ambiguous.
                          var path = uri.get_path();

                          if (path == ".." || path == "." ||
                            (path.length >= 3 && path.substr(0, 3) == "../") ||
                            (path.length >= 2 && path.substr(0, 2) == "./")) {
                            // This is a relative URI.
                            this.copyURI(uri);
                            this.forceEscape();
                            return true;
                          }
                        }

                        // Ok, it looks like we are just a normal URI missing the scheme.  Tack
                        // on the scheme.
                        uri = new URI(defaultScheme + "://" + unknown);

                        // Check to see if we are good now
                        if (uri.get_scheme().length > 0 && uri.get_authority().length > 0) {
                          // It was just missing the scheme.
                          this.copyURI(uri);
                          this.forceEscape(); // Make sure we are properly encoded.
                          return true;
                        }

                        // don't know what this is
                        this.initialize();
                        return false;
                      }

                      module.exports = URI;
                    };
                    Program["com.adobe.net.URIEncodingBitmap"] = function(module, exports) {
                      var URIEncodingBitmap = function(charsToEscape) {
                        var i;
                        var data = new ByteArray();

                        // Initialize our 128 bits (16 bytes) to zero
                        for (i = 0; i < 16; i++)
                          this.writeByte(0);

                        data.writeUTFBytes(charsToEscape);
                        data.position = 0;

                        while (data.bytesAvailable) {
                          var c = data.readByte();

                          if (c > 0x7f)
                            continue; // only escape low bytes

                          var enc;
                          this.position = (c >> 3);
                          enc = this.readByte();
                          enc |= 1 << (c & 0x7);
                          this.position = (c >> 3);
                          this.writeByte(enc);
                        }
                      };

                      URIEncodingBitmap.prototype = Object.create(ByteArray.prototype);

                      URIEncodingBitmap.prototype.ShouldEscape = function(char) {
                        var data = new ByteArray();
                        var c, mask: int;

                        // write the character into a ByteArray so
                        // we can pull it out as a raw byte value.
                        data.writeUTFBytes(char);
                        data.position = 0;
                        c = data.readByte();

                        if (c & 0x80) {
                          // don't escape high byte characters.  It can make international
                          // URI's unreadable.  We just want to escape characters that would
                          // make URI syntax ambiguous.
                          return 0;
                        } else if ((c < 0x1f) || (c == 0x7f)) {
                          // control characters must be escaped.
                          return c;
                        }

                        this.position = (c >> 3);
                        mask = this.readByte();

                        if (mask & (1 << (c & 0x7))) {
                          // we need to escape this, return the numeric value
                          // of the character
                          return c;
                        } else {
                          return 0;
                        }
                      }

                      module.exports = URIEncodingBitmap;
                    };
                    Program["com.adobe.net.proxies.RFC2817Socket"] = function(module, exports) {
                      var RFC2817Socket = function(host, port) {
                        this.deferredEventHandlers = new Object();
                        host = AS3JS.Utils.getDefaultValue(host, null);
                        port = AS3JS.Utils.getDefaultValue(port, 0);
                        if (host != null && port != 0) {
                          Socket.call(this, host, port);
                        }
                      };

                      RFC2817Socket.prototype = Object.create(Socket.prototype);

                      RFC2817Socket.prototype.proxyHost = null;
                      RFC2817Socket.prototype.host = null;
                      RFC2817Socket.prototype.proxyPort = 0;
                      RFC2817Socket.prototype.port = 0;
                      RFC2817Socket.prototype.deferredEventHandlers = null;
                      RFC2817Socket.prototype.buffer = new String();
                      RFC2817Socket.prototype.setProxyInfo = function(host, port) {
                        this.proxyHost = host;
                        this.proxyPort = port;

                        var deferredSocketDataHandler = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
                        var deferredConnectHandler = this.deferredEventHandlers[Event.CONNECT];

                        if (deferredSocketDataHandler != null) {
                          Socket.prototype.removeEventListener.call(this, ProgressEvent.SOCKET_DATA, deferredSocketDataHandler.listener, deferredSocketDataHandler.useCapture);
                        }

                        if (deferredConnectHandler != null) {
                          Socket.prototype.removeEventListener.call(this, Event.CONNECT, deferredConnectHandler.listener, deferredConnectHandler.useCapture);
                        }
                      };
                      RFC2817Socket.prototype.connect = function(host, port) {
                        if (this.proxyHost == null) {
                          this.redirectConnectEvent();
                          this.redirectSocketDataEvent();
                          Socket.prototype.connect.call(this, host, port);
                        } else {
                          this.host = host;
                          this.port = port;
                          Socket.prototype.addEventListener.call(this, Event.CONNECT, this.onConnect);
                          Socket.prototype.addEventListener.call(this, ProgressEvent.SOCKET_DATA, this.onSocketData);
                          Socket.prototype.connect.call(this, this.proxyHost, this.proxyPort);
                        }
                      };
                      RFC2817Socket.prototype.onConnect = function(event) {
                        this.writeUTFBytes("CONNECT " + this.host + ":" + this.port + " HTTP/1.1\n\n");
                        this.flush();
                        this.redirectConnectEvent();
                      };
                      RFC2817Socket.prototype.onSocketData = function(event) {
                        while (this.bytesAvailable != 0) {
                          this.buffer += this.readUTFBytes(1);
                          if (this.buffer.search(/\r?\n\r?\n$/) != -1) {
                            this.checkResponse(event);
                            break;
                          }
                        }
                      };
                      RFC2817Socket.prototype.checkResponse = function(event) {
                        var responseCode = this.buffer.substr(this.buffer.indexOf(" ") + 1, 3);

                        if (responseCode.search(/^2/) == -1) {
                          var ioError = new IOErrorEvent(IOErrorEvent.IO_ERROR);
                          ioError.text = "Error connecting to the proxy [" + this.proxyHost + "] on port [" + this.proxyPort + "]: " + this.buffer;
                          this.dispatchEvent(ioError);
                        } else {
                          this.redirectSocketDataEvent();
                          this.dispatchEvent(new Event(Event.CONNECT));
                          if (this.bytesAvailable > 0) {
                            this.dispatchEvent(event);
                          }
                        }
                        this.buffer = null;
                      };
                      RFC2817Socket.prototype.redirectConnectEvent = function() {
                        Socket.prototype.removeEventListener.call(this, Event.CONNECT, this.onConnect);
                        var deferredEventHandler = this.deferredEventHandlers[Event.CONNECT];
                        if (deferredEventHandler != null) {
                          Socket.prototype.addEventListener.call(this, Event.CONNECT, deferredEventHandler.listener, deferredEventHandler.useCapture, deferredEventHandler.priority, deferredEventHandler.useWeakReference);
                        }
                      };
                      RFC2817Socket.prototype.redirectSocketDataEvent = function() {
                        Socket.prototype.removeEventListener.call(this, ProgressEvent.SOCKET_DATA, this.onSocketData);
                        var deferredEventHandler = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
                        if (deferredEventHandler != null) {
                          Socket.prototype.addEventListener.call(this, ProgressEvent.SOCKET_DATA, deferredEventHandler.listener, deferredEventHandler.useCapture, deferredEventHandler.priority, deferredEventHandler.useWeakReference);
                        }
                      };
                      RFC2817Socket.prototype.addEventListener = function(type, listener, useCapture, priority, useWeakReference) {
                        useCapture = AS3JS.Utils.getDefaultValue(useCapture, false);
                        priority = AS3JS.Utils.getDefaultValue(priority, 0.0);
                        useWeakReference = AS3JS.Utils.getDefaultValue(useWeakReference, false);
                        if (type == Event.CONNECT || type == ProgressEvent.SOCKET_DATA) {
                          this.deferredEventHandlers[type] = {
                            listener: listener,
                            useCapture: useCapture,
                            priority: priority,
                            useWeakReference: useWeakReference
                          };
                        } else {
                          Socket.prototype.addEventListener.call(this, type, listener, useCapture, priority, useWeakReference);
                        }
                      }

                      module.exports = RFC2817Socket;
                    };
                    Program["com.serialization.json.JSON"] = function(module, exports) {
                      var JSON = function JSON() {};

                      JSON.deserialize = function(source) {

                        source = new String(source); // Speed
                        var at = 0;
                        var ch = ' ';

                        var _isDigit;
                        var _isHexDigit;
                        var _white;
                        var _string;
                        var _next;
                        var _array;
                        var _object;
                        var _number;
                        var _word;
                        var _value;
                        var _error;

                        _isDigit = function(c) {
                          return (("0" <= c) && (c <= "9"));
                        };

                        _isHexDigit = function(c) {
                          return (_isDigit(c) || (("A" <= c) && (c <= "F")) || (("a" <= c) && (c <= "f")));
                        };

                        _error = function(m) {
                          //throw new JSONError( m, at - 1 , source) ;
                          throw new Error(m, at - 1);
                        };

                        _next = function() {
                          ch = source.charAt(at);
                          at += 1;
                          return ch;
                        };

                        _white = function() {
                          while (ch) {
                            if (ch <= ' ') {
                              _next();
                            } else if (ch == '/') {
                              switch (_next()) {
                                case '/':
                                  while (_next() && ch != '\n' && ch != '\r') {}
                                  break;
                                case '*':
                                  _next();
                                  for (;;) {
                                    if (ch) {
                                      if (ch == '*') {
                                        if (_next() == '/') {
                                          _next();
                                          break;
                                        }
                                      } else {
                                        _next();
                                      }
                                    } else {
                                      _error("Unterminated Comment");
                                    }
                                  }
                                  break;
                                default:
                                  _error("Syntax Error");
                              }
                            } else {
                              break;
                            }
                          }
                        };

                        _string = function() {

                          var i = '';
                          var s = '';
                          var t;
                          var u;
                          var outer = false;

                          if (ch == '"') {

                            while (_next()) {
                              if (ch == '"') {
                                _next();
                                return s;
                              } else if (ch == '\\') {
                                switch (_next()) {
                                  case 'b':
                                    s += '\b';
                                    break;
                                  case 'f':
                                    s += '\f';
                                    break;
                                  case 'n':
                                    s += '\n';
                                    break;
                                  case 'r':
                                    s += '\r';
                                    break;
                                  case 't':
                                    s += '\t';
                                    break;
                                  case 'u':
                                    u = 0;
                                    for (i = 0; i < 4; i += 1) {
                                      t = parseInt(_next(), 16);
                                      if (!isFinite(t)) {
                                        outer = true;
                                        break;
                                      }
                                      u = u * 16 + t;
                                    }
                                    if (outer) {
                                      outer = false;
                                      break;
                                    }
                                    s += String.fromCharCode(u);
                                    break;
                                  default:
                                    s += ch;
                                }
                              } else {
                                s += ch;
                              }
                            }
                          }
                          _error("Bad String");
                          return null;
                        };

                        _array = function() {
                          var a = [];
                          if (ch == '[') {
                            _next();
                            _white();
                            if (ch == ']') {
                              _next();
                              return a;
                            }
                            while (ch) {
                              a.push(_value());
                              _white();
                              if (ch == ']') {
                                _next();
                                return a;
                              } else if (ch != ',') {
                                break;
                              }
                              _next();
                              _white();
                              // Allow for an extra comma before ending bracket
                              if (ch == ']') {
                                _next();
                                return a;
                              }
                            }
                          }
                          _error("Bad Array");
                          return null;
                        };

                        _object = function() {
                          var k = {};
                          var o = {};
                          if (ch == '{') {

                            _next();

                            _white();

                            if (ch == '}') {
                              _next();
                              return o;
                            }

                            while (ch) {
                              k = _string();
                              _white();
                              if (ch != ':') {
                                break;
                              }
                              _next();
                              o[k] = _value();
                              _white();
                              if (ch == '}') {
                                _next();
                                return o;
                              } else if (ch != ',') {
                                break;
                              }
                              _next();
                              _white();
                              // Allow for an extra comma before ending brace
                              if (ch == '}') {
                                _next();
                                return o;
                              }
                            }
                          }
                          _error("Bad Object");
                        };

                        _number = function() {

                          var n = '';
                          var e = '';
                          var v;
                          var exp;
                          var hex = '';
                          var sign = '';

                          if (ch == '-') {
                            n = '-';
                            sign = n;
                            _next();
                          }

                          if (ch == "0") {
                            _next();
                            if ((ch == "x") || (ch == "X")) {
                              _next();
                              while (_isHexDigit(ch)) {
                                hex += ch;
                                _next();
                              }
                              if (hex == "") {
                                _error("mal formed Hexadecimal");
                              } else {
                                return Number(sign + "0x" + hex);
                              }
                            } else {
                              n += "0";
                            }
                          }

                          while (_isDigit(ch)) {
                            n += ch;
                            _next();
                          }
                          if (ch == '.') {
                            n += '.';
                            while (_next() && ch >= '0' && ch <= '9') {
                              n += ch;
                            }
                          }
                          v = 1 * n;
                          if (!isFinite(v)) {
                            _error("Bad Number");
                          } else {
                            if ((ch == 'e') || (ch == 'E')) {
                              // Continue processing exponent
                              _next();
                              var expSign = (ch == '-') ? -1 : 1;
                              // allow for a digit without a + sign
                              if ((ch == '+') || (ch == '-')) {
                                _next();
                              }
                              if (_isDigit(ch)) {
                                e += ch;
                              } else {
                                _error("Bad Exponent");
                              }
                              while (_next() && ch >= '0' && ch <= '9') {
                                e += ch;
                              }
                              exp = expSign * e;
                              if (!isFinite(v)) {
                                _error("Bad Exponent");
                              } else {
                                v = v * Math.pow(10, exp);
                                //trace("JSON._number - have exponent: n=" + n + "  e=" + e + "  v=" + v);
                              }
                            }
                            return v;
                          }

                          return NaN;

                        };

                        _word = function() {
                          switch (ch) {
                            case 't':
                              if (_next() == 'r' && _next() == 'u' && _next() == 'e') {
                                _next();
                                return true;
                              }
                              break;
                            case 'f':
                              if (_next() == 'a' && _next() == 'l' && _next() == 's' && _next() == 'e') {
                                _next();
                                return false;
                              }
                              break;
                            case 'n':
                              if (_next() == 'u' && _next() == 'l' && _next() == 'l') {
                                _next();
                                return null;
                              }
                              break;
                          }
                          _error("Syntax Error");
                          return null;
                        };

                        _value = function() {
                          _white();
                          switch (ch) {
                            case '{':
                              return _object();
                            case '[':
                              return _array();
                            case '"':
                              return _string();
                            case '-':
                              return _number();
                            default:
                              return ch >= '0' && ch <= '9' ? _number() : _word();
                          }
                        };

                        return _value();

                      };
                      JSON.serialize = function(o) {

                        var c; // char
                        var i;
                        var l;
                        var s = '';
                        var v;

                        switch (typeof o) {

                          case 'object':

                            if (o) {
                              if (o is Array) {

                                l = o.length;

                                for (i = 0; i < l; ++i) {
                                  v = JSON.serialize(o[i]);
                                  if (s) s += ',';
                                  s += v;
                                }
                                return '[' + s + ']';

                              } else if (typeof(o.toString) != 'undefined') {

                                for (var prop in o) {
                                  v = o[prop];
                                  if ((typeof(v) != 'undefined') && (typeof(v) != 'function')) {
                                    v = JSON.serialize(v);
                                    if (s) s += ',';
                                    s += JSON.serialize(prop) + ':' + v;
                                  }
                                }
                                return "{" + s + "}";
                              }
                            }
                            return 'null';

                          case 'number':

                            return isFinite(o) ? String(o) : 'null';

                          case 'string':

                            l = o.length;
                            s = '"';
                            for (i = 0; i < l; i += 1) {
                              c = o.charAt(i);
                              if (c >= ' ') {
                                if (c == '\\' || c == '"') {
                                  s += '\\';
                                }
                                s += c;
                              } else {
                                switch (c) {

                                  case '\b':
                                    s += '\\b';
                                    break;
                                  case '\f':
                                    s += '\\f';
                                    break;
                                  case '\n':
                                    s += '\\n';
                                    break;
                                  case '\r':
                                    s += '\\r';
                                    break;
                                  case '\t':
                                    s += '\\t';
                                    break;
                                  default:
                                    var code = c.charCodeAt();
                                    s += '\\u00' + (Math.floor(code / 16).JSON.toString(16)) + ((code % 16).JSON.toString(16));
                                }
                              }
                            }
                            return s + '"';

                          case 'boolean':
                            return String(o);

                          default:
                            return 'null';

                        }
                      };

                      module.exports = JSON;
                    };
                    Program["com.adobe.serialization.json.JSONDecoder"] = function(module, exports) {
                      var JSONTokenizer, JSONTokenType;
                      module.inject = function() {
                        JSONTokenizer = module.import('com.adobe.serialization.json', 'JSONTokenizer');
                        JSONTokenType = module.import('com.adobe.serialization.json', 'JSONTokenType');
                      };

                      var JSONDecoder = function(s) {
                        this.value = null;
                        this.tokenizer = null;
                        this.token = null;

                        this.tokenizer = new JSONTokenizer(s);

                        this.nextToken();
                        this.value = this.parseValue();
                      };

                      JSONDecoder.prototype.value = null;
                      JSONDecoder.prototype.tokenizer = null;
                      JSONDecoder.prototype.token = null;
                      JSONDecoder.prototype.getValue = function() {
                        return this.value;
                      };
                      JSONDecoder.prototype.nextToken = function() {
                        return this.token = this.tokenizer.getNextToken();
                      };
                      JSONDecoder.prototype.parseArray = function() {
                        // create an array internally that we're going to attempt
                        // to parse from the tokenizer
                        var a = [];

                        // grab the next token from the tokenizer to move
                        // past the opening [
                        this.nextToken();

                        // check to see if we have an empty array
                        if (this.token.get_type() == JSONTokenType.RIGHT_BRACKET) {
                          // we're done reading the array, so return it
                          return a;
                        }

                        // deal with elements of the array, and use an "infinite"
                        // loop because we could have any amount of elements
                        while (true) {
                          // read in the value and add it to the array
                          a.push(this.parseValue());

                          // after the value there should be a ] or a ,
                          this.nextToken();

                          if (this.token.get_type() == JSONTokenType.RIGHT_BRACKET) {
                            // we're done reading the array, so return it
                            return a;
                          } else if (this.token.get_type() == JSONTokenType.COMMA) {
                            // move past the comma and read another value
                            this.nextToken();
                          } else {
                            this.tokenizer.parseError("Expecting ] or , but found " + this.token.get_value());
                          }
                        }
                        return null;
                      };
                      JSONDecoder.prototype.parseObject = function() {
                        // create the object internally that we're going to
                        // attempt to parse from the tokenizer
                        var o = new Object();

                        // store the string part of an object member so
                        // that we can assign it a value in the object
                        var key

                        // grab the next token from the tokenizer
                        this.nextToken();

                        // check to see if we have an empty object
                        if (this.token.get_type() == JSONTokenType.RIGHT_BRACE) {
                          // we're done reading the object, so return it
                          return o;
                        }

                        // deal with members of the object, and use an "infinite"
                        // loop because we could have any amount of members
                        while (true) {

                          if (this.token.get_type() == JSONTokenType.STRING) {
                            // the string value we read is the key for the object
                            key = String(this.token.get_value());

                            // move past the string to see what's next
                            this.nextToken();

                            // after the string there should be a :
                            if (this.token.get_type() == JSONTokenType.COLON) {

                              // move past the : and read/assign a value for the key
                              this.nextToken();
                              o[key] = this.parseValue();

                              // move past the value to see what's next
                              this.nextToken();

                              // after the value there's either a } or a ,
                              if (this.token.get_type() == JSONTokenType.RIGHT_BRACE) {
                                // // we're done reading the object, so return it
                                return o;

                              } else if (this.token.get_type() == JSONTokenType.COMMA) {
                                // skip past the comma and read another member
                                this.nextToken();
                              } else {
                                this.tokenizer.parseError("Expecting } or , but found " + this.token.get_value());
                              }
                            } else {
                              this.tokenizer.parseError("Expecting : but found " + this.token.get_value());
                            }
                          } else {
                            this.tokenizer.parseError("Expecting string but found " + this.token.get_value());
                          }
                        }
                        return null;
                      };
                      JSONDecoder.prototype.parseValue = function() {

                        switch (this.token.get_type()) {
                          case JSONTokenType.LEFT_BRACE:
                            return this.parseObject();

                          case JSONTokenType.LEFT_BRACKET:
                            return this.parseArray();

                          case JSONTokenType.STRING:
                          case JSONTokenType.NUMBER:
                          case JSONTokenType.TRUE:
                          case JSONTokenType.FALSE:
                          case JSONTokenType.NULL:
                            return this.token.get_value();

                          default:
                            this.tokenizer.parseError("Unexpected " + this.token.get_value());

                        }
                        return null;
                      }

                      module.exports = JSONDecoder;
                    };
                    Program["com.adobe.serialization.json.JSONEncoder"] = function(module, exports) {
                      var JSONEncoder = function(value) {
                        this.jsonString = this.convertToString(value);

                      };

                      JSONEncoder.prototype.jsonString = null;
                      JSONEncoder.prototype.getString = function() {
                        return this.jsonString;
                      };
                      JSONEncoder.prototype.convertToString = function(value) {

                        // determine what value is and convert it based on it's type
                        if (value is String) {

                          // escape the string so it's formatted correctly
                          return this.escapeString((String) value);

                        } else if (value is Number) {

                          // only encode numbers that finate
                          return isFinite((Number) value) ? value.toString() : "null";

                        } else if (value is Boolean) {

                          // convert boolean to string easily
                          return value ? "true" : "false";

                        } else if (value is Array) {

                          // call the helper method to convert an array
                          return this.arrayToString((Array) value);

                        } else if (value is Object && value != null) {

                          // call the helper method to convert an object
                          return this.objectToString(value);
                        }
                        return "null";
                      };
                      JSONEncoder.prototype.escapeString = function(str) {
                        // create a string to store the string's jsonstring value
                        var s = "";
                        // current character in the string we're processing
                        var ch;
                        // store the length in a local variable to reduce lookups
                        var len = str.length;

                        // loop over all of the characters in the string
                        for (var i = 0; i < len; i++) {

                          // examine the character to determine if we have to escape it
                          ch = str.charAt(i);
                          switch (ch) {

                            case '"': // quotation mark
                              s += "\\\"";
                              break;

                              //case '/':  // solidus
                              //  s += "\\/";
                              //  break;

                            case '\\': // reverse solidus
                              s += "\\\\";
                              break;

                            case '\b': // bell
                              s += "\\b";
                              break;

                            case '\f': // form feed
                              s += "\\f";
                              break;

                            case '\n': // newline
                              s += "\\n";
                              break;

                            case '\r': // carriage return
                              s += "\\r";
                              break;

                            case '\t': // horizontal tab
                              s += "\\t";
                              break;

                            default: // everything else

                              // check for a control character and escape as unicode
                              if (ch < ' ') {
                                // get the hex digit(s) of the character (either 1 or 2 digits)
                                var hexCode = ch.charCodeAt(0).toString(16);

                                // ensure that there are 4 digits by adjusting
                                // the # of zeros accordingly.
                                var zeroPad = hexCode.length == 2 ? "00" : "000";

                                // create the unicode escape sequence with 4 hex digits
                                s += "\\u" + zeroPad + hexCode;
                              } else {

                                // no need to do any special encoding, just pass-through
                                s += ch;

                              }
                          } // end switch

                        } // end for loop

                        return "\"" + s + "\"";
                      };
                      JSONEncoder.prototype.arrayToString = function(a) {
                        // create a string to store the array's jsonstring value
                        var s = "";

                        // loop over the elements in the array and add their converted
                        // values to the string
                        for (var i = 0; i < a.length; i++) {
                          // when the length is 0 we're adding the first element so
                          // no comma is necessary
                          if (s.length > 0) {
                            // we've already added an element, so add the comma separator
                            s += ","
                          }

                          // convert the value to a string
                          s += this.convertToString(a[i]);
                        }

                        // KNOWN ISSUE:  In ActionScript, Arrays can also be associative
                        // objects and you can put anything in them, ie:
                        //    myArray["foo"] = "bar";
                        //
                        // These properties aren't picked up in the for loop above because
                        // the properties don't correspond to indexes.  However, we're
                        // sort of out luck because the JSON specification doesn't allow
                        // these types of array properties.
                        //
                        // So, if the array was also used as an associative object, there
                        // may be some values in the array that don't get properly encoded.
                        //
                        // A possible solution is to instead encode the Array as an Object
                        // but then it won't get decoded correctly (and won't be an
                        // Array instance)

                        // close the array and return it's string value
                        return "[" + s + "]";
                      };
                      JSONEncoder.prototype.objectToString = function(o) {
                        // create a string to store the object's jsonstring value
                        var s = "";

                        // determine if o is a class instance or a plain object
                        var classInfo = describeType(o);
                        if (classInfo.@name.toString() == "Object") {
                          // the value of o[key] in the loop below - store this 
                          // as a variable so we don't have to keep looking up o[key]
                          // when testing for valid values to convert
                          var value;

                          // loop over the keys in the object and add their converted
                          // values to the string
                          for (var key in o) {
                            // assign value to a variable for quick lookup
                            value = o[key];

                            // don't add function's to the JSON string
                            if (value is Function) {
                              // skip this key and try another
                              continue;
                            }

                            // when the length is 0 we're adding the first item so
                            // no comma is necessary
                            if (s.length > 0) {
                              // we've already added an item, so add the comma separator
                              s += ","
                            }

                            s += this.escapeString(key) + ":" + this.convertToString(value);
                          }
                        } else // o is a class instance
                        {
                          // Loop over all of the variables and accessors in the class and 
                          // serialize them along with their values.
                          for each(var v in classInfo..*.(name() == "variable" || name() == "accessor")) {
                            // When the length is 0 we're adding the first item so
                            // no comma is necessary
                            if (s.length > 0) {
                              // We've already added an item, so add the comma separator
                              s += ","
                            }

                            s += this.escapeString(v.@name.toString()) + ":" + this.convertToString(o[v.@name]);
                          }

                        }

                        return "{" + s + "}";
                      }

                      module.exports = JSONEncoder;
                    };
                    Program["com.adobe.serialization.json.JSONParseError"] = function(module, exports) {
                      var JSONParseError = function(message, location, text) {
                        message = AS3JS.Utils.getDefaultValue(message, "");
                        location = AS3JS.Utils.getDefaultValue(location, 0);
                        text = AS3JS.Utils.getDefaultValue(text, "");
                        Error.call(this, message);
                        //name = "JSONParseError";
                        this._location = location;
                        this._text = text;
                      };

                      JSONParseError.prototype = Object.create(Error.prototype);

                      JSONParseError.prototype.get_location = function() {
                        return this._location;
                      };
                      JSONParseError.prototype.get_text = function() {
                        return this._text;
                      };
                      JSONParseError.prototype._location = 0;
                      JSONParseError.prototype._text = null

                      module.exports = JSONParseError;
                    };
                    Program["com.adobe.serialization.json.JSONToken"] = function(module, exports) {
                      var JSONToken = function(type, value) {
                        this._value = null;
                        type = AS3JS.Utils.getDefaultValue(type, -1 /* JSONTokenType.UNKNOWN */ );
                        value = AS3JS.Utils.getDefaultValue(value, null);
                        this._type = type;
                        this._value = value;
                      };

                      JSONToken.prototype.get_type = function() {
                        return this._type;
                      };
                      JSONToken.prototype.get_value = function() {
                        return this._value;
                      };
                      JSONToken.prototype.set_type = function(value) {
                        this._type = value;
                      };
                      JSONToken.prototype.set_value = function(v) {
                        this._value = v;
                      };
                      JSONToken.prototype._type = 0;
                      JSONToken.prototype._value = null

                      module.exports = JSONToken;
                    };
                    Program["com.adobe.serialization.json.JSONTokenizer"] = function(module, exports) {
                      var JSONParseError, JSONToken, JSONTokenType;
                      module.inject = function() {
                        JSONParseError = module.import('com.adobe.serialization.json', 'JSONParseError');
                        JSONToken = module.import('com.adobe.serialization.json', 'JSONToken');
                        JSONTokenType = module.import('com.adobe.serialization.json', 'JSONTokenType');
                      };

                      var JSONTokenizer = function(s) {
                        this.obj = null;
                        this.jsonString = s;
                        this.loc = 0;

                        // prime the pump by getting the first character
                        this.nextChar();
                      };

                      JSONTokenizer.prototype.obj = null;
                      JSONTokenizer.prototype.jsonString = null;
                      JSONTokenizer.prototype.loc = 0;
                      JSONTokenizer.prototype.ch = null;
                      JSONTokenizer.prototype.getNextToken = function() {
                        var token = new JSONToken();

                        // skip any whitespace / comments since the last 
                        // token was read
                        this.skipIgnored();

                        // examine the new character and see what we have...
                        switch (this.ch) {

                          case '{':
                            token.set_type(JSONTokenType.LEFT_BRACE);
                            token.set_value('{');
                            this.nextChar();
                            break

                          case '}':
                            token.set_type(JSONTokenType.RIGHT_BRACE);
                            token.set_value('}');
                            this.nextChar();
                            break

                          case '[':
                            token.set_type(JSONTokenType.LEFT_BRACKET);
                            token.set_value('[');
                            this.nextChar();
                            break

                          case ']':
                            token.set_type(JSONTokenType.RIGHT_BRACKET);
                            token.set_value(']');
                            this.nextChar();
                            break

                          case ',':
                            token.set_type(JSONTokenType.COMMA);
                            token.set_value(',');
                            this.nextChar();
                            break

                          case ':':
                            token.set_type(JSONTokenType.COLON);
                            token.set_value(':');
                            this.nextChar();
                            break;

                          case 't': // attempt to read true
                            var possibleTrue = "t" + this.nextChar() + this.nextChar() + this.nextChar();

                            if (possibleTrue == "true") {
                              token.set_type(JSONTokenType.TRUE);
                              token.set_value(true);
                              this.nextChar();
                            } else {
                              this.parseError("Expecting 'true' but found " + possibleTrue);
                            }

                            break;

                          case 'f': // attempt to read false
                            var possibleFalse = "f" + this.nextChar() + this.nextChar() + this.nextChar() + this.nextChar();

                            if (possibleFalse == "false") {
                              token.set_type(JSONTokenType.FALSE);
                              token.set_value(false);
                              this.nextChar();
                            } else {
                              this.parseError("Expecting 'false' but found " + possibleFalse);
                            }

                            break;

                          case 'n': // attempt to read null

                            var possibleNull = "n" + this.nextChar() + this.nextChar() + this.nextChar();

                            if (possibleNull == "null") {
                              token.set_type(JSONTokenType.NULL);
                              token.set_value(null);
                              this.nextChar();
                            } else {
                              this.parseError("Expecting 'null' but found " + possibleNull);
                            }

                            break;

                          case '"': // the start of a string
                            token = this.readString();
                            break;

                          default:
                            // see if we can read a number
                            if (this.isDigit(this.ch) || this.ch == '-') {
                              token = this.readNumber();
                            } else if (this.ch == '') {
                              // check for reading past the end of the string
                              return null;
                            } else {
                              // not sure what was in the input string - it's not
                              // anything we expected
                              this.parseError("Unexpected " + this.ch + " encountered");
                            }
                        }

                        return token;
                      };
                      JSONTokenizer.prototype.readString = function() {
                        // the token for the string we'll try to read
                        var token = new JSONToken();
                        token.set_type(JSONTokenType.STRING);

                        // the string to store the string we'll try to read
                        var string = "";

                        // advance past the first "
                        this.nextChar();

                        while (this.ch != '"' && this.ch != '') {

                          // unescape the escape sequences in the string
                          if (this.ch == '\\') {

                            // get the next character so we know what
                            // to unescape
                            this.nextChar();

                            switch (this.ch) {

                              case '"': // quotation mark
                                string += '"';
                                break;

                              case '/': // solidus
                                string += "/";
                                break;

                              case '\\': // reverse solidus
                                string += '\\';
                                break;

                              case 'b': // bell
                                string += '\b';
                                break;

                              case 'f': // form feed
                                string += '\f';
                                break;

                              case 'n': // newline
                                string += '\n';
                                break;

                              case 'r': // carriage return
                                string += '\r';
                                break;

                              case 't': // horizontal tab
                                string += '\t'
                                break;

                              case 'u':
                                // convert a unicode escape sequence
                                // to it's character value - expecting
                                // 4 hex digits

                                // save the characters as a string we'll convert to an int
                                var hexValue = "";

                                // try to find 4 hex characters
                                for (var i = 0; i < 4; i++) {
                                  // get the next character and determine
                                  // if it's a valid hex digit or not
                                  if (!this.isHexDigit(this.nextChar())) {
                                    this.parseError(" Excepted a hex digit, but found: " + this.ch);
                                  }
                                  // valid, add it to the value
                                  hexValue += this.ch;
                                }

                                // convert hexValue to an integer, and use that
                                // integrer value to create a character to add
                                // to our string.
                                string += String.fromCharCode(parseInt(hexValue, 16));

                                break;

                              default:
                                // couldn't unescape the sequence, so just
                                // pass it through
                                string += '\\' + this.ch;

                            }

                          } else {
                            // didn't have to unescape, so add the character to the string
                            string += this.ch;

                          }

                          // move to the next character
                          this.nextChar();

                        }

                        // we read past the end of the string without closing it, which
                        // is a parse error
                        if (this.ch == '') {
                          this.parseError("Unterminated string literal");
                        }

                        // move past the closing " in the input string
                        this.nextChar();

                        // attach to the string to the token so we can return it
                        token.set_value(string);

                        return token;
                      };
                      JSONTokenizer.prototype.readNumber = function() {
                        // the token for the number we'll try to read
                        var token = new JSONToken();
                        token.set_type(JSONTokenType.NUMBER);

                        // the string to accumulate the number characters
                        // into that we'll convert to a number at the end
                        var input = "";

                        // check for a negative number
                        if (this.ch == '-') {
                          input += '-';
                          this.nextChar();
                        }

                        // the number must start with a digit
                        if (!this.isDigit(this.ch)) {
                          this.parseError("Expecting a digit");
                        }

                        // 0 can only be the first digit if it
                        // is followed by a decimal point
                        if (this.ch == '0') {
                          input += this.ch;
                          this.nextChar();

                          // make sure no other digits come after 0
                          if (this.isDigit(this.ch)) {
                            this.parseError("A digit cannot immediately follow 0");
                          }
                        } else {
                          // read numbers while we can
                          while (this.isDigit(this.ch)) {
                            input += this.ch;
                            this.nextChar();
                          }
                        }

                        // check for a decimal value
                        if (this.ch == '.') {
                          input += '.';
                          this.nextChar();

                          // after the decimal there has to be a digit
                          if (!this.isDigit(this.ch)) {
                            this.parseError("Expecting a digit");
                          }

                          // read more numbers to get the decimal value
                          while (this.isDigit(this.ch)) {
                            input += this.ch;
                            this.nextChar();
                          }
                        }

                        // check for scientific notation
                        if (this.ch == 'e' || this.ch == 'E') {
                          input += "e"
                          this.nextChar();
                          // check for sign
                          if (this.ch == '+' || this.ch == '-') {
                            input += this.ch;
                            this.nextChar();
                          }

                          // require at least one number for the exponent
                          // in this case
                          if (!this.isDigit(this.ch)) {
                            this.parseError("Scientific notation number needs exponent value");
                          }

                          // read in the exponent
                          while (this.isDigit(this.ch)) {
                            input += this.ch;
                            this.nextChar();
                          }
                        }

                        // convert the string to a number value
                        var num = Number(input);

                        if (isFinite(num) && !isNaN(num)) {
                          token.set_value(num);
                          return token;
                        } else {
                          this.parseError("Number " + num + " is not valid!");
                        }
                        return null;
                      };
                      JSONTokenizer.prototype.nextChar = function() {
                        return this.ch = this.jsonString.charAt(this.loc++);
                      };
                      JSONTokenizer.prototype.skipIgnored = function() {
                        this.skipWhite();
                        this.skipComments();
                        this.skipWhite();
                      };
                      JSONTokenizer.prototype.skipComments = function() {
                        if (this.ch == '/') {
                          // Advance past the first / to find out what type of comment
                          this.nextChar();
                          switch (this.ch) {
                            case '/': // single-line comment, read through end of line

                              // Loop over the characters until we find
                              // a newline or until there's no more characters left
                              do {
                                this.nextChar();
                              } while (this.ch != '\n' && this.ch != '')

                              // move past the \n
                              this.nextChar();

                              break;

                            case '*': // multi-line comment, read until closing */

                              // move past the opening *
                              this.nextChar();

                              // try to find a trailing */
                              while (true) {
                                if (this.ch == '*') {
                                  // check to see if we have a closing /
                                  this.nextChar();
                                  if (this.ch == '/') {
                                    // move past the end of the closing */
                                    this.nextChar();
                                    break;
                                  }
                                } else {
                                  // move along, looking if the next character is a *
                                  this.nextChar();
                                }

                                // when we're here we've read past the end of 
                                // the string without finding a closing */, so error
                                if (this.ch == '') {
                                  this.parseError("Multi-line comment not closed");
                                }
                              }

                              break;

                              // Can't match a comment after a /, so it's a parsing error
                            default:
                              this.parseError("Unexpected " + this.ch + " encountered (expecting '/' or '*' )");
                          }
                        }

                      };
                      JSONTokenizer.prototype.skipWhite = function() {

                        // As long as there are spaces in the input 
                        // stream, advance the current location pointer
                        // past them
                        while (this.isWhiteSpace(this.ch)) {
                          this.nextChar();
                        }

                      };
                      JSONTokenizer.prototype.isWhiteSpace = function(ch) {
                        return (ch == ' ' || ch == '\t' || ch == '\n');
                      };
                      JSONTokenizer.prototype.isDigit = function(ch) {
                        return (ch >= '0' && ch <= '9');
                      };
                      JSONTokenizer.prototype.isHexDigit = function(ch) {
                        // get the uppercase value of ch so we only have
                        // to compare the value between 'A' and 'F'
                        var uc = ch.toUpperCase();

                        // a hex digit is a digit of A-F, inclusive ( using
                        // our uppercase constraint )
                        return (this.isDigit(ch) || (uc >= 'A' && uc <= 'F'));
                      };
                      JSONTokenizer.prototype.parseError = function(message) {
                        throw new JSONParseError(message, this.loc, this.jsonString);
                      }

                      module.exports = JSONTokenizer;
                    };
                    Program["com.adobe.serialization.json.JSONTokenType"] = function(module, exports) {
                      module.inject = function() {
                        JSONTokenType.UNKNOWN = -1;
                        JSONTokenType.COMMA = 0;
                        JSONTokenType.LEFT_BRACE = 1;
                        JSONTokenType.RIGHT_BRACE = 2;
                        JSONTokenType.LEFT_BRACKET = 3;
                        JSONTokenType.RIGHT_BRACKET = 4;
                        JSONTokenType.COLON = 6;
                        JSONTokenType.TRUE = 7;
                        JSONTokenType.FALSE = 8;
                        JSONTokenType.NULL = 9;
                        JSONTokenType.STRING = 10;
                        JSONTokenType.NUMBER = 11;
                      };

                      var JSONTokenType = function JSONTokenType() {};

                      JSONTokenType.UNKNOWN = -1;
                      JSONTokenType.COMMA = 0;
                      JSONTokenType.LEFT_BRACE = 1;
                      JSONTokenType.RIGHT_BRACE = 2;
                      JSONTokenType.LEFT_BRACKET = 3;
                      JSONTokenType.RIGHT_BRACKET = 4;
                      JSONTokenType.COLON = 6;
                      JSONTokenType.TRUE = 7;
                      JSONTokenType.FALSE = 8;
                      JSONTokenType.NULL = 9;
                      JSONTokenType.STRING = 10;
                      JSONTokenType.NUMBER = 11;

                      module.exports = JSONTokenType;
                    };
                    Program["com.adobe.utils.ArrayUtil"] = function(module, exports) {
                      var ArrayUtil = function ArrayUtil() {};

                      ArrayUtil.arrayContainsValue = function(arr, value) {
                        return (arr.indexOf(value) != -1);
                      };
                      ArrayUtil.removeValueFromArray = function(arr, value) {
                        var len = arr.length;

                        for (var i = len; i > -1; i--) {
                          if (arr[i] === value) {
                            arr.splice(i, 1);
                          }
                        }
                      };
                      ArrayUtil.createUniqueCopy = function(a) {
                        var newArray = [];

                        var len = a.length;
                        var item;

                        for (var i = 0; i < len; ++i) {
                          item = a[i];

                          if (ArrayUtil.arrayContainsValue(newArray, item)) {
                            continue;
                          }

                          newArray.push(item);
                        }

                        return newArray;
                      };
                      ArrayUtil.copyArray = function(arr) {
                        return arr.slice();
                      };
                      ArrayUtil.arraysAreEqual = function(arr1, arr2) {
                        if (arr1.length != arr2.length) {
                          return false;
                        }

                        var len = arr1.length;

                        for (var i = 0; i < len; i++) {
                          if (arr1[i] !== arr2[i]) {
                            return false;
                          }
                        }

                        return true;
                      };

                      module.exports = ArrayUtil;
                    };
                    Program["com.adobe.utils.DateUtil"] = function(module, exports) {
                      var DateUtil = function DateUtil() {};

                      DateUtil.getShortMonthName = function(d) {
                        return DateBase.monthNamesShort[d.getMonth()];
                      };
                      DateUtil.getShortMonthIndex = function(m) {
                        return DateBase.monthNamesShort.indexOf(m);
                      };
                      DateUtil.getFullMonthName = function(d) {
                        return DateBase.monthNamesLong[d.getMonth()];
                      };
                      DateUtil.getFullMonthIndex = function(m) {
                        return DateBase.monthNamesLong.indexOf(m);
                      };
                      DateUtil.getShortDayName = function(d) {
                        return DateBase.dayNamesShort[d.getDay()];
                      };
                      DateUtil.getShortDayIndex = function(d) {
                        return DateBase.dayNamesShort.indexOf(d);
                      };
                      DateUtil.getFullDayName = function(d) {
                        return DateBase.dayNamesLong[d.getDay()];
                      };
                      DateUtil.getFullDayIndex = function(d) {
                        return DateBase.dayNamesLong.indexOf(d);
                      };
                      DateUtil.getShortYear = function(d) {
                        var dStr = String(d.getFullYear());

                        if (dStr.length < 3) {
                          return dStr;
                        }

                        return (dStr.substr(dStr.length - 2));
                      };
                      DateUtil.compareDates = function(d1, d2) {
                        var d1ms = d1.getTime();
                        var d2ms = d2.getTime();

                        if (d1ms > d2ms) {
                          return -1;
                        } else if (d1ms < d2ms) {
                          return 1;
                        } else {
                          return 0;
                        }
                      };
                      DateUtil.getShortHour = function(d) {
                        var h = d.hours;

                        if (h == 0 || h == 12) {
                          return 12;
                        } else if (h > 12) {
                          return h - 12;
                        } else {
                          return h;
                        }
                      };
                      DateUtil.getAMPM = function(d) {
                        return (d.hours > 11) ? "PM" : "AM";
                      };
                      DateUtil.parseRFC822 = function(str) {
                        var finalDate;
                        try {
                          var dateParts = str.split(" ");
                          var day = null;

                          if (dateParts[0].search(/\d/) == -1) {
                            day = dateParts.shift().replace(/\W/, "");
                          }

                          var date = Number(dateParts.shift());
                          var month = Number(DateUtil.getShortMonthIndex(dateParts.shift()));
                          var year = Number(dateParts.shift());
                          var timeParts = dateParts.shift().split(":");
                          var hour = int(timeParts.shift());
                          var minute = int(timeParts.shift());
                          var second = (timeParts.length > 0) ? int(timeParts.shift()) : 0;

                          var milliseconds = Date.UTC(year, month, date, hour, minute, second, 0);

                          var timezone = dateParts.shift();
                          var offset = 0;

                          if (timezone.search(/\d/) == -1) {
                            switch (timezone) {
                              case "UT":
                                offset = 0;
                                break;
                              case "UTC":
                                offset = 0;
                                break;
                              case "GMT":
                                offset = 0;
                                break;
                              case "EST":
                                offset = (-5 * 3600000);
                                break;
                              case "EDT":
                                offset = (-4 * 3600000);
                                break;
                              case "CST":
                                offset = (-6 * 3600000);
                                break;
                              case "CDT":
                                offset = (-5 * 3600000);
                                break;
                              case "MST":
                                offset = (-7 * 3600000);
                                break;
                              case "MDT":
                                offset = (-6 * 3600000);
                                break;
                              case "PST":
                                offset = (-8 * 3600000);
                                break;
                              case "PDT":
                                offset = (-7 * 3600000);
                                break;
                              case "Z":
                                offset = 0;
                                break;
                              case "A":
                                offset = (-1 * 3600000);
                                break;
                              case "M":
                                offset = (-12 * 3600000);
                                break;
                              case "N":
                                offset = (1 * 3600000);
                                break;
                              case "Y":
                                offset = (12 * 3600000);
                                break;
                              default:
                                offset = 0;
                            }
                          } else {
                            var multiplier = 1;
                            var oHours = 0;
                            var oMinutes = 0;
                            if (timezone.length != 4) {
                              if (timezone.charAt(0) == "-") {
                                multiplier = -1;
                              }
                              timezone = timezone.substr(1, 4);
                            }
                            oHours = Number(timezone.substr(0, 2));
                            oMinutes = Number(timezone.substr(2, 2));
                            offset = (((oHours * 3600000) + (oMinutes * 60000)) * multiplier);
                          }

                          finalDate = new Date(milliseconds - offset);

                          if (finalDate.toString() == "Invalid Date") {
                            throw new Error("This date does not conform to RFC822.");
                          }
                        } catch (e: Error) {
                          var eStr = "Unable to parse the string [" + str + "] into a date. ";
                          eStr += "The internal error was: " + e.toString();
                          throw new Error(eStr);
                        }
                        return finalDate;
                      };
                      DateUtil.toRFC822 = function(d) {
                        var date = d.getUTCDate();
                        var hours = d.getUTCHours();
                        var minutes = d.getUTCMinutes();
                        var seconds = d.getUTCSeconds();
                        var sb = new String();
                        sb += DateBase.dayNamesShort[d.getUTCDay()];
                        sb += ", ";

                        if (date < 10) {
                          sb += "0";
                        }
                        sb += date;
                        sb += " ";
                        //sb += DateUtil.SHORT_MONTH[d.getUTCMonth()];
                        sb += DateBase.monthNamesShort[d.getUTCMonth()];
                        sb += " ";
                        sb += d.getUTCFullYear();
                        sb += " ";
                        if (hours < 10) {
                          sb += "0";
                        }
                        sb += hours;
                        sb += ":";
                        if (minutes < 10) {
                          sb += "0";
                        }
                        sb += minutes;
                        sb += ":";
                        if (seconds < 10) {
                          sb += "0";
                        }
                        sb += seconds;
                        sb += " GMT";
                        return sb;
                      };
                      DateUtil.parseW3CDTF = function(str) {
                        var finalDate;
                        try {
                          var dateStr = str.substring(0, str.indexOf("T"));
                          var timeStr = str.substring(str.indexOf("T") + 1, str.length);
                          var dateArr = dateStr.split("-");
                          var year = Number(dateArr.shift());
                          var month = Number(dateArr.shift());
                          var date = Number(dateArr.shift());

                          var multiplier;
                          var offsetHours;
                          var offsetMinutes;
                          var offsetStr;

                          if (timeStr.indexOf("Z") != -1) {
                            multiplier = 1;
                            offsetHours = 0;
                            offsetMinutes = 0;
                            timeStr = timeStr.replace("Z", "");
                          } else if (timeStr.indexOf("+") != -1) {
                            multiplier = 1;
                            offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
                            offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
                            offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
                            timeStr = timeStr.substring(0, timeStr.indexOf("+"));
                          } else // offset is -
                          {
                            multiplier = -1;
                            offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
                            offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
                            offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
                            timeStr = timeStr.substring(0, timeStr.indexOf("-"));
                          }
                          var timeArr = timeStr.split(":");
                          var hour = Number(timeArr.shift());
                          var minutes = Number(timeArr.shift());
                          var secondsArr = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
                          var seconds = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
                          var milliseconds = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
                          var utc = Date.UTC(year, month - 1, date, hour, minutes, seconds, milliseconds);
                          var offset = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
                          finalDate = new Date(utc - offset);

                          if (finalDate.toString() == "Invalid Date") {
                            throw new Error("This date does not conform to W3CDTF.");
                          }
                        } catch (e: Error) {
                          var eStr = "Unable to parse the string [" + str + "] into a date. ";
                          eStr += "The internal error was: " + e.toString();
                          throw new Error(eStr);
                        }
                        return finalDate;
                      };
                      DateUtil.toW3CDTF = function(d, includeMilliseconds) {
                        includeMilliseconds = AS3JS.Utils.getDefaultValue(includeMilliseconds, false);
                        var date = d.getUTCDate();
                        var month = d.getUTCMonth();
                        var hours = d.getUTCHours();
                        var minutes = d.getUTCMinutes();
                        var seconds = d.getUTCSeconds();
                        var milliseconds = d.getUTCMilliseconds();
                        var sb = new String();

                        sb += d.getUTCFullYear();
                        sb += "-";

                        //thanks to "dom" who sent in a fix for the line below
                        if (month + 1 < 10) {
                          sb += "0";
                        }
                        sb += month + 1;
                        sb += "-";
                        if (date < 10) {
                          sb += "0";
                        }
                        sb += date;
                        sb += "T";
                        if (hours < 10) {
                          sb += "0";
                        }
                        sb += hours;
                        sb += ":";
                        if (minutes < 10) {
                          sb += "0";
                        }
                        sb += minutes;
                        sb += ":";
                        if (seconds < 10) {
                          sb += "0";
                        }
                        sb += seconds;
                        if (includeMilliseconds && milliseconds > 0) {
                          sb += ".";
                          sb += milliseconds;
                        }
                        sb += "-00:00";
                        return sb;
                      };

                      module.exports = DateUtil;
                    };
                    Program["com.adobe.utils.DictionaryUtil"] = function(module, exports) {
                      var DictionaryUtil = function DictionaryUtil() {};

                      DictionaryUtil.getKeys = function(d) {
                        var a = [];

                        for (var key in d) {
                          a.push(key);
                        }

                        return a;
                      };
                      DictionaryUtil.getValues = function(d) {
                        var a = [];

                        for each(var value in d) {
                          a.push(value);
                        }

                        return a;
                      };

                      module.exports = DictionaryUtil;
                    };
                    Program["com.adobe.utils.IntUtil"] = function(module, exports) {
                      module.inject = function() {
                        IntUtil.hexChars = "0123456789abcdef";
                      };

                      var IntUtil = function IntUtil() {};

                      IntUtil.rol = function(x, n) {
                        return (x << n) | (x >>> (32 - n));
                      };
                      IntUtil.ror = function(x, n) {
                        var nn = 32 - n;
                        return (x << nn) | (x >>> (32 - nn));
                      };
                      IntUtil.hexChars = null;
                      IntUtil.toHex = function(n, bigEndian) {
                        bigEndian = AS3JS.Utils.getDefaultValue(bigEndian, false);
                        var s = "";

                        if (bigEndian) {
                          for (var i = 0; i < 4; i++) {
                            s += IntUtil.hexChars.charAt((n >> ((3 - i) * 8 + 4)) & 0xF) + IntUtil.hexChars.charAt((n >> ((3 - i) * 8)) & 0xF);
                          }
                        } else {
                          for (var x = 0; x < 4; x++) {
                            s += IntUtil.hexChars.charAt((n >> (x * 8 + 4)) & 0xF) + IntUtil.hexChars.charAt((n >> (x * 8)) & 0xF);
                          }
                        }

                        return s;
                      };

                      module.exports = IntUtil;
                    };
                    Program["com.adobe.utils.NumberFormatter"] = function(module, exports) {
                      var NumberFormatter = function NumberFormatter() {};

                      NumberFormatter.addLeadingZero = function(n) {
                        var out = String(n);

                        if (n < 10 && n > -1) {
                          out = "0" + out;
                        }

                        return out;
                      };

                      module.exports = NumberFormatter;
                    };
                    Program["com.adobe.utils.StringUtil"] = function(module, exports) {
                      var StringUtil = function StringUtil() {};

                      StringUtil.stringsAreEqual = function(s1, s2, caseSensitive) {
                        if (caseSensitive) {
                          return (s1 == s2);
                        } else {
                          return (s1.toUpperCase() == s2.toUpperCase());
                        }
                      };
                      StringUtil.trim = function(input) {
                        return StringUtil.ltrim(StringUtil.rtrim(input));
                      };
                      StringUtil.ltrim = function(input) {
                        var size = input.length;
                        for (var i = 0; i < size; i++) {
                          if (input.charCodeAt(i) > 32) {
                            return input.substring(i);
                          }
                        }
                        return "";
                      };
                      StringUtil.rtrim = function(input) {
                        var size = input.length;
                        for (var i = size; i > 0; i--) {
                          if (input.charCodeAt(i - 1) > 32) {
                            return input.substring(0, i);
                          }
                        }

                        return "";
                      };
                      StringUtil.beginsWith = function(input, prefix) {
                        return (prefix == input.substring(0, prefix.length));
                      };
                      StringUtil.endsWith = function(input, suffix) {
                        return (suffix == input.substring(input.length - suffix.length));
                      };
                      StringUtil.remove = function(input, remove) {
                        return StringUtil.replace(input, remove, "");
                      };
                      StringUtil.replace = function(input, replace, replaceWith) {
                        //change to StringBuilder
                        var sb = new String();
                        var found = false;

                        var sLen = input.length;
                        var rLen = replace.length;

                        for (var i = 0; i < sLen; i++) {
                          if (input.charAt(i) == replace.charAt(0)) {
                            found = true;
                            for (var j = 0; j < rLen; j++) {
                              if (!(input.charAt(i + j) == replace.charAt(j))) {
                                found = false;
                                break;
                              }
                            }

                            if (found) {
                              sb += replaceWith;
                              i = i + (rLen - 1);
                              continue;
                            }
                          }
                          sb += input.charAt(i);
                        }
                        //TODO : if the string is not found, should we return the original
                        //string?
                        return sb;
                      };

                      module.exports = StringUtil;
                    };
                    Program["com.adobe.utils.XMLUtil"] = function(module, exports) {
                      module.inject = function() {
                        XMLUtil.TEXT = "text";
                        XMLUtil.COMMENT = "comment";
                        XMLUtil.PROCESSING_INSTRUCTION = "processing-instruction";
                        XMLUtil.ATTRIBUTE = "attribute";
                        XMLUtil.ELEMENT = "element";
                      };

                      var XMLUtil = function XMLUtil() {};

                      XMLUtil.TEXT = null;
                      XMLUtil.COMMENT = null;
                      XMLUtil.PROCESSING_INSTRUCTION = null;
                      XMLUtil.ATTRIBUTE = null;
                      XMLUtil.ELEMENT = null;
                      XMLUtil.isValidXML = function(data) {
                        var xml;

                        try {
                          xml = new XML(data);
                        } catch (e: Error) {
                          return false;
                        }

                        if (xml.nodeKind() != XMLUtil.ELEMENT) {
                          return false;
                        }

                        return true;
                      };
                      XMLUtil.getNextSibling = function(x) {
                        return XMLUtil.getSiblingByIndex(x, 1);
                      };
                      XMLUtil.getPreviousSibling = function(x) {
                        return XMLUtil.getSiblingByIndex(x, -1);
                      };
                      XMLUtil.getSiblingByIndex = function(x, count) {
                        var out;

                        try {
                          out = x.parent().children()[x.childIndex() + count];
                        } catch (e: Error) {
                          return null;
                        }

                        return out;
                      };

                      module.exports = XMLUtil;
                    };
                    Program["com.adobe.webapis.ServiceBase"] = function(module, exports) {
                      var ServiceBase = function() {};

                      ServiceBase.prototype = Object.create(EventDispatcher.prototype);

                      module.exports = ServiceBase;
                    };
                    Program["com.adobe.webapis.URLLoaderBase"] = function(module, exports) {
                      var ServiceBase = module.import('com.adobe.webapis', 'ServiceBase');
                      var DynamicURLLoader;
                      module.inject = function() {
                        DynamicURLLoader = module.import('com.adobe.net', 'DynamicURLLoader');
                      };

                      var URLLoaderBase = function URLLoaderBase() {};
                      URLLoaderBase.prototype = Object.create(ServiceBase.prototype);

                      URLLoaderBase.prototype.getURLLoader = function() {
                        var loader = new DynamicURLLoader();
                        loader.addEventListener("progress", this.onProgress);
                        loader.addEventListener("ioError", this.onIOError);
                        loader.addEventListener("securityError", this.onSecurityError);

                        return loader;
                      };
                      URLLoaderBase.prototype.onIOError = function(event) {
                        dispatchEvent(event);
                      };
                      URLLoaderBase.prototype.onSecurityError = function(event) {
                        dispatchEvent(event);
                      };
                      URLLoaderBase.prototype.onProgress = function(event) {
                        dispatchEvent(event);
                      }

                      module.exports = URLLoaderBase;
                    };
                    Program["com.adobe.webapis.events.ServiceEvent"] = function(module, exports) {
                      var ServiceEvent = function(type, bubbles, cancelable) {
                        this._data = new Object();
                        bubbles = AS3JS.Utils.getDefaultValue(bubbles, false);
                        cancelable = AS3JS.Utils.getDefaultValue(cancelable, false);
                        Event.call(this, type, bubbles, cancelable);
                      };

                      ServiceEvent.prototype = Object.create(Event.prototype);

                      ServiceEvent.prototype.get_data = function() {
                        return this._data;
                      };
                      ServiceEvent.prototype.set_data = function(d) {
                        this._data = d;
                      };
                      ServiceEvent.prototype._data = null

                      module.exports = ServiceEvent;
                    };
                    if (typeof module !== 'undefined') {
                      module.exports = AS3JS.load({
                        program: Program,
                        entry: "main",
                        entryMode: "instance"
                      });
                    } else if (typeof window !== 'undefined' && typeof AS3JS !== 'undefined') {
                      window['main'] = AS3JS.load({
                        program: Program,
                        entry: "main",
                        entryMode: "instance"
                      });
                    }
                  })();
