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
 * @constructor init specific hooks
 */
function hooks() {
    "use strict";
}
/*
 * @param array layers
 * @param iaScene mainScene
 */
hooks.prototype.beforeMainConstructor = function(mainScene, layers) {

    // Load datas - only useful for themes debugging
    if ($("#content").html() === "{{CONTENT}}") {
        var menu = "";
        menu += '<article id="general">';
        menu += '<img class="article_close" src="img/close.png" alt="close"/>';
        menu += '<h1>'+scene.intro_title+'</h1>';
        menu += '<p>' + scene.intro_detail + '</p>';
        menu += '</article>';

        for (var i in details) {
            if (details[i].options.indexOf("direct-link") == -1) {
                if ((details[i].detail.indexOf("Réponse:") != -1) || (details[i].detail.indexOf("réponse:") != -1)) {
                    var question = details[i].detail.substr(0,details[i].detail.indexOf("Réponse:"));
                    var answer = details[i].detail.substr(details[i].detail.indexOf("Réponse:")+8);
                    menu += '<article id="article-'+i+'">';
                    menu += '<img class="article_close" src="img/close.png" alt="close"/>';
                    menu += '<h1>'+details[i].title+'</h1>';
                    menu += '<p>' + question + '<div style="margin-top:5px;margin-bottom:5px;"><a class="button" href="#response_'+i+'">Réponse</a></div>' + '<div class="response" id="response_'+ i +'">' + answer + '</div>' + '</p>';
                    menu += '</article>';            
                }

                else {
                    menu += '<article id="article-'+i+'">';
                    menu += '<img class="article_close" src="img/close.png" alt="close"/>';
                    menu += '<h1>'+details[i].title+'</h1>';
                    menu += '<p>'+details[i].detail+'</p>';
                    menu += '</article>';                        
                }
            }
        }
        $("#content").html(menu);
    }
    if ($("#title").html() === "{{TITLE}}") $("#title").html(scene.title);


};

/*
 * @param iaScene mainScene
 * @param array layers
 */
hooks.prototype.afterMainConstructor = function(mainScene, layers) {

    // some stuff to manage popin windows

    var viewportHeight = $(window).height();

    var button_click = function() {
        var target = $(this).data("target");
        if ($("#response_" + target).is(":hidden")) {
            if ($(this).data("password")) {
                $("#form_" + target).toggle();
                $("#form_" + target + " input[type=text]").val("");
                $("#form_" + target + " input[type=text]").focus();
            }
            else {
                $("#response_" + target).toggle();
            }
        }
        else {
            if ($(this).data("password")) {
                $("#response_" + target).html($("#response_" + target).data("encrypted_content"));
            }
            $("#response_" + target).toggle();
        }
       
    };
    var unlock_input = function(e) {
        e.preventDefault();
        var entered_password = $(this).parent().children("input[type=text]").val();
        var sha1Digest= new createJs(true);
        sha1Digest.update(entered_password);
        var hash = sha1Digest.digest();
        if (hash == $(this).data("password")) {
            var target = $(this).data("target");
            var encrypted_content = $("#response_" + target).html();
            $("#response_" + target).data("encrypted_content", encrypted_content);
            $("#response_" + target).html(XORCipher.decode(entered_password, encrypted_content).decode());
            $("#response_" + target).show();
            $("#form_" + target).hide();
            $(".button").off("click");
            $(".button").on("click", button_click);
            $(".unlock input[type=submit]").off("click");
            $(".unlock input[type=submit]").on("click", unlock_input);
        }        
    };
    $(".button").on("click", button_click);
    $(".unlock input[type=submit]").on("click", unlock_input);

    $(".meta-doc").on("click", function(){
        $("#content").show();
        $("#general").show();
        var general_border = $("#general").css("border-top-width").substr(0,$("#general").css("border-top-width").length - 2);
        var general_offset = $("#general").offset();
        var content_offset = $("#content").offset();
        $("#general").css({'max-height':(viewportHeight - general_offset.top - content_offset.top - 2 * general_border)});
    });

    $(".overlay").hide();

    $(".infos").on("click", function(){
        $("#rights").show();
    });
    $("#popup_close").on("click", function(){
        $("#rights").hide();
    });

    $(".article_close").on("click", function(){
        $(this).parent().hide();
        $("#content").hide();
    });
    document.addEventListener("click", function(ev){
        if (mainScene.noPropagation) {
            mainScene.noPropagation = false;
        }
        else {
            if (mainScene.zoomActive === 1) {
                if ((mainScene.element !== 0) && 
                (typeof(mainScene.element) !== 'undefined')) {
                    mainScene.element.kineticElement[0].fire("click");
                }
            }
            else if (mainScene.cursorState.indexOf("ZoomIn.cur") !== -1) {
                document.body.style.cursor = "default";
                mainScene.cursorState = "default";
                mainScene.element.kineticElement[0].fire("mouseleave");
            }
        }
    });
};
/*
 *
 *  
 */
hooks.prototype.afterIaObjectConstructor = function(iaScene, idText, detail, iaObject) {

};

/*
 *
 *  
 */
hooks.prototype.afterIaObjectFocus = function(iaScene, idText, iaObject) {

};


/*
 *
 *  
 */
hooks.prototype.afterIaObjectZoom = function(iaScene, idText, iaObject) {
    var viewportHeight = $(window).height();
    $("#content").show();
    $('#' + idText).show();
    $('#' + idText + " audio").each(function(){
        if ($(this).data("state") === "autostart") {
            $(this)[0].play();
        }
    });            
    var article_border = $('#' + idText).css("border-top-width").substr(0,$('#' + idText).css("border-top-width").length - 2);
    var article_offset = $('#' + idText).offset();
    var content_offset = $("#content").offset();
    $('#' + idText).css({'max-height':(viewportHeight - article_offset.top - content_offset.top - 2 * article_border)});  
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


/*
 * 
 * @param {type} imageObj
 * @param {type} detail
 * @param {type} layer
 * @param {type} idText
 * @param {type} baseImage
 * @param {type} iaScene
 * @param {type} backgroundCache_layer
 * @constructor create image active object
 */
function IaObject(imageObj, detail, layer, idText, baseImage, iaScene, background_layer, backgroundCache_layer, myhooks) {
    "use strict";
    var that = this;
    this.path = [];
    this.title = [];      
    this.kineticElement = [];
    this.backgroundImage = [];
    this.backgroundImageOwnScaleX = [];
    this.backgroundImageOwnScaleY = [];
    this.persistent = [];
    this.originalX = [];
    this.originalY = [];
    this.options = [];    
    this.layer = layer;
    this.background_layer = background_layer;
    this.backgroundCache_layer = backgroundCache_layer;
    this.imageObj = imageObj;
    this.agrandissement = 0;
    this.zoomActive = 0;
    this.minX = 10000;
    this.minY = 10000;
    this.maxX = -10000;
    this.maxY = -10000;
    this.tween = []; 
    this.tween_group = 0;
    this.group = 0;
    this.idText = idText;    
    this.myhooks = myhooks;
    // Create kineticElements and include them in a group
   
    that.group = new Kinetic.Group();
    that.layer.add(that.group);
    
    if (typeof(detail.path) !== 'undefined') {
        that.includePath(detail, 0, that, iaScene, baseImage, idText);
    }
    else if (typeof(detail.image) !== 'undefined') {
        that.includeImage(detail, 0, that, iaScene, baseImage, idText);
    }
    else if (typeof(detail.group) !== 'undefined') {
        for (var i in detail.group) {
            if (typeof(detail.group[i].path) !== 'undefined') {
                that.includePath(detail.group[i], i, that, iaScene, baseImage, idText);
            }
            else if (typeof(detail.group[i].image) !== 'undefined') {
                that.includeImage(detail.group[i], i, that, iaScene, baseImage, idText);
            }
        }
        that.definePathBoxSize(detail, that);
    }
    else {
        console.log(detail);
    }

    this.defineTweens(this, iaScene);
    this.myhooks.afterIaObjectConstructor(iaScene, idText, detail, this);
}

/*
 * 
 * @param {type} detail
 * @param {type} i KineticElement index
 * @returns {undefined}
 */
IaObject.prototype.includeImage = function(detail, i, that, iaScene, baseImage, idText) {
    that.defineImageBoxSize(detail, that);
    var rasterObj = new Image();
    rasterObj.src = detail.image; 
    that.title[i] = detail.title;    
    that.backgroundImage[i] = rasterObj;
    that.kineticElement[i] = new Kinetic.Image({
        name: detail.title,
        x: parseFloat(detail.x) * iaScene.coeff,
        y: parseFloat(detail.y) * iaScene.coeff + iaScene.y,
        width: detail.width,
        height: detail.height,
        scale: {x:iaScene.coeff,y:iaScene.coeff}
    });

    rasterObj.onload = function() {
        that.backgroundImageOwnScaleX[i] = iaScene.scale * detail.width / this.width;
        that.backgroundImageOwnScaleY[i] = iaScene.scale * detail.height / this.height;
        var zoomable = true;
        if ((typeof(detail.fill) !== 'undefined') && 
            (detail.fill === "#000000")) {
            zoomable = false;
        }
        if ((typeof(detail.options) !== 'undefined')) {
            that.options[i] = detail.options;
        }
        that.persistent[i] = "off-image";
        if ((typeof(detail.fill) !== 'undefined') && 
            (detail.fill === "#ffffff")) {
            that.persistent[i] = "onImage";
            that.kineticElement[i].fillPriority('pattern');
            that.kineticElement[i].fillPatternScaleX(that.backgroundImageOwnScaleX[i] * 1/iaScene.scale);
            that.kineticElement[i].fillPatternScaleY(that.backgroundImageOwnScaleY[i] * 1/iaScene.scale);                
            that.kineticElement[i].fillPatternImage(that.backgroundImage[i]); 
            zoomable = false;
        }
        
        that.group.add(that.kineticElement[i]);
        that.addEventsManagement(i,zoomable, that, iaScene, baseImage, idText);


        // define hit area excluding transparent pixels
        // =============================================================

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

        var canvas_source = document.createElement('canvas');
        canvas_source.setAttribute('width', cropWidth * iaScene.coeff);
        canvas_source.setAttribute('height', cropHeight * iaScene.coeff);
        var context_source = canvas_source.getContext('2d');
        context_source.drawImage(rasterObj,0,0, cropWidth * iaScene.coeff, cropHeight * iaScene.coeff);
        imageDataSource = context_source.getImageData(0, 0, cropWidth * iaScene.coeff, cropHeight * iaScene.coeff);            
        len = imageDataSource.data.length;
        that.group.zoomActive = 0;
     
        (function(len, imageDataSource){
        that.kineticElement[i].hitFunc(function(context) {
            if (that.group.zoomActive == 0) {
                rgbColorKey = Kinetic.Util._hexToRgb(this.colorKey);
                //detach from the DOM
                var imageData = imageDataSource.data;
                // just replace scene colors by hit colors - alpha remains unchanged
                for(j = 0; j < len; j += 4) {
                   imageData[j + 0] = rgbColorKey.r;
                   imageData[j + 1] = rgbColorKey.g;
                   imageData[j + 2] = rgbColorKey.b;
                   // imageData[j + 3] = imageDataSource.data[j + 3];
                } 
                // reatach to the DOM
                imageDataSource.data = imageData;
  
                context.putImageData(imageDataSource, cropX * iaScene.coeff, cropY * iaScene.coeff);     
            }
            else {
                context.beginPath();
                context.rect(0,0,this.width(),this.height());
                context.closePath();
                context.fillStrokeShape(this);					
            }
        });        
        })(len, imageDataSource);
        /*that.kineticElement[i].sceneFunc(function(context) {
            var yo = that.layer.getHitCanvas().getContext().getImageData(0,0,iaScene.width, iaScene.height);
            context.putImageData(yo, 0,0);  
        });*/

        // =============================================================
        
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
    that.path[i] = detail.path;
    that.title[i] = detail.title;
    // if detail is out of background, hack maxX and maxY
    if (parseFloat(detail.maxX) < 0) detail.maxX = 1;
    if (parseFloat(detail.maxY) < 0) detail.maxY = 1;        
    that.kineticElement[i] = new Kinetic.Path({
        name: detail.title,
        data: detail.path,
        x: parseFloat(detail.x) * iaScene.coeff,
        y: parseFloat(detail.y) * iaScene.coeff + iaScene.y,
        scale: {x:iaScene.coeff,y:iaScene.coeff},
        fill: 'rgba(0, 0, 0, 0)'
    });
    that.definePathBoxSize(detail, that);
    // crop background image to suit shape box
    that.cropCanvas = document.createElement('canvas');
    that.cropCanvas.setAttribute('width', parseFloat(detail.maxX) - parseFloat(detail.minX));
    that.cropCanvas.setAttribute('height', parseFloat(detail.maxY) - parseFloat(detail.minY));
    var cropCtx = that.cropCanvas.getContext('2d');
    var cropX = Math.max(parseFloat(detail.minX), 0);
    var cropY = Math.max(parseFloat(detail.minY), 0);
    var cropWidth = (Math.min((parseFloat(detail.maxX) - cropX) * iaScene.scale, Math.floor(parseFloat(iaScene.originalWidth) * iaScene.scale)));
    var cropHeight = (Math.min((parseFloat(detail.maxY) - cropY) * iaScene.scale, Math.floor(parseFloat(iaScene.originalHeight) * iaScene.scale)));
    if (cropX * iaScene.scale + cropWidth > iaScene.originalWidth * iaScene.scale) {
	cropWidth = iaScene.originalWidth * iaScene.scale - cropX * iaScene.scale;
    }
    if (cropY * iaScene.scale + cropHeight > iaScene.originalHeight * iaScene.scale) {
	cropHeight = iaScene.originalHeight * iaScene.scale - cropY * iaScene.scale;
    }
    var posX = 0;
    var posY = 0;
    if (parseFloat(detail.minX) < 0) posX = parseFloat(detail.minX) * (-1);
    if (parseFloat(detail.minY) < 0) posY = parseFloat(detail.minY) * (-1);
    // bad workaround to avoid null dimensions
    if (cropWidth == 0) cropWidth = 1;
    if (cropHeight == 0) cropHeight = 1;    
    cropCtx.drawImage(
        that.imageObj,
        cropX * iaScene.scale,
        cropY * iaScene.scale,
        cropWidth,
        cropHeight,
        posX,
        posY,
        cropWidth,
        cropHeight
    );
    var dataUrl = that.cropCanvas.toDataURL();
    delete that.cropCanvas;
    var cropedImage = new Image();
    cropedImage.src = dataUrl;
    cropedImage.onload = function() {
        that.backgroundImage[i] = cropedImage;
        that.backgroundImageOwnScaleX[i] = 1;
        that.backgroundImageOwnScaleY[i] = 1;
        that.kineticElement[i].fillPatternRepeat('no-repeat');
        that.kineticElement[i].fillPatternX(detail.minX);
        that.kineticElement[i].fillPatternY(detail.minY);
    };

    var zoomable = true;
    if ((typeof(detail.fill) !== 'undefined') && 
        (detail.fill === "#000000")) {
        zoomable = false;
    }
    if ((typeof(detail.options) !== 'undefined')) {
        that.options[i] = detail.options;
    }    
    that.persistent[i] = "off";
    if ((typeof(detail.fill) !== 'undefined') && 
        (detail.fill === "#ffffff")) {
        that.persistent[i] = "onPath";
        that.kineticElement[i].fill('rgba(' + iaScene.colorPersistent.red + ',' + iaScene.colorPersistent.green + ',' + iaScene.colorPersistent.blue + ',' + iaScene.colorPersistent.opacity + ')');
    }    
    that.addEventsManagement(i, zoomable, that, iaScene, baseImage, idText);

    that.group.add(that.kineticElement[i]);
    that.group.draw();
};

/*
 * 
 * @param {type} index
 * @returns {undefined}
 */
IaObject.prototype.defineImageBoxSize = function(detail, that) {
    "use strict";

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
 * Define zoom rate and define tween effect for each group
 * @returns {undefined}
 */
IaObject.prototype.defineTweens = function(that, iaScene) {

    that.minX = that.minX * iaScene.coeff;
    that.minY = that.minY * iaScene.coeff;
    that.maxX = that.maxX * iaScene.coeff;
    that.maxY = that.maxY * iaScene.coeff;    

    var largeur = that.maxX - that.minX;
    var hauteur = that.maxY - that.minY;
    that.agrandissement1  = (iaScene.height - iaScene.y) / hauteur;   // beta
    that.agrandissement2  = iaScene.width / largeur;    // alpha

    if (hauteur * that.agrandissement2 > iaScene.height) {
        that.agrandissement = that.agrandissement1;
        that.tweenX = (0 - (that.minX)) * that.agrandissement + (iaScene.width - largeur * that.agrandissement) / 2;
        that.tweenY = (0 - iaScene.y - (that.minY)) * that.agrandissement + iaScene.y;
    }
    else {
        that.agrandissement = that.agrandissement2;
        that.tweenX = (0 - (that.minX)) * that.agrandissement;
        that.tweenY = 1 * ((0 - iaScene.y - (that.minY)) * that.agrandissement + iaScene.y + (iaScene.height - hauteur * that.agrandissement) / 2);
    }
};

/*
 * Define mouse events on the current KineticElement
 * @param {type} i KineticElement index
 * @returns {undefined}
 */
   
IaObject.prototype.addEventsManagement = function(i, zoomable, that, iaScene, baseImage, idText) {

    if (that.options[i].indexOf("disable-click") !== -1) return;
    /*
     * if mouse is over element, fill the element with semi-transparency
     */
    that.kineticElement[i].on('mouseover', function() {
        if (iaScene.cursorState.indexOf("ZoomOut.cur") !== -1) {

        }
        else if (iaScene.cursorState.indexOf("ZoomIn.cur") !== -1) {

        }
        else if (iaScene.cursorState.indexOf("HandPointer.cur") === -1) {
            document.body.style.cursor = "url(img/HandPointer.cur),auto";
            iaScene.cursorState = "url(img/HandPointer.cur),auto";
            for (var i in that.kineticElement) {
                if (that.persistent[i] == "off") {
                    that.kineticElement[i].fillPriority('color');
                    that.kineticElement[i].fill(iaScene.overColor);
                    that.kineticElement[i].scale(iaScene.coeff);
                    that.kineticElement[i].stroke(iaScene.overColorStroke);
                    that.kineticElement[i].strokeWidth(2);                    
                }
                else if (that.persistent[i] == "onPath") {
                    that.kineticElement[i].fillPriority('color');
                    that.kineticElement[i].fill('rgba(' + iaScene.colorPersistent.red + ',' + iaScene.colorPersistent.green + ',' + iaScene.colorPersistent.blue + ',' + iaScene.colorPersistent.opacity + ')');                       

                }
                else if ((that.persistent[i] == "onImage") || (that.persistent[i] == "off-image")) {
                    that.kineticElement[i].fillPriority('pattern');
                    that.kineticElement[i].fillPatternScaleX(that.backgroundImageOwnScaleX[i] * 1/iaScene.scale);
                    that.kineticElement[i].fillPatternScaleY(that.backgroundImageOwnScaleY[i] * 1/iaScene.scale); 
                    that.kineticElement[i].fillPatternImage(that.backgroundImage[i]);                        
                }                
            }
            that.layer.batchDraw();
        }
    });
    /*
     * if we click in this element, manage zoom-in, zoom-out
     */
    if (that.options[i].indexOf("direct-link") !== -1) {
        that.kineticElement[i].on('click touchstart', function(e) {
            location.href = that.title[i];
        });
    }
    else {    
        that.kineticElement[i].on('click touchstart', function() {
            var i = 0;
            iaScene.noPropagation = true;
            // let's zoom
            if ((iaScene.cursorState.indexOf("ZoomIn.cur") !== -1) && 
                (iaScene.element === that)) {

                iaScene.zoomActive = 0;
                document.body.style.cursor = 'default';
                iaScene.cursorState = 'default';
                that.myhooks.afterIaObjectZoom(iaScene, idText, that);




            }
            // let's unzoom
            else if (iaScene.cursorState.indexOf("ZoomOut.cur") != -1) {

                if ((that.group.zoomActive == 1)) {
                    iaScene.zoomActive = 0;
                    that.group.zoomActive = 0;
                    that.group.scaleX(1);
                    that.group.scaleY(1);
                    that.group.x(that.originalX[0]);
                    that.group.y(that.originalY[0]);

                    $('#' + that.idText + " audio").each(function(){
                        $(this)[0].pause();
                    });        
                    $('#' + that.idText + " video").each(function(){
                        $(this)[0].pause();
                    });
                    
                    that.backgroundCache_layer.moveToBottom();
                    document.body.style.cursor = "default";
                    iaScene.cursorState = "default";

                    for (i in that.kineticElement) {
                        if (that.persistent[i] == "off") {
                            that.kineticElement[i].fillPriority('color');
                            that.kineticElement[i].fill('rgba(0, 0, 0, 0)');
                            that.kineticElement[i].setStroke('rgba(0, 0, 0, 0)');
                            that.kineticElement[i].setStrokeWidth(0);                             
                        }
                        else if (that.persistent[i] == "onPath") {
                            that.kineticElement[i].fillPriority('color');
                            that.kineticElement[i].fill('rgba(' + iaScene.colorPersistent.red + ',' + iaScene.colorPersistent.green + ',' + iaScene.colorPersistent.blue + ',' + iaScene.colorPersistent.opacity + ')');                       
                            that.kineticElement[i].setStroke('rgba(0, 0, 0, 0)');
                            that.kineticElement[i].setStrokeWidth(0);                             
                        }
                        else if (that.persistent[i] == "onImage") {
                            that.kineticElement[i].fillPriority('pattern');
                            that.kineticElement[i].fillPatternScaleX(that.backgroundImageOwnScaleX[i] * 1/iaScene.scale);
                            that.kineticElement[i].fillPatternScaleY(that.backgroundImageOwnScaleY[i] * 1/iaScene.scale); 
                            that.kineticElement[i].fillPatternImage(that.backgroundImage[i]);                        
                            that.kineticElement[i].setStroke('rgba(0, 0, 0, 0)');
                            that.kineticElement[i].setStrokeWidth(0);                             
                        }
                    }                    
                    that.layer.draw();
                    that.backgroundCache_layer.draw();
                }
            }
            // let's focus
            else {
                if (iaScene.zoomActive === 0) {
                    if ((iaScene.element !== 0) && 
                        (typeof(iaScene.element) !== 'undefined')) {

                        for (i in iaScene.element.kineticElement) {
                            iaScene.element.kineticElement[i].fillPriority('color');
                            iaScene.element.kineticElement[i].fill('rgba(0,0,0,0)');
                            iaScene.element.kineticElement[i].setStroke('rgba(0, 0, 0, 0)');
                            iaScene.element.kineticElement[i].setStrokeWidth(0);                         
                        }
                        iaScene.element.layer.draw();
                        $('#' + iaScene.element.idText + " audio").each(function(){
                            $(this)[0].pause();
                        });        
                        $('#' + iaScene.element.idText + " video").each(function(){
                            $(this)[0].pause();
                        });                        
                    }                    
                    //if (zoomable === true) {
                        //document.body.style.cursor = 'url("img/ZoomIn.cur"),auto';
                        iaScene.cursorState = 'url("img/ZoomIn.cur"),auto';
                    //}
                    $('.collapse.in').each(function (index) {
                            //if ($(this).attr("id") !== idText) 
                                //$(this).collapse("toggle");
                    });
                    //$('#' + idText).collapse("show");


                    var cacheBackground = true;
                    for (i in that.kineticElement) {
                        if (that.persistent[i] === "onImage") cacheBackground = false;
                        that.kineticElement[i].fillPriority('pattern');
                        that.kineticElement[i].fillPatternScaleX(that.backgroundImageOwnScaleX[i] * 1/iaScene.scale);
                        that.kineticElement[i].fillPatternScaleY(that.backgroundImageOwnScaleY[i] * 1/iaScene.scale); 
                        that.kineticElement[i].fillPatternImage(that.backgroundImage[i]);
                        that.kineticElement[i].stroke(iaScene.overColorStroke);
                        that.kineticElement[i].strokeWidth(2);   
                        that.kineticElement[i].moveToTop();
                    }
                    if (cacheBackground === true) that.backgroundCache_layer.moveToTop();
                    that.group.moveToTop();
                    that.layer.moveToTop();
                    that.layer.draw(); 
                    iaScene.element = that;
                    that.myhooks.afterIaObjectFocus(iaScene, idText, that);
                }
            }
        });
    }
    /*
     * if we leave this element, just clear the scene
     */
    that.kineticElement[i].on('mouseleave', function() {
        if (iaScene.cursorState.indexOf("ZoomOut.cur") !== -1) {

        }
        else {
            var mouseXY = that.layer.getStage().getPointerPosition();
            if (typeof(mouseXY) == "undefined") {
		mouseXY = {x:0,y:0};
            }            
            if ((that.layer.getStage().getIntersection(mouseXY) != this)) {
                that.backgroundCache_layer.moveToBottom();
                for (var i in that.kineticElement) {
                    if ((that.persistent[i] == "off") || (that.persistent[i] == "off-image")) {
                        that.kineticElement[i].fillPriority('color');
                        that.kineticElement[i].fill('rgba(0, 0, 0, 0)');
                        that.kineticElement[i].stroke('rgba(0, 0, 0, 0)');
                        that.kineticElement[i].strokeWidth(0);                         
                    }
                    else if (that.persistent[i] == "onPath") {
                        that.kineticElement[i].fillPriority('color');
                        that.kineticElement[i].fill('rgba(' + iaScene.colorPersistent.red + ',' + iaScene.colorPersistent.green + ',' + iaScene.colorPersistent.blue + ',' + iaScene.colorPersistent.opacity + ')');                       
                        that.kineticElement[i].stroke('rgba(0, 0, 0, 0)');
                        that.kineticElement[i].strokeWidth(0);                        

                    }
                    else if (that.persistent[i] == "onImage") {
                        that.kineticElement[i].fillPriority('pattern');
                        that.kineticElement[i].fillPatternScaleX(that.backgroundImageOwnScaleX[i] * 1/iaScene.scale);
                        that.kineticElement[i].fillPatternScaleY(that.backgroundImageOwnScaleY[i] * 1/iaScene.scale); 
                        that.kineticElement[i].fillPatternImage(that.backgroundImage[i]);                        
                        that.kineticElement[i].stroke('rgba(0, 0, 0, 0)');
                        that.kineticElement[i].strokeWidth(0);                        

                    }                    
                }
                document.body.style.cursor = "default";
                iaScene.cursorState = "default";
                that.layer.draw();						
            }
        }
    });        
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

    // color used over background image during focus
    var _colorCache = {red:0, green:0, blue:0, opacity:0.6};
 
    // internal
    this.fullScreen = "off";
    this.backgroundCacheColor = 'rgba(' + _colorCache.red + ',' + _colorCache.green + ',' + _colorCache.blue + ',' + _colorCache.opacity + ')';
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

    // area located under the canvas. If mouse over is detected, 
    // we must re-activate mouse events on canvas
    var detect = document.getElementById("detect");
    detect.addEventListener("mouseover", function()
        {
            that.canvas.style.pointerEvents="auto";
            if ((IaScene.element !== 0) && (typeof(IaScene.element) !== 'undefined')) {
                for (var i in IaScene.element.kineticElement) {
                    IaScene.element.kineticElement[i].fillPriority('color');
                    IaScene.element.kineticElement[i].fill('rgba(0,0,0,0)');
                }
            }
        }, false);			
    detect.addEventListener("touchstart", function()
        {   
            that.canvas.style.pointerEvents="auto";
            if ((IaScene.element !== 0) && (typeof(IaScene.element) !== 'undefined')) {
                for (var i in IaScene.element.kineticElement) {
                    IaScene.element.kineticElement[i].fillPriority('color');
                    IaScene.element.kineticElement[i].fill('rgba(0,0,0,0)');
                }
            }
        }, false);	

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

        // area containing image background    
        var baseImage = new Kinetic.Image({
            x: 0,
            y: mainScene.y,
            width: scene.width,
            height: scene.height,
            scale: {x:mainScene.coeff,y:mainScene.coeff},
            image: that.imageObj
        });

        // cache used over background image
        var baseCache = new Kinetic.Rect({
            x: 0,
            y: mainScene.y,
            width: scene.width,
            height: scene.height,
            scale: {x:mainScene.coeff,y:mainScene.coeff},
            fill: mainScene.backgroundCacheColor
        });

        // define area to disable canvas events management when
        // mouse is over. Thus, we can reach div located under canvas 
        var disableArea = new Kinetic.Rect({
            x: mainScene.width  * mainScene.ratio,
            y: mainScene.y,
            width: mainScene.width * (1 - mainScene.ratio),
            height: mainScene.height
        });		
        disableArea.on('mouseover touchstart', function() {
            canvas.style.pointerEvents="none";
        });
        var layers = [];
        that.layers = layers;
        layers[0] = new Kinetic.FastLayer();	
        layers[1] = new Kinetic.FastLayer();	
        layers[2] = new Kinetic.Layer();

        layers[0].add(baseCache);
        layers[1].add(baseImage);
        layers[2].add(disableArea);	
        stage.add(layers[0]);
        stage.add(layers[1]);
        stage.add(layers[2]);
        myhooks.beforeMainConstructor(mainScene, that.layers);
        var indice = 3;
        layers[indice] = new Kinetic.Layer();
        stage.add(layers[indice]);        
        for (var i in details) {
            //var indice = parseInt(i+3);
            //layers[indice] = new Kinetic.Layer();
            //stage.add(layers[indice]);
            var iaObj = new IaObject(that.imageObj, details[i], layers[indice], "article-" + i, baseImage, mainScene, layers[1], layers[0], myhooks);
        }
        myhooks.afterMainConstructor(mainScene, that.layers); 
        $("#splash").fadeOut("slow", function(){
                $("#loader").hide();	
        });
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
