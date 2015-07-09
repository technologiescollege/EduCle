//   This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   (at your option) any later version.
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//   You should have received a copy of the GNU General Public License
//   along with this program.  If not, see <http://www.gnu.org/licenses/>
//   
//   
// @author : pascal.fautrero@ac-versailles.fr


/*
 * 
 * @param {object} params
 * @constructor create image active object
 */
function IaObject(params) {
    "use strict";
    var that = this;
    this.path = [];
    this.xiaDetail = [];
    this.persistent = [];
    this.minX = 10000;
    this.minY = 10000;
    this.maxX = -10000;
    this.maxY = -10000;
    this.group = 0;

    this.layer = params.layer;
    this.background_layer = params.background_layer;
    this.imageObj = params.imageObj;
    this.idText = params.idText;
    this.myhooks = params.myhooks;
    // Create kineticElements and include them in a group
   
    that.group = new Kinetic.Group();
    that.layer.add(that.group);
    
    if (typeof(params.detail.path) !== 'undefined') {
        that.includePath(params.detail, 0, that, params.iaScene, params.baseImage, params.idText);
    }
    else if (typeof(params.detail.image) !== 'undefined') {
        that.includeImage(params.detail, 0, that, params.iaScene, params.baseImage, params.idText);
    }
    else if (typeof(params.detail.group) !== 'undefined') {
        for (var i in params.detail.group) {
            if (typeof(params.detail.group[i].path) !== 'undefined') {
                that.includePath(params.detail.group[i], i, that, params.iaScene, params.baseImage, params.idText);
            }
            else if (typeof(params.detail.group[i].image) !== 'undefined') {
                that.includeImage(params.detail.group[i], i, that, params.iaScene, params.baseImage, params.idText);
            }
        }
        that.definePathBoxSize(params.detail, that);
    }
    else {
        console.log(params.detail);
    }

    this.scaleBox(this, params.iaScene);
    this.myhooks.afterIaObjectConstructor(params.iaScene, params.idText, params.detail, this);
}

/*
 * 
 * @param {type} detail
 * @param {type} i KineticElement index
 * @returns {undefined}
 */
IaObject.prototype.includeImage = function(detail, i, that, iaScene, baseImage, idText) {
    that.defineImageBoxSize(detail, that);
    
    that.xiaDetail[i] = new XiaDetail(detail, idText);
    
    var rasterObj = new Image();
    rasterObj.src = detail.image;    

    that.xiaDetail[i].kineticElement = new Kinetic.Image({
        id: detail.id,
        name: detail.title,
        x: parseFloat(detail.x) * iaScene.coeff,
        y: parseFloat(detail.y) * iaScene.coeff + iaScene.y,
        width: detail.width,
        height: detail.height,
        scale: {x:iaScene.coeff,y:iaScene.coeff}
    });
    that.xiaDetail[i].kineticElement.setXiaParent(that.xiaDetail[i]);
    that.xiaDetail[i].kineticElement.setIaObject(that);
    
    that.xiaDetail[i].kineticElement.backgroundImage = rasterObj;
    that.xiaDetail[i].kineticElement.tooltip = "";
    
    rasterObj.onload = function() {
        
        that.xiaDetail[i].kineticElement.backgroundImageOwnScaleX = iaScene.scale * detail.width / this.width;
        that.xiaDetail[i].kineticElement.backgroundImageOwnScaleY = iaScene.scale * detail.height / this.height;           
        var zoomable = true;

        if ((typeof(detail.fill) !== 'undefined') && 
            (detail.fill === "#000000")) {
            zoomable = false;
        }

        that.persistent[i] = "off";
        if ((typeof(detail.fill) !== 'undefined') && 
            (detail.fill === "#ffffff")) {
            that.persistent[i] = "onImage";
            that.xiaDetail[i].kineticElement.fillPriority('pattern');
            that.xiaDetail[i].kineticElement.fillPatternScaleX(that.xiaDetail[i].kineticElement.backgroundImageOwnScaleX * 1/iaScene.scale);
            that.xiaDetail[i].kineticElement.fillPatternScaleY(that.xiaDetail[i].kineticElement.backgroundImageOwnScaleY * 1/iaScene.scale);                
            that.xiaDetail[i].kineticElement.fillPatternImage(that.xiaDetail[i].kineticElement.backgroundImage); 
            zoomable = false;
        }
        that.group.add(that.xiaDetail[i].kineticElement);

        // define hit area excluding transparent pixels

        var cropX = Math.max(parseFloat(detail.minX), 0);
        var cropY = Math.max(parseFloat(detail.minY), 0);
        var cropWidth = (Math.min(parseFloat(detail.maxX) - parseFloat(detail.minX), Math.floor(parseFloat(iaScene.originalWidth) * 1)));
        var cropHeight = (Math.min(parseFloat(detail.maxY) - parseFloat(detail.minY), Math.floor(parseFloat(iaScene.originalHeight) * 1)));
        if (cropX + cropWidth > iaScene.originalWidth * 1) {
            cropWidth = iaScene.originalWidth * 1 - cropX * 1;
        }
        if (cropY * 1 + cropHeight > iaScene.originalHeight * 1) {
            cropHeight = iaScene.originalHeight * 1 - cropY * 1;
        }
        
	var hitCanvas = that.layer.getHitCanvas();
        iaScene.completeImage = hitCanvas.getContext().getImageData(0,0,Math.floor(hitCanvas.width),Math.floor(hitCanvas.height));

        var canvas_source = document.createElement('canvas');
        canvas_source.setAttribute('width', cropWidth * iaScene.coeff);
        canvas_source.setAttribute('height', cropHeight * iaScene.coeff);
        var context_source = canvas_source.getContext('2d');
        context_source.drawImage(rasterObj,0,0, cropWidth * iaScene.coeff, cropHeight * iaScene.coeff);

	imageDataSource = context_source.getImageData(0, 0, Math.floor(cropWidth * iaScene.coeff), Math.floor(cropHeight * iaScene.coeff));            

        (function(imageDataSource){
            that.xiaDetail[i].kineticElement.hitFunc(function(context) {
                var imageData = imageDataSource.data;
                var imageDest = iaScene.completeImage.data;
                var position1 = 0;
                var position2 = 0;
                var maxWidth = Math.floor(cropWidth * iaScene.coeff);
                var maxHeight = Math.floor(cropHeight * iaScene.coeff);
                var startY = Math.floor(cropY * iaScene.coeff);
                var startX = Math.floor(cropX * iaScene.coeff);
                var hitCanvasWidth = Math.floor(that.layer.getHitCanvas().width);
                var rgbColorKey = Kinetic.Util._hexToRgb(this.colorKey);
                for(var varx = 0; varx < maxWidth; varx +=1) {
                    for(var vary = 0; vary < maxHeight; vary +=1) {
                        position1 = 4 * (vary * maxWidth + varx);
                        position2 = 4 * ((vary + startY) * hitCanvasWidth + varx + startX);
                        if (imageData[position1 + 3] > 100) {
                           imageDest[position2 + 0] = rgbColorKey.r;
                           imageDest[position2 + 1] = rgbColorKey.g;
                           imageDest[position2 + 2] = rgbColorKey.b;
                           imageDest[position2 + 3] = 255;
                        }
                    }
                } 
                context.putImageData(iaScene.completeImage, 0, 0);    
            });        
        })(imageDataSource);    
        
        
      /* that.xiaDetail[i].kineticElement.sceneFunc(function(context) {
            var yo = that.layer.getHitCanvas().getContext().getImageData(0,0,iaScene.width, iaScene.height);
            context.putImageData(yo, 0,0);  
        });*/
        that.addEventsManagement(i,zoomable, that, iaScene, baseImage, idText);
        that.group.draw();        
    };

};    


/*
 * 
 * @param {type} path
 * @param {type} i KineticElement index
 * @returns {undefined}
 */
IaObject.prototype.includePath = function(detail, i, that, iaScene, baseImage, idText) {
    
    var that=this;
    that.xiaDetail[i] = new XiaDetail(detail, idText);
    
    that.path[i] = detail.path;
    // if detail is out of background, hack maxX and maxY
    if (parseFloat(detail.maxX) < 0) detail.maxX = 1;
    if (parseFloat(detail.maxY) < 0) detail.maxY = 1;        
    that.xiaDetail[i].kineticElement = new Kinetic.Path({
        id: detail.id,        
        name: detail.title,
        data: detail.path,
        x: parseFloat(detail.x) * iaScene.coeff,
        y: parseFloat(detail.y) * iaScene.coeff + iaScene.y,
        scale: {x:iaScene.coeff,y:iaScene.coeff},
        fill: 'rgba(0, 0, 0, 0)'
    });
    that.xiaDetail[i].kineticElement.setXiaParent(that.xiaDetail[i]);
    that.xiaDetail[i].kineticElement.setIaObject(that);
    that.xiaDetail[i].kineticElement.tooltip = "";
    that.definePathBoxSize(detail, that);
    // crop background image to suit shape box
    that.cropCanvas = document.createElement('canvas');
    that.cropCanvas.setAttribute('width', parseFloat(detail.maxX) - parseFloat(detail.minX));
    that.cropCanvas.setAttribute('height', parseFloat(detail.maxY) - parseFloat(detail.minY));
    var cropCtx = that.cropCanvas.getContext('2d');
    var cropX = Math.max(parseFloat(detail.minX), 0);
    var cropY = Math.max(parseFloat(detail.minY), 0);
    var cropWidth = (Math.min((parseFloat(detail.maxX) - parseFloat(detail.minX)) * iaScene.scale, Math.floor(parseFloat(iaScene.originalWidth) * iaScene.scale)));
    var cropHeight = (Math.min((parseFloat(detail.maxY) - parseFloat(detail.minY)) * iaScene.scale, Math.floor(parseFloat(iaScene.originalHeight) * iaScene.scale)));
    if (cropX * iaScene.scale + cropWidth > iaScene.originalWidth * iaScene.scale) {
	cropWidth = iaScene.originalWidth * iaScene.scale - cropX * iaScene.scale;
    }
    if (cropY * iaScene.scale + cropHeight > iaScene.originalHeight * iaScene.scale) {
	cropHeight = iaScene.originalHeight * iaScene.scale - cropY * iaScene.scale;
    }
    // bad workaround to avoid null dimensions
    if (cropWidth <= 0) cropWidth = 1;
    if (cropHeight <= 0) cropHeight = 1;
    cropCtx.drawImage(
        that.imageObj,
        cropX * iaScene.scale,
        cropY * iaScene.scale,
        cropWidth,
        cropHeight,
        0,
        0,
        cropWidth,
        cropHeight
    );
    var dataUrl = that.cropCanvas.toDataURL();
    delete that.cropCanvas;
    var cropedImage = new Image();
    cropedImage.src = dataUrl;
    that.xiaDetail[i].kineticElement.tooltip = "";
    cropedImage.onload = function() {
        that.xiaDetail[i].kineticElement.backgroundImage = cropedImage;
        that.xiaDetail[i].kineticElement.backgroundImageOwnScaleX = 1;
        that.xiaDetail[i].kineticElement.backgroundImageOwnScaleY = 1;
        that.xiaDetail[i].kineticElement.fillPatternRepeat('no-repeat');
        that.xiaDetail[i].kineticElement.fillPatternX(detail.minX);
        that.xiaDetail[i].kineticElement.fillPatternY(detail.minY);
    };

    var zoomable = true;
    if ((typeof(detail.fill) !== 'undefined') && 
        (detail.fill === "#000000")) {
        zoomable = false;
    }
    that.persistent[i] = "off";
    if ((typeof(detail.fill) !== 'undefined') && 
        (detail.fill === "#ffffff")) {
        that.persistent[i] = "onPath";
        that.xiaDetail[i].kineticElement.fill('rgba(' + iaScene.colorPersistent.red + ',' + iaScene.colorPersistent.green + ',' + iaScene.colorPersistent.blue + ',' + iaScene.colorPersistent.opacity + ')');
    }    
    that.addEventsManagement(i, zoomable, that, iaScene, baseImage, idText);

    that.group.add(that.xiaDetail[i].kineticElement);
    that.group.draw();
};

/*
 * 
 * @param {type} index
 * @returns {undefined}
 */
IaObject.prototype.defineImageBoxSize = function(detail, that) {
    "use strict";
    var that = this;
    if (that.minX === -1)
        that.minX = (parseFloat(detail.x));
    if (that.maxY === 10000)
        that.maxY = parseFloat(detail.y) + parseFloat(detail.height);
    if (that.maxX === -1)
        that.maxX = (parseFloat(detail.x) + parseFloat(detail.width));
    if (that.minY === 10000)
        that.minY = (parseFloat(detail.y));

    if (parseFloat(detail.x) < that.minX) that.minX = parseFloat(detail.x);
    if (parseFloat(detail.x) + parseFloat(detail.width) > that.maxX)
        that.maxX = parseFloat(detail.x) + parseFloat(detail.width);
    if (parseFloat(detail.y) < that.minY) 
        that.miny = parseFloat(detail.y);
    if (parseFloat(detail.y) + parseFloat(detail.height) > that.maxY) 
        that.maxY = parseFloat(detail.y) + parseFloat(detail.height);
};    


/*
 * 
 * @param {type} index
 * @returns {undefined}
 */
IaObject.prototype.definePathBoxSize = function(detail, that) {
    "use strict";
    if (  (typeof(detail.minX) !== 'undefined') &&
          (typeof(detail.minY) !== 'undefined') &&
          (typeof(detail.maxX) !== 'undefined') &&
          (typeof(detail.maxY) !== 'undefined')) {
        that.minX = detail.minX;
        that.minY = detail.minY;
        that.maxX = detail.maxX;
        that.maxY = detail.maxY;
    }
    else {
        console.log('definePathBoxSize failure');
    }
};


/*
 * 
 */
IaObject.prototype.scaleBox = function(that, iaScene) {

    that.minX = that.minX * iaScene.coeff;
    that.minY = that.minY * iaScene.coeff;
    that.maxX = that.maxX * iaScene.coeff;
    that.maxY = that.maxY * iaScene.coeff;    

};

/*
 * Define mouse events on the current KineticElement
 * @param {type} i KineticElement index
 * @returns {undefined}
 */
   
IaObject.prototype.addEventsManagement = function(i, zoomable, that, iaScene, baseImage, idText) {

    var that=this;

    that.xiaDetail[i].kineticElement.droparea = false;
    that.xiaDetail[i].kineticElement.tooltip_area = false;
    // if current detail is a drop area, disable drag and drop
    if ($('article[data-target="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        that.xiaDetail[i].kineticElement.droparea = true;
    }
    // tooltip must be at the bottom
    if ($('article[data-tooltip="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        that.xiaDetail[i].kineticElement.getParent().moveToBottom();
        that.xiaDetail[i].options += " disable-click ";
        that.xiaDetail[i].kineticElement.tooltip_area = true;
        // disable hitArea for tooltip
        that.xiaDetail[i].kineticElement.hitFunc(function(context){
            context.beginPath();
            context.rect(0,0,0,0);
            context.closePath();
            context.fillStrokeShape(this);	
	});        
    }
};


//   This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   (at your option) any later version.
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//   You should have received a copy of the GNU General Public License
//   along with this program.  If not, see <http://www.gnu.org/licenses/>
//   
//   
// @author : pascal.fautrero@crdp.ac-versailles.fr

/**
 * 
 * @param {type} originalWidth
 * @param {type} originalHeight
 * @constructor create image active scene
 */
function IaScene(originalWidth, originalHeight) {
    "use strict";
    var that = this;
    //  canvas width
    this.width = 1000;
    
    // canvas height
    this.height = 800;  
    
    // default color used to fill shapes during mouseover
    var _colorOver = {red:66, green:133, blue:244, opacity:0.6};

    // default color used to fill stroke around shapes during mouseover
    var _colorOverStroke = {red:255, green:0, blue:0, opacity:1};
    
    // default color used to fill shapes if defined as cache
    this.colorPersistent = {red:124, green:154, blue:174, opacity:1};

    // Image ratio on the scene
    this.ratio = 1.00;  
    
    // padding-top in the canvas
    this.y = 0;
 
    // internal
    this.score = 0;
    this.score2 = 0;

    this.currentShape = "";

    this.currentScore = 0;
    this.currentScore2 = 0;    
    this.fullScreen = "off";
    this.overColor = 'rgba(' + _colorOver.red + ',' + _colorOver.green + ',' + _colorOver.blue + ',' + _colorOver.opacity + ')';   
    this.overColorStroke = 'rgba(' + _colorOverStroke.red + ',' + _colorOverStroke.green + ',' + _colorOverStroke.blue + ',' + _colorOverStroke.opacity + ')';
    this.scale = 1;
    this.zoomActive = 0;
    this.element = 0;
    this.originalWidth = originalWidth;
    this.originalHeight = originalHeight;
    this.coeff = (this.width * this.ratio) / parseFloat(originalWidth);
    this.cursorState="";
    this.noPropagation = false;
}

/*
 * Scale entire scene
 *  
 */
IaScene.prototype.scaleScene = function(mainScene){
    "use strict";
    var viewportWidth = $(window).width();
    var viewportHeight = $(window).height();

    var coeff_width = (viewportWidth * mainScene.ratio) / parseFloat(mainScene.originalWidth);
    var coeff_height = (viewportHeight) / (parseFloat(mainScene.originalHeight) + $('#canvas').offset().top + $('#container').offset().top);

    var canvas_border_left = parseFloat($("#canvas").css("border-left-width").substr(0,$("#canvas").css("border-left-width").length - 2));
    var canvas_border_right = parseFloat($("#canvas").css("border-right-width").substr(0,$("#canvas").css("border-right-width").length - 2));
    var canvas_border_top = parseFloat($("#canvas").css("border-top-width").substr(0,$("#canvas").css("border-top-width").length - 2));
    var canvas_border_bottom = parseFloat($("#canvas").css("border-bottom-width").substr(0,$("#canvas").css("border-bottom-width").length - 2));    
    
    if ((viewportWidth >= parseFloat(mainScene.originalWidth) * coeff_width) && (viewportHeight >= ((parseFloat(mainScene.originalHeight) + $('#canvas').offset().top) * coeff_width))) {
        mainScene.width = viewportWidth - canvas_border_left - canvas_border_right;
        mainScene.coeff = (mainScene.width * mainScene.ratio) / parseFloat(mainScene.originalWidth);
        mainScene.height = parseFloat(mainScene.originalHeight) * mainScene.coeff;
    }
    else if ((viewportWidth >= parseFloat(mainScene.originalWidth) * coeff_height) && (viewportHeight >= (parseFloat(mainScene.originalHeight) + $('#canvas').offset().top) * coeff_height)) {
        mainScene.height = viewportHeight - $('#container').offset().top - $('#canvas').offset().top - canvas_border_top - canvas_border_bottom - 2;
        mainScene.coeff = (mainScene.height) / parseFloat(mainScene.originalHeight);
        mainScene.width = parseFloat(mainScene.originalWidth) * mainScene.coeff;
    }


    $('#container').css({"width": (mainScene.width + canvas_border_left + canvas_border_right) + 'px'});
    $('#container').css({"height": (mainScene.height + $('#canvas').offset().top - $('#container').offset().top + canvas_border_top + canvas_border_bottom) + 'px'});
    $('#canvas').css({"height": (mainScene.height) + 'px'});    
    $('#canvas').css({"width": mainScene.width + 'px'});     
    $('#detect').css({"height": (mainScene.height) + 'px'});
    $('#detect').css({"top": ($('#canvas').offset().top) + 'px'});
};

IaScene.prototype.mouseover = function(kineticElement) {
    if (this.cursorState.indexOf("ZoomOut.cur") !== -1) {

    }
    else if (this.cursorState.indexOf("ZoomIn.cur") !== -1) {

    }
    else if (this.cursorState.indexOf("HandPointer.cur") === -1) {
        if ((kineticElement.getXiaParent().options.indexOf("pointer") !== -1) && (!this.tooltip_area)) {
            document.body.style.cursor = "pointer";
        }
        this.cursorState = "url(img/HandPointer.cur),auto";   

        // manage tooltips if present
        var tooltip = false;
        if (kineticElement.tooltip != "") {
            tooltip = true;
        }
        else if ($("#" + kineticElement.getXiaParent().idText).data("tooltip") != "") {
            var tooltip_id = $("#" + kineticElement.getXiaParent().idText).data("tooltip");
            kineticElement.tooltip = kineticElement.getStage().find("#" + tooltip_id)[0];
            tooltip = true;
        }
        if (tooltip) {
            kineticElement.tooltip.clearCache();
            kineticElement.tooltip.fillPriority('pattern');
            if ((kineticElement.tooltip.backgroundImageOwnScaleX != "undefined") && 
                    (kineticElement.tooltip.backgroundImageOwnScaleY != "undefined")) {
                kineticElement.tooltip.fillPatternScaleX(kineticElement.tooltip.backgroundImageOwnScaleX * 1/this.scale);
                kineticElement.tooltip.fillPatternScaleY(kineticElement.tooltip.backgroundImageOwnScaleY * 1/this.scale);
            }
            kineticElement.tooltip.fillPatternImage(kineticElement.tooltip.backgroundImage);
            kineticElement.tooltip.getParent().moveToTop();
            //that.group.draw();
            kineticElement.tooltip.draw();
        }            

        //kineticElement.getIaObject().layer.batchDraw();
        //kineticElement.draw();
    }

    
};

IaScene.prototype.mouseout = function(kineticElement) {

    if ((this.cursorState.indexOf("ZoomOut.cur") !== -1) ||
            (this.cursorState.indexOf("ZoomIn.cur") !== -1)){

    }
    else {
        
        var mouseXY = kineticElement.getStage().getPointerPosition();
        if (typeof(mouseXY) == "undefined") {
            mouseXY = {x:0,y:0};
        }            
        //if ((kineticElement.getStage().getIntersection(mouseXY) != kineticElement)) {

            // manage tooltips if present
            var tooltip = false;
            if (kineticElement.tooltip != "") {
                tooltip = true;
            }
            else if ($("#" + kineticElement.getXiaParent().idText).data("tooltip") != "") {
                var tooltip_id = $("#" + kineticElement.getXiaParent().idText).data("tooltip");
                kineticElement.tooltip = kineticElement.getStage().find("#" + tooltip_id)[0];
                tooltip = true;
            }         
            if (tooltip) {
                kineticElement.tooltip.fillPriority('color');
                kineticElement.tooltip.fill('rgba(0, 0, 0, 0)');
                kineticElement.tooltip.getParent().moveToBottom();
                kineticElement.tooltip.draw();
                kineticElement.getIaObject().layer.draw();
            }                     

            document.body.style.cursor = "default";
            this.cursorState = "default";
            						
        //}
        document.body.style.cursor = "default";
    }
    
};

IaScene.prototype.click = function(kineticElement) {
  
    if (kineticElement.getXiaParent().click == "off") return;

    /*
     * if we click in this element, manage zoom-in, zoom-out
     */
    if (kineticElement.getXiaParent().options.indexOf("direct-link") !== -1) {
        location.href = kineticElement.getXiaParent().title;
    }
    else {    

        this.noPropagation = true;
        var iaobject = kineticElement.getIaObject();
        for (var i in iaobject.xiaDetail) {
            if (iaobject.persistent[i] == "off") {
                if (iaobject.xiaDetail[i].kineticElement instanceof Kinetic.Image) {
                    iaobject.xiaDetail[i].kineticElement.fillPriority('pattern');
                    iaobject.xiaDetail[i].kineticElement.fillPatternScaleX(iaobject.xiaDetail[i].kineticElement.backgroundImageOwnScaleX * 1/this.scale);
                    iaobject.xiaDetail[i].kineticElement.fillPatternScaleY(iaobject.xiaDetail[i].kineticElement.backgroundImageOwnScaleY * 1/this.scale); 
                    iaobject.xiaDetail[i].kineticElement.fillPatternImage(iaobject.xiaDetail[i].kineticElement.backgroundImage);                        
                }
                else {
                    iaobject.xiaDetail[i].kineticElement.fillPriority('color');
                    iaobject.xiaDetail[i].kineticElement.fill(this.overColor);
                    iaobject.xiaDetail[i].kineticElement.scale(this.coeff);
                    iaobject.xiaDetail[i].kineticElement.stroke(this.overColorStroke);
                    iaobject.xiaDetail[i].kineticElement.strokeWidth(2);                                                
                }

            }
            else if (iaobject.persistent[i] == "onPath") {
                iaobject.xiaDetail[i].kineticElement.fillPriority('color');
                iaobject.xiaDetail[i].kineticElement.fill('rgba(' + this.colorPersistent.red + ',' + this.colorPersistent.green + ',' + this.colorPersistent.blue + ',' + this.colorPersistent.opacity + ')');                       
            }
            else if (iaobject.persistent[i] == "onImage") {
                iaobject.xiaDetail[i].kineticElement.fillPriority('pattern');
                iaobject.xiaDetail[i].kineticElement.fillPatternScaleX(iaobject.xiaDetail[i].kineticElement.backgroundImageOwnScaleX * 1/this.scale);
                iaobject.xiaDetail[i].kineticElement.fillPatternScaleY(iaobject.xiaDetail[i].kineticElement.backgroundImageOwnScaleY * 1/this.scale); 
                iaobject.xiaDetail[i].kineticElement.fillPatternImage(iaobject.xiaDetail[i].kineticElement.backgroundImage);                        
            }                
            iaobject.xiaDetail[i].kineticElement.moveToTop();
            iaobject.xiaDetail[i].kineticElement.draw();
        }                

        iaobject.group.moveToTop();
        //iaobject.layer.draw(); 
        this.element = iaobject;
        iaobject.myhooks.afterIaObjectFocus(this, kineticElement.getXiaParent().idText, iaobject, kineticElement);
        iaobject.layer.getStage().completeImage = "redefine";


    }    

};


//   This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   (at your option) any later version.
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//   You should have received a copy of the GNU General Public License
//   along with this program.  If not, see <http://www.gnu.org/licenses/>
//   
//   
// @author : pascal.fautrero@ac-versailles.fr


// Script used to load youtube resource after main page
// otherwise, Chrome fails to start the page

$(".videoWrapper16_9").each(function(){
    var source = $(this).data("iframe");
    var iframe = document.createElement("iframe");
    iframe.src = source;
    $(this).append(iframe);    
});

$(".videoWrapper4_3").each(function(){
    var source = $(this).data("iframe");
    var iframe = document.createElement("iframe");
    iframe.src = source;
    $(this).append(iframe);    
});

//   This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   (at your option) any later version.
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//   You should have received a copy of the GNU General Public License
//   along with this program.  If not, see <http://www.gnu.org/licenses/>
//   
//   
// @author : pascal.fautrero@ac-versailles.fr
// @version=1.1

/*
 * Main
 * Initialization
 * 
 * 1rst layer : div "detect" - if clicked, enable canvas events
 * 2nd layer : bootstrap accordion
 * 3rd layer : div "canvas" containing images and paths
 * 4th layer : div "disablearea" - if clicked, disable events canvas  
 */

function main(myhooks) {
    "use strict";
    var that=window;
    that.canvas = document.getElementById("canvas");

    // fix bug in retina and amoled screens
    Kinetic.pixelRatio = 1;

    Kinetic.Util.addMethods(Kinetic.Path,{
        setIaObject: function(iaobject) {
            this.iaobject = iaobject;
        },
        getIaObject: function() {
            return this.iaobject;
        }
    });    
    
    Kinetic.Util.addMethods(Kinetic.Image,{
        setIaObject: function(iaobject) {
            this.iaobject = iaobject;
        },
        getIaObject: function() {
            return this.iaobject;
        }
    });

    Kinetic.Util.addMethods(Kinetic.Path,{
        setXiaParent: function(xiaparent) {
            this.xiaparent = xiaparent;
        },
        getXiaParent: function() {
            return this.xiaparent;
        }
    });    
    Kinetic.Util.addMethods(Kinetic.Image,{
        setXiaParent: function(xiaparent) {
            this.xiaparent = xiaparent;
        },
        getXiaParent: function() {
            return this.xiaparent;
        }    
    });    
    


    // Load background image

    that.imageObj = new Image();
    that.imageObj.src = scene.image;
    that.imageObj.onload = function() {

        var mainScene = new IaScene(scene.width,scene.height);
        mainScene.scale = 1; 
        mainScene.scaleScene(mainScene);

        var stage = new Kinetic.Stage({
            container: 'canvas',
            width: mainScene.width,
            height: mainScene.height
        });
        stage.on("mouseout touchend", function(){
            var shape = Kinetic.shapes[mainScene.currentShape];
            if (typeof(shape) != "undefined") {
                mainScene.mouseout(shape);    
            }
            mainScene.currentShape = "";
        });

        stage.on("click tap", function(){
            mainScene.currentShape = "";
            if ((mainScene.currentShape == "") || (typeof(mainScene.currentShape) == "undefined")) {
                var mousePos = this.getPointerPosition();
                var imageDest = mainScene.completeImage.data;
                var position1 = 0;
                position1 = 4 * (Math.floor(mousePos.y) * Math.floor(mainScene.width) + Math.floor(mousePos.x));
                mainScene.currentShape = "#" + Kinetic.Util._rgbToHex(imageDest[position1 + 0], imageDest[position1 + 1], imageDest[position1 + 2]);                
            }
            var shape = Kinetic.shapes[mainScene.currentShape];
            if (typeof(shape) != "undefined") {
                mainScene.click(shape);    
            }
        });        
        
        stage.on("mousemove touchstart", function(){
            var mousePos = this.getPointerPosition();
            var imageDest = mainScene.completeImage.data;
            var position1 = 0;
            position1 = 4 * (Math.floor(mousePos.y) * Math.floor(mainScene.width) + Math.floor(mousePos.x));
            var shape_id = Kinetic.Util._rgbToHex(imageDest[position1 + 0], imageDest[position1 + 1], imageDest[position1 + 2]);
            var shape = Kinetic.shapes["#" + shape_id];
            if (typeof(shape) != "undefined") {
                if (shape.colorKey != mainScene.currentShape) {
                    if (mainScene.currentShape != "") {
                        var oldShape = Kinetic.shapes[mainScene.currentShape];
                        if (typeof(oldShape) != "undefined") {
                            mainScene.mouseout(oldShape);    
                        } 
                    }
                    mainScene.currentShape = shape.colorKey;
                    mainScene.mouseover(shape);
                }
            }
            else {
                var shape = Kinetic.shapes[mainScene.currentShape];
                if (typeof(shape) != "undefined") {
                    mainScene.mouseout(shape);    
                }
                mainScene.currentShape = "";
            }
        });
        // area containing image background    
        var baseImage = new Kinetic.Image({
            x: 0,
            y: mainScene.y,
            width: scene.width,
            height: scene.height,
            scale: {x:mainScene.coeff,y:mainScene.coeff},
            image: that.imageObj
        });


        var layers = [];
        that.layers = layers;
        layers[0] = new Kinetic.FastLayer();	
        layers[0].add(baseImage);
        stage.add(layers[0]);
        myhooks.beforeMainConstructor(mainScene, that.layers);
        var indice = 1;
        layers[indice] = new Kinetic.Layer();
        stage.add(layers[indice]);

        for (var i in details) {
            var iaObj = new IaObject({
                imageObj: that.imageObj,
                detail: details[i],
                layer: layers[indice],
                idText: "article-" + i,
                baseImage: baseImage,
                iaScene: mainScene,
                background_layer: layers[0],
                myhooks: myhooks
            });
        }
        
	var hitCanvas = layers[indice].getHitCanvas();
        mainScene.completeImage = hitCanvas.getContext().getImageData(0,0,Math.floor(hitCanvas.width),Math.floor(hitCanvas.height));        
        
        
        myhooks.afterMainConstructor(mainScene, that.layers);             
        $("#splash").fadeOut("slow", function(){
                $("#loader").hide();	
        });
        var viewportHeight = $(window).height();
        if (scene.description != "") {
            $("#rights").show();
            var content_offset = $("#rights").offset();
            var message_height = $("#popup_intro").css('height').substr(0,$("#popup_intro").css("height").length - 2);
            $("#popup_intro").css({'top':(viewportHeight - content_offset.top - message_height)/ 2 - 40});
            $("#popup_intro").show();
            $("#popup").hide();
            $("#popup_close_intro").on("click", function(){
                $("#rights").hide();
            });            
        }
        // FullScreen ability
        // source code from http://blogs.sitepointstatic.com/examples/tech/full-screen/index.html
        var e = document.getElementById("title");
        var div_container = document.getElementById("image-active");
        e.onclick = function() {
            if (runPrefixMethod(document, "FullScreen") || runPrefixMethod(document, "IsFullScreen")) {
                runPrefixMethod(document, "CancelFullScreen");
            }
            else {
                runPrefixMethod(div_container, "RequestFullScreen");
            }
            mainScene.fullScreen = mainScene.fullScreen == "on" ? "off": "on";
        };

        var pfx = ["webkit", "moz", "ms", "o", ""];
        function runPrefixMethod(obj, method) {
            var p = 0, m, t;
            while (p < pfx.length && !obj[m]) {
                m = method;
                if (pfx[p] === "") {
                    m = m.substr(0,1).toLowerCase() + m.substr(1);
                }
                m = pfx[p] + m;
                t = typeof obj[m];
                if (t != "undefined") {
                    pfx = [pfx[p]];
                    return (t == "function" ? obj[m]() : obj[m]);
                }
                p++;
            }
        }       
        
    };    
}

myhooks = new hooks();
launch = new main(myhooks);

//   This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   (at your option) any later version.
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//   You should have received a copy of the GNU General Public License
//   along with this program.  If not, see <http://www.gnu.org/licenses/>
//   
//   
// @author : pascal.fautrero@ac-versailles.fr


/*
 * 
 */
function XiaDetail(detail, idText) {
    "use strict";
    
    var that = this;
    
    this.click = "on";
    this.title = detail.title;
    this.idText = idText;
    this.path = "";
    this.kineticElement = null;
    this.persistent = "";
    this.options = "";
    this.backgroundImage = null;
    this.tooltip = null;
    
    if ((typeof(detail.options) !== 'undefined')) {
        this.options = detail.options;
    }
    if (this.options.indexOf("disable-click") !== -1) {
        this.click = "off";
    }
    
}

// XORCipher - Super simple encryption using XOR and Base64
// MODIFIED VERSION TO AVOID underscore dependancy
// License : MIT
// 
// As a warning, this is **not** a secure encryption algorythm. It uses a very
// simplistic keystore and will be easy to crack.
//
// The Base64 algorythm is a modification of the one used in phpjs.org
// * http://phpjs.org/functions/base64_encode/
// * http://phpjs.org/functions/base64_decode/
//
// Examples
// --------
//
// XORCipher.encode("test", "foobar"); // => "EgocFhUX"
// XORCipher.decode("test", "EgocFhUX"); // => "foobar"
//
/* jshint forin:true, noarg:true, noempty:true, eqeqeq:true, strict:true,
undef:true, unused:true, curly:true, browser:true, indent:2, maxerr:50 */
/* global _ */

(function(exports) {
    "use strict";

    var XORCipher = {
        encode: function(key, data) {
            data = xor_encrypt(key, data);
            return b64_encode(data);
        },
        decode: function(key, data) {
            data = b64_decode(data);
            return xor_decrypt(key, data);
        }
    };

    var b64_table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    function b64_encode(data) {
        var o1, o2, o3, h1, h2, h3, h4, bits, r, i = 0, enc = "";
        if (!data) { return data; }
        do {
        o1 = data[i++];
        o2 = data[i++];
        o3 = data[i++];
        bits = o1 << 16 | o2 << 8 | o3;
        h1 = bits >> 18 & 0x3f;
        h2 = bits >> 12 & 0x3f;
        h3 = bits >> 6 & 0x3f;
        h4 = bits & 0x3f;
        enc += b64_table.charAt(h1) + b64_table.charAt(h2) + b64_table.charAt(h3) + b64_table.charAt(h4);
        } while (i < data.length);
        r = data.length % 3;
        return (r ? enc.slice(0, r - 3) : enc) + "===".slice(r || 3);
    }

    function b64_decode(data) {
        var o1, o2, o3, h1, h2, h3, h4, bits, i = 0, result = [];
        if (!data) { return data; }
        data += "";
        do {
            h1 = b64_table.indexOf(data.charAt(i++));
            h2 = b64_table.indexOf(data.charAt(i++));
            h3 = b64_table.indexOf(data.charAt(i++));
            h4 = b64_table.indexOf(data.charAt(i++));
            bits = h1 << 18 | h2 << 12 | h3 << 6 | h4;
            o1 = bits >> 16 & 0xff;
            o2 = bits >> 8 & 0xff;
            o3 = bits & 0xff;
            result.push(o1);
            if (h3 !== 64) {
                result.push(o2);
                if (h4 !== 64) {
                    result.push(o3);
                }
            }
        } while (i < data.length);
        return result;
    }

    function keyCharAt(key, i) {
        //return key.charCodeAt( Math.floor(i % key.length) );
        return key.charCodeAt( i % key.length );
    }

    function xor_encrypt(key, data) {
        /*return _.map(data, function(c, i) {
                return c.charCodeAt(0) ^ keyCharAt(key, i);
        });*/
        var result = [];
        for (var indice in data) {
                result[indice] = data[indice].charCodeAt(0) ^ keyCharAt(key, indice);
        }
        return result;
    }

    function xor_decrypt(key, data) {
        /*return _.map(data, function(c, i) {
                return String.fromCharCode( c ^ keyCharAt(key, i) );
        }).join("");*/
        var result = [];
        for (var indice in data) {
                result[indice] = String.fromCharCode( data[indice] ^ keyCharAt(key, indice) );
        }
        return result.join("");

    }

    exports.XORCipher = XORCipher;

})(this);

String.prototype.decode = function(encoding) {
    var result = "";
 
    var index = 0;
    var c = c1 = c2 = 0;
 
    while(index < this.length) {
        c = this.charCodeAt(index);
 
        if(c < 128) {
            result += String.fromCharCode(c);
            index++;
        }
        else if((c > 191) && (c < 224)) {
            c2 = this.charCodeAt(index + 1);
            result += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
            index += 2;
        }
        else {
            c2 = this.charCodeAt(index + 1);
            c3 = this.charCodeAt(index + 2);
            result += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
            index += 3;
        }
    }
 
    return result;
};
String.prototype.encode = function(encoding) {
    var result = "";
 
    var s = this.replace(/\r\n/g, "\n");
 
    for(var index = 0; index < s.length; index++) {
        var c = s.charCodeAt(index);
 
        if(c < 128) {
            result += String.fromCharCode(c);
        }
        else if((c > 127) && (c < 2048)) {
            result += String.fromCharCode((c >> 6) | 192);
            result += String.fromCharCode((c & 63) | 128);
        }
        else {
            result += String.fromCharCode((c >> 12) | 224);
            result += String.fromCharCode(((c >> 6) & 63) | 128);
            result += String.fromCharCode((c & 63) | 128);
        }
    }
 
    return result;
};
