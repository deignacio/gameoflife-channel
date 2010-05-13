package com.litl.gameoflife {
    public class Model {
        private var _rows:Number;
        private var _cols:Number;
        private var _generation:Number;
        private var _totalSize:Number;
        private var _currentGen:Vector.<Boolean>;
        private var _neighborCount:Vector.<int>;
        private var _tmpGen:Vector.<Boolean>;
        private var _tmpNeighborCount:Vector.<int>;
        private var _isAlive:Boolean;

        public function Model() {
            initialize();
        }

        public function initialize():void {
            _rows = 0;
            _cols = 0;
            resize(45, 80);
        }

        public function resize(rows:int, cols:int):void {
            if (_rows != rows || _cols != cols) {
                _rows = rows;
                _cols = cols;
                _totalSize = _rows * _cols;
                _currentGen = new Vector.<Boolean>(_totalSize);
                _neighborCount = new Vector.<int>(_totalSize);
                _isAlive = true;
                reseed();
            }
        }

        public function get rows():Number {
            return _rows;
        }

        public function get cols():Number {
            return _cols;
        }

        public function reseed():void {
            _generation = 0;
            var initialPopulation:uint = _totalSize * randomNumber(33, 100) / 100;
            var newInitial:int;
            for (var i:int = 0; i < initialPopulation; i++) {
                newInitial = randomNumber(0, _totalSize-1);
                _currentGen[newInitial] = true;
                updateNeighbors(newInitial, _neighborCount);
            }
        }

        public function get generation():Number {
            return _generation;
        }

        public function get currentGen():Vector.<Boolean> {
            return _currentGen;
        }

        public function get neighborCount():Vector.<int> {
            return _neighborCount;
        }

        public function increment():void {
            _tmpGen = new Vector.<Boolean>(_totalSize);
            _tmpNeighborCount = new Vector.<int>(_totalSize);
            _generation ++;
            var alive:Boolean;
            for (var i:int = 0; i < _totalSize; i++) {
                if (shouldLive(i)) {
                    _tmpGen[i] = true;
                    updateNeighbors(i, _tmpNeighborCount);
                }
            }
            _currentGen = _tmpGen;
            _neighborCount = _tmpNeighborCount;
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

        private function updateNeighbors(index:int, neighborCount:Vector.<int>):void {
            var neighbors:Array = [ _totalSize + index - _cols - 1, _totalSize + index - _cols, _totalSize + index - _cols + 1,
                                    _totalSize + index - 1, _totalSize + index + 1,
                                    _totalSize + index + _cols - 1, _totalSize + index + _cols, _totalSize + index + _cols + 1 ];
            for (var i:int = 0; i < neighbors.length; i++) {
                neighborCount[neighbors[i] % _totalSize] += 1;
            }
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