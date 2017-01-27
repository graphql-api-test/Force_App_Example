global with sharing class News_Feed_Controller {
    global News_Feed_Controller(){}
    //Remote action tag is used to indicate that the function will be called at runtime, something similar to AJAX
    //Remote action should be global, not public/private
	@RemoteAction
    global static boolean createNewsFeed(String author, String title, String description, String publishedAt, String url, String urlToImage) {
		News_Feed__c feed = new News_Feed__c();
        feed.Author__c = author;
        feed.Description__c = description;
        feed.Title__c = title;
        if(!publishedAt.equals('')) feed.Published_At__c = Datetime.valueOfGmt(publishedAt);
        feed.Url__c = url;
        feed.Url_To_Image__c = urlToImage;
        try{
            //As in the object model, title is set to unique, same news being inserted twice will result to an exception
            //Therefore wrap the insert statement in try-catch
            insert feed;
        }
        catch(Exception e){
            return false;
        }
        return true;
    }
    
    @RemoteAction
    global static boolean deleteNewsFeed(String Id) {
        News_Feed__c feed = new News_Feed__c();
        feed.Id = Id;
        delete feed;
        return true;
    }
    
    //To get 'something' from the visualforce page, the function name has to be prefixed by 'get'
    public List<News_Feed__c> getLatestNewsFeed(){
        //Square bracket is the indication of soql query insertion
        return [SELECT Id, Title__c, Url__c, Url_To_Image__c, Description__c FROM News_Feed__c ORDER BY Published_At__c DESC];
    }
}