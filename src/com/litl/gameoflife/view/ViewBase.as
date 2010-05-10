package com.litl.gameoflife.view {
    import com.litl.gameoflife.GraphicsUtils;
    import com.litl.gameoflife.Model;

    import flash.display.Shape;
    import flash.display.Sprite;

    public class ViewBase extends Sprite {
        private var _width:Number;
        private var _height:Number;
        private var _model:Model;
        private var _graphicsUtils:GraphicsUtils;
        private var _shape:Shape;
        private var _dimmer:Shape;

        public function ViewBase(model:Model, utils:GraphicsUtils) {
            super();
            _model = model;
            _graphicsUtils = utils;
            drawModel();
        }

        public function get utils():GraphicsUtils {
            return _graphicsUtils;
        }

        public function get model():Model {
            return _model;
        }

        override public function get height():Number {
            return _height;
        }

        override public function set height(value:Number):void {
            _height = value;
        }

        override public function get width():Number {
            return _width;
        }

        override public function set width(value:Number):void {
            _width = value;
        }

        public function setSize(newWidth:Number, newHeight:Number):void {
            width = newWidth;
            height = newHeight;

            sizeUpdated();
        }

        protected function sizeUpdated():void {
            drawModel();
        }

        public function drawModel():void {
            if (_shape) {
                removeChild(_shape);
            }

            _shape = _graphicsUtils.makeRect(height, width);
            addChild(_shape);
        }

        public function dim():void {
            if (_dimmer == null) {
                _dimmer = _graphicsUtils.makeDimmer(height, width);
            }

            addChild(_dimmer);
        }

        public function undim():void {
            if (_dimmer) {
                removeChild(_dimmer);
            }
        }
    }
}
