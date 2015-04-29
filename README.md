## Scoops Newspaper ##

##### Description #####
This is an iOS app for managing news, which will be so-called "scoops" from now on. There will be two roles: 

* On one hand, an author will be able to write his/her own news. A login from FB connect will be required for that purpose. A request will be sent to Azure, that will ask for some user's public data from the FB's graph API. A scoop will contain a title, some text, the name of the author and a picture. The author can select the desired date for the scoop's publication. Once logged in, an author will see his/her scoops grouped by two sections: scoops in review and scoops already published. He/she will be able to see each scoop in a detailed view.
* On the other hand, all the scoops already published will be available for the rest of users of the app. These users can see the scoops without logging and will be able to rate them in the scoop's detailed view. Every time a scoop is rated by a user, a push notification will be sent to its author by using Azure's mobile service.