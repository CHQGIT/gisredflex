package widgets.GoogleAnalytics.events
{
	import flash.events.Event;
	/**
	 * GoogleAnalyticsWidgetEvent is used to let GoogleAnalyticsWidget know
	 * to log a page view to Google Analytics.
	 * Requires a string parameter of the Page name
	 *
	 * <p>To log when the search button is clicked on myWidget example:</p>
	 *
	 * <listing>
	 *   dispatchEvent(new GoogleAnalyticsWidgetEvent(
	 * 		GoogleAnalyticsWidgetEvent.LOG_PAGE, "myWidgetSearchButton"));
	 * </listing>
	 *
	 * <p>GoogleAnalyticsWidget listens for this event is, for example:</p>
	 * <listing>
	 *   systemManager.addEventListener(GoogleAnalyticsWidgetEvent.LOG_PAGE, logPageHandler);								
	 * </listing>
	 *
	 */
	public class GoogleAnalyticsWidgetEvent extends Event
	{
		public static const LOG_PAGE:String = "gaWidgetLogPage";
		
		public var pageName:String;
		
		public function GoogleAnalyticsWidgetEvent(type:String, pageName:String)
		{
			super(type, true);
			this.pageName = pageName;
		}
	}
}