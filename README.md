# Brochure

Brochure is an app which will show all the articles of the given webservice i have used
http://www.json-generator.com/api/json/get/bYKqOKXiEO according to it i have designed my core data which we can change later on i have assumed that paging count of 35 (35 articles per page). 
I have used two third party one is sdwebimage for image caching and loading and other is Mb progress hud for showing loading icon.
I have used MVC architecture, loading on the main thread so that user can't scroll untill data is loading which could have been on 
background thread but nothing was specified in the documentation. The table view shows article titles and collection view shows you the
image of the article and in settings you can change the font using the stepper. There is a detail view in which you can view the whole
article text and image of the article which on tap be hidden when you touch it and the text information will fill the view. The articles 
are sorted alphabetically according to the title. You can delete the article from detail view which i missed for list view . The application
uses core data for caching, storyboard for UI and you can view the app in any mode. Pagination is being done so that if we have large
data. Apart from this i have also implemented a scaling function for image.
