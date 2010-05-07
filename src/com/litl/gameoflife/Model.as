package com.litl.gameoflife {
    public class Model {
        private var _generation:Number;
        private var _size:Number;
        private var _totalSize:Number;
        private var _currentGen:Array;
        private var _tmpGen:Array;
        private var _isAlive:Boolean;

        public function Model() {
            initialize();
        }

        public function initialize():void {
            _size = 50;
            _totalSize = _size * _size;
            _currentGen = new Array(_totalSize);
            _isAlive = true;
            reseed();
        }

        public function reseed():void {
            _generation = 0;
            var initialPopulation:uint = _totalSize * randomNumber(0, 100) / 100;
            var newInitial:int;
            for (var i:int = 0; i < initialPopulation; i++) {
                newInitial = randomNumber(0, _totalSize-1);
                _currentGen[newInitial] = 1;
            }
        }

        public function get generation():Number {
            return _generation;
        }

        public function get currentGen():Array {
            return _currentGen;
        }

        public function increment():void {
            _tmpGen = new Array(_totalSize);

            _generation ++;

            for (var i:int = 0; i < _totalSize; i++) {
                _tmpGen[i] = shouldLive(i);
            }
            _currentGen = _tmpGen;
        }

        public function get size():Number {
            return _size;
        }

        public function get isAlive():Boolean {
            return _isAlive;
        }

        private function shouldLive(index:Number):uint {
            var neighbors:Array = [
                                   _totalSize + index - _size - 1, _totalSize + index - _size, _totalSize + index - _size + 1,
                                   _totalSize + index - 1, _totalSize + index + 1,
                                   _totalSize + index + _size - 1, _totalSize + index + _size, _totalSize + index + _size + 1 ]
            var aliveNeighbors:int = 0;
            for (var i:int = 0; i < neighbors.length; i++) {
                aliveNeighbors += _currentGen[neighbors[i] % _totalSize];
            }

            if (aliveNeighbors == 3 ||
                (aliveNeighbors == 2 && _currentGen[index])) {
                return 1;
            }
            return 0;
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