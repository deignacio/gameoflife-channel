package com.litl.gameoflife {
    public class Model {
        private var _rows:Number;
        private var _cols:Number;
        private var _generation:Number;
        private var _totalSize:Number;
        private var _currentGen:Array;
        private var _neighborCount:Array;
        private var _tmpGen:Array;
        private var _isAlive:Boolean;

        public function Model() {
            initialize();
        }

        public function initialize():void {
            _rows = 45;
            _cols = 80;
            resize();
        }

        private function resize():void {
            _totalSize = _rows * _cols;
            _currentGen = new Array(_totalSize);
            _neighborCount = new Array(_totalSize);
            _isAlive = true;
            reseed();
        }

        public function get rows():Number {
            return _rows;
        }

        public function set rows(value:Number):void {
            if (value != _rows) {
                _rows = value;
                resize();
            }
        }

        public function get cols():Number {
            return _cols;
        }

        public function set cols(value:Number):void {
            if (value != _cols) {
                _cols = value;
                resize();
            }
        }

        public function reseed():void {
            _generation = 0;
            var initialPopulation:uint = _totalSize * randomNumber(33, 100) / 100;
            var newInitial:int;
            for (var i:int = 0; i < initialPopulation; i++) {
                newInitial = randomNumber(0, _totalSize-1);
                _currentGen[newInitial] = 1;
            }

            var count:int;
            for (var j:int = 0; j < _totalSize; j++) {
                count = countNeighbors(j);
                _neighborCount[j] = count;
            }
        }

        public function get generation():Number {
            return _generation;
        }

        public function get currentGen():Array {
            return _currentGen;
        }

        public function get neighborCount():Array {
            return _neighborCount;
        }

        public function increment():void {
            _tmpGen = new Array(_totalSize);

            _generation ++;

            for (var i:int = 0; i < _totalSize; i++) {
                _tmpGen[i] = shouldLive(i);
            }
            _currentGen = _tmpGen;

            var count:int;
            for (var j:int = 0; j < _totalSize; j++) {
                count = countNeighbors(j);
                _neighborCount[j] = count;
            }
        }

        public function get isAlive():Boolean {
            return _isAlive;
        }

        private function shouldLive(index:int):int {
            var neighborCount:int = _neighborCount[index];
            if (neighborCount == 3 ||
                (neighborCount == 2 && _currentGen[index])) {
                return 1;
            }
            return 0;
        }

        private function countNeighbors(index:int):int {
            var neighbors:Array = [
                                   _totalSize + index - _cols - 1, _totalSize + index - _cols, _totalSize + index - _cols + 1,
                                   _totalSize + index - 1, _totalSize + index + 1,
                                   _totalSize + index + _cols - 1, _totalSize + index + _cols, _totalSize + index + _cols + 1 ]
            var aliveNeighbors:int = 0;
            for (var i:int = 0; i < neighbors.length; i++) {
                aliveNeighbors += _currentGen[neighbors[i] % _totalSize];
            }
            return aliveNeighbors;
        }

        private function randomNumber(low:Number=NaN, high:Number=NaN):Number {
            var low:Number = low;
            var high:Number = high;

            if (isNaN(low)) {
                throw new Error("low must be defined");
            }
            if (isNaN(high)) {
                throw new Error("high must be defined");
            }

            return Math.round(Math.random() * (high - low)) + low;
        }
    }
}