# MarvelComics

MarvelComics demonstrates using the Marvel API to retrieve and display a list of comics, sorted by title.

Comics are loaded using the pagination feature of the Marvel API.  The comics are loaded in sets of 20. When the user scrolls down toward the end of the loaded list, the next set of comics is requested and they are appended to the collection view when they are received. This offers a seamless, ever scrolling experience to the user. 

When a comic cell is selected a detail comic view is presented. The detail comic view displays the comic thumbnail in the background, with the details displayed in semi-transparent overlay. Tapping the details view will collapse the details view to the botton, with only the title displayed. Tapping the title will expand the details view. 

The project is designed using the MVVM architectural pattern. The ComicsViewModel class represents the view model. Callers can access the formtted information by using its supplied getter functions. 

The Marvel API is accessed using the iOS nativie method. A data task is retrieved from URLSession.  The completion parses the JSON data into the model classes, using JSONDecoder. The data is saved to the view model. The delegate is notified when the model changes, by calling the delegate's didUpdateModel function . It also checks for errors and calls the delegate handleError function if an error has occured. 

This project attempts to improve user experience throught the use of motion through animations. 

Furture Improvements:

Adding a custom view transation when moving from the main view to the detail view would add interest by differing from the norm. 

Although a unit test suite has been started, future increases in code coverage should be undertaken.  

Requires iOS 15
