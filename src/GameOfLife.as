package {
import com.adobe.images.PNGEncoder;
import com.litl.gameoflife.GraphicsUtils;
    import com.litl.gameoflife.Model;
    import com.litl.gameoflife.view.OptionsView;
    import com.litl.gameoflife.view.ViewBase;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.enum.ViewDetails;
    import com.litl.sdk.message.*;
    import com.litl.sdk.service.LitlService;

import flash.display.BitmapData;
import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    [SWF(backgroundColor="0", width="1280", height="800", frameRate="21")]
        public class GameOfLife extends Sprite {
            protected var service:LitlService;
            protected var currentView:ViewBase;
            protected var views:Dictionary;
            protected var model:Model;
            protected var utils:GraphicsUtils;
            private var _gameTimer:Timer;
            private var _timerLength:Number;
            private var _optionsView:OptionsView;
            private var _img:BitmapData;

            private var _saveTimer:Timer;

            public function GameOfLife() {

                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.align = StageAlign.TOP_LEFT;

                initialize();
            }

            protected function initialize():void {
                model = new Model();
                utils = new GraphicsUtils(model);
                _timerLength = 250;
                _gameTimer = new Timer(_timerLength);
                _gameTimer.addEventListener("timer", onTimer);
                _saveTimer = new Timer(1000 * 30);
                _saveTimer.addEventListener("timer", onSaveTimer);

                service = new LitlService(this);
                service.connect("gameoflife", "Game of Life", "1.0", true);

                service.addEventListener(InitializeMessage.INITIALIZE, handleInitialize);
                service.addEventListener(PropertyMessage.PROPERTY_CHANGED, handlePropertyChanged);
                service.addEventListener(OptionsStatusMessage.OPTIONS_STATUS, handleOptionsStatus);
                service.addEventListener(UserInputMessage.GO_BUTTON_PRESSED, handleGoPressed);
                service.addEventListener(UserInputMessage.GO_BUTTON_HELD, handleGoHeld);
                service.addEventListener(UserInputMessage.GO_BUTTON_RELEASED, handleGoReleased);
                service.addEventListener(ViewChangeMessage.VIEW_CHANGE, handleViewChange);
            }

            /**
             * Called when the device has sent all our saved properties, and is ready for us to begin.
             * @param e        The InitializeMessage instance.
             *
             */
            private function handleInitialize(e:InitializeMessage):void {
                service.channelTitle = "Game of Life";
                //service.channelIcon = "http://litl.com/cute.ico";
                service.channelItemCount = 1;

                _saveTimer.start();
            }

            /**
             * Called when the device has changed views. From focus to card view, for instance.
             * @param e        The ViewChangeMessage instance.
             *
             */
            private function handleViewChange(e:ViewChangeMessage):void {
                // When the device sends us a ViewChangeMessage, we should change our content
                // to match the new view.
                var newView:String = e.view;
                var newDetails:String = e.details;
                var viewWidth:Number = e.width;
                var viewHeight:Number = e.height;
                setView(newView, newDetails, viewWidth, viewHeight);
            }

            private function handlePropertyChanged(e:PropertyMessage):void {

            }

            private function handleOptionsStatus(e:OptionsStatusMessage):void {
                if (e.optionsOpen) {
                    showOptions();
                } else {
                    hideOptions();
                }
            }

            private function showOptions():void {
                if (_optionsView == null || !contains(_optionsView)) {
                    gameStop();
                    _optionsView = new OptionsView(model, utils, service);
                    currentView.dim();
                    addChild(_optionsView);
                }
            }

            private function hideOptions():void {
                if (_optionsView != null && contains(_optionsView)) {
                    removeChild(_optionsView);
                    currentView.undim();
                    _optionsView = null;
                    gameStart();
                }
            }

            private function handleGoPressed(e:UserInputMessage):void {
                gameRestart();
            }

            private function handleGoHeld(e:UserInputMessage):void {

            }

            private function handleGoReleased(e:UserInputMessage):void {

            }

            public function gameStart():void {
                if (!_gameTimer.running) {
                    _gameTimer.start();
                }
            }

            private function gameStep():void {
                model.increment();
                currentView.drawModel();
            }

            public function gameStop():void {
                if (_gameTimer.running) {
                    _gameTimer.stop();
                }
            }

            public function gameRestart():void {
                gameStop();
                model.reseed();
                gameStart();
            }

            public function onTimer(event:TimerEvent):void {
                if (model.generation == 60 * 1000 / _timerLength) {
                    gameRestart();
                }
                gameStep();
            }

            /**
             * Set the current view. Create the view if it doesn't exist, and switch to it.
             * @param newView                The view constant.
             * @param newDetails        The view details.
             * @see com.litl.sdk.enum.View
             */
            public function setView(newView:String, newDetails:String, viewWidth:Number = 0, viewHeight:Number = 0):void {
                trace("Setting view: " + newView + " " + newDetails + " (" + viewWidth + ", " + viewHeight + ")");

                // Remove the current view from the display list.
                if (currentView && contains(currentView)) {
                    removeChild(currentView);
                }

                if (views == null)
                    views = new Dictionary(false);

                currentView = views[newView];

                if (currentView == null)
                    currentView = new ViewBase(model, utils);

                views[newView] = currentView;

                currentView.setSize(viewWidth, viewHeight);

                if (!contains(currentView))
                    addChild(currentView);

                if (newDetails == ViewDetails.OFFSCREEN) {
                    // Optionally do something to "disable" the channel here, when the channel is offscreen for instance.
                    //
                    gameStop();
                } else {
                    gameStart();
                }
            }

            protected function onSaveTimer(e:TimerEvent):void {
                trace("starting to save shapes.  "+new Date());
                if (!_img) {
                    _img = new BitmapData(300, 180, false, 0x00000000);
                }
                var timer:Timer = new Timer(500, 10);
                timer.addEventListener(TimerEvent.TIMER, saveView);
                timer.addEventListener(TimerEvent.TIMER_COMPLETE, onSaveViewDone);
                timer.start();
            }

        private function saveView(e:TimerEvent):void {
            _img.draw(currentView);
            var bytes:ByteArray = _img.getPixels(new Rectangle(0, 0, 300, 180));
            bytes.compress();
            service.channelIcon = bytes.toString();
            trace("byte array length:  "+bytes.length);
        }

        private function onSaveViewDone(e:TimerEvent):void {
                trace("done saving shapes.  "+new Date());
        }

        }
}
