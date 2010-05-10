package {
    import com.litl.gameoflife.GraphicsUtils;
    import com.litl.gameoflife.Model;
    import com.litl.gameoflife.view.OptionsView;
    import com.litl.gameoflife.view.ViewBase;
    import com.litl.sdk.enum.View;
    import com.litl.sdk.enum.ViewDetails;
    import com.litl.sdk.enum.ViewSizes;
    import com.litl.sdk.message.*;
    import com.litl.sdk.service.LitlService;

    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
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

            public function GameOfLife() {

                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.align = StageAlign.TOP_LEFT;

                initialize();
            }

            protected function initialize():void {
                model = new Model();
                utils = new GraphicsUtils(model);
                _timerLength = 100;
                _gameTimer = new Timer(_timerLength);
                _gameTimer.addEventListener("timer", onTimer);

                service = new LitlService(this);
                service.connect("litl_gameoflife", "Game of Life", "1.0", true);

                service.addEventListener(InitializeMessage.INITIALIZE, handleInitialize);
                service.addEventListener(PropertyMessage.PROPERTY_CHANGED, handlePropertyChanged);
                service.addEventListener(OptionsStatusMessage.OPTIONS_STATUS, handleOptionsStatus);
                service.addEventListener(UserInputMessage.GO_BUTTON_PRESSED, handleGoPressed);
                service.addEventListener(UserInputMessage.GO_BUTTON_HELD, handleGoHeld);
                service.addEventListener(UserInputMessage.GO_BUTTON_RELEASED, handleGoReleased);
                service.addEventListener(UserInputMessage.WHEEL_NEXT_ITEM, handleWheelNext);
                service.addEventListener(UserInputMessage.WHEEL_PREVIOUS_ITEM, handleWheelPrevious);
                service.addEventListener(UserInputMessage.MOVE_NEXT_ITEM, handleMoveNext);
                service.addEventListener(UserInputMessage.MOVE_PREVIOUS_ITEM, handleMovePrevious);
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

            private function handleWheelNext(e:UserInputMessage):void {
            }

            private function handleWheelPrevious(e:UserInputMessage):void {
            }

            private function handleMoveNext(e:UserInputMessage):void {
            }

            private function handleMovePrevious(e:UserInputMessage):void {
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

                var newWidth:Number;
                var newHeight:Number;

                switch (newView) {
                default:
                    throw new Error("Unknown view state");
                    break;

                case View.CHANNEL:
                    if (currentView == null)
                        currentView = new ViewBase(model, utils);
                    newWidth = viewWidth > 0 ? viewWidth : ViewSizes.CHANNEL_WIDTH;
                    newHeight = viewHeight > 0 ? viewHeight : ViewSizes.CHANNEL_HEIGHT;
                    break;

                case View.FOCUS:
                    if (currentView == null)
                        currentView = new ViewBase(model, utils);
                    newWidth = viewWidth > 0 ? viewWidth : ViewSizes.FOCUS_WIDTH;
                    newHeight = viewHeight > 0 ? viewHeight : ViewSizes.FOCUS_HEIGHT;
                    break;

                case View.CARD:
                    if (currentView == null)
                        currentView = new ViewBase(model, utils);
                    newWidth = viewWidth > 0 ? viewWidth : ViewSizes.CARD_WIDTH;
                    newHeight = viewHeight > 0 ? viewHeight : ViewSizes.CARD_HEIGHT;
                    break;
                }

                views[newView] = currentView;

                currentView.setSize(newWidth, newHeight);

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
        }
}
