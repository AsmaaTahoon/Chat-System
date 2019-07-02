# ChatSystem

simple chat system which have an API endpoints

#### Running the Application with Docker
1. At root directory run ``docker-compose up``

#### Documentation
1- main url of the app is ``localhost:3000``
2. create application endpoint  POST ``/applications`` with body ``{"name": "test1"}``
3. create chat endpoint POST ``/chats`` with body ``{"application_token": "APPLICATION_TOKEN"}``
4. create message endpoint POST ``/messages`` with body ``{"chat_number": "CHAT_NUMBER", ""application_token": "APPLICATION_TOKEN", "body": "MESSAGE_BODY"}``
5. get application chats GET ``/applications/{APPLICATION_TOKEN}/chats``
6. get application chat messages chats GET ``/applications/{APPLICATION_TOKEN}/chats/{CHAT_NUMBER}``
5. search message body chats POST ``/messages/search`` with body ``{"chat_number": "CHAT_NUMBER", ""application_token": "APPLICATION_TOKEN"}``
