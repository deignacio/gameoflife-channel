package com.litl.gameoflife {
    import com.litl.gameoflife.Model;

    import flash.display.Shape;

    public class GraphicsUtils {
        public static const DIMMED_BACKGROUND_ALPHA:Number = 0.75;

        private var _height:int;
        private var _width:int;
        private var _rows:int;
        private var _cols:int;
        private var _colSize:int;
        private var _rowSize:int;
        private var _bgColor:uint;
        private var _colors:Array;
        private var _model:Model;

        public function GraphicsUtils(model:Model) {
            _bgColor = 0xffffff;
            _colors = [ 0xdbdbdb, 0xc8dadb, 0xa3d8db,
                        0x9AD7DB, 0x76d5db, 0x56d3db,
                        0x2cd0db, 0x00cedb, 0x00cedb ];

            _model = model;

            _rows = _model.size;
            _cols = _model.size;
        }

        public function makeDimmer(height:int, width:int):Shape {
            var dimmer:Shape = new Shape();
            dimmer.graphics.beginFill(0x000000, DIMMED_BACKGROUND_ALPHA);
            dimmer.graphics.drawRect(0, 0, width, height);
            dimmer.graphics.endFill();

            return dimmer;
        }

        public function makeRect(height:int, width:int):Shape {
            if (_height != height) {
                _height = height;
                _rowSize = _height / _rows;
            }

            if (_width != width) {
                _width = width;
                _colSize = _width / _cols;
            }

            var rect:Shape = new Shape();
            rect.graphics.beginFill(_bgColor);
            rect.graphics.drawRect(0, 0, width, height);
            rect.graphics.endFill();
            var x:Number = 0;
            var y:Number = 0;
            for (var i:Number = 0; i < _model.currentGen.length; i++) {
                if (_model.currentGen[i]) {
                    drawRect(rect, y, x, _colors[_model.neighborCount[i]]);
                }

                x++;
                if (x % _cols == 0) {
                    y++;
                    x = 0;
                }
            }
            return rect;
        }

        private function drawRect(shape:Shape, row:int, col:int, color:uint):void {
            shape.graphics.beginFill(color);
            shape.graphics.drawRect(col * _colSize, row * _rowSize, _colSize, _rowSize);
            shape.graphics.endFill();
        }
    }
}
