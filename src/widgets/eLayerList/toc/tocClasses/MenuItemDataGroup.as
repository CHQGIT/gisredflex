package widgets.eLayerList.toc.tocClasses
{
    import mx.core.ClassFactory;
    
    import spark.components.DataGroup;
    
    // these events bubble up from the MenuItemRenderer
    [Event(name="menuItemClick", type="flash.events.Event")]
    
    public class MenuItemDataGroup extends DataGroup
    {
        public function MenuItemDataGroup()
        {
            super();
            itemRenderer = new ClassFactory(widgets.eLayerList.toc.tocClasses.MenuItemRenderer);
        }
    }
}