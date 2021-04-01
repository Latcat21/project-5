
#  The Recruiter
A Sinatra based application that helps college baseball teams and high school baseball players connect. This application creates a unique environment for players and coaches by identifying the needs of the college by position and allowing the players an opportunity to communicate with the college to meet that need. Key features include: in app messaging, ability to follow/unfollow users, integrated Google Places and Google Maps API.

# Active record Associations Used 
- Has many
- Has many using a through table (assosiation)
- Belongs too
- has one

# Stand out Queries
- Message.where("from_id = ?", session[:user_id])
- found_state = State.find_by({:id => @player.state_code})

# Cool Ruby methods used
- flat_map
- uniq
- any
- first

# Basic Ruby Methods used
- each
- length
- split
- join
- parse


# Link to live version
https://the-recruiter-capstone.herokuapp.com/
