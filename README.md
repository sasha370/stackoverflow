QnA Application (Question \ Answer). Analogue of Stackoverflow
=

###Used tools:
- TDD (349 examples)
- Ajax (JSON)
- ActiveStorage (Amazon S3)
- ActionCable (for new Question, Answer, Comment)
- Polymorphic associations( Comments, Links, Attachments)
- OAuth (Google, Github, VKontakte)
- CanCanCan
- REST API
- ActiveJob (Daily Digest by mail)
- ThinkingSphinx for search (All, by entities)
- Capistrano for deploy

__Guest can:__
> - View all questions
> - Search by parameters 

__User can:__
> As Author
> - Create a question 
> - Attach link(Gists link convert to image), files
> - Give an award for the best answer

> As User
> - Add answer or comment for all entities
> - Vote for favorite answer question
> - Subscribe to update question
> - Search by parameters 
> - Authenticate with Oauth services

####GitHub:
https://github.com/sasha370/stackoverflow

####Deploy
http://88.214.237.55/


```
Test users:
- test1@test.ru   123456
- test2@test.ru   123456
- admin@admin.ru  123456
```

Total work time: ~225 hour
