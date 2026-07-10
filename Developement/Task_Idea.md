- [ ] series of documenting system architecture (2): Document current cloudflare worker code, environment variables, secrets, d1 database, etc. Show what each worker does, environment variables, secrets, d1 database, etc. 
- [ ] series of documenting system architecture (3): Document current flutter code, state management, services, repositories, etc. Show what each service does, repository does, etc. 

- Simplifying/compacting users profile:
    - User card:
        - profile picture
        - name
        - username
        - Level name (instead of a number), e.g., "Newbie".
        - 

- habits on user's phone calendar: make possible to connect your calendar to the app to add tasks on the user's phone calendar. (or creating calendar subscription link iCal to subscribe and import on phone calendar)
    - Event title:
        - it could have dynamic titling based on user's progress; e.g. 
            simple motivational messages (dynamic based on user's progress) like "You got this!" for lower progress, and "Keep it up!" for higher progress. ( a set of motivational messages based on user's progress, in the database) 
        - if user has multiple habits per day: should it create multiple events, or one event with title showing the number of habits? 
    - Event description: 
        - simple and useful as user would have lots of events and long descriptions would be annoying. 
        - partner name
        - the current status of habit in number of days (current number of days / target number of days) (e.g., 3/5)

- Clarifying database:
    - Clarifying different roles of a user: user can have different roles on different habits:
        - habit creator (owner) 
            - can complete/skip the habit
            - can edit or delete it.
            - They can nudge participants
        - habit participant (partner)
            - can view the habit (list, details, etc.)
            - can't edit or delete it.
            - can complete/skip the habit
            - They can nudge the creator, and other participants.
        - Motivator / supporter:
            - can't complete/skip the habit
            - can view the habit (list, details, etc.)
            - They can nudge the creator, and other participants.
            - They can't edit or delete the habit.
            - can view the progress
            - can send support/encouragement/congratulatory messages
    - Relationship types:
        - one user can solely create a habit (sole creator).
        - user can be friends with another user. (mutual relationship) by sending or accepting a friend request.
        - user's can add their friends as a partner to acheiving habits. a user can be a partner for multiple friends, and each friend can have multiple partners.
        - friends can follow habits of their friends (for motivatio and support).
        - friends can nudge each other.
            - if they are partner or supporter
        - friends can see each other's profile (public user info), the user card.

- Leaderboard? maybe no need for now.
    - it could be based on streak (number of consecutive days of completing the habit), or number of completed habits, or percentage of completed habits. (with filtering by time: weekly, monthly, yearly)
    - availble between friends, not a global leaderboard for all users.

- Habit card info:
    - Habit title
    - Habit icon
    - Habit current streak
    - Habit target number of days
    - partner(s) user profile picture, name, and status (active/completed/skipped): (max 3 or 4 visible, and "..." if more) 
    - supporters profile picture: (max 3 or 4 visible, and "..." if more) 
    - status bar showing the progress of the habit: (current number of days / target number of days) a progress bar like a line like the bottom border of habit cards
    - the ring: the icon of the habit is inside this ring, and it's a solid color, like the border color of the card. (if the habit is completed, the ring is filled with the color of the border, if the habit is skipped, the ring is empty. if the habit is active, the ring is empty.) 
    

        
             

    

        
        
    
        
             

    

        
        
    