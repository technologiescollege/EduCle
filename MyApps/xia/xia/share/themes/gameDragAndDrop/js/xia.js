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
    this.xiaDetail = [];
    this.minX = 10000;
    this.minY = 10000;
    this.maxX = -10000;
    this.maxY = -10000;
    this.match = false;
    this.collisions = "on";

    this.layer = params.layer;
    this.imageObj = params.imageObj;
    this.idText = params.idText;
    this.myhooks = params.myhooks;

    // Create kineticElements and include them in a group
   
    //that.group = new Kinetic.Group();
    //that.layer.add(that.group);
    
    if (typeof(params.detail.path) !== 'undefined') {
        that.includePath(params.detail, 0, that, params.iaScene, params.baseImage, params.idText);
    }
    else if (typeof(params.detail.image) !== 'undefined') {
        that.includeImage(params.detail, 0, that, params.iaScene, params.baseImage, params.idText);
    }
    // actually, groups are not allowed because of boxsize restriction
    
    /*else if (typeof(detail.group) !== 'undefined') {
        for (var i in detail.group) {
            if (typeof(detail.group[i].path) !== 'undefined') {
                that.includePath(detail.group[i], i, that, iaScene, baseImage, idText);
            }
            else if (typeof(detail.group[i].image) !== 'undefined') {
                that.includeImage(detail.group[i], i, that, iaScene, baseImage, idText);
            }
        }
        that.definePathBoxSize(detail, that);
    }*/
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

    var that = this;
    that.xiaDetail[i] = new XiaDetail(detail, idText);

    that.defineImageBoxSize(detail, that);
    var rasterObj = new Image();
    
    rasterObj.src = detail.image;
    
    that.xiaDetail[i].kineticElement = new Kinetic.Image({
        id: detail.id,
        name: detail.title,
        x: parseFloat(detail.x) * iaScene.coeff,
        y: parseFloat(detail.y) * iaScene.coeff + iaScene.y,
        width: detail.width,
        height: detail.height,
        draggable: that.xiaDetail[i].draggable_object
     
    });
    that.xiaDetail[i].kineticElement.setXiaParent(that.xiaDetail[i]);
    that.xiaDetail[i].kineticElement.setIaObject(that);
    that.xiaDetail[i].backgroundImage = rasterObj;
    that.xiaDetail[i].kineticElement.tooltip = "";
    
    var collision_state = $("#" + idText).data("collisions");
    if ($('article[data-target="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        collision_state = "off";
    }    
    that.collisions = collision_state;
    var global_collision_state = $("#message_success").data("collisions");
    if (global_collision_state == "on" && collision_state != "off") {
        that.xiaDetail[i].kineticElement.dragBoundFunc(function(pos) {
            var x_value = pos.x;
            var y_value = pos.y;
            var len = iaScene.shapes.length;
            var getAbsolutePosition = {
                x : this.getAbsolutePosition().x,
                y : this.getAbsolutePosition().y,
            }    
            var objectWidth = that.maxX - that.minX;
            var objectHeight = that.maxY - that.minY;
            for(var i=0; i< len; i++) {
                if (that != iaScene.shapes[i] && iaScene.shapes[i].collisions == "on") {

                    var shape = {
                        maxX : iaScene.shapes[i].maxX,
                        maxY : iaScene.shapes[i].maxY,
                        minX : iaScene.shapes[i].minX - objectWidth,
                        minY : iaScene.shapes[i].minY - objectHeight
                    };

                    var objectLocatedAt = {
                        horizontal: (getAbsolutePosition.y < shape.maxY - 10) &&
                          (getAbsolutePosition.y > shape.minY + 10),
                        vertical: (getAbsolutePosition.x < shape.maxX - 10) &&
                          (getAbsolutePosition.x > shape.minX + 10),
                        bottomLeft: getAbsolutePosition.x <= shape.minX + 10 &&
                          getAbsolutePosition.y >= shape.maxY - 10,
                        topLeft: getAbsolutePosition.x <= shape.minX + 10 &&
                          getAbsolutePosition.y <= shape.minY + 10,
                        topRight: getAbsolutePosition.x >= shape.maxX - 10 &&
                          getAbsolutePosition.y <= shape.minY + 10,
                        bottomRight: getAbsolutePosition.x >= shape.maxX - 10 &&
                          getAbsolutePosition.y >= shape.maxY - 10

                    };
                    if (objectLocatedAt.horizontal) {
                        if (pos.x <= shape.maxX &&
                          getAbsolutePosition.x >= shape.maxX - 10) {
                            if (x_value == pos.x) {
                                x_value = shape.maxX;
                            }
                            else {
                                x_value = Math.max(shape.maxX, x_value);
                            }
                        }
                        if (pos.x >= shape.minX &&
                          getAbsolutePosition.x <= shape.minX + 10) {
                            if (x_value == pos.x) {
                                x_value = shape.minX;
                            }
                            else {
                                x_value = Math.min(shape.minX, x_value);
                            }
                        }
                    }
                    if (objectLocatedAt.vertical) {
                        if (pos.y <= shape.maxY &&
                          getAbsolutePosition.y >= shape.maxY -10) {
                            if (y_value == pos.y) {
                                y_value = shape.maxY;
                            }
                            else {
                                y_value = Math.max(shape.maxY, y_value);
                            }
                        }

                        if (pos.y >= shape.minY &&
                          getAbsolutePosition.y <= 10 + shape.minY) {
                            if (y_value == pos.y) {
                                y_value = shape.minY;
                            }
                            else {
                                y_value = Math.min(shape.minY, y_value);
                            }
                        }
                    }
                    var delta = 15;
                    if (pos.x >= shape.minX + delta &&
                      pos.y <= shape.maxY - delta &&
                      objectLocatedAt.bottomLeft
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.minX;
                        }
                        else {
                            x_value = Math.min(shape.minX, x_value);
                        }

                    }
                    if (pos.x >= shape.minX + delta &&
                      pos.y >= shape.minY + delta &&
                      objectLocatedAt.topLeft
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.minX;
                        }
                        else {
                            x_value = Math.min(shape.minX, x_value);
                        }

                    }
                    if (pos.x <= shape.maxX - delta &&
                      pos.y >= shape.minY + delta &&
                      objectLocatedAt.topRight
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.maxX;
                        }
                        else {
                            x_value = Math.max(shape.maxX, x_value);
                        }

                    }
                    if (pos.x <= shape.maxX - delta &&
                      pos.y <= shape.maxY - delta &&
                      objectLocatedAt.bottomRight
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.maxX;
                        }
                        else {
                            x_value = Math.max(shape.maxX, x_value);
                        }

                    }
                }
            }

            return {
              x: x_value,
              y: y_value
            };
        
        });
       
    }
    
    
    rasterObj.onload = function() {
        
        that.xiaDetail[i].kineticElement.backgroundImageOwnScaleX = iaScene.scale * detail.width / this.width;
        that.xiaDetail[i].kineticElement.backgroundImageOwnScaleY = iaScene.scale * detail.height / this.height;        

        if ($('article[data-tooltip="' + $("#" + idText).data("kinetic_id") + '"]').length == 0) {
            detail.fill = '#ffffff';    // force image to be displayed - must refactor if it is a good idea !
        }
        that.xiaDetail[i].persistent = "off";
        if ((typeof(detail.fill) !== 'undefined') && 
            (detail.fill === "#ffffff")) {
            that.xiaDetail[i].persistent = "onImage";
            that.xiaDetail[i].kineticElement.fillPriority('pattern');
            that.xiaDetail[i].kineticElement.fillPatternScaleX(that.xiaDetail[i].kineticElement.backgroundImageOwnScaleX * 1/iaScene.scale);
            that.xiaDetail[i].kineticElement.fillPatternScaleY(that.xiaDetail[i].kineticElement.backgroundImageOwnScaleY * 1/iaScene.scale);                
            that.xiaDetail[i].kineticElement.fillPatternImage(that.xiaDetail[i].backgroundImage); 
        }
        
        that.layer.add(that.xiaDetail[i].kineticElement);
        that.addEventsManagement(i, that, iaScene, baseImage, idText);
        
        // define hit area excluding transparent pixels
        // =============================================================
        that.rasterObj = rasterObj;

        that.xiaDetail[i].kineticElement.cache();
        that.xiaDetail[i].kineticElement.scale({x:iaScene.coeff,y:iaScene.coeff});
        that.xiaDetail[i].kineticElement.drawHitFromCache();
        that.xiaDetail[i].kineticElement.draw();
    };

};    


/*
 * 
 * @param {type} path
 * @param {type} i KineticElement index
 * @returns {undefined}
 */
IaObject.prototype.includePath = function(detail, i, that, iaScene, baseImage, idText) {
    var that = this;
    that.xiaDetail[i] = new XiaDetail(detail, idText);

    that.xiaDetail[i].path = detail.path;
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
        fill: 'rgba(0, 0, 0, 0)',
        draggable : that.xiaDetail[i].draggable_object
    });
    that.xiaDetail[i].kineticElement.setIaObject(that);    
    that.xiaDetail[i].kineticElement.setXiaParent(that.xiaDetail[i]);
    that.xiaDetail[i].kineticElement.tooltip = "";
    
    var collision_state = $("#" + idText).data("collisions");
    if ($('article[data-target="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        collision_state = "off";
    }
    that.collisions = collision_state;

    var global_collision_state = $("#message_success").data("collisions");

    if (global_collision_state == "on" && collision_state != "off") {


        that.xiaDetail[i].kineticElement.dragBoundFunc(function(pos) {
            var x_value = pos.x;
            var y_value = pos.y;
            var len = iaScene.shapes.length;
            var getAbsolutePosition = {
                x : this.getAbsolutePosition().x,
                y : this.getAbsolutePosition().y,
            }    

            var objectWidth = that.maxX - that.minX;
            var objectHeight = that.maxY - that.minY;
            for(var i=0; i< len; i++) {
                if (that != iaScene.shapes[i] && iaScene.shapes[i].collisions == "on") {

                    var shape = {
                        maxX : iaScene.shapes[i].maxX,
                        maxY : iaScene.shapes[i].maxY,
                        minX : iaScene.shapes[i].minX - objectWidth,
                        minY : iaScene.shapes[i].minY - objectHeight
                    };

                    var objectLocatedAt = {
                        horizontal: (getAbsolutePosition.y < shape.maxY - 10) &&
                          (getAbsolutePosition.y > shape.minY + 10),
                        vertical: (getAbsolutePosition.x < shape.maxX - 10) &&
                          (getAbsolutePosition.x > shape.minX + 10),
                        bottomLeft: getAbsolutePosition.x <= shape.minX + 10 &&
                          getAbsolutePosition.y >= shape.maxY - 10,
                        topLeft: getAbsolutePosition.x <= shape.minX + 10 &&
                          getAbsolutePosition.y <= shape.minY + 10,
                        topRight: getAbsolutePosition.x >= shape.maxX - 10 &&
                          getAbsolutePosition.y <= shape.minY + 10,
                        bottomRight: getAbsolutePosition.x >= shape.maxX - 10 &&
                          getAbsolutePosition.y >= shape.maxY - 10

                    };
                    if (objectLocatedAt.horizontal) {
                        if (pos.x <= shape.maxX &&
                          getAbsolutePosition.x >= shape.maxX - 10) {
                            if (x_value == pos.x) {
                                x_value = shape.maxX;
                            }
                            else {
                                x_value = Math.max(shape.maxX, x_value);
                            }
                        }
                        if (pos.x >= shape.minX &&
                          getAbsolutePosition.x <= shape.minX + 10) {
                            if (x_value == pos.x) {
                                x_value = shape.minX;
                            }
                            else {
                                x_value = Math.min(shape.minX, x_value);
                            }
                        }
                    }
                    if (objectLocatedAt.vertical) {
                        if (pos.y <= shape.maxY &&
                          getAbsolutePosition.y >= shape.maxY -10) {
                            if (y_value == pos.y) {
                                y_value = shape.maxY;
                            }
                            else {
                                y_value = Math.max(shape.maxY, y_value);
                            }
                        }

                        if (pos.y >= shape.minY &&
                          getAbsolutePosition.y <= 10 + shape.minY) {
                            if (y_value == pos.y) {
                                y_value = shape.minY;
                            }
                            else {
                                y_value = Math.min(shape.minY, y_value);
                            }
                        }
                    }
                    var delta = 15;
                    if (pos.x >= shape.minX + delta &&
                      pos.y <= shape.maxY - delta &&
                      objectLocatedAt.bottomLeft
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.minX;
                        }
                        else {
                            x_value = Math.min(shape.minX, x_value);
                        }

                    }
                    if (pos.x >= shape.minX + delta &&
                      pos.y >= shape.minY + delta &&
                      objectLocatedAt.topLeft
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.minX;
                        }
                        else {
                            x_value = Math.min(shape.minX, x_value);
                        }

                    }
                    if (pos.x <= shape.maxX - delta &&
                      pos.y >= shape.minY + delta &&
                      objectLocatedAt.topRight
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.maxX;
                        }
                        else {
                            x_value = Math.max(shape.maxX, x_value);
                        }

                    }
                    if (pos.x <= shape.maxX - delta &&
                      pos.y <= shape.maxY - delta &&
                      objectLocatedAt.bottomRight
                        ) {

                        if (x_value == pos.x) {
                            x_value = shape.maxX;
                        }
                        else {
                            x_value = Math.max(shape.maxX, x_value);
                        }

                    }
                }
            }

            return {
              x: x_value,
              y: y_value
            };

        });

    }

    that.definePathBoxSize(detail, that);
    // crop background image to suit shape box

    if (that.xiaDetail[i].options.indexOf("disable-click") == -1) {
        var cropCanvas = document.createElement('canvas');
        cropCanvas.setAttribute('width', parseFloat(detail.maxX) - parseFloat(detail.minX));
        cropCanvas.setAttribute('height', parseFloat(detail.maxY) - parseFloat(detail.minY));
        var cropCtx = cropCanvas.getContext('2d');
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
        var dataUrl = cropCanvas.toDataURL();
        var cropedImage = new Image();
        cropedImage.src = dataUrl;
        cropedImage.onload = function() {
            that.xiaDetail[i].backgroundImage = cropedImage;
            that.xiaDetail[i].kineticElement.backgroundImageOwnScaleX = 1;
            that.xiaDetail[i].kineticElement.backgroundImageOwnScaleY = 1;            
            that.xiaDetail[i].kineticElement.fillPatternRepeat('no-repeat');
            that.xiaDetail[i].kineticElement.fillPatternX(detail.minX);
            that.xiaDetail[i].kineticElement.fillPatternY(detail.minY);
        };
    }

    that.xiaDetail[i].persistent = "off";
    if ((typeof(detail.fill) !== 'undefined') && 
        (detail.fill === "#ffffff")) {
        that.xiaDetail[i].persistent = "onPath";
        that.xiaDetail[i].kineticElement.fill('rgba(' + iaScene.colorPersistent.red + ',' + iaScene.colorPersistent.green + ',' + iaScene.colorPersistent.blue + ',' + iaScene.colorPersistent.opacity + ')');
    }    
    that.addEventsManagement(i, that, iaScene, baseImage, idText);

    that.layer.add(that.xiaDetail[i].kineticElement);
    that.layer.draw();
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
 * Rescale box
 * @returns {undefined}
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
   
IaObject.prototype.addEventsManagement = function(i, that, iaScene, baseImage, idText) {

    var that=this;

    that.xiaDetail[i].kineticElement.tooltip_area = false;
    // tooltip must be at the bottom
    if ($('article[data-tooltip="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        that.xiaDetail[i].kineticElement.moveToBottom();
        that.xiaDetail[i].kineticElement.tooltip_area = true;
        that.xiaDetail[i].options += " disable-click ";
    }

    that.myhooks.afterXiaObjectCreation(iaScene, that.xiaDetail[i]);

    that.xiaDetail[i].kineticElement.on('mouseenter', function() {
        if (iaScene.cursorState.indexOf("ZoomOut.cur") !== -1) {

        }
        else if (iaScene.cursorState.indexOf("ZoomIn.cur") !== -1) {

        }
        else if (iaScene.cursorState.indexOf("HandPointer.cur") === -1) {
            if ((!this.getXiaParent().droparea) && (!this.tooltip_area)) {
                document.body.style.cursor = "pointer";
            }
            iaScene.cursorState = "url(img/HandPointer.cur),auto";
            // manage tooltips if present
            var tooltip = false;
            if (this.tooltip != "") {
                tooltip = true;
            }
            else if ($("#" + idText).data("tooltip") != "") {
                var tooltip_id = $("#" + idText).data("tooltip");
                this.tooltip = this.getStage().find("#" + tooltip_id)[0];
                tooltip = true;
            }
            if (tooltip) {
                this.tooltip.clearCache();
                this.tooltip.fillPriority('pattern');
                if ((this.tooltip.backgroundImageOwnScaleX != "undefined") && 
                        (this.tooltip.backgroundImageOwnScaleY != "undefined")) {
                    this.tooltip.fillPatternScaleX(this.tooltip.backgroundImageOwnScaleX * 1/iaScene.scale);
                    this.tooltip.fillPatternScaleY(this.tooltip.backgroundImageOwnScaleY * 1/iaScene.scale);
                }
                this.tooltip.fillPatternImage(this.tooltip.getXiaParent().backgroundImage); 

                this.tooltip.moveToTop();
                this.tooltip.draw();
                that.layer.draw();
            }
            
        }
    });
 
    /*
     * if we leave this element, just clear the scene
     */
    that.xiaDetail[i].kineticElement.on('mouseout', function() {
    
        
        if ((iaScene.cursorState.indexOf("ZoomOut.cur") !== -1) ||
                (iaScene.cursorState.indexOf("ZoomIn.cur") !== -1)){

        }
        else {
            var mouseXY = that.layer.getStage().getPointerPosition();
            if ((that.layer.getStage().getIntersection(mouseXY) != this)) {
                // manage tooltips if present
                var tooltip = false;
                if (this.tooltip != "") {
                    tooltip = true;
                }
                else if ($("#" + idText).data("tooltip") != "") {
                    var tooltip_id = $("#" + idText).data("tooltip");
                    this.tooltip = this.getStage().find("#" + tooltip_id)[0];
                    tooltip = true;
                }                
                if (tooltip) {
                    this.tooltip.fillPriority('color');
                    this.tooltip.fill('rgba(0, 0, 0, 0)');
                    this.tooltip.draw();
                }                
                document.body.style.cursor = "default";
                iaScene.cursorState = "default";
                that.layer.draw();						
            }
        }
    });       
    
    if (that.xiaDetail[i].options.indexOf("direct-link") != -1) {
        that.xiaDetail[i].kineticElement.on('click touchstart', function(e) {
            //location.href = that.title[i];
            location.href = that.xiaDetail[i].title;
        });
    }
    else if (that.xiaDetail[i].options.indexOf("disable-click") != -1) {
        return;
    }
    else {

        if (!that.xiaDetail[i].droparea) {
            that.xiaDetail[i].kineticElement.on('dragstart', function(e) {
                iaScene.element = that;
                that.afterDragStart(iaScene, idText, this);
                that.myhooks.afterDragStart(iaScene, idText, this);
                this.moveToTop();
                Kinetic.draggedshape = this;
            });

            that.xiaDetail[i].kineticElement.on('dragend', function(e) {
                iaScene.element = that;
                Kinetic.draggedshape = null;
                // Kinetic hacking - speed up _getIntersection (for linux)
                that.afterDragEnd(iaScene, idText, e, this);
                that.myhooks.afterDragEnd(iaScene, idText, this);
                this.getStage().completeImage = "redefine";
                that.layer.draw();
            });    
        }
    }

};

IaObject.prototype.afterDragStart = function(iaScene, idText, kineticElement) {

    $('#' + idText + " audio").each(function(){
        if ($(this).data("state") === "autostart") {
            $(this)[0].play();
        }
    });
};
/*
 *
 *
 */
IaObject.prototype.afterDragEnd = function(iaScene, idText, event, kineticElement) {
    //var target_id = $('#' + idText).data("target");
    var target_id = kineticElement.getXiaParent().target_id;
    var target_object = kineticElement.getStage().find("#" + target_id);
    var iaObject_width = this.maxX - this.minX;
    var iaObject_height = this.maxY - this.minY;
    this.minX = event.target.x();
    this.minY = event.target.y();
    this.maxX = event.target.x() + iaObject_width;
    this.maxY = event.target.y() + iaObject_height;
    var middle_coords = {x: event.target.x() + (this.maxX - this.minX)/2,y:event.target.y() + (this.maxY - this.minY)/2};

    //var mouseXY = kineticElement.getStage().getPointerPosition();
    //var droparea = kineticElement.getStage().getIntersection(mouseXY);
    var droparea = kineticElement.getStage().getIntersection(middle_coords);
    var over_droparea = false;
    if (droparea) {
        if (droparea == kineticElement) {
            // element dropped on its own area
            // move current element out of stage, redraw the scene,
            // find the drop zone element
            // and move current element to its original position
            var old_x = kineticElement.x();
            kineticElement.x(2000);
            kineticElement.getLayer().drawHit();
            kineticElement.getStage().completeImage = "redefine";
            //droparea = kineticElement.getStage().getIntersection(mouseXY);
            droparea = kineticElement.getStage().getIntersection(middle_coords);
            if (droparea) {
                if (droparea != kineticElement) {
                    over_droparea = true;
                }
            }
            kineticElement.x(old_x);
            kineticElement.getLayer().drawHit();
        }
        else if (droparea.getXiaParent().droparea) {
            over_droparea = true;
        }
    }

    if (over_droparea) {
        // retrieve kineticElement drop zone
        // if center of dropped element is located in the drop zone
        // then drop !
        //var target_object = this.xiaDetail[0].kineticElement.getStage().find("#" + target_id);
        var target_iaObject = droparea.getIaObject();
        if ((middle_coords.x > target_iaObject.minX) &
                (middle_coords.x < target_iaObject.maxX) &
                (middle_coords.y > target_iaObject.minY) &
                (middle_coords.y < target_iaObject.maxY)) {
            if (!this.match && droparea == target_object[0]) {
                this.match = true;
                iaScene.currentScore += 1;
            }
            if (iaScene.global_magnet_enabled || droparea.getXiaParent().magnet_state=="on") {
                kineticElement.x(target_iaObject.minX - (iaObject_width / 2) + (target_iaObject.maxX - target_iaObject.minX) / 2);
                kineticElement.y(target_iaObject.minY - (iaObject_height / 2) + (target_iaObject.maxY - target_iaObject.minY) / 2);
            }
        }
        else {
            if (this.match) {
                this.match = false;
                iaScene.currentScore -= 1;
            }
        }

        if (droparea.getXiaParent().options.indexOf("direct-link") != -1) {
            location.href = droparea.getXiaParent().title;
        }

        var viewportHeight = $(window).height();
        if ((iaScene.score == iaScene.currentScore) && (iaScene.score != 0)) {
            $("#content").show();
            $("#message_success").show();
            var general_border = $("#message_success").css("border-top-width").substr(0,$("#message_success").css("border-top-width").length - 2);
            var general_offset = $("#message_success").offset();
            var content_offset = $("#content").offset();
            $("#message_success").css({'max-height':(viewportHeight - general_offset.top - content_offset.top - 2 * general_border)});
        }
        $('#' + idText + " audio").each(function(){
            if ($(this).data("state") === "autostart") {
                $(this)[0].play();
            }
        });
    }
    else {
        if (this.match) {
            this.match = false;
            iaScene.currentScore -= 1;
        }
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

    // color used over background image during focus
    var _colorCache = {red:0, green:0, blue:0, opacity:0.6};
 
    // internal
    this.global_magnet_enabled = false;
    if ($("#message_success").data("magnet") == "on") {
        this.global_magnet_enabled = true;
    }
    this.score = 0;
    this.currentScore = 0;
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
    this.shapes = [];
}

/*
 * Scale entire scene
 *  
 */
IaScene.prototype.scaleScene = function(mainScene){
    "use strict";
    var viewportWidth = $(window).width();
    var viewportHeight = $(window).height();

    //if (viewportWidth > 1280) viewportWidth = 1280;
    
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
    
};

IaScene.prototype.mouseout = function(kineticElement) {
    
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
 */

function main(myhooks) {
    "use strict";

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
        }    });    
    
    Kinetic.draggedshape = null;
    
    //var that=window;
    var that=this;
    that.canvas = document.getElementById("canvas");

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
                myhooks: myhooks
            });
            mainScene.shapes.push(iaObj);
        }

        that.afterMainConstructor(mainScene, that.layers);
        myhooks.afterMainConstructor(mainScene, that.layers);             

        $("#loader").hide();

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
main.prototype.afterMainConstructor = function(mainScene, layers) {

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
        sha1Digest.update(entered_password.encode());
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


    mainScene.score = $("#message_success").data("score");
    if ((mainScene.score == mainScene.currentScore) && (mainScene.score != "0")) {
        $("#content").show();
        $("#message_success").show();
        var general_border = $("#message_success").css("border-top-width").substr(0,$("#message_success").css("border-top-width").length - 2);
        var general_offset = $("#message_success").offset();
        var content_offset = $("#content").offset();
        $("#message_success").css({
            'max-height':(viewportHeight - general_offset.top - content_offset.top - 2 * general_border)
        });
    }

    $(".overlay").hide();

    $(".infos").on("click", function(){
        $("#rights").show();
        $("#popup").show();
        $("#popup_intro").hide();
    });
    $("#popup_close").on("click", function(){
        $("#rights").hide();
    });
    $("#popup_toggle").on("click", function(){
        $("#message_success_content").toggle();
        if ($(this).attr('src') == 'img/hide.png') {
            $(this).attr('src', 'img/show.png');
        }
        else {
            $(this).attr('src', 'img/hide.png');
        }
    });
};

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
    
    this.title = detail.title;
    this.path = "";
    this.kineticElement = null;
    this.persistent = "";
    this.options = "";
    this.backgroundImage = null;
    this.tooltip = null;
    this.draggable_object = true;
    this.target_id = null;
    this.magnet_state = null;
    this.droparea = false;
    this.idText = idText;
    
    if ((typeof(detail.options) !== 'undefined')) {
        this.options = detail.options;
    }
    
    if (this.options.indexOf("disable-click") != -1) {
        this.draggable_object = false;
    };  
    if ($('article[data-target="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        this.draggable_object = false;
    }    
    if ($('article[data-tooltip="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        this.draggable_object = false;
    }  
    
    this.target_id = $('#' + idText).data("target");
    this.magnet_state = $("#" + idText).data("magnet");

    if ($('article[data-target="' + $("#" + idText).data("kinetic_id") + '"]').length != 0) {
        this.droparea = true;
        
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
