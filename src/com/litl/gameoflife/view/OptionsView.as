package com.litl.gameoflife.view {
    import com.litl.control.TextButton;

    import com.litl.gameoflife.GraphicsUtils;
    import com.litl.gameoflife.Model;

    import com.litl.sdk.service.LitlService;

    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class OptionsView extends Sprite {
        private var _height:int;
        private var _width:int;
        private var _shape:Shape;
        private var _model:Model;
        private var _graphicsUtils:GraphicsUtils;
        private var _closeButton:TextButton;
        private var _service:LitlService;

        public function OptionsView(model:Model, utils:GraphicsUtils, service:LitlService) {
            super();
            height = 450;
            width = 450;

            _model = model;
            _graphicsUtils = utils;
            _service = service;

            _shape = new Shape();
            _shape.graphics.beginFill(0x000000);
            _shape.graphics.drawRect(0, 0, width, height);
            _shape.graphics.endFill();
            _shape.x = 10;
            _shape.y = 10;
            addChild(_shape);

            _closeButton = new TextButton();
            _closeButton.text = "close";
            _closeButton.move(400, 425);
            _closeButton.styleName = ".mainButton";
            _closeButton.addEventListener(MouseEvent.CLICK, onCloseClicked);
            addChild(_closeButton);
        }

        public function onCloseClicked(e:MouseEvent):void {
            _service.closeOptions();
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

        public function get model():Model {
            return _model;
        }
    }
}
