///////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010-2011 Esri. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
///////////////////////////////////////////////////////////////////////////
package widgets.eLayerList.toc.tocClasses
{

    import com.esri.ags.layers.FeatureLayer;
    import com.esri.ags.layers.GeoRSSLayer;
    import com.esri.ags.layers.KMLLayer;
    import com.esri.ags.layers.Layer;
    import com.esri.ags.layers.TiledMapServiceLayer;
    import com.esri.ags.layers.supportClasses.LegendItemInfo;
    import com.esri.viewer.AppEvent;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.controls.treeClasses.TreeItemRenderer;
    import mx.controls.treeClasses.TreeListData;
    import mx.core.FlexGlobals;
    import mx.core.UIComponent;
    
    import spark.components.Group;
    import spark.components.Image;
    import spark.primitives.BitmapImage;
    
    import widgets.eLayerList.toc.TOC;
    import widgets.eLayerList.toc.controls.CheckBoxScaleDependant;
    import widgets.eLayerList.toc.tocClasses.TocItem;
    import widgets.eLayerList.toc.tocClasses.TocLayerMenu;
    import widgets.eLayerList.toc.tocClasses.TocMapLayerItem;

    /**
     * A custom tree item renderer for a map Table of Contents.
     *
     * @private
     */
    public class TocItemRenderer extends TreeItemRenderer
    {
    
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
    
        // Renderer UI components
        private var _checkbox:CheckBoxScaleDependant;
    
        // UI component spacing
        private static const PRE_CHECKBOX_GAP:Number = 5;
    
        private static const POST_CHECKBOX_GAP:Number = 4;
    
        private static const LEGEND_SWATCH_SIZE:Number = 24;
    
        private var _tocLayerMenu:TocLayerMenu;
    
        [Embed(source="assets/images/Context_menu11.png")]
        [Bindable]
        public var contextCls:Class;
    
        private var _layerMenuImage:Image;
        private var _legendSwatchContainer:Group;
        private var _toc:TOC;
    
        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------
    
        public function TocItemRenderer()
        {
            super();
    
            addEventListener(MouseEvent.CLICK, itemClickHandler);
        }
    
        //--------------------------------------------------------------------------
        //
        //  Overriden Properties
        //
        //--------------------------------------------------------------------------
    
        /**
         * @private
         */
        override public function set data(value:Object):void
        {
            super.data = value;
            
            if (value is TocLegendItem)
            {
                _legendSwatchContainer.removeAllElements();
                
                var legendItemInfo:LegendItemInfo = TocLegendItem(value).legendItemInfo;
                if (legendItemInfo.imageURL) // WMS
                {
                    var legendImg:BitmapImage = new BitmapImage();
                    legendImg.source = legendItemInfo.imageURL;
                    _legendSwatchContainer.addElement(legendImg);
                }
                else if (legendItemInfo.symbol)
                {
                    var swatch:UIComponent = legendItemInfo.symbol.createSwatch(LEGEND_SWATCH_SIZE, LEGEND_SWATCH_SIZE);
                    if (swatch)
                    {
                        _legendSwatchContainer.addElement(swatch);
                    }
                }
            }
        }
    
        //--------------------------------------------------------------------------
        //
        //  Overriden Methods
        //
        //--------------------------------------------------------------------------
    
        /**
         * @private
         */
        override protected function createChildren():void
        {
            super.createChildren();
    
            // Create a checkbox child component for toggling layer visibility.
            if (!_checkbox)
            {
                _checkbox = new CheckBoxScaleDependant();
                _checkbox.addEventListener(MouseEvent.CLICK, onCheckBoxClick);
                _checkbox.addEventListener(MouseEvent.DOUBLE_CLICK, onCheckBoxDoubleClick);
                _checkbox.addEventListener(MouseEvent.MOUSE_DOWN, onCheckBoxMouseDown);
                _checkbox.addEventListener(MouseEvent.MOUSE_UP, onCheckBoxMouseUp);
                addChild(_checkbox);
            }
    
            if (!_layerMenuImage)
            {
                _layerMenuImage = new Image();
                _layerMenuImage.source = contextCls;
                _layerMenuImage.height = 11;
                _layerMenuImage.width = 11;
                _layerMenuImage.setStyle("verticalAlign", "middle");
                _layerMenuImage.buttonMode = true;
                addChild(_layerMenuImage);
                this._layerMenuImage.addEventListener(MouseEvent.CLICK, onLayerMenuImageClick);
                this._layerMenuImage.addEventListener(MouseEvent.DOUBLE_CLICK, onLayerMenuImageDoubleClick);
            }
    
            if (!_legendSwatchContainer)
            {
                _legendSwatchContainer = new Group();
                addChild(_legendSwatchContainer);
            }
        }
    
        /**
         * @private
         */
        override protected function commitProperties():void
        {
            super.commitProperties();
    
            if (data is TocItem)
            {
                var item:TocItem = TocItem(data);
                
    
                // Set the checkbox state
                _checkbox.scaledependant = !item.isInScaleRange;
                _checkbox.selected = item.visible;
    
                // Hide the checkbox for child items of tiled map services
                var checkboxVisible:Boolean = true;
                if (isTiledLayerChild(item) || (item is TocLegendItem))
                {
                    checkboxVisible = false;
                }
                _checkbox.visible = checkboxVisible;
                
                // Hide the checkbox for child items of kml layer map services
                if(!isTiledLayerChild(item) && (!item is TocLegendItem)){
                    _checkbox.visible = isKMLLayerChild(item) ? false : true;
                }
                //Hide the checkbox for child items of GeoRSS layer map services
                if(!isTiledLayerChild(item) && (!item is TocLegendItem) && !isKMLLayerChild(item)){
                    _checkbox.visible = isGeoRSSLayerChild(item) ? false : true;
                }
                // Hide the checkbox for child items of feature layer map services
                if(!isTiledLayerChild(item) && (!item is TocLegendItem) && !isKMLLayerChild(item) && !isGeoRSSLayerChild(item)){
                    _checkbox.visible = isFeatureLayerChild(item) ? false : true;
                }
    
                // show legend for TocLegendItem
                _legendSwatchContainer.visible = item is TocLegendItem;
    
                // hide the option button if this is not a layer
                if((isLayerItem(item) || hasLayerExtent(item)) && isMenuEmpty(item) == false){
                     _layerMenuImage.visible = true;
                }else{
                    _layerMenuImage.visible = false;
                }
                if(item){
                    if(item.ttooltip && item.ttooltip != "" && !TOC(parent.parent).UseESRIDesc){
                        _layerMenuImage.visible = true;
                    }
                    if(!item.isInScaleRange){
                        _layerMenuImage.visible = true;
                    }
                }
                if (item.isTopLevel())
                {
                    // Apply a bold label style to root nodes
                    setStyle("fontWeight", "bold");
                    //If it is the topmost then it should have a menu
                    _layerMenuImage.visible = true;
                }
                else
                {
                    setStyle("fontWeight", "normal");
                }
                if (item.isInScaleRange)
                {
                    label.alpha = 1;
                    setStyle("fontStyle", "normal");
                }
                else
                {
                    label.alpha = 0.5;
                    setStyle("fontStyle", "italic");
                }
            }
        }
        
        private function isMenuEmpty(item:Object):Boolean
        {
            var retVal:Boolean = true;
            var _layer:Layer;
            
            if (item is TocLayerInfoItem){
                if (item.layerExtent){
                    if(!item.disableZoomTo){
                        retVal = false;
                    }
                }
                if(!item.isInScaleRange){
                    retVal = false;
                }
                if (parent.parent is TOC){
                    _toc = TOC(parent.parent);
                    if (_toc.UseESRIDesc){
                        if(item is TocMapLayerItem){
                            _layer = TocMapLayerItem(item).layer;
                        }
                        if(_layer){
                            if(!(_layer is FeatureLayer && FeatureLayer(_layer).featureCollection)){
                                retVal = false;
                            }
                        }
                    }else if (item.ttooltip && item.ttooltip != ""){
                        retVal = false;
                    }
                }
            }else{
                retVal = false;
            }
            return retVal;
        }
    
        /**
         * @private
         */
        override protected function measure():void
        {
            super.measure();
    
            // Add space for the checkbox and gaps
            if (isNaN(explicitWidth) && !isNaN(measuredWidth))
            {
                var w:Number = measuredWidth;
                w += _checkbox.measuredWidth;
                w += _legendSwatchContainer.measuredWidth;
                w += _layerMenuImage.measuredWidth;
                w += 2 * (PRE_CHECKBOX_GAP + POST_CHECKBOX_GAP); // once for the checkbox and once for the option image
                measuredWidth = w;
            }
            /*if (isNaN(explicitHeight) && !isNaN(measuredHeight))
            {
                measuredHeight = LEGEND_SWATCH_SIZE;
            }*/
        }
    
        /**
         * @private
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            var startx:Number = data ? TreeListData(listData).indent : 0;
            if (icon)
            {
                startx = icon.x;
            }
            else if (disclosureIcon)
            {
                startx = disclosureIcon.x + disclosureIcon.width;
            }
            startx += PRE_CHECKBOX_GAP;
            
            if (_checkbox.visible)
            {
                // Position the checkbox between the disclosure icon and the item icon
                _checkbox.x = startx;
                _checkbox.setActualSize(_checkbox.measuredWidth, _checkbox.measuredHeight);
                _checkbox.y = (unscaledHeight - _checkbox.height) / 2;
                startx = _checkbox.x + _checkbox.width + POST_CHECKBOX_GAP;
            }
            else if (data is TocLegendItem)
            {
                startx += TocLegendItem(data).parent is TocMapLayerItem ? 0 : POST_CHECKBOX_GAP;
                _legendSwatchContainer.x = startx;
                _legendSwatchContainer.y = -(_legendSwatchContainer.height / 2);
                startx = _legendSwatchContainer.x + LEGEND_SWATCH_SIZE + POST_CHECKBOX_GAP;
            }
            
            if (icon)
            {
                icon.x = startx;
                startx = icon.x + icon.width;
            }
            
            label.x = startx;
            var layerMenuImageSpace:Number = POST_CHECKBOX_GAP + _layerMenuImage.width + PRE_CHECKBOX_GAP;
            
            label.setActualSize(unscaledWidth - startx - layerMenuImageSpace, measuredHeight);
            
            _layerMenuImage.x = startx + label.width + PRE_CHECKBOX_GAP;
            _layerMenuImage.y = (unscaledHeight - _layerMenuImage.height) / 2;
        }
    
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
    
        private function onRemovalFromStage(event:AppEvent):void
        {
            hideLayerMenu();
        }
        
        private function hideLayerMenu():void
        {
            if (_tocLayerMenu)
            {
                // need to show/hide pop-up with information.
                AppEvent.removeListener(AppEvent.TOC_HIDDEN, onRemovalFromStage);
                systemManager.removeEventListener(Event.RESIZE, systemManager_resizeHandler);
                _tocLayerMenu.remove();
                _tocLayerMenu = null;
            }
        }
    
        private function onLayerMenuImageClick(event:MouseEvent):void
        {
            event.stopPropagation();
    
            // need to show/hide pop-up with information.
            //AppEvent.removeListener(AppEvent.TOC_HIDDEN, onRemovalFromStage);
    
            if (_tocLayerMenu && _tocLayerMenu.isPopUp)
            {
                hideLayerMenu();
            }
            else
            {
                // let any other popups know a popup is about to be created and opened
                AppEvent.dispatch(AppEvent.LAUNCHING_TOC_LAYER_MENU);
                _tocLayerMenu = new TocLayerMenu();
                var originPoint:Point = new Point(this.x + this.width, this.label.y + this.height);
                var globalPoint:Point = localToGlobal(originPoint);
                _tocLayerMenu.popUpForItem(this.parent.parent, data, TOC(this.parent.parent).map, globalPoint.x, globalPoint.y);
                if (FlexGlobals.topLevelApplication.layoutDirection != "rtl") // fix for RTL
                {
                    _tocLayerMenu.validateNow();
                    _tocLayerMenu.x -= _tocLayerMenu.width;
                }
                
                AppEvent.addListener(AppEvent.TOC_HIDDEN, onRemovalFromStage);
                systemManager.addEventListener(Event.RESIZE, systemManager_resizeHandler, false, 0, true);
            }
        }
        
        private function systemManager_resizeHandler(event:Event):void
        {
            if (_tocLayerMenu && _tocLayerMenu.isPopUp)
            {
                var originPoint:Point = new Point(this.x + this.width, this.label.y + this.height);
                var globalPoint:Point = localToGlobal(originPoint);
                if (FlexGlobals.topLevelApplication.layoutDirection != "rtl") // fix for RTL
                {
                    globalPoint.x -= _tocLayerMenu.width;
                }
                _tocLayerMenu.positionAt(globalPoint.x, globalPoint.y);
            }
        }
    
        private function onLayerMenuImageDoubleClick(event:MouseEvent):void
        {
            event.stopPropagation();
        }
        
        
        /**
         * Whether the specified TOC item is a child of a kml Layer map service layer.
         */
        private function isKMLLayerChild(item:TocItem):Boolean
        {
            while (item){
                item = item.parent;
                if (item is TocMapLayerItem){
                    if (TocMapLayerItem(item).layer is KMLLayer){
                        return true;
                    }
                }
            }
            return false;
        }
    
        /**
         * Whether the specified TOC item is a child of a tiled map service layer.
         */
        private function isTiledLayerChild(item:TocItem):Boolean
        {
            while (item)
            {
                item = item.parent;
                if (item is TocMapLayerItem)
                {
                    if (TocMapLayerItem(item).layer is TiledMapServiceLayer)
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        
        /**
         * Whether the specified TOC item is a child of a faeturelayer.
         */
        private function isFeatureLayerChild(item:TocItem):Boolean
        {
            while (item)
            {
                item = item.parent;
                if (item is TocMapLayerItem)
                {
                    if (TocMapLayerItem(item).layer is FeatureLayer)
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        
        /**
         * Whether the specified TOC item is a child of a GeoRSS Layer map service layer.
         */
        private function isGeoRSSLayerChild(item:TocItem):Boolean
        {
            while (item){
                item = item.parent;
                if (item is TocMapLayerItem){
                    if (TocMapLayerItem(item).layer is GeoRSSLayer){
                        return true;
                    }
                }
            }
            return false;
        }
    
        /**
         * Whether the specified TOC item is a child of a map service layer.
         */
        private function isLayerItem(item:TocItem):Boolean
        {
            if (item)
            {
                if (item is TocMapLayerItem)
                {
                    if (TocMapLayerItem(item).layer is Layer)
                    {
                        return true;
                    }
                }
            }
            return false;
        }
        
        /**
         * Whether the specified TOC item has a Layer Extent.
         */
        private function hasLayerExtent(item:TocItem):Boolean
        {
            if (item){
                if (item is TocLayerInfoItem){
                    if (TocLayerInfoItem(item).layerExtent.spatialReference){
                        return true;
                    }
                }
            }
            return false;
        }
    
        private function itemClickHandler(event:MouseEvent):void
        {
            AppEvent.dispatch(AppEvent.TOC_HIDDEN); // always hide the layer options popup
        }
    
        /**
         * Updates the visible property of the underlying TOC item.
         */
        private function onCheckBoxClick(event:MouseEvent):void
        {
            event.stopPropagation();
    
            if (data is TocItem)
            {
                var item:TocItem = TocItem(data);
                item.visible = _checkbox.selected;
            }
        }
    
        private function onCheckBoxDoubleClick(event:MouseEvent):void
        {
            event.stopPropagation();
        }
    
        private function onCheckBoxMouseDown(event:MouseEvent):void
        {
            event.stopPropagation();
        }
    
        private function onCheckBoxMouseUp(event:MouseEvent):void
        {
            event.stopPropagation();
            AppEvent.dispatch(AppEvent.TOC_HIDDEN); // always hide the layer options popup
        }
    }

}
